//===-- ALFBackend.cpp - Library for converting LLVM code to ALF (Artist2 Language for Flow Analysis) --------------===//
//
//                     Benedikt Huber, <benedikt@vmars.tuwien.ac.at>
//                     Adapted from the C Backend (The LLVM Compiler Infrastructure)
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This library converts LLVM code to ALF code, to be fed into the Swedish
// Execution Time Tool (SWEET).
//
// Problems, in priority order:
//
// High Priority:
//
// TODO: Add support for .map files
//
// Medium Priority:
//
// TODO: Add command line help (-mattr=help)
//
// TODO: Support constant composite values and composite return types
//
// Low Priority
//
// TODO: Support for fmod, fmodf, fmodl
// TODO: Support for vector types
// TODO: Support more intrinsics (we currently lower ALL intrinsics except mem{cpy,set,move})
//
// TODO: Handle Linkage Declarations [1], we cannot handle weak and common linkage at the moment
// TODO: Handle inline assembler
//
// TODO: Handle global CTors/DTors
// TODO: Support type 'Type::X86_MMXTyID'
//
// Note on PHI Nodes:
//  The value of a PHI node depends on the predecessor: For each predecessor there
//  is exactly one value.
//  Therefore, we can set the PHI node variable in the predecessor, as last
//  store before the terminator instruction.
//  The set of stores for PHI node variables is distinct amongst the successor
//  nodes, so it is ok to perform all stores in parallel.
//===----------------------------------------------------------------------===//

#include "ALFOutput.h"
#include "ALFBuilder.h"
#include "ALFTranslator.h"

#include "ALFTargetMachine.h"
#include "llvm/IntrinsicInst.h"
#include "llvm/PassManager.h"
#include "llvm/Analysis/ConstantsScanner.h"
#include "llvm/Support/CallSite.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/MC/MCRegisterInfo.h"

// Allow expressions for select instructions
// Lowers the precision of the restriction mechanism of SWEET
#undef ENABLE_SELECT_EXPRESSIONS

#define ALF_DEBUG_HOT(x) (x)
#define ALF_DEBUG(x)

// ------------------------------------
// registering and command line options
// ------------------------------------

extern "C" void LLVMInitializeALFBackendTarget() {
  // Register the target
  RegisterTargetMachine<ALFTargetMachine> X(TheALFBackendTarget);
}

static cl::opt<std::string>
ALFMapFile("alf-map-file", cl::NotHidden,
            cl::desc("Emit a map file (linking ALF labels and C source code) using debug information"),
            cl::init(""));

static cl::opt<std::string>
ALFTargetData("alf-target-data", cl::NotHidden,
  cl::desc("Target data string for ALF code generation (alignment and pointer properties, default HOST)"),
  cl::init("!HOST!"));

static cl::opt<bool>
ALFIgnoreVolatiles("alf-ignore-volatiles", cl::NotHidden,
            cl::desc("Ignore volatile modifier for loads and stores (default=false)"),
            cl::init(false));

static cl::opt<std::string>
ALFIgnoreDefinitions("alf-ignore-definitions", cl::NotHidden,
            cl::desc("Comma-separated list of definitions which should be ignored during translation (e.g.'_start,printf')"),
            cl::init(""));

static cl::opt<std::string>
ALFMemoryAreas("alf-memory-areas", cl::NotHidden,
            cl::desc("Comma-separated list of memory ranges, accessed using absolute addresses (e.g.'0x0-0xe,0x30-0x40')"),
            cl::init(""));

static cl::opt<bool>
ALFStandalone("alf-standalone", cl::NotHidden,
              cl::desc("Define stubs for undefined functions and define common frames, instead of importing them."),
              cl::init(false));

/* utilities */

using namespace alf;

namespace {

  /// class representing information on ALF assembler (empty
  class ALFMCAsmInfo : public MCAsmInfo {
  public:
    ALFMCAsmInfo() {
      GlobalPrefix = "";
      PrivateGlobalPrefix = "";
    }
  };
  /// XXX: refactor
  static SpecialGlobalClass getGlobalVariableClass(const GlobalVariable *GV) {
    // If this is a global ctors/dtors list, handle it now.
    if (GV->hasAppendingLinkage() && GV->use_empty()) {
      if (GV->getName() == "llvm.global_ctors")
        return GlobalCtors;
      else if (GV->getName() == "llvm.global_dtors")
        return GlobalDtors;
    }

    // Otherwise, if it is other metadata, don't print it.  This catches things
    // like debug information.
    if (GV->getSection() == "llvm.metadata")
      return OtherMetadata;

    return NotSpecial;
  }

  /// XXX: refactor
  static void FindStaticTors(GlobalVariable *GV, std::set<Function*> &StaticTors){
    ConstantArray *InitList = dyn_cast<ConstantArray>(GV->getInitializer());
    if (!InitList) return;

    for (unsigned i = 0, e = InitList->getNumOperands(); i != e; ++i)
      if (ConstantStruct *CS = dyn_cast<ConstantStruct>(InitList->getOperand(i))){
        if (CS->getNumOperands() != 2) return;  // Not array of 2-element structs.

        if (CS->getOperand(1)->isNullValue())
          return;  // Found a null terminator, exit printing.
        Constant *FP = CS->getOperand(1);
        if (ConstantExpr *CE = dyn_cast<ConstantExpr>(FP))
          if (CE->isCast())
            FP = CE->getOperand(0);
        if (Function *F = dyn_cast<Function>(FP))
          StaticTors.insert(F);
      }
  }

  /// ALFBackend - This class is the main chunk of code that converts an LLVM
  /// module to an ALF translation unit.
  /// Adapted from the C Backend
  class ALFBackend : public FunctionPass {

    /// Least Addressable Unit (8 bit is probably ok)
    const unsigned LeastAddrUnit;

    // Target Machine information
    const TargetData* TD;
    MCContext *TCtx;
    const MCAsmInfo* TAsm;
    const MCRegisterInfo *MRI;
    IntrinsicLowering *IL;
    Mangler *Mang;

    /// Ignored Definitions
    std::set<std::string> IgnoredDefinitions;

    /// ALFOutput for directly emmiting ALF code (should not be used anymore)
    ALFOutput Output;

    /// ALFBuilder for generating ALF code via a high level interface
    ALFBuilder Builder;

    /// ALFTranslator translating LLVM to ALF code
    ALFTranslator Translator;

    /// translated module
    const Module *TheModule;

    /// Loop Info
    LoopInfo *LI;

	/* unique name generation and counters */
    unsigned FunctionCounter; // count the number of already generated functions to disambiguate labels
    DenseMap<const Value*, unsigned> AnonValueNumbers;
    unsigned NextAnonValueNumber;

  public:
    static char ID;

    explicit ALFBackend(formatted_raw_ostream &ostream)
      : FunctionPass(ID),
        LeastAddrUnit(8), /* FIXME: Currently, the translator only works with LAU=8, but LLVM has 1-bit values */
        TD(0),  TCtx(0),TAsm(0), IL(0), Mang(0),
        Output(ostream, LeastAddrUnit),
        Builder(Output),
        Translator(Builder, LeastAddrUnit, ALFIgnoreVolatiles),
        TheModule(0),  LI(0),
        FunctionCounter(0), NextAnonValueNumber(0) {
      initializeLoopInfoPass(*PassRegistry::getPassRegistry());
    }

    virtual const char *getPassName() const { return "ALF backend"; }

    void getAnalysisUsage(AnalysisUsage &AU) const {
      AU.addRequired<LoopInfo>();
      AU.setPreservesAll();
    }

    virtual bool doInitialization(Module &M);

    void processFunctionImports(Module &M);

    void processGlobalVariables(Module &M);

    void addBuiltinFunctions(Module &M);

    bool runOnFunction(Function &F);

    virtual bool doFinalization(Module &M);

  private :

    void addMemoryAreas(std::string& AreaSpec, bool IsVolatile);
    void addIgnoredDefinitions(std::string& List);
    void lowerIntrinsics(Function &F);

    /// return true if the function/object should be ignored
    bool isIgnoredDefinition(const StringRef FunctionName) {
      return IgnoredDefinitions.count(FunctionName) > 0;
    }

    /// return true if the function should be treated as declaration (no function body)
    bool isDeclaration(const Function &F) {
      if(isIgnoredDefinition(F.getName())) return true;
      if(F.isIntrinsic()) return false;
      if(F.isDeclaration()) return true;
      return false;
    }

    // Functions and Basic Blocks
    void visitFunction(Function &);
    void visitBasicBlock(BasicBlock *BB);

  };
}

char ALFBackend::ID = 0;

// ALFBackend: Global Stuff
bool ALFBackend::doInitialization(Module &M) {
  FunctionPass::doInitialization(M);

  // Initialize
  TheModule = &M;
  if(ALFTargetData == "!HOST!") {
	  TD = new TargetData(&M);
  } else {
	  TD = new TargetData(ALFTargetData);
  }
  IL = new IntrinsicLowering(*TD);
  TAsm = new ALFMCAsmInfo();
  MRI  = new MCRegisterInfo();
  TCtx = new MCContext(*TAsm, *MRI, NULL);
  Mang = new Mangler(*TCtx, *TD);

  Translator.initializeTarget(TAsm, TD, MRI);

  // Ignored Definitions
  addIgnoredDefinitions(ALFIgnoreDefinitions);

  // Lower unsupported intrinsic calls
  for (Module::iterator I = M.begin(), E = M.end(); I!=E; ++I) {
      lowerIntrinsics(*I);
  }

  // Absolute memory
  addMemoryAreas(ALFMemoryAreas, false);

  // Set Bit Width
  Builder.setBitWidths(TD->getPointerSizeInBits(), TD->getPointerSizeInBits(), TD->getPointerSizeInBits());

  /// Emit global warnings, if any

  // Keep track of which functions are static ctors/dtors so they can have
  // an attribute added to their prototypes.
  // TODO: Not quite clear how to model this in ALF
  std::set<Function*> StaticCtors, StaticDtors;
  for (Module::global_iterator I = M.global_begin(), E = M.global_end();
       I != E; ++I) {
    switch (getGlobalVariableClass(I)) {
    case GlobalCtors:
      FindStaticTors(I, StaticCtors);
      break;
    case GlobalDtors:
      FindStaticTors(I, StaticDtors);
      break;
    default: break;
    }
  }

  // Set properties
  Builder.setLittleEndian(TD->isLittleEndian());

  // TODO: Handle inline assembler
  // see C backend /!M.getModuleInlineAsm().empty()/

  processFunctionImports(M);

  processGlobalVariables(M);

  addBuiltinFunctions(M);

  return false;
}

// Function Imports
// If function is not defined and not an intrinsic, we either need to import it or generate a stub
// TODO: Process Linkage Information [1]
// TODO: Handle LLVM_ASM (name starts with 1)
void ALFBackend::processFunctionImports(Module &M) {
  for (Module::iterator I = M.begin(), E = M.end(); I != E; ++I) {
    if(isDeclaration(*I)) {
      if(!ALFStandalone) {
        std::string Label = Translator.getValueName(I);
        Builder.importLabel(Label);
      } // otherwise: add stub
    }
  }
}

// Global variables (import or definition/export)
// TODO: We should consider special linkage information, such as:
//   ==> thread Local, hidden visibility, link once, weak, external weak, common linkage
// TODO: const == read-only? (currently ignored)
void ALFBackend::processGlobalVariables(Module &M) {

    // Global Variables Imports / Definitions
    if (!M.global_empty()) {
      for (Module::global_iterator I = M.global_begin(), E = M.global_end();
           I != E; ++I) {
          // Ignore debug info
          if (I->getSection() == "llvm.metadata")
            continue;
          // add frame
          bool IsImported = I->isDeclaration();
          bool IsExported = ! I->hasLocalLinkage();
          FrameStorage Storage = IsImported ? ImportedFrame : (IsExported ? ExportedFrame : InternalFrame);
          unsigned SizeInBits = Translator.getBitWidth(I->getType()->getElementType());
          Builder.addFrame(Translator.getValueName(I), SizeInBits, Storage);
          // All global variables (which are not special purpose) need to be initialized
          // The initializer, however, is allowed to be NULL
          if(! IsImported && !getGlobalVariableClass(I)) {
              Translator.addInitializers(M, *I, 0, I->getInitializer());
          }
      }
    }

    FrameStorage SpecialStorage = ALFStandalone ? InternalFrame : ImportedFrame;

    // Define/Import Null-Pointer variables
    Builder.addFrame(ALFTranslator::NULL_REF, TD->getPointerSizeInBits(), SpecialStorage);

    // Define absolute Memory
    if(Translator.mem_areas_begin() == Translator.mem_areas_end()) {
        Builder.addInfiniteFrame(ALFTranslator::ABS_REF, SpecialStorage);
    } else {
        for(ALFTranslator::mem_areas_iterator I = Translator.mem_areas_begin(), E = Translator.mem_areas_end();
                I!=E; ++I) {
            Builder.addFrame(I->getName(), I->sizeInBits(), SpecialStorage);
        }
    }

}


// Emit implementations for undefined functions (which are only declared but not defined),
// returning TOP (in ALFStandalone mode)
void ALFBackend::addBuiltinFunctions(Module &M) {
    if(ALFStandalone) {
        for (Module::iterator F = M.begin(), E = M.end(); F != E; ++F) {
            // If the function has no definition, we either need to import it or generate a stub
            // TODO Linkage / LLVM_ASM (name starts with 1)
          if(! isDeclaration(*F)) continue;
          ALFFunction *AF = Builder.addFunction(F->getName(), Translator.getValueName(F),
                                                "STUB for undefined function " + F->getName());
          Translator.processFunctionSignature(F, AF);
          Type *RTy = F->getReturnType();
          ALFStatementGroup* Block = AF->addBasicBlock(F->getName() + "::entry", "Generated Basic Block (return undef)");
          if(! RTy->isVoidTy()) {
            SExpr *Z = Builder.load(Translator.getBitWidth(RTy), Builder.address(Translator.getVolatileStorage(RTy)));
            Block->addStatement(F->getName() + "::entry::0", "return undef", Builder.ret(Z));
          } else {
            if(! isIgnoredDefinition(F->getName())) {
              alf_warning("Emitting no-op stub for function '" + Twine(F->getName()) + "' returning void");
            }
            Block->addStatement(F->getName() + "::entry::0", "return", Builder.ret());
          }
        }
    }
}

bool ALFBackend::runOnFunction(Function &F) {
  // Do not codegen any 'available_externally' functions at all, they have
  // definitions outside the translation unit. Also skip declarations.
  if (F.hasAvailableExternallyLinkage() || isDeclaration(F))
    return false;

  LI = &getAnalysis<LoopInfo>();

  // Get rid of intrinsics we can't handle
  lowerIntrinsics(F);

  visitFunction(F);
  FunctionCounter++;
  return false;
}

/// Generate ALF code for function
/// TODO: isStructReturn - Should this function actually return a struct by-value?
///        In ALF, we probably flatten this into multiple return values
void ALFBackend::visitFunction(Function &F) {
  ALFFunction *AF = Builder.addFunction(F.getName(), Translator.getValueName(&F), "Definition of function " + F.getName());
  AF->setExported(! F.hasLocalLinkage());
  Translator.translateFunction(&F, AF);
}

bool ALFBackend::doFinalization(Module &M) {

    // Translator finalization
    Translator.addVolatileFrames();

    // Write
    Builder.writeToFile(Output);

    //
    if(ALFMapFile.size() != 0) {
        Builder.writeMapFile(ALFMapFile);
    }
    // Free memory...
    delete IL;
    delete TD;
    delete Mang;
    delete TCtx;
    delete TAsm;
    return false;
}


void ALFBackend::addMemoryAreas(std::string& AreaSpec, bool IsVolatile)
{
    if(AreaSpec.empty()) {
        return;
    }
    SmallVector<StringRef,8> MemoryAreaList;
    StringRef(AreaSpec).split(MemoryAreaList, StringRef(","));
    for(SmallVector<StringRef,8>::iterator I = MemoryAreaList.begin(), E = MemoryAreaList.end(); I!=E; ++I) {
      std::pair<StringRef,StringRef> StartEnd = I->split("-");
      unsigned long long Start, End;
      if(StartEnd.first.getAsInteger(0,Start) || StartEnd.second.getAsInteger(0,End)) {
        report_fatal_error("Bad area specification '"+AreaSpec+"':  Range " +
                           StartEnd.first + " to " + StartEnd.second +
                           " is not a pair of valid addresses.");
      }
      Translator.addMemoryArea((uint64_t)Start, (uint64_t)End, IsVolatile);
    }
}

void ALFBackend::addIgnoredDefinitions(std::string& List)
{
  SmallVector<StringRef,8> IgnDefList;
  StringRef(List).split(IgnDefList, StringRef(","));
  for(SmallVector<StringRef,8>::iterator I = IgnDefList.begin(), E = IgnDefList.end(); I!=E; ++I) {
    IgnoredDefinitions.insert(I->str());
  }
}

//===----------------------------------------------------------------------===//
//                        Preprocessing
//===----------------------------------------------------------------------===//


// TODO: we currently lower ALL intrinsics except mem{cpy,set,move}
void ALFBackend::lowerIntrinsics(Function &F) {
  // This is used to keep track of intrinsics that get generated to a lowered
  // function. We must generate the prototypes before the function body which
  // will only be expanded on first use (by the loop below).
  std::vector<Function*> prototypesToGen;

  // Examine all the instructions in this function to find the intrinsics that
  // need to be lowered.
  for (Function::iterator BB = F.begin(), EE = F.end(); BB != EE; ++BB) {
	  for (BasicBlock::iterator I = BB->begin(), E = BB->end(); I != E; ) {
		  if (CallInst *CI = dyn_cast<CallInst>(I++)) {
			  if (Function *F = CI->getCalledFunction()) {

				  bool needsLowering = true;

				  switch (F->getIntrinsicID()) {
				  case Intrinsic::not_intrinsic:
					  needsLowering = false;
					  break;
                  case Intrinsic::dbg_declare:
                  case Intrinsic::dbg_value:
                      needsLowering = false;
                      break;
				  case Intrinsic::memcpy:
				  case Intrinsic::memset:
			      case Intrinsic::memmove:
			    	  // In all three cases, the third operand is 'len'
			    	  if(isa<ConstantInt>(CI->getArgOperand(2))) {
			    		  needsLowering = false;
			    	  }
			    	  break;
				  // Intrinsics handled directly in the C Backend:
					  //          case Intrinsic::memory_barrier:
					  //          case Intrinsic::vastart:
					  //          case Intrinsic::vacopy:
					  //          case Intrinsic::vaend:
					  //          case Intrinsic::returnaddress:
					  //          case Intrinsic::frameaddress:
					  //          case Intrinsic::setjmp:
					  //          case Intrinsic::longjmp:
					  //          case Intrinsic::prefetch:
					  //          case Intrinsic::powi:
					  //          case Intrinsic::x86_sse_cmp_ss:
					  //          case Intrinsic::x86_sse_cmp_ps:
					  //          case Intrinsic::x86_sse2_cmp_sd:
					  //          case Intrinsic::x86_sse2_cmp_pd:
					  //          case Intrinsic::ppc_altivec_lvsl:
				  }

				  if(needsLowering) {
					  IL->LowerIntrinsicCall(CI);
				  }

			  }
		  }
	  }
  }
}


//===----------------------------------------------------------------------===//
//                       External Interface declaration
//===----------------------------------------------------------------------===//

// TODO should we run GCLowering / LowerInvoke passes?
bool ALFTargetMachine::addPassesToEmitFile(PassManagerBase &PM,
                                         formatted_raw_ostream &o,
                                         CodeGenFileType FileType,
                                         bool DisableVerify) {
  if (FileType != TargetMachine::CGFT_AssemblyFile) return true;

  // Do not simplify CFG by default, as it is difficult to predict the translation this way
  // PM.add(createCFGSimplificationPass());   // clean up after lower invoke.

  // add ALFBackend pass
  PM.add(new ALFBackend(o));
  return false;
}


