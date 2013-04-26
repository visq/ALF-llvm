define i32 @main() nounwind {
entry:
  %call = call float @_sqrt(double 2.5000000e+00)
  %i = fptosi float %call to i32
  %r = sub i32 %i, 2
  ret i32 %r
}
define internal float @_sqrt(double) nounwind {
entry:
  %val.addr = alloca float, align 4
  %val = fptrunc double %0 to float
  store float %val, float* %val.addr, align 4
  %1 = load float* %val.addr, align 4
  ret float %1
}
