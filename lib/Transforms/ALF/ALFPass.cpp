//===- ALF.cpp - Pass to export bitcode to ALF ---------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This library converts LLVM code to ALF code, to be fed into the Swedish
// Execution Time Tool (SWEET).
//
// Medium Priority Tasks:
//
// TODO: Support constant composite values and composite return types
// FIXME: We rely on LAU=8 (implicit pointer to integer casts), but strictly speaking,
//        LLVM might require LAU=1 (one bit arrays). We still need to find a clean
//        solution for this problem.
//
// Low Priority Tasks:
//
// TODO: Handle Linkage Declarations [1], we cannot handle weak and common linkage at the moment
// TODO: Handle global CTors/DTors [2]
// TODO: Handle inline assembler [3]
// TODO: Support more intrinsics (we currently lower ALL intrinsics except mem{cpy,set,move}) [4]
// TODO: Const attribute is ignored in the translation, could be translated to read-only frames [5]
// TODO: Support for fmod, fmodf, fmodl
// TODO: Support for vector types
// TODO: Support type 'Type::X86_MMXTyID'
//
// Note on PHI Nodes:
//  The value of a PHI node depends on the predecessor: For each predecessor there
//  is exactly one value.
//  Therefore, we can set the PHI node variable in the predecessor, as last
//  store before the terminator instruction.
//  The set of stores for PHI node variables is distinct amongst the successor
//  nodes, so it is ok to perform all stores in parallel.
//
//===----------------------------------------------------------------------===//

#define ALF_PASS_NAME "alf-translator"
#define DEBUG_TYPE ALF_PASS_NAME

#include <set>

#include "llvm/Analysis/ConstantsScanner.h"
#include "llvm/DataLayout.h"
#include "llvm/Pass.h"
#include "llvm/Function.h"
#include "llvm/Intrinsics.h"
#include "llvm/PassManager.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/CallSite.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ToolOutputFile.h"
#include "llvm/CodeGen/IntrinsicLowering.h"
#include "llvm/MC/MCRegisterInfo.h"

#include "llvm/Transforms/ALF.h"
#include "ALFOutput.h"
#include "ALFBuilder.h"
#include "ALFTranslator.h"

using namespace llvm;

// If ENABLE_SELECT_EXPRESSIONS is set, select instructions are
// translated to expressions, not if-then-else subgraphs.
// Enabling select expressions decreases the precision of the
// restriction mechanism of SWEET, and is thus not recomended
// at the moment.
#undef ENABLE_SELECT_EXPRESSIONS

static cl::opt<std::string>
ALFFile("alf-file", cl::NotHidden,
        cl::desc("Output file for the LLVM to ALF translator"),
        cl::init(""));

static cl::opt<std::string>
ALFMapFile("alf-map-file", cl::NotHidden,
            cl::desc("Emit a map file (linking ALF labels and C source code) using debug information"),
            cl::init(""));

static cl::opt<std::string>
ALFTargetData("alf-target-data", cl::NotHidden,
              cl::desc("Specify target data string for ALF code generation (alignment and pointer properties)"));

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


namespace {

  struct ALFPass : public ModulePass {

    /// Least Addressable Unit (8 bit is probably ok)
    const unsigned LeastAddrUnit;

    // Target Machine information
    std::string DataLayoutDescription;
    const DataLayout* TD;
    const MCAsmInfo* TAsm;
    const MCRegisterInfo *MRI;
    IntrinsicLowering *IL;

    /// Ignored Definitions
    std::set<std::string> IgnoredDefinitions;

    /// Tool output (if any)
    tool_output_file *PassOutput;

    /// ALFOutput for directly emmiting ALF code (should not be used anymore)
    ALFOutput *Output;

    /// ALFBuilder for generating ALF code via a high level interface
    ALFBuilder *Builder;

    /// ALFTranslator translating LLVM to ALF code
    ALFTranslator *Translator;

    /// translated module
    const Module *TheModule;

    /// Loop Info
    LoopInfo *LI;

    /// unique name generation and counters
    unsigned FunctionCounter; // count the number of already generated functions to disambiguate labels
    DenseMap<const Value*, unsigned> AnonValueNumbers;
    unsigned NextAnonValueNumber;

  public:
    static char ID; // Pass identification, replacement for typeid

    explicit ALFPass()
      : ModulePass(ID),
        LeastAddrUnit(8), /* FIXME: Currently, the translator only works with LAU=8, but LLVM has 1-bit values */
        DataLayoutDescription(ALFTargetData),
        TD(0), TAsm(0), IL(0),
        PassOutput(0), Output(0),
        TheModule(0),  LI(0),
        FunctionCounter(0),
        NextAnonValueNumber(0) {
      //initializeLoopInfoPass(*PassRegistry::getPassRegistry());
      //initializeALFPassPass(*PassRegistry::getPassRegistry());
    }

    void initializeOutput(raw_ostream &os) {
      assert(! Output && "initializeOutput called, but Output != 0");
      Output = new ALFOutput(os, LeastAddrUnit);
    }

    void setDefaultDataLayout(std::string& Description) {
      if(DataLayoutDescription.empty())
        DataLayoutDescription = Description;
      // if not empty, overridden by command-line argument
    }

    virtual const char *getPassName() const { return "ALF backend"; }

    virtual void getAnalysisUsage(AnalysisUsage &AU) const {
      AU.addRequired<LoopInfo>();
      AU.setPreservesAll();
    }

    virtual bool runOnModule(Module &M);

    void processFunctionImports(Module &M);

    void processGlobalVariables(Module &M);

    void addBuiltinFunctions(Module &M);


  private :

    void addMemoryAreas(std::string& AreaSpec, bool IsVolatile);
    void addIgnoredDefinitions(std::string& List);
    void lowerIntrinsics(Function &F);

    /// return true if the function/object should be ignored
    bool isIgnoredDefinition(const StringRef FunctionName) {
      return IgnoredDefinitions.count(FunctionName) > 0;
    }

    /// return true if the object should be treated as declaration (imported object)
    bool isDeclaration(const GlobalVariable *V) {
      if(V->isDeclaration()) return true;
      if(isIgnoredDefinition(V->getName())) return true;
      return false;
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

    // Dealing with special global variables
    SpecialGlobalClass getGlobalVariableClass(const GlobalVariable *GV);
    void FindStaticTors(GlobalVariable *GV, std::set<Function*> &StaticTors);

  };
}

// ALFPass: Global Stuff
bool ALFPass::runOnModule(Module &M) {
  // Initialize Output, if necessary
  if(! Output) {
    std::string ErrorInfo;
    PassOutput = new tool_output_file(ALFFile.c_str(), ErrorInfo, 0);
    if (!ErrorInfo.empty()) {
      delete PassOutput;
      errs() << ALF_PASS_NAME ": Opening Export File failed: " << ALFFile << "\n";
      errs() << ALF_PASS_NAME "Reason: " << ErrorInfo;
      PassOutput = 0;
      initializeOutput(nulls());
    } else {
      initializeOutput(PassOutput->os());
    }
  }
  Builder = new ALFBuilder(*Output);
  Translator = new ALFTranslator(*Builder, LeastAddrUnit, ALFIgnoreVolatiles);

  // Initialize
  TheModule = &M;
  if(ALFTargetData.empty()) {
	  TD = new DataLayout(&M);
  } else {
	  TD = new DataLayout(ALFTargetData);
  }
  IL = new IntrinsicLowering(*TD);
  TAsm = new MCAsmInfo();
  MRI  = new MCRegisterInfo();

  Translator->initializeTarget(TAsm, TD, MRI);

  // Ignored Definitions
  addIgnoredDefinitions(ALFIgnoreDefinitions);

  // Lower unsupported intrinsic calls
  for (Module::iterator I = M.begin(), E = M.end(); I!=E; ++I) {
      lowerIntrinsics(*I);
  }

  // Absolute memory
  addMemoryAreas(ALFMemoryAreas, false);

  // Set Bit Width
  Builder->setBitWidths(TD->getPointerSizeInBits(), TD->getPointerSizeInBits(), TD->getPointerSizeInBits());

  // Keep track of which functions are static ctors/dtors so they can have
  // an attribute added to their prototypes.
  // TODO: Not quite clear how to model this in ALF [2]
  std::set<Function*> StaticCtors, StaticDtors;
  for (Module::global_iterator I = M.global_begin(), E = M.global_end();
       I != E; ++I) {
    switch (getGlobalVariableClass(I)) {
    case GlobalCtors:
      //FindStaticTors(I, StaticCtors);
      break;
    case GlobalDtors:
      //FindStaticTors(I, StaticDtors);
      break;
    default: break;
    }
  }

  // Set properties
  Builder->setLittleEndian(TD->isLittleEndian());

  // TODO: Handle inline assembler [3]
  // see C backend /!M.getModuleInlineAsm().empty()/

  processFunctionImports(M);

  processGlobalVariables(M);

  addBuiltinFunctions(M);

  for(Module::iterator I = M.begin(), E = M.end(); I!=E; I++) {
    // Do not codegen any 'available_externally' functions at all, they have
    // definitions outside the translation unit. Also skip intrinsics and
    // functions that are declaration or should be treated as declarations in ALF
    if (I->hasAvailableExternallyLinkage() || I->isIntrinsic() ||  isDeclaration(*I))
      continue;
    LI = &getAnalysis<LoopInfo>(*I);

    // Get rid of intrinsics we can't handle
    lowerIntrinsics(*I);

    visitFunction(*I);
    FunctionCounter++;
  }

  // Translator finalization
  Translator->addVolatileFrames();

  // Write
  Builder->writeToFile(*Output);

  //
  if(ALFMapFile.size() != 0) {
    Builder->writeMapFile(ALFMapFile);
  }
  // Keep output file if no error occured
  if(PassOutput) {
    PassOutput->keep();
    delete PassOutput;
  }

  // Free memory...
  delete Translator;
  delete Builder;
  delete Output;
  delete IL;
  delete TD;
  delete TAsm;
  return false;
}

// Function Imports
// If function is not defined and not an intrinsic, we either need to import it or generate a stub
// TODO: Process Linkage Information [1]
// TODO: Handle LLVM_ASM (name starts with 1)
void ALFPass::processFunctionImports(Module &M) {
  for (Module::iterator I = M.begin(), E = M.end(); I != E; ++I) {
    if(isDeclaration(*I)) {
      if(! ALFStandalone) {
        std::string Label = Translator->getValueName(I);
        Builder->importLabel(Label);
      } // otherwise: add stub later
    }
  }
}

// Global variables (import or definition/export)
// TODO: We should consider special linkage information, such as:
//   ==> thread Local, hidden visibility, link once, weak, external weak, common linkage [1]
// TODO: const == read-only? (currently ignored) [5]
void ALFPass::processGlobalVariables(Module &M) {

    // Global Variables Imports / Definitions
    if (!M.global_empty()) {
      for (Module::global_iterator I = M.global_begin(), E = M.global_end();
           I != E; ++I) {
          // Ignore debug info
          if (I->getSection() == "llvm.metadata")
            continue;
          // add frame
          bool IsImported = isDeclaration(I);
          bool IsExported = ! IsImported && ! I->hasLocalLinkage();
          FrameStorage Storage = IsImported ? ImportedFrame : (IsExported ? ExportedFrame : InternalFrame);
	  if (ALFStandalone)
	    Storage = InternalFrame; // in standalone mode, we have uninitialized globals
          unsigned SizeInBits = Translator->getBitWidth(I->getType()->getElementType());
          Builder->addFrame(Translator->getValueName(I), SizeInBits, Storage);
          // All global variables (which are not special purpose) need to be initialized
          // The initializer, however, is allowed to be NULL
          if(! IsImported && !getGlobalVariableClass(I)) {
              Translator->addInitializers(M, *I, 0, I->getInitializer());
          }
      }
    }

    FrameStorage SpecialStorage = ALFStandalone ? InternalFrame : ImportedFrame;

    // Define/Import Null-Pointer variables
    Builder->addFrame(ALFTranslator::NULL_REF, TD->getPointerSizeInBits(), SpecialStorage);

    // Define absolute Memory
    if(Translator->mem_areas_begin() == Translator->mem_areas_end()) {
        Builder->addInfiniteFrame(ALFTranslator::ABS_REF, SpecialStorage);
    } else {
        for(ALFTranslator::mem_areas_iterator I = Translator->mem_areas_begin(), E = Translator->mem_areas_end();
                I!=E; ++I) {
            Builder->addFrame(I->getName(), I->sizeInBits(), SpecialStorage);
        }
    }

}


// Emit implementations for undefined functions (which are only declared but not defined),
// returning TOP (in ALFStandalone mode)
void ALFPass::addBuiltinFunctions(Module &M) {
    if(ALFStandalone) {
        for (Module::iterator F = M.begin(), E = M.end(); F != E; ++F) {
            // If the function has no definition, we either need to import it or generate a stub
            // TODO Linkage / LLVM_ASM (name starts with 1)
          if(! isDeclaration(*F)) continue;
          ALFFunction *AF = Builder->addFunction(F->getName(), Translator->getValueName(F),
                                                "STUB for undefined function " + F->getName());
          Translator->processFunctionSignature(F, AF);
          Type *RTy = F->getReturnType();
          ALFStatementGroup* Block = AF->addBasicBlock(F->getName() + "::entry", "Generated Basic Block (return undef)");
          if(! RTy->isVoidTy()) {
            SExpr *Z = Builder->load(Translator->getBitWidth(RTy), Builder->address(Translator->getVolatileStorage(RTy)));
            Block->addStatement(F->getName() + "::entry::0", "return undef", Builder->ret(Z));
          } else {
            if(! isIgnoredDefinition(F->getName())) {
              alf_warning("Emitting no-op stub for function '" + Twine(F->getName()) + "' returning void");
            }
            Block->addStatement(F->getName() + "::entry::0", "return", Builder->ret());
          }
        }
    }
}


/// Generate ALF code for function
void ALFPass::visitFunction(Function &F) {
  ALFFunction *AF = Builder->addFunction(F.getName(), Translator->getValueName(&F), "Definition of function " + F.getName());
  AF->setExported(! F.hasLocalLinkage());
  Translator->translateFunction(&F, AF);
}


void ALFPass::addMemoryAreas(std::string& AreaSpec, bool IsVolatile)
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
      Translator->addMemoryArea((uint64_t)Start, (uint64_t)End, IsVolatile);
    }
}

void ALFPass::addIgnoredDefinitions(std::string& List)
{
  SmallVector<StringRef,8> IgnDefList;
  StringRef(List).split(IgnDefList, StringRef(","));
  for(SmallVector<StringRef,8>::iterator I = IgnDefList.begin(), E = IgnDefList.end(); I!=E; ++I) {
    IgnoredDefinitions.insert(I->str());
  }
}

SpecialGlobalClass ALFPass::getGlobalVariableClass(const GlobalVariable *GV) {
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

void ALFPass::FindStaticTors(GlobalVariable *GV, std::set<Function*> &StaticTors) {
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

//===----------------------------------------------------------------------===//
//                        Preprocessing
//===----------------------------------------------------------------------===//


// TODO: we currently lower ALL intrinsics except mem{cpy,set,move}
void ALFPass::lowerIntrinsics(Function &F) {
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

char ALFPass::ID = 0;
static const char alf_pass_name[] = "ALF Translator Pass";
//INITIALIZE_PASS_BEGIN(ALFPass, ALF_PASS_NAME, alf_pass_name, false, false)
//INITIALIZE_AG_DEPENDENCY(AliasAnalysis)
//INITIALIZE_PASS_DEPENDENCY(LoopInfo)
//INITIALIZE_PASS_DEPENDENCY(ScalarEvolution)
//INITIALIZE_PASS_END(ALFPass, ALF_PASS_NAME, alf_pass_name, false, false)
static RegisterPass<ALFPass> ALFPassRegistration("print-alf", "Translate bitcode to ALF");

ModulePass *llvm::createALFPass()
{
  return new ALFPass();
}

ModulePass *llvm::createALFPassWithStream(formatted_raw_ostream &ostream, std::string& DataLayoutDescription)
{
  ALFPass *ALF = new ALFPass();
  ALF->initializeOutput(ostream);
  ALF->setDefaultDataLayout(DataLayoutDescription);
  return ALF;
}
