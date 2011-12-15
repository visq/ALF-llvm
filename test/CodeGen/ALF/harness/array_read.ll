; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@x = global [4 x i32] [i32 1, i32 2, i32 3, i32 4], align 4
@out = common global i32 0, align 4

define i32 @deref(i32* %array) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32* %array}, i64 0, metadata !14), !dbg !16
  %tmp = getelementptr inbounds i32* %array, i32 1, !dbg !17
  %tmp1 = load i32* %tmp, align 4, !dbg !17
  %tmp2 = getelementptr inbounds i32* %array, i32 3, !dbg !17
  %tmp3 = load i32* %tmp2, align 4, !dbg !17
  %tmp4 = add nsw i32 %tmp1, %tmp3, !dbg !17
  ret i32 %tmp4, !dbg !17
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define i32 @read_x(i32 %i) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %i}, i64 0, metadata !19), !dbg !20
  %tmp = srem i32 %i, 4, !dbg !21
  %tmp1 = getelementptr inbounds [4 x i32]* @x, i32 0, i32 %tmp, !dbg !21
  %tmp2 = load i32* %tmp1, align 4, !dbg !21
  ret i32 %tmp2, !dbg !21
}

define i32 @main(i32 %argc, i8** %argv) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %argc}, i64 0, metadata !23), !dbg !24
  call void @llvm.dbg.value(metadata !{i8** %argv}, i64 0, metadata !25), !dbg !29
  %tmp = load i32* getelementptr inbounds ([4 x i32]* @x, i32 0, i32 0), align 4, !dbg !30
  %tmp1 = load i32* getelementptr inbounds ([4 x i32]* @x, i32 0, i32 2), align 4, !dbg !30
  %tmp2 = add nsw i32 %tmp, %tmp1, !dbg !30
  call void @llvm.dbg.value(metadata !{i32 %tmp2}, i64 0, metadata !32), !dbg !30
  %tmp3 = call i32 @deref(i32* getelementptr inbounds ([4 x i32]* @x, i32 0, i32 0)), !dbg !33
  call void @llvm.dbg.value(metadata !{i32 %tmp3}, i64 0, metadata !34), !dbg !33
  %tmp4 = call i32 @read_x(i32 4), !dbg !35
  %tmp5 = call i32 @read_x(i32 5), !dbg !35
  %tmp6 = add nsw i32 %tmp4, %tmp5, !dbg !35
  call void @llvm.dbg.value(metadata !{i32 %tmp6}, i64 0, metadata !36), !dbg !35
  call void @llvm.dbg.value(metadata !{i32 %tmp2}, i64 0, metadata !37), !dbg !38
  call void @llvm.dbg.value(metadata !{i32 %tmp3}, i64 0, metadata !39), !dbg !40
  call void @llvm.dbg.value(metadata !{i32 %tmp6}, i64 0, metadata !41), !dbg !42
  %tmp7 = add nsw i32 %tmp2, %tmp3, !dbg !43
  %tmp8 = add nsw i32 %tmp7, %tmp6, !dbg !43
  %tmp9 = icmp eq i32 %tmp8, 13, !dbg !43
  br i1 %tmp9, label %bb11, label %bb10, !dbg !43

bb10:                                             ; preds = %bb
  br label %bb14, !dbg !44

bb11:                                             ; preds = %bb
  %tmp12 = call i32 @read_x(i32 4), !dbg !46
  %tmp13 = add nsw i32 %tmp12, -1, !dbg !46
  br label %bb14, !dbg !46

bb14:                                             ; preds = %bb11, %bb10
  %.0 = phi i32 [ -1, %bb10 ], [ %tmp13, %bb11 ]
  ret i32 %.0, !dbg !47
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.gv = !{!0, !7}
!llvm.dbg.sp = !{!9, !12, !13}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"x", metadata !"x", metadata !"", metadata !2, i32 3, metadata !3, i32 0, i32 1, [4 x i32]* @x} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"array_read.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"array_read.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 128, i64 32, i32 0, i32 0, metadata !4, metadata !5, i32 0, i32 0} ; [ DW_TAG_array_type ]
!4 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!5 = metadata !{metadata !6}
!6 = metadata !{i32 589857, i64 0, i64 3}         ; [ DW_TAG_subrange_type ]
!7 = metadata !{i32 589876, i32 0, metadata !1, metadata !"out", metadata !"out", metadata !"", metadata !2, i32 1, metadata !8, i32 0, i32 1, i32* @out} ; [ DW_TAG_variable ]
!8 = metadata !{i32 589877, metadata !1, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !4} ; [ DW_TAG_volatile_type ]
!9 = metadata !{i32 589870, i32 0, metadata !2, metadata !"deref", metadata !"deref", metadata !"", metadata !2, i32 5, metadata !10, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32*)* @deref} ; [ DW_TAG_subprogram ]
!10 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !11, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!11 = metadata !{metadata !4}
!12 = metadata !{i32 589870, i32 0, metadata !2, metadata !"read_x", metadata !"read_x", metadata !"", metadata !2, i32 9, metadata !10, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32)* @read_x} ; [ DW_TAG_subprogram ]
!13 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 13, metadata !10, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32, i8**)* @main} ; [ DW_TAG_subprogram ]
!14 = metadata !{i32 590081, metadata !9, metadata !"array", metadata !2, i32 16777221, metadata !15, i32 0} ; [ DW_TAG_arg_variable ]
!15 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !4} ; [ DW_TAG_pointer_type ]
!16 = metadata !{i32 5, i32 16, metadata !9, null}
!17 = metadata !{i32 6, i32 5, metadata !18, null}
!18 = metadata !{i32 589835, metadata !9, i32 5, i32 23, metadata !2, i32 0} ; [ DW_TAG_lexical_block ]
!19 = metadata !{i32 590081, metadata !12, metadata !"i", metadata !2, i32 16777225, metadata !4, i32 0} ; [ DW_TAG_arg_variable ]
!20 = metadata !{i32 9, i32 16, metadata !12, null}
!21 = metadata !{i32 10, i32 5, metadata !22, null}
!22 = metadata !{i32 589835, metadata !12, i32 9, i32 19, metadata !2, i32 1} ; [ DW_TAG_lexical_block ]
!23 = metadata !{i32 590081, metadata !13, metadata !"argc", metadata !2, i32 16777229, metadata !4, i32 0} ; [ DW_TAG_arg_variable ]
!24 = metadata !{i32 13, i32 14, metadata !13, null}
!25 = metadata !{i32 590081, metadata !13, metadata !"argv", metadata !2, i32 33554445, metadata !26, i32 0} ; [ DW_TAG_arg_variable ]
!26 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !27} ; [ DW_TAG_pointer_type ]
!27 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !28} ; [ DW_TAG_pointer_type ]
!28 = metadata !{i32 589860, metadata !1, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!29 = metadata !{i32 13, i32 27, metadata !13, null}
!30 = metadata !{i32 14, i32 24, metadata !31, null}
!31 = metadata !{i32 589835, metadata !13, i32 13, i32 33, metadata !2, i32 2} ; [ DW_TAG_lexical_block ]
!32 = metadata !{i32 590080, metadata !31, metadata !"r", metadata !2, i32 14, metadata !4, i32 0} ; [ DW_TAG_auto_variable ]
!33 = metadata !{i32 15, i32 25, metadata !31, null}
!34 = metadata !{i32 590080, metadata !31, metadata !"q", metadata !2, i32 15, metadata !4, i32 0} ; [ DW_TAG_auto_variable ]
!35 = metadata !{i32 16, i32 34, metadata !31, null}
!36 = metadata !{i32 590080, metadata !31, metadata !"s", metadata !2, i32 16, metadata !4, i32 0} ; [ DW_TAG_auto_variable ]
!37 = metadata !{i32 590080, metadata !31, metadata !"t1", metadata !2, i32 17, metadata !4, i32 0} ; [ DW_TAG_auto_variable ]
!38 = metadata !{i32 17, i32 30, metadata !31, null}
!39 = metadata !{i32 590080, metadata !31, metadata !"t2", metadata !2, i32 18, metadata !4, i32 0} ; [ DW_TAG_auto_variable ]
!40 = metadata !{i32 18, i32 30, metadata !31, null}
!41 = metadata !{i32 590080, metadata !31, metadata !"t3", metadata !2, i32 19, metadata !4, i32 0} ; [ DW_TAG_auto_variable ]
!42 = metadata !{i32 19, i32 30, metadata !31, null}
!43 = metadata !{i32 20, i32 5, metadata !31, null}
!44 = metadata !{i32 21, i32 9, metadata !45, null}
!45 = metadata !{i32 589835, metadata !31, i32 20, i32 28, metadata !2, i32 3} ; [ DW_TAG_lexical_block ]
!46 = metadata !{i32 23, i32 5, metadata !31, null}
!47 = metadata !{i32 24, i32 1, metadata !31, null}
