; ModuleID = 'phi.bc'
; sweet-singlepath check (terminate)
; this is an example from the Vellvm paper
define i32 @f() nounwind {
pred:
  br label %loop
loop:
  %x = phi i32 [ %z, %loop ], [ 0, %pred ]
  %z = phi i32 [ %x, %loop ], [ 1, %pred ]
  %b = icmp sle i32 %x, %z
  br i1 %b, label %loop, label %return
return:
  ret i32 0
}

define i32 @main() nounwind {
entry:
  %ret = call i32 @f() nounwind
  ret i32 %ret
}
