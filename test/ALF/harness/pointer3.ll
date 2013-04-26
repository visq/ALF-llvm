; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

%struct.mstruct = type { i32, i16, i8, i16, i32, i64 }

@dat = common global [2 x %struct.mstruct] zeroinitializer, align 4

define i32 @main() nounwind {
bb:
  call void @llvm.dbg.value(metadata !22, i64 0, metadata !23), !dbg !25
  call void @llvm.dbg.value(metadata !26, i64 0, metadata !27), !dbg !29
  call void @llvm.dbg.value(metadata !30, i64 0, metadata !31), !dbg !34
  call void @llvm.dbg.value(metadata !35, i64 0, metadata !23), !dbg !36
  call void @llvm.dbg.value(metadata !37, i64 0, metadata !31), !dbg !38
  call void @llvm.dbg.value(metadata !35, i64 0, metadata !23), !dbg !39
  call void @llvm.dbg.value(metadata !40, i64 0, metadata !31), !dbg !41
  call void @llvm.dbg.value(metadata !35, i64 0, metadata !23), !dbg !42
  call void @llvm.dbg.value(metadata !43, i64 0, metadata !31), !dbg !44
  call void @llvm.dbg.value(metadata !35, i64 0, metadata !23), !dbg !45
  call void @llvm.dbg.value(metadata !46, i64 0, metadata !31), !dbg !47
  call void @llvm.dbg.value(metadata !35, i64 0, metadata !23), !dbg !48
  call void @llvm.dbg.value(metadata !49, i64 0, metadata !31), !dbg !50
  call void @llvm.dbg.value(metadata !35, i64 0, metadata !23), !dbg !51
  call void @llvm.dbg.value(metadata !52, i64 0, metadata !31), !dbg !53
  call void @llvm.dbg.value(metadata !35, i64 0, metadata !23), !dbg !54
  call void @llvm.dbg.value(metadata !37, i64 0, metadata !31), !dbg !55
  call void @llvm.dbg.value(metadata !35, i64 0, metadata !23), !dbg !56
  call void @llvm.dbg.value(metadata !43, i64 0, metadata !31), !dbg !57
  call void @llvm.dbg.value(metadata !35, i64 0, metadata !23), !dbg !58
  call void @llvm.dbg.value(metadata !46, i64 0, metadata !31), !dbg !59
  call void @llvm.dbg.value(metadata !35, i64 0, metadata !23), !dbg !60
  call void @llvm.dbg.value(metadata !52, i64 0, metadata !31), !dbg !61
  call void @llvm.dbg.value(metadata !35, i64 0, metadata !23), !dbg !62
  call void @llvm.dbg.value(metadata !40, i64 0, metadata !31), !dbg !63
  call void @llvm.dbg.value(metadata !35, i64 0, metadata !23), !dbg !64
  call void @llvm.dbg.value(metadata !65, i64 0, metadata !31), !dbg !66
  call void @llvm.dbg.value(metadata !35, i64 0, metadata !23), !dbg !67
  ret i32 0, !dbg !68
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}
!llvm.dbg.gv = !{!6}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"main", metadata !"main", metadata !"", metadata !1, i32 27, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"pointer3.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 12, metadata !"pointer3.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !4, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5}
!5 = metadata !{i32 589860, metadata !2, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589876, i32 0, metadata !2, metadata !"dat", metadata !"dat", metadata !"", metadata !1, i32 24, metadata !7, i32 0, i32 1, [2 x %struct.mstruct]* @dat} ; [ DW_TAG_variable ]
!7 = metadata !{i32 589825, metadata !2, metadata !"", metadata !2, i32 0, i64 384, i64 32, i32 0, i32 0, metadata !8, metadata !20, i32 0, i32 0} ; [ DW_TAG_array_type ]
!8 = metadata !{i32 589846, metadata !2, metadata !"mstruct", metadata !1, i32 18, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_typedef ]
!9 = metadata !{i32 589843, metadata !2, metadata !"", metadata !1, i32 11, i64 192, i64 32, i32 0, i32 0, i32 0, metadata !10, i32 0, i32 0} ; [ DW_TAG_structure_type ]
!10 = metadata !{metadata !11, metadata !12, metadata !14, metadata !16, metadata !17, metadata !18}
!11 = metadata !{i32 589837, metadata !1, metadata !"x", metadata !1, i32 12, i64 32, i64 32, i64 0, i32 0, metadata !5} ; [ DW_TAG_member ]
!12 = metadata !{i32 589837, metadata !1, metadata !"y", metadata !1, i32 13, i64 16, i64 16, i64 32, i32 0, metadata !13} ; [ DW_TAG_member ]
!13 = metadata !{i32 589860, metadata !2, metadata !"short", null, i32 0, i64 16, i64 16, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!14 = metadata !{i32 589837, metadata !1, metadata !"z", metadata !1, i32 14, i64 8, i64 8, i64 48, i32 0, metadata !15} ; [ DW_TAG_member ]
!15 = metadata !{i32 589860, metadata !2, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!16 = metadata !{i32 589837, metadata !1, metadata !"u", metadata !1, i32 15, i64 16, i64 16, i64 64, i32 0, metadata !13} ; [ DW_TAG_member ]
!17 = metadata !{i32 589837, metadata !1, metadata !"v", metadata !1, i32 16, i64 32, i64 32, i64 96, i32 0, metadata !5} ; [ DW_TAG_member ]
!18 = metadata !{i32 589837, metadata !1, metadata !"w", metadata !1, i32 17, i64 64, i64 32, i64 128, i32 0, metadata !19} ; [ DW_TAG_member ]
!19 = metadata !{i32 589860, metadata !2, metadata !"long long int", null, i32 0, i64 64, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!20 = metadata !{metadata !21}
!21 = metadata !{i32 589857, i64 0, i64 1}        ; [ DW_TAG_subrange_type ]
!22 = metadata !{i32 0}
!23 = metadata !{i32 590080, metadata !24, metadata !"res", metadata !1, i32 28, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!24 = metadata !{i32 589835, metadata !0, i32 27, i32 1, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!25 = metadata !{i32 28, i32 14, metadata !24, null}
!26 = metadata !{%struct.mstruct* getelementptr inbounds ([2 x %struct.mstruct]* @dat, i32 0, i32 0)}
!27 = metadata !{i32 590080, metadata !24, metadata !"a", metadata !1, i32 29, metadata !28, i32 0} ; [ DW_TAG_auto_variable ]
!28 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !8} ; [ DW_TAG_pointer_type ]
!29 = metadata !{i32 29, i32 23, metadata !24, null}
!30 = metadata !{i32 sub (i32 ptrtoint (%struct.mstruct* getelementptr inbounds ([2 x %struct.mstruct]* @dat, i32 0, i32 1) to i32), i32 ptrtoint ([2 x %struct.mstruct]* @dat to i32))}
!31 = metadata !{i32 590080, metadata !24, metadata !"diff", metadata !1, i32 30, metadata !32, i32 0} ; [ DW_TAG_auto_variable ]
!32 = metadata !{i32 589846, metadata !2, metadata !"size_t", metadata !1, i32 32, i64 0, i64 0, i64 0, i32 0, metadata !33} ; [ DW_TAG_typedef ]
!33 = metadata !{i32 589860, metadata !2, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!34 = metadata !{i32 33, i32 3, metadata !24, null}
!35 = metadata !{i32 select (i1 icmp eq (i32 sub (i32 ptrtoint (%struct.mstruct* getelementptr inbounds ([2 x %struct.mstruct]* @dat, i32 0, i32 1) to i32), i32 ptrtoint ([2 x %struct.mstruct]* @dat to i32)), i32 24), i32 0, i32 1)}
!36 = metadata !{i32 34, i32 3, metadata !24, null}
!37 = metadata !{i32 4}
!38 = metadata !{i32 37, i32 3, metadata !24, null}
!39 = metadata !{i32 38, i32 3, metadata !24, null}
!40 = metadata !{i32 6}
!41 = metadata !{i32 39, i32 3, metadata !24, null}
!42 = metadata !{i32 40, i32 3, metadata !24, null}
!43 = metadata !{i32 8}
!44 = metadata !{i32 41, i32 3, metadata !24, null}
!45 = metadata !{i32 42, i32 3, metadata !24, null}
!46 = metadata !{i32 12}
!47 = metadata !{i32 43, i32 3, metadata !24, null}
!48 = metadata !{i32 44, i32 3, metadata !24, null}
!49 = metadata !{i32 16}
!50 = metadata !{i32 45, i32 3, metadata !24, null}
!51 = metadata !{i32 46, i32 3, metadata !24, null}
!52 = metadata !{i32 2}
!53 = metadata !{i32 48, i32 3, metadata !24, null}
!54 = metadata !{i32 49, i32 3, metadata !24, null}
!55 = metadata !{i32 50, i32 3, metadata !24, null}
!56 = metadata !{i32 51, i32 3, metadata !24, null}
!57 = metadata !{i32 52, i32 3, metadata !24, null}
!58 = metadata !{i32 53, i32 3, metadata !24, null}
!59 = metadata !{i32 54, i32 3, metadata !24, null}
!60 = metadata !{i32 55, i32 3, metadata !24, null}
!61 = metadata !{i32 57, i32 3, metadata !24, null}
!62 = metadata !{i32 58, i32 3, metadata !24, null}
!63 = metadata !{i32 59, i32 3, metadata !24, null}
!64 = metadata !{i32 60, i32 3, metadata !24, null}
!65 = metadata !{i32 10}
!66 = metadata !{i32 61, i32 3, metadata !24, null}
!67 = metadata !{i32 62, i32 3, metadata !24, null}
!68 = metadata !{i32 64, i32 3, metadata !24, null}
