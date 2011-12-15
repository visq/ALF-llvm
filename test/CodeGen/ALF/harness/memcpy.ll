; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@main.stack_array = internal constant [20 x i32] [i32 0, i32 1, i32 1, i32 2, i32 3, i32 5, i32 8, i32 13, i32 21, i32 34, i32 55, i32 89, i32 144, i32 233, i32 377, i32 610, i32 987, i32 1597, i32 2584, i32 4181], align 4

define i8* @my_memcpy(i8* %dest, i8* %src, i32 %n) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i8* %dest}, i64 0, metadata !10), !dbg !11
  call void @llvm.dbg.value(metadata !{i8* %src}, i64 0, metadata !12), !dbg !15
  call void @llvm.dbg.value(metadata !{i32 %n}, i64 0, metadata !16), !dbg !19
  call void @llvm.dbg.value(metadata !{i8* %dest}, i64 0, metadata !20), !dbg !24
  call void @llvm.dbg.value(metadata !{i8* %src}, i64 0, metadata !25), !dbg !28
  call void @llvm.dbg.value(metadata !29, i64 0, metadata !30), !dbg !31
  br label %bb1, !dbg !31

bb1:                                              ; preds = %bb6, %bb
  %i.0 = phi i32 [ 0, %bb ], [ %tmp7, %bb6 ]
  %tmp = icmp ult i32 %i.0, %n, !dbg !31
  br i1 %tmp, label %bb2, label %bb8, !dbg !31

bb2:                                              ; preds = %bb1
  %tmp3 = getelementptr inbounds i8* %src, i32 %i.0, !dbg !32
  %tmp4 = load i8* %tmp3, align 1, !dbg !32
  %tmp5 = getelementptr inbounds i8* %dest, i32 %i.0, !dbg !32
  store i8 %tmp4, i8* %tmp5, align 1, !dbg !32
  br label %bb6, !dbg !35

bb6:                                              ; preds = %bb2
  %tmp7 = add i32 %i.0, 1, !dbg !36
  call void @llvm.dbg.value(metadata !{i32 %tmp7}, i64 0, metadata !30), !dbg !36
  br label %bb1, !dbg !36

bb8:                                              ; preds = %bb1
  ret i8* %dest, !dbg !37
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define i32 @main(i32 %argc, i8** %argv) nounwind {
bb:
  %stack_array = alloca [20 x i32], align 4
  %stack_arr2 = alloca [20 x i32], align 4
  call void @llvm.dbg.value(metadata !{i32 %argc}, i64 0, metadata !38), !dbg !39
  call void @llvm.dbg.value(metadata !{i8** %argv}, i64 0, metadata !40), !dbg !42
  call void @llvm.dbg.declare(metadata !{[20 x i32]* %stack_array}, metadata !43), !dbg !48
  %tmp = bitcast [20 x i32]* %stack_array to i8*, !dbg !49
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %tmp, i8* bitcast ([20 x i32]* @main.stack_array to i8*), i32 80, i32 4, i1 false), !dbg !49
  call void @llvm.dbg.declare(metadata !{[20 x i32]* %stack_arr2}, metadata !50), !dbg !51
  call void @llvm.dbg.value(metadata !29, i64 0, metadata !52), !dbg !53
  call void @llvm.dbg.value(metadata !29, i64 0, metadata !54), !dbg !53
  br label %bb1, !dbg !53

bb1:                                              ; preds = %bb8, %bb
  %i.0 = phi i32 [ 0, %bb ], [ %tmp10, %bb8 ]
  %sum.0 = phi i32 [ 0, %bb ], [ %tmp9, %bb8 ]
  %tmp2 = icmp slt i32 %i.0, 20, !dbg !53
  br i1 %tmp2, label %bb3, label %bb11, !dbg !53

bb3:                                              ; preds = %bb1
  %tmp4 = getelementptr inbounds [20 x i32]* %stack_array, i32 0, i32 %i.0, !dbg !55
  %tmp5 = load i32* %tmp4, align 4, !dbg !55
  call void @llvm.dbg.value(metadata !{i32 %tmp9}, i64 0, metadata !54), !dbg !55
  %tmp6 = getelementptr inbounds [20 x i32]* %stack_array, i32 0, i32 %i.0, !dbg !58
  %tmp7 = add nsw i32 %tmp5, 1, !dbg !58
  store i32 %tmp7, i32* %tmp6, align 4, !dbg !58
  br label %bb8, !dbg !59

bb8:                                              ; preds = %bb3
  %tmp9 = add nsw i32 %sum.0, %tmp5, !dbg !55
  %tmp10 = add nsw i32 %i.0, 1, !dbg !60
  call void @llvm.dbg.value(metadata !{i32 %tmp10}, i64 0, metadata !52), !dbg !60
  br label %bb1, !dbg !60

bb11:                                             ; preds = %bb1
  %tmp12 = icmp eq i32 %sum.0, 10945, !dbg !61
  br i1 %tmp12, label %bb14, label %bb13, !dbg !61

bb13:                                             ; preds = %bb11
  br label %bb31, !dbg !61

bb14:                                             ; preds = %bb11
  %tmp15 = bitcast [20 x i32]* %stack_arr2 to i8*, !dbg !62
  %tmp16 = bitcast [20 x i32]* %stack_array to i8*, !dbg !62
  %tmp17 = call i8* @my_memcpy(i8* %tmp15, i8* %tmp16, i32 80), !dbg !62
  call void @llvm.dbg.value(metadata !29, i64 0, metadata !52), !dbg !63
  call void @llvm.dbg.value(metadata !29, i64 0, metadata !54), !dbg !63
  br label %bb18, !dbg !63

bb18:                                             ; preds = %bb21, %bb14
  %i.1 = phi i32 [ 0, %bb14 ], [ %tmp26, %bb21 ]
  %sum.1 = phi i32 [ 0, %bb14 ], [ %tmp25, %bb21 ]
  %tmp19 = icmp slt i32 %i.1, 20, !dbg !63
  br i1 %tmp19, label %bb20, label %bb27, !dbg !63

bb20:                                             ; preds = %bb18
  call void @llvm.dbg.value(metadata !{i32 %tmp25}, i64 0, metadata !54), !dbg !64
  br label %bb21, !dbg !67

bb21:                                             ; preds = %bb20
  %tmp22 = getelementptr inbounds [20 x i32]* %stack_array, i32 0, i32 %i.1, !dbg !64
  %tmp23 = load i32* %tmp22, align 4, !dbg !64
  %tmp24 = add nsw i32 %tmp23, -1, !dbg !64
  %tmp25 = add nsw i32 %sum.1, %tmp24, !dbg !64
  %tmp26 = add nsw i32 %i.1, 1, !dbg !68
  call void @llvm.dbg.value(metadata !{i32 %tmp26}, i64 0, metadata !52), !dbg !68
  br label %bb18, !dbg !68

bb27:                                             ; preds = %bb18
  %tmp28 = icmp eq i32 %sum.1, 10945, !dbg !69
  br i1 %tmp28, label %bb30, label %bb29, !dbg !69

bb29:                                             ; preds = %bb27
  br label %bb31, !dbg !69

bb30:                                             ; preds = %bb27
  br label %bb31, !dbg !70

bb31:                                             ; preds = %bb30, %bb29, %bb13
  %.0 = phi i32 [ 1, %bb13 ], [ 1, %bb29 ], [ 0, %bb30 ]
  ret i32 %.0, !dbg !71
}

declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture, i8* nocapture, i32, i32, i1) nounwind

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0, !6}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"my_memcpy", metadata !"my_memcpy", metadata !"", metadata !1, i32 4, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i8* (i8*, i8*, i32)* @my_memcpy} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"memcpy.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 12, metadata !"memcpy.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !4, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5}
!5 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ]
!6 = metadata !{i32 589870, i32 0, metadata !1, metadata !"main", metadata !"main", metadata !"", metadata !1, i32 16, metadata !7, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32, i8**)* @main} ; [ DW_TAG_subprogram ]
!7 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !8, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!8 = metadata !{metadata !9}
!9 = metadata !{i32 589860, metadata !2, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!10 = metadata !{i32 590081, metadata !0, metadata !"dest", metadata !1, i32 16777219, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!11 = metadata !{i32 3, i32 22, metadata !0, null}
!12 = metadata !{i32 590081, metadata !0, metadata !"src", metadata !1, i32 33554435, metadata !13, i32 0} ; [ DW_TAG_arg_variable ]
!13 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !14} ; [ DW_TAG_pointer_type ]
!14 = metadata !{i32 589862, metadata !2, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, null} ; [ DW_TAG_const_type ]
!15 = metadata !{i32 3, i32 38, metadata !0, null}
!16 = metadata !{i32 590081, metadata !0, metadata !"n", metadata !1, i32 50331651, metadata !17, i32 0} ; [ DW_TAG_arg_variable ]
!17 = metadata !{i32 589846, metadata !2, metadata !"size_t", metadata !1, i32 32, i64 0, i64 0, i64 0, i32 0, metadata !18} ; [ DW_TAG_typedef ]
!18 = metadata !{i32 589860, metadata !2, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!19 = metadata !{i32 3, i32 49, metadata !0, null}
!20 = metadata !{i32 590080, metadata !21, metadata !"d", metadata !1, i32 6, metadata !22, i32 0} ; [ DW_TAG_auto_variable ]
!21 = metadata !{i32 589835, metadata !0, i32 4, i32 1, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!22 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !23} ; [ DW_TAG_pointer_type ]
!23 = metadata !{i32 589860, metadata !2, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!24 = metadata !{i32 6, i32 22, metadata !21, null}
!25 = metadata !{i32 590080, metadata !21, metadata !"s", metadata !1, i32 7, metadata !26, i32 0} ; [ DW_TAG_auto_variable ]
!26 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !27} ; [ DW_TAG_pointer_type ]
!27 = metadata !{i32 589862, metadata !2, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !23} ; [ DW_TAG_const_type ]
!28 = metadata !{i32 7, i32 21, metadata !21, null}
!29 = metadata !{i32 0}
!30 = metadata !{i32 590080, metadata !21, metadata !"i", metadata !1, i32 5, metadata !17, i32 0} ; [ DW_TAG_auto_variable ]
!31 = metadata !{i32 8, i32 3, metadata !21, null}
!32 = metadata !{i32 10, i32 7, metadata !33, null}
!33 = metadata !{i32 589835, metadata !34, i32 9, i32 5, metadata !1, i32 2} ; [ DW_TAG_lexical_block ]
!34 = metadata !{i32 589835, metadata !21, i32 8, i32 3, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!35 = metadata !{i32 11, i32 5, metadata !33, null}
!36 = metadata !{i32 8, i32 21, metadata !34, null}
!37 = metadata !{i32 12, i32 3, metadata !21, null}
!38 = metadata !{i32 590081, metadata !6, metadata !"argc", metadata !1, i32 16777231, metadata !9, i32 0} ; [ DW_TAG_arg_variable ]
!39 = metadata !{i32 15, i32 14, metadata !6, null}
!40 = metadata !{i32 590081, metadata !6, metadata !"argv", metadata !1, i32 33554447, metadata !41, i32 0} ; [ DW_TAG_arg_variable ]
!41 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !22} ; [ DW_TAG_pointer_type ]
!42 = metadata !{i32 15, i32 27, metadata !6, null}
!43 = metadata !{i32 590080, metadata !44, metadata !"stack_array", metadata !1, i32 18, metadata !45, i32 0} ; [ DW_TAG_auto_variable ]
!44 = metadata !{i32 589835, metadata !6, i32 16, i32 1, metadata !1, i32 3} ; [ DW_TAG_lexical_block ]
!45 = metadata !{i32 589825, metadata !2, metadata !"", metadata !2, i32 0, i64 640, i64 32, i32 0, i32 0, metadata !9, metadata !46, i32 0, i32 0} ; [ DW_TAG_array_type ]
!46 = metadata !{metadata !47}
!47 = metadata !{i32 589857, i64 0, i64 19}       ; [ DW_TAG_subrange_type ]
!48 = metadata !{i32 18, i32 9, metadata !44, null}
!49 = metadata !{i32 18, i32 95, metadata !44, null}
!50 = metadata !{i32 590080, metadata !44, metadata !"stack_arr2", metadata !1, i32 19, metadata !45, i32 0} ; [ DW_TAG_auto_variable ]
!51 = metadata !{i32 19, i32 9, metadata !44, null}
!52 = metadata !{i32 590080, metadata !44, metadata !"i", metadata !1, i32 17, metadata !9, i32 0} ; [ DW_TAG_auto_variable ]
!53 = metadata !{i32 20, i32 5, metadata !44, null}
!54 = metadata !{i32 590080, metadata !44, metadata !"sum", metadata !1, i32 17, metadata !9, i32 0} ; [ DW_TAG_auto_variable ]
!55 = metadata !{i32 21, i32 9, metadata !56, null}
!56 = metadata !{i32 589835, metadata !57, i32 20, i32 33, metadata !1, i32 5} ; [ DW_TAG_lexical_block ]
!57 = metadata !{i32 589835, metadata !44, i32 20, i32 5, metadata !1, i32 4} ; [ DW_TAG_lexical_block ]
!58 = metadata !{i32 22, i32 9, metadata !56, null}
!59 = metadata !{i32 23, i32 5, metadata !56, null}
!60 = metadata !{i32 20, i32 28, metadata !57, null}
!61 = metadata !{i32 27, i32 5, metadata !44, null}
!62 = metadata !{i32 28, i32 5, metadata !44, null}
!63 = metadata !{i32 29, i32 5, metadata !44, null}
!64 = metadata !{i32 30, i32 9, metadata !65, null}
!65 = metadata !{i32 589835, metadata !66, i32 29, i32 33, metadata !1, i32 7} ; [ DW_TAG_lexical_block ]
!66 = metadata !{i32 589835, metadata !44, i32 29, i32 5, metadata !1, i32 6} ; [ DW_TAG_lexical_block ]
!67 = metadata !{i32 31, i32 5, metadata !65, null}
!68 = metadata !{i32 29, i32 28, metadata !66, null}
!69 = metadata !{i32 35, i32 5, metadata !44, null}
!70 = metadata !{i32 36, i32 5, metadata !44, null}
!71 = metadata !{i32 37, i32 1, metadata !44, null}
