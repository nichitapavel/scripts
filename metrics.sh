#!/bin/bash

# set -ex

# TODO Add a proper arguments parser

# REMOTE_USER=$1
# HOST=$2
LOOPS=$1


PMLIB=PMLib
PM_INFO=PM-info
WATT=odroid-watt
VOLT=odroid-volt
AMP=odroid-amp
CAPEW=watt-APCape.json
CAPEV=volt-APCape.json
CAPEA=amp-APCape.json

MATRIX_SIZE=(100 200 300 400 500 600 700 800 900 1000)

PMLIB_WATT=${PMLIB}-${WATT}
PMLIB_VOLT=${PMLIB}-${VOLT}
PMLIB_AMP=${PMLIB}-${AMP}

PM_INFO_WATT=${PM_INFO}-${WATT}
PM_INFO_VOLT=${PM_INFO}-${VOLT}
PM_INFO_AMP=${PM_INFO}-${AMP}

DIRECTORY=~/data/odroid-ubuntu-model-a/2019-03-22-09-00-float-data/
SLEEP_PMLIB_STARTUP=5
SLEEP_START=5
SLEEP_FINISH=5


#############################################################################################################
echo "**************** ${PMLIB_WATT}"

for i in $(seq 1 ${LOOPS});
do
  echo "============== Run: ${i} =============="
  for j in ${MATRIX_SIZE[@]}
  do
    echo "============== Size: ${j} =============="
    ssh debian@10.209.2.79 "screen -dmS ${PMLIB_WATT} ~/bin/pmlib_server --configfile ~/git/PMLib/new/${CAPEW}" &> /dev/null
    sleep ${SLEEP_PMLIB_STARTUP}s
    # screen -h 1000000000 -L -dmS ${PM_INFO_WATT} ~/bin/pm-info -s localhost:6526 -r APCape8L
    if [ ${i} -lt 10 ]; then
      I=0${i}
    else I=${i}
    fi
    if [ "${j}" -lt "1000" ]; then
      J=0${j}
    else J=${j}
    fi
    screen -dmS ${PM_INFO_WATT} ~/git/PMLib/Python/.venv/bin/python ~/git/PMLib/Python/client/thread_flask_pminfo.py -s 10.209.2.79:6526 -d ${DIRECTORY} -f data-${J}-${I}.csv -r APCape8L
    ##############################
    sleep ${SLEEP_START}s

    START=$(date +%Y-%m-%d\ %H:%M:%S\ %N)

    # matrix multiplication linux odroid
    ssh odroid@10.209.2.95 "~/matrix-jar-app-0.4.1/bin/matrix-jar-app ${j} 50 false http://10.209.3.126:5000/message"

    # matrix multiplication android odroid
    # adb connect 10.209.2.95:5555 &> /dev/null
    # cd development/releases/appium/matrix-android-appium-0.2.1/bin/ > /dev/null
    # ./matrix-android-appium ${j} 50 false  http://10.209.3.126:5000/message
    # cd - > /dev/null

    FINISH=$(date +%Y-%m-%d\ %H:%M:%S\ %N)

    echo "Start matrix multiplication: ${START}"
    echo -e "Finish matrix multiplication: ${FINISH}\n"

    ###################################3
    sleep ${SLEEP_FINISH}s
    ssh debian@10.209.2.79 "screen -X -S ${PMLIB_WATT} quit"  &> /dev/null
    screen -X -S ${PM_INFO_WATT} quit &> /dev/null
  done
done

cp metrics.log ${DIRECTORY}
cp ~/git/scripts/metrics.sh ${DIRECTORY}

# ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d ${DIRECTORY}
# ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d ${DIRECTORY}

#############################################################################################################

# TODO Make a loops for amp & volt mesurements too
