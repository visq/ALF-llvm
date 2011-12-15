; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@x = global [4 x i32] [i32 4, i32 3, i32 2, i32 1], align 4
@out = common global i32 0, align 4

define i32 @main(i32 %argc, i8** %argv) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %argc}, i64 0, metadata !12), !dbg !13
  call void @llvm.dbg.value(metadata !{i8** %argv}, i64 0, metadata !14), !dbg !18
  %tmp = load i32* getelementptr inbounds ([4 x i32]* @x, i32 0, i32 1), align 4, !dbg !19
  %tmp1 = load i32* getelementptr inbounds ([4 x i32]* @x, i32 0, i32 3), align 4, !dbg !19
  %tmp2 = add nsw i32 %tmp, %tmp1, !dbg !19
  call void @llvm.dbg.value(metadata !{i32 %tmp2}, i64 0, metadata !21), !dbg !19
  store i32 2, i32* getelementptr inbounds ([4 x i32]* @x, i32 0, i32 1), align 4, !dbg !22
  call void @llvm.dbg.value(metadata !{i32 %tmp2}, i64 0, metadata !23), !dbg !24
  %tmp3 = icmp eq i32 %tmp2, 4, !dbg !25
  br i1 %tmp3, label %bb5, label %bb4, !dbg !25

bb4:                                              ; preds = %bb
  br label %bb6, !dbg !25

bb5:                                              ; preds = %bb
  br label %bb6, !dbg !26

bb6:                                              ; preds = %bb5, %bb4
  %.0 = phi i32 [ 1, %bb4 ], [ 0, %bb5 ]
  ret i32 %.0, !dbg !27
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.gv = !{!0, !7}
!llvm.dbg.sp = !{!9}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"x", metadata !"x", metadata !"", metadata !2, i32 3, metadata !3, i32 0, i32 1, [4 x i32]* @x} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"side_effect.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"side_effect.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 128, i64 32, i32 0, i32 0, metadata !4, metadata !5, i32 0, i32 0} ; [ DW_TAG_array_type ]
!4 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!5 = metadata !{metadata !6}
!6 = metadata !{i32 589857, i64 0, i64 3}         ; [ DW_TAG_subrange_type ]
!7 = metadata !{i32 589876, i32 0, metadata !1, metadata !"out", metadata !"out", metadata !"", metadata !2, i32 1, metadata !8, i32 0, i32 1, i32* @out} ; [ DW_TAG_variable ]
!8 = metadata !{i32 589877, metadata !1, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !4} ; [ DW_TAG_volatile_type ]
!9 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 5, metadata !10, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32, i8**)* @main} ; [ DW_TAG_subprogram ]
!10 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !11, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!11 = metadata !{metadata !4}
!12 = metadata !{i32 590081, metadata !9, metadata !"argc", metadata !2, i32 16777221, metadata !4, i32 0} ; [ DW_TAG_arg_variable ]
!13 = metadata !{i32 5, i32 14, metadata !9, null}
!14 = metadata !{i32 590081, metadata !9, metadata !"argv", metadata !2, i32 33554437, metadata !15, i32 0} ; [ DW_TAG_arg_variable ]
!15 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !16} ; [ DW_TAG_pointer_type ]
!16 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !17} ; [ DW_TAG_pointer_type ]
!17 = metadata !{i32 589860, metadata !1, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!18 = metadata !{i32 5, i32 27, metadata !9, null}
!19 = metadata !{i32 6, i32 24, metadata !20, null}
!20 = metadata !{i32 589835, metadata !9, i32 5, i32 33, metadata !2, i32 0} ; [ DW_TAG_lexical_block ]
!21 = metadata !{i32 590080, metadata !20, metadata !"r", metadata !2, i32 6, metadata !4, i32 0} ; [ DW_TAG_auto_variable ]
!22 = metadata !{i32 7, i32 5, metadata !20, null}
!23 = metadata !{i32 590080, metadata !20, metadata !"t1", metadata !2, i32 8, metadata !4, i32 0} ; [ DW_TAG_auto_variable ]
!24 = metadata !{i32 8, i32 30, metadata !20, null}
!25 = metadata !{i32 9, i32 5, metadata !20, null}
!26 = metadata !{i32 10, i32 5, metadata !20, null}
!27 = metadata !{i32 11, i32 1, metadata !20, null}
