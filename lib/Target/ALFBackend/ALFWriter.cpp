//===-- ALFWriter.cpp - Library for converting LLVM code to ALF (Artist2 Language for Flow Analysis) --------------===//
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

#include "ALFOutput.h"
#include "ALFWriter.h"
#include "llvm/Analysis/DebugInfo.h"
#include "llvm/Support/CallSite.h"

const string ALFWriter::NULL_REF("$null");
const string ALFWriter::ABS_REF("$mem");
const string ALFWriter::ABS_REF_PREFIX("$mem_");


void llvm::alf_fatal_error(const string& Reason, Instruction& Ins) {
    DebugLoc Loc = Ins.getDebugLoc();
    DISubprogram SubProgram;
    if(MDNode* Scope = Loc.getScope(Ins.getContext())) {
        SubProgram = getDISubprogram(Scope);
        if(SubProgram.Verify()) {
            std::string File = SubProgram.getFilename().str();
            std::string Fun  = SubProgram.getDisplayName().str();
            errs() << "[llvm2alf] At " << File << ":" << Loc.getLine() << ", in " << Fun << "()\n";
        }
    } else {
        Function *F = Ins.getParent()->getParent();
        DebugInfoFinder* DIF = new DebugInfoFinder();
        DIF->processModule(*F->getParent());
        for(DebugInfoFinder::iterator I = DIF->subprogram_begin(), E = DIF->subprogram_end(); I!=E; ++I) {
            DISubprogram SubProgram(*I);
            if(SubProgram.Verify() && SubProgram.describes(F)) {
                std::string File = SubProgram.getFilename().str();
                std::string Fun  = SubProgram.getDisplayName().str();
                errs() << "[llvm2alf] At " << File << ", in " << Fun << "()\n";
                break;
            }
        }
    }
    errs() << "[llvm2alf] At instruction"; Ins.print(errs()); errs () << "\n";
    report_fatal_error("[llvm2alf] Error: " + Reason);
}

void ALFWriter::emitInitializers(Module &M, GlobalVariable& V, unsigned BitOffset, Constant* Const) {

	Type *Ty = Const->getType();
    // Omit undef initializers (undefined is default)
	if(isa<UndefValue>(Const)) {
	    return;
	}
	// Initializers for aggregate zeros
	if(isa<ConstantAggregateZero>(Const)) {
		if(SequentialType *SeqTy = dyn_cast<SequentialType>(Ty)) {
			unsigned NumElems;
			if(const ArrayType* ArrTy = dyn_cast<ArrayType>(SeqTy)) {
				NumElems = ArrTy->getNumElements();
			} else if(const VectorType *VecTy = dyn_cast<VectorType>(SeqTy)) {
				NumElems = VecTy->getNumElements();
			} else {
				report_fatal_error("Unexpected Constant Aggregate Zero for type different from Array or Vector: " + typeToString(*SeqTy));
			}
			for(unsigned Ix = 0; Ix < NumElems; Ix++) {
				Constant* SubConstZero = Constant::getNullValue(SeqTy->getElementType());
				emitInitializers(M, V, BitOffset + getBitOffset(SeqTy, Ix), SubConstZero);
			}
		} else if(StructType *StructTy = dyn_cast<StructType>(Ty)) {
			unsigned Ix = 0;
			for(StructType::element_iterator I = StructTy->element_begin(), E = StructTy->element_end(); I!=E; ++I) {
				Constant* SubConstZero = Constant::getNullValue(*I);
				emitInitializers(M,V,BitOffset + getBitOffset(StructTy, Ix++), SubConstZero);
			}
		} else {
		    report_fatal_error ("[llvm2alf] emitInitializers(): Unknown composite type for ConstantAggregateZero:" + typeToString(*Ty));
		}
		return;
    }

    switch (Ty->getTypeID()) {
    // Emit Integer Constant
    case Type::IntegerTyID: {
        assert(isa<ConstantInt>(Const) && "Integer Constant not of type ConstantInt?");
        emitInitializer(V, BitOffset, cast<ConstantInt>(Const));
        return;
    }
	// For pointer types, null, global values and constant expressions are supported
    case Type::PointerTyID: {
    	if(Const->isNullValue()) {
    		emitInitializer(V, BitOffset, ConstantPointerNull::get(cast<PointerType>(Const->getType())));
    	} else if(isa<GlobalVariable>(Const)) {
    		emitInitializer(V, BitOffset, cast<GlobalVariable>(Const));
    	} else if(ConstantExpr* ConstExpr = dyn_cast<ConstantExpr>(Const)) {
    		if(hasSimpleInitializer(ConstExpr)) {
    			emitInitializer(V, BitOffset, ConstExpr);
    		} else {
    	        report_fatal_error("[llvm2alf] emitIntializers(): Unsupported Constant Pointer Expression: " + valueToString(*ConstExpr));
    		}
    	} else if(isa<Function>(Const)) {
    		emitInitializer(V, BitOffset, cast<Function>(Const));
        } else if(isa<BlockAddress>(Const)) {
            emitInitializer(V, BitOffset, cast<BlockAddress>(Const));
        } else {
    		report_fatal_error("[llvm2alf] emitIntializers(): Unsupported Pointer Constant: " + valueToString(*Const));
    	}
    	return;
    }
    // For vectors, emit initializer for every element
    case Type::VectorTyID: {
        assert(isa<ConstantVector>(Const) && "Non-Zero Vector Constant not of type ConstantVector?");
        emitCompositeInitializers(M,V,BitOffset,cast<ConstantVector>(Const));
        return;
    }
    // For arrays, emit initializer for every element
    case Type::ArrayTyID: {
        assert(isa<ConstantArray>(Const) && "Non-Zero Array Constant not of type ConstantArray?");
        emitCompositeInitializers(M,V,BitOffset,cast<ConstantArray>(Const));
        return;
    }
    // For struct, emit initializer for every element
    case Type::StructTyID: {
        assert(isa<ConstantStruct>(Const) && "Non-Zero Struct Constant not of type ConstantStruct?");
        emitStructInitializers(M,V,BitOffset,cast<ConstantStruct>(Const));
        return;
    }
    // For floating point types, we only support constant values
    case Type::FloatTyID:       // 32 bit floating point type
    case Type::DoubleTyID:      // 64 bit floating point type
    case Type::X86_FP80TyID:    // 80 bit floating point type (X87)
    case Type::FP128TyID:       // 128 bit floating point type (112-bit mantissa)
    case Type::PPC_FP128TyID:   // 128 bit floating point type (two 64-bits)
    {
        assert(isa<ConstantFP>(Const) && "Non-Zero floating point constant not of type ConstantFP?");
        emitInitializer(V, BitOffset, cast<ConstantFP>(Const));
        return;
    }
    // Function constants do not make sense
    case Type::FunctionTyID:
        report_fatal_error("[llvm2alf] emitIntializers(): Unsupported constant of function type " + typeToString(*Ty));
        break;
    default:
        report_fatal_error("[llvm2alf] emitIntializers(): Unsupported Type: " + typeToString(*Ty));
        break;
    }
    assert(0 && "llvm_unreachable");
}

template<typename Tc>
void ALFWriter::emitCompositeInitializers(Module &M, GlobalVariable& V, unsigned BitOffset, Tc* Const) {

   	unsigned bitIndex = BitOffset;
    for(ConstantArray::const_op_iterator I = Const->op_begin(), E = Const->op_end();
    I!=E; ++I) {
        Constant *ElConst = cast<Constant>(&*I);
        emitInitializers(M, V, bitIndex, ElConst);
        bitIndex += TD->getTypeAllocSizeInBits(ElConst->getType());
    }
}

void ALFWriter::emitStructInitializers(Module &M, GlobalVariable& V, unsigned BitOffset, ConstantStruct* Const) {

	const StructLayout* Layout = TD->getStructLayout(Const->getType());
    for(unsigned Ix = 0; Ix < Const->getNumOperands(); ++Ix) {
        emitInitializers(M, V, BitOffset + Layout->getElementOffsetInBits(Ix), cast<Constant>(Const->getOperand(Ix)));
    }
}

void ALFWriter::emitInitializer(GlobalVariable& V, unsigned BitOffset, Constant* Const) {

	ALF_DEBUG(dbgs() << "emitInitializer: " << valueToString(V) << "[offset=" << utostr(BitOffset)
			         << "] <- " << valueToString(*Const) << "\n");

	// no need to emit undefined initializers (e.g., padding generated by clang)
	if(isa<UndefValue>(Const)) return;

	std::string ref = getValueName(&V);
	bool ReadOnly = V.isConstant();
	Output.startList("init");

	Output.ref(ref, BitOffset);
    emitConstant(Const);

    // There is no notion of a volatile *variable* in LLVM
    if(ReadOnly) Output.atom("read_only");

    Output.endList("init");
}

void ALFWriter::emitConstant(Constant *CPV) {

	if (isa<GlobalValue>(CPV)) {
		emitGlobalValue(cast<GlobalValue>(CPV), 0ULL);

	} else if (const ConstantExpr *CE = dyn_cast<ConstantExpr>(CPV)) {
		emitConstantExpression(CE);

	} else if (isa<UndefValue>(CPV) && CPV->getType()->isSingleValueType()) {
		Output.undefined(getBitWidth(CPV->getType()));

	} else if(ConstantInt *CI = dyn_cast<ConstantInt>(CPV)) {
		emitIntNumVal(CI->getValue());

	} else if(ConstantFP *CFP = dyn_cast<ConstantFP>(CPV)) {
		emitFloatNumVal(CFP->getType(), CFP->getValueAPF());
    } else if(isa<ConstantPointerNull>(CPV)) {
        // Emit a null pointer constant.
        // Might be obvious, but keep in mind that a null pointer is not an
        // undefined value, but needs to be comparable to other pointers.
        //    int *x = 0, y = 5, z = 2;
        //    if(x == 0)  x = &z;
        //    if(x != &y) x = &y;
        //    if(x == 0) *x = 3;  /* segfault */
        //    if(x == 0)  y = *x; /* segfault */
        // Currently implemented as frameref "mem@00000000"
		Output.address(NULL_REF, 0);
	} else if(BlockAddress *CBA = dyn_cast<BlockAddress>(CPV)) {
	    BasicBlock *BB = CBA->getBasicBlock();
	    Output.label(getBasicBlockLabel(BB), 0);
	} else if(ConstantAggregateZero *CAZ = dyn_cast<ConstantAggregateZero>(CPV)) {
		report_fatal_error("[llvm2alf] emitConstant(): unsupported ConstantAggregateZero. "
				           "Type: " + typeToString(*CAZ->getType()));
	} else if(ConstantArray *CA = dyn_cast<ConstantArray>(CPV)) {
		report_fatal_error("[llvm2alf] emitConstant(): unsupported ConstantArray. "
				           "Type: " + typeToString(*CA->getType()));
	} else if(ConstantStruct *CS = dyn_cast<ConstantStruct>(CPV)) {
		report_fatal_error("[llvm2alf] emitConstant(): unsupported ConstantStruct. "
				            "Type: " + typeToString(*CS->getType()));
	} else if(ConstantVector *CV = dyn_cast<ConstantVector>(CPV)) {
		report_fatal_error("[llvm2alf] emitConstant(): unsupported ConstantVector. "
				            "Type: " + typeToString(*CV->getType()));
	} else {
		report_fatal_error("[llvm2alf] unknown constant expressions of type: " + typeToString(*CPV->getType()));
	}
}

void ALFWriter::emitGlobalValue(const GlobalValue *GV, uint64_t Offset) {

	ALF_DEBUG(dbgs() << "[llvm2alf] Global Value Constant (label or address): " << valueToString(*GV) << "\n");

	if(const GlobalVariable *GVar = dyn_cast<GlobalVariable>(GV)) {
		Output.address(getValueName(GVar), Offset);
	} else if(const Function *FVar = dyn_cast<Function>(GV)) {
		Output.label(getValueName(FVar), Offset);
	} else {
		report_fatal_error("[llvm2alf] emitGlobalValue: Unsupported Global Value Type: " + valueToString(*GV));
	}
}

// emit function signature {func LABEL ARG_DECLS SCOPE}
void ALFWriter::emitFunctionSignature(const Function *F) {
  // XXX: Ignoring calling conventions and linkage

  // Loop over the arguments, printing them...
  const FunctionType *FT = cast<FunctionType>(F->getFunctionType());
  const AttrListPtr &PAL = F->getAttributes();

  // Emit name
  Output.label(getValueName(F), 0);

  // Emit formal parameters
  Output.startList("arg_decls");
  if (!F->arg_empty()) {
      Function::const_arg_iterator I = F->arg_begin(), E = F->arg_end();
      unsigned Idx = 1;

      std::string ArgName;
      for (; I != E; ++I) {
          std::string ArgName;
          if (! I->hasName()) {
              ArgName = "__unused__" + utostr(Idx);
          } else {
              ArgName = getValueName(I);
          }
          Type *ArgTy = I->getType();
          if (PAL.paramHasAttr(Idx, Attribute::ByVal)) {
              errs() << "[llvm2alf] Warning: ByVal parameter does not conform to C interface" << typeToString(*FT) << "\n";
          }
          unsigned size = getBitWidth(ArgTy); // in bits
          Output.alloc(ArgName, size);
          ++Idx;
      }
  }
  Output.endList("arg_decls");
  if (FT->isVarArg()) {
    report_fatal_error("[llvm2alf] emitFunctionSignature(): varargs are not supported");
  }
}

//===----------------------------------------------------------------------===//
//                        ALF Statement visitors
//===----------------------------------------------------------------------===//

void ALFWriter::visitReturnInst(ReturnInst &I) {

  // TODO: struct return
  bool isStructReturn = I.getParent()->getParent()->hasStructRetAttr();
  if (isStructReturn) {
      alf_fatal_error("struct return not yet supported", I);
  }

  Output.startList("return");
  for (unsigned i = 0, e = I.getNumOperands(); i != e; ++i) {
      emitOperand(I.getOperand(i));
  }
  Output.endList("return");
}

void ALFWriter::visitSwitchInst(SwitchInst &SI) {

	  if(SI.getNumCases() > 1) {
		  Value* Condition = SI.getCondition();

		  /* one case: true -> 0, default -> 1 */
	 	  ALFWriter::CaseVector Cases;
		  for(unsigned i = 1; i < SI.getNumCases(); ++i) {
				Cases.push_back(make_pair(SI.getCaseValue(i), SI.getSuccessor(i)));
		  }
		  emitSwitch(SI, Condition, Cases, SI.getSuccessor(0));

	  } else { // emulated unconditional branch
		  emitUnconditionalJump(SI.getParent(), SI.getSuccessor(0));
	  }

}

// Emit ALF code for a Branch Instruction
void ALFWriter::visitBranchInst(BranchInst &I) {

  if (I.isConditional()) {
	Value* Condition = I.getCondition();

	/* one case: true -> 0, default -> 1 */
	ALFWriter::CaseVector Cases;
	Cases.push_back(make_pair(ConstantInt::getTrue(Condition->getType()), I.getSuccessor(0)));
	emitSwitch(I, Condition, Cases, I.getSuccessor(1));

  } else {
	  emitUnconditionalJump(I.getParent(), I.getSuccessor(0));
  }
}

void ALFWriter::visitIndirectBrInst(IndirectBrInst &IBI) {
    alf_fatal_error("indirect branch instruction not yet supported", IBI);
}

// The unreachable instructions has undefined behavior; its intention
// will often be that of assert(0). As ALF is missing asserts, we
// currently emit a nop (which is NOT a good solution IMHO).
void ALFWriter::visitUnreachableInst(UnreachableInst &I) {
	Output.startList("null", true);
	Output.endList("null");
}


void ALFWriter::visitStoreInst(StoreInst &I) {
  // FIXME: Deal with Alignment
  Type* OperandType = I.getOperand(0)->getType();
  bool IsUnaligned = I.getAlignment() &&
                     I.getAlignment() < TD->getABITypeAlignment(OperandType);
  if(IsUnaligned) {
    errs() << "Error: Alignment is " << itostr(I.getAlignment()) <<
              ", but ABI requirement is " <<  itostr(TD->getABITypeAlignment(OperandType)) <<
              " for operand type " << typeToString(*OperandType) << "\n";
    alf_fatal_error("Unaligned memory write access not supported yet", I);
  }

  if(I.isVolatile() && ! IgnoreVolatiles) {
	  // In general, it is not safe to ignore volatile stores. A store to a regular
	  // variable might be marked volatile (to avoid reordering).
  }

  // Emit LHS
  Output.startList("store");
  emitOperand(I.getPointerOperand());

  Output.atom("with");
  emitOperand(I.getOperand(0));
  Output.endList("store");
}


void ALFWriter::visitCallInst(CallInst &I) {
  if (isa<InlineAsm>(I.getCalledValue()))
    return visitInlineAsm(I);

  bool WroteCallee = false;

  // Handle intrinsic function calls first...
  if (Function *F = I.getCalledFunction())
    if (Intrinsic::ID ID = (Intrinsic::ID)F->getIntrinsicID())
      if (visitBuiltinCall(I, ID, WroteCallee))
        return;

  Value *Callee = I.getCalledValue();

  const PointerType  *PTy   = cast<PointerType>(Callee->getType());
  const FunctionType *FTy   = cast<FunctionType>(PTy->getElementType());

  // If this is a call to a struct-return function, assign to the first
  // parameter instead of passing it to the call.
  //bool hasByVal = I.hasByValArgument();
  bool isStructRet = I.hasStructRetAttr();

  // FIXME: struct returns are not supported yet
  if (isStructRet) {
      alf_fatal_error("struct return is not supported yet",I);
  }

  // if (I.isTailCall()) Out << " /*tail*/ ";

  Output.startList("call",false);

  if (!WroteCallee) {
    // cf C Backend: Inserts a cast if:
    //  - this is an indirect call to a struct return function
    //  - indirect calls with byval arguments.
    emitOperand(Callee);
  }

  // FIXME: VarArgs are not supported yet
  if(FTy->isVarArg() && !FTy->getNumParams()) {
      alf_fatal_error("var args are not yet supported",I);
  }

  unsigned NumDeclaredParams = FTy->getNumParams();
  CallSite CS(&I);
  CallSite::arg_iterator AI = CS.arg_begin(), AE = CS.arg_end();
  unsigned ArgNo = 0;
  if (isStructRet) {   // Skip struct return argument.
    ++AI;
    ++ArgNo;
  }


  for (; AI != AE; ++AI, ++ArgNo) {
    if (ArgNo < NumDeclaredParams &&
        (*AI)->getType() != FTy->getParamType(ArgNo)) {
      errs() << "[llvm2alf] Mismatch in Parameter " << ArgNo << "\n";
      alf_fatal_error("coercion of function parameters is not supported", I);
    }
    // Check if the argument is expected to be passed by value.
    if (I.paramHasAttr(ArgNo+1, Attribute::ByVal)) {
        // This has no direct consequence for ALF code generation, but may lead
        // to problems when a caller uses the C interface
        errs() << "[llvm2alf] Warning: Pointer argument was declared as ByVal parameter of "
                  "type " << typeToString(*(*AI)->getType()) << "\n";
    }
    emitOperand(*AI);
  }

  Output.atom("result");

  if(! FTy->getReturnType()->isVoidTy()) {
    Output.address(getValueName(&I), 0);
  }

  Output.endList("call");
}

/// visitBuiltinCall - Handle the call to the specified builtin.  Returns true
/// if the entire call is handled, return false if it wasn't handled, and
/// optionally set 'WroteCallee' if the callee has already been printed out.
/// TODO: va_* vararg support
// XXX: Unresolved question: what is the best way to deal with mem{cpy,set,move} ???
//      This applies to all intrinsics which are usually either replaced by an optimized code block or
//      a low-level libc-alike function
//
// Notes from the C Backend. They need compiler specific macros for:
//  ... alloca builtin
//  ... longjmp, setjmp builtin
//  ... whether __attribute__ for linkweak,linkonce,visibility etc. is available
//  ... floating points: nan,nanf,inf,inff
//  ... stack save, stack restore builtins
//  ... support for 128-bit integers
bool ALFWriter::visitBuiltinCall(CallInst &I, Intrinsic::ID ID,
                               bool &WroteCallee) {

  switch(ID) {
  case Intrinsic::dbg_declare:
  case Intrinsic::dbg_value:
      return true;
  /// mem{cpy,set,move}: For constant length N, emit load/store pairs
  case Intrinsic::memcpy:
  case Intrinsic::memmove:
  case Intrinsic::memset:
	  // Paralell copy supports both memcpy and memmove
	  // declare void @llvm.memcpy.p0i8.p0i8.i32(i8* <dest>, i8* <src>, i32 <len>, i32 <align>, i1 <isvolatile>)
	  // declare void @llvm.memmove.p0i8.p0i8.i32(i8* <dest>, i8* <src>, i32 <len>, i32 <align>, i1 <isvolatile>)
	  // declare void @llvm.memset.p0i8.i32(i8* <dest>, i8 <val>, i32 <len>, i32 <align>, i1 <isvolatile>)
	  if(ConstantInt* Len = dyn_cast<ConstantInt>(I.getOperand(2))) {
		  Value *Dst = I.getOperand(0);
		  Value *Src = I.getOperand(1);

		  Output.startList("store",true);
		  for(uint64_t I = 0, E = Len->getLimitedValue(); I!=E; ++I) {
			  Output.startList("add",true);
			  Output.atom(TD->getTypeSizeInBits(Dst->getType()));
			  emitExpression(Dst);
			  Output.dec_unsigned(TD->getTypeSizeInBits(Dst->getType()), I);
			  Output.dec_unsigned(1,0);
			  Output.endList("add");
		  }
		  Output.atom("with");
		  for(uint64_t I = 0, E = Len->getLimitedValue(); I!=E; ++I) {
			  if(ID == Intrinsic::memset) {
				  emitExpression(Src);
			  } else {
				  Output.startList("load",true);
				  Output.atom(8);
				  Output.startList("add",true);
				  Output.atom(TD->getTypeSizeInBits(Src->getType()));
				  emitExpression(Src);
				  Output.dec_unsigned(TD->getTypeSizeInBits(Src->getType()), I);
				  Output.dec_unsigned(1,0);
				  Output.endList("add");
				  Output.endList("load");
			  }
		  }
		  Output.endList("store");
		  return true;
	  }
  case Intrinsic::vastart:
  case Intrinsic::vacopy:
  case Intrinsic::vaend:
      alf_fatal_error("unsupported vaarg intrinsic",I);
  default:
      alf_fatal_error("unsupported builtin call",I);
  }
}


void ALFWriter::visitInlineAsm(CallInst &CI) {
    alf_fatal_error("Inline assembler not supported yet",CI);
}

//===----------------------------------------------------------------------===//
//                        ALF Expression visitors
//===----------------------------------------------------------------------===//

void ALFWriter::visitSelectInst(SelectInst &I) {
#ifdef ENABLE_SELECT_EXPRESSIONS
  Output.startList("if");
  Output.atom(getBitWidth(I.getTrueValue()->getType()));
  emitOperand(I.getCondition());
  emitOperand(I.getTrueValue());
  emitOperand(I.getFalseValue());
  Output.endList("if");
#else
  std::string InstLabel = getInstructionLabel(I.getParent(), CurrentStatementIndex);
  std::string ThenLabel = InstLabel + "::then";
  std::string ElseLabel = InstLabel + "::else";
  std::string JoinLabel = InstLabel + "::join";

  Output.startList("switch");
  emitOperand(I.getCondition());
  Output.startList("target");
  emitOperand(ConstantInt::getTrue(I.getCondition()->getType()));
  Output.label(ThenLabel, 0);
  Output.endList("target");
  Output.startList("default");
  Output.label(ElseLabel, 0);
  Output.endList("default");
  Output.endList("switch");

  // then and else branch
  for(int Branch = 0; Branch < 2; Branch++) {
	  Output.label((Branch == 0) ? ThenLabel : ElseLabel,0);
	  Output.startList("store");
	  Output.address(getValueName(&I));
	  Output.atom("with");
	  emitOperand((Branch == 0) ? I.getTrueValue() : I.getFalseValue());
	  Output.endList("store");
	  Output.jump(JoinLabel, 0);
  }
  // join
  Output.label(JoinLabel,0);
  // nop to avoid double label errors
  Output.null();
#endif
}

void ALFWriter::visitAllocaInst(AllocaInst &AI) {

    if (isStaticSizeAlloca(&AI) != 0) {
    	Output.address(getValueName(&AI), 0);
    } else {
        alf_fatal_error("alloca(): dyn_alloc not yet supported by SWEET", AI);

        Output.startList("dyn_alloc");
        Output.atom(Output.getBitsOffset());
        Output.fref("alloca");

        const Value* ArraySize = AI.getArraySize();
        Type* SizeType = ArraySize->getType();
        Constant* ElementSize =
                ConstantInt::get(SizeType, getBitWidth(AI.getAllocatedType()) / 8, false);
        emitMultiplication(getBitWidth(SizeType), const_cast<Value*>(ArraySize), ElementSize);
        Output.endList("dyn_alloc");
    }
}

// The value for PHI nodes is set at the predecessor
void ALFWriter::visitPHINode(PHINode &I) {
  Output.load(getBitWidth(I.getType()), getValueName(&I), 0);
}

// Emit ALF expression for binary operator
// FIXME: Support nuw and nsw Semantics
// FIXME: Is it ok to use u_mul + bitcast to emulate LLVM mul?
// FIXME: has ALF/mod and LLVM/rem the same semantics?
void ALFWriter::visitBinaryOperator(Instruction &I) {
  // binary instructions, shift instructions, setCond instructions.
  assert(!I.getType()->isPointerTy());


  // If this is a negation operation, print it out as such.  For FP, we don't
  // want to print "-0.0 - X".
  if (BinaryOperator::isNeg(&I)) {
      Value* Operand = BinaryOperator::getNegArgument(cast<BinaryOperator>(&I));
      Output.startList("neg",true);
      Output.atom(getBitWidth(Operand->getType()));
      emitOperand(Operand);
      Output.endList("neg");

  } else if (BinaryOperator::isFNeg(&I)) {
      Value* Operand = BinaryOperator::getFNegArgument(cast<BinaryOperator>(&I));
      Type* FTy = Operand->getType();
      Output.startList("f_neg",true);
      Output.atom(getExpWidth(FTy));
      Output.atom(getFracWidth(FTy));
      emitOperand(Operand);
      Output.endList("f_neg");

  } else if (I.getOpcode() == Instruction::FRem) {
    // TODO: output a call to fmod/fmodf instead of emitting a%b
    errs() << "[llvm2alf]: frem is not yet supported\n";
    Output.undefined(getBitWidth(I.getType()));
  } else {

    string Cmd;
    Type *OpTy = I.getOperand(0)->getType();
    unsigned BitWidth  = OpTy->getPrimitiveSizeInBits();
    assert(OpTy->getTypeID() == I.getOperand(1)->getType()->getTypeID()
           && "arithmetic operation: TypeIDs have to match");
    assert(BitWidth == I.getOperand(1)->getType()->getPrimitiveSizeInBits()
           && "arithmetic operation: Bit width of operands has to match");

    switch (I.getOpcode()) {
    case Instruction::Add:  Cmd = "add"; break;
    case Instruction::Sub:  Cmd = "sub"; break;
    }
    if(! Cmd.empty()) {
        Output.startList(Cmd);
        Output.atom(BitWidth);

        /* To support pointer arithmetic, ignore ptr2int in operands for add and sub */
        for(int OpIx = 0; OpIx < 2; ++OpIx) {
            Value *Op = I.getOperand(OpIx);
            if(PtrToIntInst* SubOp = dyn_cast<PtrToIntInst>(Op)) {
            	Op = SubOp->getOperand(0);
            }
            emitOperand(Op);
        }

        Output.dec_unsigned(1,I.getOpcode() == Instruction::Add ? 0 : 1);
        Output.endList(Cmd);
        return;
    }
    // FIXME: support nuw and nsw
    // multiplication + bitcast
    if(I.getOpcode() == Instruction::Mul) {
        emitMultiplication(BitWidth, I.getOperand(0), I.getOperand(1));
        return;
    }

    switch (I.getOpcode()) {
    case Instruction::UDiv: Cmd = "u_div";break;
    case Instruction::SDiv: Cmd = "s_div";break;
    case Instruction::URem: Cmd = "u_mod";break;
    case Instruction::SRem: Cmd = "s_mod";break;
    }
    if(! Cmd.empty()) {
        Output.startList(Cmd);
        Output.atom(BitWidth);
        Output.atom(BitWidth);
        emitOperand(I.getOperand(0));
        emitOperand(I.getOperand(1));
        Output.endList(Cmd);
        return;
    }

    switch (I.getOpcode()) {
    case Instruction::And:  Cmd = "and"; break;
    case Instruction::Or:   Cmd = "or"; break;
    case Instruction::Xor:  Cmd = "xor"; break;
    }
    if(! Cmd.empty()) {
        Output.startList(Cmd);
        Output.atom(BitWidth);
        emitOperand(I.getOperand(0));
        emitOperand(I.getOperand(1));
        Output.endList(Cmd);
        return;
    }

    switch (I.getOpcode()) {
    case Instruction::Shl : Cmd = "l_shift"; break;
    case Instruction::LShr: Cmd = "r_shift"; break;
    case Instruction::AShr: Cmd = "r_shift_a"; break;
    }
    if(! Cmd.empty()) {
        Output.startList(Cmd);
        Output.atom(BitWidth);
        Output.atom(BitWidth);
        emitOperand(I.getOperand(0));
        emitOperand(I.getOperand(1));
        Output.endList(Cmd);
        return;
    }

    switch (I.getOpcode()) {
    case Instruction::FAdd: Cmd = "f_add"; break;
    case Instruction::FSub: Cmd = "f_sub"; break;
    case Instruction::FMul: Cmd = "f_mul"; break;
    case Instruction::FDiv: Cmd = "f_div"; break;
    }

    if(! Cmd.empty()) {
      Output.startList(Cmd);
      Output.atom(getExpWidth(OpTy));
      Output.atom(getFracWidth(OpTy));
      emitOperand(I.getOperand(0));
      emitOperand(I.getOperand(1));
      Output.endList(Cmd);
      return;
    }

    errs() << "Invalid operator type!" << I;
    llvm_unreachable(0);
  }

}

/// emit cmp expression
//  Note that (in constrast to C Backend) we do not need signedness casts
void ALFWriter::visitICmpInst(ICmpInst &I) {
  string Cmd;
  unsigned BitWidth = getBitWidth(I.getOperand(0)->getType());
  assert(BitWidth == getBitWidth(I.getOperand(1)->getType()) && "ICmp: Bitwidth does not match");

  switch (I.getPredicate()) {
  case ICmpInst::ICMP_EQ:  Cmd = "eq"  ;break;
  case ICmpInst::ICMP_NE:  Cmd = "neq" ;break;
  case ICmpInst::ICMP_ULE: Cmd = "u_le";break;
  case ICmpInst::ICMP_SLE: Cmd = "s_le";break;
  case ICmpInst::ICMP_UGE: Cmd = "u_ge";break;
  case ICmpInst::ICMP_SGE: Cmd = "s_ge";break;
  case ICmpInst::ICMP_ULT: Cmd = "u_lt";break;
  case ICmpInst::ICMP_SLT: Cmd = "s_lt";break;
  case ICmpInst::ICMP_UGT: Cmd = "u_gt";break;
  case ICmpInst::ICMP_SGT: Cmd = "s_gt";break;
  default: llvm_unreachable("Illegal ICmp predicate");
  }
  Output.startList(Cmd);
  Output.atom(BitWidth);
  emitOperand(I.getOperand(0));
  emitOperand(I.getOperand(1));
  Output.endList(Cmd);
}

// Floating point comparison
// As ALF does not support infinity or NaN, we have
// UNO(x,y)   LLVM: isnan(x) || isnan(y)
//            ALF:  undefined, this cannot be expressed in ALF
// ORD(x,y)   LLVM: !isnan(x) && !isnan(y)
//            ALF:  currently undefined, could be expressed as (x<=y || x>=y)
// FCMP_O<=>: LLVM: ORD(x,y) && x <=> y
//            ALF:  If any is undefined: undefined
//                  otherwise: x <=> y
// FCMP_U<=>: LLVM: UNO(x,y) || x <=> y
//            ALF:  If any is undefined: undefined
//                  otherwise: x <=> y
void ALFWriter::visitFCmpInst(FCmpInst &I) {


  Type* OpTy = I.getOperand(0)->getType();
  if (I.getPredicate() == FCmpInst::FCMP_FALSE) {
    Output.dec_unsigned(1,0);
    return;
  }
  if (I.getPredicate() == FCmpInst::FCMP_TRUE) {
    Output.dec_unsigned(1,1);
    return;
  }

  if (I.getPredicate() == FCmpInst::FCMP_UNO) {
	Output.undefined(OpTy->getPrimitiveSizeInBits());
  }
  // FIXME: good translation of ORD(x,y)
  if (I.getPredicate() == FCmpInst::FCMP_ORD) {
	Output.undefined(OpTy->getPrimitiveSizeInBits());
  }


  const char* Cmd = 0;
  switch (I.getPredicate()) {
  case FCmpInst::FCMP_UEQ: Cmd = "f_eq"; break;
  case FCmpInst::FCMP_UNE: Cmd = "f_ne"; break;
  case FCmpInst::FCMP_ULT: Cmd = "f_lt"; break;
  case FCmpInst::FCMP_ULE: Cmd = "f_le"; break;
  case FCmpInst::FCMP_UGT: Cmd = "f_gt"; break;
  case FCmpInst::FCMP_UGE: Cmd = "f_ge"; break;
  case FCmpInst::FCMP_OEQ: Cmd = "f_eq"; break;
  case FCmpInst::FCMP_ONE: Cmd = "f_ne"; break;
  case FCmpInst::FCMP_OLT: Cmd = "f_lt"; break;
  case FCmpInst::FCMP_OLE: Cmd = "f_le"; break;
  case FCmpInst::FCMP_OGT: Cmd = "f_gt"; break;
  case FCmpInst::FCMP_OGE: Cmd = "f_ge"; break;
  default: llvm_unreachable("Illegal FCmp predicate");
  }
  Output.startList(Cmd);
  Output.atom(getExpWidth(OpTy));
  Output.atom(getFracWidth(OpTy));
  emitOperand(I.getOperand(0));
  emitOperand(I.getOperand(1));
  Output.endList(Cmd);
}



// GEP Instructions ~ address arithmetic
void ALFWriter::visitGetElementPtrInst(GetElementPtrInst &GepIns) {

	Value *Ptr = GepIns.getPointerOperand();
	gep_type_iterator S = gep_type_begin(GepIns), E = gep_type_end(GepIns);

	unsigned BitWidth =  getBitWidth(Ptr->getType());
	assert(BitWidth == TD->getPointerSizeInBits() && "bad pointer bit width");

	SmallVector<std::pair<Value*, uint64_t>, 4> Offsets;

    // Pointer arithmetic
    for (gep_type_iterator I = S; I != E; ++I) {
        if (isa<Constant>(I.getOperand()) && cast<Constant>(I.getOperand())->isNullValue())
            continue;
        Offsets.push_back(getBitOffset(cast<CompositeType>(*I), I.getOperand()));
    }
    emitPointer(Ptr, Offsets);
}

/// FIXME: alignment issues are ignored for now
void ALFWriter::visitLoadInst(LoadInst &I) {
  if(I.isVolatile() && ! IgnoreVolatiles) {
	Output.load(getBitWidth(I.getType()),getVolatileStorage(I.getType()),0);
    return;
  }
  Output.startList("load");
  Output.atom(getBitWidth(I.getType()));
  emitOperand(I.getOperand(0));
  Output.endList("load");
}

void ALFWriter::visitExtractElementInst(ExtractElementInst &I) {
  alf_fatal_error("unsupported: visitExtractElementInst", I);
  // We know that our operand is not inlined.
//  Out << "((";
//  Type *EltTy =
//    cast<VectorType>(I.getOperand(0)->getType())->getElementType();
//  printType(Out, PointerType::getUnqual(EltTy));
//  Out << ")(&" << getValueName(I.getOperand(0)) << "))[";
//  emitOperand(I.getOperand(1));
//  Out << "]";
}


void ALFWriter::visitInsertElementInst(InsertElementInst &I) {
  alf_fatal_error("unsupported: visitInsertElementInst", I);
//  const Type *EltTy = I.getType()->getElementType();
//  emitOperand(I.getOperand(0));
//  Out << ";\n  ";
//  Out << "((";
//  printType(Out, PointerType::getUnqual(EltTy));
//  Out << ")(&" << getValueName(&I) << "))[";
//  emitOperand(I.getOperand(2));
//  Out << "] = (";
//  emitOperand(I.getOperand(1));
//  Out << ")";
}

void ALFWriter::visitExtractValueInst(ExtractValueInst &EVI) {

    uint64_t BitOffset = 0;
    {
        Type *OpTy = EVI.getAggregateOperand()->getType();
        for (ExtractValueInst::idx_iterator I = EVI.idx_begin(), E = EVI.idx_end(); I!=E; ++I) {
            CompositeType *Agg = cast<CompositeType>(OpTy);
            BitOffset += getBitOffset(Agg, *I);
            OpTy = Agg->getTypeAtIndex(*I);
        }
    }
    // Extract from BitOffset to BitOffset + Size - 1
    Output.startList("select");
    Output.atom(getBitWidth(EVI.getAggregateOperand()->getType()));
    Output.atom(BitOffset);
    Output.atom(BitOffset + getBitWidth(EVI.getType()) - 1);
    emitOperand(EVI.getAggregateOperand());
    Output.endList("select");
}


void ALFWriter::visitInsertValueInst(InsertValueInst &IVI) {

    errs() << "unsupported: visitInsertValueInst\n";
    Output.undefined(getBitWidth(IVI.getType()));
  // Start by copying the entire aggregate value into the result variable.
//  emitOperand(IVI.getOperand(0));
//  Out << ";\n  ";
//
//  // Then do the insert to update the field.
//  Out << getValueName(&IVI);
//  for (const unsigned *b = IVI.idx_begin(), *i = b, *e = IVI.idx_end();
//       i != e; ++i) {
//    Type *IndexedTy =
//      ExtractValueInst::getIndexedType(IVI.getOperand(0)->getType(), b, i+1);
//    if (IndexedTy->isArrayTy())
//      Out << ".array[" << *i << "]";
//    else
//      Out << ".field" << *i;
//  }
//  Out << " = ";
//  emitOperand(IVI.getOperand(1));
}

void ALFWriter::visitShuffleVectorInst(ShuffleVectorInst &SVI) {
    alf_fatal_error("unsupported: visitShuffleVectorInst", SVI);
//  Out << "(";
//  printType(Out, SVI.getType());
//  Out << "){ ";
//  const VectorType *VT = SVI.getType();
//  unsigned NumElts = VT->getNumElements();
//  Type *EltTy = VT->getElementType();
//
//  for (unsigned i = 0; i != NumElts; ++i) {
//    if (i) Out << ", ";
//    int SrcVal = SVI.getMaskValue(i);
//    if ((unsigned)SrcVal >= NumElts*2) {
//      Out << " 0/*undef*/ ";
//    } else {
//      Value *Op = SVI.getOperand((unsigned)SrcVal >= NumElts);
//      if (isa<Instruction>(Op)) {
//        // Do an extractelement of this value from the appropriate input.
//        Out << "((";
//        printType(Out, PointerType::getUnqual(EltTy));
//        Out << ")(&" << getValueName(Op)
//            << "))[" << (SrcVal & (NumElts-1)) << "]";
//      } else if (isa<ConstantAggregateZero>(Op) || isa<UndefValue>(Op)) {
//        Out << "0";
//      } else {
//        printConstant(cast<ConstantVector>(Op)->getOperand(SrcVal &
//                                                           (NumElts-1)),
//                      false);
//      }
//    }
//  }
//  Out << "}";
}

void ALFWriter::visitCastInst(CastInst &I) {

  Value* Operand = I.getOperand(0);

  Type *SrcTy = I.getSrcTy();
  Type *DstTy = I.getDestTy();

  IntegerType *SrcTyInt = dyn_cast<IntegerType>(SrcTy);
  IntegerType *DstTyInt = dyn_cast<IntegerType>(DstTy);

  switch(I.getOpcode()) {
  case Instruction::Trunc:
    assert(SrcTyInt && DstTyInt && "Trunc: both operands need to be integer types");
    emitIntCast(Operand, getBitWidth(SrcTyInt), getBitWidth(DstTyInt), false);
    break;
  case Instruction::SExt:
    assert(SrcTyInt && DstTyInt && "SExt: both operands need to be integer types");
    emitIntCast(Operand, getBitWidth(SrcTyInt), getBitWidth(DstTyInt), true);
    break;
  case Instruction::ZExt:
    assert(SrcTyInt && DstTyInt && "ZExt: both operands need to be integer types");
    emitIntCast(Operand, getBitWidth(SrcTyInt), getBitWidth(DstTyInt), false);
    break;
  case Instruction::FPTrunc:
	emitFPCast(Operand, SrcTy, DstTy, true);
	break;
  case Instruction::FPExt:
	emitFPCast(Operand, SrcTy, DstTy, false);
	break;

  // Pointers (which might be symbolic memory addresses) cannot be coerced to integers in ALF
  case Instruction::PtrToInt:
	  errs() << "LLVM->ALF: unsupported ptr2int ins, emitting undefined\n";
	  Output.comment("undefined ptr2int");
	  Output.undefined(getBitWidth(DstTy));
	  break;
  case Instruction::IntToPtr:
	  errs() << "LLVM->ALF: unsupported int2ptr ins, emitting undefined\n";
	  Output.comment("undefined int2ptr");
	  Output.undefined(getBitWidth(DstTy));
	  break;
  // XXX: do LLVM and ALF have the same semantics for these instructions? (tests/float2.ll)
  case Instruction::FPToUI:
  case Instruction::FPToSI:
	  emitFPIntCast(Operand, SrcTy, DstTy, I.getOpcode());
	  break;
  case Instruction::UIToFP:
  case Instruction::SIToFP:
	  emitFPIntCast(Operand, DstTy, SrcTy, I.getOpcode());
	  break;
  case Instruction::BitCast:
	if(SrcTy == DstTy) {
		emitOperand(Operand);
	} else if(isPtrPtrBitCast(I)){
		/* ignore pointer <-> pointer bitcasts */
		ALF_DEBUG(dbgs() << "Warning: LLVM->ALF: Ignoring ptr2ptr BitCast\n");
		assert(TD->getTypeAllocSizeInBits(I.getType()) ==
			   TD->getTypeAllocSizeInBits(Operand->getType()) && "bitcast between type of different size");
		emitOperand(Operand);
	} else {
	    alf_fatal_error("unsupported BitCast instruction", I);
	}
	break;
  default: llvm_unreachable(0);

  }
}
/// Store the value of the instruction in a temporary
/// ALF variable. Directly *after* the store, the value
/// of emitLoad(I) is equivalent to emitExpression(I)
void ALFWriter::emitTemporaryStore(Instruction* I) {
    Output.startList("store",false);
    Output.address(getValueName(I), 0);
    Output.atom("with");
    emitExpression(I);
    Output.endList("store");
}



/// Note: Emit Operand will use use a local variable if the value
/// is neither inlineable nor a constant
/// cf. C Backend: has a Static parameter, which we removed
void ALFWriter::emitExpression(Value *Operand) {

    Instruction *I;
    Constant* CPV;

    if((I = dyn_cast<Instruction>(Operand)) != 0) {
        visit(I);
    } else if((CPV = dyn_cast<Constant>(Operand)) != 0) {
        emitConstant(CPV);
    } else {
    	report_fatal_error("emitExpression(): Neither Constant nor Instruction: " + valueToString(*Operand));
    }
}
/// emitOperand detects whether the operand should be inlined or
/// not. If yes, the expression is emitted, otherwise a load of
/// the corresponding local variable is emited.
//
// ct. CBackend: the Static parameter was removed
void ALFWriter::emitOperand(Value *Operand) {

	Constant* CPV = dyn_cast<Constant>(Operand);
    if (CPV) {
    	emitExpression(Operand);
    	return;
    }
    Instruction *I = dyn_cast<Instruction>(Operand);
    if(I && isInlinableInst(*I)) {
    	emitExpression(Operand);
        return;
    }
    // Load the named operand
    emitLoad(Operand);
}



// Load the variable the given operand was
// assigned to.
void ALFWriter::emitLoad(Value* Operand) {
    unsigned size = getBitWidth(Operand->getType());
    Output.load(size, getValueName(Operand));
}

void ALFWriter::emitUnconditionalJump(BasicBlock* Block, BasicBlock* Succ) {
    setPHICopiesForSuccessor (Block, Succ);
    Output.jump(getBasicBlockLabel(Succ), 0);
}



// Emit switch statement. The phi variables are now set in an extra basic block inserted
// between the predecessors and sucessor.
void ALFWriter::emitSwitch(TerminatorInst& SI,
		                   Value* Condition,
		                   const CaseVector& Cases,
		                   BasicBlock* DefaultCase) {

	  BasicBlock *BB = SI.getParent();

	  std::set<BasicBlock*> EdgeBlocks;
	  Output.startList("switch");
	  emitOperand(Condition);
	  for(CaseVector::const_iterator I = Cases.begin(), E = Cases.end(); I!=E; ++I) {
		    Output.startList("target");
		    emitOperand(I->first);
		    if(isa<PHINode>(I->second->begin())) { /* need to set phi variables on the edge */
				Output.label(getConditionalJumpLabel(BB, I->second));
				EdgeBlocks.insert(I->second);
		    } else {
		    	Output.label(getBasicBlockLabel(I->second));
		    }
		    Output.endList("target");
	  }
	  Output.startList("default");
	  if(isa<PHINode>(DefaultCase->begin())) { /* need to set phi variables on the edge */
		  Output.label(getConditionalJumpLabel(BB,DefaultCase));
		  EdgeBlocks.insert(DefaultCase);
	  } else {
	      Output.label(getBasicBlockLabel(DefaultCase));
	  }
	  Output.endList("default");
	  Output.endList("switch");

	  // Insert basic blocks to set phi copies (one for each succ with phi nodes)
	  for(std::set<BasicBlock*>::const_iterator I = EdgeBlocks.begin(), E = EdgeBlocks.end();
			  I!=E; ++I) {
		  BasicBlock* Succ = *I;
		  Output.label(getConditionalJumpLabel(BB, Succ));
		  emitUnconditionalJump(BB, Succ);
	  }
}


// Assign to the variables which are defined as PHI nodes
// in a direct successor of the current basic block.
// Note:   If we set the PHI copy in the direct successor,
//         there is no conflict when setting the phi copies for
//         all successors in the current basic block. It might
//         be more efficient to user intermediate BBs though.
// CAVEAT: The branch condition has to be saved to a temporary
//         variable BEFORE the successors are set.
void ALFWriter::setPHICopiesForSuccessor (BasicBlock *PredBlock, BasicBlock *Successor) {
  for (BasicBlock::iterator I = Successor->begin(); isa<PHINode>(I); ++I) {
    PHINode *PN = cast<PHINode>(I);
    Value *IV = PN->getIncomingValueForBlock(PredBlock);
    if (!isa<UndefValue>(IV)) {
	  Output.comment("Set PHI node: " + valueToString(*PN) + " to " + valueToString(*IV), false);

	  Output.startList("store");
      Output.address(getValueName(I), 0);
      Output.atom("with");
      emitOperand(IV);
      Output.endList("store");
    }
  }
}

// Constant Expressions which could not be folded by LLVM itself
// Supported:
//  - Constant Pointers (global + offset)
//  - Bitcasts between pointers (ignored)
//  - Arithmetic on constant pointers and integers
// Expressions & Expression Operands
//  - GlobalVar:  (global, 0)
//  - GEP:        (global, k) -> (global, k+off)
//  - ptr2ptr:    (global, k) -> (global, k)
//  - ptr +- ptr: (g1,k1) -> (g1,k2) -> (g1, k1+-k2)
//  - int`op`int: (_, i1) -> (_, i2) -> i1 `op` i2
void ALFWriter::emitConstantExpression(const ConstantExpr* CE) {

	ALF_DEBUG(dbgs() << "[llvm2alf]: Emmitting constant expression: " << *CE << "\n");

	std::auto_ptr<ALFConstant> FoldedConstant = foldConstant(CE);

	if(FoldedConstant.get() == 0) {
		errs() << "Failed to fold constant expression, emiting undefined: " << valueToString(*CE) << "\n";
		Output.undefined(getBitWidth(CE->getType()));
	} else {
		FoldedConstant->print(Output);
	}
}

/// Do constant integer and pointer arithmetic.
/// Be careful as pointer offsets are bit-addresses in ALF and byte-addresses in LLVM
/// returns a freshly allocated ALFConstant (constant address, integer or float)
std::auto_ptr<ALFConstant> ALFWriter::foldConstant(const Constant* Const) {

	const ConstantExpr* CE = dyn_cast<ConstantExpr>(Const);

	if(CE && isPtrPtrBitCast(*CE)) {
		assert(TD->getTypeAllocSizeInBits(CE->getType()) ==
			   TD->getTypeAllocSizeInBits(CE->getOperand(0)->getType()) && "bitcast between type of different size");
		return foldConstant(CE->getOperand(0));
	}

	if(CE && CE->getOpcode() == Instruction::GetElementPtr)	{

		std::auto_ptr<ALFConstant> ALFConst       = foldConstant(CE->getOperand(0));
		ALFConstAddress* Address = dyn_cast<ALFConstAddress>(ALFConst.get());
		assert(Address && "foldConstant: GetElementPtr on non-address");
		Address->addOffset(getConstantPointerOffset(CE));
		return ALFConst;

	} else if(CE && CE->getOpcode() == Instruction::IntToPtr) {

		std::auto_ptr<ALFConstant> Op = foldConstant(CE->getOperand(0));

		ALFConstInteger* ConstAddress = dyn_cast<ALFConstInteger>(Op.get());
		assert(ConstAddress && "foldConstant: IntToPtr on non-integer");
		uint64_t AbsAddress = ConstAddress->getLimitedValue();
		const PointerType* PtrTy = cast<PointerType>(Const->getType());
		if(PtrTy->getElementType()->isFunctionTy() || PtrTy->getElementType()->isLabelTy()) {
			errs() << "llvm2alf: foldConstant: absolute addresses of functions or labels are not supported\n";
			return std::auto_ptr<ALFConstant>( 0 );
		}
		for(mem_areas_iterator I = mem_areas_begin(), E = mem_areas_end(); I!=E; ++I) {
			if(I->doesInclude(AbsAddress)) {
				std::string Frame = I->getName();
				uint64_t    FrameOffset = I->getOffset(AbsAddress) * 8;
				return std::auto_ptr<ALFConstant>( new ALFConstAddress(false, Frame, FrameOffset) );
			}
		}
		if(mem_areas_begin() == mem_areas_end()) {
			// no memory areas specified, use default catch-all
			return std::auto_ptr<ALFConstant>( new ALFConstAddress(false, ABS_REF, AbsAddress * 8) );
		} else {
			errs() << "llvm2alf: foldConstant: invalid absolute address (not specified on the command line): " << AbsAddress << "\n";
			return std::auto_ptr<ALFConstant>( 0 );
		}

    } else if(CE && CE->getNumOperands() == 1) {

		/* unary expression */
		std::auto_ptr<ALFConstant> Op = foldConstant(CE->getOperand(0));
		if(Op.get() == 0) return Op;

		switch(CE->getOpcode()) {
		/* ptr2int (ignored, as we perform pointer arithmetic directly on pointers) */
		case Instruction::PtrToInt:
			return Op;
		/* unsupported */
		default:
			errs() << "Unsupported instruction in constant expression: " + valueToString(*CE) << "\n";
			return std::auto_ptr<ALFConstant>( 0 );
		}

	} else if(CE && CE->getNumOperands() == 2) {

    	/* binary expression */
    	return foldBinaryConstantExpression(CE);

	} else if(const ConstantInt* ConstInt = dyn_cast<ConstantInt>(Const)) {

		return std::auto_ptr<ALFConstant> (new ALFConstInteger(ConstInt->getBitWidth(), ConstInt->getValue()));

	} else if(isa<GlobalVariable>(Const)) {

		return std::auto_ptr<ALFConstant> (new ALFConstAddress(false, getValueName(Const), 0));

	} else if(isa<Function>(Const)) {

		return std::auto_ptr<ALFConstant> (new ALFConstAddress(true, getValueName(Const), 0));

	} else {

		errs () << "Cannot fold constant expression (unsupported type): " << valueToString(*Const) << "\n";
		return std::auto_ptr<ALFConstant> (0);
	}
}

std::auto_ptr<ALFConstant> ALFWriter::foldBinaryConstantExpression(const ConstantExpr* CE) {

	std::auto_ptr<ALFConstant> OpLeft = foldConstant(CE->getOperand(0));
	std::auto_ptr<ALFConstant> OpRight = foldConstant(CE->getOperand(1));
	if(OpLeft.get() == 0 || OpRight.get() == 0) {
		return std::auto_ptr<ALFConstant> (0);
	}

	unsigned BitWidth = getBitWidth(CE->getType());
	ALFConstInteger* IntegerLHS = dyn_cast<ALFConstInteger>(OpLeft.get());
	ALFConstInteger* IntegerRHS = dyn_cast<ALFConstInteger>(OpRight.get());

	// Integer and pointer arithmetic
	if(CE->getOpcode() == Instruction::Add || CE->getOpcode() == Instruction::Sub) {

		// Handle Cases: Address Left, Address Right, Both Address, Both Integers
		if(ALFConstAddress* AddrLeft = dyn_cast<ALFConstAddress>(OpLeft.get())) {
			if(ALFConstAddress* AddrRight = dyn_cast<ALFConstAddress>(OpRight.get())) {
				// Addr <op> Addr
				if(AddrLeft->getFrame() != AddrRight->getFrame()) {
					errs() << "llvm2alf: foldBinaryConstantExpression: Arithmetic on pointers in different frames is undefined\n";
					return std::auto_ptr<ALFConstant> (0);
				} else if(CE->getOpcode() == Instruction::Add) {
					errs() << "llvm2alf: foldBinaryConstantExpression: Sum of two pointers is undefined\n";
					return std::auto_ptr<ALFConstant> (0);
				}
				// CAVEAT: ALF uses bit offsets, C byte offsets for addresses
				uint64_t Diff = (AddrLeft->getOffset() - AddrRight->getOffset()) / 8;
				return std::auto_ptr<ALFConstant> (new ALFConstInteger(BitWidth, APInt(BitWidth, Diff, false)));
			} else if(IntegerRHS) {
				// Addr <op> Offs
				APInt Offset;
				if(CE->getOpcode() == Instruction::Sub) {
					Offset = - IntegerRHS->getValue();
				} else {
					Offset = IntegerRHS->getValue();
				}
				AddrLeft->addOffset(Offset.getLimitedValue());
				return OpLeft;
			} else {
				report_fatal_error("llvm2alf: foldBinaryConstantExpression: In ptr + x, x has the wrong type: " +
						valueToString(*CE->getOperand(1)));
			}
		} else if(ALFConstAddress* AddrRight = dyn_cast<ALFConstAddress>(OpRight.get())) {
			// Offs <op> Addr
			if(CE->getOpcode() == Instruction::Add && IntegerLHS) {
				AddrRight->addOffset(IntegerLHS->getLimitedValue());
				return OpRight;
			} else if(CE->getOpcode() == Instruction::Sub) {
				errs() << "llvm2alf: foldBinaryConstantExpression: scalar - pointer is undefined\n";
				return std::auto_ptr<ALFConstant> (0);
			} else {
				report_fatal_error("llvm2alf: foldBinaryConstantExpression: In x + ptr, x has the wrong type: " +
						valueToString(*CE->getOperand(0)));
			}
		} else if(IntegerLHS && IntegerRHS) {
			// Int <op> Int
			APInt Result;
			if(CE->getOpcode() == Instruction::Sub) {
				Result = IntegerLHS->getValue() - IntegerRHS->getValue();
			} else {
				Result = IntegerLHS->getValue() + IntegerRHS->getValue();
			}
			return std::auto_ptr<ALFConstant> ( new ALFConstInteger( BitWidth, Result));
		}
	}
	/// Although LLVM handles constant folding of numbers for us, pointer arithmetic might result
	/// in an integer, which is then used in a larger constant expression
	/// For example:   ((int*)q-(int*)p) / 4;

	/* integer arithmetic */

	switch(CE->getOpcode()) {
	case Instruction::Mul:
		if(IntegerLHS && IntegerRHS) {
			return std::auto_ptr<ALFConstant> ( new ALFConstInteger(BitWidth, IntegerLHS->getValue() * IntegerRHS->getValue()) );
		}
		errs() << "llvm2alf: foldConstant: non-integer constant for multiplication" << valueToString(*CE) << "\n";
		break;
	case Instruction::SDiv:
		if(IntegerLHS && IntegerRHS) {
			assert(IntegerRHS->getLimitedValue() != 0 && "llvm2alf: foldConstant: constant division by zero");
			return std::auto_ptr<ALFConstant> ( new ALFConstInteger(BitWidth, IntegerLHS->getValue().sdiv(IntegerRHS->getValue())) );
		}
		errs() << "llvm2alf: foldConstant: non-integer constant for signed divison" << valueToString(*CE) << "\n";
		break;
	case Instruction::UDiv:
		if(IntegerLHS && IntegerRHS) {
			assert(IntegerRHS->getLimitedValue() != 0 && "llvm2alf: foldConstant: constant division by zero");
			return std::auto_ptr<ALFConstant> ( new ALFConstInteger(BitWidth, IntegerLHS->getValue().udiv(IntegerRHS->getValue())) );
		}
		errs() << "llvm2alf: foldConstant: non-integer constant for unsigned divison" << valueToString(*CE) << "\n";
		break;
	default:
		errs () << "Unsupported instruction in constant expression: " + valueToString(*CE) << "\n";
		break;
	}
	return std::auto_ptr<ALFConstant> (0);
}



// Constant Pointers ~ compile-time address arithmetic
uint64_t ALFWriter::getConstantPointerOffset(const ConstantExpr* CE) {

	assert(CE->getOpcode() == Instruction::GetElementPtr && "[llvm2alf]: getConstantPointerOffset(): Not a GEP expression");

	uint64_t BitOffset = 0;

	// Calculate offset
	for (gep_type_iterator I = gep_type_begin(CE), E = gep_type_end(CE); I != E; ++I) {

		assert(isa<CompositeType>(*I) && "getConstantPointerOffset: not a composite type");
		if(ConstantInt* EIx = dyn_cast<ConstantInt>(I.getOperand())) {
			BitOffset += getBitOffset(cast<CompositeType>(*I),EIx->getLimitedValue());
		} else {
			report_fatal_error("[llvm2alf] getConstantPointerOffset: Non constant index for composite type "
			                   "in constant GEP expression: " + valueToString(*I.getOperand()));
		}
	}

	return BitOffset;
}

// Pointers and run-time address arithmetic
void ALFWriter::emitPointer(Value *Ptr, SmallVectorImpl<std::pair<Value*, uint64_t> >& Offsets)
{
    // Pass 1: Fold constants
    int PtrBitWidth = getBitWidth(Ptr->getType());
    uint64_t ConstantOffset = 0;
    SmallVector<std::pair<Value*, uint64_t>, 4> DynamicOffsets;
    for (SmallVectorImpl<std::pair<Value*, uint64_t> >::iterator I = Offsets.begin(), E = Offsets.end();
         I != E; ++I) {
        if (! I->first) {
            ConstantOffset += I->second;
        } else if( ConstantInt* EIx = dyn_cast<ConstantInt>(I->first)) {
            ConstantOffset += EIx->getLimitedValue() * I->second;
        } else {
            DynamicOffsets.push_back(*I);
        }
    }
    // Pass 1: Open add expressions
    for (unsigned I = 0; I < DynamicOffsets.size(); I++) {
        Output.startList("add",false); // Add to address
        Output.atom(PtrBitWidth);
    }

    // Emit Operand (First argument to innermost add, if any)
    emitPointer(Ptr, ConstantOffset);

    // Pass 2: Close add expressions
    for (SmallVectorImpl<std::pair<Value*, uint64_t> >::iterator I = DynamicOffsets.begin(), E = DynamicOffsets.end();
         I != E; ++I) {
        Type* IndexType = IntegerType::get(Ptr->getContext(), PtrBitWidth);
        Constant* IndexMultiplier = ConstantInt::get(IndexType, bitsToLAU(I->second), false);
        emitMultiplication(PtrBitWidth, I->first, IndexMultiplier);
        Output.dec_unsigned(1,0); // No carry bit
        Output.endList("add"); // Close add expression
    }
}

void ALFWriter::emitPointer(Value *Operand, uint64_t Offset) {
    // Pass 1: Open add expressions
    // assert(Operand->getType()->isPointerTy() && "emitPointer: not a pointer type");

    // Emit Operand (First argument to innermost add, if any)
    Output.startList("add",false); // Add to address
    Output.atom(getBitWidth(Operand->getType()));
    emitOperand(Operand);
    Output.offset(Offset);
    Output.dec_unsigned(1,0); // No carry bit
    Output.endList("add"); // Close add expression
}
// TODO: is it ok to emulate LLVM multiplication this way?
// FIXME: support nsw flags etc.
void ALFWriter::emitMultiplication(unsigned BitWidth, Value* Op1, Value* Op2) {
  Output.startList("select");
  Output.atom(BitWidth + BitWidth);
  Output.atom(0);
  Output.atom(BitWidth - 1);
  Output.startList("u_mul",true);
  Output.atom(BitWidth);
  Output.atom(BitWidth);
  emitOperand(Op1);
  emitOperand(Op2);
  Output.endList("u_mul");
  Output.endList("select");
}

/// emit a cast between integer types
void  ALFWriter::emitIntCast(Value* Operand, unsigned BitWidthSrc, unsigned BitWidthDst, bool signExtend) {
  if(BitWidthSrc > BitWidthDst) { // truncate
    Output.startList("select");
    Output.atom(BitWidthSrc);
    Output.atom(0);
    Output.atom(BitWidthDst - 1);
    emitOperand(Operand);
    Output.endList("select");
  } else if(BitWidthSrc < BitWidthDst) {
    if(signExtend) {
      Output.startList("s_ext");
      Output.atom(BitWidthSrc);
      Output.atom(BitWidthDst);
      emitOperand(Operand);
      Output.endList("s_ext");
    } else {
      unsigned ZExtWidth = BitWidthDst - BitWidthSrc;
      Output.startList("conc");
      Output.atom(ZExtWidth);
      Output.atom(BitWidthSrc);
      Output.dec_unsigned(ZExtWidth,0);
      emitOperand(Operand);
      Output.endList("conc");
    }
  } else {
    emitOperand(Operand);
  }
}

// Emit a cast between floating point types
void  ALFWriter::emitFPCast(Value* Operand, Type* SrcTy, Type* DstTy, bool isTrunc) {

  Output.startList("f_to_f");
  Output.atom(getExpWidth(SrcTy));
  Output.atom(getExpWidth(DstTy));
  Output.atom(getFracWidth(SrcTy));
  Output.atom(getFracWidth(DstTy));
  emitOperand(Operand);
  Output.endList("f_to_f");
}

// Emit cast from floating point to integer
void  ALFWriter::emitFPIntCast(Value* Operand, Type* FloatTy, Type* IntTy, Instruction::CastOps Opcode) {

	string op;
	switch(Opcode) {
	  case Instruction::FPToUI:
		  op = "f_to_u";
		  break;
	  case Instruction::FPToSI:
		  op = "f_to_s";
		  break;
	  case Instruction::UIToFP:
		  op = "u_to_f";
		  break;
	  case Instruction::SIToFP:
		  op = "s_to_f";
		  break;
	  default:
		  report_fatal_error("emitFPIntCast: invalid opcode: "+Opcode);
	}
	Output.startList(op);
	Output.atom(getExpWidth(FloatTy));
	Output.atom(getFracWidth(FloatTy));
	Output.atom(getBitWidth(IntTy));
	emitOperand(Operand);
	Output.endList(op);
}

void ALFWriter::basicBlockHeader(const BasicBlock* BB) {
    Output.newline();
    Output.comment("--------- BASIC BLOCK " + BB->getNameStr() + " ----------",false);
    Output.newline();
    Output.label(getBasicBlockLabel(BB), 0);
    Output.incrementIndent();
    IsBasicBlockStart = true;
}

void ALFWriter::statementHeader(const Instruction &I, unsigned Index) {
    Output.comment("LLVM expression: " + I.getParent()->getParent()->getNameStr() + "::" +
                   I.getParent()->getNameStr() + "::" + valueToString(I), false);
    CurrentStatementIndex = Index;
    if(! IsBasicBlockStart) {
        Output.label(getInstructionLabel(I.getParent(),Index));
    } else {
        IsBasicBlockStart = false;
    }
}

std::string ALFWriter::getValueName(const Value *Operand) {

  // Resolve potential alias.
  if (const GlobalAlias *GA = dyn_cast<GlobalAlias>(Operand)) {
    if (const Value *V = GA->resolveAliasedGlobal(false))
      Operand = V;
  }

  // Mangle globals with the standard mangler interface for LLC compatibility.
  if (const GlobalValue *GV = dyn_cast<GlobalValue>(Operand)) {
    SmallString<128> Str;
    Mang->getNameWithPrefix(Str, GV, false);
    return Str.str().str();
  }

  std::string Name = Operand->getName();

  if (Name.empty()) { // Assign unique names to local temporaries.
	Name = getAnonValueName(Operand);
  }
  return "%"+Name;
}

std::string ALFWriter::getBasicBlockLabel(const BasicBlock* BB) {
  std::string name;
  if(! BB->hasName()) {
	  name = getAnonValueName(BB);
  } else {
	  name = BB->getNameStr();
  }
  return BB->getParent()->getNameStr() + "::" + name;
}

std::string ALFWriter::getInstructionLabel(const BasicBlock *BB, unsigned Index) {
    return getBasicBlockLabel(BB) + "::" + utostr(Index);
}

std::string ALFWriter::getConditionalJumpLabel(const BasicBlock* Pred, const BasicBlock* Succ) {
    return getBasicBlockLabel(Pred) + "::edge::" + getBasicBlockLabel(Succ);
}

std::string ALFWriter::getAnonValueName(const Value* Operand) {
	unsigned &No = AnonValueNumbers[Operand];
	if (No == 0) {
		No = ++NextAnonValueNumber;
		AnonValueNumbers[Operand] = No;
	}
	return utostr(No);
}

/// ALF name for volatile storage of the given type
std::string ALFWriter::getVolatileStorage(Type* Ty) {
	return "$volatile_" + utostr(getBitWidth(Ty));
}

uint64_t ALFWriter::getBitOffset(CompositeType* Ty, uint64_t Index) {

	if(StructType *StrucTy = dyn_cast<StructType>(Ty)) {
		return TD->getStructLayout(StrucTy)->getElementOffsetInBits(Index);
	} else if(const SequentialType *SeqTy = dyn_cast<SequentialType>(Ty)) {
		return TD->getTypeAllocSize(SeqTy->getElementType()) * Index * 8;
	} else {
		report_fatal_error ("[llvm2alf] getBitOffset: CompositeType which is neither struct nor sequential");
	}
}

std::pair<Value*, uint64_t> ALFWriter::getBitOffset(CompositeType* Ty, Value* Index) {

    if (ConstantInt* CI = dyn_cast<ConstantInt>(Index)) {
        uint64_t Offset = getBitOffset(Ty, CI->getLimitedValue());
        return std::make_pair((Value*)0, Offset);
    } else if(const SequentialType *SeqTy = dyn_cast<SequentialType>(Ty)) {
        // Sequential types: offset is index times element size
        unsigned ElementBitWidth = TD->getTypeAllocSize(SeqTy->getElementType()) * 8;
        return std::make_pair(Index, ElementBitWidth);
    } else {
        report_fatal_error ("[llvm2alf] visitGetElementPtrInst: Unexpected/Unsupported type in address arithmetic");
    }
}


// This converts the llvm constraint string to something gcc is expecting.
// TODO: currently unused
std::string ALFWriter::interpretASMConstraint(InlineAsm::ConstraintInfo& c) {
  assert(c.Codes.size() == 1 && "Too many asm constraint codes to handle");

  const char *const *table = TAsm->getAsmCBE();

  // Search the translation table if it exists.
  for (int i = 0; table && table[i]; i += 2)
    if (c.Codes[0] == table[i]) {
      return table[i+1];
    }

  // Default is identity.
  return c.Codes[0];
}


