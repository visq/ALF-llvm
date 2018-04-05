---
title: Open Timing Analysis Platform Project: LLVM ALF Backend
---

LLVM ALF Backend
================

This document explains how to

 * obtain the LLVM -> ALF translator
 * build it
 * use it

Tested on OS X 10.7 and 32-bit Linux (Ubuntu 12.04)

__IMPORTANT NOTE__: We are currently developing against LLVM 3.4

Getting It
----------

    # clone ALF-llvm
    git clone https://github.com/visq/ALF-llvm.git
    pushd ALF-llvm/tools

    # [ALF-llvm/tools/] clone clang (C/C++ frontend)
    git clone http://llvm.org/git/clang.git
    cd clang

    # [ALF-llvm/tools/clang/] synchronize with the llvm version (currently: release 3.4)
    git checkout remotes/origin/release_34 -b release_34
    popd


Building
--------

To build llvm (and clang), either run

    # using cmake
    mkdir build
    cd build
    cmake <path-to-ALF-llvm>
    make

or

    # [ALF-llvm/] configure and build LLVM
    ./configure --enable-assertions && make

Setting things up
-----------------

Add the LLVM binaries to your PATH environment variable.

    # [ALF-llvm/] add LLVM binaries (in build or ./Debug or ./Debug+Asserts) to your PATH
    export PATH=$(dirname $(find $(pwd) -wholename '*/bin/llc')):${PATH}

You need to use a frontend to obtain LLVM bitcode. Here is the recommended way
to translate C to bitcode using clang. Note that four standard transformations
are run to simplify the translator and improve its effectiveness (mem2reg,
instcombine, instsimplify, instnamer).

    # From C code ($f.c) to LLVM bitcode ($f.ll)
    clang -Wall -emit-llvm -S -o - $f.c | \
    opt -mem2reg -instcombine -instsimplify -instnamer | \
    llvm-dis -o $f.ll

Usage
-----

The LLVM backend driver llc is used to generate ALF code.
Here are the relevant options:

* `-alf-ignore-volatiles`

  Ignore volatile modifier for loads and stores (default=false)

* `-alf-memory-areas=<string>`

  Comma-separated list of memory ranges, accessed using absolute addresses
  (e.g., `0x0-0xe,0x30-0x40`).
  If no memory areas are specified, one infinite size frame `$mem` is used,
  otherwise the frames have the specified sizes and are called `$mem_<ix>`
  (`$mem_0`,`$mem_1`,etc.)

* `-alf-standalone`

  Define stubs for undefined functions and define common frames, instead of
  importing them.

* `-alf-target-data=<string>`

  Target data string for ALF code generation, specifying for example
  data alignment or the size of pointers (default: `HOST`)

* `-alf-map-file=<filename>`

  Generate a file `filename` containing mappings from ALF code labels
  to source code positions.

### Example Usage

Here is an example of using the translator:

    llc -march=alf -alf-standalone -alf-memory-areas=0x0000-0x1000 -o test.alf test.ll

When analyzing the ALF modules using SWEET, you need to specify the entry point. C names should directly correspond to ALF names. Furthermore, you have to specify `vola=t` to correctly interpret volatile memory accesses.
Here is an example:

    sweet -i=test.alf func=main -ae ffg=ub vola=t pu css -f co

There are a few simple tests in `test/ALF`.
The tests can be executed as follows (starting in llvm directory):

    # [llvm/] Add LLVM bin directory to PATH
    export PATH=$(dirname $(find $(pwd) -wholename '*/bin/llc')):${PATH}

    # [llvm/] test directory for ALF
    cd test/ALF/harness

    # [llvm/test/ALF/harness] Test Harness
    # Runs a set of tests and checks the expected number of failures
    # Assumes there is a 'sweet' program available
    bash run_tests


Note that `.ll` files contain disassembled LLVM bitcode. To get from C to bitcode,
you need a C frontend for LLVM, such as clang or dragonegg.

    # [llvm/test/ALF/harness] generate bitcode
    clang -Wall -emit-llvm -S -o - array.c | \
        opt -mem2reg -instcombine -instsimplify -instnamer | \
        llvm-dis -o array.ll

    # [llvm/test/ALF/harness] generate ALF code
    llc -march=alf -o array.alf array.ll

    # [llvm/test/ALF/harness] analyze using sweet (single path mode)
    sweet -i=array.alf func=main -ae ffg=ub vola=t pu css -f co

Identifier Mapping
------------------

The LLVM->ALF translator uses a predictable naming scheme for ALF labels,
which makes it easy to interpret the resulting flow facts with respect to
the bitcode. Below we describe the translation of labels, where

    alf-name = T(llvm-name)

* LLVM Function func-name

  In ALF: The label for function func-name
  T(func-name) = "func-name"

* LLVM Basic Block block-name in function func-name

  In ALF: The first label in the single-entry ALF region corresponding to
          the basic block
  T(block-name,func-name) = "func-name::block-name"

* i^th LLVM instruction in a basic block
  
  In ALF: The first label in the single-entry ALF region corresponding
          to the instruction
  T(i, block-name, func-name) = "func-name::block-name::i"

* Edges from branch instruction f:bb:i to successor succ-block'

  T(succ-block,i,block-name,func-name) = "func-name::block-name::i::succ-block"

* Internal ALF basic blocks and internal (j>1)^th ALF statement
  (used to translate complex LLVM instructions with no 1-1 correspondence)

  T(j, llvm-part)               = "${T(llvm-part)}:::j"
  T(j, branch-label, llvm-part) = "${T(llvm-part)}:::branch-label:::j"

Summarizing: The LLVM part and the ALF-internal part is separated by :::. The
LLVM part consists of up to 4 parts separated by :: (function,block,instruction, 
edge). The first label corresponding to a LLVM block and LLVM instruction do not 
have an internal part, and consist of two and three LLVM parts, respectively.
