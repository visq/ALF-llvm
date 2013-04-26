add_llvm_library( LLVMALF
  ALF.cpp ALFPass.cpp ALFTranslator.cpp ALFBuilder.cpp ALFContext.cpp SExpr.cpp
  )
add_dependencies(LLVMALF intrinsics_gen)
