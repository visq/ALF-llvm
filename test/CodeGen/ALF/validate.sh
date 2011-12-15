# Validate that all failure counts are expected
function die() {
    echo $1 >&2
    exit 1
}
(cd harness && bash run_tests) || die '*** Harness Testsuite failed'
(cd mrtc    && IGNORE_VOLATILES=yes bash run_tests) || die '*** MRTC testsuite failed (standalone+css)'
(cd mrtc    && ALF_STANDALONE=yes   bash run_tests) || die '*** MRTC testsuite failed (standalone+multipath)'
