#!/bin/bash
#set -ex
#TRAPPED="false"


#function trap_sigint() {
#       TRAPPED=
#        echo "Temperature monitor truncated by user."
#}

#while [ "${TRAPPED}" = "false" ];

PID=$1
SUCCESS="true"
MESSAGE="Starting logging..."

while [[ "$SUCCESS" = "true" ]];
do
        echo -e "${MESSAGE}"
	TEMP0=$(cat /proc/${PID}/statm 2> /dev/null)
	if [ "$?" -ne "0" ]; then
		SUCCESS="false"
	fi
        #TEMP1=$(cat /sys/devices/virtual/thermal/thermal_zone1/temp)
        #TEMP2=$(cat /sys/devices/virtual/thermal/thermal_zone2/temp)
        #TEMP3=$(cat /sys/devices/virtual/thermal/thermal_zone3/temp)
        #TEMP4=$(cat /sys/devices/virtual/thermal/thermal_zone4/temp)
        DATE=$(date +%Y-%m-%d\ %H:%M:%S\ %N)

        #echo -e "[${DATE}]: TEMP0: ${TEMP0}\t TEMP1: ${TEMP1}\t TEMP2: ${TEMP2}\t TEMP3: ${TEMP3}\t TEMP4: ${TEMP4}"
	MESSAGE="[${DATE}]: TEMP0: ${TEMP0}"
done

trap trap_sigint SIGINT
