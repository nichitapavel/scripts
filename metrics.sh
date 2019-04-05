#!/bin/bash

# set -x

SLEEP_PMLIB_STARTUP=10s
SLEEP_START=10s
SLEEP_FINISH=10s

# Default values
PRINT_MATRIX=
# MATRIX_SIZE=(100 200 300 400 500 600 700 800 900 1000)
MATRIX_SIZE=(100)
MODULE=50


usage="metrics.sh [Arguments]
Collect power usage data from a PMLib server. Currently only matrix multiplication is done.

Required arguments:
-n|--name NAME                - Name of the experiment. A directory with same NAME will be created to store data.
-d|--directory DIRECTORY      - Path to where the collected data will be stored.
-l|--loops LOOPS              - How many times an experiment must be executed.
--line LINE                   - Number corresponding to the BeagleBoneBlack (BBB) UCM cape lines.
                                Your device should be connected to this line, otherwiser data will be inconclusive.
                                Current range: from 1 to 8.
--pmlib-server PMLIB_SERVER   - IP and port of the BBB where pmlib server is running and UCM cape is connected.
--pm-info PM_INFO_FLASK       - IP where flask server and pm_info tool are running.
                                Most probably is the same device where metrics.sh will be run, but this ARGUMENT is
                                passed to the clients that compute. Do NOT pass localhost or similar, only external 
                                availabe IP's.
-p|--port PORT                - Flask server port (PM_INFO_FLASK). Done this way to be able to run multiple PM_INFO_FLASK
                                instances on the same device.
-s|--system SYSTEM            - Operating system of the client that computes.
--device DEVICE               - Address of the client that computes.
                                For LINUX is ssh address, i.e.: user@10.26.25.32
                                For ANDROID is adb serial number, i.e.: MSDPQSADXASD or 10.206.35.87:5555

Optional arguments:
--appium-port APPIUM_PORT     - When running multiple Android clients simultaneosly is better to provide a different
                                port for each of them.
--print-matrix PRINT_MATRIX   - Print on stdout matrix A, B and computed.
--module MODULE               - Specify the highest possible number in matrix A and B, use integer type numbers.
--help                        - Print this message."


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
    PRINT_MATRIX='-p'
    shift
  ;;
  --size-list)
    # TODO implementation pending
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
  --appium-port)
    APPIUM_PORT=$2
    shift 2
  ;;
  --module)
    MODULE=$2
    shift 2
  ;;
  -h|--help)
    echo "$usage" || exit 2
    exit
  ;;
esac
done


#############################################################################################################
# Valid call for linux systems:
#  ./metrics.sh
#    -n test
#    -d /home/pavel/data/testing/
#    -l 2
#    --line 2
#    --pmlib-server 10.209.2.79:6526
#    --pm-info 10.209.3.126
#    -p 5001
#    -s linux
#    --device odroid@10.209.2.95
#    --print-matrix
#
# Valid call for android systems:
#  ./metrics.sh
#    -n test
#    -d /home/pavel/data/testing/
#    -l 2
#    --line 2
#    --pmlib-server 10.209.2.79:6526
#    --pm-info 10.209.3.126
#    -p 5001
#    -s android
#    --device 10.209.2.95:5555
#    --appium-port 8201
#    --print-matrix
#############################################################################################################

# TODO most probably device will be required 99% of the executions for appium too, should refactor this
# condition check
# TODO --appium-port most_probably will always be required when executing android
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

LOGGING=(NAME DIRECTORY LOOPS LINE\ 
        PMLIB_SERVER PM_INFO_FLASK PORT\ 
        SYSTEM DEVICE APPIUM_PORT\ 
        PRINT_MATRIX MODULE\ 
        SLEEP_PMLIB_STARTUP SLEEP_START SLEEP_FINISH)
LOG_FILE="${DIRECTORY}/${NAME}/metrics-${NAME}.log"
mkdir -p "${DIRECTORY}/${NAME}/"
touch ${LOG_FILE}
echo "============== Variables ==============" | tee -a ${LOG_FILE}
for arg in ${LOGGING[@]};
do
  echo "${arg}=${!arg}" | tee -a ${LOG_FILE}
done
echo -e | tee -a ${LOG_FILE}

for i in $(seq 1 ${LOOPS});
do
  echo "============== Run: ${i} ==============" | tee -a ${LOG_FILE}
  for j in ${MATRIX_SIZE[@]}
  do
    echo "============== Size: ${j} ==============" | tee -a ${LOG_FILE}
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
    sleep ${SLEEP_START}

    if [ "${SYSTEM}" == "linux" ]; then
      # matrix multiplication linux odroid
      # Expects bin file to be always in ~/matrix-jar-app independent of version
      # TODO Replace "false" with ${PRINT_MATRIX}, for this must update jar app to accept named arguments
      ssh ${DEVICE} "~/matrix-jar-app/bin/matrix-jar-app ${j} ${MODULE} false ${PM_INFO_FLASK}" | tee -a ${LOG_FILE}
    elif [ "${SYSTEM}" == "android" ]; then
      # matrix multiplication android odroid
      ADB=$(echo ${DEVICE} | awk -F '.' '{print $2}')
      if [ -n "${ADB}" ]; then
        adb connect ${DEVICE} &> /dev/null
      fi
      # Expects bin file to be always in ~/matrix-android-appium independent of version
      # this rule is not for the client device
      cd ~/matrix-android-appium/bin/ > /dev/null
      ./matrix-android-appium -s ${j} -m ${MODULE} -e ${PM_INFO_FLASK} -d ${DEVICE} --system-port ${APPIUM_PORT} ${PRINT_MATRIX} | tee -a ${LOG_FILE}
      cd - > /dev/null
    else
      echo "Unkown operating system. Exiting..." | tee -a ${LOG_FILE}
      screen -X -S ${NAME} quit &> /dev/null
      exit 1
    fi

    ###################################3
    sleep ${SLEEP_FINISH}
    screen -X -S ${NAME} quit &> /dev/null
  done
done

#############################################################################################################

# TODO Make a loops for amp & volt mesurements too
