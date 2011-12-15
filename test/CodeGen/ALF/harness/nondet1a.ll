; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@i8_init = global i8 -18, align 1
@u32_init = global i32 3, align 4
@i8_ptr = global i8* @i8_init, align 4
@u32_ptr = global i32* @u32_init, align 4

define signext i8 @nondet_i8() nounwind {
bb:
  %tmp = load i8** @i8_ptr, align 4
  %tmp1 = volatile load i8* %tmp, align 1
  ret i8 %tmp1
}

define i32 @nondet_u32(i32 %lb, i32 %ub) nounwind {
bb:
  %tmp = load i32** @u32_ptr, align 4
  %tmp1 = volatile load i32* %tmp, align 4
  %tmp2 = icmp ult i32 %tmp1, %lb
  %v.0 = select i1 %tmp2, i32 %lb, i32 %tmp1
  %tmp5 = icmp ugt i32 %v.0, %ub
  %v.1 = select i1 %tmp5, i32 %ub, i32 %v.0
  ret i32 %v.1
}

define i32 @main() nounwind {
bb:
  %tmp.i = load i32** @u32_ptr, align 4
  %tmp1.i = volatile load i32* %tmp.i, align 4
  %tmp2.i = icmp ult i32 %tmp1.i, 3
  %v.0.i = select i1 %tmp2.i, i32 3, i32 %tmp1.i
  %tmp5.i = icmp ugt i32 %v.0.i, 7
  %v.1.i = select i1 %tmp5.i, i32 7, i32 %v.0.i
  %tmp1.i9 = volatile load i32* %tmp.i, align 4
  %tmp2.i10 = icmp ult i32 %tmp1.i9, 2
  %v.0.i11 = select i1 %tmp2.i10, i32 2, i32 %tmp1.i9
  %tmp5.i12 = icmp ugt i32 %v.0.i11, 3
  %v.1.i13 = select i1 %tmp5.i12, i32 3, i32 %v.0.i11
  %tmp2 = mul i32 %v.1.i13, %v.1.i
  %tmp.i6 = load i8** @i8_ptr, align 4
  %tmp1.i7 = volatile load i8* %tmp.i6, align 1
  %tmp4 = sext i8 %tmp1.i7 to i32
  %tmp5 = add nsw i32 %tmp2, %tmp4
  ret i32 %tmp5
}
