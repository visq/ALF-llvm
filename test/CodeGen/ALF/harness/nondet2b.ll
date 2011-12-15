; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@vint_init = global i32 9, align 4
@vint_ptr = global i32* @vint_init, align 4
@tmp = common global i32 0, align 4

define i32 @nondet_int() nounwind {
bb:
  %tmp = load i32** @vint_ptr, align 4, !tbaa !0
  %tmp1 = volatile load i32* %tmp, align 4, !tbaa !3
  ret i32 %tmp1
}

define i32 @main() nounwind {
bb:
  %tmp = load i32** @vint_ptr, align 4, !tbaa !0
  %tmp1 = volatile load i32* %tmp, align 4, !tbaa !3
  %tmp2 = icmp ult i32 %tmp1, 10
  br i1 %tmp2, label %.preheader, label %bb3

.preheader:                                       ; preds = %bb
  store i32 10, i32* @tmp, align 4
  br label %bb3

bb3:                                              ; preds = %.preheader, %bb
  %i.1 = phi i32 [ %tmp1, %bb ], [ 10, %.preheader ]
  %tmp4 = add nsw i32 %i.1, -10
  ret i32 %tmp4
}

!0 = metadata !{metadata !"any pointer", metadata !1}
!1 = metadata !{metadata !"omnipotent char", metadata !2}
!2 = metadata !{metadata !"Simple C/C++ TBAA", null}
!3 = metadata !{metadata !"int", metadata !1}
