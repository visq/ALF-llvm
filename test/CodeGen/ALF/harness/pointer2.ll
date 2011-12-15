; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

%struct.mstruct = type { [4 x i32], [4 x i8], [4 x i32] }

@str = global [9 x i8] c"9-char-s\00", align 1
@a = common global %struct.mstruct zeroinitializer, align 4
@b = common global %struct.mstruct zeroinitializer, align 4

define i32 @main() nounwind {
bb:
  %c = alloca %struct.mstruct, align 4
  call void @llvm.dbg.value(metadata !23, i64 0, metadata !24), !dbg !26
  call void @llvm.dbg.declare(metadata !{%struct.mstruct* %c}, metadata !27), !dbg !28
  call void @llvm.dbg.value(metadata !29, i64 0, metadata !30), !dbg !33
  call void @llvm.dbg.value(metadata !34, i64 0, metadata !24), !dbg !35
  call void @llvm.dbg.value(metadata !36, i64 0, metadata !37), !dbg !38
  call void @llvm.dbg.value(metadata !39, i64 0, metadata !24), !dbg !40
  call void @llvm.dbg.value(metadata !41, i64 0, metadata !42), !dbg !43
  call void @llvm.dbg.value(metadata !44, i64 0, metadata !24), !dbg !45
  %tmp = getelementptr inbounds %struct.mstruct* %c, i32 0, i32 1, i32 2, !dbg !46
  %tmp2 = getelementptr inbounds %struct.mstruct* %c, i32 0, i32 0, i32 1, !dbg !46
  %tmp3 = ptrtoint i8* %tmp to i32, !dbg !46
  %tmp4 = ptrtoint i32* %tmp2 to i32, !dbg !46
  %tmp5 = sub i32 %tmp3, %tmp4, !dbg !46
  call void @llvm.dbg.value(metadata !{i32 %tmp5}, i64 0, metadata !47), !dbg !46
  %not. = icmp ne i32 %tmp5, 14
  %tmp6 = zext i1 %not. to i32, !dbg !48
  call void @llvm.dbg.value(metadata !{i32 %tmp6}, i64 0, metadata !24), !dbg !48
  call void @llvm.dbg.value(metadata !23, i64 0, metadata !49), !dbg !50
  call void @llvm.dbg.value(metadata !51, i64 0, metadata !52), !dbg !54
  call void @llvm.dbg.value(metadata !55, i64 0, metadata !56), !dbg !57
  br label %bb7, !dbg !58

bb7:                                              ; preds = %bb9, %bb
  %steps.0 = phi i32 [ 0, %bb ], [ %tmp10, %bb9 ]
  %p1.0 = phi i8* [ getelementptr inbounds ([9 x i8]* @str, i32 0, i32 1), %bb ], [ %tmp11, %bb9 ]
  %p2.0 = phi i8* [ getelementptr inbounds ([9 x i8]* @str, i32 0, i32 8), %bb ], [ %tmp12, %bb9 ]
  %tmp8 = icmp ult i8* %p1.0, %p2.0, !dbg !58
  br i1 %tmp8, label %bb9, label %bb13, !dbg !58

bb9:                                              ; preds = %bb7
  %tmp10 = add nsw i32 %steps.0, 1, !dbg !59
  call void @llvm.dbg.value(metadata !{i32 %tmp10}, i64 0, metadata !49), !dbg !59
  %tmp11 = getelementptr inbounds i8* %p1.0, i32 1, !dbg !61
  call void @llvm.dbg.value(metadata !{i8* %tmp11}, i64 0, metadata !52), !dbg !61
  %tmp12 = getelementptr inbounds i8* %p2.0, i32 -1, !dbg !62
  call void @llvm.dbg.value(metadata !{i8* %tmp12}, i64 0, metadata !56), !dbg !62
  br label %bb7, !dbg !63

bb13:                                             ; preds = %bb7
  %not.1 = icmp ne i32 %steps.0, 4
  %tmp14 = zext i1 %not.1 to i32, !dbg !64
  %tmp15 = add nsw i32 %tmp6, %tmp14, !dbg !64
  call void @llvm.dbg.value(metadata !{i32 %tmp15}, i64 0, metadata !24), !dbg !64
  ret i32 %tmp15, !dbg !65
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.gv = !{!0, !7, !19}
!llvm.dbg.sp = !{!20}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"str", metadata !"str", metadata !"", metadata !2, i32 19, metadata !3, i32 0, i32 1, [9 x i8]* @str} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"pointer2.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"pointer2.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 72, i64 8, i32 0, i32 0, metadata !4, metadata !5, i32 0, i32 0} ; [ DW_TAG_array_type ]
!4 = metadata !{i32 589860, metadata !1, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!5 = metadata !{metadata !6}
!6 = metadata !{i32 589857, i64 0, i64 8}         ; [ DW_TAG_subrange_type ]
!7 = metadata !{i32 589876, i32 0, metadata !1, metadata !"a", metadata !"a", metadata !"", metadata !2, i32 18, metadata !8, i32 0, i32 1, %struct.mstruct* @a} ; [ DW_TAG_variable ]
!8 = metadata !{i32 589846, metadata !1, metadata !"mstruct", metadata !2, i32 16, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_typedef ]
!9 = metadata !{i32 589843, metadata !1, metadata !"", metadata !2, i32 12, i64 288, i64 32, i32 0, i32 0, i32 0, metadata !10, i32 0, i32 0} ; [ DW_TAG_structure_type ]
!10 = metadata !{metadata !11, metadata !16, metadata !18}
!11 = metadata !{i32 589837, metadata !2, metadata !"x", metadata !2, i32 13, i64 128, i64 32, i64 0, i32 0, metadata !12} ; [ DW_TAG_member ]
!12 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 128, i64 32, i32 0, i32 0, metadata !13, metadata !14, i32 0, i32 0} ; [ DW_TAG_array_type ]
!13 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!14 = metadata !{metadata !15}
!15 = metadata !{i32 589857, i64 0, i64 3}        ; [ DW_TAG_subrange_type ]
!16 = metadata !{i32 589837, metadata !2, metadata !"y", metadata !2, i32 14, i64 32, i64 8, i64 128, i32 0, metadata !17} ; [ DW_TAG_member ]
!17 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 32, i64 8, i32 0, i32 0, metadata !4, metadata !14, i32 0, i32 0} ; [ DW_TAG_array_type ]
!18 = metadata !{i32 589837, metadata !2, metadata !"z", metadata !2, i32 15, i64 128, i64 32, i64 160, i32 0, metadata !12} ; [ DW_TAG_member ]
!19 = metadata !{i32 589876, i32 0, metadata !1, metadata !"b", metadata !"b", metadata !"", metadata !2, i32 20, metadata !8, i32 0, i32 1, %struct.mstruct* @b} ; [ DW_TAG_variable ]
!20 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 23, metadata !21, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!21 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !22, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!22 = metadata !{metadata !13}
!23 = metadata !{i32 0}
!24 = metadata !{i32 590080, metadata !25, metadata !"res", metadata !2, i32 24, metadata !13, i32 0} ; [ DW_TAG_auto_variable ]
!25 = metadata !{i32 589835, metadata !20, i32 23, i32 1, metadata !2, i32 0} ; [ DW_TAG_lexical_block ]
!26 = metadata !{i32 24, i32 14, metadata !25, null}
!27 = metadata !{i32 590080, metadata !25, metadata !"c", metadata !2, i32 25, metadata !8, i32 0} ; [ DW_TAG_auto_variable ]
!28 = metadata !{i32 25, i32 11, metadata !25, null}
!29 = metadata !{i32 sdiv exact (i32 sub (i32 ptrtoint (i32* getelementptr inbounds (%struct.mstruct* @a, i32 0, i32 0, i32 3) to i32), i32 ptrtoint (%struct.mstruct* @a to i32)), i32 4)}
!30 = metadata !{i32 590080, metadata !25, metadata !"d1", metadata !2, i32 28, metadata !31, i32 0} ; [ DW_TAG_auto_variable ]
!31 = metadata !{i32 589846, metadata !1, metadata !"size_t", metadata !2, i32 32, i64 0, i64 0, i64 0, i32 0, metadata !32} ; [ DW_TAG_typedef ]
!32 = metadata !{i32 589860, metadata !1, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!33 = metadata !{i32 28, i32 32, metadata !25, null}
!34 = metadata !{i32 select (i1 icmp eq (i32 sdiv exact (i32 sub (i32 ptrtoint (i32* getelementptr inbounds (%struct.mstruct* @a, i32 0, i32 0, i32 3) to i32), i32 ptrtoint (%struct.mstruct* @a to i32)), i32 4), i32 3), i32 0, i32 1)}
!35 = metadata !{i32 29, i32 3, metadata !25, null}
!36 = metadata !{i32 sdiv exact (i32 sub (i32 ptrtoint ([4 x i32]* getelementptr inbounds (%struct.mstruct* @b, i32 0, i32 2) to i32), i32 ptrtoint (%struct.mstruct* @b to i32)), i32 16)}
!37 = metadata !{i32 590080, metadata !25, metadata !"d2", metadata !2, i32 32, metadata !31, i32 0} ; [ DW_TAG_auto_variable ]
!38 = metadata !{i32 32, i32 27, metadata !25, null}
!39 = metadata !{i32 add (i32 select (i1 icmp eq (i32 sdiv exact (i32 sub (i32 ptrtoint (i32* getelementptr inbounds (%struct.mstruct* @a, i32 0, i32 0, i32 3) to i32), i32 ptrtoint (%struct.mstruct* @a to i32)), i32 4), i32 3), i32 0, i32 1), i32 select (i1 icmp eq (i32 sdiv exact (i32 sub (i32 ptrtoint ([4 x i32]* getelementptr inbounds (%struct.mstruct* @b, i32 0, i32 2) to i32), i32 ptrtoint (%struct.mstruct* @b to i32)), i32 16), i32 1), i32 0, i32 1))}
!40 = metadata !{i32 33, i32 3, metadata !25, null}
!41 = metadata !{i32 sub (i32 ptrtoint ([4 x i32]* getelementptr inbounds (%struct.mstruct* @b, i32 0, i32 2) to i32), i32 ptrtoint (%struct.mstruct* @b to i32))}
!42 = metadata !{i32 590080, metadata !25, metadata !"d3", metadata !2, i32 36, metadata !31, i32 0} ; [ DW_TAG_auto_variable ]
!43 = metadata !{i32 36, i32 42, metadata !25, null}
!44 = metadata !{i32 add (i32 add (i32 select (i1 icmp eq (i32 sdiv exact (i32 sub (i32 ptrtoint (i32* getelementptr inbounds (%struct.mstruct* @a, i32 0, i32 0, i32 3) to i32), i32 ptrtoint (%struct.mstruct* @a to i32)), i32 4), i32 3), i32 0, i32 1), i32 select (i1 icmp eq (i32 sdiv exact (i32 sub (i32 ptrtoint ([4 x i32]* getelementptr inbounds (%struct.mstruct* @b, i32 0, i32 2) to i32), i32 ptrtoint (%struct.mstruct* @b to i32)), i32 16), i32 1), i32 0, i32 1)), i32 select (i1 icmp eq (i32 sub (i32 ptrtoint ([4 x i32]* getelementptr inbounds (%struct.mstruct* @b, i32 0, i32 2) to i32), i32 ptrtoint (%struct.mstruct* @b to i32)), i32 20), i32 0, i32 1))}
!45 = metadata !{i32 37, i32 3, metadata !25, null}
!46 = metadata !{i32 40, i32 46, metadata !25, null}
!47 = metadata !{i32 590080, metadata !25, metadata !"d4", metadata !2, i32 40, metadata !31, i32 0} ; [ DW_TAG_auto_variable ]
!48 = metadata !{i32 41, i32 3, metadata !25, null}
!49 = metadata !{i32 590080, metadata !25, metadata !"steps", metadata !2, i32 44, metadata !13, i32 0} ; [ DW_TAG_auto_variable ]
!50 = metadata !{i32 44, i32 16, metadata !25, null}
!51 = metadata !{i8* getelementptr inbounds ([9 x i8]* @str, i32 0, i32 1)}
!52 = metadata !{i32 590080, metadata !25, metadata !"p1", metadata !2, i32 45, metadata !53, i32 0} ; [ DW_TAG_auto_variable ]
!53 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !4} ; [ DW_TAG_pointer_type ]
!54 = metadata !{i32 45, i32 22, metadata !25, null}
!55 = metadata !{i8* getelementptr inbounds ([9 x i8]* @str, i32 0, i32 8)}
!56 = metadata !{i32 590080, metadata !25, metadata !"p2", metadata !2, i32 46, metadata !53, i32 0} ; [ DW_TAG_auto_variable ]
!57 = metadata !{i32 46, i32 22, metadata !25, null}
!58 = metadata !{i32 47, i32 3, metadata !25, null}
!59 = metadata !{i32 48, i32 5, metadata !60, null}
!60 = metadata !{i32 589835, metadata !25, i32 47, i32 18, metadata !2, i32 1} ; [ DW_TAG_lexical_block ]
!61 = metadata !{i32 49, i32 5, metadata !60, null}
!62 = metadata !{i32 50, i32 5, metadata !60, null}
!63 = metadata !{i32 51, i32 3, metadata !60, null}
!64 = metadata !{i32 52, i32 3, metadata !25, null}
!65 = metadata !{i32 54, i32 3, metadata !25, null}
