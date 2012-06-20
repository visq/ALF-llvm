//===-- ALFBuilder.cpp - Creating ALF (Artist2 Language for Flow Analysis) modules --------------===//
//
//                     Benedikt Huber, <benedikt@vmars.tuwien.ac.at>
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
#include <string>
#include <vector>
#include <iostream>
#include <sstream>
#include <llvm/ADT/StringExtras.h>

#include "ALFBuilder.h"

namespace alf {
SExpr* ALFContext::identifier(const Twine& ident) {
    std::string Ident = ident.str();
    std::stringstream QuotedIdent;
    QuotedIdent << "\"";
    for (unsigned i = 0, e = Ident.size(); i != e; ++i) {
        if (Ident[i] == '"' || Ident[i] == '\\') {
            QuotedIdent << "\\";
        }
        QuotedIdent << (char)Ident[i];
    }
    QuotedIdent << "\"";
    return atom(QuotedIdent.str());
}
void ALFBuilder::addInit(const Twine& Name, uint64_t Offset, SExpr* InitValue, bool Volatile) {
    SExpr     *InitRef =  list("ref")->append(identifier(Name))->append(0ULL);
    SExprList *Init = list("init")->append(InitRef)
                              ->append(InitValue);
    if(Volatile) Init->append("volatile");
    Initializers.push_back(Init);
}

void ALFBuilder::writeToFile(ALFOutput& Output) {
    // Initialize ALF file
    Output.startList("alf");
    Output.startList("macro_defs");
    Output.endList("macro_defs");
    Output.lauDef();
    Output.atom(Config.isLittleEndian() ? "little_endian" : "big_endian");

    Output.startList("exports");
    // Global variable exports
    Output.startList("frefs");
    // Export Global Frames
    for(std::vector<Frame*>::iterator I = GlobalFrames.begin(), E = GlobalFrames.end(); I!=E; ++I) {
        if((*I)->getStorage() == ExportedFrame)
            Output.fref((*I)->getFrameRef(), false);
    }
    Output.endList("frefs");
    // Export Labels
    Output.startList("lrefs");
    for(std::vector<ALFFunction*>::iterator I = Functions.begin(), E = Functions.end(); I!=E; ++I) {
        if((*I)->isExported()) {
            Output.lref((*I)->getLabel());
        }
    }
    Output.endList("lrefs");
    Output.endList("exports");
    Output.startList("imports");
    // Import Global Frames
    Output.startList("frefs");
    for(std::vector<Frame*>::iterator I = GlobalFrames.begin(), E = GlobalFrames.end(); I!=E; ++I) {
        if((*I)->getStorage() == ImportedFrame)
            Output.fref((*I)->getFrameRef(), false);
    }
    Output.endList("frefs");
    // Import Labels
    Output.startList("lrefs");
    for(std::vector<std::string>::iterator I = ImportedLabels.begin(), E = ImportedLabels.end(); I!=E; ++I) {
        Output.lref(*I, false);
    }
    Output.endList("lrefs");
    Output.endList("imports");
    // Define Functions
    for(std::vector<ALFFunction*>::iterator I = Functions.begin(), E = Functions.end(); I!=E; ++I) {
        writeFunction(*I, Output);
    }
    Output.endList("alf");
}

void ALFBuilder::writeFunction(ALFFunction* AF, ALFOutput& Output) {
    Output.newline();
    Output.comment(AF->getComment(),false);
    Output.startList("func");
    Output.labelRef(AF->getLabel());
    // Emit formal parameters
    Output.startList("arg_decls");
    for(std::vector<Frame*>::iterator I = AF->args_begin(), E = AF->args_end(); I!=E; ++I) {
        Output.alloc((*I)->getFrameRef(), (*I)->getBitWidth());
    }
    Output.endList("arg_decls");

    // start function scope
    Output.startList("scope"); // DECLS INITS STMTS

    // declare local variables
    Output.startList("decls");
    for(std::vector<Frame*>::iterator I = AF->locals_begin(), E = AF->locals_end(); I!=E; ++I) {
        Output.alloc((*I)->getFrameRef(), (*I)->getBitWidth());
        Output.comment((*I)->getDescription());
    }
    Output.endList("decls");
    Output.startList("inits");
    Output.endList("inits");
    // print the basic blocks
    Output.startList("stmts");
    for(std::vector<ALFStatementGroup*>::iterator I = AF->groups_begin(), E = AF->groups_end(); I!=E; ++I) {
        writeStatementGroup(AF, Output, *I);
    }
    Output.endList("stmts");
    Output.endList("scope");
    Output.endList("func");
}

void ALFBuilder::writeStatementGroup(ALFFunction* AF, ALFOutput& Output, ALFStatementGroup *Group) {
    Output.newline();
    Output.comment("--------- BASIC BLOCK " + Group->getComment() + " ----------",false);
    Output.labelRef(Group->getLabel());
    Output.startList("null");
    Output.endList("null");
    Output.incrementIndent();
    for(std::vector<ALFStatement*>::iterator I = Group->stmts_begin(), E = Group->stmts_end(); I!=E; ++I) {
        Output.newline();
        Output.comment((*I)->getComment(),false);
        Output.labelRef((*I)->getLabel());
        Output.sexpr((*I)->getCode());
    }
    Output.decrementIndent();
}

//void ALFTranslator::basicBlockHeader(const BasicBlock* BB) {

//}

//void ALFTranslator::statementHeader(const Instruction &I, unsigned Index) {
//
//    Output.comment("LLVM expression: " + I.getParent()->getParent()->getName().str() + "::" +
//                   I.getParent()->getName().str(), false);
//    /* output all LLVM instructions combined in this ALF statement. Note that the dependency
//     * relation is acyclic if all PHI nodes are removed
//     */
//    std::vector<const Instruction *> Worklist, Instructions;
//    Worklist.push_back(&I);
//    while(! Worklist.size() == 0) {
//        const Instruction *Ins = Worklist.back();
//        Worklist.pop_back();
//        Instructions.push_back(Ins);
//        for(Instruction::const_op_iterator OI = Ins->op_begin(), OE = Ins->op_end(); OI != OE; ++OI) {
//            if(Instruction* Op = dyn_cast<Instruction>(OI)) {
//                if(isa<PHINode>(Op)) continue;
//                if(! isInlinableInst(*Op)) continue;
//                Worklist.push_back(Op);
//            }
//        }
//    }
//    for(std::vector<const Instruction*>::const_reverse_iterator II = Instructions.rbegin(), IE = Instructions.rend(); IE != II; ++ II) {
//        Output.comment("  " + valueToString(**II), false);
//    }
//
//    CurrentStatementIndex = Index;
//    if(! IsBasicBlockStart) {
//        Output.setStmtLabel(getInstructionLabel(I.getParent(),Index));
//    } else {
//        IsBasicBlockStart = false;
//    }
//}
//Output.newline();
//Output.comment("-------------------- STUB FOR UNDEFINED FUNCTION " + F->getName().str() + " --------------------");
//Output.startList("func");
//Writer.emitFunctionSignature(F);
//Output.startList("scope");
//Output.startList("decls"); Output.endList("decls");
//Output.startList("inits"); Output.endList("inits");
//Output.startList("stmts");
//Output.setStmtLabel(F->getName().str() + "::stub");
//Output.startStmt("return");
//Output.load(Writer.getBitWidth(RTy),Writer.getVolatileStorage(RTy),0);
//Output.endStmt("return");
//Output.endList("stmts");
//Output.endList("scope");
//Output.endList("func");

//Output.newline();
//Output.comment("-------------------- FUNCTION " + F.getName().str() + " --------------------");
//Output.startList("func");
//
//Writer.emitFunctionSignature(&F);
//
//// start function scope
//Output.startList("scope"); // DECLS INITS STMTS
//
//// declare local variables
//Output.startList("decls");
//Output.endList("funcs");
//Output.endList("alf");

} // end namespace alf
