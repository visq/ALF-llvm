; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

%0 = type { i8, [3 x [4 x %struct.sB]], i8, [3 x i8] }
%struct.sB = type { i8, i32 }
%struct.tA = type { i8, [3 x [4 x %struct.sB]], i8 }

@out = global i32 1, align 4
@global = global %0 { i8 50, [3 x [4 x %struct.sB]] [[4 x %struct.sB] [%struct.sB { i8 2, i32 28 }, %struct.sB { i8 3, i32 27 }, %struct.sB { i8 4, i32 26 }, %struct.sB { i8 5, i32 25 }], [4 x %struct.sB] [%struct.sB { i8 6, i32 24 }, %struct.sB { i8 7, i32 23 }, %struct.sB { i8 8, i32 22 }, %struct.sB { i8 9, i32 21 }], [4 x %struct.sB] [%struct.sB { i8 10, i32 20 }, %struct.sB { i8 11, i32 19 }, %struct.sB { i8 12, i32 18 }, %struct.sB { i8 13, i32 17 }]], i8 100, [3 x i8] undef }, align 4

define i32 @deref_direct() nounwind {
bb:
  %tmp = load i8* getelementptr inbounds (%0* @global, i32 0, i32 0), align 4, !dbg !27
  %tmp1 = sext i8 %tmp to i32, !dbg !27
  %tmp2 = load i8* getelementptr inbounds (%0* @global, i32 0, i32 2), align 4, !dbg !27
  %tmp3 = sext i8 %tmp2 to i32, !dbg !27
  %tmp4 = add i32 %tmp1, %tmp3, !dbg !27
  call void @llvm.dbg.value(metadata !{i32 %tmp4}, i64 0, metadata !29), !dbg !27
  %tmp5 = icmp eq i32 %tmp4, 150, !dbg !31
  br i1 %tmp5, label %bb7, label %bb6, !dbg !31

bb6:                                              ; preds = %bb
  br label %bb35, !dbg !32

bb7:                                              ; preds = %bb
  call void @llvm.dbg.value(metadata !34, i64 0, metadata !35), !dbg !36
  br label %bb8, !dbg !36

bb8:                                              ; preds = %bb32, %bb7
  %i.0 = phi i32 [ 0, %bb7 ], [ %tmp33, %bb32 ]
  %tmp9 = icmp slt i32 %i.0, 3, !dbg !36
  br i1 %tmp9, label %bb10, label %bb34, !dbg !36

bb10:                                             ; preds = %bb8
  call void @llvm.dbg.value(metadata !34, i64 0, metadata !37), !dbg !38
  br label %bb11, !dbg !38

bb11:                                             ; preds = %bb29, %bb10
  %j.0 = phi i32 [ 0, %bb10 ], [ %tmp30, %bb29 ]
  %tmp12 = icmp slt i32 %j.0, 4, !dbg !38
  br i1 %tmp12, label %bb13, label %bb31, !dbg !38

bb13:                                             ; preds = %bb11
  %tmp14 = getelementptr inbounds %0* @global, i32 0, i32 1, i32 %i.0, i32 %j.0, i32 0, !dbg !41
  %tmp15 = load i8* %tmp14, align 4, !dbg !41
  %tmp16 = sext i8 %tmp15 to i32, !dbg !41
  %tmp17 = getelementptr inbounds %struct.tA* bitcast (%0* @global to %struct.tA*), i32 0, i32 1, i32 %i.0, i32 %j.0, i32 1, !dbg !41
  %tmp18 = load i32* %tmp17, align 4, !dbg !41
  %tmp19 = add i32 %tmp16, %tmp18, !dbg !41
  %tmp20 = icmp eq i32 %tmp19, 30, !dbg !41
  br i1 %tmp20, label %bb28, label %bb21, !dbg !41

bb21:                                             ; preds = %bb13
  %tmp22 = getelementptr inbounds %struct.tA* bitcast (%0* @global to %struct.tA*), i32 0, i32 1, i32 %i.0, i32 %j.0, i32 0, !dbg !44
  %tmp23 = load i8* %tmp22, align 4, !dbg !44
  %tmp24 = sext i8 %tmp23 to i32, !dbg !44
  %tmp25 = getelementptr inbounds %struct.tA* bitcast (%0* @global to %struct.tA*), i32 0, i32 1, i32 %i.0, i32 %j.0, i32 1, !dbg !44
  %tmp26 = load i32* %tmp25, align 4, !dbg !44
  %tmp27 = add i32 %tmp24, %tmp26, !dbg !44
  br label %bb35, !dbg !44

bb28:                                             ; preds = %bb13
  br label %bb29, !dbg !46

bb29:                                             ; preds = %bb28
  %tmp30 = add nsw i32 %j.0, 1, !dbg !47
  call void @llvm.dbg.value(metadata !{i32 %tmp30}, i64 0, metadata !37), !dbg !47
  br label %bb11, !dbg !47

bb31:                                             ; preds = %bb11
  br label %bb32, !dbg !48

bb32:                                             ; preds = %bb31
  %tmp33 = add nsw i32 %i.0, 1, !dbg !49
  call void @llvm.dbg.value(metadata !{i32 %tmp33}, i64 0, metadata !35), !dbg !49
  br label %bb8, !dbg !49

bb34:                                             ; preds = %bb8
  br label %bb35, !dbg !50

bb35:                                             ; preds = %bb34, %bb21, %bb6
  %.0 = phi i32 [ %tmp4, %bb6 ], [ %tmp27, %bb21 ], [ 0, %bb34 ]
  ret i32 %.0, !dbg !51
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define i32 @main(i32 %argc, i8** %argv) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %argc}, i64 0, metadata !52), !dbg !53
  call void @llvm.dbg.value(metadata !{i8** %argv}, i64 0, metadata !54), !dbg !57
  %tmp = call i32 @deref_direct(), !dbg !58
  call void @llvm.dbg.value(metadata !{i32 %tmp}, i64 0, metadata !60), !dbg !58
  %tmp1 = icmp eq i32 %tmp, 0, !dbg !61
  br i1 %tmp1, label %bb2, label %bb3, !dbg !61

bb2:                                              ; preds = %bb
  br label %bb4, !dbg !61

bb3:                                              ; preds = %bb
  br label %bb4, !dbg !62

bb4:                                              ; preds = %bb3, %bb2
  %.0 = phi i32 [ 0, %bb2 ], [ 1, %bb3 ]
  ret i32 %.0, !dbg !63
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.gv = !{!0, !5}
!llvm.dbg.sp = !{!23, !26}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"out", metadata !"out", metadata !"", metadata !2, i32 1, metadata !3, i32 0, i32 1, i32* @out} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"multiarray.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"multiarray.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589877, metadata !1, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !4} ; [ DW_TAG_volatile_type ]
!4 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!5 = metadata !{i32 589876, i32 0, metadata !1, metadata !"global", metadata !"global", metadata !"", metadata !2, i32 14, metadata !6, i32 0, i32 1, %0* @global} ; [ DW_TAG_variable ]
!6 = metadata !{i32 589846, metadata !1, metadata !"tA", metadata !2, i32 12, i64 0, i64 0, i64 0, i32 0, metadata !7} ; [ DW_TAG_typedef ]
!7 = metadata !{i32 589843, metadata !1, metadata !"", metadata !2, i32 8, i64 832, i64 32, i32 0, i32 0, i32 0, metadata !8, i32 0, i32 0} ; [ DW_TAG_structure_type ]
!8 = metadata !{metadata !9, metadata !11, metadata !22}
!9 = metadata !{i32 589837, metadata !2, metadata !"a", metadata !2, i32 9, i64 8, i64 8, i64 0, i32 0, metadata !10} ; [ DW_TAG_member ]
!10 = metadata !{i32 589860, metadata !1, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!11 = metadata !{i32 589837, metadata !2, metadata !"b", metadata !2, i32 10, i64 768, i64 32, i64 32, i32 0, metadata !12} ; [ DW_TAG_member ]
!12 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 768, i64 32, i32 0, i32 0, metadata !13, metadata !19, i32 0, i32 0} ; [ DW_TAG_array_type ]
!13 = metadata !{i32 589846, metadata !1, metadata !"tB", metadata !2, i32 6, i64 0, i64 0, i64 0, i32 0, metadata !14} ; [ DW_TAG_typedef ]
!14 = metadata !{i32 589843, metadata !1, metadata !"sB", metadata !2, i32 3, i64 64, i64 32, i32 0, i32 0, i32 0, metadata !15, i32 0, i32 0} ; [ DW_TAG_structure_type ]
!15 = metadata !{metadata !16, metadata !17}
!16 = metadata !{i32 589837, metadata !2, metadata !"a", metadata !2, i32 4, i64 8, i64 8, i64 0, i32 0, metadata !10} ; [ DW_TAG_member ]
!17 = metadata !{i32 589837, metadata !2, metadata !"b", metadata !2, i32 5, i64 32, i64 32, i64 32, i32 0, metadata !18} ; [ DW_TAG_member ]
!18 = metadata !{i32 589860, metadata !1, metadata !"long unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!19 = metadata !{metadata !20, metadata !21}
!20 = metadata !{i32 589857, i64 0, i64 2}        ; [ DW_TAG_subrange_type ]
!21 = metadata !{i32 589857, i64 0, i64 3}        ; [ DW_TAG_subrange_type ]
!22 = metadata !{i32 589837, metadata !2, metadata !"c", metadata !2, i32 11, i64 8, i64 8, i64 800, i32 0, metadata !10} ; [ DW_TAG_member ]
!23 = metadata !{i32 589870, i32 0, metadata !2, metadata !"deref_direct", metadata !"deref_direct", metadata !"", metadata !2, i32 24, metadata !24, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @deref_direct} ; [ DW_TAG_subprogram ]
!24 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !25, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!25 = metadata !{metadata !4}
!26 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 40, metadata !24, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32, i8**)* @main} ; [ DW_TAG_subprogram ]
!27 = metadata !{i32 25, i32 57, metadata !28, null}
!28 = metadata !{i32 589835, metadata !23, i32 24, i32 20, metadata !2, i32 0} ; [ DW_TAG_lexical_block ]
!29 = metadata !{i32 590080, metadata !28, metadata !"x", metadata !2, i32 25, metadata !30, i32 0} ; [ DW_TAG_auto_variable ]
!30 = metadata !{i32 589860, metadata !1, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!31 = metadata !{i32 26, i32 5, metadata !28, null}
!32 = metadata !{i32 27, i32 9, metadata !33, null}
!33 = metadata !{i32 589835, metadata !28, i32 26, i32 18, metadata !2, i32 1} ; [ DW_TAG_lexical_block ]
!34 = metadata !{i32 0}
!35 = metadata !{i32 590080, metadata !28, metadata !"i", metadata !2, i32 29, metadata !4, i32 0} ; [ DW_TAG_auto_variable ]
!36 = metadata !{i32 30, i32 5, metadata !28, null}
!37 = metadata !{i32 590080, metadata !28, metadata !"j", metadata !2, i32 29, metadata !4, i32 0} ; [ DW_TAG_auto_variable ]
!38 = metadata !{i32 31, i32 9, metadata !39, null}
!39 = metadata !{i32 589835, metadata !40, i32 30, i32 28, metadata !2, i32 3} ; [ DW_TAG_lexical_block ]
!40 = metadata !{i32 589835, metadata !28, i32 30, i32 5, metadata !2, i32 2} ; [ DW_TAG_lexical_block ]
!41 = metadata !{i32 32, i32 13, metadata !42, null}
!42 = metadata !{i32 589835, metadata !43, i32 31, i32 32, metadata !2, i32 5} ; [ DW_TAG_lexical_block ]
!43 = metadata !{i32 589835, metadata !39, i32 31, i32 9, metadata !2, i32 4} ; [ DW_TAG_lexical_block ]
!44 = metadata !{i32 33, i32 17, metadata !45, null}
!45 = metadata !{i32 589835, metadata !42, i32 32, i32 59, metadata !2, i32 6} ; [ DW_TAG_lexical_block ]
!46 = metadata !{i32 35, i32 9, metadata !42, null}
!47 = metadata !{i32 31, i32 27, metadata !43, null}
!48 = metadata !{i32 36, i32 5, metadata !39, null}
!49 = metadata !{i32 30, i32 23, metadata !40, null}
!50 = metadata !{i32 37, i32 5, metadata !28, null}
!51 = metadata !{i32 38, i32 1, metadata !28, null}
!52 = metadata !{i32 590081, metadata !26, metadata !"argc", metadata !2, i32 16777256, metadata !4, i32 0} ; [ DW_TAG_arg_variable ]
!53 = metadata !{i32 40, i32 14, metadata !26, null}
!54 = metadata !{i32 590081, metadata !26, metadata !"argv", metadata !2, i32 33554472, metadata !55, i32 0} ; [ DW_TAG_arg_variable ]
!55 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !56} ; [ DW_TAG_pointer_type ]
!56 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !10} ; [ DW_TAG_pointer_type ]
!57 = metadata !{i32 40, i32 27, metadata !26, null}
!58 = metadata !{i32 42, i32 27, metadata !59, null}
!59 = metadata !{i32 589835, metadata !26, i32 40, i32 33, metadata !2, i32 7} ; [ DW_TAG_lexical_block ]
!60 = metadata !{i32 590080, metadata !59, metadata !"r", metadata !2, i32 42, metadata !4, i32 0} ; [ DW_TAG_auto_variable ]
!61 = metadata !{i32 43, i32 5, metadata !59, null}
!62 = metadata !{i32 44, i32 16, metadata !59, null}
!63 = metadata !{i32 45, i32 1, metadata !59, null}
