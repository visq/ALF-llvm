//===-- Vectorize.h - Vectorization Transformations -------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This header file defines prototypes for accessor functions that expose passes
// in the Vectorize transformations library.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TRANSFORMS_ALF_H
#define LLVM_TRANSFORMS_ALF_H

#include "llvm/Support/FormattedStream.h"

namespace llvm {

//===----------------------------------------------------------------------===//
//
// Create ALF Pass - create Pass that translates LLVM bitcode to ALF
//
ModulePass *createALFPass();

//===----------------------------------------------------------------------===//
//
// Create ALF Pass - create Pass that translates LLVM bitcode to ALF,
// writing to the specified output stream, and using the specified
// data layout (used by the ALF backend pass).
//
ModulePass *createALFPassWithStream(formatted_raw_ostream &ostream, std::string& DataLayoutDescription);

} // End llvm namespace

#endif
