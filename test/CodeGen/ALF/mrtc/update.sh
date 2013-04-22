#!/bin/bash
bash fetch.sh
for f in remote/* ; do
    M=`basename "${f}"`
    if [ ! -e local/"${M}" ] ; then
        echo "New file from remote: '$M'"
        cp "${f}" .
    elif diff -q local/"${M}" "${f}" >/dev/null ; then
        true # ok
    else        
        echo "File '$M' locally modified"
        cp "${f}" "${M}.orig"
    fi
done
