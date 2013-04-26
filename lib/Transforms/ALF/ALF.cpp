//===-- ALF.cpp -----------------------------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements common infrastructure for libLLVMalf.a, which
// implements the translation from LLVM to ALF.
//
//===----------------------------------------------------------------------===//
#include "llvm/InitializePasses.h"
#include "llvm/PassManager.h"
#include "llvm/Analysis/Passes.h"
#include "llvm/Analysis/Verifier.h"
#include "llvm/Transforms/ALF.h"

using namespace llvm;

/// initializeALFPass - initialize passes linked into the
/// alf library
void llvm::initializeALF(PassRegistry &Registry) {
  initializeALFPassPass(Registry);
}

