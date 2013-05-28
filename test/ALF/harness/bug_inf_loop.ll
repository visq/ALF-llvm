; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

define void @loop() nounwind {
bb:
  call void @llvm.dbg.value(metadata !9, i64 0, metadata !10), !dbg !12
  br label %bb1, !dbg !13

bb1:                                              ; preds = %bb2, %bb
  %x.0 = phi i32 [ 1, %bb ], [ %tmp3, %bb2 ]
  %tmp = icmp eq i32 %x.0, 0, !dbg !13
  br i1 %tmp, label %bb4, label %bb2, !dbg !13

bb2:                                              ; preds = %bb1
  %tmp3 = add nsw i32 %x.0, 2, !dbg !13
  call void @llvm.dbg.value(metadata !{i32 %tmp3}, i64 0, metadata !10), !dbg !13
  br label %bb1, !dbg !13

bb4:                                              ; preds = %bb1
  ret void, !dbg !14
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define i32 @main(i32 %argc, i8** %argv) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %argc}, i64 0, metadata !15), !dbg !16
  call void @llvm.dbg.value(metadata !{i8** %argv}, i64 0, metadata !17), !dbg !21
  %tmp = icmp sgt i32 %argc, 1, !dbg !22
  br i1 %tmp, label %bb1, label %bb2, !dbg !22

bb1:                                              ; preds = %bb
  call void @loop(), !dbg !22
  br label %bb2, !dbg !22

bb2:                                              ; preds = %bb1, %bb
  ret i32 0, !dbg !24
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0, !5}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"loop", metadata !"loop", metadata !"", metadata !1, i32 1, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, void ()* @loop} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"bug_inf_loop.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 12, metadata !"bug_inf_loop.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !4, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{null}
!5 = metadata !{i32 589870, i32 0, metadata !1, metadata !"main", metadata !"main", metadata !"", metadata !1, i32 7, metadata !6, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32, i8**)* @main} ; [ DW_TAG_subprogram ]
!6 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !7, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!7 = metadata !{metadata !8}
!8 = metadata !{i32 589860, metadata !2, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!9 = metadata !{i32 1}
!10 = metadata !{i32 590080, metadata !11, metadata !"x", metadata !1, i32 2, metadata !8, i32 0} ; [ DW_TAG_auto_variable ]
!11 = metadata !{i32 589835, metadata !0, i32 1, i32 13, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!12 = metadata !{i32 2, i32 14, metadata !11, null}
!13 = metadata !{i32 3, i32 5, metadata !11, null}
!14 = metadata !{i32 5, i32 1, metadata !11, null}
!15 = metadata !{i32 590081, metadata !5, metadata !"argc", metadata !1, i32 16777223, metadata !8, i32 0} ; [ DW_TAG_arg_variable ]
!16 = metadata !{i32 7, i32 14, metadata !5, null}
!17 = metadata !{i32 590081, metadata !5, metadata !"argv", metadata !1, i32 33554439, metadata !18, i32 0} ; [ DW_TAG_arg_variable ]
!18 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !19} ; [ DW_TAG_pointer_type ]
!19 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !20} ; [ DW_TAG_pointer_type ]
!20 = metadata !{i32 589860, metadata !2, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!21 = metadata !{i32 7, i32 27, metadata !5, null}
!22 = metadata !{i32 8, i32 5, metadata !23, null}
!23 = metadata !{i32 589835, metadata !5, i32 7, i32 33, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!24 = metadata !{i32 9, i32 5, metadata !23, null}
