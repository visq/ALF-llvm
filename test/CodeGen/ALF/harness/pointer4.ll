; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

%struct.s = type { i16, i8 }

@dbg = common global i32 0, align 4

define i32 @main() nounwind {
bb:
  call void @llvm.dbg.value(metadata !7, i64 0, metadata !8), !dbg !10
  store i32 1, i32* inttoptr (i32 36 to i32*), align 4, !dbg !11
  store i32 2, i32* inttoptr (i32 40 to i32*), align 8, !dbg !12
  store i32 3, i32* inttoptr (i32 44 to i32*), align 4, !dbg !13
  store i32 4, i32* inttoptr (i32 48 to i32*), align 16, !dbg !14
  store i16 5, i16* inttoptr (i32 1114112 to i16*), align 65536, !dbg !15
  store i8 6, i8* inttoptr (i32 2031618 to i8*), align 2, !dbg !16
  call void @llvm.dbg.value(metadata !17, i64 0, metadata !18), !dbg !19
  call void @llvm.dbg.value(metadata !7, i64 0, metadata !8), !dbg !20
  volatile store i32 23, i32* inttoptr (i32 32 to i32*), align 32, !dbg !21
  call void @llvm.dbg.value(metadata !22, i64 0, metadata !18), !dbg !23
  call void @llvm.dbg.value(metadata !7, i64 0, metadata !8), !dbg !24
  call void @llvm.dbg.value(metadata !25, i64 0, metadata !26), !dbg !28
  call void @llvm.dbg.value(metadata !7, i64 0, metadata !29), !dbg !30
  br label %bb3, !dbg !30

bb3:                                              ; preds = %bb11, %bb
  %xp.0 = phi i32* [ inttoptr (i32 36 to i32*), %bb ], [ %xp.1, %bb11 ]
  %i.0 = phi i32 [ 0, %bb ], [ %tmp12, %bb11 ]
  %tmp = icmp slt i32 %i.0, 3, !dbg !30
  br i1 %tmp, label %bb4, label %bb13, !dbg !30

bb4:                                              ; preds = %bb3
  %tmp5 = getelementptr inbounds i32* inttoptr (i32 36 to i32*), i32 %i.0, !dbg !31
  %tmp6 = load i32* %tmp5, align 4, !dbg !31
  %tmp7 = icmp eq i32 %tmp6, 3, !dbg !31
  br i1 %tmp7, label %bb8, label %bb10, !dbg !31

bb8:                                              ; preds = %bb4
  %tmp9 = getelementptr inbounds i32* inttoptr (i32 36 to i32*), i32 %i.0, !dbg !31
  call void @llvm.dbg.value(metadata !{i32* %tmp9}, i64 0, metadata !26), !dbg !31
  br label %bb10, !dbg !31

bb10:                                             ; preds = %bb8, %bb4
  %xp.1 = phi i32* [ %tmp9, %bb8 ], [ %xp.0, %bb4 ]
  br label %bb11, !dbg !34

bb11:                                             ; preds = %bb10
  %tmp12 = add nsw i32 %i.0, 1, !dbg !35
  call void @llvm.dbg.value(metadata !{i32 %tmp12}, i64 0, metadata !29), !dbg !35
  br label %bb3, !dbg !35

bb13:                                             ; preds = %bb3
  %tmp14 = load i32* %xp.0, align 4, !dbg !36
  call void @llvm.dbg.value(metadata !{i32 %tmp14}, i64 0, metadata !18), !dbg !36
  %not. = icmp ne i32 %tmp14, 3
  %tmp15 = zext i1 %not. to i32, !dbg !37
  call void @llvm.dbg.value(metadata !{i32 %tmp15}, i64 0, metadata !8), !dbg !37
  %tmp16 = load i16* inttoptr (i32 1114112 to i16*), align 65536, !dbg !38
  %tmp17 = sext i16 %tmp16 to i32, !dbg !38
  %tmp18 = load i8* inttoptr (i32 2031618 to i8*), align 2, !dbg !38
  %tmp19 = sext i8 %tmp18 to i32, !dbg !38
  %tmp20 = add nsw i32 %tmp17, %tmp19, !dbg !38
  %not.1 = icmp ne i32 %tmp20, 11
  %tmp21 = zext i1 %not.1 to i32, !dbg !38
  %tmp22 = add nsw i32 %tmp15, %tmp21, !dbg !38
  call void @llvm.dbg.value(metadata !{i32 %tmp22}, i64 0, metadata !8), !dbg !38
  call void @llvm.dbg.value(metadata !7, i64 0, metadata !18), !dbg !39
  call void @llvm.dbg.value(metadata !40, i64 0, metadata !41), !dbg !49
  call void @llvm.dbg.value(metadata !7, i64 0, metadata !29), !dbg !50
  br label %bb23, !dbg !51

bb23:                                             ; preds = %bb30, %bb13
  %i.1 = phi i32 [ 0, %bb13 ], [ %tmp31, %bb30 ]
  %sp.0 = phi %struct.s* [ inttoptr (i32 1114112 to %struct.s*), %bb13 ], [ %tmp27, %bb30 ]
  %tmp24 = icmp ugt %struct.s* %sp.0, inttoptr (i32 2031616 to %struct.s*), !dbg !51
  br i1 %tmp24, label %bb32, label %bb25, !dbg !51

bb25:                                             ; preds = %bb23
  %tmp26 = getelementptr inbounds %struct.s* %sp.0, i32 0, i32 0, !dbg !52
  store i16 2814, i16* %tmp26, align 2, !dbg !52
  %tmp27 = getelementptr inbounds %struct.s* %sp.0, i32 57344, !dbg !54
  call void @llvm.dbg.value(metadata !{%struct.s* %tmp27}, i64 0, metadata !41), !dbg !54
  call void @llvm.dbg.value(metadata !{i32 %tmp31}, i64 0, metadata !29), !dbg !55
  %tmp28 = icmp sgt i32 %i.1, 32, !dbg !55
  br i1 %tmp28, label %bb29, label %bb30, !dbg !55

bb29:                                             ; preds = %bb25
  br label %bb32, !dbg !55

bb30:                                             ; preds = %bb25
  %tmp31 = add nsw i32 %i.1, 1, !dbg !55
  br label %bb23, !dbg !56

bb32:                                             ; preds = %bb29, %bb23
  %sp.1 = phi %struct.s* [ %tmp27, %bb29 ], [ %sp.0, %bb23 ]
  call void @llvm.dbg.value(metadata !7, i64 0, metadata !29), !dbg !57
  br label %bb33, !dbg !58

bb33:                                             ; preds = %bb43, %bb32
  %x.0 = phi i32 [ 0, %bb32 ], [ %tmp39, %bb43 ]
  %i.2 = phi i32 [ 0, %bb32 ], [ %tmp40, %bb43 ]
  %sp.2 = phi %struct.s* [ %sp.1, %bb32 ], [ %tmp44, %bb43 ]
  %tmp34 = icmp ult %struct.s* %sp.2, inttoptr (i32 1343488 to %struct.s*), !dbg !58
  br i1 %tmp34, label %bb45, label %bb35, !dbg !58

bb35:                                             ; preds = %bb33
  call void @llvm.dbg.value(metadata !{%struct.s* %tmp44}, i64 0, metadata !41), !dbg !59
  %tmp36 = getelementptr inbounds %struct.s* %sp.2, i32 -57344, i32 0, !dbg !61
  %tmp37 = load i16* %tmp36, align 2, !dbg !61
  %tmp38 = sext i16 %tmp37 to i32, !dbg !61
  %tmp39 = add nsw i32 %x.0, %tmp38, !dbg !61
  call void @llvm.dbg.value(metadata !{i32 %tmp39}, i64 0, metadata !18), !dbg !61
  %tmp40 = add nsw i32 %i.2, 1, !dbg !62
  call void @llvm.dbg.value(metadata !{i32 %tmp40}, i64 0, metadata !29), !dbg !62
  %tmp41 = icmp sgt i32 %i.2, 32, !dbg !62
  br i1 %tmp41, label %bb42, label %bb43, !dbg !62

bb42:                                             ; preds = %bb35
  br label %bb45, !dbg !62

bb43:                                             ; preds = %bb35
  %tmp44 = getelementptr inbounds %struct.s* %sp.2, i32 -57344, !dbg !59
  br label %bb33, !dbg !63

bb45:                                             ; preds = %bb42, %bb33
  %x.1 = phi i32 [ %tmp39, %bb42 ], [ %x.0, %bb33 ]
  %i.3 = phi i32 [ %tmp40, %bb42 ], [ %i.2, %bb33 ]
  store i32 %i.3, i32* @dbg, align 4, !dbg !64
  %not.2 = icmp ne i32 %x.1, 14070
  %tmp46 = zext i1 %not.2 to i32, !dbg !65
  %tmp47 = add nsw i32 %tmp22, %tmp46, !dbg !65
  call void @llvm.dbg.value(metadata !{i32 %tmp47}, i64 0, metadata !8), !dbg !65
  ret i32 %tmp47, !dbg !66
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}
!llvm.dbg.gv = !{!6}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"main", metadata !"main", metadata !"", metadata !1, i32 53, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"pointer4.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 12, metadata !"pointer4.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !4, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5}
!5 = metadata !{i32 589860, metadata !2, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589876, i32 0, metadata !2, metadata !"dbg", metadata !"dbg", metadata !"", metadata !1, i32 50, metadata !5, i32 0, i32 1, i32* @dbg} ; [ DW_TAG_variable ]
!7 = metadata !{i32 0}
!8 = metadata !{i32 590080, metadata !9, metadata !"res", metadata !1, i32 54, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!9 = metadata !{i32 589835, metadata !0, i32 53, i32 1, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!10 = metadata !{i32 54, i32 14, metadata !9, null}
!11 = metadata !{i32 60, i32 3, metadata !9, null}
!12 = metadata !{i32 61, i32 3, metadata !9, null}
!13 = metadata !{i32 62, i32 3, metadata !9, null}
!14 = metadata !{i32 63, i32 3, metadata !9, null}
!15 = metadata !{i32 64, i32 3, metadata !9, null}
!16 = metadata !{i32 65, i32 3, metadata !9, null}
!17 = metadata !{i32 17}
!18 = metadata !{i32 590080, metadata !9, metadata !"x", metadata !1, i32 56, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!19 = metadata !{i32 75, i32 3, metadata !9, null}
!20 = metadata !{i32 76, i32 3, metadata !9, null}
!21 = metadata !{i32 79, i32 3, metadata !9, null}
!22 = metadata !{i32 23}
!23 = metadata !{i32 81, i32 3, metadata !9, null}
!24 = metadata !{i32 82, i32 3, metadata !9, null}
!25 = metadata !{i32* inttoptr (i32 36 to i32*)}
!26 = metadata !{i32 590080, metadata !9, metadata !"xp", metadata !1, i32 57, metadata !27, i32 0} ; [ DW_TAG_auto_variable ]
!27 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !5} ; [ DW_TAG_pointer_type ]
!28 = metadata !{i32 85, i32 3, metadata !9, null}
!29 = metadata !{i32 590080, metadata !9, metadata !"i", metadata !1, i32 55, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!30 = metadata !{i32 86, i32 3, metadata !9, null}
!31 = metadata !{i32 87, i32 5, metadata !32, null}
!32 = metadata !{i32 589835, metadata !33, i32 86, i32 26, metadata !1, i32 2} ; [ DW_TAG_lexical_block ]
!33 = metadata !{i32 589835, metadata !9, i32 86, i32 3, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!34 = metadata !{i32 88, i32 3, metadata !32, null}
!35 = metadata !{i32 86, i32 21, metadata !33, null}
!36 = metadata !{i32 89, i32 3, metadata !9, null}
!37 = metadata !{i32 90, i32 3, metadata !9, null}
!38 = metadata !{i32 94, i32 3, metadata !9, null}
!39 = metadata !{i32 97, i32 3, metadata !9, null}
!40 = metadata !{%struct.s* inttoptr (i32 1114112 to %struct.s*)}
!41 = metadata !{i32 590080, metadata !9, metadata !"sp", metadata !1, i32 58, metadata !42, i32 0} ; [ DW_TAG_auto_variable ]
!42 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !43} ; [ DW_TAG_pointer_type ]
!43 = metadata !{i32 589843, metadata !2, metadata !"s", metadata !1, i32 35, i64 32, i64 16, i32 0, i32 0, i32 0, metadata !44, i32 0, i32 0} ; [ DW_TAG_structure_type ]
!44 = metadata !{metadata !45, metadata !47}
!45 = metadata !{i32 589837, metadata !1, metadata !"f1", metadata !1, i32 36, i64 16, i64 16, i64 0, i32 0, metadata !46} ; [ DW_TAG_member ]
!46 = metadata !{i32 589860, metadata !2, metadata !"short", null, i32 0, i64 16, i64 16, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!47 = metadata !{i32 589837, metadata !1, metadata !"f2", metadata !1, i32 37, i64 8, i64 8, i64 16, i32 0, metadata !48} ; [ DW_TAG_member ]
!48 = metadata !{i32 589860, metadata !2, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!49 = metadata !{i32 98, i32 3, metadata !9, null}
!50 = metadata !{i32 99, i32 3, metadata !9, null}
!51 = metadata !{i32 101, i32 3, metadata !9, null}
!52 = metadata !{i32 106, i32 7, metadata !53, null}
!53 = metadata !{i32 589835, metadata !9, i32 102, i32 3, metadata !1, i32 3} ; [ DW_TAG_lexical_block ]
!54 = metadata !{i32 107, i32 7, metadata !53, null}
!55 = metadata !{i32 108, i32 7, metadata !53, null}
!56 = metadata !{i32 109, i32 3, metadata !53, null}
!57 = metadata !{i32 110, i32 3, metadata !9, null}
!58 = metadata !{i32 111, i32 3, metadata !9, null}
!59 = metadata !{i32 116, i32 7, metadata !60, null}
!60 = metadata !{i32 589835, metadata !9, i32 112, i32 3, metadata !1, i32 4} ; [ DW_TAG_lexical_block ]
!61 = metadata !{i32 117, i32 7, metadata !60, null}
!62 = metadata !{i32 118, i32 7, metadata !60, null}
!63 = metadata !{i32 119, i32 3, metadata !60, null}
!64 = metadata !{i32 120, i32 3, metadata !9, null}
!65 = metadata !{i32 121, i32 3, metadata !9, null}
!66 = metadata !{i32 123, i32 3, metadata !9, null}
