; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

%struct.pint = type { i8, i32 }

@y = global %struct.pint { i8 0, i32 5 }, align 4
@z = global %struct.pint { i8 0, i32 3 }, align 4
@p = global %struct.pint* null, align 4
@q = global i32* bitcast (i8* getelementptr (i8* getelementptr inbounds (%struct.pint* @z, i32 0, i32 0), i64 4) to i32*), align 4
@P = global %struct.pint** @p, align 4
@Q = global i32** @q, align 4

define i32 @main() nounwind {
bb:
  %tmp = load %struct.pint*** @P, align 4, !dbg !22
  %tmp1 = load %struct.pint** %tmp, align 4, !dbg !22
  %tmp2 = icmp eq %struct.pint* %tmp1, @z, !dbg !22
  br i1 %tmp2, label %bb4, label %bb3, !dbg !22

bb3:                                              ; preds = %bb
  store %struct.pint* @z, %struct.pint** @p, align 4, !dbg !24
  br label %bb4, !dbg !26

bb4:                                              ; preds = %bb3, %bb
  %tmp5 = load i32*** @Q, align 4, !dbg !27
  %tmp6 = load i32** %tmp5, align 4, !dbg !27
  %tmp7 = icmp eq i32* %tmp6, null, !dbg !27
  br i1 %tmp7, label %bb9, label %bb8, !dbg !27

bb8:                                              ; preds = %bb4
  store i32* getelementptr inbounds (%struct.pint* @y, i32 0, i32 1), i32** @q, align 4, !dbg !28
  br label %bb9, !dbg !30

bb9:                                              ; preds = %bb8, %bb4
  %tmp10 = load %struct.pint*** @P, align 4, !dbg !31
  %tmp11 = load %struct.pint** %tmp10, align 4, !dbg !31
  %tmp12 = getelementptr inbounds %struct.pint* %tmp11, i32 0, i32 1, !dbg !31
  %tmp13 = load i32* %tmp12, align 4, !dbg !31
  %tmp14 = shl nsw i32 %tmp13, 1, !dbg !31
  %tmp15 = load i32*** @Q, align 4, !dbg !31
  %tmp16 = load i32** %tmp15, align 4, !dbg !31
  %tmp17 = load i32* %tmp16, align 4, !dbg !31
  %tmp18 = add nsw i32 %tmp14, %tmp17, !dbg !31
  %tmp19 = icmp eq i32 %tmp18, 11, !dbg !31
  br i1 %tmp19, label %bb20, label %bb21, !dbg !31

bb20:                                             ; preds = %bb9
  br label %bb22, !dbg !32

bb21:                                             ; preds = %bb9
  br label %bb22, !dbg !34

bb22:                                             ; preds = %bb21, %bb20
  %.0 = phi i32 [ 0, %bb20 ], [ 1, %bb21 ]
  ret i32 %.0, !dbg !35
}

!llvm.dbg.gv = !{!0, !10, !11, !13, !15, !17}
!llvm.dbg.sp = !{!19}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"y", metadata !"y", metadata !"", metadata !2, i32 2, metadata !3, i32 0, i32 1, %struct.pint* @y} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"np3.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"np3.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589846, metadata !1, metadata !"pint", metadata !2, i32 1, i64 0, i64 0, i64 0, i32 0, metadata !4} ; [ DW_TAG_typedef ]
!4 = metadata !{i32 589843, metadata !1, metadata !"", metadata !2, i32 1, i64 64, i64 32, i32 0, i32 0, i32 0, metadata !5, i32 0, i32 0} ; [ DW_TAG_structure_type ]
!5 = metadata !{metadata !6, metadata !8}
!6 = metadata !{i32 589837, metadata !2, metadata !"_pad", metadata !2, i32 1, i64 8, i64 8, i64 0, i32 0, metadata !7} ; [ DW_TAG_member ]
!7 = metadata !{i32 589860, metadata !1, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!8 = metadata !{i32 589837, metadata !2, metadata !"val", metadata !2, i32 1, i64 32, i64 32, i64 32, i32 0, metadata !9} ; [ DW_TAG_member ]
!9 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!10 = metadata !{i32 589876, i32 0, metadata !1, metadata !"z", metadata !"z", metadata !"", metadata !2, i32 2, metadata !3, i32 0, i32 1, %struct.pint* @z} ; [ DW_TAG_variable ]
!11 = metadata !{i32 589876, i32 0, metadata !1, metadata !"p", metadata !"p", metadata !"", metadata !2, i32 3, metadata !12, i32 0, i32 1, %struct.pint** @p} ; [ DW_TAG_variable ]
!12 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !3} ; [ DW_TAG_pointer_type ]
!13 = metadata !{i32 589876, i32 0, metadata !1, metadata !"q", metadata !"q", metadata !"", metadata !2, i32 4, metadata !14, i32 0, i32 1, i32** @q} ; [ DW_TAG_variable ]
!14 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !9} ; [ DW_TAG_pointer_type ]
!15 = metadata !{i32 589876, i32 0, metadata !1, metadata !"P", metadata !"P", metadata !"", metadata !2, i32 5, metadata !16, i32 0, i32 1, %struct.pint*** @P} ; [ DW_TAG_variable ]
!16 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !12} ; [ DW_TAG_pointer_type ]
!17 = metadata !{i32 589876, i32 0, metadata !1, metadata !"Q", metadata !"Q", metadata !"", metadata !2, i32 6, metadata !18, i32 0, i32 1, i32*** @Q} ; [ DW_TAG_variable ]
!18 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !14} ; [ DW_TAG_pointer_type ]
!19 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 9, metadata !20, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!20 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !21, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!21 = metadata !{metadata !9}
!22 = metadata !{i32 10, i32 3, metadata !23, null}
!23 = metadata !{i32 589835, metadata !19, i32 9, i32 1, metadata !2, i32 0} ; [ DW_TAG_lexical_block ]
!24 = metadata !{i32 11, i32 5, metadata !25, null}
!25 = metadata !{i32 589835, metadata !23, i32 10, i32 16, metadata !2, i32 1} ; [ DW_TAG_lexical_block ]
!26 = metadata !{i32 12, i32 3, metadata !25, null}
!27 = metadata !{i32 13, i32 3, metadata !23, null}
!28 = metadata !{i32 14, i32 5, metadata !29, null}
!29 = metadata !{i32 589835, metadata !23, i32 13, i32 15, metadata !2, i32 2} ; [ DW_TAG_lexical_block ]
!30 = metadata !{i32 15, i32 3, metadata !29, null}
!31 = metadata !{i32 16, i32 3, metadata !23, null}
!32 = metadata !{i32 17, i32 5, metadata !33, null}
!33 = metadata !{i32 589835, metadata !23, i32 16, i32 33, metadata !2, i32 3} ; [ DW_TAG_lexical_block ]
!34 = metadata !{i32 19, i32 3, metadata !23, null}
!35 = metadata !{i32 20, i32 1, metadata !23, null}
