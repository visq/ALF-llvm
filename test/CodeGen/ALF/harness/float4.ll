; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

define i32 @main() nounwind {
bb:
  call void @llvm.dbg.value(metadata !6, i64 0, metadata !7), !dbg !10
  call void @llvm.dbg.value(metadata !11, i64 0, metadata !12), !dbg !14
  call void @llvm.dbg.value(metadata !15, i64 0, metadata !16), !dbg !17
  br label %bb1, !dbg !17

bb1:                                              ; preds = %bb17, %bb
  %i.0 = phi i32 [ 0, %bb ], [ %tmp18, %bb17 ]
  %ds.0 = phi double [ 0.000000e+00, %bb ], [ %ds.1, %bb17 ]
  %fs.0 = phi float [ 0.000000e+00, %bb ], [ %fs.1, %bb17 ]
  %tmp = icmp slt i32 %i.0, 101, !dbg !17
  br i1 %tmp, label %bb2, label %bb19, !dbg !17

bb2:                                              ; preds = %bb1
  call void @llvm.dbg.value(metadata !18, i64 0, metadata !19), !dbg !20
  br label %bb3, !dbg !20

bb3:                                              ; preds = %bb6, %bb2
  %j.0 = phi i32 [ 10, %bb2 ], [ %tmp15, %bb6 ]
  %ds.1 = phi double [ %ds.0, %bb2 ], [ %tmp13, %bb6 ]
  %fs.1 = phi float [ %fs.0, %bb2 ], [ %tmp14, %bb6 ]
  %tmp4 = icmp slt i32 %j.0, 101, !dbg !20
  br i1 %tmp4, label %bb5, label %bb16, !dbg !20

bb5:                                              ; preds = %bb3
  call void @llvm.dbg.value(metadata !{float %tmp14}, i64 0, metadata !7), !dbg !23
  call void @llvm.dbg.value(metadata !{double %tmp13}, i64 0, metadata !12), !dbg !26
  br label %bb6, !dbg !27

bb6:                                              ; preds = %bb5
  %tmp7 = sitofp i32 %j.0 to double, !dbg !26
  %tmp8 = sitofp i32 %i.0 to double, !dbg !26
  %tmp9 = sitofp i32 %j.0 to float, !dbg !23
  %tmp10 = sitofp i32 %i.0 to float, !dbg !23
  %tmp11 = fdiv double %tmp8, %tmp7, !dbg !26
  %tmp12 = fdiv float %tmp10, %tmp9, !dbg !23
  %tmp13 = fadd double %ds.1, %tmp11, !dbg !26
  %tmp14 = fadd float %fs.1, %tmp12, !dbg !23
  %tmp15 = add nsw i32 %j.0, 1, !dbg !28
  call void @llvm.dbg.value(metadata !{i32 %tmp15}, i64 0, metadata !19), !dbg !28
  br label %bb3, !dbg !28

bb16:                                             ; preds = %bb3
  br label %bb17, !dbg !29

bb17:                                             ; preds = %bb16
  %tmp18 = add nsw i32 %i.0, 1, !dbg !30
  call void @llvm.dbg.value(metadata !{i32 %tmp18}, i64 0, metadata !16), !dbg !30
  br label %bb1, !dbg !30

bb19:                                             ; preds = %bb1
  %tmp20 = fpext float %fs.0 to double, !dbg !31
  %tmp21 = fcmp ugt double %tmp20, 1.190900e+04, !dbg !31
  br i1 %tmp21, label %bb23, label %bb22, !dbg !31

bb22:                                             ; preds = %bb19
  br label %bb34, !dbg !31

bb23:                                             ; preds = %bb19
  %tmp24 = fcmp ugt double %ds.0, 1.190900e+04, !dbg !32
  br i1 %tmp24, label %bb26, label %bb25, !dbg !32

bb25:                                             ; preds = %bb23
  br label %bb34, !dbg !32

bb26:                                             ; preds = %bb23
  %tmp27 = fpext float %fs.0 to double, !dbg !33
  %tmp28 = fcmp ult double %tmp27, 1.191000e+04, !dbg !33
  br i1 %tmp28, label %bb30, label %bb29, !dbg !33

bb29:                                             ; preds = %bb26
  br label %bb34, !dbg !33

bb30:                                             ; preds = %bb26
  %tmp31 = fcmp ult double %ds.0, 1.191000e+04, !dbg !34
  br i1 %tmp31, label %bb33, label %bb32, !dbg !34

bb32:                                             ; preds = %bb30
  br label %bb34, !dbg !34

bb33:                                             ; preds = %bb30
  br label %bb34, !dbg !35

bb34:                                             ; preds = %bb33, %bb32, %bb29, %bb25, %bb22
  %.0 = phi i32 [ 1, %bb22 ], [ 1, %bb25 ], [ 1, %bb29 ], [ 1, %bb32 ], [ 0, %bb33 ]
  ret i32 %.0, !dbg !36
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"main", metadata !"main", metadata !"", metadata !1, i32 8, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"float4.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 12, metadata !"float4.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !4, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5}
!5 = metadata !{i32 589860, metadata !2, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{float 0.000000e+00}
!7 = metadata !{i32 590080, metadata !8, metadata !"fs", metadata !1, i32 9, metadata !9, i32 0} ; [ DW_TAG_auto_variable ]
!8 = metadata !{i32 589835, metadata !0, i32 8, i32 12, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!9 = metadata !{i32 589860, metadata !2, metadata !"float", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 4} ; [ DW_TAG_base_type ]
!10 = metadata !{i32 9, i32 15, metadata !8, null}
!11 = metadata !{double 0.000000e+00}
!12 = metadata !{i32 590080, metadata !8, metadata !"ds", metadata !1, i32 10, metadata !13, i32 0} ; [ DW_TAG_auto_variable ]
!13 = metadata !{i32 589860, metadata !2, metadata !"double", null, i32 0, i64 64, i64 32, i64 0, i32 0, i32 4} ; [ DW_TAG_base_type ]
!14 = metadata !{i32 10, i32 16, metadata !8, null}
!15 = metadata !{i32 0}
!16 = metadata !{i32 590080, metadata !8, metadata !"i", metadata !1, i32 11, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!17 = metadata !{i32 12, i32 3, metadata !8, null}
!18 = metadata !{i32 10}
!19 = metadata !{i32 590080, metadata !8, metadata !"j", metadata !1, i32 11, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!20 = metadata !{i32 13, i32 5, metadata !21, null}
!21 = metadata !{i32 589835, metadata !22, i32 12, i32 27, metadata !1, i32 2} ; [ DW_TAG_lexical_block ]
!22 = metadata !{i32 589835, metadata !8, i32 12, i32 3, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!23 = metadata !{i32 14, i32 7, metadata !24, null}
!24 = metadata !{i32 589835, metadata !25, i32 13, i32 30, metadata !1, i32 4} ; [ DW_TAG_lexical_block ]
!25 = metadata !{i32 589835, metadata !21, i32 13, i32 5, metadata !1, i32 3} ; [ DW_TAG_lexical_block ]
!26 = metadata !{i32 15, i32 7, metadata !24, null}
!27 = metadata !{i32 16, i32 5, metadata !24, null}
!28 = metadata !{i32 13, i32 25, metadata !25, null}
!29 = metadata !{i32 17, i32 3, metadata !21, null}
!30 = metadata !{i32 12, i32 22, metadata !22, null}
!31 = metadata !{i32 21, i32 3, metadata !8, null}
!32 = metadata !{i32 22, i32 3, metadata !8, null}
!33 = metadata !{i32 23, i32 3, metadata !8, null}
!34 = metadata !{i32 24, i32 3, metadata !8, null}
!35 = metadata !{i32 25, i32 3, metadata !8, null}
!36 = metadata !{i32 26, i32 1, metadata !8, null}
