# Do standard flow analysis

# Tasks
# -----

TASKS="check_failsafe_task check_mega128_values_task send_data_to_autopilot_task servo_transmit test_ppm_task __vector_5 __vector_6 __vector_10"

# Modules
# -------
MODULES=../../lib/common.alf,../../lib/libc-alf.alf
for i in *.alf; do MODULES=`echo $MODULES,$i`; done

# Generate libc
# -------------
make BASE=`pwd`/../../.. ../../lib/libc-alf.o

for t in $TASKS ; do
    timeout 30 sweet -i=${MODULES} func=$t \
        -c -do floats=est -ae vola=t merge=none pu ffg=uhss -f lang=ff o=${t}.ff
done

# Problem F1a
# ENTRY: check_mega128_values_task
# INPUT: -
# OUTPUT: WCET

# Problem F1b
# ENTRY: check_mega128_values_task
# INPUT: spi_was_interrupted = 0 (global/volatile??)
# OUTPUT: WCET, infeasibility of the first statement

# Problem F2
# ENTRY: __vector_10
# INPUT: -
# OUTPUT: All flow facts (WCET)