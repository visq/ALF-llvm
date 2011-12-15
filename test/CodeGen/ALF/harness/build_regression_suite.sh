#!/bin/bash
set -e
S=alf_regression_tests
bash run_tests > $S.tmp
REGRESSION_TESTS=`grep ok $S.tmp | cut -d' ' -f 1`
mkdir -p ${S}
cp README.$S $S/README
cp run_alf_tests libtest $S
for m in ${REGRESSION_TESTS}; do 
    echo Copy $m.{alf,test}
    cp $m.{alf,test} $S
    if [ -e $m.c ] ; then
        cp $m.c $S
    fi
done
tar czf $S.tgz $S
rm -rf ${S} $S.tmp
