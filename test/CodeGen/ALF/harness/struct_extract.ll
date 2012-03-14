
%s1 = type { i8, i16, i32, i32 }
%s2 = type { i8, %s1 }
@a = global %s1 { i8  11, i16 23, i32 35, i32 47  }, align 4
@b = global %s2 { i8  61, %s1 { i8 71, i16 73, i32 87, i32 103 } }, align 4

define i32 @f(%s1* %x, %s2* %y) nounwind {
bb:
  %xs    = load %s1* %x, align 4
  %ys    = load %s2* %y, align 4
  %xs.2  = extractvalue %s1 %xs, 2
  %ys.1.2 = extractvalue %s2 %ys, 1, 2
  %ys.1   = extractvalue %s2 %ys, 1
  %ys.1.3 = extractvalue %s1 %ys.1, 3
  %sum.1  = add i32 %ys.1.2, %ys.1.3
  %sum    = add i32 %xs.2, %sum.1

  ret i32 %sum
}

define i32 @main() nounwind {
entry:
  %result = call i32 @f(%s1* @a, %s2* @b)
  ret i32 %result
  ; check
  ; %check = icmp eq i32 %result, 225
  ; br i1 %check, label %bb3, label %bb2
  ; bb2:
  ; ret i32 1
  ; bb3:
  ; ret i32 0
}
