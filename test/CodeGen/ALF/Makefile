# Makefile for running ad-hoc custom LLVM tests
#
# Influential environment variables

# e.g.: clang, llvm-gcc-4.2
LLVM_FRONTEND?=clang
# e.g.: -O0, -O1
LLVM_FRONTEND_CFLAGS?=
# e.g.: -alf-ignore-volatiles
LLVM_ALF_FLAGS?=

# LLVM optimizer flags
# Recommendations:
#  simplify/combine instructions: as the ALF backend does not implement all constant foldings
#  mem2reg:                       more precise results, more natural representation
#  instnamer:                     no anonymous labels (backend mapping!)
# Not recommended:
#  cfgsimplify                    hard to predict the translation

LLVM_OPT_FLAGS?=-mem2reg -instcombine -instsimplify -instnamer

# e.g.: main, binary_search
SWEET_ENTRY?=main
SWEET_TIMEOUT?=30

all:
	@echo "  ALFBackend Generic Makefile"
	@echo "    Rules for .ll, .alf, .ff and .bin"
	@echo "    Environment variables: LLVM_FRONTEND_CFLAGS, LLVM_OPT_FLAGS, LLVM_ALF_FLAGS"

%.ll: %.c
ifeq ($(LLVM_FRONTEND),clang)
	$(LLVM_FRONTEND) $(LLVM_FRONTEND_CFLAGS) -g -Wall -I/usr/include/i386-linux-gnu/ -emit-llvm -S -o - $^ | opt $(LLVM_OPT_FLAGS) | llvm-dis -o $@
else
	echo "'"$(LLVM_FRONTEND)"'"
	$(LLVM_FRONTEND) $(LLVM_FRONTEND_CFLAGS) -emit-llvm -c -o - $^ | opt $(LLVM_OPT_FLAGS) | llvm-dis -o $@
endif

%.bc: %.ll
	llvm-as $< 

%.alf: %.ll
	llc -march=alf $(LLVM_ALF_FLAGS) -o $@ $^

%.ff:  %.alf
	timeout $(SWEET_TIMEOUT) sweet -i=$^ func=$(SWEET_ENTRY) \
		-c -do floats=est -ae vola=t merge=none pu ffg=all -f lang=ff o=$@

%.bin: %.c
	gcc -g -DDEBUG $(CFLAGS) -o $@ -O2 $<

%.clean:
	rm -f $(patsubst %.clean,%.bc,$@) $(patsubst %.clean,%.*.s,$@) $(patsubst %.clean,%.*.bin,$@)  $(patsubst %.clean,%.*.ff,$@) 

default_clean:
	rm -f debug_msgs.txt *.bin *.log *.ff *~ 
.PHONY: default_clean