//===-- ALFBackendTargetInfo.cpp - ALFBackend Target Implementation -------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "ALFTargetMachine.h"
#include "llvm/Module.h"
#include "llvm/Support/TargetRegistry.h"
using namespace llvm;

Target llvm::TheALFBackendTarget;

static unsigned ALFBackend_TripleMatchQuality(const std::string &TT) {
  // This backend always works, but shouldn't be the default in most cases.
  return 1;
}

extern "C" void LLVMInitializeALFBackendTargetInfo() {
  TargetRegistry::RegisterTarget(TheALFBackendTarget, "alf",
                                  "ALF backend",
                                  &ALFBackend_TripleMatchQuality);
}

extern "C" void LLVMInitializeALFBackendTargetMC() {}
