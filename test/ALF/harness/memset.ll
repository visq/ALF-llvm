; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

define i32 @main() nounwind {
bb:
  %ones = alloca [16 x i8], align 1
  call void @llvm.dbg.declare(metadata !{[16 x i8]* %ones}, metadata !6), !dbg !13
  %tmp = getelementptr inbounds [16 x i8]* %ones, i32 0, i32 0, !dbg !14
  call void @llvm.memset.p0i8.i32(i8* %tmp, i8 0, i32 16, i32 1, i1 false), !dbg !14
  %tmp1 = getelementptr inbounds [16 x i8]* %ones, i32 0, i32 0, !dbg !15
  store i8 1, i8* %tmp1, align 1, !dbg !15
  call void @llvm.dbg.value(metadata !16, i64 0, metadata !17), !dbg !18
  br label %bb2, !dbg !18

bb2:                                              ; preds = %bb14, %bb
  %i.0 = phi i8 [ 1, %bb ], [ %tmp15, %bb14 ]
  %tmp3 = icmp ult i8 %i.0, 16, !dbg !18
  br i1 %tmp3, label %bb4, label %bb16, !dbg !18

bb4:                                              ; preds = %bb2
  %tmp5 = zext i8 %i.0 to i32, !dbg !19
  %tmp6 = add nsw i32 %tmp5, -1, !dbg !19
  %tmp7 = getelementptr inbounds [16 x i8]* %ones, i32 0, i32 %tmp6, !dbg !19
  %tmp8 = load i8* %tmp7, align 1, !dbg !19
  %tmp9 = add i8 %tmp8, 1
  %tmp10 = zext i8 %i.0 to i32, !dbg !19
  %tmp11 = getelementptr inbounds [16 x i8]* %ones, i32 0, i32 %tmp10, !dbg !19
  %tmp12 = load i8* %tmp11, align 1, !dbg !19
  %tmp13 = add i8 %tmp12, %tmp9
  store i8 %tmp13, i8* %tmp11, align 1, !dbg !19
  br label %bb14, !dbg !22

bb14:                                             ; preds = %bb4
  %tmp15 = add i8 %i.0, 1, !dbg !23
  call void @llvm.dbg.value(metadata !{i8 %tmp15}, i64 0, metadata !17), !dbg !23
  br label %bb2, !dbg !23

bb16:                                             ; preds = %bb2
  call void @llvm.dbg.value(metadata !24, i64 0, metadata !17), !dbg !25
  call void @llvm.dbg.value(metadata !24, i64 0, metadata !26), !dbg !25
  br label %bb17, !dbg !25

bb17:                                             ; preds = %bb20, %bb16
  %sum.0 = phi i32 [ 0, %bb16 ], [ %phitmp, %bb20 ]
  %i.1 = phi i8 [ 0, %bb16 ], [ %tmp26, %bb20 ]
  %tmp18 = icmp ult i8 %i.1, 16, !dbg !25
  br i1 %tmp18, label %bb19, label %bb27, !dbg !25

bb19:                                             ; preds = %bb17
  call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !26), !dbg !27
  br label %bb20, !dbg !30

bb20:                                             ; preds = %bb19
  %tmp21 = zext i8 %i.1 to i32, !dbg !27
  %tmp22 = getelementptr inbounds [16 x i8]* %ones, i32 0, i32 %tmp21, !dbg !27
  %tmp23 = load i8* %tmp22, align 1, !dbg !27
  %tmp24 = zext i8 %tmp23 to i32, !dbg !27
  %tmp25 = add nsw i32 %sum.0, %tmp24, !dbg !27
  %tmp26 = add i8 %i.1, 1, !dbg !31
  call void @llvm.dbg.value(metadata !{i8 %tmp26}, i64 0, metadata !17), !dbg !31
  %phitmp = and i32 %tmp25, 255
  br label %bb17, !dbg !31

bb27:                                             ; preds = %bb17
  %tmp28 = icmp eq i32 %sum.0, 136, !dbg !32
  br i1 %tmp28, label %bb30, label %bb29, !dbg !32

bb29:                                             ; preds = %bb27
  br label %bb31, !dbg !32

bb30:                                             ; preds = %bb27
  br label %bb31, !dbg !33

bb31:                                             ; preds = %bb30, %bb29
  %.0 = phi i32 [ 1, %bb29 ], [ 0, %bb30 ]
  ret i32 %.0, !dbg !34
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.memset.p0i8.i32(i8* nocapture, i8, i32, i32, i1) nounwind

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"main", metadata !"main", metadata !"", metadata !1, i32 5, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"memset.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 12, metadata !"memset.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !4, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5}
!5 = metadata !{i32 589860, metadata !2, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 590080, metadata !7, metadata !"ones", metadata !1, i32 6, metadata !8, i32 0} ; [ DW_TAG_auto_variable ]
!7 = metadata !{i32 589835, metadata !0, i32 5, i32 1, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!8 = metadata !{i32 589825, metadata !2, metadata !"", metadata !2, i32 0, i64 128, i64 8, i32 0, i32 0, metadata !9, metadata !11, i32 0, i32 0} ; [ DW_TAG_array_type ]
!9 = metadata !{i32 589846, metadata !2, metadata !"uint8_t", metadata !1, i32 49, i64 0, i64 0, i64 0, i32 0, metadata !10} ; [ DW_TAG_typedef ]
!10 = metadata !{i32 589860, metadata !2, metadata !"unsigned char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 8} ; [ DW_TAG_base_type ]
!11 = metadata !{metadata !12}
!12 = metadata !{i32 589857, i64 0, i64 15}       ; [ DW_TAG_subrange_type ]
!13 = metadata !{i32 6, i32 11, metadata !7, null}
!14 = metadata !{i32 6, i32 55, metadata !7, null}
!15 = metadata !{i32 8, i32 3, metadata !7, null}
!16 = metadata !{i8 1}                            ; [ DW_TAG_array_type ]
!17 = metadata !{i32 590080, metadata !7, metadata !"i", metadata !1, i32 7, metadata !9, i32 0} ; [ DW_TAG_auto_variable ]
!18 = metadata !{i32 9, i32 3, metadata !7, null}
!19 = metadata !{i32 10, i32 5, metadata !20, null}
!20 = metadata !{i32 589835, metadata !21, i32 9, i32 27, metadata !1, i32 2} ; [ DW_TAG_lexical_block ]
!21 = metadata !{i32 589835, metadata !7, i32 9, i32 3, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!22 = metadata !{i32 11, i32 3, metadata !20, null}
!23 = metadata !{i32 9, i32 22, metadata !21, null}
!24 = metadata !{i8 0}                            
!25 = metadata !{i32 12, i32 3, metadata !7, null}
!26 = metadata !{i32 590080, metadata !7, metadata !"sum", metadata !1, i32 7, metadata !9, i32 0} ; [ DW_TAG_auto_variable ]
!27 = metadata !{i32 13, i32 5, metadata !28, null}
!28 = metadata !{i32 589835, metadata !29, i32 12, i32 33, metadata !1, i32 4} ; [ DW_TAG_lexical_block ]
!29 = metadata !{i32 589835, metadata !7, i32 12, i32 3, metadata !1, i32 3} ; [ DW_TAG_lexical_block ]
!30 = metadata !{i32 14, i32 3, metadata !28, null}
!31 = metadata !{i32 12, i32 28, metadata !29, null}
!32 = metadata !{i32 18, i32 3, metadata !7, null}
!33 = metadata !{i32 19, i32 3, metadata !7, null}
!34 = metadata !{i32 20, i32 1, metadata !7, null}
