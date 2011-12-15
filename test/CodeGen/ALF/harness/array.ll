; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@x = global [4 x i32] [i32 1, i32 2, i32 3, i32 4], align 4
@out = common global i32 0, align 4

define i32 @deref(i32* %array) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32* %array}, i64 0, metadata !18), !dbg !20
  %tmp = getelementptr inbounds i32* %array, i32 1, !dbg !21
  %tmp1 = load i32* %tmp, align 4, !dbg !21
  %tmp2 = getelementptr inbounds i32* %array, i32 3, !dbg !21
  %tmp3 = load i32* %tmp2, align 4, !dbg !21
  %tmp4 = add nsw i32 %tmp1, %tmp3, !dbg !21
  ret i32 %tmp4, !dbg !21
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define void @modify(i32* %array) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32* %array}, i64 0, metadata !23), !dbg !24
  store i32 1, i32* %array, align 4, !dbg !25
  %tmp = getelementptr inbounds i32* %array, i32 1, !dbg !27
  store i32 2, i32* %tmp, align 4, !dbg !27
  ret void, !dbg !28
}

define i32 @read_x(i32 %i) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %i}, i64 0, metadata !29), !dbg !30
  %tmp = srem i32 %i, 4, !dbg !31
  %tmp1 = getelementptr inbounds [4 x i32]* @x, i32 0, i32 %tmp, !dbg !31
  %tmp2 = load i32* %tmp1, align 4, !dbg !31
  ret i32 %tmp2, !dbg !31
}

define void @loop() nounwind {
bb:
  br label %bb1, !dbg !33

bb1:                                              ; preds = %bb3, %bb
  %tmp = load i32* getelementptr inbounds ([4 x i32]* @x, i32 0, i32 0), align 4, !dbg !33
  %tmp2 = icmp eq i32 %tmp, 0, !dbg !33
  br i1 %tmp2, label %bb4, label %bb3, !dbg !33

bb3:                                              ; preds = %bb1
  call void @modify(i32* getelementptr inbounds ([4 x i32]* @x, i32 0, i32 0)), !dbg !33
  br label %bb1, !dbg !33

bb4:                                              ; preds = %bb1
  ret void, !dbg !35
}

define i32 @main(i32 %argc, i8** %argv) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %argc}, i64 0, metadata !36), !dbg !37
  call void @llvm.dbg.value(metadata !{i8** %argv}, i64 0, metadata !38), !dbg !42
  store i32 4, i32* getelementptr inbounds ([4 x i32]* @x, i32 0, i32 0), align 4, !dbg !43
  %tmp = call i32 @read_x(i32 6), !dbg !45
  store i32 %tmp, i32* getelementptr inbounds ([4 x i32]* @x, i32 0, i32 1), align 4, !dbg !45
  store i32 2, i32* getelementptr inbounds ([4 x i32]* @x, i32 0, i32 2), align 4, !dbg !46
  store i32 1, i32* getelementptr inbounds ([4 x i32]* @x, i32 0, i32 3), align 4, !dbg !47
  %tmp1 = load i32* getelementptr inbounds ([4 x i32]* @x, i32 0, i32 1), align 4, !dbg !48
  call void @llvm.dbg.value(metadata !14, i64 0, metadata !49), !dbg !48
  store i32 3, i32* getelementptr inbounds ([4 x i32]* @x, i32 0, i32 3), align 4, !dbg !50
  %tmp2 = call i32 @deref(i32* getelementptr inbounds ([4 x i32]* @x, i32 0, i32 0)), !dbg !51
  call void @llvm.dbg.value(metadata !{i32 %tmp2}, i64 0, metadata !52), !dbg !51
  call void @modify(i32* getelementptr inbounds ([4 x i32]* @x, i32 0, i32 0)), !dbg !53
  %tmp3 = call i32 @read_x(i32 4), !dbg !54
  %tmp4 = call i32 @read_x(i32 5), !dbg !54
  %tmp5 = add nsw i32 %tmp3, %tmp4, !dbg !54
  call void @llvm.dbg.value(metadata !{i32 %tmp5}, i64 0, metadata !55), !dbg !54
  call void @llvm.dbg.value(metadata !14, i64 0, metadata !56), !dbg !57
  call void @llvm.dbg.value(metadata !{i32 %tmp2}, i64 0, metadata !58), !dbg !59
  call void @llvm.dbg.value(metadata !{i32 %tmp5}, i64 0, metadata !60), !dbg !61
  %tmp6 = icmp eq i32 %tmp1, 3, !dbg !62
  br i1 %tmp6, label %bb8, label %bb7, !dbg !62

bb7:                                              ; preds = %bb
  br label %bb15, !dbg !62

bb8:                                              ; preds = %bb
  %tmp9 = icmp eq i32 %tmp2, 6, !dbg !63
  br i1 %tmp9, label %bb11, label %bb10, !dbg !63

bb10:                                             ; preds = %bb8
  br label %bb15, !dbg !63

bb11:                                             ; preds = %bb8
  %tmp12 = icmp eq i32 %tmp5, 3, !dbg !64
  br i1 %tmp12, label %bb14, label %bb13, !dbg !64

bb13:                                             ; preds = %bb11
  br label %bb15, !dbg !64

bb14:                                             ; preds = %bb11
  br label %bb15, !dbg !65

bb15:                                             ; preds = %bb14, %bb13, %bb10, %bb7
  %.0 = phi i32 [ 1, %bb7 ], [ 1, %bb10 ], [ 1, %bb13 ], [ 0, %bb14 ]
  ret i32 %.0, !dbg !66
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.gv = !{!0, !7}
!llvm.dbg.sp = !{!9, !12, !15, !16, !17}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"x", metadata !"x", metadata !"", metadata !2, i32 3, metadata !3, i32 0, i32 1, [4 x i32]* @x} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"array.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"array.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 128, i64 32, i32 0, i32 0, metadata !4, metadata !5, i32 0, i32 0} ; [ DW_TAG_array_type ]
!4 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!5 = metadata !{metadata !6}
!6 = metadata !{i32 589857, i64 0, i64 3}         ; [ DW_TAG_subrange_type ]
!7 = metadata !{i32 589876, i32 0, metadata !1, metadata !"out", metadata !"out", metadata !"", metadata !2, i32 1, metadata !8, i32 0, i32 1, i32* @out} ; [ DW_TAG_variable ]
!8 = metadata !{i32 589877, metadata !1, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !4} ; [ DW_TAG_volatile_type ]
!9 = metadata !{i32 589870, i32 0, metadata !2, metadata !"deref", metadata !"deref", metadata !"", metadata !2, i32 5, metadata !10, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32*)* @deref} ; [ DW_TAG_subprogram ]
!10 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !11, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!11 = metadata !{metadata !4}
!12 = metadata !{i32 589870, i32 0, metadata !2, metadata !"modify", metadata !"modify", metadata !"", metadata !2, i32 9, metadata !13, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, void (i32*)* @modify} ; [ DW_TAG_subprogram ]
!13 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !14, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!14 = metadata !{null}
!15 = metadata !{i32 589870, i32 0, metadata !2, metadata !"read_x", metadata !"read_x", metadata !"", metadata !2, i32 14, metadata !10, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32)* @read_x} ; [ DW_TAG_subprogram ]
!16 = metadata !{i32 589870, i32 0, metadata !2, metadata !"loop", metadata !"loop", metadata !"", metadata !2, i32 18, metadata !13, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, void ()* @loop} ; [ DW_TAG_subprogram ]
!17 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 22, metadata !10, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32, i8**)* @main} ; [ DW_TAG_subprogram ]
!18 = metadata !{i32 590081, metadata !9, metadata !"array", metadata !2, i32 16777221, metadata !19, i32 0} ; [ DW_TAG_arg_variable ]
!19 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !4} ; [ DW_TAG_pointer_type ]
!20 = metadata !{i32 5, i32 16, metadata !9, null}
!21 = metadata !{i32 6, i32 5, metadata !22, null}
!22 = metadata !{i32 589835, metadata !9, i32 5, i32 23, metadata !2, i32 0} ; [ DW_TAG_lexical_block ]
!23 = metadata !{i32 590081, metadata !12, metadata !"array", metadata !2, i32 16777225, metadata !19, i32 0} ; [ DW_TAG_arg_variable ]
!24 = metadata !{i32 9, i32 18, metadata !12, null}
!25 = metadata !{i32 10, i32 5, metadata !26, null}
!26 = metadata !{i32 589835, metadata !12, i32 9, i32 25, metadata !2, i32 1} ; [ DW_TAG_lexical_block ]
!27 = metadata !{i32 11, i32 5, metadata !26, null}
!28 = metadata !{i32 12, i32 1, metadata !26, null}
!29 = metadata !{i32 590081, metadata !15, metadata !"i", metadata !2, i32 16777230, metadata !4, i32 0} ; [ DW_TAG_arg_variable ]
!30 = metadata !{i32 14, i32 16, metadata !15, null}
!31 = metadata !{i32 15, i32 5, metadata !32, null}
!32 = metadata !{i32 589835, metadata !15, i32 14, i32 19, metadata !2, i32 2} ; [ DW_TAG_lexical_block ]
!33 = metadata !{i32 19, i32 5, metadata !34, null}
!34 = metadata !{i32 589835, metadata !16, i32 18, i32 13, metadata !2, i32 3} ; [ DW_TAG_lexical_block ]
!35 = metadata !{i32 20, i32 1, metadata !34, null}
!36 = metadata !{i32 590081, metadata !17, metadata !"argc", metadata !2, i32 16777238, metadata !4, i32 0} ; [ DW_TAG_arg_variable ]
!37 = metadata !{i32 22, i32 14, metadata !17, null}
!38 = metadata !{i32 590081, metadata !17, metadata !"argv", metadata !2, i32 33554454, metadata !39, i32 0} ; [ DW_TAG_arg_variable ]
!39 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !40} ; [ DW_TAG_pointer_type ]
!40 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !41} ; [ DW_TAG_pointer_type ]
!41 = metadata !{i32 589860, metadata !1, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!42 = metadata !{i32 22, i32 27, metadata !17, null}
!43 = metadata !{i32 23, i32 5, metadata !44, null}
!44 = metadata !{i32 589835, metadata !17, i32 22, i32 33, metadata !2, i32 4} ; [ DW_TAG_lexical_block ]
!45 = metadata !{i32 24, i32 5, metadata !44, null}
!46 = metadata !{i32 25, i32 5, metadata !44, null}
!47 = metadata !{i32 26, i32 5, metadata !44, null}
!48 = metadata !{i32 27, i32 24, metadata !44, null}
!49 = metadata !{i32 590080, metadata !44, metadata !"r", metadata !2, i32 27, metadata !4, i32 0} ; [ DW_TAG_auto_variable ]
!50 = metadata !{i32 29, i32 5, metadata !44, null}
!51 = metadata !{i32 30, i32 25, metadata !44, null}
!52 = metadata !{i32 590080, metadata !44, metadata !"q", metadata !2, i32 30, metadata !4, i32 0} ; [ DW_TAG_auto_variable ]
!53 = metadata !{i32 32, i32 5, metadata !44, null}
!54 = metadata !{i32 33, i32 34, metadata !44, null}
!55 = metadata !{i32 590080, metadata !44, metadata !"s", metadata !2, i32 33, metadata !4, i32 0} ; [ DW_TAG_auto_variable ]
!56 = metadata !{i32 590080, metadata !44, metadata !"t1", metadata !2, i32 35, metadata !4, i32 0} ; [ DW_TAG_auto_variable ]
!57 = metadata !{i32 35, i32 30, metadata !44, null}
!58 = metadata !{i32 590080, metadata !44, metadata !"t2", metadata !2, i32 36, metadata !4, i32 0} ; [ DW_TAG_auto_variable ]
!59 = metadata !{i32 36, i32 30, metadata !44, null}
!60 = metadata !{i32 590080, metadata !44, metadata !"t3", metadata !2, i32 37, metadata !4, i32 0} ; [ DW_TAG_auto_variable ]
!61 = metadata !{i32 37, i32 30, metadata !44, null}
!62 = metadata !{i32 39, i32 5, metadata !44, null}
!63 = metadata !{i32 40, i32 5, metadata !44, null}
!64 = metadata !{i32 41, i32 5, metadata !44, null}
!65 = metadata !{i32 42, i32 5, metadata !44, null}
!66 = metadata !{i32 43, i32 1, metadata !44, null}
