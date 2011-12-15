; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

define i32 @select(i32 %select) nounwind noinline {
bb:
  call void @llvm.dbg.value(metadata !{i32 %select}, i64 0, metadata !7), !dbg !8
  %tmp = icmp sgt i32 %select, 0, !dbg !9
  %tmp1 = select i1 %tmp, i32 7, i32 13, !dbg !9
  ret i32 %tmp1, !dbg !9
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define i32 @main(i32 %argc, i8** %argv) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %argc}, i64 0, metadata !11), !dbg !12
  call void @llvm.dbg.value(metadata !{i8** %argv}, i64 0, metadata !13), !dbg !17
  call void @llvm.dbg.value(metadata !18, i64 0, metadata !19), !dbg !21
  call void @llvm.dbg.value(metadata !18, i64 0, metadata !22), !dbg !23
  br label %bb1, !dbg !23

bb1:                                              ; preds = %bb4, %bb
  %i.0 = phi i32 [ 0, %bb ], [ %tmp6, %bb4 ]
  %r.0 = phi i32 [ 0, %bb ], [ %tmp5, %bb4 ]
  %tmp = icmp slt i32 %i.0, 1117, !dbg !23
  br i1 %tmp, label %bb2, label %bb7, !dbg !23

bb2:                                              ; preds = %bb1
  %tmp3 = call i32 @select(i32 %i.0), !dbg !24
  call void @llvm.dbg.value(metadata !{i32 %tmp5}, i64 0, metadata !19), !dbg !24
  br label %bb4, !dbg !27

bb4:                                              ; preds = %bb2
  %tmp5 = add nsw i32 %r.0, %tmp3, !dbg !24
  %tmp6 = add nsw i32 %i.0, 1, !dbg !28
  call void @llvm.dbg.value(metadata !{i32 %tmp6}, i64 0, metadata !22), !dbg !28
  br label %bb1, !dbg !28

bb7:                                              ; preds = %bb1
  %tmp8 = icmp eq i32 %r.0, 7825, !dbg !29
  br i1 %tmp8, label %bb10, label %bb9, !dbg !29

bb9:                                              ; preds = %bb7
  br label %bb11, !dbg !29

bb10:                                             ; preds = %bb7
  br label %bb11, !dbg !30

bb11:                                             ; preds = %bb10, %bb9
  %.0 = phi i32 [ 1, %bb9 ], [ 0, %bb10 ]
  ret i32 %.0, !dbg !31
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0, !6}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"select", metadata !"select", metadata !"", metadata !1, i32 3, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32)* @select} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"keyword.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 12, metadata !"keyword.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !4, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5}
!5 = metadata !{i32 589860, metadata !2, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589870, i32 0, metadata !1, metadata !"main", metadata !"main", metadata !"", metadata !1, i32 6, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32, i8**)* @main} ; [ DW_TAG_subprogram ]
!7 = metadata !{i32 590081, metadata !0, metadata !"select", metadata !1, i32 16777219, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!8 = metadata !{i32 3, i32 16, metadata !0, null}
!9 = metadata !{i32 4, i32 5, metadata !10, null}
!10 = metadata !{i32 589835, metadata !0, i32 3, i32 24, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!11 = metadata !{i32 590081, metadata !6, metadata !"argc", metadata !1, i32 16777222, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!12 = metadata !{i32 6, i32 14, metadata !6, null}
!13 = metadata !{i32 590081, metadata !6, metadata !"argv", metadata !1, i32 33554438, metadata !14, i32 0} ; [ DW_TAG_arg_variable ]
!14 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !15} ; [ DW_TAG_pointer_type ]
!15 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !16} ; [ DW_TAG_pointer_type ]
!16 = metadata !{i32 589860, metadata !2, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!17 = metadata !{i32 6, i32 26, metadata !6, null}
!18 = metadata !{i32 0}
!19 = metadata !{i32 590080, metadata !20, metadata !"r", metadata !1, i32 8, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!20 = metadata !{i32 589835, metadata !6, i32 6, i32 32, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!21 = metadata !{i32 8, i32 12, metadata !20, null}
!22 = metadata !{i32 590080, metadata !20, metadata !"i", metadata !1, i32 7, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!23 = metadata !{i32 9, i32 3, metadata !20, null}
!24 = metadata !{i32 10, i32 7, metadata !25, null}
!25 = metadata !{i32 589835, metadata !26, i32 9, i32 30, metadata !1, i32 3} ; [ DW_TAG_lexical_block ]
!26 = metadata !{i32 589835, metadata !20, i32 9, i32 3, metadata !1, i32 2} ; [ DW_TAG_lexical_block ]
!27 = metadata !{i32 11, i32 3, metadata !25, null}
!28 = metadata !{i32 9, i32 25, metadata !26, null}
!29 = metadata !{i32 12, i32 3, metadata !20, null}
!30 = metadata !{i32 13, i32 3, metadata !20, null}
!31 = metadata !{i32 14, i32 1, metadata !20, null}
