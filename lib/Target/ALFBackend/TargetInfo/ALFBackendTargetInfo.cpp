//===-- ALFBackendTargetInfo.cpp - ALFBackend Target Implementation -----------===//
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

extern "C" void LLVMInitializeALFBackendTargetInfo() { 
  RegisterTarget<> X(TheALFBackendTarget, "alf", "ALF backend");
}

extern "C" void LLVMInitializeALFBackendTargetMC() {}
