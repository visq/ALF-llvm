//===-- ALFContext.cpp - Creating ALF (Artist2 Language for Flow Analysis) modules --------------===//
//
//                     Benedikt Huber, <benedikt@vmars.tuwien.ac.at>
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
#include <string>
#include <sstream>
#include <llvm/ADT/Twine.h>

#include "ALFContext.h"

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

} // end namespace alf
