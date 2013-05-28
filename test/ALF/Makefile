# Makefile for running ad-hoc custom LLVM tests
#
# Influential environment variables

# e.g.: clang, llvm-gcc-4.2
CLANG?=clang
OPT?=opt
LLC?=llc
# e.g.: -O0, -O1
CFLAGS?=-g
# e.g.: -alf-ignore-volatiles
LLVM_ALF_FLAGS?=

# LLVM optimizer flags
# Recommendations:
#  simplify/combine instructions: as the ALF backend does not implement all constant foldings
#  mem2reg:                       more precise results, more natural representation
#  early-cse                      helps to reduce aliasing
#  instnamer:                     no anonymous labels (backend mapping!)
# Not recommended for analysis of C code:
#  cfgsimplify                    hard to predict the translation

LLVM_OPT_FLAGS?=-mem2reg -instcombine -instsimplify -instnamer -early-cse

# e.g.: main, binary_search
SWEET_ENTRY?=main
SWEET_TIMEOUT?=30

VERBOSE?=0
AT_0 := @
AT_1 :=
AT = $(AT_$(VERBOSE))

all:
	@echo "  ALFBackend Generic Makefile"
	@echo "    Rules for .ll, .alf, .ff and .bin"
	@echo "    Environment variables: CFLAGS, LLVM_OPT_FLAGS, LLVM_ALF_FLAGS"

%.bc: %.c
	$(AT)$(CLANG) $(CFLAGS) -Wall -I/usr/include/i386-linux-gnu/ -emit-llvm -S -o - $^ | $(OPT) $(LLVM_OPT_FLAGS) -o $@

%.ll: %.bc
	$(AT)llvm-dis -o $@ $^

%.alf: %.ll
	$(AT)$(LLC) -march=alf $(LLVM_ALF_FLAGS) -o $@ $^
#	$(AT)$(OPT) $(LLVM_OPT_FLAGS) -print-alf -alf-file=$@ $(LLVM_ALF_FLAGS) -o /dev/null $^

%.ff:  %.alf
	$(AT)timeout $(SWEET_TIMEOUT) sweet -i=$^ func=$(SWEET_ENTRY) \
		-c -do floats=est -ae vola=t merge=none pu ffg=all -f lang=ff o=$@

%.bin: %.c
	$(AT)gcc -g -DDEBUG $(CFLAGS) -o $@ -O2 $<
%.host.s: %.ll
	$(AT)llc -o $@ $<
%.bin: %.host.s
	$(AT)gcc -o $@ $<
%.clean:
	$(AT)rm -f $(patsubst %.clean,%.bc,$@) $(patsubst %.clean,%.*.s,$@) $(patsubst %.clean,%.*.bin,$@)  $(patsubst %.clean,%.*.ff,$@) 

default_clean:
	$(AT)rm -f debug_msgs.txt *.bin *.log *.ff *~ 
.PHONY: default_clean