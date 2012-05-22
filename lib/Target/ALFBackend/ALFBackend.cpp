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
// TODO: Support flags (like nsw) for arithmetic operations
//
// TODO: Support for fmod, fmodf, fmodl
//
// TODO: Add command line help (-mattr=help)
//
// TODO: Support for vector types
//
// TODO: Support {extract,insert}value
//
// TODO: Support more intrinsics
//
// TODO: Support struct return and byval parameters
//
// FIXME: We cannot handle weak and common linkage
//
// TODO: Support the new type 'Type::X86_MMXTyID'
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
#include "ALFWriter.h"

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
ALFTargetData("alf-target-data", cl::NotHidden,
  cl::desc("Target data string for ALF code generation (alignment and pointer properties, default HOST)"),
  cl::init("!HOST!"));

static cl::opt<bool>
ALFIgnoreVolatiles("alf-ignore-volatiles", cl::NotHidden,
            cl::desc("Ignore volatile modifier for loads and stores (default=false)"),
            cl::init(false));

static cl::opt<std::string>
ALFMemoryAreas("alf-memory-areas", cl::NotHidden,
            cl::desc("Comma-separated list of memory ranges, accessed using absolute addresses (e.g.'0x0-0xe,0x30-0x40')"),
            cl::init(""));

static cl::opt<bool>
ALFStandalone("alf-standalone", cl::NotHidden,
              cl::desc("Define stubs for undefined functions and define common frames, instead of importing them."),
              cl::init(false));

/* utilities */

enum SpecialGlobalClass {
  NotSpecial = 0,
  GlobalCtors, GlobalDtors, OtherMetadata
};

/// getGlobalVariableClass - If this is a global that is specially recognized
/// by LLVM, return a code that indicates how we should handle it.
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

/// FindStaticTors - Given a static ctor/dtor list, unpack its contents into
/// the StaticTors set.
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


namespace {

  /// class representing information on ALF assembler (empty
  class ALFMCAsmInfo : public MCAsmInfo {
  public:
    ALFMCAsmInfo() {
      GlobalPrefix = "";
      PrivateGlobalPrefix = "";
    }
  };


  /// ALFBackend - This class is the main chunk of code that converts an LLVM
  /// module to an ALF translation unit.
  /// Adapted from the C Backend
  class ALFBackend : public FunctionPass {

    // target configuration

    const unsigned LeastAddrUnit;      // Least Addressable Unit (8 bit is probably ok)
    const TargetData* TD;
    MCContext *TCtx;
    const MCAsmInfo* TAsm;
    const MCRegisterInfo *MRI;
    IntrinsicLowering *IL;
    Mangler *Mang;

	/// ALFOutput for directly emmiting ALF code (should not be used anymore)
	ALFOutput Output;

    /// ALFWriter producing ALF code
    ALFWriter Writer;

    /// translated module
    const Module *TheModule;

    /// Loop Info
    LoopInfo *LI;

    /* collections */
    std::set<const Type*> VolatileTypes;

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
        Writer(Output, LeastAddrUnit, ALFIgnoreVolatiles),
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

    bool runOnFunction(Function &F) {
     // Do not codegen any 'available_externally' functions at all, they have
     // definitions outside the translation unit.
     if (F.hasAvailableExternallyLinkage())
       return false;

      LI = &getAnalysis<LoopInfo>();

      // Get rid of intrinsics we can't handle
      lowerIntrinsics(F);

      visitFunction(F);
      FunctionCounter++;
      return false;
    }

    virtual bool doFinalization(Module &M);

  private :

    void addMemoryAreas(std::string& AreaSpec, bool IsVolatile);
    void lowerIntrinsics(Function &F);

    // Functions and Basic Blocks
    void visitFunction(Function &);
    void visitBasicBlock(BasicBlock *BB);

  };
}

char ALFBackend::ID = 0;

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

  Writer.initializeTarget(TAsm, TD, MRI);

  // Lower unsupported intrinsic calls
  for (Module::iterator I = M.begin(), E = M.end(); I!=E; ++I) {
      lowerIntrinsics(*I);
  }

  // Absolute memory
  addMemoryAreas(ALFMemoryAreas, false);

  // Set Bit Width
  Output.setBitWidths(TD->getPointerSizeInBits(), TD->getPointerSizeInBits(), TD->getPointerSizeInBits());

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

  // Volatile 'variables'
  std::map<std::string, unsigned> VolatileStorage;

  Output.startList("alf");

  // First output all the declarations for the program, because C requires
  // Functions & globals to be declared before they are used.
  //

  // TODO: Handle inline assembler
  // see C backend /!M.getModuleInlineAsm().empty()/

  // Loop over the symbol table, emitting all named constants (Not supported/needed in ALF)

  Output.startList("macro_defs");
  // Output.macroDefs();
  Output.endList("macro_defs");

  Output.lauDef();
  Output.atom(TD->isLittleEndian() ? "little_endian" : "big_endian");

  Output.startList("exports");

  // Global variable exports
  Output.startList("frefs");

  if (!M.global_empty()) {
    for (Module::global_iterator I = M.global_begin(), E = M.global_end();
         I != E; ++I)
      if (!I->isDeclaration()) {
        // Ignore special globals, such as debug info.
        if (I->getSection() == "llvm.metadata") // getGlobalVariableClass(I))
          continue;

        // Thread Local Storage (TODO?)
        if (I->isThreadLocal())
            errs() << "Warning: ALF backend does not support thread-local storage\n";
        if (I->hasHiddenVisibility())
            errs()  << "Warning: Ignoring hidden visibility\n";

        if (I->hasLocalLinkage())
          continue;

        // if (I->isThreadLocal())
        Output.fref(Writer.getValueName(I));

        if (I->hasLinkOnceLinkage()) // (TODO)
          errs()  << "Warning: Ignoring LinkOnceLinkage\n";
        if (I->hasCommonLinkage())    // FIXME is this right?
          /* errs()  << "Warning: Ignoring CommonLinkage\n" */ ;
        else if (I->hasWeakLinkage())
            errs()  << "Warning: Ignoring WeakLinkage\n";
        else if (I->hasExternalWeakLinkage())
            errs()  << "Warning: Ignoring ExternalWeakLinkage\n";
      }
  }
  Output.endList("frefs");

  Output.startList("lrefs");
  for (Module::iterator I = M.begin(), E = M.end(); I != E; ++I) {

    // TODO: Special Linkage
    // C Backend, s/StaticCtors.count(I)/

    if (!I->isDeclaration()) {
        if (I->hasName() && I->getName()[0] == 1)
            errs() << "cannot handle LLVM_ASM at the moment";
        Output.lref(Writer.getValueName(I));
    }

  }
  Output.endList("lrefs");
  Output.endList("exports");

  Output.startList("imports");
  Output.startList("frefs");

  // External Global variable declarations (frame refs)
  if (!M.global_empty()) {
    for (Module::global_iterator I = M.global_begin(), E = M.global_end();
         I != E; ++I) {
      if(I->isDeclaration()) {
          Output.fref(Writer.getValueName(I));
      }
      // TODO: Process Linkage (C Backend, s/else if (I->hasDLLImportLinkage())/)
    }
  }
  if(!ALFStandalone) {
      // Import Null-Pointer 'variable'
      Output.fref(ALFWriter::NULL_REF);
      // Import frames for memory areas addressed in an absolute way
      if(Writer.mem_areas_begin() == Writer.mem_areas_end()) {
          Output.fref(ALFWriter::ABS_REF);
      } else {
          for(ALFWriter::mem_areas_iterator I = Writer.mem_areas_begin(),E = Writer.mem_areas_end();
                  I!=E; ++I) {
              Output.fref(I->getName());
          }
      }
  }
  Output.endList("frefs");
  Output.startList("lrefs");

  for (Module::iterator I = M.begin(), E = M.end(); I != E; ++I) {
	  // If function is not defined and not an intrinsic, we either need to import it or generate a stub
	  // TODO Linkage, intrinsic function and LLVM_ASM (name starts with 1)
	  if(I->isDeclaration() && !I->isIntrinsic()) {
		  if(!ALFStandalone) {
			  // Print declaration for undefined function
			  Output.lref(Writer.getValueName(I));
		  } else {
			  // Add volatile storage for return values of undefined function stubs
			  Type *VTy = I->getReturnType();
			  VolatileTypes.insert(VTy);
			  VolatileStorage.insert(make_pair(Writer.getVolatileStorage(VTy), Writer.getBitWidth(VTy)));
		  }
	  }
  }
  Output.endList("lrefs");
  Output.endList("imports");

  Output.startList("decls");

  if(ALFStandalone) {
      // Define Null-Pointer 'variable'
      Output.alloc(ALFWriter::NULL_REF, TD->getPointerSizeInBits());
      // Define absolute Memory
      if(Writer.mem_areas_begin() == Writer.mem_areas_end()) {
          Output.startList("alloc");
          Output.atom(TD->getPointerSizeInBits());
          Output.identifier(ALFWriter::ABS_REF);
          Output.atom("inf");
          Output.endList("alloc");
      } else {
          for(ALFWriter::mem_areas_iterator I = Writer.mem_areas_begin(), E = Writer.mem_areas_end();
                  I!=E; ++I) {
              Output.alloc(I->getName(), I->sizeInBits());
          }
      }
  }

  // Collect volatile memory loads
  for(Module::iterator If = M.begin(), Ef = M.end(); If != Ef; ++If) {
	  for(Function::iterator Ib = *If->begin(), Eb = *If->end(); Ib != Eb; ++Ib) {
		  for(BasicBlock::iterator Ii = *Ib->begin(), Ei = *Ib->end(); Ii != Ei; ++Ii) {
			  // Inspect all volatile loads
			  if(const LoadInst* LIns = dyn_cast<LoadInst>(&*Ii)) {
				  if(LIns->isVolatile()) {
					  Type *VTy = LIns->getType();
					  VolatileTypes.insert(VTy);
					  VolatileStorage.insert(make_pair(Writer.getVolatileStorage(VTy), Writer.getBitWidth(VTy)));
				  }
			  }
		  }
	  }
  }

  for(std::map<std::string, unsigned>::iterator I = VolatileStorage.begin(), E= VolatileStorage.end(); I!=E; ++I) {
	  Output.alloc(I->first, I->second);
  }

  // Global variable declarations
  if (!M.global_empty()) {
    for (Module::global_iterator I = M.global_begin(), E = M.global_end();
         I != E; ++I)
      if (!I->isDeclaration()) {
        // Ignore special globals, such as debug info.
        if (getGlobalVariableClass(I))
          continue;

        unsigned size = Writer.getBitWidth(I->getType()->getElementType()); // in bits
        Output.alloc(Writer.getValueName(I), size);

        //  dbgs() << "Determining type: "; I->getType()->getElementType()->print(dbgs());
        //  dbgs() << " has size " << size << '\n';
      }
  }

  Output.endList("decls");

  Output.startList("inits");

  // Initialize volatile storage
  for(std::map<std::string, unsigned>::iterator I = VolatileStorage.begin(), E= VolatileStorage.end(); I!=E; ++I) {
	  Output.startList("init");
	  Output.ref(I->first, 0);
	  Output.startList("const_repeat",true);
	  /* Initialize with 0-values in chunks of size LAU */
	  if(I->second < LeastAddrUnit) {
	      Output.dec_unsigned(I->second, APInt(I->second,0,false));
	      Output.atom(utostr(1));
	  } else {
          Output.dec_unsigned(LeastAddrUnit, APInt(LeastAddrUnit,0,false));
          Output.atom(utostr(I->second / LeastAddrUnit));
	  }
	  Output.endList("const_repeat");
	  Output.atom("volatile");
	  Output.endList("init");
  }

  // Output the global variable definitions and contents
  if (!M.global_empty()) {
    for (Module::global_iterator I = M.global_begin(), E = M.global_end();
         I != E; ++I)
      if (!I->isDeclaration()) {
        // Ignore special globals, such as debug info.
        if (getGlobalVariableClass(I))
          continue;

        // const -> read_only

        // If the initializer is not null, emit the initializer.  If it is null,
        // we still need to initialize the memory to zero.
        // XXX: We do not support weak linkage (see C Backend, /} else if (I->hasWeakLinkage()) {/)
        Writer.emitInitializers(M, *I, 0, I->getInitializer());
     }
  }
  Output.endList("inits");

  Output.startList("funcs");

  // Emit implementations for undefined functions (which are only declared but not defined),
  // returning TOP
  if(ALFStandalone) {
	  for (Module::iterator F = M.begin(), E = M.end(); F != E; ++F) {
		  // If function is not defined and not an intrinsic, we either need to import it or generate a stub
		  // TODO Linkage / LLVM_ASM (name starts with 1)
		  if(! F->isDeclaration() || F->isIntrinsic()) continue;
		  Output.newline();
		  Output.comment("-------------------- STUB FOR UNDEFINED FUNCTION " + F->getName().str() + " --------------------");
		  Output.startList("func");
		  Writer.emitFunctionSignature(F);
		  Output.startList("scope");
		  Output.startList("decls"); Output.endList("decls");
		  Output.startList("inits"); Output.endList("inits");
		  Output.startList("stmts");
		  Output.setStmtLabel(F->getName().str() + "::stub");
		  Output.startStmt("return");
		  Type *RTy = F->getReturnType();
		  Output.load(Writer.getBitWidth(RTy),Writer.getVolatileStorage(RTy),0);
		  Output.endStmt("return");
		  Output.endList("stmts");
		  Output.endList("scope");
		  Output.endList("func");
	  }
  }

  // C backend: s/Emit some helper functions for dealing with FCMP instruction's predicates/
  return false;
}

bool ALFBackend::doFinalization(Module &M) {
  Output.endList("funcs");
  Output.endList("alf");
  // Free memory...
  delete IL;
  delete TD;
  delete Mang;
  delete TCtx;
  delete TAsm;
  return false;
}

void ALFBackend::visitFunction(Function &F) {
  /// isStructReturn - Should this function actually return a struct by-value?
  /// In ALF, we probably flatten this into multiple return values
  bool isStructReturn = F.hasStructRetAttr();

  Output.newline();
  Output.comment("-------------------- FUNCTION " + F.getName().str() + " --------------------");
  Output.startList("func");

  Writer.emitFunctionSignature(&F);

  // start function scope
  Output.startList("scope"); // DECLS INITS STMTS

  // declare local variables
  Output.startList("decls");

  for (inst_iterator I = inst_begin(&F), E = inst_end(&F); I != E; ++I) {

    // We need local variables for:
	//  - PHI nodes
	//  - non-inlineable instructions
	//  - The condition of branch and switch statements
	//  - Alloca memory with fixed size
    // We do not need to initialize variables here
    //
	Value* NeedsStore = 0;
	string Reason;
    if(isa<PHINode>(*I)) {
      NeedsStore = &*I;
      Reason     = "Local Variable (PHI node)";
    } else if (I->getType() != Type::getVoidTy(F.getContext()) &&
               !Writer.isInlinableInst(*I)) {
      NeedsStore = &*I;
      Reason     = "Local Variable (Non-Inlinable Instruction)";
    }
    if(NeedsStore) {
    	Output.alloc(Writer.getValueName(NeedsStore), Writer.getBitWidth(NeedsStore->getType()));
    	Output.comment(Reason);
    }
    if (const AllocaInst *AI = isStaticSizeAlloca(&*I)) {
    	const ConstantInt* ArraySize = cast<ConstantInt>(AI->getArraySize());
    	Type* ElTy = AI->getType()->getElementType();
    	Output.alloc(Writer.getValueName(AI), Writer.getBitWidth(ElTy) * ArraySize->getLimitedValue());
    	Reason = "alloca'd memory";
    	Output.comment(Reason);
    }
    // C Backend: uses extra temporary for bitcasts.
    // Currently we cannot support all bitcasts, as we do not know the details of the
    // architecture/ABI (i.e., alignment of composite type members)
  }

  Output.endList("decls");
  Output.startList("inits");
  Output.endList("inits");
  // print the basic blocks
  Output.startList("stmts");
  for (Function::iterator BB = F.begin(), E = F.end(); BB != E; ++BB) {
    visitBasicBlock(BB);
  }
  Output.endList("stmts");
  Output.endList("scope");

  // C Backend: If this is a struct return function, handle the result with magic.
  // Applies to ALF as well
  if (isStructReturn) {
    errs() << "We cannot handle struct returns yet\n";
    // const Type *StructTy =
    //   cast<PointerType>(F.arg_begin()->getType())->getElementType();
    // printType(Out, StructTy, false, "StructReturn");
    // Out << ";  /* Struct return temporary */\n";
    // printType(Out, F.arg_begin()->getType(), false,
    //           Writer.getValueName(F.arg_begin()));
    // Out << " = &StructReturn;\n";
  }
  Output.endList("func");
}

void ALFBackend::visitBasicBlock(BasicBlock *BB) {

  /// Print Label
  Writer.basicBlockHeader(BB);
  unsigned Ix = 0;
  // Output all of the instructions in the basic block...
  for (BasicBlock::iterator II = BB->begin(), E = BB->end(); II != E;
       ++Ix, ++II) {
    // Do not emit code for PHI nodes / debug instructions
    if (isa<PHINode>(*II) || isa<DbgInfoIntrinsic>(*II)) {
        continue;
    }

    // code for inlinable instructions is emitted at the use site
    if (Writer.isInlinableInst(*II)) {
        continue;
    }

    Writer.statementHeader(*II, Ix);
    if(Writer.isExpressionInst(*II)) {
        Writer.emitTemporaryStore(II);
    } else {
        Writer.visit(*II);
    }

  }

  Output.decrementIndent();
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
		  Writer.addMemoryArea((uint64_t)Start, (uint64_t)End, IsVolatile);
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

bool ALFTargetMachine::addPassesToEmitFile(PassManagerBase &PM,
                                         formatted_raw_ostream &o,
                                         CodeGenFileType FileType,
                                         bool DisableVerify) {
  if (FileType != TargetMachine::CGFT_AssemblyFile) return true;

  // TODO: taken from the C backend. We should not support GC/unwind, and simply emit
  // an error if it is used
  // PM.add(createGCLoweringPass());
  // PM.add(createLowerInvokePass());

  // Do not simplify CFG by default, as it is difficult to predict the translation this way
  // PM.add(createCFGSimplificationPass());   // clean up after lower invoke.

  // add ALFBackend pass
  PM.add(new ALFBackend(o));
  // PM.add(createGCInfoDeleter());
  return false;
}
