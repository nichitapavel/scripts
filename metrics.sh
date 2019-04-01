#!/bin/bash

set -x

# TODO Add a proper arguments parser

SLEEP_PMLIB_STARTUP=10
SLEEP_START=10
SLEEP_FINISH=10

# Default values
PRINT_MATRIX='false'
# MATRIX_SIZE=(100 200 300 400 500 600 700 800 900 1000)
MATRIX_SIZE=(100)

while [ "$1" != "" ]
do
case $1 in
  -n|--name)
    NAME=$2
    shift 2
  ;;
  --pm-info)
    PM_INFO_FLASK=$2
    shift 2
  ;;
  --pmlib-server)
    PMLIB_SERVER=$2
    shift 2
  ;;
  -s|--system)
    SYSTEM=$2
    shift 2
  ;;
  --device)
    DEVICE=$2
    shift 2
  ;;
  --print-matrix)
    PRINT_MATRIX='true'
    shift
  ;;
  --size-list)
    MATRIX_SIZE=''
    shift 2
  ;;
  -d|--directory)
    DIRECTORY=$2
    shift 2
  ;;
  -l|--loops)
    LOOPS=$2
    shift 2
  ;;
  --line)
    LINE=$2
    shift 2
  ;;
  -p|--port)
    PORT=$2
    shift 2
  ;;
esac
done


#############################################################################################################
# Valid call for linux systems:
#  ./metrics-parser.sh
#    -n test
#    -l 2
#    -d /home/pavel/data/testing/
#    -p 5001
#    --line 2
#    --pmlib-server 10.209.2.79:6526
#    --pm-info 10.209.3.126
#    --print-matrix
#    -s linux
#    --linux-device odroid@10.209.2.95
#
# Valid call for android systems:
#  ./metrics-parser.sh
#    -n test
#    -l 2
#    -d /home/pavel/data/testing/
#    -p 5001
#    --line 2
#    --pmlib-server 10.209.2.79:6526
#    --pm-info 10.209.3.126
#    --print-matrix
#    -s android
#    --appium-device 10.209.2.95:5555
#############################################################################################################

REQUIRED=(NAME PM_INFO_FLASK PMLIB_SERVER SYSTEM DEVICE LOOPS PORT DIRECTORY LINE)
for arg in ${REQUIRED[@]};
do
  if [ -z "${!arg}" ]; then
    if [ "${arg}" != "DEVICE" ]; then
      echo "You're missing a required argument ${arg}"
      exit 1
    elif [ "${SYSTEM}" == "linux" ]; then
      echo "Linux systems require a device argument ${arg}"
      exit 1
    fi
  fi
done

PM_INFO_FLASK=http://${PM_INFO_FLASK}:${PORT}/message

for i in $(seq 1 ${LOOPS});
do
  echo "============== Run: ${i} =============="
  for j in ${MATRIX_SIZE[@]}
  do
    echo "============== Size: ${j} =============="
    if [ ${i} -lt 10 ]; then
      I=0${i}
    else I=${i}
    fi
    if [ "${j}" -lt "1000" ]; then
      J=0${j}
    else J=${j}
    fi
    screen -dmS ${NAME} \
      ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/thread_flask_pminfo.py \
        -l ${LINE} \
        -p ${PORT} \
        -s ${PMLIB_SERVER} \
        -d "${DIRECTORY}/${NAME}/" \
        -f data-${NAME}-${J}-${I}.csv \
        -r APCape8L
    ##############################
    sleep ${SLEEP_START}s

    if [ "${SYSTEM}" == "linux" ]; then
      # matrix multiplication linux odroid
      # Expects bin file to be always in ~/matrix-jar-app independent of version
      ssh ${DEVICE} "~/matrix-jar-app/bin/matrix-jar-app ${j} 50 ${PRINT_MATRIX} ${PM_INFO_FLASK}"
    elif [ "${SYSTEM}" == "android" ]; then
      # matrix multiplication android odroid
      ADB=$(echo ${DEVICE} | awk -F '.' '{print $2}')
      if [ -n "${ADB}" ]; then
        adb connect ${DEVICE} &> /dev/null
      fi
      # Expects bin file to be always in ~/matrix-android-appium independent of version
      # this rule is not for the client device
      cd ~/matrix-android-appium/bin/ > /dev/null
      ./matrix-android-appium ${j} 50 ${PRINT_MATRIX} ${PM_INFO_FLASK}
      cd - > /dev/null
    else
      echo "Unkown operating system. Exiting..."
      screen -X -S ${NAME} quit &> /dev/null
      exit 1
    fi

    ###################################3
    sleep ${SLEEP_FINISH}s
    screen -X -S ${NAME} quit &> /dev/null
  done
done

cp metrics.log "${DIRECTORY}/${NAME}/"
cp ~/git/scripts/metrics.sh "${DIRECTORY}/${NAME}/"

#############################################################################################################

# TODO Make a loops for amp & volt mesurements too
