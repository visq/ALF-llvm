; ModuleID = 'alloca.bc'
; sweet-singlepath check (terminate)
define i32 @f(i32 %a) nounwind {
entry:
  %r = alloca [241 x i32]
  %0 = getelementptr [241 x i32]* %r, i32 0, i32 240
  store i32 %a, i32* %0, align 4
  %1 = getelementptr [241 x i32]* %r, i32 0, i32 240
  %2 = load i32* %1, align 4
  ret i32 %2
}

define i32 @main() nounwind {
entry:
  %expect = add i32 0, 42

  %v = alloca i32
  store i32 42, i32* %v, align 4
  %0 = load i32* %v, align 4
  %ret = call i32 @f(i32 %0) nounwind

  br label %checkreturn
checkreturn:
  %1 = icmp eq i32 %ret, %expect
  br i1 %1, label %return, label %checkreturn
return:
  ret i32 %ret
}
