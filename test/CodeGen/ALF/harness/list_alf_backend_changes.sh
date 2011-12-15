#!/bin/bash
#
# Check which .alf files change after rebuild
FILES=$(git ls-files | grep '\.ll$')
ok=yes
rm -rf build.log
for f in $FILES ; do
	touch ${f}
        alf_file="${f/.ll/.alf}"
	make "${alf_file}" &>>build.log
        if [ $? -ne 0 ] ; then
            ok=error
            echo "* Error: Failed to build ${alf_file} (see build.log)" >&2
        else
	    git diff --exit-code ${f}
	    if [ $? -eq 1 ] ; then
                ok=diff
                echo "* Warning: Freshly build .alf file does not match the one in the repository" 1>&2
	    fi
        fi
done
if [ "${ok}" == error ] ; then
    echo "** Build Errors"
fi
if [ "${ok}" == diff ] ; then
    echo "** ALF files changed"
fi
if [ "${ok}" == yes ] ; then
    echo "No changes"
    exit 0
else
    exit 1
fi
