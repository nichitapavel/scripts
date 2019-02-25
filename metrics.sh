#!/bin/bash

# set -ex

REMOTE_USER=$1
HOST=$2


PMLIB=PMLib
PM_INFO=PM-info
WATT=odroid-watt
VOLT=odroid-volt
AMP=odroid-amp
CAPEW=watt-APCape.json
CAPEV=volt-APCape.json
CAPEA=amp-APCape.json

PMLIB_WATT=${PMLIB}-${WATT}
PMLIB_VOLT=${PMLIB}-${VOLT}
PMLIB_AMP=${PMLIB}-${AMP}

PM_INFO_WATT=${PM_INFO}-${WATT}
PM_INFO_VOLT=${PM_INFO}-${VOLT}
PM_INFO_AMP=${PM_INFO}-${AMP}


#############################################################################################################
echo "**************** ${PMLIB_WATT}"

for i in $(seq 1 10);
do
    echo "============== Run: ${i} =============="

    screen -dmS ${PMLIB_WATT} /home/debian/bin/pmlib_server --configfile git/PMLib/new/${CAPEW}
    screen -h 1000000000 -L -dmS ${PM_INFO_WATT} /home/debian/bin/pm-info -s localhost:6526 -r APCape8L
    sleep 20s

    START=$(date +%Y-%m-%d\ %H:%M:%S\ %N)

    # matrix multiplication linux odroid
    ssh ${REMOTE_USER}@${HOST} "/home/odroid/matrix-jar-app-0.2.1/bin/matrix-jar-app 1000 50 0"

    # matrix multiplication android odroid
    # cd matrix-android-appium-0.1/bin/
    # JAVA_HOME=/opt/jdk1.8.0_202/jre ./matrix-android-appium 1000 50 false
    # cd - > /dev/null

    FINISH=$(date +%Y-%m-%d\ %H:%M:%S\ %N)

    echo "Start matrix multiplication: ${START}"
    echo -e "Finish matrix multiplication: ${FINISH}\n"

    sleep 60s
    screen -X -S ${PM_INFO_WATT} quit
    screen -X -S ${PMLIB_WATT} quit
    awk '{print $1":"$2":"$3}' screenlog.0 | awk -F ':' '{print $1":"$2":"$3","$5}' > ${PM_INFO_WATT}.date.data.${i}
    awk '{print $1":"$2":"$3}' screenlog.0 | awk -F ':' '{print $5}' > ${PM_INFO_WATT}.data.${i}
    echo "Time,Power(Watt)" > header1.txt
    echo "Power(Watt)" > header2.txt
    cat header1.txt ${PM_INFO_WATT}.date.data.${i} > ${PM_INFO_WATT}-date-data-${i}.csv
    cat header2.txt ${PM_INFO_WATT}.data.${i} > ${PM_INFO_WATT}-data-${i}.csv
    rm header1.txt header2.txt \
      ${PM_INFO_WATT}.date.data.${i} ${PM_INFO_WATT}.data.${i} \
      screenlog.0 data.tmp pmlib_0.log stxxl.errlog stxxl.log
done


#############################################################################################################

# TODO Update as watt measurement or make a loop for watt, amp, volt mesurements

# echo "**************** ${PMLIB_VOLT}"
# screen -dmS ${PMLIB_VOLT} /home/debian/bin/pmlib_server --configfile git/PMLib/new/${CAPEV}
# screen -h 1000000000 -L -dmS ${PM_INFO_VOLT} /home/debian/bin/pm-info -s localhost:6526 -r APCape8L
# 
# for i in $(seq 1 10);
# do
#     echo "Run: ${i}"
#     sleep 20s
#     START=$(date +%Y-%m-%d\ %H:%M:%S\ %N)
#     time ssh ${REMOTE_USER}@${HOST} "/opt/jdk1.8.0_202/jre/bin/java -jar /home/odroid/research.matrix.sequential-all-0.2.jar 1000 50 0"
#     echo "Start matrix multiplication: ${START}"
#     echo "Finish matrix multiplication: $(date +%Y-%m-%d\ %H:%M:%S\ %N)"
# done
# 
# screen -X -S ${PM_INFO_VOLT} quit
# screen -X -S ${PMLIB_VOLT} quit
# awk '{print $1":"$2":"$3}' screenlog.0 | awk -F ':' '{print $1":"$2":"$3","$5}' > ${PM_INFO_VOLT}.date.data
# awk '{print $1":"$2":"$3}' screenlog.0 | awk -F ':' '{print $5}' > ${PM_INFO_VOLT}.data
# echo "Time,Voltage(Volt)" > header1.txt
# echo "Voltage(Volt)" > header2.txt
# cat header1.txt ${PM_INFO_VOLT}.date.data > ${PM_INFO_VOLT}-date-data.csv
# cat header2.txt ${PM_INFO_VOLT}.data > ${PM_INFO_VOLT}-data.csv
# rm header1.txt header2.txt ${PM_INFO_VOLT}.date.data ${PM_INFO_VOLT}.data screenlog.0


#############################################################################################################
# echo "**************** ${PMLIB_AMP}"
# screen -dmS ${PMLIB_AMP} /home/debian/bin/pmlib_server --configfile git/PMLib/new/${CAPEA}
# screen -h 1000000000 -L -dmS ${PM_INFO_AMP} /home/debian/bin/pm-info -s localhost:6526 -r APCape8L
# 
# for i in $(seq 1 10);
# do
#     echo "Run: ${i}"
#     sleep 20s
#     START=$(date +%Y-%m-%d\ %H:%M:%S\ %N)
#     time ssh ${REMOTE_USER}@${HOST} "/opt/jdk1.8.0_202/jre/bin/java -jar /home/odroid/research.matrix.sequential-all-0.2.jar 1000 50 0"
#     echo "Start matrix multiplication: ${START}"
#     echo "Finish matrix multiplication: $(date +%Y-%m-%d\ %H:%M:%S\ %N)"
# done

# screen -X -S ${PM_INFO_AMP} quit
# screen -X -S ${PMLIB_AMP} quit
# awk '{print $1":"$2":"$3}' screenlog.0 | awk -F ':' '{print $1":"$2":"$3","$5}' > ${PM_INFO_AMP}.date.data
# awk '{print $1":"$2":"$3}' screenlog.0 | awk -F ':' '{print $5}' > ${PM_INFO_AMP}.data
# echo "Time,Current(mAmp)" > header1.txt
# echo "Current(mAmp)" > header2.txt
# cat header1.txt ${PM_INFO_AMP}.date.data > ${PM_INFO_AMP}-date-data.csv
# cat header2.txt ${PM_INFO_AMP}.data > ${PM_INFO_AMP}-data.csv
# rm header1.txt header2.txt ${PM_INFO_AMP}.date.data ${PM_INFO_AMP}.data screenlog.0
