; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

%struct.s = type { i8, i32 }
%struct.t = type { i8, i32 }

@z = common global [20 x i32] zeroinitializer, align 4

define i32 @f(%struct.s* byval %x, %struct.s* byval %y) nounwind {
bb:
  call void @llvm.dbg.declare(metadata !{%struct.s* %x}, metadata !10), !dbg !17
  call void @llvm.dbg.declare(metadata !{%struct.s* %y}, metadata !18), !dbg !24
  %tmp = getelementptr inbounds %struct.s* %x, i32 0, i32 0, !dbg !25
  call void @llvm.dbg.value(metadata !{i8* %tmp}, i64 0, metadata !27), !dbg !25
  %tmp1 = getelementptr inbounds %struct.s* %y, i32 0, i32 1, !dbg !29
  call void @llvm.dbg.value(metadata !{i32* %tmp1}, i64 0, metadata !30), !dbg !29
  call void @llvm.dbg.value(metadata !32, i64 0, metadata !33), !dbg !34
  %tmp2 = load i8* %tmp, align 1, !dbg !35
  %tmp3 = sext i8 %tmp2 to i32, !dbg !35
  %tmp4 = load i32* %tmp1, align 4, !dbg !35
  %tmp5 = add nsw i32 %tmp3, %tmp4, !dbg !35
  %tmp6 = load i32* getelementptr inbounds ([20 x i32]* @z, i32 0, i32 1), align 4, !dbg !35
  %tmp7 = add nsw i32 %tmp5, %tmp6, !dbg !35
  ret i32 %tmp7, !dbg !35
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}
!llvm.dbg.gv = !{!6}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"f", metadata !"f", metadata !"", metadata !1, i32 10, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i32 (%struct.s*, %struct.s*)* @f} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"struct_addr.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 12, metadata !"struct_addr.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !4, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5}
!5 = metadata !{i32 589860, metadata !2, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589876, i32 0, metadata !2, metadata !"z", metadata !"z", metadata !"", metadata !1, i32 9, metadata !7, i32 0, i32 1, [20 x i32]* @z} ; [ DW_TAG_variable ]
!7 = metadata !{i32 589825, metadata !2, metadata !"", metadata !2, i32 0, i64 640, i64 32, i32 0, i32 0, metadata !5, metadata !8, i32 0, i32 0} ; [ DW_TAG_array_type ]
!8 = metadata !{metadata !9}
!9 = metadata !{i32 589857, i64 0, i64 19}        ; [ DW_TAG_subrange_type ]
!10 = metadata !{i32 590081, metadata !0, metadata !"x", metadata !1, i32 16777226, metadata !11, i32 0} ; [ DW_TAG_arg_variable ]
!11 = metadata !{i32 589846, metadata !2, metadata !"s", metadata !1, i32 4, i64 0, i64 0, i64 0, i32 0, metadata !12} ; [ DW_TAG_typedef ]
!12 = metadata !{i32 589843, metadata !2, metadata !"", metadata !1, i32 1, i64 64, i64 32, i32 0, i32 0, i32 0, metadata !13, i32 0, i32 0} ; [ DW_TAG_structure_type ]
!13 = metadata !{metadata !14, metadata !16}
!14 = metadata !{i32 589837, metadata !1, metadata !"a", metadata !1, i32 2, i64 8, i64 8, i64 0, i32 0, metadata !15} ; [ DW_TAG_member ]
!15 = metadata !{i32 589860, metadata !2, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!16 = metadata !{i32 589837, metadata !1, metadata !"b", metadata !1, i32 3, i64 32, i64 32, i64 32, i32 0, metadata !5} ; [ DW_TAG_member ]
!17 = metadata !{i32 10, i32 9, metadata !0, null}
!18 = metadata !{i32 590081, metadata !0, metadata !"y", metadata !1, i32 33554442, metadata !19, i32 0} ; [ DW_TAG_arg_variable ]
!19 = metadata !{i32 589846, metadata !2, metadata !"t", metadata !1, i32 8, i64 0, i64 0, i64 0, i32 0, metadata !20} ; [ DW_TAG_typedef ]
!20 = metadata !{i32 589843, metadata !2, metadata !"", metadata !1, i32 5, i64 64, i64 32, i32 0, i32 0, i32 0, metadata !21, i32 0, i32 0} ; [ DW_TAG_structure_type ]
!21 = metadata !{metadata !22, metadata !23}
!22 = metadata !{i32 589837, metadata !1, metadata !"a", metadata !1, i32 6, i64 8, i64 8, i64 0, i32 0, metadata !15} ; [ DW_TAG_member ]
!23 = metadata !{i32 589837, metadata !1, metadata !"b", metadata !1, i32 7, i64 32, i64 32, i64 32, i32 0, metadata !5} ; [ DW_TAG_member ]
!24 = metadata !{i32 10, i32 14, metadata !0, null}
!25 = metadata !{i32 11, i32 21, metadata !26, null}
!26 = metadata !{i32 589835, metadata !0, i32 10, i32 17, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!27 = metadata !{i32 590080, metadata !26, metadata !"a", metadata !1, i32 11, metadata !28, i32 0} ; [ DW_TAG_auto_variable ]
!28 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !15} ; [ DW_TAG_pointer_type ]
!29 = metadata !{i32 12, i32 21, metadata !26, null}
!30 = metadata !{i32 590080, metadata !26, metadata !"b", metadata !1, i32 12, metadata !31, i32 0} ; [ DW_TAG_auto_variable ]
!31 = metadata !{i32 589839, metadata !2, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !5} ; [ DW_TAG_pointer_type ]
!32 = metadata !{i32* getelementptr inbounds ([20 x i32]* @z, i32 0, i32 1)}
!33 = metadata !{i32 590080, metadata !26, metadata !"c", metadata !1, i32 13, metadata !31, i32 0} ; [ DW_TAG_auto_variable ]
!34 = metadata !{i32 13, i32 20, metadata !26, null}
!35 = metadata !{i32 14, i32 5, metadata !26, null}
