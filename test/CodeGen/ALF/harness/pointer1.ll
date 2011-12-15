; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

%0 = type { i8, i16, i32, i32, i64, i32, %struct.s1_sub, i16, i8, i8 }
%struct.s1 = type { i8, i16, i32, i32, i64, i32, %struct.s1_sub, i16, i8 }
%struct.s1_sub = type { i16, i16 }
%struct.s2 = type { i8*, i16*, i32*, i32*, i64*, i32*, %struct.s1_sub*, i16*, i8* }

@v1 = global i8 1, align 1
@v2 = global i16 2, align 2
@v3 = global i32 3, align 4
@v4 = global i32 4, align 4
@v5 = global i64 5, align 8
@v6 = global i32 6, align 4
@v7 = global %struct.s1_sub { i16 7, i16 7 }, align 2
@v8 = global i16 8, align 2
@v9 = global i8 9, align 1
@w1 = global %0 { i8 1, i16 2, i32 3, i32 4, i64 5, i32 6, %struct.s1_sub { i16 7, i16 7 }, i16 8, i8 9, i8 undef }, align 4
@w2 = global %struct.s2 { i8* @v1, i16* @v2, i32* @v3, i32* @v4, i64* @v5, i32* @v6, %struct.s1_sub* @v7, i16* @v8, i8* @v9 }, align 4
@w3 = common global %struct.s1 zeroinitializer, align 4

define i32 @main() nounwind {
bb:
  %tmp = load i8* getelementptr inbounds (%0* @w1, i32 0, i32 0), align 4, !dbg !54
  %tmp1 = load i8** getelementptr inbounds (%struct.s2* @w2, i32 0, i32 0), align 4, !dbg !54
  %tmp2 = load i8* %tmp1, align 1, !dbg !54
  %tmp3 = icmp eq i8 %tmp, %tmp2, !dbg !54
  br i1 %tmp3, label %bb5, label %bb4, !dbg !54

bb4:                                              ; preds = %bb
  br label %bb91, !dbg !54

bb5:                                              ; preds = %bb
  %tmp6 = load i16* getelementptr inbounds (%0* @w1, i32 0, i32 1), align 2, !dbg !56
  %tmp7 = load i16** getelementptr inbounds (%struct.s2* @w2, i32 0, i32 1), align 4, !dbg !56
  %tmp8 = load i16* %tmp7, align 2, !dbg !56
  %tmp9 = icmp eq i16 %tmp6, %tmp8, !dbg !56
  br i1 %tmp9, label %bb11, label %bb10, !dbg !56

bb10:                                             ; preds = %bb5
  br label %bb91, !dbg !56

bb11:                                             ; preds = %bb5
  %tmp12 = load i32* getelementptr inbounds (%0* @w1, i32 0, i32 2), align 4, !dbg !57
  %tmp13 = load i32** getelementptr inbounds (%struct.s2* @w2, i32 0, i32 2), align 4, !dbg !57
  %tmp14 = load i32* %tmp13, align 4, !dbg !57
  %tmp15 = icmp eq i32 %tmp12, %tmp14, !dbg !57
  br i1 %tmp15, label %bb17, label %bb16, !dbg !57

bb16:                                             ; preds = %bb11
  br label %bb91, !dbg !57

bb17:                                             ; preds = %bb11
  %tmp18 = load i32* getelementptr inbounds (%0* @w1, i32 0, i32 3), align 4, !dbg !58
  %tmp19 = load i32** getelementptr inbounds (%struct.s2* @w2, i32 0, i32 3), align 4, !dbg !58
  %tmp20 = load i32* %tmp19, align 4, !dbg !58
  %tmp21 = icmp eq i32 %tmp18, %tmp20, !dbg !58
  br i1 %tmp21, label %bb23, label %bb22, !dbg !58

bb22:                                             ; preds = %bb17
  br label %bb91, !dbg !58

bb23:                                             ; preds = %bb17
  %tmp24 = load i64* getelementptr inbounds (%0* @w1, i32 0, i32 4), align 4, !dbg !59
  %tmp25 = load i64** getelementptr inbounds (%struct.s2* @w2, i32 0, i32 4), align 4, !dbg !59
  %tmp26 = load i64* %tmp25, align 4, !dbg !59
  %tmp27 = icmp eq i64 %tmp24, %tmp26, !dbg !59
  br i1 %tmp27, label %bb29, label %bb28, !dbg !59

bb28:                                             ; preds = %bb23
  br label %bb91, !dbg !59

bb29:                                             ; preds = %bb23
  %tmp30 = load i32* getelementptr inbounds (%0* @w1, i32 0, i32 5), align 4, !dbg !60
  %tmp31 = load i32** getelementptr inbounds (%struct.s2* @w2, i32 0, i32 5), align 4, !dbg !60
  %tmp32 = load i32* %tmp31, align 4, !dbg !60
  %tmp33 = icmp eq i32 %tmp30, %tmp32, !dbg !60
  br i1 %tmp33, label %bb35, label %bb34, !dbg !60

bb34:                                             ; preds = %bb29
  br label %bb91, !dbg !60

bb35:                                             ; preds = %bb29
  %tmp36 = load i16* getelementptr inbounds (%0* @w1, i32 0, i32 6, i32 0), align 4, !dbg !61
  %tmp37 = load %struct.s1_sub** getelementptr inbounds (%struct.s2* @w2, i32 0, i32 6), align 4, !dbg !61
  %tmp38 = getelementptr inbounds %struct.s1_sub* %tmp37, i32 0, i32 0, !dbg !61
  %tmp39 = load i16* %tmp38, align 2, !dbg !61
  %tmp40 = icmp eq i16 %tmp36, %tmp39, !dbg !61
  br i1 %tmp40, label %bb41, label %bb47, !dbg !61

bb41:                                             ; preds = %bb35
  %tmp42 = load i16* getelementptr inbounds (%0* @w1, i32 0, i32 6, i32 1), align 2, !dbg !61
  %tmp43 = load %struct.s1_sub** getelementptr inbounds (%struct.s2* @w2, i32 0, i32 6), align 4, !dbg !61
  %tmp44 = getelementptr inbounds %struct.s1_sub* %tmp43, i32 0, i32 1, !dbg !61
  %tmp45 = load i16* %tmp44, align 2, !dbg !61
  %tmp46 = icmp eq i16 %tmp42, %tmp45, !dbg !61
  br i1 %tmp46, label %bb48, label %bb47, !dbg !61

bb47:                                             ; preds = %bb41, %bb35
  br label %bb91, !dbg !61

bb48:                                             ; preds = %bb41
  %tmp49 = load i16* getelementptr inbounds (%0* @w1, i32 0, i32 7), align 4, !dbg !62
  %tmp50 = load i16** getelementptr inbounds (%struct.s2* @w2, i32 0, i32 7), align 4, !dbg !62
  %tmp51 = load i16* %tmp50, align 2, !dbg !62
  %tmp52 = icmp eq i16 %tmp49, %tmp51, !dbg !62
  br i1 %tmp52, label %bb54, label %bb53, !dbg !62

bb53:                                             ; preds = %bb48
  br label %bb91, !dbg !62

bb54:                                             ; preds = %bb48
  %tmp55 = load i8* getelementptr inbounds (%0* @w1, i32 0, i32 8), align 2, !dbg !63
  %tmp56 = load i8** getelementptr inbounds (%struct.s2* @w2, i32 0, i32 8), align 4, !dbg !63
  %tmp57 = load i8* %tmp56, align 1, !dbg !63
  %tmp58 = icmp eq i8 %tmp55, %tmp57, !dbg !63
  br i1 %tmp58, label %bb60, label %bb59, !dbg !63

bb59:                                             ; preds = %bb54
  br label %bb91, !dbg !63

bb60:                                             ; preds = %bb54
  %tmp61 = load i8* getelementptr inbounds (%struct.s1* @w3, i32 0, i32 0), align 4, !dbg !64
  %tmp62 = sext i8 %tmp61 to i32, !dbg !64
  %tmp63 = load i16* getelementptr inbounds (%struct.s1* @w3, i32 0, i32 1), align 2, !dbg !64
  %tmp64 = sext i16 %tmp63 to i32, !dbg !64
  %tmp65 = add nsw i32 %tmp62, %tmp64, !dbg !64
  %tmp66 = load i32* getelementptr inbounds (%struct.s1* @w3, i32 0, i32 2), align 4, !dbg !64
  %tmp67 = add nsw i32 %tmp65, %tmp66, !dbg !64
  %tmp68 = load i32* getelementptr inbounds (%struct.s1* @w3, i32 0, i32 3), align 4, !dbg !64
  %tmp69 = add nsw i32 %tmp67, %tmp68, !dbg !64
  %tmp70 = sext i32 %tmp69 to i64, !dbg !64
  %tmp71 = load i64* getelementptr inbounds (%struct.s1* @w3, i32 0, i32 4), align 4, !dbg !64
  %tmp72 = add nsw i64 %tmp70, %tmp71, !dbg !64
  %tmp73 = load i32* getelementptr inbounds (%struct.s1* @w3, i32 0, i32 5), align 4, !dbg !64
  %tmp74 = sext i32 %tmp73 to i64, !dbg !64
  %tmp75 = add nsw i64 %tmp72, %tmp74, !dbg !64
  %tmp76 = load i16* getelementptr inbounds (%struct.s1* @w3, i32 0, i32 6, i32 0), align 4, !dbg !64
  %tmp77 = sext i16 %tmp76 to i64, !dbg !64
  %tmp78 = add nsw i64 %tmp75, %tmp77, !dbg !64
  %tmp79 = load i16* getelementptr inbounds (%struct.s1* @w3, i32 0, i32 6, i32 1), align 2, !dbg !64
  %tmp80 = sext i16 %tmp79 to i64, !dbg !64
  %tmp81 = add nsw i64 %tmp78, %tmp80, !dbg !64
  %tmp82 = load i16* getelementptr inbounds (%struct.s1* @w3, i32 0, i32 7), align 4, !dbg !64
  %tmp83 = sext i16 %tmp82 to i64, !dbg !64
  %tmp84 = add nsw i64 %tmp81, %tmp83, !dbg !64
  %tmp85 = load i8* getelementptr inbounds (%struct.s1* @w3, i32 0, i32 8), align 2, !dbg !64
  %tmp86 = sext i8 %tmp85 to i64, !dbg !64
  %tmp87 = sub i64 0, %tmp86
  %tmp88 = icmp eq i64 %tmp84, %tmp87, !dbg !64
  br i1 %tmp88, label %bb90, label %bb89, !dbg !64

bb89:                                             ; preds = %bb60
  br label %bb91, !dbg !64

bb90:                                             ; preds = %bb60
  br label %bb91, !dbg !65

bb91:                                             ; preds = %bb90, %bb89, %bb59, %bb53, %bb47, %bb34, %bb28, %bb22, %bb16, %bb10, %bb4
  %.0 = phi i32 [ 1, %bb4 ], [ 1, %bb10 ], [ 1, %bb16 ], [ 1, %bb22 ], [ 1, %bb28 ], [ 1, %bb34 ], [ 1, %bb47 ], [ 1, %bb53 ], [ 1, %bb59 ], [ 1, %bb89 ], [ 0, %bb90 ]
  ret i32 %.0, !dbg !66
}

!llvm.dbg.gv = !{!0, !4, !6, !8, !10, !12, !13, !18, !19, !20, !32, !50}
!llvm.dbg.sp = !{!51}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"v1", metadata !"v1", metadata !"", metadata !2, i32 38, metadata !3, i32 0, i32 1, i8* @v1} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"pointer1.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"pointer1.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589860, metadata !1, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!4 = metadata !{i32 589876, i32 0, metadata !1, metadata !"v2", metadata !"v2", metadata !"", metadata !2, i32 39, metadata !5, i32 0, i32 1, i16* @v2} ; [ DW_TAG_variable ]
!5 = metadata !{i32 589860, metadata !1, metadata !"short", null, i32 0, i64 16, i64 16, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589876, i32 0, metadata !1, metadata !"v3", metadata !"v3", metadata !"", metadata !2, i32 40, metadata !7, i32 0, i32 1, i32* @v3} ; [ DW_TAG_variable ]
!7 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!8 = metadata !{i32 589876, i32 0, metadata !1, metadata !"v4", metadata !"v4", metadata !"", metadata !2, i32 41, metadata !9, i32 0, i32 1, i32* @v4} ; [ DW_TAG_variable ]
!9 = metadata !{i32 589860, metadata !1, metadata !"long int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!10 = metadata !{i32 589876, i32 0, metadata !1, metadata !"v5", metadata !"v5", metadata !"", metadata !2, i32 42, metadata !11, i32 0, i32 1, i64* @v5} ; [ DW_TAG_variable ]
!11 = metadata !{i32 589860, metadata !1, metadata !"long long int", null, i32 0, i64 64, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!12 = metadata !{i32 589876, i32 0, metadata !1, metadata !"v6", metadata !"v6", metadata !"", metadata !2, i32 43, metadata !9, i32 0, i32 1, i32* @v6} ; [ DW_TAG_variable ]
!13 = metadata !{i32 589876, i32 0, metadata !1, metadata !"v7", metadata !"v7", metadata !"", metadata !2, i32 44, metadata !14, i32 0, i32 1, %struct.s1_sub* @v7} ; [ DW_TAG_variable ]
!14 = metadata !{i32 589843, metadata !1, metadata !"s1_sub", metadata !2, i32 9, i64 32, i64 16, i32 0, i32 0, i32 0, metadata !15, i32 0, i32 0} ; [ DW_TAG_structure_type ]
!15 = metadata !{metadata !16, metadata !17}
!16 = metadata !{i32 589837, metadata !2, metadata !"lo", metadata !2, i32 10, i64 16, i64 16, i64 0, i32 0, metadata !5} ; [ DW_TAG_member ]
!17 = metadata !{i32 589837, metadata !2, metadata !"hi", metadata !2, i32 11, i64 16, i64 16, i64 16, i32 0, metadata !5} ; [ DW_TAG_member ]
!18 = metadata !{i32 589876, i32 0, metadata !1, metadata !"v8", metadata !"v8", metadata !"", metadata !2, i32 45, metadata !5, i32 0, i32 1, i16* @v8} ; [ DW_TAG_variable ]
!19 = metadata !{i32 589876, i32 0, metadata !1, metadata !"v9", metadata !"v9", metadata !"", metadata !2, i32 46, metadata !3, i32 0, i32 1, i8* @v9} ; [ DW_TAG_variable ]
!20 = metadata !{i32 589876, i32 0, metadata !1, metadata !"w1", metadata !"w1", metadata !"", metadata !2, i32 48, metadata !21, i32 0, i32 1, %0* @w1} ; [ DW_TAG_variable ]
!21 = metadata !{i32 589843, metadata !1, metadata !"s1", metadata !2, i32 14, i64 256, i64 32, i32 0, i32 0, i32 0, metadata !22, i32 0, i32 0} ; [ DW_TAG_structure_type ]
!22 = metadata !{metadata !23, metadata !24, metadata !25, metadata !26, metadata !27, metadata !28, metadata !29, metadata !30, metadata !31}
!23 = metadata !{i32 589837, metadata !2, metadata !"a", metadata !2, i32 15, i64 8, i64 8, i64 0, i32 0, metadata !3} ; [ DW_TAG_member ]
!24 = metadata !{i32 589837, metadata !2, metadata !"b", metadata !2, i32 16, i64 16, i64 16, i64 16, i32 0, metadata !5} ; [ DW_TAG_member ]
!25 = metadata !{i32 589837, metadata !2, metadata !"c", metadata !2, i32 17, i64 32, i64 32, i64 32, i32 0, metadata !7} ; [ DW_TAG_member ]
!26 = metadata !{i32 589837, metadata !2, metadata !"d", metadata !2, i32 18, i64 32, i64 32, i64 64, i32 0, metadata !9} ; [ DW_TAG_member ]
!27 = metadata !{i32 589837, metadata !2, metadata !"e", metadata !2, i32 19, i64 64, i64 32, i64 96, i32 0, metadata !11} ; [ DW_TAG_member ]
!28 = metadata !{i32 589837, metadata !2, metadata !"f", metadata !2, i32 20, i64 32, i64 32, i64 160, i32 0, metadata !9} ; [ DW_TAG_member ]
!29 = metadata !{i32 589837, metadata !2, metadata !"g", metadata !2, i32 21, i64 32, i64 16, i64 192, i32 0, metadata !14} ; [ DW_TAG_member ]
!30 = metadata !{i32 589837, metadata !2, metadata !"h", metadata !2, i32 22, i64 16, i64 16, i64 224, i32 0, metadata !5} ; [ DW_TAG_member ]
!31 = metadata !{i32 589837, metadata !2, metadata !"i", metadata !2, i32 23, i64 8, i64 8, i64 240, i32 0, metadata !3} ; [ DW_TAG_member ]
!32 = metadata !{i32 589876, i32 0, metadata !1, metadata !"w2", metadata !"w2", metadata !"", metadata !2, i32 49, metadata !33, i32 0, i32 1, %struct.s2* @w2} ; [ DW_TAG_variable ]
!33 = metadata !{i32 589843, metadata !1, metadata !"s2", metadata !2, i32 26, i64 288, i64 32, i32 0, i32 0, i32 0, metadata !34, i32 0, i32 0} ; [ DW_TAG_structure_type ]
!34 = metadata !{metadata !35, metadata !37, metadata !39, metadata !41, metadata !43, metadata !45, metadata !46, metadata !48, metadata !49}
!35 = metadata !{i32 589837, metadata !2, metadata !"a", metadata !2, i32 27, i64 32, i64 32, i64 0, i32 0, metadata !36} ; [ DW_TAG_member ]
!36 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !3} ; [ DW_TAG_pointer_type ]
!37 = metadata !{i32 589837, metadata !2, metadata !"b", metadata !2, i32 28, i64 32, i64 32, i64 32, i32 0, metadata !38} ; [ DW_TAG_member ]
!38 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !5} ; [ DW_TAG_pointer_type ]
!39 = metadata !{i32 589837, metadata !2, metadata !"c", metadata !2, i32 29, i64 32, i64 32, i64 64, i32 0, metadata !40} ; [ DW_TAG_member ]
!40 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !7} ; [ DW_TAG_pointer_type ]
!41 = metadata !{i32 589837, metadata !2, metadata !"d", metadata !2, i32 30, i64 32, i64 32, i64 96, i32 0, metadata !42} ; [ DW_TAG_member ]
!42 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !9} ; [ DW_TAG_pointer_type ]
!43 = metadata !{i32 589837, metadata !2, metadata !"e", metadata !2, i32 31, i64 32, i64 32, i64 128, i32 0, metadata !44} ; [ DW_TAG_member ]
!44 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !11} ; [ DW_TAG_pointer_type ]
!45 = metadata !{i32 589837, metadata !2, metadata !"f", metadata !2, i32 32, i64 32, i64 32, i64 160, i32 0, metadata !42} ; [ DW_TAG_member ]
!46 = metadata !{i32 589837, metadata !2, metadata !"g", metadata !2, i32 33, i64 32, i64 32, i64 192, i32 0, metadata !47} ; [ DW_TAG_member ]
!47 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !14} ; [ DW_TAG_pointer_type ]
!48 = metadata !{i32 589837, metadata !2, metadata !"h", metadata !2, i32 34, i64 32, i64 32, i64 224, i32 0, metadata !38} ; [ DW_TAG_member ]
!49 = metadata !{i32 589837, metadata !2, metadata !"i", metadata !2, i32 35, i64 32, i64 32, i64 256, i32 0, metadata !36} ; [ DW_TAG_member ]
!50 = metadata !{i32 589876, i32 0, metadata !1, metadata !"w3", metadata !"w3", metadata !"", metadata !2, i32 50, metadata !21, i32 0, i32 1, %struct.s1* @w3} ; [ DW_TAG_variable ]
!51 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 52, metadata !52, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!52 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !53, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!53 = metadata !{metadata !7}
!54 = metadata !{i32 53, i32 5, metadata !55, null}
!55 = metadata !{i32 589835, metadata !51, i32 52, i32 12, metadata !2, i32 0} ; [ DW_TAG_lexical_block ]
!56 = metadata !{i32 54, i32 5, metadata !55, null}
!57 = metadata !{i32 55, i32 5, metadata !55, null}
!58 = metadata !{i32 56, i32 5, metadata !55, null}
!59 = metadata !{i32 57, i32 5, metadata !55, null}
!60 = metadata !{i32 58, i32 5, metadata !55, null}
!61 = metadata !{i32 59, i32 5, metadata !55, null}
!62 = metadata !{i32 60, i32 5, metadata !55, null}
!63 = metadata !{i32 61, i32 5, metadata !55, null}
!64 = metadata !{i32 62, i32 5, metadata !55, null}
!65 = metadata !{i32 63, i32 5, metadata !55, null}
!66 = metadata !{i32 64, i32 1, metadata !55, null}
