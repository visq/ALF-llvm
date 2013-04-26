# see http://bugzilla.mdh.se/bugzilla/show_bug.cgi?id=31
# A few changes:
# - '-ae' instead of '-x'
# Notes
# - d[1] is [1,1], as a 2-byte store to (d,3) (byte 4/5)
#   is invalid for a frame of 4 bytes
export LLVM_ALF_FLAGS=-alf-standalone

make bug31a.alf
make bug31b.alf

sweet -i=bug31a.alf annot=bug31a.ann -ae ffg=uhss -f
sweet -i=bug31b.alf annot=bug31b.ann -ae ffg=uhss -f  

