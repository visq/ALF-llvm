; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32"
target triple = "i386-pc-linux-gnu"

@x = common global i32 0, align 4

define void @f() nounwind {
bb:
  %tmp = load i32* @x, align 4, !dbg !10
  %tmp1 = shl i32 %tmp, 2
  %tmp2 = add i32 %tmp1, 4, !dbg !10
  store i32 %tmp2, i32* @x, align 4, !dbg !10
  ret void, !dbg !12
}

define i32 @main() nounwind {
bb:
  call void @f(), !dbg !13
  ret i32 0, !dbg !15
}

!llvm.dbg.sp = !{!0, !5}
!llvm.dbg.gv = !{!9}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"f", metadata !"f", metadata !"", metadata !1, i32 2, metadata !3, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, void ()* @f} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"void.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 12, metadata !"void.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 2.9 (http://llvm.org/git/clang.git 059773e8917ce69e2ce5ad8f702b2ac99a62a9cb)", i1 true, i1 false, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !4, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{null}
!5 = metadata !{i32 589870, i32 0, metadata !1, metadata !"main", metadata !"main", metadata !"", metadata !1, i32 5, metadata !6, i1 false, i1 true, i32 0, i32 0, i32 0, i32 0, i1 false, i32 ()* @main} ; [ DW_TAG_subprogram ]
!6 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i32 0, i32 0, i32 0, metadata !7, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!7 = metadata !{metadata !8}
!8 = metadata !{i32 589860, metadata !2, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!9 = metadata !{i32 589876, i32 0, metadata !2, metadata !"x", metadata !"x", metadata !"", metadata !1, i32 1, metadata !8, i32 0, i32 1, i32* @x} ; [ DW_TAG_variable ]
!10 = metadata !{i32 3, i32 5, metadata !11, null}
!11 = metadata !{i32 589835, metadata !0, i32 2, i32 10, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!12 = metadata !{i32 4, i32 1, metadata !11, null}
!13 = metadata !{i32 6, i32 5, metadata !14, null}
!14 = metadata !{i32 589835, metadata !5, i32 5, i32 12, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!15 = metadata !{i32 7, i32 5, metadata !14, null}
