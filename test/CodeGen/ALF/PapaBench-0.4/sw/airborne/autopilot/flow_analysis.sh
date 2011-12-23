# Do standard flow analysis

# Tasks
# -----

# task receive_gps_data_task # commented out in source
REPORTING_TASK="send_boot send_attitude send_settings send_desired send_bat send_climb send_mode send_debug send_nav_ref"
TASKS="altitude_control_task climb_control_task link_fbw_send send_nav_values course_run navigation_update radio_control_task stabilisation_task ${REPORTING_TASK} __vector_5 __vector_12 __vector_17 __vector_30 periodic_task"

# Modules
# -------

MODULES=adc.alf,estimator.alf,gps_ubx.alf,if_calib.alf,infrared.alf,link_fbw.alf,main.alf,mainloop.alf,math.alf,modem.alf,nav.alf,pid.alf,spi.alf,uart.alf

# Generate libc
# -------------
# clang -W -Wall -Wno-unused-parameter -I../../../avr/include/ -I../fly_by_wire -I../../include \
#       -I../../var/include -Wall -Wstrict-prototypes -DUBX -D __AVR_ATmega128__  -O2 -nostdinc \
#       -DSTACK="0x80000000" -mfloat-abi=soft -ccc-host-triple arm-elf-linux -mcpu=arm7tdmi -c \
#       -o ../../lib/libc.bc ../../lib/libc-alf.c
make BASE=`pwd`/../../.. ../../lib/libc-alf.o

for t in $TASKS ; do
    timeout 30 sweet -i=../../lib/common.alf,../../lib/libc-alf.alf,${MODULES} func=$t \
        -c -do floats=est -ae vola=t merge=none pu ffg=uhss -f lang=ff o=${t}.ff
done

# Problem A1
# ENTRY: course_run
# INPUT: estimator_hspeed_dir, gps_fcourse, ubx_msg_buf+24, desired_course
# CONSTRAINTS: -
# OUTPUT: Loop Bounds of pid.h:31, pid.h:32, WCET(course_run)

