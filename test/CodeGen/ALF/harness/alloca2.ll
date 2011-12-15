; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

define i32 @f(i32 %n) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %n}, i64 0, metadata !10), !dbg !11
  call void @llvm.dbg.value(metadata !12, i64 0, metadata !13), !dbg !15
  %tmp = alloca i32, i32 %n, align 4
  call void @llvm.dbg.declare(metadata !{i32* %tmp}, metadata !16), !dbg !20
  %tmp1 = bitcast i32* %tmp to i8*, !dbg !21
  %tmp2 = shl i32 %n, 2, !dbg !21
  call void @llvm.memset.p0i8.i32(i8* %tmp1, i8 3, i32 %tmp2, i32 4, i1 false), !dbg !21
  call void @llvm.dbg.value(metadata !12, i64 0, metadata !22), !dbg !23
  br label %bb3, !dbg !23

bb3:                                              ; preds = %bb10, %bb
  %i.0 = phi i32 [ 0, %bb ], [ %tmp11, %bb10 ]
  %tmp4 = icmp slt i32 %i.0, %n, !dbg !23
  br i1 %tmp4, label %bb5, label %bb12, !dbg !23

bb5:                                              ; preds = %bb3
  %tmp6 = getelementptr inbounds i32* %tmp, i32 %i.0, !dbg !24
  %tmp7 = load i32* %tmp6, align 4, !dbg !24
  %tmp8 = and i32 %tmp7, 255, !dbg !24
  %tmp9 = getelementptr inbounds i32* %tmp, i32 %i.0, !dbg !24
  store i32 %tmp8, i32* %tmp9, align 4, !dbg !24
  br label %bb10, !dbg !27

bb10:                                             ; preds = %bb5
  %tmp11 = add nsw i32 %i.0, 1, !dbg !28
  call void @llvm.dbg.value(metadata !{i32 %tmp11}, i64 0, metadata !22), !dbg !28
  br label %bb3, !dbg !28

bb12:                                             ; preds = %bb3
  call void @llvm.dbg.value(metadata !29, i64 0, metadata !22), !dbg !30
  br label %bb13, !dbg !30

bb13:                                             ; preds = %bb22, %bb12
  %i.1 = phi i32 [ 1, %bb12 ], [ %tmp23, %bb22 ]
  %tmp14 = icmp slt i32 %i.1, %n, !dbg !30
  br i1 %tmp14, label %bb15, label %bb24, !dbg !30

bb15:                                             ; preds = %bb13
  %tmp16 = add nsw i32 %i.1, -1, !dbg !31
  %tmp17 = getelementptr inbounds i32* %tmp, i32 %tmp16, !dbg !31
  %tmp18 = load i32* %tmp17, align 4, !dbg !31
  %tmp19 = getelementptr inbounds i32* %tmp, i32 %i.1, !dbg !31
  %tmp20 = load i32* %tmp19, align 4, !dbg !31
  %tmp21 = add i32 %tmp20, %tmp18, !dbg !31
  store i32 %tmp21, i32* %tmp19, align 4, !dbg !31
  br label %bb22, !dbg !34

bb22:                                             ; preds = %bb15
  %tmp23 = add nsw i32 %i.1, 1, !dbg !35
  call void @llvm.dbg.value(metadata !{i32 %tmp23}, i64 0, metadata !22), !dbg !35
  br label %bb13, !dbg !35

bb24:                                             ; preds = %bb13
  call void @llvm.dbg.value(metadata !12, i64 0, metadata !22), !dbg !36
  br label %bb25, !dbg !36

bb25:                                             ; preds = %bb28, %bb24
  %i.2 = phi i32 [ 0, %bb24 ], [ %tmp32, %bb28 ]
  %sum.0 = phi i32 [ 0, %bb24 ], [ %tmp31, %bb28 ]
  %tmp26 = icmp slt i32 %i.2, %n, !dbg !36
  br i1 %tmp26, label %bb27, label %bb33, !dbg !36

bb27:                                             ; preds = %bb25
  call void @llvm.dbg.value(metadata !{i32 %tmp31}, i64 0, metadata !13), !dbg !37
  br label %bb28, !dbg !40

bb28:                                             ; preds = %bb27
  %tmp29 = getelementptr inbounds i32* %tmp, i32 %i.2, !dbg !37
  %tmp30 = load i32* %tmp29, align 4, !dbg !37
  %tmp31 = add i32 %sum.0, %tmp30, !dbg !37
  %tmp32 = add nsw i32 %i.2, 1, !dbg !41
  call void @llvm.dbg.value(metadata !{i32 %tmp32}, i64 0, metadata !22), !dbg !41
  br label %bb25, !dbg !41

bb33:                                             ; preds = %bb25
  ret i32 %sum.0, !dbg !42
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare i8* @llvm.stacksave() nounwind

declare void @llvm.memset.p0i8.i32(i8* nocapture, i8, i32, i32, i1) nounwind

declare void @llvm.stackrestore(i8*) nounwind

define i32 @main(i32 %argc, i8** %argv) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %argc}, i64 0, metadata !43), !dbg !44
  call void @llvm.dbg.value(metadata !{i8** %argv}, i64 0, metadata !45), !dbg !49
  %tmp = call i32 @f(i32 3), !dbg !50
  %tmp1 = call i32 @f(i32 7), !dbg !50
  %tmp2 = call i32 @f(i32 15), !dbg !50
  call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !52), !dbg !50
  ret i32 0, !dbg !53
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0, !6}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"f", metadata !"f", metadata !"", metadata !1, i32 7, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32)* @f} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"alloca2.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 12, metadata !"alloca2.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !4, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5}
!5 = metadata !{i32 589860, metadata !2, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589870, i32 0, metadata !1, metadata !"main", metadata !"main", metadata !"", metadata !1, i32 26, metadata !7, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32, i8**)* @main} ; [ DW_TAG_subprogram ]
!7 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !8, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!8 = metadata !{metadata !9}
!9 = metadata !{i32 589860, metadata !2, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!10 = metadata !{i32 590081, metadata !0, metadata !"n", metadata !1, i32 16777222, metadata !9, i32 0} ; [ DW_TAG_arg_variable ]
!11 = metadata !{i32 6, i32 20, metadata !0, null}
!12 = metadata !{i32 0}
!13 = metadata !{i32 590080, metadata !14, metadata !"sum", metadata !1, i32 9, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!14 = metadata !{i32 589835, metadata !0, i32 7, i32 1, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!15 = metadata !{i32 9, i32 25, metadata !14, null}
!16 = metadata !{i32 590080, metadata !14, metadata !"array", metadata !1, i32 10, metadata !17, i32 0} ; [ DW_TAG_auto_variable ]
!17 = metadata !{i32 589825, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 32, i32 0, i32 0, metadata !5, metadata !18, i32 0, i32 0} ; [ DW_TAG_array_type ]
!18 = metadata !{metadata !19}
!19 = metadata !{i32 589857, i64 0, i64 0}        ; [ DW_TAG_subrange_type ]
!20 = metadata !{i32 10, i32 18, metadata !14, null}
!21 = metadata !{i32 12, i32 5, metadata !14, null}
!22 = metadata !{i32 590080, metadata !14, metadata !"i", metadata !1, i32 8, metadata !9, i32 0} ; [ DW_TAG_auto_variable ]
!23 = metadata !{i32 13, i32 5, metadata !14, null}
!24 = metadata !{i32 14, i32 9, metadata !25, null}
!25 = metadata !{i32 589835, metadata !26, i32 13, i32 28, metadata !1, i32 2} ; [ DW_TAG_lexical_block ]
!26 = metadata !{i32 589835, metadata !14, i32 13, i32 5, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!27 = metadata !{i32 15, i32 5, metadata !25, null}
!28 = metadata !{i32 13, i32 23, metadata !26, null}
!29 = metadata !{i32 1}
!30 = metadata !{i32 16, i32 5, metadata !14, null}
!31 = metadata !{i32 17, i32 9, metadata !32, null}
!32 = metadata !{i32 589835, metadata !33, i32 16, i32 28, metadata !1, i32 4} ; [ DW_TAG_lexical_block ]
!33 = metadata !{i32 589835, metadata !14, i32 16, i32 5, metadata !1, i32 3} ; [ DW_TAG_lexical_block ]
!34 = metadata !{i32 18, i32 5, metadata !32, null}
!35 = metadata !{i32 16, i32 23, metadata !33, null}
!36 = metadata !{i32 19, i32 5, metadata !14, null}
!37 = metadata !{i32 20, i32 9, metadata !38, null}
!38 = metadata !{i32 589835, metadata !39, i32 19, i32 28, metadata !1, i32 6} ; [ DW_TAG_lexical_block ]
!39 = metadata !{i32 589835, metadata !14, i32 19, i32 5, metadata !1, i32 5} ; [ DW_TAG_lexical_block ]
!40 = metadata !{i32 21, i32 5, metadata !38, null}
!41 = metadata !{i32 19, i32 23, metadata !39, null}
!42 = metadata !{i32 23, i32 1, metadata !14, null}
!43 = metadata !{i32 590081, metadata !6, metadata !"argc", metadata !1, i32 16777241, metadata !9, i32 0} ; [ DW_TAG_arg_variable ]
!44 = metadata !{i32 25, i32 14, metadata !6, null}
!45 = metadata !{i32 590081, metadata !6, metadata !"argv", metadata !1, i32 33554457, metadata !46, i32 0} ; [ DW_TAG_arg_variable ]
!46 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !47} ; [ DW_TAG_pointer_type ]
!47 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !48} ; [ DW_TAG_pointer_type ]
!48 = metadata !{i32 589860, metadata !2, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!49 = metadata !{i32 25, i32 27, metadata !6, null}
!50 = metadata !{i32 28, i32 5, metadata !51, null}
!51 = metadata !{i32 589835, metadata !6, i32 26, i32 1, metadata !1, i32 7} ; [ DW_TAG_lexical_block ]
!52 = metadata !{i32 590080, metadata !51, metadata !"sum", metadata !1, i32 27, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!53 = metadata !{i32 32, i32 5, metadata !51, null}
