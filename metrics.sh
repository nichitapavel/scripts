#!/bin/bash

#set -x
VERSION=v0.2-beta-02

SLEEP_PMLIB_STARTUP=10s
SLEEP_START=10s
SLEEP_FINISH=10s

# Default values
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
-s|--system [linux|android]   - Operating system of the client that computes (SYSTEM).
--device DEVICE               - Address of the client that computes.
                                For LINUX is ssh address, i.e.: user@10.26.25.32
                                For ANDROID is adb serial number, i.e.: MSDPQSADXASD or 10.206.35.87:5555
-b|--benchmark [is|mg]        - NAS Benchmark to run.
-t|--threads [is|mg]          - Number if threads to use when running NAS Benchmark.
--size-list                   - A comma delimited string with the problem size (MATRIX_SIZE).
                                i.e.: \"A,B,C\" or \"100,500,900\". For best results always use double quotes \"\" .

Optional arguments:
--appium-port APPIUM_PORT     - When running multiple Android clients simultaneosly is better to provide a different
                                port for each of them. Recommended port range 8201-8299.
--print-matrix PRINT_MATRIX   - Print on stdout matrix A, B and computed.
--module MODULE               - Specify the highest possible number in matrix A and B, use integer type numbers.
-h|--help                     - Print this message.
-v|--version                  - Print script version."


while [ "$1" != "" ]
do
case $1 in
  -n|--name)
    NAME=$2
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
  --pmlib-server)
    PMLIB_SERVER=$2
    shift 2
  ;;
  --pm-info)
    PM_INFO_FLASK=$2
    shift 2
  ;;
  -p|--port)
    PORT=$2
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
  -b|--benchmark)
    BENCHMARK=$2
    shift 2
  ;;
  -t|--threads)
    THREADS=$2
    shift 2
  ;;
  --appium-port)
    APPIUM_PORT=$2
    shift 2
  ;;
  --print-matrix)
    PRINT_MATRIX='-p'
    shift
  ;;
  --module)
    MODULE=$2
    shift 2
  ;;
  --size-list)
    # TODO implementation pending
    IFS=',' read -r -a MATRIX_SIZE <<< $2
    shift 2
  ;;
  -h|--help)
    echo "$usage" || exit 2
    exit
  ;;
  -v|--version)
    echo "$0 ${VERSION}" || exit 2
    exit
  ;;
  *)
    echo -e "ERROR: unknown argument, read help for more info.\n"
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

############################ Check requiered arguments ######################################################
REQUIRED=(NAME DIRECTORY LOOPS LINE PMLIB_SERVER PM_INFO_FLASK PORT SYSTEM DEVICE)
for arg in ${REQUIRED[@]};
do
  if [ -z "${!arg}" ]; then
    echo "You're missing a required argument ${arg}"
    exit 1
  fi
done

PM_INFO_FLASK=http://${PM_INFO_FLASK}:${PORT}/message

############################# Log to file arguments values ##################################################
LOGGING=(NAME DIRECTORY LOOPS LINE\ 
        PMLIB_SERVER PM_INFO_FLASK PORT\ 
        SYSTEM DEVICE APPIUM_PORT\ 
        PRINT_MATRIX MODULE\ 
        MATRIX_SIZE[@]\ 
        BENCHMARK THREADS\ 
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


###################################### Do important stuff :) ################################################
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

    screen -dmS ${NAME} \
      ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/thread_flask_pminfo.py \
        -l ${LINE} \
        -p ${PORT} \
        -s ${PMLIB_SERVER} \
        -d "${DIRECTORY}/${NAME}/" \
        -f data-${NAME}-${j}-${I}.csv \
        -r APCape8L
    ##############################
    sleep ${SLEEP_START}

    if [ "${SYSTEM}" == "linux" ]; then
      # Matrix multiplication linux
      # Expects bin file to be always in ~/matrix-jar-app independent of version
      ssh ${DEVICE} "~/matrix-jar-app/bin/matrix-jar-app -s ${j} -m ${MODULE} ${PRINT_MATRIX} -e ${PM_INFO_FLASK}" | tee -a ${LOG_FILE}
    elif [ "${SYSTEM}" == "android" ]; then
      # Matrix multiplication android

      # In case device has tcp connection try to reconnect
      ADB=$(echo ${DEVICE} | awk -F '.' '{print $2}')
      if [ -n "${ADB}" ]; then
        adb connect ${DEVICE} &> /dev/null
      fi

      # Was APPIUM_PORT specified?
      CMD="-s ${j} -e ${PM_INFO_FLASK} -d ${DEVICE}"
      if [ -n "${APPIUM_PORT}" ]; then
         CMD="${CMD} --system-port ${APPIUM_PORT}"
      fi
      if [ -n "${BENCHMARK}" ]; then
         CMD="${CMD} -b ${BENCHMARK}"
      fi
      if [ -n "${THREADS}" ]; then
         CMD="${CMD} -t ${THREADS}"
      fi

      # Expects bin file to be always in ~/matrix-android-appium independent of version
      # this rule is not for the client device
      cd ~/benchmark-android-appium/bin/ > /dev/null
      ./benchmark-android-appium ${CMD} | tee -a ${LOG_FILE}
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
