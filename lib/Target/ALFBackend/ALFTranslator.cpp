
//===-- ALFTranslator.cpp - Library for converting LLVM code to ALF (Artist2 Language for Flow Analysis) --------------===//
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

#include "ALFTranslator.h"
#include "llvm/IntrinsicInst.h"
#include "llvm/Analysis/DebugInfo.h"
#include "llvm/Support/CallSite.h"
#include "llvm/Support/InstIterator.h"

#define DEBUG_TYPE "ALF"
#include "llvm/Support/Debug.h"

/* local utilities */
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
inline const AllocaInst *isStaticSizeAlloca(const Value *V) {
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
inline std::string valueToString(const Value& V) {
    std::string s;
    raw_string_ostream os(s);
    V.print(os);
    return os.str();
}

/// Convert a type into a String (for debugging purposes)
inline std::string typeToString(const Type& T) {
    std::string s;
    raw_string_ostream os(s);
    T.print(os);
    return os.str();
}

} // end anonymous namespace

const string ALFTranslator::NULL_REF("$null");
const string ALFTranslator::ABS_REF("$mem");
const string ALFTranslator::ABS_REF_PREFIX("$mem_");
const string ALFTranslator::RETURN_VALUE_REF("$rv");
const string ALFTranslator::RETURN_VALUE_LABEL_SUFFIX("$return");

void llvm::alf_fatal_error(const Twine& Reason, Instruction& Ins) {
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

void llvm::alf_fatal_error(const Twine& Reason, const Type& Ty) {
    report_fatal_error("[llvm2alf] Error: " + Reason + " for Type " + typeToString(Ty));
}

void llvm::alf_fatal_error(const Twine& Reason, const Function* F) {
    report_fatal_error("[llvm2alf] Error: " + Reason + (F?" in Function "+F->getName():""));
}

void llvm::alf_warning(const Twine& Msg) {
    errs() << "[llvm2alf] Warning: " << Msg << "\n";
}


/// Translator Interface
void ALFTranslator::translateFunction(const Function *F, ALFFunction *AF) {

    this->ACtx = AF;

    // add arguments
    processFunctionSignature(F, AF);

    // Declare local variables for storing instruction results. We need local variables for:
    //  - Non-inlineable instructions
    //  - PHI nodes
    //  - The condition of branch and switch statements
    //  - Stack allocated memory, if size is known at compile time
    unsigned ReturnInstructionCount = 0;
    for (const_inst_iterator I = inst_begin(F), E = inst_end(F); I != E; ++I) {

        if(isa<PHINode>(*I)) {
            AF->addLocal(getValueName(&*I), getBitWidth(I->getType()), "Local Variable (PHI node)");
        } else if (I->getType() != Type::getVoidTy(F->getContext()) && !isInlinableInst(*I)) {
            AF->addLocal(getValueName(&*I), getBitWidth(I->getType()), "Local Variable (Non-Inlinable Instruction)");
        } else if (const AllocaInst *AI = isStaticSizeAlloca(&*I)) {
            const ConstantInt* ArraySize = cast<ConstantInt>(AI->getArraySize());
            Type* ElTy = AI->getType()->getElementType();
            AF->addLocal(getValueName(AI), getBitWidth(ElTy) * ArraySize->getLimitedValue(), "Alloca'd memory");
        }

        // Count the number of return instructions, to add an additional basic block as unique exit node
        if(isa<ReturnInst>(*I)) {
            ReturnInstructionCount++;
        }
    }

    // Add (unique, additional) exit basic block if necessary
    // FIXME: we cannot generate sensible mapping info for this BB
    if(ReturnInstructionCount > 1) {
        AF->addLocal(RETURN_VALUE_REF, getBitWidth(F->getReturnType()), "return value");
        AF->setMultiExit(true);
    } else {
        AF->setMultiExit(false);
    }

    // translate the basic blocks
    for (Function::const_iterator BB = F->begin(), E = F->end(); BB != E; ++BB) {
        processBasicBlock(BB, AF);
    }

    // add return block for multi-exit functions
    if(AF->isMultiExit()) {
        CurrentBlock = AF->addBasicBlock(F->getName()+"::"+RETURN_VALUE_LABEL_SUFFIX, "Exit block");
        SExpr *RetExpr;
        if(F->getReturnType()->isVoidTy()) {
            RetExpr = ACtx->ret();
        } else {
            RetExpr = ACtx->ret(ACtx->load(getBitWidth(F->getReturnType()), RETURN_VALUE_REF, 0));
        }
        CurrentBlock->addStatement(F->getName()+"::"+RETURN_VALUE_LABEL_SUFFIX+"::0", "return statement", RetExpr);
    }
    // TODO: Support struct returns
    bool isStructReturn = F->hasStructRetAttr();


    if (isStructReturn) {
        alf_fatal_error("We cannot handle struct returns yet",F);
        // const Type *StructTy =
        //   cast<PointerType>(F.arg_begin()->getType())->getElementType();
        // printType(Out, StructTy, false, "StructReturn");
        // Out << ";  /* Struct return temporary */\n";
        // printType(Out, F.arg_begin()->getType(), false,
        //           getValueName(F.arg_begin()));
        // Out << " = &StructReturn;\n";
    }
}

// finalize build (call before writing output)
void ALFTranslator::addVolatileFrames()
{
    // Add volatile variables
    for(std::map<std::string, unsigned>::iterator I = VolatileStorage.begin(), E= VolatileStorage.end(); I!=E; ++I) {
        Builder.addFrame(I->first, I->second, InternalFrame);
        bool Volatile = true;
        SExpr *Zero;
        uint64_t Repeats;
        /* Initialize with 0-values in chunks of size LAU */
        if(I->second < LeastAddrUnit) {
            Zero = Builder.dec_unsigned(I->second, 0);
            Repeats = 1;
        } else {
            Zero = Builder.dec_unsigned(LeastAddrUnit, 0);
            Repeats = I->second / LeastAddrUnit;
        }
        Builder.addInit(I->first, 0, Builder.const_repeat(Zero, Repeats), Volatile);
    }
}

// emit function signature {func LABEL ARG_DECLS SCOPE}
// FIXME: Ignoring calling conventions and linkage
// FIXME: We do not support varargs
void ALFTranslator::processFunctionSignature(const Function *F, ALFFunction *AF) {

    // Loop over the arguments, printing them...
    const FunctionType *FT = cast<FunctionType>(F->getFunctionType());

    // Add formal parameters
    if (FT->isVarArg()) {
        alf_fatal_error("processFunctionSignature(): variable argument lists are not supported", F);
    } else if (! F->arg_empty()) {
        unsigned Idx = 1;
        for (Function::const_arg_iterator I = F->arg_begin(), E = F->arg_end(); I != E; ++I) {
            // see: http://bugzilla.mdh.se/bugzilla/show_bug.cgi?id=292
            // if (F->getAttributes().paramHasAttr(Idx, Attribute::ByVal)) {
            //    alf_warning("Attribute::ByVal ignored; type = " + typeToString(*FT));
            // }
            AF->addFormal(getValueName(I), getBitWidth(I->getType()));
            ++Idx;
        }
    }
}

// FIXME: BBconst is morally const, but our interfaces do not match
void ALFTranslator::processBasicBlock(const BasicBlock *BBconst, ALFFunction *ACtx) {
    BasicBlock *BB = const_cast<BasicBlock*>(BBconst);
    CurrentBlock = ACtx->addBasicBlock(getBasicBlockLabel(BB), BB->getName());

    // Add statements covering all of the instructions in the basic block...
    unsigned Index = 0;
    for (BasicBlock::iterator II = BB->begin(), IE = BB->end(); II != IE; ++II, ++Index) {
        // Do not emit code for PHI nodes, debug instructions or inlineable instructions
        if (isa<PHINode>(*II) || isa<DbgInfoIntrinsic>(*II) || isInlinableInst(*II)) {
            continue;
        }
        setCurrentInstruction(II, Index);
        if(isExpressionInst(*II)) {
            // Store the value of the instruction in a temporary
            // ALF variable. Directly *after* the store, the value
            // of emitLoad(I) is equivalent to emitExpression(I)
            SExpr *Store = ACtx->store(ACtx->address(getValueName(&*II)), buildExpression(&*II));
            (void) addStatement(Store);
        } else {
            // Visit the statement instruction II
            visit(*II);
        }

    }
}


/// Add an ALF statement for the current LLVM instruction in the current statement block
/// This function returns the label of the generated ALF Statement
ALFStatement* ALFTranslator::addStatement(SExpr *Code) {
    std::string StatementLabel = getInstructionLabel(CurrentInstruction->getParent(), CurrentInsIndex);
    if(CurrentHelperBlock)
        StatementLabel += "::" + *CurrentHelperBlock;
    if(CurrentInsCounter > 0) {
        StatementLabel += ":::" + utostr(CurrentInsCounter);
    }
    bool IsFirst = !CurrentHelperBlock && CurrentInsCounter == 0;
    ALFStatement *Stmt = CurrentBlock->addStatement(StatementLabel,
            IsFirst ? getStatementComment(*CurrentInstruction, CurrentInsIndex) : "", Code);
    CurrentInsCounter++;
    return Stmt;
}

/// Build a comment describing a statement
std::string ALFTranslator::getStatementComment(const Instruction &Ins, unsigned Index) {
    std::string Comment = "STATEMENT " + getInstructionLabel(Ins.getParent(), Index);
    std::vector<const Instruction *> InsList;
    getStatementInstructions(Ins,InsList);
    for(std::vector<const Instruction*>::const_reverse_iterator II = InsList.rbegin(), IE = InsList.rend(); IE != II; ++ II) {
        Comment = Comment + "\n* " + valueToString(**II);
    }
    return Comment;
}

// Collect all LLVM instructions combined in the ALF statement for the given instruction
// Note that the dependency relation is acyclic as no PHI nodes are inlined
void ALFTranslator::getStatementInstructions(const Instruction& Ins, std::vector<const Instruction*> &InsList) {
    std::vector<const Instruction *> Worklist;
    Worklist.push_back(&Ins);
    while(! Worklist.size() == 0) {
        const Instruction *UsedIns = Worklist.back();
        Worklist.pop_back();
        InsList.push_back(UsedIns);
        for(Instruction::const_op_iterator OI = UsedIns->op_begin(), OE = UsedIns->op_end(); OI != OE; ++OI) {
            if(Instruction* Op = dyn_cast<Instruction>(OI)) {
                if(isa<PHINode>(Op)) continue;
                if(! isInlinableInst(*Op)) continue;
                Worklist.push_back(Op);
            }
        }
    }
}

/// Build SExpr for a Operand Value
SExpr* ALFTranslator::buildExpression(Value *Operand) {

    Instruction *I;
    Constant* CPV;

    if((I = dyn_cast<Instruction>(Operand)) != 0) {
        BuiltExpr = 0;
        visit(I);
        if(BuiltExpr == 0) {
            alf_fatal_error("buildExpression(): visitor does not produce expression");
        }
        return BuiltExpr;
    } else if((CPV = dyn_cast<Constant>(Operand)) != 0) {
        return buildConstant(CPV);
    } else {
        alf_fatal_error("emitExpression(): Neither Constant nor Instruction: " + valueToString(*Operand));
    }
}


/// Intializers

bool ALFTranslator::hasSimpleInitializer(ConstantExpr* ConstExpr) {
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

void ALFTranslator::addInitializers(Module &M, GlobalVariable& V, unsigned BitOffset, Constant* Const) {

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
				alf_fatal_error("addInitializers(): Unexpected ConstantAggregateZero for type different from Array or Vector", *SeqTy);
			}
			for(unsigned Ix = 0; Ix < NumElems; Ix++) {
				Constant* SubConstZero = Constant::getNullValue(SeqTy->getElementType());
				addInitializers(M, V, BitOffset + (uint64_t)getBitOffset(SeqTy, Ix), SubConstZero);
			}
		} else if(StructType *StructTy = dyn_cast<StructType>(Ty)) {
			unsigned Ix = 0;
			for(StructType::element_iterator I = StructTy->element_begin(), E = StructTy->element_end(); I!=E; ++I) {
				Constant* SubConstZero = Constant::getNullValue(*I);
				addInitializers(M,V,BitOffset + (uint64_t)getBitOffset(StructTy, Ix++), SubConstZero);
			}
		} else {
		    alf_fatal_error("addInitializers(): Unknown composite type for ConstantAggregateZero:", *Ty);
		}
		return;
    }

    switch (Ty->getTypeID()) {
    // Emit Integer Constant
    case Type::IntegerTyID: {
        assert(isa<ConstantInt>(Const) && "addInitializers(): Integer Constant not of type ConstantInt?");
        addInitializer(V, BitOffset, cast<ConstantInt>(Const));
        return;
    }
	// For pointer types, null, global values and constant expressions are supported
    case Type::PointerTyID: {
    	if(Const->isNullValue()) {
    		addInitializer(V, BitOffset, ConstantPointerNull::get(cast<PointerType>(Const->getType())));
    	} else if(isa<GlobalVariable>(Const)) {
    		addInitializer(V, BitOffset, cast<GlobalVariable>(Const));
    	} else if(ConstantExpr* ConstExpr = dyn_cast<ConstantExpr>(Const)) {
    		if(hasSimpleInitializer(ConstExpr)) {
    			addInitializer(V, BitOffset, ConstExpr);
    		} else {
    	        alf_fatal_error("addInitializers(): Unsupported Constant Pointer Expression: " + valueToString(*ConstExpr));
    		}
    	} else if(isa<Function>(Const)) {
    		addInitializer(V, BitOffset, cast<Function>(Const));
        } else if(isa<BlockAddress>(Const)) {
            addInitializer(V, BitOffset, cast<BlockAddress>(Const));
        } else {
    		alf_fatal_error("addInitializers(): Unsupported Pointer Constant: " + valueToString(*Const));
    	}
    	return;
    }
    // For vectors, emit initializer for every element
    case Type::VectorTyID: {
        assert(isa<ConstantVector>(Const) && "addInitializers(): Non-Zero Vector Constant not of type ConstantVector?");
        addCompositeInitializers(M,V,BitOffset,cast<ConstantVector>(Const));
        return;
    }
    // For arrays, emit initializer for every element
    case Type::ArrayTyID: {
        if(ConstantDataArray* CDA = dyn_cast<ConstantDataArray>(Const)) {
            addCompositeInitializers(M,V,BitOffset,CDA);
        } else {
            assert(isa<ConstantArray>(Const) && "addInitializers(): Non-Zero Array Constant not of type Constant[Data]Array?");
            addCompositeInitializers(M,V,BitOffset,cast<ConstantArray>(Const));
        }
        return;
    }
    // For struct, emit initializer for every element
    case Type::StructTyID: {
        assert(isa<ConstantStruct>(Const) && "addInitializers(): Non-Zero Struct Constant not of type ConstantStruct?");
        addStructInitializers(M,V,BitOffset,cast<ConstantStruct>(Const));
        return;
    }
    // For floating point types, we only support constant values
    case Type::FloatTyID:       // 32 bit floating point type
    case Type::DoubleTyID:      // 64 bit floating point type
    case Type::X86_FP80TyID:    // 80 bit floating point type (X87)
    case Type::FP128TyID:       // 128 bit floating point type (112-bit mantissa)
    case Type::PPC_FP128TyID:   // 128 bit floating point type (two 64-bits)
    {
        assert(isa<ConstantFP>(Const) && "addInitializers(): Non-Zero floating point constant not of type ConstantFP?");
        addInitializer(V, BitOffset, cast<ConstantFP>(Const));
        return;
    }
    // Function constants do not make sense
    case Type::FunctionTyID:
        alf_fatal_error("addInitializers(): Unsupported constant of function type", *Ty);
        break;
    default:
        alf_fatal_error("addInitializers(): Unsupported Type", *Ty);
        break;
    }
    assert(0 && "llvm_unreachable");
}

void ALFTranslator::addCompositeInitializers(Module &M, GlobalVariable& V, unsigned BitOffset, ConstantArray* Const) {

   	unsigned bitIndex = BitOffset;
    for(ConstantArray::const_op_iterator I = Const->op_begin(), E = Const->op_end();
    I!=E; ++I) {
        Constant *ElConst = cast<Constant>(&*I);
        addInitializers(M, V, bitIndex, ElConst);
        bitIndex += TD->getTypeAllocSizeInBits(ElConst->getType());
    }
}

void ALFTranslator::addCompositeInitializers(Module &M, GlobalVariable& V, unsigned BitOffset, ConstantVector* Const) {

    unsigned bitIndex = BitOffset;
    for(ConstantVector::const_op_iterator I = Const->op_begin(), E = Const->op_end();
    I!=E; ++I) {
        Constant *ElConst = cast<Constant>(&*I);
        addInitializers(M, V, bitIndex, ElConst);
        bitIndex += TD->getTypeAllocSizeInBits(ElConst->getType());
    }
}


void ALFTranslator::addCompositeInitializers(Module &M, GlobalVariable& V, unsigned BitOffset, ConstantDataSequential* Const) {

    unsigned bitIndex = BitOffset;
    for(unsigned I = 0, E = Const->getNumElements(); I!=E; ++I) {
        Constant *ElConst = Const->getElementAsConstant(I);
        addInitializers(M, V, bitIndex, ElConst);
        bitIndex += TD->getTypeAllocSizeInBits(ElConst->getType());
    }
}

void ALFTranslator::addStructInitializers(Module &M, GlobalVariable& V, unsigned BitOffset, ConstantStruct* Const) {

	const StructLayout* Layout = TD->getStructLayout(Const->getType());
    for(unsigned Ix = 0; Ix < Const->getNumOperands(); ++Ix) {
        addInitializers(M, V, BitOffset + Layout->getElementOffsetInBits(Ix), cast<Constant>(Const->getOperand(Ix)));
    }
}

void ALFTranslator::addInitializer(GlobalVariable& V, unsigned BitOffset, Constant* Const) {

	DEBUG(dbgs() << "addInitializer: " << valueToString(V) << "[offset=" << utostr(BitOffset)
			         << "] <- " << valueToString(*Const) << "\n");

	// no need to emit undefined initializers (e.g., padding generated by clang)
	if(isa<UndefValue>(Const)) return;
    Builder.addInit(getValueName(&V), BitOffset, buildConstant(Const), false, V.isConstant());
}

SExpr* ALFTranslator::buildConstant(Constant *CPV) {

	if (isa<GlobalValue>(CPV)) {
		return buildGlobalValue(cast<GlobalValue>(CPV), 0ULL);

	} else if (const ConstantExpr *CE = dyn_cast<ConstantExpr>(CPV)) {
		return buildConstantExpression(CE);

	} else if (isa<UndefValue>(CPV) && CPV->getType()->isSingleValueType()) {
		return ACtx->undefined(getBitWidth(CPV->getType()));

	} else if(ConstantInt *CI = dyn_cast<ConstantInt>(CPV)) {
		return buildIntNumVal(CI->getValue());

	} else if(ConstantFP *CFP = dyn_cast<ConstantFP>(CPV)) {
		return buildFloatNumVal(CFP->getType(), CFP->getValueAPF());
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
        return ACtx->address(NULL_REF, 0);
	} else if(BlockAddress *CBA = dyn_cast<BlockAddress>(CPV)) {
	    BasicBlock *BB = CBA->getBasicBlock();
	    return ACtx->labelRef(getBasicBlockLabel(BB));
	} else if(ConstantAggregateZero *CAZ = dyn_cast<ConstantAggregateZero>(CPV)) {
		alf_fatal_error("emitConstant(): unsupported ConstantAggregateZero", *CAZ->getType());
	} else if(ConstantArray *CA = dyn_cast<ConstantArray>(CPV)) {
	    alf_fatal_error("emitConstant(): unsupported ConstantArray",*CA->getType());
	} else if(ConstantStruct *CS = dyn_cast<ConstantStruct>(CPV)) {
	    alf_fatal_error("emitConstant(): unsupported ConstantStruct",*CS->getType());
	} else if(ConstantVector *CV = dyn_cast<ConstantVector>(CPV)) {
	    alf_fatal_error("emitConstant(): unsupported ConstantVector",*CV->getType());
	} else {
	    alf_fatal_error("emitConstant(): Unknown constant expressions",*CPV->getType());
	}
}

SExpr* ALFTranslator::buildGlobalValue(const GlobalValue *GV, uint64_t Offset) {

	DEBUG(dbgs() << "[llvm2alf] Global Value Constant (label or address): " << valueToString(*GV) << "\n");

	if(const GlobalVariable *GVar = dyn_cast<GlobalVariable>(GV)) {
		return ACtx->address(getValueName(GVar), Offset);
	} else if(const Function *FVar = dyn_cast<Function>(GV)) {
		return ACtx->labelRef(getValueName(FVar), Offset);
	} else {
		alf_fatal_error("emitGlobalValue: Unsupported Global Value Type: " + valueToString(*GV));
	}
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
bool ALFTranslator::isExpressionInst(const Instruction &I) {
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
    if(! isScalarValueType(I.getType())) {
        if(isa<ExtractValueInst>(I) || isa<LoadInst>(I))
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

// We must no inline an instruction if:
//  - it does not have an expression type (jumps, stores)
//  - it is a dynamic alloca (which needs to be freed at the end of the function)
//  - it is inline assembler, an extract element, or a shufflevector instruction
// Additionally, we do not inline an instruction if:
//  - it is a load instruction (to avoid read-after write hazards. XXX: not always necessary),
//    except for loads of composite-type values (which are no-ops)
//  - it is used more than once (XXX: might be beneficial to ignore this rule sometimes)
//  - it is not defined in the same basic block it is used in (XXX: is this necessary??)
//  - it is a function call
bool ALFTranslator::isInlinableInst(const Instruction &I) {
  // Always inline PHI nodes and static alloca's
  if(isa<PHINode>(I) || isStaticSizeAlloca(&I))
      return true;

  // Must be an expression, must be used exactly once.  If it is dead, we
  // emit it inline where it would go.
  if (! isExpressionInst(I))
      return false;
  if(isa<CallInst>(I))
      return false;
  if(isa<LoadInst>(I))
      return false; /* simplest solution to read-after-write hazards */
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


//===----------------------------------------------------------------------===//
//                        ALF Statement visitors
//===----------------------------------------------------------------------===//

/// ReturnInstruction: add a return statement, or if this is a multi-exit function,
/// a store to the return value temporary and a jump to the unique exit block.
void ALFTranslator::visitReturnInst(ReturnInst &I) {

  // TODO: struct return
  bool isStructReturn = I.getParent()->getParent()->hasStructRetAttr();
  if (isStructReturn) {
      alf_fatal_error("struct return not yet supported", I);
  }
  ALFFunction *AF = (ALFFunction*)(ACtx); // in function context
  if(AF->isMultiExit()) {
      SExpr *JumpToExit = ACtx->jump(I.getParent()->getParent()->getName() + "::" + RETURN_VALUE_LABEL_SUFFIX);
      if(I.getNumOperands() != 0) {
          SExpr *Store = ACtx->store(ACtx->address(RETURN_VALUE_REF),buildOperand(I.getOperand(0)));
          addStatement(Store);
          addStatement(JumpToExit);
      } else {
          addStatement(JumpToExit);
      }
  } else {
      SExprList* Ret = ACtx->ret();
      if(Value* RetVal = I.getReturnValue()) {
          Ret->append(buildOperand(RetVal));
      }
      addStatement(Ret);
  }
  assert(! isExpressionInst(I) && "ReturnInst should be a statement, not an expression");
}

/// SwitchInst: Add a switch statement or, if there is only one case, an unconditional jump
void ALFTranslator::visitSwitchInst(SwitchInst &SI) {

    assert(! isExpressionInst(SI) && "SwitchInst should be a statement, not an expression");
	if(SI.getNumCases() > 0) { /* not just the default case */
		  Value* Condition = SI.getCondition();

		  /* one case: true -> 0, default -> 1 */
	 	  ALFTranslator::CaseVector Cases;
	 	  for(SwitchInst::CaseIt I = SI.case_begin(), E = SI.case_end(); I != E; ++I) {
	 	      Cases.push_back(make_pair(I.getCaseValue(), I.getCaseSuccessor()));
	 	  }
	 	  addSwitch(SI, Condition, Cases, SI.getDefaultDest());

	} else { // emulated unconditional branch
	    addUnconditionalJump(SI.getParent(), SI.getDefaultDest());
	}
}

/// BranchInst: Add a switch statement or, if this is an unconditional branch, a jump
void ALFTranslator::visitBranchInst(BranchInst &I) {

    assert(! isExpressionInst(I) && "BranchInst should be a statement, not an expression");

    if (I.isConditional()) {

        // one case: true -> 0, default -> 1
        ALFTranslator::CaseVector Cases;
        Value* Condition = I.getCondition();
        Cases.push_back(make_pair(ConstantInt::getTrue(Condition->getType()), I.getSuccessor(0)));
        addSwitch(I, Condition, Cases, I.getSuccessor(1));

    } else {

        addUnconditionalJump(I.getParent(), I.getSuccessor(0));
    }
}

/// IndirectBrInst: not yet supported (TODO)
void ALFTranslator::visitIndirectBrInst(IndirectBrInst &IBI) {

    assert(! isExpressionInst(IBI) && "IndirectBrInst should be a statement, not an expression");
    alf_fatal_error("indirect branch instruction not yet supported", IBI);
}

/// UnreachableInst:
/// The unreachable instructions has undefined behavior; its intention
/// will often be that of assert(0). As ALF is missing asserts, we
/// currently emit a nop (TODO: this is not a good solution)
void ALFTranslator::visitUnreachableInst(UnreachableInst &I) {
    assert(! isExpressionInst(I) && "UnreachableInst should be a statement, not an expression");
    addStatement(ACtx->null());
}

/// StoreInst: store the RHS operand to the address specified by the LHS pointer operand
///  If the type of the stored value is not scalar, generate multiple copy statements.
///
/// Note: In general, it is not safe to ignore volatile stores. A store to a regular
///       variable might be marked volatile (to avoid reordering).
///       For the purposes of flow analysis, we thus ignore the volatile attribute
void ALFTranslator::visitStoreInst(StoreInst &I) {

    assert(! isExpressionInst(I) && "StoreInst should be a statement, not an expression");
    SExpr *LHS = buildOperand(I.getPointerOperand());
    SExpr *RHS = buildOperand(I.getOperand(0));
    if(isScalarValueType(I.getOperand(0)->getType())) {
        addStatement(ACtx->store(LHS,RHS));
    } else {
        addCopyStatements(I.getOperand(0)->getType(), RHS, LHS);
    }
}

/// CallInst: Generate code for function calls, inline assembly or intrinsics.
void ALFTranslator::visitCallInst(CallInst &I) {

  if (isa<InlineAsm>(I.getCalledValue()))
    return visitInlineAsm(I);

  // Handle intrinsic function calls first...
  if (Function *F = I.getCalledFunction())
    if (Intrinsic::ID ID = (Intrinsic::ID)F->getIntrinsicID())
      if (visitBuiltinCall(I, ID))
        return;

  // Struct returns: FIXME: struct returns are not supported yet
  if (I.hasStructRetAttr()) {
      alf_fatal_error("struct return is not supported yet",I);
  }

  Value *Callee = I.getCalledValue();
  const PointerType  *PTy   = cast<PointerType>(Callee->getType());
  const FunctionType *FTy   = cast<FunctionType>(PTy->getElementType());

  SExprList *Call = ACtx->list("call");
  Call->append(buildOperand(Callee));

  // FIXME: VarArgs are not supported yet
  if(FTy->isVarArg() && !FTy->getNumParams()) {
      alf_fatal_error("var args are not yet supported",I);
  }

  unsigned NumDeclaredParams = FTy->getNumParams();
  CallSite CS(&I);
  CallSite::arg_iterator AI = CS.arg_begin(), AE = CS.arg_end();
  unsigned ArgNo = 0;

  for (; AI != AE; ++AI, ++ArgNo) {
    // Check whether types match (no implicit coercion)
    if (ArgNo < NumDeclaredParams && (*AI)->getType() != FTy->getParamType(ArgNo)) {
      alf_warning("Mismatch in Parameter " + utostr(ArgNo));
      alf_fatal_error("coercion of function parameters is not supported", I);
    }
    // Check if the argument is expected to be passed by value.
    if (I.paramHasAttr(ArgNo+1, Attribute::ByVal)) {
        // This has no direct consequence for ALF code generation, but may lead
        // to problems when a caller uses the C interface
        // Unfortunately, there is no way to circumvent this problem, and it
        // is not always detectable (http://bugzilla.mdh.se/bugzilla/show_bug.cgi?id=292)
    }
    Call->append(buildOperand(*AI));
  }
  Call->append("result");
  if(! FTy->getReturnType()->isVoidTy()) {
    Call->append(ACtx->address(getValueName(&I), 0));
  }
  assert(! isExpressionInst(I) && "CallInst should be a statement, not an expression");
  addStatement(Call);
}

/// visitBuiltinCall - Handle the call to the specified builtin.  Returns true
/// if the entire call is handled, return false if it wasn't handled.
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
bool ALFTranslator::visitBuiltinCall(CallInst &I, Intrinsic::ID ID) {
  switch(ID) {
  // do not generate code for dbg_*
  case Intrinsic::dbg_declare:
  case Intrinsic::dbg_value:
      return true;
  // mem{cpy,set,move}: For constant length N, emit load/store pairs
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
		  SExprList *Store = ACtx->list("store");
		  for(uint64_t I = 0, E = Len->getLimitedValue(); I!=E; ++I) {
		      SExpr *OffsetExpr = ACtx->dec_unsigned(getBitWidth(Dst->getType()), bitsToLAU(I*8));
		      SExpr *AddrExpr = ACtx->add(getBitWidth(Dst->getType()), buildExpression(Dst), OffsetExpr);
		      Store->append(AddrExpr);
		  }
		  Store->append("with");
		  for(uint64_t I = 0, E = Len->getLimitedValue(); I!=E; ++I) {
			  if(ID == Intrinsic::memset) {
			      Store->append(buildExpression(Src));
			  } else {
	              SExpr *OffsetExpr = ACtx->dec_unsigned(getBitWidth(Src->getType()), bitsToLAU(I*8));
			      SExpr *ValueExpr = ACtx->add(getBitWidth(Src->getType()), buildExpression(Src), OffsetExpr);
			      Store->append(ACtx->list("load")->append(8)->append(ValueExpr));
			  }
		  }
		  addStatement(Store);
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

/// CallInst/inline assembler: not yet supported
void ALFTranslator::visitInlineAsm(CallInst &CI) {
    alf_fatal_error("Inline assembler not supported yet",CI);
}

//===----------------------------------------------------------------------===//
//                        ALF Expression visitors
//===----------------------------------------------------------------------===//

/// SelectInst: With ENABLE_SELECT_EXPRESSIONS, emit an ALF if statement. (Drawback:
///   restriction does not work well). Otherwise, generate an if-then-else subgraph for
///   selecting the appropriate value (Drawback: additional basic blocks).
void ALFTranslator::visitSelectInst(SelectInst &I) {
#ifdef ENABLE_SELECT_EXPRESSIONS
  assert(isExpressionInst(I) && "SelectInst should be a an expression (ENABLE_SELECT_EXPRESSIONS)");
  BuiltExpr = ACtx->list("if")
          ->append(ACtx->atom(getBitWidth(I.getTrueValue()->getType())))
          ->append(buildOperand(I.getCondition()))
          ->append(buildOperand(I.getTrueValue()))
          ->append(buildOperand(I.getFalseValue()));
#else
  std::string ThenLabel = getInstructionLabel(I.getParent(), CurrentInsIndex, ":then");
  std::string ElseLabel = getInstructionLabel(I.getParent(), CurrentInsIndex, ":else");
  std::string JoinLabel = getInstructionLabel(I.getParent(), CurrentInsIndex, ":join");

  SExprList *Switch = ACtx->list("switch");
  SExpr *Cond = buildOperand(I.getCondition());
  SExpr *TrueVal = buildOperand(ConstantInt::getTrue(I.getCondition()->getType()));
  SExpr *ThenTarget = ACtx->list("target")->append(TrueVal)->append(ACtx->labelRef(ThenLabel));
  SExpr *ElseTarget = ACtx->list("default")->append(ACtx->labelRef(ElseLabel));
  Switch->append(Cond)
        ->append(ThenTarget)
        ->append(ElseTarget);
  assert(! isExpressionInst(I) && "SelectInst should be a a statement (! ENABLE_SELECT_EXPRESSIONS)");
  addStatement(Switch);

  // then and else branch
  for(int Branch = 0; Branch < 2; Branch++) {
      // store true/false value
      setCurrentInstruction(Branch == 0 ? ":then" : ":else");
      SExpr *Val = buildOperand((Branch == 0) ? I.getTrueValue() : I.getFalseValue());
      SExpr *Store = ACtx->store(ACtx->address(getValueName(&I)),Val);
      ALFStatement* StoreStmt = addStatement(Store);
      addMapping(StoreStmt->getLabel(), &I);
      addStatement(ACtx->jump(JoinLabel));
  }
  // join block
  setCurrentInstruction(":join");
  ALFStatement* JoinNopStmt = addStatement(ACtx->null());
  addMapping(JoinNopStmt->getLabel(), &I);
#endif
}

/// AllocaInst: Evaluates to the address of (a) the local variable for
/// this alloca (static size) (b) the call to dyn_alloc (dynamic size)
void ALFTranslator::visitAllocaInst(AllocaInst &AI) {

    SExpr *E;
    if (isStaticSizeAlloca(&AI) != 0) {
        E = ACtx->address(getValueName(&AI), 0);
        setVisitorResult(AI,E);
    } else {
        const Value* ArraySize = AI.getArraySize();
        Type* SizeType = ArraySize->getType();
        Constant* ElementSize = ConstantInt::get(SizeType, getBitWidth(AI.getAllocatedType()) / 8, false);
        SExpr *AllocatedSize = buildMultiplication(getBitWidth(SizeType), const_cast<Value*>(ArraySize), ElementSize);
        SExpr *DynMemAddr = ACtx->list("dyn_alloc")
                ->append(Builder.getConfig()->getBitsOffset())
                ->append(ACtx->fref(getValueName(&AI)))
                ->append(AllocatedSize);
        SExpr *Store = ACtx->store(ACtx->address(getValueName(&AI)),DynMemAddr);
        addStatement(Store);
    }
}

/// PHINode: Load the corresponding local variable, which is set at the predecessor or
/// incoming edge.
void ALFTranslator::visitPHINode(PHINode &I) {
    setVisitorResult(I,ACtx->load(getBitWidth(I.getType()), getValueName(&I), 0));
}

/// Emit ALF expression for binary operator
/// nuw/nsw flags are ignored, as they do not influence the semantics for a correct
/// program
/// FIXME: Is it ok to use u_mul + bitcast to emulate LLVM mul?
/// FIXME: has ALF/mod and LLVM/rem the same semantics?
void ALFTranslator::visitBinaryOperator(Instruction &I) {
  // binary instructions, shift instructions, setCond instructions.
  assert(!I.getType()->isPointerTy() && "Binary operator for pointer type?");
  SExpr *E;

  // If this is a negation operation (0-X), print it out as such
  if (BinaryOperator::isNeg(&I)) {
      Value* Operand = BinaryOperator::getNegArgument(cast<BinaryOperator>(&I));
      E = ACtx->list("neg")
              ->append(getBitWidth(Operand->getType()))
              ->append(buildOperand(Operand));

  } else if (BinaryOperator::isFNeg(&I)) {
      Value* Operand = BinaryOperator::getFNegArgument(cast<BinaryOperator>(&I));
      Type* FTy = Operand->getType();
      E = ACtx->list("f_neg")
            ->append(getExpWidth(FTy))
            ->append(getFracWidth(FTy))
            ->append(buildOperand(Operand));
  } else {
    Type *OpTy = I.getOperand(0)->getType();
    unsigned BitWidth  = OpTy->getPrimitiveSizeInBits();
    assert(OpTy->getTypeID() == I.getOperand(1)->getType()->getTypeID()
           && "arithmetic operation: TypeIDs have to match");
    assert(BitWidth == I.getOperand(1)->getType()->getPrimitiveSizeInBits()
           && "arithmetic operation: Bit width of operands has to match");

    string Cmd;
    enum BinOpTy { AddSub, Mul, DivRem, Logic, Shift, FpOp } BinOpType;
    switch (I.getOpcode()) {
    case Instruction::Add: Cmd = "add"; BinOpType = AddSub; break;
    case Instruction::Sub: Cmd = "sub"; BinOpType = AddSub; break;
    case Instruction::Mul: BinOpType = Mul; break;
    case Instruction::UDiv: Cmd = "u_div"; BinOpType = DivRem; break;
    case Instruction::SDiv: Cmd = "s_div"; BinOpType = DivRem; break;
    case Instruction::URem: Cmd = "u_mod"; BinOpType = DivRem; break;
    case Instruction::SRem: Cmd = "s_mod"; BinOpType = DivRem; break;
    case Instruction::And:  Cmd = "and"; BinOpType = Logic; break;
    case Instruction::Or:   Cmd = "or"; BinOpType = Logic; break;
    case Instruction::Xor:  Cmd = "xor"; BinOpType = Logic; break;
    case Instruction::Shl : Cmd = "l_shift"; BinOpType = Shift; break;
    case Instruction::LShr: Cmd = "r_shift";  BinOpType = Shift; break;
    case Instruction::AShr: Cmd = "r_shift_a";  BinOpType = Shift; break;
    case Instruction::FAdd: Cmd = "f_add"; BinOpType = FpOp; break;
    case Instruction::FSub: Cmd = "f_sub"; BinOpType = FpOp; break;
    case Instruction::FMul: Cmd = "f_mul"; BinOpType = FpOp; break;
    case Instruction::FDiv: Cmd = "f_div"; BinOpType = FpOp; break;
    case Instruction::FRem:
        // TODO: support frem
        alf_warning("frem is not yet supported, emitting undefined");
        setVisitorResult(I,ACtx->undefined(getBitWidth(I.getType())));
        return;
    default:
        alf_fatal_error("Invalid operator type", I);
        llvm_unreachable(0);
    }
    if(BinOpType == AddSub) {
        /* FIXME: Supporting pointer arithmetic for LAU!=8
         *   (a) i1 +- i2 = (add/sub i1 i2)
         *   (b) ptrtoint[p2] - ptrtoint[p1] ==> lauToBytes[sub p2 p1]
         *   (c) ptrtoint[p] +- i ==> add p bytesToLau[i]
         */
        __attribute__((unused)) bool IsPointerOperand[2] = { false, false };
        Value *Ops[2];
        for(int OpIx = 0; OpIx < 2; ++OpIx) {
            Ops[OpIx] = I.getOperand(OpIx);
            if(PtrToIntInst* SubOp = dyn_cast<PtrToIntInst>(Ops[OpIx])) {
            	Ops[OpIx] = SubOp->getOperand(0);
            	IsPointerOperand[OpIx] = true;
            }
        }
        unsigned Carry = (I.getOpcode() == Instruction::Add) ? 0 : 1;
        E = ACtx->list(Cmd)
              ->append(BitWidth)
              ->append(buildOperand(Ops[0]))
              ->append(buildOperand(Ops[1]))
              ->append(ACtx->dec_unsigned(1,Carry));
    } else if(BinOpType == Mul) {
        E = buildMultiplication(BitWidth, I.getOperand(0), I.getOperand(1));
    } else if(BinOpType == DivRem) {
        E = ACtx->list(Cmd)
              ->append(BitWidth)
              ->append(BitWidth)
              ->append(buildOperand(I.getOperand(0)))
              ->append(buildOperand(I.getOperand(1)));
    } else if(BinOpType == Logic) {
        E = ACtx->list(Cmd)
              ->append(BitWidth)
              ->append(buildOperand(I.getOperand(0)))
              ->append(buildOperand(I.getOperand(1)));
    } else if(BinOpType == Shift) {
        E = ACtx->list(Cmd)
              ->append(BitWidth)
              ->append(BitWidth)
              ->append(buildOperand(I.getOperand(0)))
              ->append(buildOperand(I.getOperand(1)));
    } else if(BinOpType == FpOp) {
        E = ACtx->list(Cmd)
              ->append(getExpWidth(OpTy))
              ->append(getFracWidth(OpTy))
              ->append(buildOperand(I.getOperand(0)))
              ->append(buildOperand(I.getOperand(1)));
    } else {
        assert(0 && "visitBinaryOperator: Invalid BinOpType");
    } // end if: binary op kinds
  } // end if: neg/fneg/binary
  setVisitorResult(I,E);
}

/// emit cmp expression
//  Note that (in constrast to C Backend) we do not need signedness casts
void ALFTranslator::visitICmpInst(ICmpInst &I) {
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
  SExpr *E = ACtx->list(Cmd)
               ->append(BitWidth)
               ->append(buildOperand(I.getOperand(0)))
               ->append(buildOperand(I.getOperand(1)));
  setVisitorResult(I,E);
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
void ALFTranslator::visitFCmpInst(FCmpInst &I) {

  SExpr *E;
  Type* OpTy = I.getOperand(0)->getType();
  if (I.getPredicate() == FCmpInst::FCMP_FALSE) {
    E = ACtx->dec_unsigned(1,0);
  } else if (I.getPredicate() == FCmpInst::FCMP_TRUE) {
    E = ACtx->dec_unsigned(1,1);
  } else if (I.getPredicate() == FCmpInst::FCMP_UNO) {
    E = ACtx->undefined(OpTy->getPrimitiveSizeInBits());
  } else if (I.getPredicate() == FCmpInst::FCMP_ORD) {
    // FIXME: good translation of ORD(x,y)
    E = ACtx->undefined(OpTy->getPrimitiveSizeInBits());
  } else {
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
      E = ACtx->list(Cmd)
            ->append(getExpWidth(OpTy))
            ->append(getFracWidth(OpTy))
            ->append(buildOperand(I.getOperand(0)))
            ->append(buildOperand(I.getOperand(1)));
  }
  setVisitorResult(I,E);
}



// GEP Instructions ~ address arithmetic
void ALFTranslator::visitGetElementPtrInst(GetElementPtrInst &GepIns) {

	Value *Ptr = GepIns.getPointerOperand();
	gep_type_iterator S = gep_type_begin(GepIns), E = gep_type_end(GepIns);

	unsigned BitWidth =  getBitWidth(Ptr->getType());
	assert(BitWidth == TD->getPointerSizeInBits() && "bad pointer bit width");

	SmallVector<std::pair<Value*, int64_t>, 4> Offsets;

    // Pointer arithmetic
    for (gep_type_iterator I = S; I != E; ++I) {
        if (isa<Constant>(I.getOperand()) && cast<Constant>(I.getOperand())->isNullValue())
            continue;
        Offsets.push_back(getBitOffset(cast<CompositeType>(*I), I.getOperand()));
    }
    setVisitorResult(GepIns, buildPointer(Ptr, Offsets));
}

/// Load a value from a frame, if it is of scalar value type.
/// For volatile types, return a load from or a reference to
/// a volatile frame of the right size.
/// For non-scalar types, this is a statement instruction (not an
/// expression instruction); it copies all values using
/// multiple load/store pairs.
/// FIXME: alignment issues are ignored for now
void ALFTranslator::visitLoadInst(LoadInst &I) {
  SExpr *OpExpr = buildOperand(I.getOperand(0));
  SExpr *Expr;
  Type *ResultTy = I.getType();
  bool VolatileAccess = I.isVolatile() && ! IgnoreVolatiles;
  if(isScalarValueType(ResultTy)) {
      Expr = loadScalar(ResultTy, OpExpr, VolatileAccess);
      setVisitorResult(I,Expr);
  }  else {
      addCopyStatements(ResultTy, OpExpr, ACtx->address(getValueName(&I)), VolatileAccess);
      return;
  }
}

SExpr* ALFTranslator::loadScalar(Type *Ty, SExpr *SrcExpr, bool VolatileAccess) {
    if(VolatileAccess) {
        return ACtx->load(getBitWidth(Ty),getVolatileStorage(Ty),0);
    } else {
        return ACtx->list("load")
                   ->append(getBitWidth(Ty))
                   ->append(SrcExpr);
    }
}

void ALFTranslator::addCopyStatements(Type *DstTy, SExpr *SrcExpr, SExpr *DstExpr, bool VolatileAccess,  uint64_t Offset) {
    if(isScalarValueType(DstTy)) {
        SExpr *LoadExpr = loadScalar(DstTy, buildPointer(SrcExpr, Offset), VolatileAccess);
        addStatement(ACtx->store(buildPointer(DstExpr, Offset), LoadExpr));
        return;
    }
    if(StructType *STy = dyn_cast<StructType>(DstTy)) {
        unsigned Ix = 0;
        for(StructType::element_iterator I = STy->element_begin(), E = STy->element_end(); I!=E; ++I, ++Ix) {
            addCopyStatements(*I, SrcExpr, DstExpr, VolatileAccess, Offset+getBitOffset(STy,Ix));
        }
    } else if(ArrayType *ArrTy = dyn_cast<ArrayType>(DstTy)) {
        for(unsigned Ix = 0; Ix < ArrTy->getNumElements(); ++Ix) {
            addCopyStatements(ArrTy->getElementType(), SrcExpr, DstExpr, VolatileAccess, Offset+getBitOffset(ArrTy,Ix));
        }
    } else {
        alf_fatal_error("Unsupported composite value type for copying");
    }
}

/// extract value translates to a load (as we do never load composite types)
void ALFTranslator::visitExtractValueInst(ExtractValueInst &EVI) {
    Type *ResultTy = EVI.getType();
    CompositeType *AggTy = cast<CompositeType>(EVI.getAggregateOperand()->getType());
    assert(isa<CompositeType>(AggTy) && "visitExtractValueInst: expecting composite operand type");

    int64_t BitOffset = getBitOffset(AggTy, EVI.getIndices());
    SExpr *OpExpr = buildPointer(buildOperand(EVI.getAggregateOperand()),BitOffset);
    if(isScalarValueType(ResultTy)) {
        SExpr *Expr = loadScalar(ResultTy, OpExpr, false);
        setVisitorResult(EVI,Expr);
    }  else {
        addCopyStatements(ResultTy, OpExpr, ACtx->address(getValueName(&EVI)));
        return;
    }
}

// insert value corresponds to copy, replacing the value of the updated element
void ALFTranslator::visitInsertValueInst(InsertValueInst &IVI) {
    assert(isa<CompositeType>(IVI.getType()) && "visitInsertValueInst: expecting composite return type");
    CompositeType  *AggType  = cast<CompositeType>(IVI.getType());
    Value *OldValue = IVI.getAggregateOperand();
    Value *Update   = IVI.getInsertedValueOperand();
    addCopyStatements(AggType, buildOperand(OldValue), ACtx->address(getValueName(&IVI)));
    int64_t BitOffset = getBitOffset(AggType, IVI.getIndices());
    if(isScalarValueType(Update->getType())) {
        SExpr *LHS = ACtx->address(getValueName(&IVI),BitOffset);
        SExpr *RHS = buildOperand(Update);
        addStatement(ACtx->store(LHS,RHS));
    } else {
        addCopyStatements(Update->getType(), buildOperand(Update), ACtx->address(getValueName(&IVI), BitOffset));
    }
}

void ALFTranslator::visitExtractElementInst(ExtractElementInst &I) {
  alf_fatal_error("unsupported: visitExtractElementInst", I);
}


void ALFTranslator::visitInsertElementInst(InsertElementInst &I) {
  alf_fatal_error("unsupported: visitInsertElementInst", I);
}


void ALFTranslator::visitShuffleVectorInst(ShuffleVectorInst &SVI) {
    alf_fatal_error("unsupported: visitShuffleVectorInst", SVI);
}

void ALFTranslator::visitCastInst(CastInst &I) {

  Value* Operand = I.getOperand(0);

  Type *SrcTy = I.getSrcTy();
  Type *DstTy = I.getDestTy();

  IntegerType *SrcTyInt = dyn_cast<IntegerType>(SrcTy);
  IntegerType *DstTyInt = dyn_cast<IntegerType>(DstTy);

  SExpr *E = 0;
  switch(I.getOpcode()) {
  case Instruction::Trunc:
    assert(SrcTyInt && DstTyInt && "Trunc: both operands need to be integer types");
    E = buildIntCast(Operand, getBitWidth(SrcTyInt), getBitWidth(DstTyInt), false);
    break;
  case Instruction::SExt:
    assert(SrcTyInt && DstTyInt && "SExt: both operands need to be integer types");
    E = buildIntCast(Operand, getBitWidth(SrcTyInt), getBitWidth(DstTyInt), true);
    break;
  case Instruction::ZExt:
    assert(SrcTyInt && DstTyInt && "ZExt: both operands need to be integer types");
    E = buildIntCast(Operand, getBitWidth(SrcTyInt), getBitWidth(DstTyInt), false);
    break;
  case Instruction::FPTrunc:
	E = buildFPCast(Operand, SrcTy, DstTy, true);
	break;
  case Instruction::FPExt:
	E = buildFPCast(Operand, SrcTy, DstTy, false);
	break;

  // Pointers (which might be symbolic memory addresses) cannot be coerced to integers in ALF
  case Instruction::PtrToInt:
      alf_warning("Unsupported PtrToInt instruction (emitting undefined)");
      E = ACtx->undefined(getBitWidth(DstTy))
            ->setComment("undefined ptr2int");
	  break;
  case Instruction::IntToPtr:
      alf_warning("Unsupported IntToPtr instruction (emitting undefined)");
      E = ACtx->undefined(getBitWidth(DstTy))
            ->setComment("undefined int2ptr");
	  break;
  // XXX: do LLVM and ALF have the same semantics for these instructions? (tests/float2.ll)
  case Instruction::FPToUI:
  case Instruction::FPToSI:
	  E = buildFPIntCast(Operand, SrcTy, DstTy, I.getOpcode());
	  break;
  case Instruction::UIToFP:
  case Instruction::SIToFP:
	  E = buildFPIntCast(Operand, DstTy, SrcTy, I.getOpcode());
	  break;
  case Instruction::BitCast:
    /* nop and ignore pointer <-> pointer bitcasts */
	if(SrcTy == DstTy) {
		E = buildOperand(Operand);
	} else if(isPtrPtrBitCast(I)){
		DEBUG(dbgs() << "Warning: LLVM->ALF: Ignoring ptr2ptr BitCast\n");
		assert(TD->getTypeAllocSizeInBits(I.getType()) ==
			   TD->getTypeAllocSizeInBits(Operand->getType()) && "bitcast between type of different size");
		E = buildOperand(Operand);
	} else {
	    alf_fatal_error("unsupported BitCast instruction", I);
	}
	break;
  default:
      llvm_unreachable(0);
  }
  setVisitorResult(I,E);
}


/// BuildOperand detects whether the operand should be inlined or
/// not. If yes, the expression is emitted, otherwise a load of
/// the corresponding local variable is emited.
SExpr* ALFTranslator::buildOperand(Value *Operand) {

    if (Constant *CPV = dyn_cast<Constant>(Operand)) {
    	return buildExpression(CPV);
    }
    Instruction *I = dyn_cast<Instruction>(Operand);
    if(I && isInlinableInst(*I)) {
        return buildExpression(Operand);
    }
    // Load the named operand (for value types), or return
    // an address referencing the operand (for composite types)
    if(isScalarValueType(Operand->getType())) {
        return ACtx->load(getBitWidth(Operand->getType()),getValueName(Operand));
    } else {
        return ACtx->address(getValueName(Operand), 0);
    }
}

// Add unconditional jump from Block to Succ. Before that, set all PHI nodes
// defined in the successor block
ALFStatement* ALFTranslator::addUnconditionalJump(BasicBlock* Block, BasicBlock* Succ) {
    unsigned Ix = 0;
    for (BasicBlock::iterator I = Succ->begin(); isa<PHINode>(I); ++I, ++Ix) {
        PHINode *PN = cast<PHINode>(I);
        Value *IV = PN->getIncomingValueForBlock(Block);
        if (!isa<UndefValue>(IV)) {
            SExpr* Code = ACtx->store(ACtx->address(getValueName(I)),buildOperand(IV));
            Code->setComment("Assign to PHI node");
            addStatement(Code);
        }
    }
    return addStatement(ACtx->jump(getBasicBlockLabel(Succ)));
}


// Add switch statement. The phi variables are now set in an extra basic block inserted
// between the predecessors and sucessor.
void ALFTranslator::addSwitch(TerminatorInst& SI,
		                   Value* Condition,
		                   const CaseVector& Cases,
		                   BasicBlock* DefaultCase) {

	  BasicBlock *BB = SI.getParent();

	  std::set<BasicBlock*> EdgeBlocks;
	  SExprList *Code = ACtx->list("switch")
	                        ->append(buildOperand(Condition));
	  for(CaseVector::const_iterator I = Cases.begin(), E = Cases.end(); I!=E; ++I) {
	        SExprList *Target = ACtx->list("target")
	                                ->append(buildOperand(I->first));
		if(isa<PHINode>(I->second->begin())) {
		  /* need to set phi variables on the edge */
		  Target->append(ACtx->labelRef(getInstructionLabel(BB, CurrentInsIndex, getBasicBlockLabel(I->second))));
		  EdgeBlocks.insert(I->second);
		} else {
		  Target->append(ACtx->labelRef(getBasicBlockLabel(I->second)));
		}
		Code->append(Target);
	  }
	  SExprList *DefBranch = ACtx->list("default");
	  if(isa<PHINode>(DefaultCase->begin())) {
	    /* need to set phi variables on the edge */
	    DefBranch->append(ACtx->labelRef(getInstructionLabel(BB, CurrentInsIndex, getBasicBlockLabel(DefaultCase))));
	    EdgeBlocks.insert(DefaultCase);
	  } else {
	    DefBranch->append(ACtx->labelRef(getBasicBlockLabel(DefaultCase)));
	  }
	  Code->append(DefBranch);
	  addStatement(Code);

	  // Insert basic blocks to set phi copies (one for each succ with phi nodes)
	  for(std::set<BasicBlock*>::const_iterator I = EdgeBlocks.begin(), E = EdgeBlocks.end(); I!=E; ++I) {
		  BasicBlock* Succ = *I;
		  setCurrentInstruction(getBasicBlockLabel(Succ));
		  ALFStatement* Jump = addUnconditionalJump(BB, Succ);
		  addMapping(Jump->getLabel(), &SI);
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
SExpr* ALFTranslator::buildConstantExpression(const ConstantExpr* CE) {

	DEBUG(dbgs() << "[llvm2alf]: Emmitting constant expression: " << *CE << "\n");

	std::auto_ptr<ALFConstant> FoldedConstant = foldConstant(CE);

	if(FoldedConstant.get() == 0) {
	    alf_warning("Failed to fold constant expression " + valueToString(*CE) + " -> emiting undefined");
	    return ACtx->undefined(getBitWidth(CE->getType()));
	} else {
	    return FoldedConstant->createSExpr(ACtx);
	}
}

/// Do constant integer and pointer arithmetic.
/// Be careful as pointer offsets are bit-addresses in ALF and byte-addresses in LLVM
/// returns a freshly allocated ALFConstant (constant address, integer or float)
std::auto_ptr<ALFConstant> ALFTranslator::foldConstant(const Constant* Const) {

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
			alf_warning("foldConstant: absolute addresses of functions or labels are not supported");
			return std::auto_ptr<ALFConstant>( 0 );
		}
		for(mem_areas_iterator I = mem_areas_begin(), E = mem_areas_end(); I!=E; ++I) {
			if(I->doesInclude(AbsAddress)) {
				std::string Frame = I->getName();
				uint64_t    FrameOffset = I->getOffset(AbsAddress) * LeastAddrUnit;
				return std::auto_ptr<ALFConstant>( new ALFConstAddress(false, Frame, FrameOffset) );
			}
		}
		if(mem_areas_begin() == mem_areas_end()) {
		  // no memory areas specified, use default catch-all
		  return std::auto_ptr<ALFConstant>( new ALFConstAddress(false, ABS_REF, AbsAddress * LeastAddrUnit) );
		} else {
		  alf_warning("foldConstant: invalid absolute address (not specified on the command line): " + utostr(AbsAddress));
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
			alf_warning("Unsupported instruction in constant expression: " + valueToString(*CE));
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

std::auto_ptr<ALFConstant> ALFTranslator::foldBinaryConstantExpression(const ConstantExpr* CE) {

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
				    alf_warning("foldBinaryConstantExpression: Arithmetic on pointers in different frames is undefined");
					return std::auto_ptr<ALFConstant> (0);
				} else if(CE->getOpcode() == Instruction::Add) {
					alf_warning("foldBinaryConstantExpression: Sum of two pointers is undefined");
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
				alf_fatal_error("foldBinaryConstantExpression: In ptr + x, x has the wrong type: " +
						valueToString(*CE->getOperand(1)));
			}
		} else if(ALFConstAddress* AddrRight = dyn_cast<ALFConstAddress>(OpRight.get())) {
			// Offs <op> Addr
			if(CE->getOpcode() == Instruction::Add && IntegerLHS) {
				AddrRight->addOffset(IntegerLHS->getLimitedValue());
				return OpRight;
			} else if(CE->getOpcode() == Instruction::Sub) {
				errs() << "[llvm2alf] Warning: foldBinaryConstantExpression: scalar - pointer is undefined\n";
				return std::auto_ptr<ALFConstant> (0);
			} else {
				alf_fatal_error("foldBinaryConstantExpression: In x + ptr, x has the wrong type: " +
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
int64_t ALFTranslator::getConstantPointerOffset(const ConstantExpr* CE) {

	assert(CE->getOpcode() == Instruction::GetElementPtr && "[llvm2alf]: getConstantPointerOffset(): Not a GEP expression");

	int64_t BitOffset = 0;

	// Calculate offset
	for (gep_type_iterator I = gep_type_begin(CE), E = gep_type_end(CE); I != E; ++I) {

		assert(isa<CompositeType>(*I) && "getConstantPointerOffset: not a composite type");
		if(ConstantInt* EIx = dyn_cast<ConstantInt>(I.getOperand())) {
			BitOffset += getBitOffset(cast<CompositeType>(*I),EIx->getLimitedValue());
		} else {
			alf_fatal_error("getConstantPointerOffset: Non constant index for composite type "
			                   "in constant GEP expression: " + valueToString(*I.getOperand()));
		}
	}

	return BitOffset;
}

// Pointers and run-time address arithmetic
SExpr* ALFTranslator::buildPointer(Value *Ptr, SmallVectorImpl<std::pair<Value*, int64_t> >& Offsets)
{
    // Pass 1: Fold constants
    int PtrBitWidth = getBitWidth(Ptr->getType());
    int64_t ConstantOffset = 0;
    SmallVector<std::pair<Value*, int64_t>, 4> DynamicOffsets;
    for (SmallVectorImpl<std::pair<Value*, int64_t> >::iterator I = Offsets.begin(), E = Offsets.end();
         I != E; ++I) {
        if (! I->first) {
            ConstantOffset += I->second;
        } else if( ConstantInt* EIx = dyn_cast<ConstantInt>(I->first)) {
            ConstantOffset += EIx->getSExtValue() * I->second;
        } else {
            DynamicOffsets.push_back(*I);
        }
    }
    // Build Operand (First argument to innermost add, if any)
    SExpr* Expr = buildPointer(buildOperand(Ptr), ConstantOffset);
    // Build offset calculation (innermost to outermost)
    for (SmallVectorImpl<std::pair<Value*, int64_t> >::reverse_iterator I = DynamicOffsets.rbegin(), E = DynamicOffsets.rend();
         I != E; ++I) {
        Type* IndexType = IntegerType::get(Ptr->getContext(), PtrBitWidth);
        Constant* IndexMultiplier = ConstantInt::get(IndexType, bitsToLAU(I->second), false);
        Expr = ACtx->add(PtrBitWidth, Expr,
                buildMultiplication(PtrBitWidth, I->first, IndexMultiplier));
    }
    return Expr;
}

/// Pointer arithmetic: add/subtract the given offset (in bits) to/from the operand
/// In order to simplify the resulting ALF files, we first check whether the
/// operand expression is a literal address.
SExpr* ALFTranslator::buildPointer(SExpr *OpExpr, int64_t Offset) {
    if(ALFAddressExpr* Addr = dyn_cast<ALFAddressExpr>(OpExpr)) {
        return Addr->withOffset(Offset);
    }
    unsigned BitWidth = ACtx->getConfig()->getBitsFRef();
    if(Offset == 0)
        return OpExpr;
    if(Offset < 0) {
        return ACtx->sub(BitWidth, OpExpr, ACtx->offset(-Offset));
    } else {
        return ACtx->add(BitWidth, OpExpr, ACtx->offset(Offset));
    }
}

// Multiplication takes two operands i<n> A and i<m> B,
// multiplies them to obtain i<n+m> (A*B), and then selects
// the first BitWidth bits of the result (truncate A*B to i<ResultBitWidth>).
// The usual case is to have n=m, selecting the less significant half of the
// multiplication result.
//
// TODO: is it ok to emulate LLVM multiplication this way?
SExpr* ALFTranslator::buildMultiplication(unsigned ResultBitWidth, Value* Op1, Value* Op2) {
  unsigned BitWidth1 = getBitWidth(Op1->getType());
  unsigned BitWidth2 = getBitWidth(Op2->getType());
  if(BitWidth1+BitWidth2 < ResultBitWidth) {
      alf_fatal_error("[llvm2alf] emitMultiplication(): Invalid Size of operands");
  }
  SExpr *Mul = ACtx->list("u_mul")
                 ->append(BitWidth1)
                 ->append(BitWidth2)
                 ->append(buildOperand(Op1))
                 ->append(buildOperand(Op2));
  return ACtx->list("select")
            ->append(BitWidth1 + BitWidth2)
            ->append((uint64_t)0)
            ->append(ResultBitWidth - 1)
            ->append(Mul);
}

/// emit a cast between integer types
SExpr* ALFTranslator::buildIntCast(Value* Operand, unsigned BitWidthSrc, unsigned BitWidthDst, bool signExtend) {
  SExpr *OpExpr = buildOperand(Operand);
  if(BitWidthSrc > BitWidthDst) { // truncate
    return ACtx->list("select")
              ->append(BitWidthSrc)
              ->append((uint64_t)0)
              ->append(BitWidthDst - 1)
              ->append(OpExpr);
  } else if(BitWidthSrc < BitWidthDst) {
    if(signExtend) {
        return ACtx->list("s_ext")
                  ->append(BitWidthSrc)
                  ->append(BitWidthDst)
                  ->append(OpExpr);
    } else {
      unsigned ZExtWidth = BitWidthDst - BitWidthSrc;
      return ACtx->list("conc")
                ->append(ZExtWidth)
                ->append(BitWidthSrc)
                ->append(ACtx->dec_unsigned(ZExtWidth,0))
                ->append(OpExpr);
    }
  } else { // nop
      return OpExpr;
  }
}

// Emit a cast between floating point types
SExpr* ALFTranslator::buildFPCast(Value* Operand, Type* SrcTy, Type* DstTy, bool isTrunc) {
    return ACtx->list("f_to_f")
              ->append(getExpWidth(SrcTy))
              ->append(getExpWidth(DstTy))
              ->append(getFracWidth(SrcTy))
              ->append(getFracWidth(DstTy))
              ->append(buildOperand(Operand));
}

// Emit cast from floating point to integer
SExpr* ALFTranslator::buildFPIntCast(Value* Operand, Type* FloatTy, Type* IntTy, Instruction::CastOps Opcode) {

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
		  alf_fatal_error("emitFPIntCast: invalid opcode: "+utostr(Opcode));
	}
    return ACtx->list(op)
              ->append(getExpWidth(FloatTy))
              ->append(getFracWidth(FloatTy))
              ->append(getBitWidth(IntTy))
              ->append(buildOperand(Operand));
}


std::string ALFTranslator::getValueName(const Value *Operand) {

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

std::string ALFTranslator::getBlockName(const BasicBlock *BB) {
 if(! BB->hasName()) {
	  return getAnonValueName(BB);
  } else {
	  return BB->getName().str();
  }
}

std::string ALFTranslator::getBasicBlockLabel(const BasicBlock* BB) {
  return BB->getParent()->getName().str() + "::" + getBlockName(BB);
}

void ALFTranslator::setCurrentInstruction(Instruction *I, unsigned Index) {
    if(CurrentHelperBlock) {
        delete CurrentHelperBlock;
        CurrentHelperBlock = 0;
    }
    CurrentInstruction = I;
    CurrentInsIndex = Index;
    CurrentInsCounter = 0;
    // Add basic block mapping, if this is the first statement in the current ALF statement group
    if(CurrentBlock->empty()) {
        addMapping(getBasicBlockLabel(I->getParent()), I);
    }
    // add mapping from the instruction to the corresponding ALF statement
    addMapping(getInstructionLabel(I->getParent(),CurrentInsIndex), I);
}

void ALFTranslator::setCurrentInstruction(const std::string& TempBlockLabel) {
    CurrentHelperBlock  = new std::string(TempBlockLabel);
    CurrentInsCounter   = 0;
}

void ALFTranslator::addMapping(const StringRef Label, Instruction *I) {
    std::string File, Function;
    int Line, Col;
    if(getDebugLocation(I,File,Line,Col)) {
        Builder.addMapping(Label, File + ";" + utostr(Line) + ";" + utostr(Col));
    }
}

bool ALFTranslator::getDebugLocation(Instruction *I, std::string& File, int &Line, int &Col) {
    DebugLoc Loc = I->getDebugLoc();
    DISubprogram SubProgram;
    if(MDNode* Scope = Loc.getScope(I->getContext())) {
        SubProgram = getDISubprogram(Scope);
        if(SubProgram.Verify()) {
            File = SubProgram.getFilename().str();
            Line = Loc.getLine();
            Col  = Loc.getCol();
            return true;
        }
    } else {
        DEBUG(alf_warning("No debug information for instruction " + I->getParent()->getName() + ":" + valueToString(*I)));
    }
    return false;
}

std::string ALFTranslator::getInstructionLabel(const BasicBlock *BB, unsigned Index) {
    return getBasicBlockLabel(BB) + "::" + utostr(Index);
}

std::string ALFTranslator::getInstructionLabel(const BasicBlock *BB, unsigned Index, const std::string& HelperBlock) {
    return getInstructionLabel(BB, Index) + "::" + HelperBlock;
}

std::string ALFTranslator::getAnonValueName(const Value* Operand) {
	unsigned &No = AnonValueNumbers[Operand];
	if (No == 0) {
		No = ++NextAnonValueNumber;
		AnonValueNumbers[Operand] = No;
	}
	return utostr(No);
}

int64_t ALFTranslator::getBitOffset(CompositeType* Ty, int64_t Index) {

	if(StructType *StrucTy = dyn_cast<StructType>(Ty)) {
		return TD->getStructLayout(StrucTy)->getElementOffsetInBits(Index);
	} else if(const SequentialType *SeqTy = dyn_cast<SequentialType>(Ty)) {
		return TD->getTypeAllocSize(SeqTy->getElementType()) * Index * 8;
	} else {
		alf_fatal_error("getBitOffset: CompositeType which is neither struct nor sequential", *Ty);
	}
}

int64_t ALFTranslator::getBitOffset(CompositeType *Ty, ArrayRef<unsigned> Indices)
{
    int64_t BitOffset = 0;
    Type *OpTy = Ty;
    for (ArrayRef<unsigned>::iterator I = Indices.begin(), E = Indices.end(); I!=E; ++I) {
        CompositeType *Agg = cast<CompositeType>(OpTy);
        BitOffset += getBitOffset(Agg, *I);
        OpTy = Agg->getTypeAtIndex(*I);
    }
    return BitOffset;
}

std::pair<Value*, int64_t> ALFTranslator::getBitOffset(CompositeType* Ty, Value* Index) {

    if (ConstantInt* CI = dyn_cast<ConstantInt>(Index)) {
        int64_t Offset = getBitOffset(Ty, CI->getSExtValue());
        return std::make_pair((Value*)0, Offset);
    } else if(const SequentialType *SeqTy = dyn_cast<SequentialType>(Ty)) {
        // Sequential types: offset is index times element size
        int64_t ElementBitWidth = TD->getTypeAllocSize(SeqTy->getElementType()) * 8;
        return std::make_pair(Index, ElementBitWidth);
    } else {
        alf_fatal_error("visitGetElementPtrInst: Unexpected/Unsupported type in address arithmetic", *Ty);
    }
}


// This converts the llvm constraint string to something gcc is expecting.
// TODO: currently unused
std::string ALFTranslator::interpretASMConstraint(InlineAsm::ConstraintInfo& c) {
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


