; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@u32_init = global i32 1, align 4
@u32_ptr = global i32* @u32_init, align 4

define i32 @nondet_u32(i32 %lb, i32 %ub) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %lb}, i64 0, metadata !16), !dbg !17
  call void @llvm.dbg.value(metadata !{i32 %ub}, i64 0, metadata !18), !dbg !19
  %tmp = load i32** @u32_ptr, align 4, !dbg !20
  %tmp1 = load volatile i32* %tmp, align 4, !dbg !20
  call void @llvm.dbg.value(metadata !{i32 %tmp1}, i64 0, metadata !22), !dbg !20
  %tmp2 = icmp ult i32 %tmp1, %lb, !dbg !23
  br i1 %tmp2, label %bb3, label %bb4, !dbg !23

bb3:                                              ; preds = %bb
  call void @llvm.dbg.value(metadata !{i32 %lb}, i64 0, metadata !22), !dbg !23
  br label %bb4, !dbg !23

bb4:                                              ; preds = %bb3, %bb
  %v.0 = phi i32 [ %lb, %bb3 ], [ %tmp1, %bb ]
  %tmp5 = icmp ugt i32 %v.0, %ub, !dbg !24
  br i1 %tmp5, label %bb6, label %bb7, !dbg !24

bb6:                                              ; preds = %bb4
  call void @llvm.dbg.value(metadata !{i32 %ub}, i64 0, metadata !22), !dbg !24
  br label %bb7, !dbg !24

bb7:                                              ; preds = %bb6, %bb4
  %v.1 = phi i32 [ %ub, %bb6 ], [ %v.0, %bb4 ]
  ret i32 %v.1, !dbg !25
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define i32 @s(i32 %arg, i32 %v) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %arg}, i64 0, metadata !26), !dbg !27
  call void @llvm.dbg.value(metadata !{i32 %v}, i64 0, metadata !28), !dbg !29
  switch i32 %arg, label %bb6 [
    i32 0, label %bb1
    i32 1, label %bb2
    i32 2, label %bb4
  ], !dbg !30

bb1:                                              ; preds = %bb
  %tmp = mul nsw i32 %v, 3, !dbg !32
  br label %bb8, !dbg !32

bb2:                                              ; preds = %bb
  %tmp3 = mul nsw i32 %v, 5, !dbg !34
  br label %bb8, !dbg !34

bb4:                                              ; preds = %bb
  %tmp5 = mul nsw i32 %v, 7, !dbg !35
  br label %bb8, !dbg !35

bb6:                                              ; preds = %bb
  %tmp7 = mul nsw i32 %v, 11, !dbg !36
  br label %bb8, !dbg !36

bb8:                                              ; preds = %bb6, %bb4, %bb2, %bb1
  %.0 = phi i32 [ %tmp7, %bb6 ], [ %tmp5, %bb4 ], [ %tmp3, %bb2 ], [ %tmp, %bb1 ]
  ret i32 %.0, !dbg !37
}

define i32 @main() nounwind {
bb:
  call void @llvm.dbg.value(metadata !38, i64 0, metadata !39), !dbg !41
  call void @llvm.dbg.value(metadata !38, i64 0, metadata !42), !dbg !43
  br label %bb1, !dbg !43

bb1:                                              ; preds = %bb5, %bb
  %r.0 = phi i32 [ 0, %bb ], [ %tmp6, %bb5 ]
  %i.0 = phi i32 [ 0, %bb ], [ %tmp7, %bb5 ]
  %tmp = icmp slt i32 %i.0, 4, !dbg !43
  br i1 %tmp, label %bb2, label %bb8, !dbg !43

bb2:                                              ; preds = %bb1
  %tmp3 = call i32 @nondet_u32(i32 1, i32 3), !dbg !44
  %tmp4 = call i32 @s(i32 %i.0, i32 %tmp3), !dbg !44
  call void @llvm.dbg.value(metadata !{i32 %tmp6}, i64 0, metadata !39), !dbg !44
  br label %bb5, !dbg !47

bb5:                                              ; preds = %bb2
  %tmp6 = add nsw i32 %r.0, %tmp4, !dbg !44
  %tmp7 = add nsw i32 %i.0, 1, !dbg !48
  call void @llvm.dbg.value(metadata !{i32 %tmp7}, i64 0, metadata !42), !dbg !48
  br label %bb1, !dbg !48

bb8:                                              ; preds = %bb1
  %tmp9 = add nsw i32 %r.0, -26, !dbg !49
  ret i32 %tmp9, !dbg !49
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.gv = !{!0, !5}
!llvm.dbg.sp = !{!8, !11, !15}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"u32_init", metadata !"u32_init", metadata !"", metadata !2, i32 8, metadata !3, i32 0, i32 1, i32* @u32_init} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"switch1.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"switch1.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589846, metadata !1, metadata !"uint32_t", metadata !2, i32 52, i64 0, i64 0, i64 0, i32 0, metadata !4} ; [ DW_TAG_typedef ]
!4 = metadata !{i32 589860, metadata !1, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!5 = metadata !{i32 589876, i32 0, metadata !1, metadata !"u32_ptr", metadata !"u32_ptr", metadata !"", metadata !2, i32 9, metadata !6, i32 0, i32 1, i32** @u32_ptr} ; [ DW_TAG_variable ]
!6 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !7} ; [ DW_TAG_pointer_type ]
!7 = metadata !{i32 589877, metadata !1, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !3} ; [ DW_TAG_volatile_type ]
!8 = metadata !{i32 589870, i32 0, metadata !2, metadata !"nondet_u32", metadata !"nondet_u32", metadata !"", metadata !2, i32 10, metadata !9, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32, i32)* @nondet_u32} ; [ DW_TAG_subprogram ]
!9 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !10, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!10 = metadata !{metadata !3}
!11 = metadata !{i32 589870, i32 0, metadata !2, metadata !"s", metadata !"s", metadata !"", metadata !2, i32 16, metadata !12, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32, i32)* @s} ; [ DW_TAG_subprogram ]
!12 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !13, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!13 = metadata !{metadata !14}
!14 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!15 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 26, metadata !12, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!16 = metadata !{i32 590081, metadata !8, metadata !"lb", metadata !2, i32 16777226, metadata !3, i32 0} ; [ DW_TAG_arg_variable ]
!17 = metadata !{i32 10, i32 30, metadata !8, null}
!18 = metadata !{i32 590081, metadata !8, metadata !"ub", metadata !2, i32 33554442, metadata !3, i32 0} ; [ DW_TAG_arg_variable ]
!19 = metadata !{i32 10, i32 43, metadata !8, null}
!20 = metadata !{i32 11, i32 24, metadata !21, null}
!21 = metadata !{i32 589835, metadata !8, i32 10, i32 47, metadata !2, i32 0} ; [ DW_TAG_lexical_block ]
!22 = metadata !{i32 590080, metadata !21, metadata !"v", metadata !2, i32 11, metadata !3, i32 0} ; [ DW_TAG_auto_variable ]
!23 = metadata !{i32 12, i32 3, metadata !21, null}
!24 = metadata !{i32 13, i32 3, metadata !21, null}
!25 = metadata !{i32 14, i32 3, metadata !21, null}
!26 = metadata !{i32 590081, metadata !11, metadata !"arg", metadata !2, i32 16777232, metadata !14, i32 0} ; [ DW_TAG_arg_variable ]
!27 = metadata !{i32 16, i32 11, metadata !11, null}
!28 = metadata !{i32 590081, metadata !11, metadata !"v", metadata !2, i32 33554448, metadata !14, i32 0} ; [ DW_TAG_arg_variable ]
!29 = metadata !{i32 16, i32 20, metadata !11, null}
!30 = metadata !{i32 17, i32 5, metadata !31, null}
!31 = metadata !{i32 589835, metadata !11, i32 16, i32 23, metadata !2, i32 1} ; [ DW_TAG_lexical_block ]
!32 = metadata !{i32 18, i32 14, metadata !33, null}
!33 = metadata !{i32 589835, metadata !31, i32 17, i32 17, metadata !2, i32 2} ; [ DW_TAG_lexical_block ]
!34 = metadata !{i32 19, i32 14, metadata !33, null}
!35 = metadata !{i32 20, i32 14, metadata !33, null}
!36 = metadata !{i32 21, i32 14, metadata !33, null}
!37 = metadata !{i32 23, i32 1, metadata !31, null}
!38 = metadata !{i32 0}
!39 = metadata !{i32 590080, metadata !40, metadata !"r", metadata !2, i32 27, metadata !14, i32 0} ; [ DW_TAG_auto_variable ]
!40 = metadata !{i32 589835, metadata !15, i32 26, i32 1, metadata !2, i32 3} ; [ DW_TAG_lexical_block ]
!41 = metadata !{i32 28, i32 5, metadata !40, null}
!42 = metadata !{i32 590080, metadata !40, metadata !"i", metadata !2, i32 27, metadata !14, i32 0} ; [ DW_TAG_auto_variable ]
!43 = metadata !{i32 29, i32 5, metadata !40, null}
!44 = metadata !{i32 31, i32 9, metadata !45, null}
!45 = metadata !{i32 589835, metadata !46, i32 30, i32 5, metadata !2, i32 5} ; [ DW_TAG_lexical_block ]
!46 = metadata !{i32 589835, metadata !40, i32 29, i32 5, metadata !2, i32 4} ; [ DW_TAG_lexical_block ]
!47 = metadata !{i32 32, i32 5, metadata !45, null}
!48 = metadata !{i32 29, i32 17, metadata !46, null}
!49 = metadata !{i32 34, i32 5, metadata !40, null}
