; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@array = common global [16 x i32] zeroinitializer, align 4

define i32 @f(i32 %n) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %n}, i64 0, metadata !14), !dbg !15
  call void @llvm.dbg.value(metadata !16, i64 0, metadata !17), !dbg !19
  %tmp = icmp sgt i32 %n, 16, !dbg !20
  br i1 %tmp, label %bb1, label %bb2, !dbg !20

bb1:                                              ; preds = %bb
  br label %bb35, !dbg !20

bb2:                                              ; preds = %bb
  %tmp3 = shl i32 %n, 2, !dbg !21
  call void @llvm.memset.p0i8.i32(i8* bitcast ([16 x i32]* @array to i8*), i8 3, i32 %tmp3, i32 4, i1 false), !dbg !21
  call void @llvm.dbg.value(metadata !16, i64 0, metadata !22), !dbg !23
  br label %bb4, !dbg !23

bb4:                                              ; preds = %bb11, %bb2
  %i.0 = phi i32 [ 0, %bb2 ], [ %tmp12, %bb11 ]
  %tmp5 = icmp slt i32 %i.0, %n, !dbg !23
  br i1 %tmp5, label %bb6, label %bb13, !dbg !23

bb6:                                              ; preds = %bb4
  %tmp7 = getelementptr inbounds [16 x i32]* @array, i32 0, i32 %i.0, !dbg !24
  %tmp8 = load i32* %tmp7, align 4, !dbg !24
  %tmp9 = and i32 %tmp8, 255, !dbg !24
  %tmp10 = getelementptr inbounds [16 x i32]* @array, i32 0, i32 %i.0, !dbg !24
  store i32 %tmp9, i32* %tmp10, align 4, !dbg !24
  br label %bb11, !dbg !27

bb11:                                             ; preds = %bb6
  %tmp12 = add nsw i32 %i.0, 1, !dbg !28
  call void @llvm.dbg.value(metadata !{i32 %tmp12}, i64 0, metadata !22), !dbg !28
  br label %bb4, !dbg !28

bb13:                                             ; preds = %bb4
  call void @llvm.dbg.value(metadata !29, i64 0, metadata !22), !dbg !30
  br label %bb14, !dbg !30

bb14:                                             ; preds = %bb23, %bb13
  %i.1 = phi i32 [ 1, %bb13 ], [ %tmp24, %bb23 ]
  %tmp15 = icmp slt i32 %i.1, %n, !dbg !30
  br i1 %tmp15, label %bb16, label %bb25, !dbg !30

bb16:                                             ; preds = %bb14
  %tmp17 = add nsw i32 %i.1, -1, !dbg !31
  %tmp18 = getelementptr inbounds [16 x i32]* @array, i32 0, i32 %tmp17, !dbg !31
  %tmp19 = load i32* %tmp18, align 4, !dbg !31
  %tmp20 = getelementptr inbounds [16 x i32]* @array, i32 0, i32 %i.1, !dbg !31
  %tmp21 = load i32* %tmp20, align 4, !dbg !31
  %tmp22 = add i32 %tmp21, %tmp19, !dbg !31
  store i32 %tmp22, i32* %tmp20, align 4, !dbg !31
  br label %bb23, !dbg !34

bb23:                                             ; preds = %bb16
  %tmp24 = add nsw i32 %i.1, 1, !dbg !35
  call void @llvm.dbg.value(metadata !{i32 %tmp24}, i64 0, metadata !22), !dbg !35
  br label %bb14, !dbg !35

bb25:                                             ; preds = %bb14
  call void @llvm.dbg.value(metadata !16, i64 0, metadata !22), !dbg !36
  br label %bb26, !dbg !36

bb26:                                             ; preds = %bb29, %bb25
  %i.2 = phi i32 [ 0, %bb25 ], [ %tmp33, %bb29 ]
  %sum.0 = phi i32 [ 0, %bb25 ], [ %tmp32, %bb29 ]
  %tmp27 = icmp slt i32 %i.2, %n, !dbg !36
  br i1 %tmp27, label %bb28, label %bb34, !dbg !36

bb28:                                             ; preds = %bb26
  call void @llvm.dbg.value(metadata !{i32 %tmp32}, i64 0, metadata !17), !dbg !37
  br label %bb29, !dbg !40

bb29:                                             ; preds = %bb28
  %tmp30 = getelementptr inbounds [16 x i32]* @array, i32 0, i32 %i.2, !dbg !37
  %tmp31 = load i32* %tmp30, align 4, !dbg !37
  %tmp32 = add i32 %sum.0, %tmp31, !dbg !37
  %tmp33 = add nsw i32 %i.2, 1, !dbg !41
  call void @llvm.dbg.value(metadata !{i32 %tmp33}, i64 0, metadata !22), !dbg !41
  br label %bb26, !dbg !41

bb34:                                             ; preds = %bb26
  br label %bb35, !dbg !42

bb35:                                             ; preds = %bb34, %bb1
  %.0 = phi i32 [ 0, %bb1 ], [ %sum.0, %bb34 ]
  ret i32 %.0, !dbg !43
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.memset.p0i8.i32(i8* nocapture, i8, i32, i32, i1) nounwind

define i32 @main(i32 %argc, i8** %argv) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %argc}, i64 0, metadata !44), !dbg !45
  call void @llvm.dbg.value(metadata !{i8** %argv}, i64 0, metadata !46), !dbg !50
  %tmp = call i32 @f(i32 3), !dbg !51
  %tmp1 = call i32 @f(i32 7), !dbg !51
  %tmp2 = call i32 @f(i32 15), !dbg !51
  call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !53), !dbg !51
  ret i32 0, !dbg !54
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0, !6}
!llvm.dbg.gv = !{!10}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"f", metadata !"f", metadata !"", metadata !1, i32 9, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32)* @f} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"memset2.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 12, metadata !"memset2.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !4, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5}
!5 = metadata !{i32 589860, metadata !2, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589870, i32 0, metadata !1, metadata !"main", metadata !"main", metadata !"", metadata !1, i32 27, metadata !7, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32, i8**)* @main} ; [ DW_TAG_subprogram ]
!7 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !8, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!8 = metadata !{metadata !9}
!9 = metadata !{i32 589860, metadata !2, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!10 = metadata !{i32 589876, i32 0, metadata !2, metadata !"array", metadata !"array", metadata !"", metadata !1, i32 7, metadata !11, i32 0, i32 1, [16 x i32]* @array} ; [ DW_TAG_variable ]
!11 = metadata !{i32 589825, metadata !2, metadata !"", metadata !2, i32 0, i64 512, i64 32, i32 0, i32 0, metadata !5, metadata !12, i32 0, i32 0} ; [ DW_TAG_array_type ]
!12 = metadata !{metadata !13}
!13 = metadata !{i32 589857, i64 0, i64 15}       ; [ DW_TAG_subrange_type ]
!14 = metadata !{i32 590081, metadata !0, metadata !"n", metadata !1, i32 16777224, metadata !9, i32 0} ; [ DW_TAG_arg_variable ]
!15 = metadata !{i32 8, i32 20, metadata !0, null}
!16 = metadata !{i32 0}
!17 = metadata !{i32 590080, metadata !18, metadata !"sum", metadata !1, i32 11, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!18 = metadata !{i32 589835, metadata !0, i32 9, i32 1, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!19 = metadata !{i32 11, i32 25, metadata !18, null}
!20 = metadata !{i32 12, i32 5, metadata !18, null}
!21 = metadata !{i32 13, i32 5, metadata !18, null}
!22 = metadata !{i32 590080, metadata !18, metadata !"i", metadata !1, i32 10, metadata !9, i32 0} ; [ DW_TAG_auto_variable ]
!23 = metadata !{i32 14, i32 5, metadata !18, null}
!24 = metadata !{i32 15, i32 9, metadata !25, null}
!25 = metadata !{i32 589835, metadata !26, i32 14, i32 28, metadata !1, i32 2} ; [ DW_TAG_lexical_block ]
!26 = metadata !{i32 589835, metadata !18, i32 14, i32 5, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!27 = metadata !{i32 16, i32 5, metadata !25, null}
!28 = metadata !{i32 14, i32 23, metadata !26, null}
!29 = metadata !{i32 1}
!30 = metadata !{i32 17, i32 5, metadata !18, null}
!31 = metadata !{i32 18, i32 9, metadata !32, null}
!32 = metadata !{i32 589835, metadata !33, i32 17, i32 28, metadata !1, i32 4} ; [ DW_TAG_lexical_block ]
!33 = metadata !{i32 589835, metadata !18, i32 17, i32 5, metadata !1, i32 3} ; [ DW_TAG_lexical_block ]
!34 = metadata !{i32 19, i32 5, metadata !32, null}
!35 = metadata !{i32 17, i32 23, metadata !33, null}
!36 = metadata !{i32 20, i32 5, metadata !18, null}
!37 = metadata !{i32 21, i32 9, metadata !38, null}
!38 = metadata !{i32 589835, metadata !39, i32 20, i32 28, metadata !1, i32 6} ; [ DW_TAG_lexical_block ]
!39 = metadata !{i32 589835, metadata !18, i32 20, i32 5, metadata !1, i32 5} ; [ DW_TAG_lexical_block ]
!40 = metadata !{i32 22, i32 5, metadata !38, null}
!41 = metadata !{i32 20, i32 23, metadata !39, null}
!42 = metadata !{i32 23, i32 5, metadata !18, null}
!43 = metadata !{i32 24, i32 1, metadata !18, null}
!44 = metadata !{i32 590081, metadata !6, metadata !"argc", metadata !1, i32 16777242, metadata !9, i32 0} ; [ DW_TAG_arg_variable ]
!45 = metadata !{i32 26, i32 14, metadata !6, null}
!46 = metadata !{i32 590081, metadata !6, metadata !"argv", metadata !1, i32 33554458, metadata !47, i32 0} ; [ DW_TAG_arg_variable ]
!47 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !48} ; [ DW_TAG_pointer_type ]
!48 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !49} ; [ DW_TAG_pointer_type ]
!49 = metadata !{i32 589860, metadata !2, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!50 = metadata !{i32 26, i32 27, metadata !6, null}
!51 = metadata !{i32 29, i32 5, metadata !52, null}
!52 = metadata !{i32 589835, metadata !6, i32 27, i32 1, metadata !1, i32 7} ; [ DW_TAG_lexical_block ]
!53 = metadata !{i32 590080, metadata !52, metadata !"sum", metadata !1, i32 28, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!54 = metadata !{i32 33, i32 5, metadata !52, null}
