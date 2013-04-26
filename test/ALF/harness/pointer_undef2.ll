; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

%struct.mstruct = type { [4 x i32], [4 x i8], [4 x i32] }

@str = global [9 x i8] c"9-char-s\00", align 1
@a = common global %struct.mstruct zeroinitializer, align 4
@b = common global %struct.mstruct zeroinitializer, align 4

define i32 @main() nounwind {
bb:
  call void @llvm.dbg.value(metadata !23, i64 0, metadata !24), !dbg !26
  call void @llvm.dbg.value(metadata !23, i64 0, metadata !27), !dbg !28
  call void @llvm.dbg.value(metadata !29, i64 0, metadata !30), !dbg !32
  call void @llvm.dbg.value(metadata !33, i64 0, metadata !34), !dbg !35
  br label %bb1, !dbg !36

bb1:                                              ; preds = %bb11, %bb
  %s.0 = phi i8* [ bitcast (%struct.mstruct* @a to i8*), %bb ], [ %tmp13, %bb11 ]
  %i.0 = phi i32 [ 0, %bb ], [ %tmp12, %bb11 ]
  %r.0 = phi i8 [ undef, %bb ], [ %tmp8, %bb11 ]
  %tmp = icmp eq i8* %s.0, bitcast (%struct.mstruct* @b to i8*), !dbg !36
  br i1 %tmp, label %bb14, label %bb2, !dbg !36

bb2:                                              ; preds = %bb1
  call void @llvm.dbg.value(metadata !{i8* %tmp13}, i64 0, metadata !30), !dbg !37
  %tmp3 = load i8* %s.0, align 1, !dbg !37
  %tmp4 = sext i8 %tmp3 to i32, !dbg !37
  %tmp5 = srem i32 %tmp4, 2, !dbg !37
  %tmp6 = zext i8 %r.0 to i32
  %tmp7 = add nsw i32 %tmp6, %tmp5, !dbg !37
  %tmp8 = trunc i32 %tmp7 to i8, !dbg !37
  call void @llvm.dbg.value(metadata !{i8 %tmp8}, i64 0, metadata !39), !dbg !37
  call void @llvm.dbg.value(metadata !{i32 %tmp12}, i64 0, metadata !27), !dbg !40
  %tmp9 = icmp sgt i32 %i.0, 10, !dbg !40
  br i1 %tmp9, label %bb10, label %bb11, !dbg !40

bb10:                                             ; preds = %bb2
  br label %bb14, !dbg !40

bb11:                                             ; preds = %bb2
  %tmp12 = add nsw i32 %i.0, 1, !dbg !40
  %tmp13 = getelementptr inbounds i8* %s.0, i32 1, !dbg !37
  br label %bb1, !dbg !41

bb14:                                             ; preds = %bb10, %bb1
  %r.1 = phi i8 [ %tmp8, %bb10 ], [ %r.0, %bb1 ]
  call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !24), !dbg !42
  %tmp15 = sext i8 %r.1 to i32, !dbg !43
  ret i32 %tmp15, !dbg !43
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.gv = !{!0, !7, !19}
!llvm.dbg.sp = !{!20}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"str", metadata !"str", metadata !"", metadata !2, i32 17, metadata !3, i32 0, i32 1, [9 x i8]* @str} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"pointer_undef2.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"pointer_undef2.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 72, i64 8, i32 0, i32 0, metadata !4, metadata !5, i32 0, i32 0} ; [ DW_TAG_array_type ]
!4 = metadata !{i32 589860, metadata !1, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!5 = metadata !{metadata !6}
!6 = metadata !{i32 589857, i64 0, i64 8}         ; [ DW_TAG_subrange_type ]
!7 = metadata !{i32 589876, i32 0, metadata !1, metadata !"a", metadata !"a", metadata !"", metadata !2, i32 16, metadata !8, i32 0, i32 1, %struct.mstruct* @a} ; [ DW_TAG_variable ]
!8 = metadata !{i32 589846, metadata !1, metadata !"mstruct", metadata !2, i32 15, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_typedef ]
!9 = metadata !{i32 589843, metadata !1, metadata !"", metadata !2, i32 11, i64 288, i64 32, i32 0, i32 0, i32 0, metadata !10, i32 0, i32 0} ; [ DW_TAG_structure_type ]
!10 = metadata !{metadata !11, metadata !16, metadata !18}
!11 = metadata !{i32 589837, metadata !2, metadata !"x", metadata !2, i32 12, i64 128, i64 32, i64 0, i32 0, metadata !12} ; [ DW_TAG_member ]
!12 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 128, i64 32, i32 0, i32 0, metadata !13, metadata !14, i32 0, i32 0} ; [ DW_TAG_array_type ]
!13 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!14 = metadata !{metadata !15}
!15 = metadata !{i32 589857, i64 0, i64 3}        ; [ DW_TAG_subrange_type ]
!16 = metadata !{i32 589837, metadata !2, metadata !"y", metadata !2, i32 13, i64 32, i64 8, i64 128, i32 0, metadata !17} ; [ DW_TAG_member ]
!17 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 8, i32 0, i32 0, metadata !4, metadata !14, i32 0, i32 0} ; [ DW_TAG_array_type ]
!18 = metadata !{i32 589837, metadata !2, metadata !"z", metadata !2, i32 14, i64 128, i64 32, i64 160, i32 0, metadata !12} ; [ DW_TAG_member ]
!19 = metadata !{i32 589876, i32 0, metadata !1, metadata !"b", metadata !"b", metadata !"", metadata !2, i32 18, metadata !8, i32 0, i32 1, %struct.mstruct* @b} ; [ DW_TAG_variable ]
!20 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 21, metadata !21, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!21 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !22, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!22 = metadata !{metadata !13}
!23 = metadata !{i32 0}
!24 = metadata !{i32 590080, metadata !25, metadata !"res", metadata !2, i32 22, metadata !13, i32 0} ; [ DW_TAG_auto_variable ]
!25 = metadata !{i32 589835, metadata !20, i32 21, i32 1, metadata !2, i32 0} ; [ DW_TAG_lexical_block ]
!26 = metadata !{i32 22, i32 14, metadata !25, null}
!27 = metadata !{i32 590080, metadata !25, metadata !"i", metadata !2, i32 23, metadata !13, i32 0} ; [ DW_TAG_auto_variable ]
!28 = metadata !{i32 23, i32 12, metadata !25, null}
!29 = metadata !{i8* bitcast (%struct.mstruct* @a to i8*)}
!30 = metadata !{i32 590080, metadata !25, metadata !"s", metadata !2, i32 26, metadata !31, i32 0} ; [ DW_TAG_auto_variable ]
!31 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !4} ; [ DW_TAG_pointer_type ]
!32 = metadata !{i32 26, i32 23, metadata !25, null}
!33 = metadata !{i8* bitcast (%struct.mstruct* @b to i8*)}
!34 = metadata !{i32 590080, metadata !25, metadata !"e", metadata !2, i32 27, metadata !31, i32 0} ; [ DW_TAG_auto_variable ]
!35 = metadata !{i32 27, i32 23, metadata !25, null}
!36 = metadata !{i32 29, i32 3, metadata !25, null}
!37 = metadata !{i32 31, i32 7, metadata !38, null}
!38 = metadata !{i32 589835, metadata !25, i32 30, i32 5, metadata !2, i32 1} ; [ DW_TAG_lexical_block ]
!39 = metadata !{i32 590080, metadata !25, metadata !"r", metadata !2, i32 28, metadata !4, i32 0} ; [ DW_TAG_auto_variable ]
!40 = metadata !{i32 32, i32 7, metadata !38, null}
!41 = metadata !{i32 33, i32 5, metadata !38, null}
!42 = metadata !{i32 34, i32 3, metadata !25, null}
!43 = metadata !{i32 35, i32 3, metadata !25, null}
