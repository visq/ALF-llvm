; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@i8_init = global i8 -18, align 1
@u32_init = global i32 3, align 4
@i8_ptr = global i8* @i8_init, align 4
@u32_ptr = global i32* @u32_init, align 4

define signext i8 @nondet_i8() nounwind {
bb:
  %tmp = load i8** @i8_ptr, align 4, !dbg !24
  %tmp1 = load volatile i8* %tmp, align 1, !dbg !24
  ret i8 %tmp1, !dbg !24
}

define i32 @nondet_u32(i32 %lb, i32 %ub) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %lb}, i64 0, metadata !26), !dbg !27
  call void @llvm.dbg.value(metadata !{i32 %ub}, i64 0, metadata !28), !dbg !29
  %tmp = load i32** @u32_ptr, align 4, !dbg !30
  %tmp1 = load volatile i32* %tmp, align 4, !dbg !30
  call void @llvm.dbg.value(metadata !{i32 %tmp1}, i64 0, metadata !32), !dbg !30
  %tmp2 = icmp ult i32 %tmp1, %lb, !dbg !33
  br i1 %tmp2, label %bb3, label %bb4, !dbg !33

bb3:                                              ; preds = %bb
  call void @llvm.dbg.value(metadata !{i32 %lb}, i64 0, metadata !32), !dbg !33
  br label %bb4, !dbg !33

bb4:                                              ; preds = %bb3, %bb
  %v.0 = phi i32 [ %lb, %bb3 ], [ %tmp1, %bb ]
  %tmp5 = icmp ugt i32 %v.0, %ub, !dbg !34
  br i1 %tmp5, label %bb6, label %bb7, !dbg !34

bb6:                                              ; preds = %bb4
  call void @llvm.dbg.value(metadata !{i32 %ub}, i64 0, metadata !32), !dbg !34
  br label %bb7, !dbg !34

bb7:                                              ; preds = %bb6, %bb4
  %v.1 = phi i32 [ %ub, %bb6 ], [ %v.0, %bb4 ]
  ret i32 %v.1, !dbg !35
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define i32 @main() nounwind {
bb:
  %tmp = call i32 @nondet_u32(i32 3, i32 7), !dbg !36
  %tmp1 = call i32 @nondet_u32(i32 2, i32 3), !dbg !36
  %tmp2 = mul i32 %tmp, %tmp1, !dbg !36
  call void @llvm.dbg.value(metadata !{i32 %tmp2}, i64 0, metadata !38), !dbg !36
  call void @llvm.dbg.value(metadata !{i32 %tmp2}, i64 0, metadata !39), !dbg !41
  %tmp3 = call signext i8 @nondet_i8(), !dbg !42
  %tmp4 = sext i8 %tmp3 to i32, !dbg !42
  %tmp5 = add nsw i32 %tmp2, %tmp4, !dbg !42
  call void @llvm.dbg.value(metadata !{i32 %tmp5}, i64 0, metadata !39), !dbg !42
  ret i32 %tmp5, !dbg !43
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.gv = !{!0, !5, !8, !11}
!llvm.dbg.sp = !{!14, !17, !20}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"i8_init", metadata !"i8_init", metadata !"", metadata !2, i32 7, metadata !3, i32 0, i32 1, i8* @i8_init} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"nondet1.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"nondet1.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589846, metadata !1, metadata !"int8_t", metadata !2, i32 37, i64 0, i64 0, i64 0, i32 0, metadata !4} ; [ DW_TAG_typedef ]
!4 = metadata !{i32 589860, metadata !1, metadata !"signed char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!5 = metadata !{i32 589876, i32 0, metadata !1, metadata !"u32_init", metadata !"u32_init", metadata !"", metadata !2, i32 8, metadata !6, i32 0, i32 1, i32* @u32_init} ; [ DW_TAG_variable ]
!6 = metadata !{i32 589846, metadata !1, metadata !"uint32_t", metadata !2, i32 52, i64 0, i64 0, i64 0, i32 0, metadata !7} ; [ DW_TAG_typedef ]
!7 = metadata !{i32 589860, metadata !1, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!8 = metadata !{i32 589876, i32 0, metadata !1, metadata !"i8_ptr", metadata !"i8_ptr", metadata !"", metadata !2, i32 10, metadata !9, i32 0, i32 1, i8** @i8_ptr} ; [ DW_TAG_variable ]
!9 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !10} ; [ DW_TAG_pointer_type ]
!10 = metadata !{i32 589877, metadata !1, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !3} ; [ DW_TAG_volatile_type ]
!11 = metadata !{i32 589876, i32 0, metadata !1, metadata !"u32_ptr", metadata !"u32_ptr", metadata !"", metadata !2, i32 11, metadata !12, i32 0, i32 1, i32** @u32_ptr} ; [ DW_TAG_variable ]
!12 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !13} ; [ DW_TAG_pointer_type ]
!13 = metadata !{i32 589877, metadata !1, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !6} ; [ DW_TAG_volatile_type ]
!14 = metadata !{i32 589870, i32 0, metadata !2, metadata !"nondet_i8", metadata !"nondet_i8", metadata !"", metadata !2, i32 13, metadata !15, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i8 ()* @nondet_i8} ; [ DW_TAG_subprogram ]
!15 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !16, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!16 = metadata !{metadata !3}
!17 = metadata !{i32 589870, i32 0, metadata !2, metadata !"nondet_u32", metadata !"nondet_u32", metadata !"", metadata !2, i32 17, metadata !18, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32, i32)* @nondet_u32} ; [ DW_TAG_subprogram ]
!18 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !19, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!19 = metadata !{metadata !6}
!20 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 25, metadata !21, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!21 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !22, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!22 = metadata !{metadata !23}
!23 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!24 = metadata !{i32 14, i32 3, metadata !25, null}
!25 = metadata !{i32 589835, metadata !14, i32 13, i32 20, metadata !2, i32 0} ; [ DW_TAG_lexical_block ]
!26 = metadata !{i32 590081, metadata !17, metadata !"lb", metadata !2, i32 16777233, metadata !6, i32 0} ; [ DW_TAG_arg_variable ]
!27 = metadata !{i32 17, i32 30, metadata !17, null}
!28 = metadata !{i32 590081, metadata !17, metadata !"ub", metadata !2, i32 33554449, metadata !6, i32 0} ; [ DW_TAG_arg_variable ]
!29 = metadata !{i32 17, i32 43, metadata !17, null}
!30 = metadata !{i32 18, i32 24, metadata !31, null}
!31 = metadata !{i32 589835, metadata !17, i32 17, i32 47, metadata !2, i32 1} ; [ DW_TAG_lexical_block ]
!32 = metadata !{i32 590080, metadata !31, metadata !"v", metadata !2, i32 18, metadata !6, i32 0} ; [ DW_TAG_auto_variable ]
!33 = metadata !{i32 19, i32 3, metadata !31, null}
!34 = metadata !{i32 20, i32 3, metadata !31, null}
!35 = metadata !{i32 21, i32 3, metadata !31, null}
!36 = metadata !{i32 26, i32 49, metadata !37, null}
!37 = metadata !{i32 589835, metadata !20, i32 25, i32 1, metadata !2, i32 2} ; [ DW_TAG_lexical_block ]
!38 = metadata !{i32 590080, metadata !37, metadata !"v", metadata !2, i32 26, metadata !6, i32 0} ; [ DW_TAG_auto_variable ]
!39 = metadata !{i32 590080, metadata !37, metadata !"vs", metadata !2, i32 27, metadata !40, i32 0} ; [ DW_TAG_auto_variable ]
!40 = metadata !{i32 589846, metadata !1, metadata !"int32_t", metadata !2, i32 39, i64 0, i64 0, i64 0, i32 0, metadata !23} ; [ DW_TAG_typedef ]
!41 = metadata !{i32 27, i32 28, metadata !37, null}
!42 = metadata !{i32 28, i32 3, metadata !37, null}
!43 = metadata !{i32 30, i32 3, metadata !37, null}
