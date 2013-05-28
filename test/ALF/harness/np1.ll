; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@y = global i32 3, align 4
@z = global i32 7, align 4
@p = global i32* null, align 4

define i32 @main() nounwind {
bb:
  %tmp = load i32** @p, align 4, !dbg !10
  %tmp1 = icmp eq i32* %tmp, null, !dbg !10
  br i1 %tmp1, label %bb3, label %bb2, !dbg !10

bb2:                                              ; preds = %bb
  store i32* @z, i32** @p, align 4, !dbg !12
  br label %bb3, !dbg !14

bb3:                                              ; preds = %bb2, %bb
  %tmp4 = load i32** @p, align 4, !dbg !15
  %tmp5 = icmp eq i32* %tmp4, @z, !dbg !15
  br i1 %tmp5, label %bb7, label %bb6, !dbg !15

bb6:                                              ; preds = %bb3
  store i32* @y, i32** @p, align 4, !dbg !16
  br label %bb7, !dbg !18

bb7:                                              ; preds = %bb6, %bb3
  %tmp8 = load i32** @p, align 4, !dbg !19
  %tmp9 = load i32* %tmp8, align 4, !dbg !19
  %tmp10 = icmp eq i32 %tmp9, 3, !dbg !19
  br i1 %tmp10, label %bb11, label %bb12, !dbg !19

bb11:                                             ; preds = %bb7
  br label %bb13, !dbg !20

bb12:                                             ; preds = %bb7
  br label %bb13, !dbg !22

bb13:                                             ; preds = %bb12, %bb11
  %.0 = phi i32 [ 0, %bb11 ], [ -1, %bb12 ]
  ret i32 %.0, !dbg !24
}

!llvm.dbg.gv = !{!0, !4, !5}
!llvm.dbg.sp = !{!7}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"y", metadata !"y", metadata !"", metadata !2, i32 7, metadata !3, i32 0, i32 1, i32* @y} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"np1.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"np1.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!4 = metadata !{i32 589876, i32 0, metadata !1, metadata !"z", metadata !"z", metadata !"", metadata !2, i32 7, metadata !3, i32 0, i32 1, i32* @z} ; [ DW_TAG_variable ]
!5 = metadata !{i32 589876, i32 0, metadata !1, metadata !"p", metadata !"p", metadata !"", metadata !2, i32 8, metadata !6, i32 0, i32 1, i32** @p} ; [ DW_TAG_variable ]
!6 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !3} ; [ DW_TAG_pointer_type ]
!7 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 11, metadata !8, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!8 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !9, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!9 = metadata !{metadata !3}
!10 = metadata !{i32 12, i32 3, metadata !11, null}
!11 = metadata !{i32 589835, metadata !7, i32 11, i32 1, metadata !2, i32 0} ; [ DW_TAG_lexical_block ]
!12 = metadata !{i32 13, i32 5, metadata !13, null}
!13 = metadata !{i32 589835, metadata !11, i32 12, i32 14, metadata !2, i32 1} ; [ DW_TAG_lexical_block ]
!14 = metadata !{i32 14, i32 3, metadata !13, null}
!15 = metadata !{i32 15, i32 3, metadata !11, null}
!16 = metadata !{i32 16, i32 5, metadata !17, null}
!17 = metadata !{i32 589835, metadata !11, i32 15, i32 15, metadata !2, i32 2} ; [ DW_TAG_lexical_block ]
!18 = metadata !{i32 17, i32 3, metadata !17, null}
!19 = metadata !{i32 18, i32 3, metadata !11, null}
!20 = metadata !{i32 19, i32 5, metadata !21, null}
!21 = metadata !{i32 589835, metadata !11, i32 18, i32 15, metadata !2, i32 3} ; [ DW_TAG_lexical_block ]
!22 = metadata !{i32 21, i32 5, metadata !23, null}
!23 = metadata !{i32 589835, metadata !11, i32 20, i32 10, metadata !2, i32 4} ; [ DW_TAG_lexical_block ]
!24 = metadata !{i32 23, i32 1, metadata !11, null}
