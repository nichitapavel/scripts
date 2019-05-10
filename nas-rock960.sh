#!/bin/bash

# Use tsp to a specific queue
export TMPDIR=/var/log/tsp/rock960d
export TS_MAXFINISHED=20
export TS_SOCKET=/var/log/tsp/rock960

# DIRECTORY=~/data/rock960-and71/rock960/
DIRECTORY=~/data/testing/rock960_android/12/
LOOPS=1
LINE=4
PMLIB_SERVER=10.209.3.198:6526
PM_INFO=10.209.3.126
PM_INFO_PORT=5004
SYSTEM=android
DEVICE=10.209.3.104:5555
APPIUM_PORT=8204


AND_APP=~/development/releases/beta/benchmark-beta-05.apk
DEV=rock960


#####################################################################
################################  IS  ###############################
#####################################################################
BENCHMARK=is
PROBLEM_SIZE="B"
THREADS=1
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp adb -s ${DEVICE} install -r -t ${AND_APP}
tsp metrics.sh -n ${NAME} -d ${DIR} -l ${LOOPS} --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE} --appium-port ${APPIUM_PORT}\
               --size-list ${PROBLEM_SIZE}
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIR}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIR}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIR}/${NAME}/"
tsp mv-data.sh -d ${DIR}/${NAME}

THREADS=2
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp adb -s ${DEVICE} install -r -t ${AND_APP}
tsp metrics.sh -n ${NAME} -d ${DIR} -l ${LOOPS} --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE} --appium-port ${APPIUM_PORT}\
               --size-list ${PROBLEM_SIZE}
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIR}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIR}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIR}/${NAME}/"
tsp mv-data.sh -d ${DIR}/${NAME}

THREADS=4
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp adb -s ${DEVICE} install -r -t ${AND_APP}
tsp metrics.sh -n ${NAME} -d ${DIR} -l ${LOOPS} --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE} --appium-port ${APPIUM_PORT}\
               --size-list ${PROBLEM_SIZE}
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIR}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIR}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIR}/${NAME}/"
tsp mv-data.sh -d ${DIR}/${NAME}


#####################################################################
################################  MG  ###############################
#####################################################################
BENCHMARK=mg
PROBLEM_SIZE="B"
THREADS=1
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp adb -s ${DEVICE} install -r -t ${AND_APP}
tsp metrics.sh -n ${NAME} -d ${DIR} -l ${LOOPS} --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE} --appium-port ${APPIUM_PORT}\
               --size-list ${PROBLEM_SIZE}
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIR}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIR}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIR}/${NAME}/"
tsp mv-data.sh -d ${DIR}/${NAME}

THREADS=2
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp adb -s ${DEVICE} install -r -t ${AND_APP}
tsp metrics.sh -n ${NAME} -d ${DIR} -l ${LOOPS} --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE} --appium-port ${APPIUM_PORT}\
               --size-list ${PROBLEM_SIZE}
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIR}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIR}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIR}/${NAME}/"
tsp mv-data.sh -d ${DIR}/${NAME}

THREADS=4
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp adb -s ${DEVICE} install -r -t ${AND_APP}
tsp metrics.sh -n ${NAME} -d ${DIR} -l ${LOOPS} --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE} --appium-port ${APPIUM_PORT}\
               --size-list ${PROBLEM_SIZE}
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIR}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIR}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIR}/${NAME}/"
tsp mv-data.sh -d ${DIR}/${NAME}


#####################################################################
################################  BT  ###############################
#####################################################################
BENCHMARK=bt
PROBLEM_SIZE="W"
THREADS=1
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp adb -s ${DEVICE} install -r -t ${AND_APP}
tsp metrics.sh -n ${NAME} -d ${DIR} -l ${LOOPS} --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE} --appium-port ${APPIUM_PORT}\
               --size-list ${PROBLEM_SIZE}
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIR}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIR}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIR}/${NAME}/"
tsp mv-data.sh -d ${DIR}/${NAME}

THREADS=2
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp adb -s ${DEVICE} install -r -t ${AND_APP}
tsp metrics.sh -n ${NAME} -d ${DIR} -l ${LOOPS} --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE} --appium-port ${APPIUM_PORT}\
               --size-list ${PROBLEM_SIZE}
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIR}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIR}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIR}/${NAME}/"
tsp mv-data.sh -d ${DIR}/${NAME}

THREADS=4
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp adb -s ${DEVICE} install -r -t ${AND_APP}
tsp metrics.sh -n ${NAME} -d ${DIR} -l ${LOOPS} --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE} --appium-port ${APPIUM_PORT}\
               --size-list ${PROBLEM_SIZE}
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIR}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIR}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIR}/${NAME}/"
tsp mv-data.sh -d ${DIR}/${NAME}