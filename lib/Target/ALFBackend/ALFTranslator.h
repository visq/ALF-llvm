//===-- ALFTranslator.h - Library for converting LLVM code to ALF (Artist2 Language for Flow Analysis) --------------===//
//
//                     Benedikt Huber, <benedikt@vmars.tuwien.ac.at>
//                     Adapted from the C Backend (The LLVM Compiler Infrastructure)
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// The ALFTranslator class is responsible for generating ALF code, and is usually
// used by the ALFTranslator class, which traverses the input module
//
//===----------------------------------------------------------------------===//
#ifndef __ALF_TRANSLATOR_H__
#define __ALF_TRANSLATOR_H__

#include "llvm/Constants.h"
#include "llvm/InlineAsm.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/CodeGen/IntrinsicLowering.h"
#include "llvm/Target/Mangler.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCContext.h"
#include "llvm/Target/TargetData.h"
#include "llvm/Support/GetElementPtrTypeIterator.h"
#include "ALFBuilder.h"

// Allow expressions for select instructions
// Lowers the precision of the restriction mechanism of SWEET
#undef ENABLE_SELECT_EXPRESSIONS

using namespace alf;

/* utility functions (local to the translation unit */
namespace {

/// Global Variables Classes and Static CTor/DTor
enum SpecialGlobalClass {
    NotSpecial = 0,
    GlobalCtors, GlobalDtors, OtherMetadata
};

} // end anon namespace

namespace llvm {

  /// Global Variables Classes and Static CTor/DTor
  enum SpecialGlobalClass {
      NotSpecial = 0,
      GlobalCtors, GlobalDtors, OtherMetadata
  };

  /// Report a fatal error (in context of Function F)
  LLVM_ATTRIBUTE_NORETURN void alf_fatal_error(const Twine& Reason, const Function* F = 0);

  /// Report a fatal error with debugging information for the given Instruction included
  LLVM_ATTRIBUTE_NORETURN void alf_fatal_error(const Twine& Reason, Instruction& Ins);

  /// Report a fatal error, with debugging information on a Type included
  LLVM_ATTRIBUTE_NORETURN void alf_fatal_error(const Twine& Reason, const Type& Ty);

  /// Emit a warning
  void alf_warning(const Twine& Msg, const Function *F = 0);

  /// Emit a warning (instruction information)
  void alf_warning(const Twine& Msg, const Instruction &I);

  /// Specification of areas of memory which are addressed using absolute addresses
  class MemoryArea {
	  std::string Name;
	  uint64_t Start, End;
	  bool IsVolatile;
  public:
	  MemoryArea(std::string& name, uint64_t start, uint64_t end, bool isVolatile) {
		  Name  = name;
		  Start = start;
		  End   = end;
		  IsVolatile = isVolatile;
	  }
	  std::string getName() {
		  return Name;
	  }
	  uint64_t getOffset(uint64_t Address) {
		  return Address - Start;
	  }
	  bool doesInclude(uint64_t Address) {
		  if(Address < Start) return false;
		  if(Address > End)   return false;
		  return true;
	  }
	  uint64_t sizeInBits() {
		  return 8*(End-Start+1);
	  }
	  bool isVolatile() {
		  return IsVolatile;
	  }

  };

  /// ALFTranslator - This class is used to generate ALF code for LLVM expressions and various
  /// other constructs found in the LLVM IR
  /// The visitor only deals with ALF expressions, not ALF statements.
  /// The latter are handled in ALFBackend directly
  class ALFTranslator : public InstVisitor<ALFTranslator> {

	/// Least Addressable Unit
    unsigned LeastAddrUnit;      // Least Addressable Unit

    /// ALF Builder
    ALFBuilder& Builder;

    /// Context for creating expression: either global or current ALF function
    ALFContext *ACtx;

    /// State for adding statements: Current ALF Statement Group
    ALFStatementGroup *CurrentBlock;

    /// State for adding statements: current LLVM instruction
    Instruction* CurrentInstruction;

    /// State for adding statements: current instruction index
    unsigned CurrentInsIndex;

    /// State for adding statements: ALF statement counter
    unsigned CurrentInsCounter;

    /// State for adding statements: current helper basic block
    std::string *CurrentHelperBlock;

    /// State for generating expressions via visitors
    SExpr* BuiltExpr;

    /// Whether volatiles should be ignored
    bool IgnoreVolatiles;

    /// Special frames for volatile loads
    std::map<std::string, unsigned> VolatileStorage;

    /// Memory Areas
    std::vector<MemoryArea> MemoryAreas;

	/// unique name generation and counters
    DenseMap<const Value*, unsigned> AnonValueNumbers;
    unsigned NextAnonValueNumber;

    /// target configuration
    const TargetData* TD;

    /// Machine code context
    MCContext *TCtx;

    /// Assembler info for target
    const MCAsmInfo* TAsm;

    /// Name Mangler
    Mangler *Mang;

  public:

	/// Name of the null-pointer frame (label)
	const static string NULL_REF;

	/// Infinite frame addressed using absolute addresses
	/// Used as fallback if no memory areas have been specified
	const static string ABS_REF;

	/// Prefix for frame name of frames addressed using absolute addresses
	const static string ABS_REF_PREFIX;

    /// Suffix for entry block label
    const static string ENTRY_LABEL_SUFFIX;

    /// Suffix for exit block label
    const static string EXIT_LABEL_SUFFIX;

    /// Name of the frame used to store temporary return values
	const static string RETURN_VALUE_REF;

    /// Suffix for non-scalar formal parameter references
    const static string ARG_BYREF_SUFFIX;

	/// Type of (case,target) list for switch instructions
	typedef SmallVector< std::pair<Value*, BasicBlock*> , 32> CaseVector;

	explicit ALFTranslator(ALFBuilder &B, unsigned lau, bool FlagIgnoreVolatiles)
      : LeastAddrUnit(lau),
        Builder(B),
        CurrentHelperBlock(0),
        IgnoreVolatiles(FlagIgnoreVolatiles),
        NextAnonValueNumber(0),
        TD(0), TCtx(0), TAsm(0), Mang(0)  // initialized in 'initializeTarget
	{
	    this->ACtx = &Builder;
	}

	void initializeTarget(const MCAsmInfo* _TAsm, const TargetData* _TD, const MCRegisterInfo *_MRI) {
  	  TAsm = _TAsm;
  	  TD = _TD;
  	  TCtx = new MCContext(*TAsm, *_MRI, NULL);
  	  Mang = new Mangler(*TCtx, *TD);
	}

	void addMemoryArea(uint64_t Start, uint64_t End, bool IsVolatile) {
		std::string Name = ABS_REF_PREFIX + itostr(MemoryAreas.size());
		MemoryAreas.push_back(MemoryArea(Name, Start, End, IsVolatile));
	}

	typedef std::vector<MemoryArea>::iterator mem_areas_iterator;
	mem_areas_iterator mem_areas_begin()  { return MemoryAreas.begin(); }
	mem_areas_iterator mem_areas_end()    { return MemoryAreas.end(); }

    virtual ~ALFTranslator() {
        if(CurrentHelperBlock) delete CurrentHelperBlock;
    	delete TCtx;
    	delete Mang;
    }

    /// should be called before writing the output
    void addVolatileFrames();

    /// translate a function
    void translateFunction(const Function *F, ALFFunction *AF);

    /// translate a basic block
    void processBasicBlock(const BasicBlock *BBconst, ALFFunction *AF);

    /// process a function definition sginature
    void processFunctionSignature(const Function *F, ALFFunction *AF);

    /// add a statement to the current block
    ALFStatement* addStatement(SExpr *Code);

    /// set the result of a instruction visitor for 'expression' instructions
    void setVisitorResult(const Instruction& Ins, SExpr *Expr) {
        assert(Expr && "setVisitorResult: null pointer");
        assert(isExpressionInst(Ins) && "setVisitorResult: LLVM instruction does not correspond to ALF expression, but ALF Statement");
        BuiltExpr = Expr;
    }

    /// Build ALF expression from LLVM expression
    SExpr* buildExpression(Value *Expression);

    /// Add initializers (zero or more) for the specified global variable
    void addInitializers(Module &M, GlobalVariable &V,unsigned BitOffset, Constant* C);

    /// Add initializers for a vector or array type
    void addCompositeInitializers(Module &M, GlobalVariable& V, unsigned BitOffset, ConstantArray* C);

    /// Add initializers for a vector or array type
    void addCompositeInitializers(Module &M, GlobalVariable& V, unsigned BitOffset, ConstantVector* C);

    /// Add initializers for a vector or array type
    void addCompositeInitializers(Module &M, GlobalVariable& V, unsigned BitOffset, ConstantDataSequential* C);

    /// Add initializers for a struct type
    void addStructInitializers(Module &M, GlobalVariable& V, unsigned BitOffset, ConstantStruct* Const);

    /// Check whether ConstantExpr can be initialized using a single ALF initializer entry
    bool hasSimpleInitializer(ConstantExpr* ConstExpr);

    /// Build an (atomic) initializer statement for ALF
    void addInitializer(GlobalVariable &V, unsigned BitOffset, Constant* C);

    // ---  Constants

    /// generate ALF code representing a constant
    SExpr* buildConstant(Constant* Const);

    /// generate ALF code representing a global value
    SExpr* buildGlobalValue(const GlobalValue *GV, uint64_t BitOffset);

    /// generate ALF code representing a constant expression
    SExpr* buildConstantExpression(const ConstantExpr * CE);

    /// Constant Folding
    std::auto_ptr<ALFConstant> foldConstant(const Constant* Const);

    /// Constant Folding
    std::auto_ptr<ALFConstant> foldBinaryConstantExpression(const ConstantExpr* CE);

    int64_t getConstantPointerOffset(const ConstantExpr* CE);

    // Instruction visitation functions
    friend class InstVisitor<ALFTranslator>;

    // LLVM IR Statement Instructions
    void visitReturnInst(ReturnInst &I);
    void visitBranchInst(BranchInst &I);
    void visitSwitchInst(SwitchInst &I);
    void visitIndirectBrInst(IndirectBrInst &I);
    void visitUnreachableInst(UnreachableInst &I);
    void visitCallInst (CallInst &I);
    void visitInlineAsm(CallInst &I);
    bool visitBuiltinCall(CallInst &I, Intrinsic::ID ID);
    void visitAllocaInst(AllocaInst &I);
    void visitStoreInst (StoreInst  &I);
    void visitInsertElementInst(InsertElementInst &I);
    void visitShuffleVectorInst(ShuffleVectorInst &SVI);
    void visitInsertValueInst(InsertValueInst &I);

    void visitInvokeInst(InvokeInst &I) {
        alf_fatal_error("invoke instruction not eliminated by lowerinvoke pass!", I);
    }

    // LLVM IR Expression Instructions
    void visitPHINode(PHINode &I);
    void visitBinaryOperator(Instruction &I);
    void visitICmpInst(ICmpInst &I);
    void visitFCmpInst(FCmpInst &I);
    void visitCastInst (CastInst &I);
    void visitSelectInst(SelectInst &I); // Must only be called if ENABLE_SELECT_EXPRESSIONS is defined
    void visitLoadInst  (LoadInst   &I);
    void visitGetElementPtrInst(GetElementPtrInst &I);
    void visitExtractElementInst(ExtractElementInst &I);
    void visitExtractValueInst(ExtractValueInst &I);

    void visitVAArgInst (VAArgInst &I) {
        alf_fatal_error("VAArgInst not yet supported",I);
    }
    void visitInstruction(Instruction &I) {
        alf_fatal_error("Unsupported Instruction Type", I);
    }

    // Expressions
    SExpr* buildOperand(Value *Operand);

    /// cast between integer and floating point types
    SExpr* buildIntCast(Value* Ptr, unsigned BitWidthSrc, unsigned BitWidthTarget, bool signExtend);
    SExpr* buildFPCast(Value* Operand, Type* SrcTy, Type* DstTy, bool isTrunc);
    SExpr* buildFPIntCast(Value* Operand, Type* FloatTy, Type* IntTy, Instruction::CastOps op);

    SExpr* buildMultiplication(unsigned BitWidth, Value* Op1, Value* Op2);


    std::string interpretASMConstraint(InlineAsm::ConstraintInfo& c);

    /// isScalarValueType - Check whether the given type is a primitive type
    /// in ALF; pointers (that is, framerefs), integers (signed and unsigned of any size)
    /// and floats (of any size), as well as void type (1 byte)
    /// are considered to be primitive, while all composite types are not
    bool isScalarValueType(const Type* Ty) {
        if(Ty->isVoidTy()) return true;
        if(Ty->isPointerTy()) return true;
        if(Ty->isIntegerTy()) return true;
        if(Ty->isVectorTy()) return false;
        return Ty->isPrimitiveType();
    }

    /// isExpressionInst - Check whether the instruction corresponds
    ///  to an ALF expression, not an ALF statement.
    bool isExpressionInst(const Instruction &I);

    /// Return true if an instruction should be inlined
    bool isInlinableInst(const Instruction &I);

    /// Add statements for an unconditional jump
    ALFStatement* addUnconditionalJump(BasicBlock* Block, BasicBlock* Succ);

    /// Add statements for a conditional branch or switch instruction
    void addSwitch(TerminatorInst& SI, Value* Condition, const CaseVector& Cases, BasicBlock* DefaultCase);

    /// Build integer atom
    SExpr* buildIntNumVal(const APInt& Value) {
        if(Value.isNegative()) { // nicer to read
            return ACtx->dec_signed(Value.getBitWidth(), Value.getSExtValue());
        } else {
            return ACtx->dec_unsigned(Value.getBitWidth(), Value.getLimitedValue());
        }
    }

    /// Build floating point atom
    SExpr* buildFloatNumVal(Type* FPTy, const APFloat& Value) {
        return ACtx->float_val(getExpWidth(FPTy), getFracWidth(FPTy), Value);
    }

    /// ALF name for volatile storage of the given type
    std::string getVolatileStorage(Type* Ty) {
        std::string Ref = "$volatile_" + utostr(getBitWidth(Ty));
        VolatileStorage.insert(make_pair(Ref, getBitWidth(Ty)));
        return Ref;
    }

    /// ALF variable name of some Value (except BasicBlock labels, see getBasicBlockLabel)
    std::string getValueName(const Value *Operand);

    /// ALF name for a basic block (without function/module prefix)
    std::string getBlockName(const BasicBlock *BB);

    /// ALF name for a basic block label (needs to be unique to the module)
    std::string getBasicBlockLabel(const BasicBlock *BB);

    /// Set the current LLVM instruction
    void setCurrentInstruction(Instruction *I, unsigned Index);

    /// Set current ALF label to a temporary block within an LLVM instruction
    void setCurrentInstruction(const std::string& TempBlockLabel);

    /// ALF name for an LLVM instruction at the given Index in BB (needs to be unique to the module)
    std::string getInstructionLabel(const BasicBlock *BB, unsigned Index);

    /// ALF name for a helper block for translating LLVM instruction at the given Index in BB
    std::string getInstructionLabel(const BasicBlock *BB, unsigned Index, const std::string& HelperBlock);

	/// ALF name for anonymous values
    std::string getAnonValueName(const Value* Operand);


    /// Get bit offset of subtype at Index of a composite type
    int64_t getBitOffset(CompositeType* Ty, int64_t Index);

    /// Get bit offset into a composite type
    int64_t getBitOffset(CompositeType *Ty, ArrayRef<unsigned> Indices);

    /// Get bit offset (Ins,C) interpreted C * valueOf(Ins) of subtype at Index of a composite type
    std::pair<Value*, int64_t> getBitOffset(CompositeType* Ty, Value* Index);

    /// Get number of bits needed to represent the given type in the ALF memory model
    /// Uses TargetData TD to support platfrom-specific behavior
    unsigned getBitWidth(Type *Ty) {
        return TD->getTypeSizeInBits(Ty);
    }

    /// Get the number of bits needed to represent the exponent of a FP number
    unsigned getExpWidth(Type* Ty) {
    	return Ty->getPrimitiveSizeInBits() - Ty->getFPMantissaWidth();
    }

    /// Get the number of bits needed to represent the fractional part (without sign) of a FP number
    unsigned getFracWidth(Type* Ty) {
    	return Ty->getFPMantissaWidth() - 1;
    }

    /// Convert size in bits to size in LAU (least addressable unit)
    unsigned bitsToLAU(uint64_t bits) {
      assert(bits % LeastAddrUnit == 0 && "bitsToLAU: Addressing Errror");
      return bits / LeastAddrUnit;
    }
  private:

    /// Build a comment describing a statement
    std::string getStatementComment(const Instruction &Ins, unsigned Index);

    /// Collect all LLVM instructions combined in the ALF statement for the given instruction
    void getStatementInstructions(const Instruction &Ins, std::vector<const Instruction*> &InsList);

    /// Pointer arithmetic: add the given offset (in bits) to the operand
    SExpr* buildPointer(SExpr *Ptr, int64_t OffsetInBit);

    /// Pointer arithmetic: add the given offset (in bits) to the translated operand
    SExpr* buildPointer(Value *Ptr, SmallVectorImpl<std::pair<Value*, int64_t> >& BitOffsets);

    /// load a scalar value from memory
    SExpr* loadScalar(Type *Ty, SExpr *SrcExpr, bool VolatileAccess);

    /// add copy statements (load of composite types)
    void addCopyStatements(Type *Ty, SExpr *SrcExpr, SExpr *DstExpr, bool VolatileAccess = false, uint64_t Offset = 0);

    /// add a source code mapping for an instruction
    void addMapping(const StringRef Label, Instruction *I);

    /// get source code location corresponding to an instruction (if available)
    bool getDebugLocation(Instruction *I, std::string& File, int &Line, int &Col);
  };
}

#endif




