; ModuleID = 'ins_phi_cond'
define i32 @main(i32 %argc, i8** %argv) nounwind {
entry:
  %cmp = icmp eq i32 %argc, 1
  br i1 %cmp, label %IfEqual, label %IfUnequal
IfUnequal:
  br label %IfEqual
IfEqual:
  %r = phi i32 [ 1, %IfUnequal ], [ 0, %entry ]
  ret i32 %r
}
