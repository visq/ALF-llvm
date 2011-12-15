; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@fp = global i16 (i16)* @f, align 4

define signext i16 @f(i16 signext %arg) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i16 %arg}, i64 0, metadata !16), !dbg !17
  %tmp = shl i16 %arg, 1
  ret i16 %tmp, !dbg !18
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define i32 @main() nounwind {
bb:
  %tmp = load i16 (i16)** @fp, align 4, !dbg !20
  %tmp1 = call signext i16 %tmp(i16 signext 8) nounwind, !dbg !20
  call void @llvm.dbg.value(metadata !{i16 %tmp1}, i64 0, metadata !22), !dbg !20
  %tmp2 = icmp eq i16 %tmp1, 16, !dbg !23
  br i1 %tmp2, label %bb4, label %bb3, !dbg !23

bb3:                                              ; preds = %bb
  br label %bb5, !dbg !23

bb4:                                              ; preds = %bb
  br label %bb5, !dbg !24

bb5:                                              ; preds = %bb4, %bb3
  %.0 = phi i32 [ 1, %bb3 ], [ 0, %bb4 ]
  ret i32 %.0, !dbg !25
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0, !7}
!llvm.dbg.gv = !{!11}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"f", metadata !"f", metadata !"", metadata !1, i32 8, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i16 (i16)* @f} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"indirect1.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 12, metadata !"indirect1.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !4, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5}
!5 = metadata !{i32 589846, metadata !2, metadata !"int16_t", metadata !1, i32 38, i64 0, i64 0, i64 0, i32 0, metadata !6} ; [ DW_TAG_typedef ]
!6 = metadata !{i32 589860, metadata !2, metadata !"short", null, i32 0, i64 16, i64 16, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!7 = metadata !{i32 589870, i32 0, metadata !1, metadata !"main", metadata !"main", metadata !"", metadata !1, i32 13, metadata !8, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!8 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !9, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!9 = metadata !{metadata !10}
!10 = metadata !{i32 589860, metadata !2, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!11 = metadata !{i32 589876, i32 0, metadata !2, metadata !"fp", metadata !"fp", metadata !"", metadata !1, i32 11, metadata !12, i32 0, i32 1, i16 (i16)** @fp} ; [ DW_TAG_variable ]
!12 = metadata !{i32 589846, metadata !2, metadata !"fun", metadata !1, i32 7, i64 0, i64 0, i64 0, i32 0, metadata !13} ; [ DW_TAG_typedef ]
!13 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !14} ; [ DW_TAG_pointer_type ]
!14 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !15, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!15 = metadata !{metadata !5, metadata !5}
!16 = metadata !{i32 590081, metadata !0, metadata !"arg", metadata !1, i32 16777224, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!17 = metadata !{i32 8, i32 19, metadata !0, null}
!18 = metadata !{i32 9, i32 5, metadata !19, null}
!19 = metadata !{i32 589835, metadata !0, i32 8, i32 24, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!20 = metadata !{i32 15, i32 5, metadata !21, null}
!21 = metadata !{i32 589835, metadata !7, i32 13, i32 1, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!22 = metadata !{i32 590080, metadata !21, metadata !"r", metadata !1, i32 14, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!23 = metadata !{i32 19, i32 5, metadata !21, null}
!24 = metadata !{i32 20, i32 5, metadata !21, null}
!25 = metadata !{i32 21, i32 1, metadata !21, null}
