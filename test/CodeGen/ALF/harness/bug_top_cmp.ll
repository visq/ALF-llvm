; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@x = common global i32 0, align 4

define i32 @main(i32 %argc, i8** %argv) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %argc}, i64 0, metadata !8), !dbg !9
  call void @llvm.dbg.value(metadata !{i8** %argv}, i64 0, metadata !10), !dbg !14
  %tmp = icmp slt i32 %argc, 5, !dbg !15
  br i1 %tmp, label %bb1, label %bb2, !dbg !15

bb1:                                              ; preds = %bb
  br label %bb3, !dbg !15

bb2:                                              ; preds = %bb
  volatile store i32 1, i32* @x, align 4, !dbg !17
  br label %bb3, !dbg !18

bb3:                                              ; preds = %bb2, %bb1
  %.0 = phi i32 [ -1, %bb1 ], [ 0, %bb2 ]
  ret i32 %.0, !dbg !19
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}
!llvm.dbg.gv = !{!6}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"main", metadata !"main", metadata !"", metadata !1, i32 9, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32, i8**)* @main} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"bug_top_cmp.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 12, metadata !"bug_top_cmp.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !4, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5}
!5 = metadata !{i32 589860, metadata !2, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589876, i32 0, metadata !2, metadata !"x", metadata !"x", metadata !"", metadata !1, i32 7, metadata !7, i32 0, i32 1, i32* @x} ; [ DW_TAG_variable ]
!7 = metadata !{i32 589877, metadata !2, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !5} ; [ DW_TAG_volatile_type ]
!8 = metadata !{i32 590081, metadata !0, metadata !"argc", metadata !1, i32 16777225, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!9 = metadata !{i32 9, i32 14, metadata !0, null}
!10 = metadata !{i32 590081, metadata !0, metadata !"argv", metadata !1, i32 33554441, metadata !11, i32 0} ; [ DW_TAG_arg_variable ]
!11 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !12} ; [ DW_TAG_pointer_type ]
!12 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !13} ; [ DW_TAG_pointer_type ]
!13 = metadata !{i32 589860, metadata !2, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!14 = metadata !{i32 9, i32 26, metadata !0, null}
!15 = metadata !{i32 10, i32 5, metadata !16, null}
!16 = metadata !{i32 589835, metadata !0, i32 9, i32 32, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!17 = metadata !{i32 11, i32 5, metadata !16, null}
!18 = metadata !{i32 12, i32 5, metadata !16, null}
!19 = metadata !{i32 13, i32 1, metadata !16, null}
