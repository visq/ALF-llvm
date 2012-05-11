//===-- ALFWriter.h - Library for converting LLVM code to ALF (Artist2 Language for Flow Analysis) --------------===//
//
//                     Benedikt Huber, <benedikt@vmars.tuwien.ac.at>
//                     Adapted from the C Backend (The LLVM Compiler Infrastructure)
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// The ALFWriter class is responsible for generating ALF code, and is usually
// used by the ALFWriter class, which traverses the input module
//
//===----------------------------------------------------------------------===//
#ifndef __ALF_WRITER_H__
#define __ALF_WRITER_H__

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


// Allow expressions for select instructions
// Lowers the precision of the restriction mechanism of SWEET
#undef ENABLE_SELECT_EXPRESSIONS

#define ALF_DEBUG_HOT(x) (x)
#define ALF_DEBUG(x)


/* utility functions (local to the translation unit */
namespace {

/// Check whether this instruction is a pointer <-> pointer bitcast
inline bool isPtrPtrBitCast(const Instruction &I) {
  if (!isa<BitCastInst>(I)) return false;
  return (I.getOperand(0)->getType()->isPointerTy() && I.getType()->isPointerTy());
}

/// Check whether this constant expression is a pointer <-> pointer bitcast
inline bool isPtrPtrBitCast(const ConstantExpr &CE) {
	if(CE.getOpcode() != Instruction::BitCast) return false;
    return (CE.getOperand(0)->getType()->isPointerTy() && CE.getType()->isPointerTy());
}

/// isStaticSizeAlloca - fixed size allocas are implemented by adding a scalar
/// variable of the given size to the set of local variables of the function,
/// and assigning the address of that variable to the left-hand-side of the
/// alloca. It is not required that the alloca is in the entry block,
/// so AI->isStaticAlloca() is a stronger predicate than isStaticSizeAlloca(AI)
const AllocaInst *isStaticSizeAlloca(const Value *V) {
  const AllocaInst *AI = dyn_cast<AllocaInst>(V);
  // not an alloca instruction
  if (!AI) return 0;
  // not a fixed size allocation
  if (!isa<ConstantInt>(AI->getArraySize())) return 0;
  return AI;
}

/// isInlineAsm - Check if the instruction is a call to an inline asm chunk
inline bool isInlineAsm(const Instruction& I) {
  if (const CallInst *CI = dyn_cast<CallInst>(&I))
    return isa<InlineAsm>(CI->getCalledValue());
  return false;
}

/// Convert a Value into a String (for debugging purposes)
std::string valueToString(const Value& V) {
	std::string s;
	raw_string_ostream os(s);
	V.print(os);
	return os.str();
}

/// Convert a type into a String (for debugging purposes)
std::string typeToString(const Type& T) {
	std::string s;
	raw_string_ostream os(s);
	T.print(os);
	return os.str();
}

} /* end anonymous namespace */

namespace llvm {

  /// Report a fatal error with debugging information included
  LLVM_ATTRIBUTE_NORETURN void alf_fatal_error(const string& Reason, Instruction& Ins);

  /// Report a fatal error for a
  LLVM_ATTRIBUTE_NORETURN void alf_fatal_error(const string& Reason, Instruction& Ins);

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

  /// ALFWriter - This class is used to generate ALF code for LLVM expressions and various
  /// other constructs found in the LLVM IR
  /// The visitor only deals with ALF expressions, not ALF statements.
  /// The latter are handled in ALFBackend directly
  class ALFWriter : public InstVisitor<ALFWriter> {

	/// Least Addressable Unit
    unsigned LeastAddrUnit;      // Least Addressable Unit

    /// ALF output stream
    ALFOutput& Output;

    /// Output Configuration
    bool IgnoreVolatiles;

    /// Memory Areas
    std::vector<MemoryArea> MemoryAreas;

    /// Labeling
    unsigned IsBasicBlockStart;
    unsigned CurrentStatementIndex;

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

	/// Type of (case,target) list for switch instructions
	typedef SmallVector< std::pair<Value*, BasicBlock*> , 32> CaseVector;

	explicit ALFWriter(ALFOutput &O, unsigned lau, bool FlagIgnoreVolatiles)
      : LeastAddrUnit(lau),
        Output(O),
        IgnoreVolatiles(FlagIgnoreVolatiles),
        NextAnonValueNumber(0),
        TD(0), TCtx(0), TAsm(0), Mang(0)  // initialized in 'initializeTarget
	{ }

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

    virtual ~ALFWriter() {
    	delete TCtx;
    	delete Mang;
    }

    /// emit the signature for a function
    void emitFunctionSignature(const Function *F);

    // Temporary Store
    void emitTemporaryStore(Instruction *I);

    /// Emit initializers (zero or more) for the specified global variable
    void emitInitializers(Module &M, GlobalVariable &V,unsigned BitOffset, Constant* C);

    /// Emit initializers for a vector or array type
    template<typename Const>
    void emitCompositeInitializers(Module &M, GlobalVariable& V, unsigned BitOffset, Const* C);

    /// Emit initializers for a struct type
    void emitStructInitializers(Module &M, GlobalVariable& V, unsigned BitOffset, ConstantStruct* Const);

    /// Check whether ConstantExpr can be initialized using a single ALF initializer entry
    bool hasSimpleInitializer(ConstantExpr* ConstExpr) {
    	// Ptr2Ptr Bitcasts, GEPs and Global Variables or ok
    	Constant* Const = ConstExpr;
    	while(Const) {
    		ConstantExpr* CE = dyn_cast<ConstantExpr>(Const);
    		if(CE && isPtrPtrBitCast(*CE)) {
    			Const = CE->getOperand(0);
    		} else if(CE && CE->getOpcode() == Instruction::GetElementPtr) {
    			Const = CE->getOperand(0);
    		} else {
    			return isa<GlobalValue>(Const);
    		}
    	}
    	return true;
    }

    /// Emit a (atomic) initializer statement for ALF
    void emitInitializer(GlobalVariable &V, unsigned BitOffset, Constant* C);

    //  Constants
    void emitConstant(Constant* Const);
    void emitGlobalValue(const GlobalValue *GV, uint64_t BitOffset);
    void emitConstantExpression(const ConstantExpr * CE);
    std::auto_ptr<ALFConstant> foldConstant(const Constant* Const);
    std::auto_ptr<ALFConstant> foldBinaryConstantExpression(const ConstantExpr* CE);
    uint64_t getConstantPointerOffset(const ConstantExpr* CE);

    // Instruction visitation functions
    friend class InstVisitor<ALFWriter>;

    // LLVM IR Statement Instructions
    void visitReturnInst(ReturnInst &I);
    void visitBranchInst(BranchInst &I);
    void visitSwitchInst(SwitchInst &I);
    void visitIndirectBrInst(IndirectBrInst &I);
    void visitUnreachableInst(UnreachableInst &I);
    void visitCallInst (CallInst &I);
    void visitInlineAsm(CallInst &I);
    bool visitBuiltinCall(CallInst &I, Intrinsic::ID ID, bool &WroteCallee);
    void visitAllocaInst(AllocaInst &I);
    void visitStoreInst (StoreInst  &I);
    void visitInsertElementInst(InsertElementInst &I);
    void visitShuffleVectorInst(ShuffleVectorInst &SVI);
    void visitInsertValueInst(InsertValueInst &I);

    void visitInvokeInst(InvokeInst &I) {
      report_fatal_error("LLVM -> ALF: invoke instruction not eliminated by lowerinvoke pass!");
    }
    void visitUnwindInst(UnwindInst &I) {
      report_fatal_error("LLVM -> ALF: unwind instruction not eliminated by lowerinvoke pass!");
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
        report_fatal_error("ALF Backend: VAArgInst not yet supported " + valueToString(I));
    }
    void visitInstruction(Instruction &I) {
    	report_fatal_error("ALFWriter: not expressible as ALF expression: "+valueToString(I));
    }

    // Expressions
    void emitOperand(Value *Operand);
    void emitExpression(Value *Expression);
    void emitLoad(Value* Operand);

    /// cast between integer and floating point types
    void emitIntCast(Value* Ptr, unsigned BitWidthSrc, unsigned BitWidthTarget, bool signExtend);
    void emitFPCast(Value* Operand, Type* SrcTy, Type* DstTy, bool isTrunc);
    void emitFPIntCast(Value* Operand, Type* FloatTy, Type* IntTy, Instruction::CastOps op);

    void emitMultiplication(unsigned BitWidth, Value* Op1, Value* Op2);
    void emitPointer(Value *Ptr, uint64_t Offset);
    void emitPointer(Value *Ptr, SmallVectorImpl<std::pair<Value*, uint64_t> >& Offsets);

    std::string interpretASMConstraint(InlineAsm::ConstraintInfo& c);

    /// isScalarValueType - Check whether the given type is a primitive type
    /// in ALF; pointers (that is, framerefs), integers (signed and unsigned of any size)
    /// and floats (of any size), as well as void type (1 byte)
    /// are considered to be primitive, while all composite types are not
    static bool isScalarValueType(const Type* Ty) {
        if(Ty->isVoidTy()) return true;
        if(Ty->isPointerTy()) return true;
        if(Ty->isVectorTy()) return false;
        return Ty->isPrimitiveType();
    }

    /// isExpressionInst - Check whether the instruction corresponds
    ///  to an ALF expression, not an ALF statement.
    ///  - PHI node variables are assigned in the predecessor basic block,
    ///    and thus are always variable expressions.
    ///  - Static size allocas are represented by address expressions
    ///  - Loads are ALF expressions, but we need to take care of read-after-write hazards
    ///    when deciding about inlining (see isInlinableInst)
    ///  - Select can be represented as ALF expression, but this weakens the precision
    //     of the restriction mechanism in SWEET (switch: ENABLE_SELECT_EXPRESSIONS)
    static bool isExpressionInst(const Instruction &I) {
        if (I.getType() == Type::getVoidTy(I.getContext())
            || isa<TerminatorInst>(I)
            || isa<CallInst>(I)
            || isa<StoreInst>(I)
            || isa<InsertElementInst>(I)
            || isa<InsertValueInst>(I)
            || isa<ShuffleVectorInst>(I)
            || isa<VAArgInst>(I)) {
            return false;
        }
#ifndef ENABLE_SELECT_EXPRESSIONS
        if(isa<SelectInst>(I)) return false;
#endif
        if(isa<AllocaInst>(I)) {
        	const AllocaInst* AI = cast<AllocaInst>(&I);
        	if(! isStaticSizeAlloca(AI)) return false;
        }
        return true;
    }

    // isInlinableInst - Attempt to inline instructions into their uses to build
    // trees as much as possible.
    // We must no inline an instruction if:
    //  - it does not have an expression type (jumps, stores)
    //  - it is a dynamic alloca (which needs to be freed at the end of the function)
    //  - it is inline assembler, an extract element or a shufflevector instruction
    // Additionally, we do not inline an instruction if:
    //  - it is a load instruction (to avoid read-after write hazards. XXX: not always necessary)
    //  - it is used more than once (XXX: might be beneficial to ignore this rule sometimes)
    //  - it is not defined in the same basic block it is used in (XXX: is this necessary??)
    //  - it is a function call
    static bool isInlinableInst(const Instruction &I) {
      // Always inline PHI nodes and static alloca's
      if(isa<PHINode>(I) || isStaticSizeAlloca(&I))
          return true;

      // Must be an expression, must be used exactly once.  If it is dead, we
      // emit it inline where it would go.
      if (    ! isExpressionInst(I)
           || isa<LoadInst>(I)) /* simplest solution to read-after-write hazards */
          return false;

      // Should only have one use
      if (I.hasOneUse()) {
        const Instruction &User = cast<Instruction>(*I.use_back());
        // Must not be used in inline asm, extractelement, or shufflevector.
        if (isInlineAsm(User) || isa<ExtractElementInst>(User) ||
            isa<ShuffleVectorInst>(User))
          return false;
      } else {
    	  return false;
      }

      // Only inline instruction it if it's use is in the same BB as the inst.
      return I.getParent() == cast<Instruction>(I.use_back())->getParent();
    }

    /// Emit code for an unconditional jump
    void emitUnconditionalJump(BasicBlock* Block, BasicBlock* Succ);

    /// Emit code for a conditional branch or switch instruction
    void emitSwitch(TerminatorInst& SI, Value* Condition, const CaseVector& Cases, BasicBlock* DefaultCase);

    /// Emit integer atom
    void emitIntNumVal(const APInt& Value) {
        Output.dec_unsigned(Value.getBitWidth(), Value);
    }

    /// Emit floating point atom
    void emitFloatNumVal(Type* FPTy, const APFloat& Value) {
    	Output.float_val(getExpWidth(FPTy), getFracWidth(FPTy), Value);
    }

    /// Set all PHI variables of the successor block, assuming the predecessor is known
    void setPHICopiesForSuccessor(BasicBlock *PredBlock, BasicBlock* SuccBlock);

    /// Labeling/Comments
    void basicBlockHeader(const BasicBlock* BB);
    void statementHeader(const Instruction &I, unsigned Index);

    /// ALF variable name of some Value (except BasicBlock labels, see getBasicBlockLabel)
    std::string getValueName(const Value *Operand);

    /// ALF name for a basic block label (needs to be unique to the module)
    std::string getBasicBlockLabel(const BasicBlock *BB);

    /// ALF name for labeling instruction statement (needs to be unique to the module)
    std::string getInstructionLabel(const BasicBlock *BB, unsigned Index);

    /// ALF name for the basic block representing the edge of a conditional jump
    std::string getConditionalJumpLabel(const BasicBlock* Pred, const BasicBlock* Succ);

	/// ALF name for anonymous values
    std::string getAnonValueName(const Value* Operand);

    /// ALF name for volatile storage of the given type
    std::string getVolatileStorage(Type* Ty);

    /// Get bit offset of subtype at Index of a composite type
    uint64_t getBitOffset(CompositeType* Ty, uint64_t Index);

    /// Get bit offset (Ins,C) interpreted C * valueOf(Ins) of subtype at Index of a composite type
    std::pair<Value*, uint64_t> getBitOffset(CompositeType* Ty, Value* Index);

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
  };
}

#endif




