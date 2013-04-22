#!/bin/bash
bash fetch.sh
for f in remote/* ; do
    M=`basename "${f}"`
    if [ ! -e local/"${M}" ] ; then
        true # nothing to do
    elif diff -q local/"${M}" "${f}" >/dev/null ; then
#        echo "Cleaning ${M}"
        rm -f "${M}"
    else        
        echo "File '$M' locally modified"
    fi
done
rm -rf *.orig local remote