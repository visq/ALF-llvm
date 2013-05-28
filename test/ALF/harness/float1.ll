; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@pif = global float 0x400921FB60000000, align 4
@pid = global double 0x400921FB54442D18, align 8

define i32 @main() nounwind {
bb:
  call void @llvm.dbg.value(metadata !10, i64 0, metadata !11), !dbg !13
  call void @llvm.dbg.value(metadata !14, i64 0, metadata !15), !dbg !13
  call void @llvm.dbg.value(metadata !16, i64 0, metadata !17), !dbg !18
  call void @llvm.dbg.value(metadata !19, i64 0, metadata !20), !dbg !18
  call void @llvm.dbg.value(metadata !21, i64 0, metadata !22), !dbg !23
  %tmp = load float* @pif, align 4, !dbg !24
  %tmp1 = fcmp ogt float %tmp, 0x400921FB40000000, !dbg !24
  br i1 %tmp1, label %bb2, label %bb3, !dbg !24

bb2:                                              ; preds = %bb
  call void @llvm.dbg.value(metadata !25, i64 0, metadata !22), !dbg !24
  br label %bb3, !dbg !24

bb3:                                              ; preds = %bb2, %bb
  %r.0 = phi i32 [ 5, %bb2 ], [ 6, %bb ]
  %tmp4 = load double* @pid, align 8, !dbg !26
  %tmp5 = fcmp ogt double %tmp4, 0x400921FB40000000, !dbg !26
  br i1 %tmp5, label %bb6, label %bb8, !dbg !26

bb6:                                              ; preds = %bb3
  %tmp7 = add nsw i32 %r.0, -1, !dbg !26
  call void @llvm.dbg.value(metadata !{i32 %tmp7}, i64 0, metadata !22), !dbg !26
  br label %bb8, !dbg !26

bb8:                                              ; preds = %bb6, %bb3
  %r.1 = phi i32 [ %tmp7, %bb6 ], [ %r.0, %bb3 ]
  %tmp9 = load double* @pid, align 8, !dbg !27
  %tmp10 = fcmp ogt double %tmp9, 0x400921FB54442D15, !dbg !27
  br i1 %tmp10, label %bb11, label %bb13, !dbg !27

bb11:                                             ; preds = %bb8
  %tmp12 = add nsw i32 %r.1, -1, !dbg !27
  call void @llvm.dbg.value(metadata !{i32 %tmp12}, i64 0, metadata !22), !dbg !27
  br label %bb13, !dbg !27

bb13:                                             ; preds = %bb11, %bb8
  %r.2 = phi i32 [ %tmp12, %bb11 ], [ %r.1, %bb8 ]
  %tmp14 = load float* @pif, align 4, !dbg !28
  %tmp15 = fcmp olt float %tmp14, 0x400921FB80000000, !dbg !28
  br i1 %tmp15, label %bb16, label %bb18, !dbg !28

bb16:                                             ; preds = %bb13
  %tmp17 = add nsw i32 %r.2, -1, !dbg !28
  call void @llvm.dbg.value(metadata !{i32 %tmp17}, i64 0, metadata !22), !dbg !28
  br label %bb18, !dbg !28

bb18:                                             ; preds = %bb16, %bb13
  %r.3 = phi i32 [ %tmp17, %bb16 ], [ %r.2, %bb13 ]
  %tmp19 = load double* @pid, align 8, !dbg !29
  %tmp20 = fcmp olt double %tmp19, 0x400921FB80000000, !dbg !29
  br i1 %tmp20, label %bb21, label %bb23, !dbg !29

bb21:                                             ; preds = %bb18
  %tmp22 = add nsw i32 %r.3, -1, !dbg !29
  call void @llvm.dbg.value(metadata !{i32 %tmp22}, i64 0, metadata !22), !dbg !29
  br label %bb23, !dbg !29

bb23:                                             ; preds = %bb21, %bb18
  %r.4 = phi i32 [ %tmp22, %bb21 ], [ %r.3, %bb18 ]
  %tmp24 = load double* @pid, align 8, !dbg !30
  %tmp25 = fcmp olt double %tmp24, 0x400921FB54442D1A, !dbg !30
  br i1 %tmp25, label %bb26, label %bb28, !dbg !30

bb26:                                             ; preds = %bb23
  %tmp27 = add nsw i32 %r.4, -1, !dbg !30
  call void @llvm.dbg.value(metadata !{i32 %tmp27}, i64 0, metadata !22), !dbg !30
  br label %bb28, !dbg !30

bb28:                                             ; preds = %bb26, %bb23
  %r.5 = phi i32 [ %tmp27, %bb26 ], [ %r.4, %bb23 ]
  ret i32 %r.5, !dbg !31
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.gv = !{!0, !4}
!llvm.dbg.sp = !{!6}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"pif", metadata !"pif", metadata !"", metadata !2, i32 2, metadata !3, i32 0, i32 1, float* @pif} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"float1.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"float1.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589860, metadata !1, metadata !"float", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 4} ; [ DW_TAG_base_type ]
!4 = metadata !{i32 589876, i32 0, metadata !1, metadata !"pid", metadata !"pid", metadata !"", metadata !2, i32 3, metadata !5, i32 0, i32 1, double* @pid} ; [ DW_TAG_variable ]
!5 = metadata !{i32 589860, metadata !1, metadata !"double", null, i32 0, i64 64, i64 32, i64 0, i32 0, i32 4} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 5, metadata !7, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!7 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !8, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!8 = metadata !{metadata !9}
!9 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!10 = metadata !{float 0x400921FB40000000}
!11 = metadata !{i32 590080, metadata !12, metadata !"pifl", metadata !2, i32 6, metadata !3, i32 0} ; [ DW_TAG_auto_variable ]
!12 = metadata !{i32 589835, metadata !6, i32 5, i32 12, metadata !2, i32 0} ; [ DW_TAG_lexical_block ]
!13 = metadata !{i32 6, i32 44, metadata !12, null}
!14 = metadata !{float 0x400921FB80000000}
!15 = metadata !{i32 590080, metadata !12, metadata !"pifu", metadata !2, i32 6, metadata !3, i32 0} ; [ DW_TAG_auto_variable ]
!16 = metadata !{double 0x400921FB54442D15}
!17 = metadata !{i32 590080, metadata !12, metadata !"pidl", metadata !2, i32 7, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!18 = metadata !{i32 7, i32 60, metadata !12, null}
!19 = metadata !{double 0x400921FB54442D1A}
!20 = metadata !{i32 590080, metadata !12, metadata !"pidu", metadata !2, i32 7, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!21 = metadata !{i32 6}
!22 = metadata !{i32 590080, metadata !12, metadata !"r", metadata !2, i32 8, metadata !9, i32 0} ; [ DW_TAG_auto_variable ]
!23 = metadata !{i32 8, i32 12, metadata !12, null}
!24 = metadata !{i32 9, i32 3, metadata !12, null}
!25 = metadata !{i32 5}
!26 = metadata !{i32 10, i32 3, metadata !12, null}
!27 = metadata !{i32 11, i32 3, metadata !12, null}
!28 = metadata !{i32 12, i32 3, metadata !12, null}
!29 = metadata !{i32 13, i32 3, metadata !12, null}
!30 = metadata !{i32 14, i32 3, metadata !12, null}
!31 = metadata !{i32 15, i32 3, metadata !12, null}
