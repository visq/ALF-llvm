; ModuleID = '<stdin>'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

@u32 = common global i32 0, align 4
@u32_nd = global i32* @u32, align 4

define i32 @nondet(i32 %ub) nounwind {
entry:
  call void @llvm.dbg.value(metadata !{i32 %ub}, i64 0, metadata !29), !dbg !30
  %tmp = load i32** @u32_nd, align 4, !dbg !31
  %tmp1 = load volatile i32* %tmp, align 4, !dbg !31
  call void @llvm.dbg.value(metadata !{i32 %tmp1}, i64 0, metadata !33), !dbg !31
  %cmp = icmp ugt i32 %tmp1, %ub, !dbg !35
  br i1 %cmp, label %if.then, label %if.end, !dbg !35

if.then:                                          ; preds = %entry
  call void @llvm.dbg.value(metadata !{i32 %ub}, i64 0, metadata !33), !dbg !36
  br label %if.end, !dbg !36

if.end:                                           ; preds = %if.then, %entry
  %v.0 = phi i32 [ %ub, %if.then ], [ %tmp1, %entry ]
  ret i32 %v.0, !dbg !37
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define signext i16 @f(i16 signext %arg) nounwind {
entry:
  call void @llvm.dbg.value(metadata !{i16 %arg}, i64 0, metadata !38), !dbg !39
  %conv = sext i16 %arg to i32, !dbg !40
  %add = add nsw i32 %conv, 1, !dbg !40
  %div = sdiv i32 %add, 2, !dbg !40
  %conv1 = trunc i32 %div to i16, !dbg !40
  ret i16 %conv1, !dbg !40
}

define signext i16 @g(i16 signext %arg) nounwind {
entry:
  call void @llvm.dbg.value(metadata !{i16 %arg}, i64 0, metadata !42), !dbg !43
  %mul = shl i16 %arg, 1, !dbg !44
  ret i16 %mul, !dbg !44
}

define signext i16 @h(i16 signext %arg) nounwind {
entry:
  call void @llvm.dbg.value(metadata !{i16 %arg}, i64 0, metadata !46), !dbg !47
  %add = add i16 %arg, 1, !dbg !48
  ret i16 %add, !dbg !48
}

define i32 @main() nounwind {
entry:
  %fs = alloca [3 x i16 (i16)*], align 4
  call void @llvm.dbg.declare(metadata !{[3 x i16 (i16)*]* %fs}, metadata !50), !dbg !57
  call void @llvm.dbg.value(metadata !58, i64 0, metadata !59), !dbg !60
  call void @llvm.dbg.value(metadata !61, i64 0, metadata !62), !dbg !63
  call void @llvm.dbg.value(metadata !64, i64 0, metadata !65), !dbg !66
  %arrayidx = getelementptr inbounds [3 x i16 (i16)*]* %fs, i32 0, i32 2, !dbg !67
  store i16 (i16)* @h, i16 (i16)** %arrayidx, align 4, !dbg !67
  %arrayidx1 = getelementptr inbounds [3 x i16 (i16)*]* %fs, i32 0, i32 1, !dbg !68
  store i16 (i16)* @g, i16 (i16)** %arrayidx1, align 4, !dbg !68
  %arrayidx2 = getelementptr inbounds [3 x i16 (i16)*]* %fs, i32 0, i32 0, !dbg !69
  store i16 (i16)* @f, i16 (i16)** %arrayidx2, align 4, !dbg !69
  %call = call i32 @nondet(i32 2), !dbg !70
  %arrayidx3 = getelementptr inbounds [3 x i16 (i16)*]* %fs, i32 0, i32 %call, !dbg !70
  %tmp = load i16 (i16)** %arrayidx3, align 4, !dbg !70
  %call4 = call signext i16 %tmp(i16 signext 0) nounwind, !dbg !70
  call void @llvm.dbg.value(metadata !{i16 %call4}, i64 0, metadata !71), !dbg !70
  %call5 = call i32 @nondet(i32 2), !dbg !72
  %arrayidx6 = getelementptr inbounds [3 x i16 (i16)*]* %fs, i32 0, i32 %call5, !dbg !72
  %tmp4 = load i16 (i16)** %arrayidx6, align 4, !dbg !72
  %call7 = call signext i16 %tmp4(i16 signext 3) nounwind, !dbg !72
  call void @llvm.dbg.value(metadata !{i16 %call7}, i64 0, metadata !73), !dbg !72
  %call8 = call i32 @nondet(i32 2), !dbg !74
  %arrayidx9 = getelementptr inbounds [3 x i16 (i16)*]* %fs, i32 0, i32 %call8, !dbg !74
  %tmp5 = load i16 (i16)** %arrayidx9, align 4, !dbg !74
  %call10 = call signext i16 %tmp5(i16 signext 7) nounwind, !dbg !74
  call void @llvm.dbg.value(metadata !{i16 %call10}, i64 0, metadata !75), !dbg !74
  %add = add i16 %call4, %call7, !dbg !76
  %add13 = add i16 %add, %call10, !dbg !76
  %sub = add i16 %add13, -6, !dbg !76
  call void @llvm.dbg.value(metadata !{i16 %sub}, i64 0, metadata !77), !dbg !76
  %conv15 = sext i16 %sub to i32, !dbg !78
  ret i32 %conv15, !dbg !78
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.cu = !{!0}

!0 = metadata !{i32 786449, i32 0, i32 12, metadata !"indirect3.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", metadata !"clang version 3.1 ", i1 true, i1 false, metadata !"", i32 0, metadata !1, metadata !1, metadata !3, metadata !23} ; [ DW_TAG_compile_unit ]
!1 = metadata !{metadata !2}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4}
!4 = metadata !{metadata !5, metadata !12, metadata !17, metadata !18, metadata !19}
!5 = metadata !{i32 786478, i32 0, metadata !6, metadata !"nondet", metadata !"nondet", metadata !"", metadata !6, i32 10, metadata !7, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32)* @nondet, null, null, metadata !10, i32 10} ; [ DW_TAG_subprogram ]
!6 = metadata !{i32 786473, metadata !"indirect3.c", metadata !"/home/benedikt/Projects/otap-llvm/test/CodeGen/ALF/harness", null} ; [ DW_TAG_file_type ]
!7 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !8, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!8 = metadata !{metadata !9, metadata !9}
!9 = metadata !{i32 786468, null, metadata !"unsigned int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!10 = metadata !{metadata !11}
!11 = metadata !{i32 786468}                      ; [ DW_TAG_base_type ]
!12 = metadata !{i32 786478, i32 0, metadata !6, metadata !"f", metadata !"f", metadata !"", metadata !6, i32 17, metadata !13, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i16 (i16)* @f, null, null, metadata !10, i32 17} ; [ DW_TAG_subprogram ]
!13 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !14, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!14 = metadata !{metadata !15, metadata !15}
!15 = metadata !{i32 786454, null, metadata !"int16_t", metadata !6, i32 38, i64 0, i64 0, i64 0, i32 0, metadata !16} ; [ DW_TAG_typedef ]
!16 = metadata !{i32 786468, null, metadata !"short", null, i32 0, i64 16, i64 16, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!17 = metadata !{i32 786478, i32 0, metadata !6, metadata !"g", metadata !"g", metadata !"", metadata !6, i32 20, metadata !13, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i16 (i16)* @g, null, null, metadata !10, i32 20} ; [ DW_TAG_subprogram ]
!18 = metadata !{i32 786478, i32 0, metadata !6, metadata !"h", metadata !"h", metadata !"", metadata !6, i32 23, metadata !13, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i16 (i16)* @h, null, null, metadata !10, i32 23} ; [ DW_TAG_subprogram ]
!19 = metadata !{i32 786478, i32 0, metadata !6, metadata !"main", metadata !"main", metadata !"", metadata !6, i32 26, metadata !20, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i32 ()* @main, null, null, metadata !10, i32 27} ; [ DW_TAG_subprogram ]
!20 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !21, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!21 = metadata !{metadata !22}
!22 = metadata !{i32 786468, null, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!23 = metadata !{metadata !24}
!24 = metadata !{metadata !25, metadata !28}
!25 = metadata !{i32 786484, i32 0, null, metadata !"u32_nd", metadata !"u32_nd", metadata !"", metadata !6, i32 8, metadata !26, i32 0, i32 1, i32** @u32_nd} ; [ DW_TAG_variable ]
!26 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !27} ; [ DW_TAG_pointer_type ]
!27 = metadata !{i32 786485, null, metadata !"", null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_volatile_type ]
!28 = metadata !{i32 786484, i32 0, null, metadata !"u32", metadata !"u32", metadata !"", metadata !6, i32 7, metadata !9, i32 0, i32 1, i32* @u32} ; [ DW_TAG_variable ]
!29 = metadata !{i32 786689, metadata !5, metadata !"ub", metadata !6, i32 16777226, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!30 = metadata !{i32 10, i32 26, metadata !5, null}
!31 = metadata !{i32 11, i32 23, metadata !32, null}
!32 = metadata !{i32 786443, metadata !5, i32 10, i32 30, metadata !6, i32 0} ; [ DW_TAG_lexical_block ]
!33 = metadata !{i32 786688, metadata !32, metadata !"v", metadata !6, i32 11, metadata !34, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!34 = metadata !{i32 786454, null, metadata !"uint32_t", metadata !6, i32 52, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_typedef ]
!35 = metadata !{i32 12, i32 3, metadata !32, null}
!36 = metadata !{i32 12, i32 15, metadata !32, null}
!37 = metadata !{i32 13, i32 3, metadata !32, null}
!38 = metadata !{i32 786689, metadata !12, metadata !"arg", metadata !6, i32 16777233, metadata !15, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!39 = metadata !{i32 17, i32 19, metadata !12, null}
!40 = metadata !{i32 18, i32 3, metadata !41, null}
!41 = metadata !{i32 786443, metadata !12, i32 17, i32 24, metadata !6, i32 1} ; [ DW_TAG_lexical_block ]
!42 = metadata !{i32 786689, metadata !17, metadata !"arg", metadata !6, i32 16777236, metadata !15, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!43 = metadata !{i32 20, i32 19, metadata !17, null}
!44 = metadata !{i32 21, i32 3, metadata !45, null}
!45 = metadata !{i32 786443, metadata !17, i32 20, i32 24, metadata !6, i32 2} ; [ DW_TAG_lexical_block ]
!46 = metadata !{i32 786689, metadata !18, metadata !"arg", metadata !6, i32 16777239, metadata !15, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!47 = metadata !{i32 23, i32 19, metadata !18, null}
!48 = metadata !{i32 24, i32 3, metadata !49, null}
!49 = metadata !{i32 786443, metadata !18, i32 23, i32 24, metadata !6, i32 3} ; [ DW_TAG_lexical_block ]
!50 = metadata !{i32 786688, metadata !51, metadata !"fs", metadata !6, i32 28, metadata !52, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!51 = metadata !{i32 786443, metadata !19, i32 27, i32 1, metadata !6, i32 4} ; [ DW_TAG_lexical_block ]
!52 = metadata !{i32 786433, null, metadata !"", null, i32 0, i64 96, i64 32, i32 0, i32 0, metadata !53, metadata !55, i32 0, i32 0} ; [ DW_TAG_array_type ]
!53 = metadata !{i32 786454, null, metadata !"fun", metadata !6, i32 16, i64 0, i64 0, i64 0, i32 0, metadata !54} ; [ DW_TAG_typedef ]
!54 = metadata !{i32 786447, null, metadata !"", null, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !13} ; [ DW_TAG_pointer_type ]
!55 = metadata !{metadata !56}
!56 = metadata !{i32 786465, i64 0, i64 2}        ; [ DW_TAG_subrange_type ]
!57 = metadata !{i32 28, i32 7, metadata !51, null}
!58 = metadata !{i16 0}                           
!59 = metadata !{i32 786688, metadata !51, metadata !"t1", metadata !6, i32 29, metadata !15, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!60 = metadata !{i32 29, i32 17, metadata !51, null}
!61 = metadata !{i16 3}                           ; [ DW_TAG_entry_point ]
!62 = metadata !{i32 786688, metadata !51, metadata !"t2", metadata !6, i32 30, metadata !15, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!63 = metadata !{i32 30, i32 17, metadata !51, null}
!64 = metadata !{i16 7}                           
!65 = metadata !{i32 786688, metadata !51, metadata !"t3", metadata !6, i32 31, metadata !15, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!66 = metadata !{i32 31, i32 17, metadata !51, null}
!67 = metadata !{i32 34, i32 3, metadata !51, null}
!68 = metadata !{i32 35, i32 3, metadata !51, null}
!69 = metadata !{i32 36, i32 3, metadata !51, null}
!70 = metadata !{i32 37, i32 11, metadata !51, null}
!71 = metadata !{i32 786688, metadata !51, metadata !"r1", metadata !6, i32 32, metadata !15, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!72 = metadata !{i32 38, i32 11, metadata !51, null}
!73 = metadata !{i32 786688, metadata !51, metadata !"r2", metadata !6, i32 32, metadata !15, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!74 = metadata !{i32 39, i32 11, metadata !51, null}
!75 = metadata !{i32 786688, metadata !51, metadata !"r3", metadata !6, i32 32, metadata !15, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!76 = metadata !{i32 43, i32 3, metadata !51, null}
!77 = metadata !{i32 786688, metadata !51, metadata !"s", metadata !6, i32 32, metadata !15, i32 0, i32 0} ; [ DW_TAG_auto_variable ]
!78 = metadata !{i32 44, i32 3, metadata !51, null}
