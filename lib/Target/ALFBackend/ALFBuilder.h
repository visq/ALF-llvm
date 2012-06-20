//===-- ALFBuilder.h - Creating ALF (Artist2 Language for Flow Analysis) modules --------------===//
//
//                     Benedikt Huber, <benedikt@vmars.tuwien.ac.at>
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
#ifndef __ALF_BUILDER_H__
#define __ALF_BUILDER_H__
#include <vector>
#include <map>

#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/Twine.h"
#include "llvm/ADT/StringMap.h"

#include "SExpr.h"
#include "ALFOutput.h"
#include "ALFContext.h"

using namespace llvm;

// ALF namespace
namespace alf {

/// Representation of "size infinity" for frames
const uint64_t INFTY_BITS = ~0ULL;

/// Storage type for frames (imported, internal, exported, local)
enum FrameStorage { ImportedFrame, InternalFrame, ExportedFrame, LocalFrame, ArgFrame };

/// Type of an ALF frame
struct Frame {
    /// Name of the frame
    std::string FrameName;

    /// Width of the frame in bits
    uint64_t BitWidth;

    /// Storage classifier for the frame
    enum FrameStorage Storage;

    /// Description of the frame
    std::string Description;

    /// Create a new Frame
    Frame(const Twine& frameName, uint64_t bitWidth, enum FrameStorage storage):
        FrameName(frameName.str()), BitWidth(bitWidth), Storage(storage) {
    }
    /// Set description
    void setDescription(const Twine& description) {
        Description = description.str();
    }
    /// Get description
    StringRef getDescription() {
        return StringRef(Description);
    }
    /// Get reference to frame name; valid as long as the Context it was created in is alive
    StringRef getFrameRef() {
        return StringRef(FrameName);
    }
    /// Get frame width in bits
    unsigned getBitWidth() {
        return BitWidth;
    }
    /// Get frame storage classification
    FrameStorage getStorage() {
        return Storage;
    }
};

/**
 *  Idea: add ALF type as ALFExpression meta info
 *  ALF type: int<N>, float<M,N>, address, label
 */

class ALFLabeled {
    std::string Label;
    std::string Comment;
public:
    ALFLabeled(const Twine& label, const Twine& comment) : Label(label.str()), Comment(comment.str()) {}
    const StringRef getLabel() {
        return StringRef(Label);
    }
    const StringRef getComment() {
        return StringRef(Comment);
    }
};

/// ALF statements
class ALFStatement : public ALFLabeled {
    SExpr *Code;
public:
    ALFStatement(const Twine& label, const Twine& comment, SExpr *code) :
        ALFLabeled(label,comment), Code(code) {
    }
    SExpr *getCode() {
        return Code;
    }
};

/// Groups of ALF statements corresponding to Basic Blocks
class ALFStatementGroup : public ALFLabeled {
    std::vector<ALFStatement*> Statements;
public:
    ALFStatementGroup(const Twine &label, const Twine& comment) : ALFLabeled(label,comment) {
    }
    virtual ~ALFStatementGroup() {
        for(std::vector<ALFStatement*>::iterator I = Statements.begin(), E = Statements.end(); I!=E; ++I) {
            delete *I;
        }
    }
    void addStatement(const Twine& Label, const Twine& Comment, SExpr* Code) {
        Code->setInline(false);
        ALFStatement *Statement = new ALFStatement(Label, Comment, Code);
        Statements.push_back(Statement);
    }
    std::vector<ALFStatement*>::iterator stmts_begin() {
        return Statements.begin();
    }
    std::vector<ALFStatement*>::iterator stmts_end() {
        return Statements.end();
    }
};

/// ALF functions
class ALFFunction : public ALFContext, public ALFLabeled {
    std::string Name;
    bool IsExported;
    std::vector<Frame*> FormalParameters;
    std::vector<Frame*> LocalVariables;
    std::vector<ALFStatementGroup*> StatementGroups;
public:
    ALFFunction(ALFConfiguration *Config, const Twine& name, const Twine& label, const Twine& comment) :
        ALFContext(Config), ALFLabeled(label,comment), Name(name.str()) {
    }
    virtual ~ALFFunction() {
        /// XXX: use utility function
        for(std::vector<Frame*>::iterator I = FormalParameters.begin(), E = FormalParameters.end(); I!=E; ++I) {
            delete (*I);
        }
        for(std::vector<Frame*>::iterator I = LocalVariables.begin(), E = LocalVariables.end(); I!=E; ++I) {
            delete (*I);
        }
        for(std::vector<ALFStatementGroup*>::iterator I = StatementGroups.begin(), E = StatementGroups.end(); I!=E; ++I) {
            delete (*I);
        }
    }
    void setExported(bool isExported = true) {
        IsExported = isExported;
    }
    bool isExported() {
        return IsExported;
    }
    void addFormal(const Twine& Name, unsigned BitWidth) {
        Frame* F = new Frame(Name, BitWidth, ArgFrame);
        FormalParameters.push_back(F);
    }
    void addLocal(const Twine& Name, unsigned BitWidth, const Twine &Comment) {
        Frame* F = new Frame(Name, BitWidth, LocalFrame);
        F->setDescription(Comment);
        LocalVariables.push_back(F);
    }
    ALFStatementGroup* addBasicBlock(const Twine& Label, const Twine& Comment) {
        ALFStatementGroup* BB = new ALFStatementGroup(Label, Comment);
        StatementGroups.push_back(BB);
        return BB;
    }
    const StringRef getNameRef() {
        return StringRef(Name);
    }
    std::vector<Frame*>::iterator args_begin() {
        return FormalParameters.begin();
    }
    std::vector<Frame*>::iterator args_end() {
        return FormalParameters.end();
    }
    std::vector<Frame*>::iterator locals_begin() {
        return LocalVariables.begin();
    }
    std::vector<Frame*>::iterator locals_end() {
        return LocalVariables.end();
    }
    std::vector<ALFStatementGroup*>::iterator groups_begin() {
        return StatementGroups.begin();
    }
    std::vector<ALFStatementGroup*>::iterator groups_end() {
        return StatementGroups.end();
    }
};

class ALFBuilder : public ALFContext {
    ALFConfiguration Config;
    ALFOutput &Output;

    /* collections */
    std::vector<std::string> ImportedLabels;
    std::vector<Frame*> GlobalFrames;
    std::vector<SExpr*> Initializers;
    std::vector<ALFFunction*> Functions;

    /// write ALF function to file
    void writeFunction(ALFFunction* AF, ALFOutput& Output);
    /// write ALF Statement group to file
    void writeStatementGroup(ALFFunction* AF, ALFOutput& Output, ALFStatementGroup* Group);

public:
    ALFBuilder(ALFOutput& output) :
        ALFContext(&Config),
        Config(output.getLeastAddrUnit()),
        Output(output) {
    }
    virtual ~ALFBuilder() {
        for(std::vector<Frame*>::iterator I = GlobalFrames.begin(), E = GlobalFrames.end(); I!=E; ++I) {
            delete (*I);
        }
        for(std::vector<ALFFunction*>::iterator I = Functions.begin(), E = Functions.end(); I!=E; ++I) {
            delete (*I);
        }
    }
    /// XXX: remove me (devel purposes)
    ALFOutput& getOutput() {
        return Output;
    }
    void setBitWidths(unsigned LRefBits, unsigned FRefBits, unsigned OffsetBits) {
        Config.setBitWidths(LRefBits, FRefBits, OffsetBits);
    }
    void setLittleEndian(bool IsLittleEndian) {
        Config.setLittleEndian(IsLittleEndian);
    }
    /// write ALF module to file
    void writeToFile(ALFOutput& O);

    void importLabel(std::string& FunctionLabel) {
        ImportedLabels.push_back(FunctionLabel);
    }

    void addFrame(const Twine& FrameName, uint64_t SizeInBits, enum FrameStorage Storage) {
        GlobalFrames.push_back(new Frame(FrameName,SizeInBits,Storage));
    }

    void addInfiniteFrame(const Twine& FrameName, enum FrameStorage Storage) {
        addFrame(FrameName, INFTY_BITS, Storage);
    }

    void addInit(const Twine& Name, uint64_t Offset, SExpr* InitValue, bool Volatile);

    ALFFunction* addFunction(const Twine& Name, const Twine& Label, const Twine& Comment) {
        ALFFunction *AF = new ALFFunction(&Config, Name, Label, Comment);
        Functions.push_back(AF);
        return AF;
    }
};

} // end namespace alf

#endif
