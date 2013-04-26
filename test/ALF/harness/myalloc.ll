; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

%struct.s = type { i32, i8 }

@data = common global [1024 x i8] zeroinitializer, align 1
@p = global i8* getelementptr inbounds ([1024 x i8]* @data, i32 0, i32 0), align 4

define i8* @myalloc(i32 %bytes) nounwind {
bb:
  call void @llvm.dbg.value(metadata !{i32 %bytes}, i64 0, metadata !27), !dbg !28
  %tmp = load i8** @p, align 4, !dbg !29
  call void @llvm.dbg.value(metadata !{i8* %tmp}, i64 0, metadata !31), !dbg !29
  %tmp1 = getelementptr inbounds i8* %tmp, i32 %bytes, !dbg !32
  store i8* %tmp1, i8** @p, align 4, !dbg !32
  ret i8* %tmp, !dbg !33
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define %struct.s* @f() nounwind {
bb:
  %tmp = call i8* @myalloc(i32 8), !dbg !34
  call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !36), !dbg !34
  %tmp1 = call i8* @myalloc(i32 8), !dbg !37
  %tmp2 = bitcast i8* %tmp1 to %struct.s*, !dbg !37
  call void @llvm.dbg.value(metadata !{%struct.s* %tmp2}, i64 0, metadata !38), !dbg !37
  %tmp3 = bitcast i8* %tmp to i32*, !dbg !39
  store i32 2, i32* %tmp3, align 4, !dbg !39
  %tmp4 = bitcast i8* %tmp1 to i32*, !dbg !40
  store i32 3, i32* %tmp4, align 4, !dbg !40
  %tmp5 = bitcast i8* %tmp to i32*, !dbg !41
  %tmp6 = load i32* %tmp5, align 4, !dbg !41
  %tmp7 = trunc i32 %tmp6 to i8, !dbg !41
  %tmp8 = getelementptr inbounds i8* %tmp1, i32 4
  store i8 %tmp7, i8* %tmp8, align 1, !dbg !41
  ret %struct.s* %tmp2, !dbg !42
}

define i32 @main() nounwind {
bb:
  %tmp = call %struct.s* @f(), !dbg !43
  call void @llvm.dbg.value(metadata !{%struct.s* %tmp}, i64 0, metadata !45), !dbg !43
  %tmp1 = getelementptr inbounds %struct.s* %tmp, i32 0, i32 0, !dbg !46
  %tmp2 = load i32* %tmp1, align 4, !dbg !46
  %tmp3 = getelementptr inbounds %struct.s* %tmp, i32 0, i32 1, !dbg !46
  %tmp4 = load i8* %tmp3, align 1, !dbg !46
  %tmp5 = sext i8 %tmp4 to i32, !dbg !46
  %tmp6 = sub nsw i32 %tmp2, %tmp5, !dbg !46
  %tmp7 = add nsw i32 %tmp6, -1, !dbg !46
  ret i32 %tmp7, !dbg !46
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.gv = !{!0, !6}
!llvm.dbg.sp = !{!10, !14, !24}

!0 = metadata !{i32 589876, i32 0, metadata !1, metadata !"p", metadata !"p", metadata !"", metadata !2, i32 6, metadata !3, i32 0, i32 1, i8** @p} ; [ DW_TAG_variable ]
!1 = metadata !{i32 589841, i32 0, i32 12, metadata !"myalloc.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!2 = metadata !{i32 589865, metadata !"myalloc.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !1} ; [ DW_TAG_file_type ]
!3 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !4} ; [ DW_TAG_pointer_type ]
!4 = metadata !{i32 589846, metadata !1, metadata !"int8_t", metadata !2, i32 37, i64 0, i64 0, i64 0, i32 0, metadata !5} ; [ DW_TAG_typedef ]
!5 = metadata !{i32 589860, metadata !1, metadata !"signed char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589876, i32 0, metadata !1, metadata !"data", metadata !"data", metadata !"", metadata !2, i32 5, metadata !7, i32 0, i32 1, [1024 x i8]* @data} ; [ DW_TAG_variable ]
!7 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 8192, i64 8, i32 0, i32 0, metadata !4, metadata !8, i32 0, i32 0} ; [ DW_TAG_array_type ]
!8 = metadata !{metadata !9}
!9 = metadata !{i32 589857, i64 0, i64 1023}      ; [ DW_TAG_subrange_type ]
!10 = metadata !{i32 589870, i32 0, metadata !2, metadata !"myalloc", metadata !"myalloc", metadata !"", metadata !2, i32 8, metadata !11, i1 false, i1 true, i32 0, i32 0, i32 0, i32 256, i1 false, i8* (i32)* @myalloc} ; [ DW_TAG_subprogram ]
!11 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !12, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!12 = metadata !{metadata !13}
!13 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ]
!14 = metadata !{i32 589870, i32 0, metadata !2, metadata !"f", metadata !"f", metadata !"", metadata !2, i32 13, metadata !15, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, %struct.s* ()* @f} ; [ DW_TAG_subprogram ]
!15 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !16, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!16 = metadata !{metadata !17}
!17 = metadata !{i32 589839, metadata !1, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !18} ; [ DW_TAG_pointer_type ]
!18 = metadata !{i32 589843, metadata !1, metadata !"s", metadata !2, i32 4, i64 64, i64 32, i32 0, i32 0, i32 0, metadata !19, i32 0, i32 0} ; [ DW_TAG_structure_type ]
!19 = metadata !{metadata !20, metadata !22}
!20 = metadata !{i32 589837, metadata !2, metadata !"a", metadata !2, i32 4, i64 32, i64 32, i64 0, i32 0, metadata !21} ; [ DW_TAG_member ]
!21 = metadata !{i32 589860, metadata !1, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!22 = metadata !{i32 589837, metadata !2, metadata !"b", metadata !2, i32 4, i64 8, i64 8, i64 32, i32 0, metadata !23} ; [ DW_TAG_member ]
!23 = metadata !{i32 589860, metadata !1, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!24 = metadata !{i32 589870, i32 0, metadata !2, metadata !"main", metadata !"main", metadata !"", metadata !2, i32 21, metadata !25, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!25 = metadata !{i32 589845, metadata !2, metadata !"", metadata !2, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !26, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!26 = metadata !{metadata !21}
!27 = metadata !{i32 590081, metadata !10, metadata !"bytes", metadata !2, i32 16777224, metadata !21, i32 0} ; [ DW_TAG_arg_variable ]
!28 = metadata !{i32 8, i32 19, metadata !10, null}
!29 = metadata !{i32 9, i32 22, metadata !30, null}
!30 = metadata !{i32 589835, metadata !10, i32 8, i32 26, metadata !2, i32 0} ; [ DW_TAG_lexical_block ]
!31 = metadata !{i32 590080, metadata !30, metadata !"chunk", metadata !2, i32 9, metadata !3, i32 0} ; [ DW_TAG_auto_variable ]
!32 = metadata !{i32 10, i32 5, metadata !30, null}
!33 = metadata !{i32 11, i32 5, metadata !30, null}
!34 = metadata !{i32 14, i32 44, metadata !35, null}
!35 = metadata !{i32 589835, metadata !14, i32 13, i32 15, metadata !2, i32 1} ; [ DW_TAG_lexical_block ]
!36 = metadata !{i32 590080, metadata !35, metadata !"x", metadata !2, i32 14, metadata !17, i32 0} ; [ DW_TAG_auto_variable ]
!37 = metadata !{i32 15, i32 44, metadata !35, null}
!38 = metadata !{i32 590080, metadata !35, metadata !"y", metadata !2, i32 15, metadata !17, i32 0} ; [ DW_TAG_auto_variable ]
!39 = metadata !{i32 16, i32 5, metadata !35, null}
!40 = metadata !{i32 17, i32 5, metadata !35, null}
!41 = metadata !{i32 18, i32 5, metadata !35, null}
!42 = metadata !{i32 19, i32 5, metadata !35, null}
!43 = metadata !{i32 22, i32 22, metadata !44, null}
!44 = metadata !{i32 589835, metadata !24, i32 21, i32 12, metadata !2, i32 2} ; [ DW_TAG_lexical_block ]
!45 = metadata !{i32 590080, metadata !44, metadata !"x", metadata !2, i32 22, metadata !17, i32 0} ; [ DW_TAG_auto_variable ]
!46 = metadata !{i32 23, i32 5, metadata !44, null}
