#!/bin/bash

#TRAPPED="false"


#function trap_sigint() {
#	TRAPPED=
#        echo "Temperature monitor truncated by user."
#}

#while [ "${TRAPPED}" = "false" ];
while true;
do
	TEMP0=$(cat /sys/devices/virtual/thermal/thermal_zone0/temp)
	TEMP1=$(cat /sys/devices/virtual/thermal/thermal_zone1/temp)
	TEMP2=$(cat /sys/devices/virtual/thermal/thermal_zone2/temp)
	TEMP3=$(cat /sys/devices/virtual/thermal/thermal_zone3/temp)
	TEMP4=$(cat /sys/devices/virtual/thermal/thermal_zone4/temp)
	DATE=$(date +%Y-%m-%d\ %H:%M:%S\ %N)

	echo -e "[${DATE}]: TEMP0: ${TEMP0}\t TEMP1: ${TEMP1}\t TEMP2: ${TEMP2}\t TEMP3: ${TEMP3}\t TEMP4: ${TEMP4}"
done

trap trap_sigint SIGINT

