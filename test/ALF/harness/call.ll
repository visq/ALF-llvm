; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

define i32 @a(i32 %x) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %x}, i64 0, metadata !8), !dbg !9
  %tmp = call i32 @b(i32 %x), !dbg !10
  %tmp1 = mul nsw i32 %tmp, 7, !dbg !10
  ret i32 %tmp1, !dbg !10
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define i32 @b(i32 %x) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %x}, i64 0, metadata !12), !dbg !13
  %tmp = ashr i32 %x, 1, !dbg !14
  ret i32 %tmp, !dbg !14
}

define i32 @main() nounwind {
bb:
  %tmp = call i32 @b(i32 12), !dbg !16
  call void @llvm.dbg.value(metadata !{i32 %tmp}, i64 0, metadata !18), !dbg !16
  %tmp1 = icmp eq i32 %tmp, 42, !dbg !19
  br i1 %tmp1, label %bb3, label %bb2, !dbg !19

bb2:                                              ; preds = %bb
  br label %bb4, !dbg !19

bb3:                                              ; preds = %bb
  br label %bb4, !dbg !20

bb4:                                              ; preds = %bb3, %bb2
  %.0 = phi i32 [ 1, %bb2 ], [ 0, %bb3 ]
  ret i32 %.0, !dbg !21
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0, !6, !7}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"a", metadata !"a", metadata !"", metadata !1, i32 4, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32)* @a} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"call.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 12, metadata !"call.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !4, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5}
!5 = metadata !{i32 589860, metadata !2, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589870, i32 0, metadata !1, metadata !"b", metadata !"b", metadata !"", metadata !1, i32 7, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32)* @b} ; [ DW_TAG_subprogram ]
!7 = metadata !{i32 589870, i32 0, metadata !1, metadata !"main", metadata !"main", metadata !"", metadata !1, i32 10, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!8 = metadata !{i32 590081, metadata !0, metadata !"x", metadata !1, i32 16777220, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!9 = metadata !{i32 4, i32 11, metadata !0, null}
!10 = metadata !{i32 5, i32 5, metadata !11, null}
!11 = metadata !{i32 589835, metadata !0, i32 4, i32 14, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!12 = metadata !{i32 590081, metadata !6, metadata !"x", metadata !1, i32 16777223, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!13 = metadata !{i32 7, i32 11, metadata !6, null}
!14 = metadata !{i32 8, i32 5, metadata !15, null}
!15 = metadata !{i32 589835, metadata !6, i32 7, i32 14, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!16 = metadata !{i32 12, i32 5, metadata !17, null}
!17 = metadata !{i32 589835, metadata !7, i32 10, i32 12, metadata !1, i32 2} ; [ DW_TAG_lexical_block ]
!18 = metadata !{i32 590080, metadata !17, metadata !"r", metadata !1, i32 11, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!19 = metadata !{i32 13, i32 5, metadata !17, null}
!20 = metadata !{i32 14, i32 5, metadata !17, null}
!21 = metadata !{i32 15, i32 1, metadata !17, null}
