#!/bin/bash

echo "Preprocessing main.c"
cpp -I../fly_by_wire/ -I../../include/ -I../../var/include/ -I../../../avr/include/ -I../../../avr/include/avr/ -I../../../sw/airborne/autopilot/ -D__AVR_ATmega128__ -DUBX main.c main_processed.c

#echo "Test compile with gcc - only linking errors should occur"
#gcc main_processed.c -Wall -C99

echo "Now converting main_changed_processed.c from .c to .alf"
c_to_alf main_processed

#######################################################################################################

echo "Preprocessing the nav.c file"
cpp -xc -Wall -I../fly_by_wire/ -I../../include/ -I../../var/include/ -I../../../avr/include/ -I../../../avr/include/avr/ -I../../../sw/airborne/autopilot/ -D__AVR_ATmega128__ -DUBX nav.c nav_processed.c

#echo "Test compile with gcc - only linking errors should occur"
#gcc nav_processed.c -Wall -C99

echo "Now converting nav_processed.c from .c to .alf"
c_to_alf nav_processed

#######################################################################################################

echo "Preprocessing the gps_ubx.c file"
cpp -I../../../avr/include/ -I../../var/include/ -I../../include/ -D__AVR_ATmega128__ gps_ubx.c gps_ubx_processed.c

#echo "Test compile with gcc - only linking errors should occur"
#gcc gps_ubx_processed.c -Wall -C99

echo "Now converting gps_ubx_processed.c from .c to .alf"
c_to_alf gps_ubx_processed

#######################################################################################################

echo "Processing modem.c "
cpp -I../../../avr/include/ -I../../var/include/ -I../../include/ -D__AVR_ATmega128__ modem.c modem_processed.c

#echo "Test compile with gcc - only linking errors should occur"
#gcc modem_processed.c -Wall -C99

echo "Converting to .alf "
c_to_alf modem_processed

#######################################################################################################

echo "Processing link_fbw.c  "
cpp -I../../../avr/include/ -I../../var/include/ -I../../include/ -I../fly_by_wire -D__AVR_ATmega128__ link_fbw.c link_fbw_processed.c

#echo "Test compile with gcc - only linking errors should occur"
#gcc link_fbw_processed.c -Wall -C99

echo "Converting to .alf "
c_to_alf link_fbw_processed

#echo "Now removing the '::[digits]' from the .alf file "
#sed 's/::[0-9]*//g' link_fbw_processed.alf > link_fbw_processed.alf

#######################################################################################################

echo "Processing spi.c  "
cpp -I../../../avr/include/ -I../../var/include/ -I../../include/ -I../fly_by_wire -D__AVR_ATmega128__ spi.c spi_processed.c
 
#echo "Test compile with gcc - only linking errors should occur"
#gcc spi_processed.c -Wall -C99

echo "Converting to .alf "
c_to_alf spi_processed

#######################################################################################################

echo "Processing adc.c "
cpp -I../../../avr/include/ -I../../var/include/ -I../../include/ -D__AVR_ATmega128__ adc.c adc_processed.c

#echo "Test compile with gcc - only linking errors should occur"
#gcc adc_processed.c -Wall -C99

echo "Converting to .alf "
c_to_alf adc_processed

#######################################################################################################

echo "Processing infrared.c  "
cpp -I../../../avr/include/ -I../../var/include/ -I../../include/ -I../fly_by_wire -D__AVR_ATmega128__ infrared.c infrared_processed.c

#echo "Test compile with gcc - only linking errors should occur"
#gcc infrared_processed.c -Wall -C99

echo "Converting to .alf "
c_to_alf infrared_processed

#######################################################################################################

echo "Processing pid.c  "
cpp -I../../../avr/include/ -I../../var/include/ -I../../include/ -I../fly_by_wire -D__AVR_ATmega128__ pid.c pid_processed.c

#echo "Test compile with gcc - only linking errors should occur"
#gcc pid_processed.c -Wall -C99

echo "Converting to .alf "
c_to_alf pid_processed

#######################################################################################################

echo "Processing uart.c "
cpp -I../../../avr/include/ -I../../var/include/ -I../../include/ -I../fly_by_wire -D__AVR_ATmega128__ uart.c uart_processed.c

#echo "Test compile with gcc - only linking errors should occur"
#gcc uart_processed.c -Wall -C99

echo "Converting to .alf "
c_to_alf uart_processed

#######################################################################################################

echo "Processing estimator.c  "
cpp -I../../../avr/include/ -I../../var/include/ -I../../include/ -I../fly_by_wire -D__AVR_ATmega128__ estimator.c estimator_processed.c

#echo "Test compile with gcc - only linking errors should occur"
#gcc estimator_processed.c -Wall -C99

echo "Converting to .alf "
c_to_alf estimator_processed

#######################################################################################################

echo "Preprocessing if_calib.c"
cpp -I../../../avr/include/ -I../../var/include/ -I../../include/ -I../fly_by_wire -D__AVR_ATmega128__ if_calib.c if_calib_processed.c

#echo "Test compile with gcc - only linking errors should occur"
#gcc if_calib_processed.c -Wall -C99

echo "converting if_calib_processed.c to if_calib_processed.alf  "
c_to_alf if_calib_processed

#######################################################################################################

echo "Preprocessing mainloop.c  "
cpp -I../../../avr/include/ -I../../var/include/ -I../../include/ -I../fly_by_wire -D__AVR_ATmega128__ mainloop.c mainloop_processed.c

#echo "Test compile with gcc - only linking errors should occur"
#gcc mainloop_processed.c -Wall -C99

echo "Converting to .alf "
c_to_alf mainloop_processed

#######################################################################################################

echo "Now copying math.c into current directory"
cp ../../../sw/lib/c/math.c ./

echo "Converting to .alf "
c_to_alf math

#######################################################################################################

echo "Analysing the .alf files by SWEET with the help of consistency checking option"
sweet -i=main_processed.alf,nav_processed.alf,gps_ubx_processed.alf,modem_processed.alf,link_fbw_processed.alf,spi_processed.alf,adc_processed.alf,infrared_processed.alf,pid_processed.alf,uart_processed.alf,estimator_processed.alf,if_calib_processed.alf,mainloop_processed.alf,math.alf func=main -c -d g=sgh,fsg,rsg,cg,cfg