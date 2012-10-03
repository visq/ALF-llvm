; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

%struct.mstruct = type { [4 x i32], [4 x i8], [4 x i32] }

@str = global [9 x i8] c"9-char-s\00", align 1
@b = common global %struct.mstruct zeroinitializer, align 4
@a = common global %struct.mstruct zeroinitializer, align 4

define i32 @main() nounwind {
entry:
  %expect = alloca [2 x i32], align 8
  %c = alloca %struct.mstruct, align 4
  call void @llvm.dbg.declare(metadata !{[2 x i32]* %expect}, metadata !31), !dbg !36
  %tmp = bitcast [2 x i32]* %expect to i64*, !dbg !37
  store i64 0, i64* %tmp, align 8, !dbg !37
  call void @llvm.dbg.declare(metadata !{%struct.mstruct* %c}, metadata !38), !dbg !39
  %sub.ptr.lhs.cast = ptrtoint %struct.mstruct* %c to i32, !dbg !40
  %sub.ptr.sub = sub i32 %sub.ptr.lhs.cast, ptrtoint (%struct.mstruct* @b to i32), !dbg !40
  call void @llvm.dbg.value(metadata !{i32 %sub.ptr.sub}, i64 0, metadata !41), !dbg !40
  %cmp = icmp eq i32 %sub.ptr.sub, 36, !dbg !44
  br i1 %cmp, label %if.then, label %if.end, !dbg !44

if.then:                                          ; preds = %entry
  %arrayidx = getelementptr inbounds [2 x i32]* %expect, i32 0, i32 0, !dbg !45
  store i32 1, i32* %arrayidx, align 8, !dbg !45
  br label %if.end, !dbg !45

if.end:                                           ; preds = %if.then, %entry
  call void @llvm.dbg.value(metadata !46, i64 0, metadata !47), !dbg !48
  br i1 icmp eq (i32 sdiv (i32 sub (i32 ptrtoint (%struct.mstruct* @b to i32), i32 ptrtoint (%struct.mstruct* @a to i32)), i32 36), i32 36), label %if.then2, label %if.end4, !dbg !49

if.then2:                                         ; preds = %if.end
  %arrayidx3 = getelementptr inbounds [2 x i32]* %expect, i32 0, i32 1, !dbg !50
  store i32 1, i32* %arrayidx3, align 4, !dbg !50
  br label %if.end4, !dbg !50

if.end4:                                          ; preds = %if.then2, %if.end
  %arrayidx5 = getelementptr inbounds [2 x i32]* %expect, i32 0, i32 0, !dbg !51
  %tmp1 = load i32* %arrayidx5, align 8, !dbg !51
  %shl = shl i32 %tmp1, 1, !dbg !51
  %arrayidx6 = getelementptr inbounds [2 x i32]* %expect, i32 0, i32 1, !dbg !51
  %tmp2 = load i32* %arrayidx6, align 4, !dbg !51
  %add = add nsw i32 %shl, %tmp2, !dbg !51
  ret i32 %add, !dbg !51
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.memset.p0i8.i32(i8* nocapture, i8, i32, i32, i1) nounwind

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.cu = !{!0}

!0 = metadata !{i32 786449, i32 0, i32 12, metadata !"pointer_undef1.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 3.1 ", i1 true, i1 false, metadata !"", i32 0, metadata !1, metadata !1, metadata !3, metadata !12} ; [ DW_TAG_compile_unit ]
!1 = metadata !{metadata !2}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4}
!4 = metadata !{metadata !5}
!5 = metadata !{i32 786478, i32 0, metadata !6, metadata !"main", metadata !"main", metadata !"", metadata !6, i32 21, metadata !7, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i32 ()* @main, null, null, metadata !10, i32 22} ; [ DW_TAG_subprogram ]
!6 = metadata !{i32 786473, metadata !"pointer_undef1.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", null} ; [ DW_TAG_file_type ]
!7 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !8, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!8 = metadata !{metadata !9}
!9 = metadata !{i32 786468, null, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!10 = metadata !{metadata !11}
!11 = metadata !{i32 786468}                      ; [ DW_TAG_base_type ]
!12 = metadata !{metadata !13}
!13 = metadata !{metadata !14, metadata !19, metadata !30}
!14 = metadata !{i32 786484, i32 0, null, metadata !"str", metadata !"str", metadata !"", metadata !6, i32 18, metadata !15, i32 0, i32 1, [9 x i8]* @str} ; [ DW_TAG_variable ]
!15 = metadata !{i32 786433, null, metadata !"", null, i32 0, i64 72, i64 8, i32 0, i32 0, metadata !16, metadata !17, i32 0, i32 0} ; [ DW_TAG_array_type ]
!16 = metadata !{i32 786468, null, metadata !"char", null, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!17 = metadata !{metadata !18}
!18 = metadata !{i32 786465, i64 0, i64 8}        ; [ DW_TAG_subrange_type ]
!19 = metadata !{i32 786484, i32 0, null, metadata !"a", metadata !"a", metadata !"", metadata !6, i32 17, metadata !20, i32 0, i32 1, %struct.mstruct* @a} ; [ DW_TAG_variable ]
!20 = metadata !{i32 786454, null, metadata !"mstruct", metadata !6, i32 16, i64 0, i64 0, i64 0, i32 0, metadata !21} ; [ DW_TAG_typedef ]
!21 = metadata !{i32 786451, null, metadata !"", metadata !6, i32 12, i64 288, i64 32, i32 0, i32 0, null, metadata !22, i32 0, i32 0} ; [ DW_TAG_structure_type ]
!22 = metadata !{metadata !23, metadata !27, metadata !29}
!23 = metadata !{i32 786445, metadata !21, metadata !"x", metadata !6, i32 13, i64 128, i64 32, i64 0, i32 0, metadata !24} ; [ DW_TAG_member ]
!24 = metadata !{i32 786433, null, metadata !"", null, i32 0, i64 128, i64 32, i32 0, i32 0, metadata !9, metadata !25, i32 0, i32 0} ; [ DW_TAG_array_type ]
!25 = metadata !{metadata !26}
!26 = metadata !{i32 786465, i64 0, i64 3}        ; [ DW_TAG_subrange_type ]
!27 = metadata !{i32 786445, metadata !21, metadata !"y", metadata !6, i32 14, i64 32, i64 8, i64 128, i32 0, metadata !28} ; [ DW_TAG_member ]
!28 = metadata !{i32 786433, null, metadata !"", null, i32 0, i64 32, i64 8, i32 0, i32 0, metadata !16, metadata !25, i32 0, i32 0} ; [ DW_TAG_array_type ]
!29 = metadata !{i32 786445, metadata !21, metadata !"z", metadata !6, i32 15, i64 128, i64 32, i64 160, i32 0, metadata !24} ; [ DW_TAG_member ]
!30 = metadata !{i32 786484, i32 0, null, metadata !"b", metadata !"b", metadata !"", metadata !6, i32 19, metadata !20, i32 0, i32 1, %struct.mstruct* @b} ; [ DW_TAG_variable ]
!31 = metadata !{i32 786688, metadata !32, metadata !"expect", metadata !6, i32 23, metadata !33, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!32 = metadata !{i32 786443, metadata !5, i32 22, i32 1, metadata !6, i32 0} ; [ DW_TAG_lexical_block ]
!33 = metadata !{i32 786433, null, metadata !"", null, i32 0, i64 64, i64 32, i32 0, i32 0, metadata !9, metadata !34, i32 0, i32 0} ; [ DW_TAG_array_type ]
!34 = metadata !{metadata !35}
!35 = metadata !{i32 786465, i64 0, i64 1}        ; [ DW_TAG_subrange_type ]
!36 = metadata !{i32 23, i32 7, metadata !32, null}
!37 = metadata !{i32 23, i32 25, metadata !32, null}
!38 = metadata !{i32 786688, metadata !32, metadata !"c", metadata !6, i32 24, metadata !20, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!39 = metadata !{i32 24, i32 11, metadata !32, null}
!40 = metadata !{i32 27, i32 36, metadata !32, null}
!41 = metadata !{i32 786688, metadata !32, metadata !"d6", metadata !6, i32 27, metadata !42, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!42 = metadata !{i32 786454, null, metadata !"size_t", metadata !6, i32 35, i64 0, i64 0, i64 0, i32 0, metadata !43} ; [ DW_TAG_typedef ]
!43 = metadata !{i32 786468, null, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!44 = metadata !{i32 28, i32 3, metadata !32, null}
!45 = metadata !{i32 28, i32 32, metadata !32, null}
!46 = metadata !{i32 sdiv exact (i32 sub (i32 ptrtoint (%struct.mstruct* @b to i32), i32 ptrtoint (%struct.mstruct* @a to i32)), i32 36)}
!47 = metadata !{i32 786688, metadata !32, metadata !"d7", metadata !6, i32 30, metadata !42, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!48 = metadata !{i32 30, i32 22, metadata !32, null}
!49 = metadata !{i32 31, i32 3, metadata !32, null}
!50 = metadata !{i32 31, i32 32, metadata !32, null}
!51 = metadata !{i32 33, i32 3, metadata !32, null}
