//===-- ALFBackend.cpp - Library for converting LLVM code to ALF (Artist2 Language for Flow Analysis) --------------===//
//
// Benedikt Huber, <benedikt@vmars.tuwien.ac.at>
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// The ALF Target invokes the ALF pass (lib/Transforms/ALF), and generates ALF code
// corresponding to the input bitcode file.
//===----------------------------------------------------------------------===//

#include "ALFTargetMachine.h"
#include "llvm/PassManager.h"
#include "llvm/Transforms/ALF.h"
#include "llvm/Support/TargetRegistry.h"

namespace llvm {

// ------------------------------------
// registering and command line options
// ------------------------------------

extern "C" void LLVMInitializeALFBackendTarget() {
  // Register the target
  RegisterTargetMachine<ALFTargetMachine> X(TheALFBackendTarget);
}

//===----------------------------------------------------------------------===//
//                       External Interface declaration
//===----------------------------------------------------------------------===//

// TODO should we run GCLowering / LowerInvoke passes?
bool ALFTargetMachine::addPassesToEmitFile(PassManagerBase &PM,
                                           formatted_raw_ostream &o,
                                           CodeGenFileType FileType,
                                           bool DisableVerify,
                                           AnalysisID StartAfter,
                                           AnalysisID StopAfter) {
  if (FileType != TargetMachine::CGFT_AssemblyFile) return true;

  // Do not simplify CFG by default, as it is difficult to predict the translation this way
  // PM.add(createCFGSimplificationPass());   // clean up after lower invoke.
  std::string DefaultTargetData =
    "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-"
    "i64:64:64-f32:32:32-f64:64:64-"
    "v64:64:64-v128:64:128-a0:0:64-n32-S64";
  // add ALFBackend pass
  PM.add(createALFPassWithStream(o, DefaultTargetData));
  return false;
}

}
