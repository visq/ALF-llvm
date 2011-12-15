; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

define i64 @pow3(i32 %x) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %x}, i64 0, metadata !6), !dbg !8
  %tmp = icmp ugt i32 %x, 63, !dbg !9
  br i1 %tmp, label %bb2, label %bb3, !dbg !9

bb2:                                              ; preds = %bb
  br label %bb10, !dbg !11

bb3:                                              ; preds = %bb
  call void @llvm.dbg.value(metadata !13, i64 0, metadata !14), !dbg !15
  br label %bb4, !dbg !16

bb4:                                              ; preds = %bb6, %bb3
  %r.0 = phi i64 [ 1, %bb3 ], [ %tmp8, %bb6 ]
  %.01 = phi i32 [ %x, %bb3 ], [ %tmp7, %bb6 ]
  call void @llvm.dbg.value(metadata !{i32 %tmp7}, i64 0, metadata !6), !dbg !16
  %tmp5 = icmp eq i32 %.01, 0, !dbg !16
  br i1 %tmp5, label %bb9, label %bb6, !dbg !16

bb6:                                              ; preds = %bb4
  %tmp7 = add i32 %.01, -1, !dbg !16
  %tmp8 = mul i64 %r.0, 3, !dbg !17
  call void @llvm.dbg.value(metadata !{i64 %tmp8}, i64 0, metadata !14), !dbg !17
  br label %bb4, !dbg !19

bb9:                                              ; preds = %bb4
  br label %bb10, !dbg !20

bb10:                                             ; preds = %bb9, %bb2
  %.0 = phi i64 [ -1, %bb2 ], [ %r.0, %bb9 ]
  ret i64 %.0, !dbg !21
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"pow3", metadata !"pow3", metadata !"", metadata !1, i32 7, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i64 (i32)* @pow3} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"pow3.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 12, metadata !"pow3.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !4, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5}
!5 = metadata !{i32 589860, metadata !2, metadata !"long long unsigned int", null, i32 0, i64 64, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 590081, metadata !0, metadata !"x", metadata !1, i32 16777223, metadata !7, i32 0} ; [ DW_TAG_arg_variable ]
!7 = metadata !{i32 589860, metadata !2, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!8 = metadata !{i32 7, i32 34, metadata !0, null}
!9 = metadata !{i32 8, i32 5, metadata !10, null}
!10 = metadata !{i32 589835, metadata !0, i32 7, i32 37, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!11 = metadata !{i32 9, i32 9, metadata !12, null}
!12 = metadata !{i32 589835, metadata !10, i32 8, i32 45, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!13 = metadata !{i64 1}
!14 = metadata !{i32 590080, metadata !10, metadata !"r", metadata !1, i32 11, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!15 = metadata !{i32 11, i32 29, metadata !10, null}
!16 = metadata !{i32 12, i32 5, metadata !10, null}
!17 = metadata !{i32 13, i32 9, metadata !18, null}
!18 = metadata !{i32 589835, metadata !10, i32 12, i32 20, metadata !1, i32 2} ; [ DW_TAG_lexical_block ]
!19 = metadata !{i32 14, i32 5, metadata !18, null}
!20 = metadata !{i32 15, i32 5, metadata !10, null}
!21 = metadata !{i32 16, i32 1, metadata !10, null}
