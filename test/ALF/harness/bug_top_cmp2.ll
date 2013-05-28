; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@a = common global i32 0, align 4

define i32 @main() nounwind {
entry:
  %b = alloca i32, align 4
  call void @llvm.dbg.declare(metadata !{i32* %b}, metadata !15), !dbg !17
  call void @llvm.dbg.value(metadata !18, i64 0, metadata !15), !dbg !19
  store i32 3, i32* %b, align 4, !dbg !19
  %sub.ptr.rhs.cast = ptrtoint i32* %b to i32, !dbg !20
  %sub.ptr.sub = sub i32 ptrtoint (i32* @a to i32), %sub.ptr.rhs.cast, !dbg !20
  %cmp = icmp eq i32 %sub.ptr.sub, 16, !dbg !20
  br i1 %cmp, label %if.then, label %if.else, !dbg !20

if.then:                                          ; preds = %entry
  br label %return, !dbg !21

if.else:                                          ; preds = %entry
  br label %return, !dbg !22

return:                                           ; preds = %if.else, %if.then
  %retval.0 = phi i32 [ 1, %if.then ], [ 0, %if.else ]
  ret i32 %retval.0, !dbg !23
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.cu = !{!0}

!0 = metadata !{i32 786449, i32 0, i32 12, metadata !"bug_top_cmp2.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 3.1 ", i1 true, i1 false, metadata !"", i32 0, metadata !1, metadata !1, metadata !3, metadata !12} ; [ DW_TAG_compile_unit ]
!1 = metadata !{metadata !2}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4}
!4 = metadata !{metadata !5}
!5 = metadata !{i32 786478, i32 0, metadata !6, metadata !"main", metadata !"main", metadata !"", metadata !6, i32 4, metadata !7, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i32 ()* @main, null, null, metadata !10, i32 4} ; [ DW_TAG_subprogram ]
!6 = metadata !{i32 786473, metadata !"bug_top_cmp2.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", null} ; [ DW_TAG_file_type ]
!7 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !8, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!8 = metadata !{metadata !9}
!9 = metadata !{i32 786468, null, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!10 = metadata !{metadata !11}
!11 = metadata !{i32 786468}                      ; [ DW_TAG_base_type ]
!12 = metadata !{metadata !13}
!13 = metadata !{metadata !14}
!14 = metadata !{i32 786484, i32 0, null, metadata !"a", metadata !"a", metadata !"", metadata !6, i32 3, metadata !9, i32 0, i32 1, i32* @a} ; [ DW_TAG_variable ]
!15 = metadata !{i32 786688, metadata !16, metadata !"b", metadata !6, i32 5, metadata !9, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!16 = metadata !{i32 786443, metadata !5, i32 4, i32 12, metadata !6, i32 0} ; [ DW_TAG_lexical_block ]
!17 = metadata !{i32 5, i32 9, metadata !16, null}
!18 = metadata !{i32 3}
!19 = metadata !{i32 5, i32 14, metadata !16, null}
!20 = metadata !{i32 6, i32 5, metadata !16, null}
!21 = metadata !{i32 6, i32 30, metadata !16, null}
!22 = metadata !{i32 7, i32 30, metadata !16, null}
!23 = metadata !{i32 8, i32 1, metadata !16, null}
