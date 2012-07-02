; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

define i32 @main(i32 %argc, i8** %argv) nounwind {
entry:
  call void @llvm.dbg.value(metadata !{i32 %argc}, i64 0, metadata !15), !dbg !16
  call void @llvm.dbg.value(metadata !{i8** %argv}, i64 0, metadata !17), !dbg !18
  %mul = mul nsw i32 %argc, 3, !dbg !19
  %sub = add nsw i32 %mul, -3, !dbg !19
  ret i32 %sub, !dbg !19
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.cu = !{!0}

!0 = metadata !{i32 786449, i32 0, i32 12, metadata !"c_ret.c", metadata !"/home/benedikt/Projects/otap-llvm-3.0-b1/test/CodeGen/ALF/smoke", metadata !"clang version 3.1 (http://llvm.org/git/clang.git 6f576c9bfa9a22e2801485768fe56b3336ea18a7) (gitosis@forge.vmars.tuwien.ac.at:otap-llvm.git http://llvm.org/git/llvm.git 0624744fc88264009e42687020ffef0e89f9a255)", i1 true, i1 false, metadata !"", i32 0, metadata !1, metadata !1, metadata !3, metadata !1} ; [ DW_TAG_compile_unit ]
!1 = metadata !{metadata !2}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4}
!4 = metadata !{metadata !5}
!5 = metadata !{i32 786478, i32 0, metadata !6, metadata !"main", metadata !"main", metadata !"", metadata !6, i32 1, metadata !7, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32, i8**)* @main, null, null, metadata !13, i32 1} ; [ DW_TAG_subprogram ]
!6 = metadata !{i32 786473, metadata !"c_ret.c", metadata !"/home/benedikt/Projects/otap-llvm-3.0-b1/test/CodeGen/ALF/smoke", null} ; [ DW_TAG_file_type ]
!7 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !8, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!8 = metadata !{metadata !9, metadata !9, metadata !10}
!9 = metadata !{i32 786468, null, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!10 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !11} ; [ DW_TAG_pointer_type ]
!11 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !12} ; [ DW_TAG_pointer_type ]
!12 = metadata !{i32 786468, null, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!13 = metadata !{metadata !14}
!14 = metadata !{i32 786468}                      ; [ DW_TAG_base_type ]
!15 = metadata !{i32 786689, metadata !5, metadata !"argc", metadata !6, i32 16777217, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!16 = metadata !{i32 1, i32 14, metadata !5, null}
!17 = metadata !{i32 786689, metadata !5, metadata !"argv", metadata !6, i32 33554433, metadata !10, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!18 = metadata !{i32 1, i32 26, metadata !5, null}
!19 = metadata !{i32 2, i32 5, metadata !20, null}
!20 = metadata !{i32 786443, metadata !5, i32 1, i32 32, metadata !6, i32 0} ; [ DW_TAG_lexical_block ]
