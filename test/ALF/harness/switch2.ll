; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@u32_init = global i32 3, align 4
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

define i32 @s(i32 %v) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %v}, i64 0, metadata !26), !dbg !27
  call void @llvm.dbg.value(metadata !28, i64 0, metadata !29), !dbg !31
  call void @llvm.dbg.value(metadata !28, i64 0, metadata !32), !dbg !31
  br label %bb1, !dbg !31

bb1:                                              ; preds = %bb3, %bb
  %i.0 = phi i32 [ 0, %bb ], [ %tmp7, %bb3 ]
  %r2.0 = phi i32 [ 0, %bb ], [ %tmp6, %bb3 ]
  %tmp = icmp slt i32 %i.0, 32, !dbg !31
  br i1 %tmp, label %bb2, label %bb8, !dbg !31

bb2:                                              ; preds = %bb1
  call void @llvm.dbg.value(metadata !{i32 %tmp6}, i64 0, metadata !32), !dbg !31
  br label %bb3, !dbg !31

bb3:                                              ; preds = %bb2
  %tmp4 = lshr i32 %v, %i.0, !dbg !31
  %tmp5 = and i32 %tmp4, 1, !dbg !31
  %tmp6 = xor i32 %r2.0, %tmp5, !dbg !31
  %tmp7 = add nsw i32 %i.0, 1, !dbg !31
  call void @llvm.dbg.value(metadata !{i32 %tmp7}, i64 0, metadata !29), !dbg !31
  br label %bb1, !dbg !31

bb8:                                              ; preds = %bb1
  switch i32 %v, label %bb19 [
    i32 0, label %bb9
    i32 3, label %bb9
    i32 7, label %bb9
    i32 13, label %bb9
    i32 21, label %bb9
    i32 29, label %bb9
    i32 381, label %bb9
    i32 4872, label %bb9
    i32 5001, label %bb9
  ], !dbg !33

bb9:                                              ; preds = %bb8, %bb8, %bb8, %bb8, %bb8, %bb8, %bb8, %bb8, %bb8
  call void @llvm.dbg.value(metadata !28, i64 0, metadata !29), !dbg !34
  call void @llvm.dbg.value(metadata !28, i64 0, metadata !36), !dbg !34
  br label %bb10, !dbg !34

bb10:                                             ; preds = %bb13, %bb9
  %r1.0 = phi i32 [ 0, %bb9 ], [ %tmp16, %bb13 ]
  %i.1 = phi i32 [ 0, %bb9 ], [ %tmp17, %bb13 ]
  %tmp11 = icmp slt i32 %i.1, 32, !dbg !34
  br i1 %tmp11, label %bb12, label %bb18, !dbg !34

bb12:                                             ; preds = %bb10
  call void @llvm.dbg.value(metadata !{i32 %tmp16}, i64 0, metadata !36), !dbg !34
  br label %bb13, !dbg !34

bb13:                                             ; preds = %bb12
  %tmp14 = lshr i32 %v, %i.1, !dbg !34
  %tmp15 = and i32 %tmp14, 7, !dbg !34
  %tmp16 = xor i32 %r1.0, %tmp15, !dbg !34
  %tmp17 = add nsw i32 %i.1, 1, !dbg !34
  call void @llvm.dbg.value(metadata !{i32 %tmp17}, i64 0, metadata !29), !dbg !34
  br label %bb10, !dbg !34

bb18:                                             ; preds = %bb10
  br label %bb29, !dbg !37

bb19:                                             ; preds = %bb8
  call void @llvm.dbg.value(metadata !28, i64 0, metadata !29), !dbg !38
  call void @llvm.dbg.value(metadata !28, i64 0, metadata !36), !dbg !38
  br label %bb20, !dbg !38

bb20:                                             ; preds = %bb23, %bb19
  %r1.1 = phi i32 [ 0, %bb19 ], [ %tmp26, %bb23 ]
  %i.2 = phi i32 [ 0, %bb19 ], [ %tmp27, %bb23 ]
  %tmp21 = icmp slt i32 %i.2, 32, !dbg !38
  br i1 %tmp21, label %bb22, label %bb28, !dbg !38

bb22:                                             ; preds = %bb20
  call void @llvm.dbg.value(metadata !{i32 %tmp26}, i64 0, metadata !36), !dbg !38
  br label %bb23, !dbg !38

bb23:                                             ; preds = %bb22
  %tmp24 = lshr i32 %v, %i.2, !dbg !38
  %tmp25 = and i32 %tmp24, 3, !dbg !38
  %tmp26 = xor i32 %r1.1, %tmp25, !dbg !38
  %tmp27 = add nsw i32 %i.2, 1, !dbg !38
  call void @llvm.dbg.value(metadata !{i32 %tmp27}, i64 0, metadata !29), !dbg !38
  br label %bb20, !dbg !38

bb28:                                             ; preds = %bb20
  br label %bb29, !dbg !39

bb29:                                             ; preds = %bb28, %bb18
  %r1.2 = phi i32 [ %r1.1, %bb28 ], [ %r1.0, %bb18 ]
  %tmp30 = and i32 %r1.2, 1, !dbg !40
  %tmp31 = icmp eq i32 %tmp30, %r2.0, !dbg !40
  br i1 %tmp31, label %bb33, label %bb32, !dbg !40

bb32:                                             ; preds = %bb29
  br label %bb34, !dbg !40

bb33:                                             ; preds = %bb29
  br label %bb34, !dbg !41

bb34:                                             ; preds = %bb33, %bb32
  %.0 = phi i32 [ 1, %bb32 ], [ 0, %bb33 ]
  ret i32 %.0, !dbg !42
}

define i32 @main() nounwind {
bb:
  %tmp = call i32 @nondet_u32(i32 1, i32 8192), !dbg !43
  %tmp1 = call i32 @s(i32 %tmp), !dbg !43
  %tmp2 = call i32 @nondet_u32(i32 5001, i32 5001), !dbg !43
  %tmp3 = call i32 @s(i32 %tmp2), !dbg !43
  %tmp4 = add nsw i32 %tmp1, %tmp3, !dbg !43
  %tmp5 = call i32 @nondet_u32(i32 5002, i32 5002), !dbg !43
  %tmp6 = call i32 @s(i32 %tmp5), !dbg !43
  %tmp7 = add nsw i32 %tmp4, %tmp6, !dbg !43
  ret i32 %tmp7, !dbg !43
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.gv = !{!0, !5}
!llvm.dbg.sp = !{!8, !11, !15}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"u32_init", metadata !"u32_init", metadata !"", metadata !2, i32 8, metadata !3, i32 0, i32 1, i32* @u32_init} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"switch2.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"switch2.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589846, metadata !1, metadata !"uint32_t", metadata !2, i32 52, i64 0, i64 0, i64 0, i32 0, metadata !4} ; [ DW_TAG_typedef ]
!4 = metadata !{i32 589860, metadata !1, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!5 = metadata !{i32 589876, i32 0, metadata !1, metadata !"u32_ptr", metadata !"u32_ptr", metadata !"", metadata !2, i32 9, metadata !6, i32 0, i32 1, i32** @u32_ptr} ; [ DW_TAG_variable ]
!6 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !7} ; [ DW_TAG_pointer_type ]
!7 = metadata !{i32 589877, metadata !1, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !3} ; [ DW_TAG_volatile_type ]
!8 = metadata !{i32 589870, i32 0, metadata !2, metadata !"nondet_u32", metadata !"nondet_u32", metadata !"", metadata !2, i32 10, metadata !9, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32, i32)* @nondet_u32} ; [ DW_TAG_subprogram ]
!9 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !10, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!10 = metadata !{metadata !3}
!11 = metadata !{i32 589870, i32 0, metadata !2, metadata !"s", metadata !"s", metadata !"", metadata !2, i32 17, metadata !12, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (i32)* @s} ; [ DW_TAG_subprogram ]
!12 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !13, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!13 = metadata !{metadata !14}
!14 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!15 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 46, metadata !12, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
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
!26 = metadata !{i32 590081, metadata !11, metadata !"v", metadata !2, i32 16777233, metadata !3, i32 0} ; [ DW_TAG_arg_variable ]
!27 = metadata !{i32 17, i32 16, metadata !11, null}
!28 = metadata !{i32 0}
!29 = metadata !{i32 590080, metadata !30, metadata !"i", metadata !2, i32 18, metadata !14, i32 0} ; [ DW_TAG_auto_variable ]
!30 = metadata !{i32 589835, metadata !11, i32 17, i32 19, metadata !2, i32 1} ; [ DW_TAG_lexical_block ]
!31 = metadata !{i32 20, i32 3, metadata !30, null}
!32 = metadata !{i32 590080, metadata !30, metadata !"r2", metadata !2, i32 19, metadata !3, i32 0} ; [ DW_TAG_auto_variable ]
!33 = metadata !{i32 21, i32 3, metadata !30, null}
!34 = metadata !{i32 32, i32 7, metadata !35, null}
!35 = metadata !{i32 589835, metadata !30, i32 22, i32 5, metadata !2, i32 3} ; [ DW_TAG_lexical_block ]
!36 = metadata !{i32 590080, metadata !30, metadata !"r1", metadata !2, i32 19, metadata !3, i32 0} ; [ DW_TAG_auto_variable ]
!37 = metadata !{i32 33, i32 7, metadata !35, null}
!38 = metadata !{i32 35, i32 7, metadata !35, null}
!39 = metadata !{i32 36, i32 7, metadata !35, null}
!40 = metadata !{i32 41, i32 3, metadata !30, null}
!41 = metadata !{i32 42, i32 3, metadata !30, null}
!42 = metadata !{i32 43, i32 1, metadata !30, null}
!43 = metadata !{i32 47, i32 3, metadata !44, null}
!44 = metadata !{i32 589835, metadata !15, i32 46, i32 1, metadata !2, i32 6} ; [ DW_TAG_lexical_block ]
