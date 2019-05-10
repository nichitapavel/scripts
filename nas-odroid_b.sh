#!/bin/bash

# Use tsp to a specific queue
export TMPDIR=/var/log/tsp/odroidxu4_bd
export TS_MAXFINISHED=20
export TS_SOCKET=/var/log/tsp/odroidxu4_b

JAR_DIR=~/development/releases/beta
ZIP=zip
APP_DIRECTORY=benchmark-jar-app

# DIRECTORY=~/data/odroid-ubuntu-model-b/odroidxu4_b/
DIRECTORY=~/data/testing/odroidxu4_b_linux/12/
LOOPS=1
LINE=2
PMLIB_SERVER=10.209.3.198:6526
PM_INFO=10.209.3.126
PM_INFO_PORT=5002
SYSTEM=linux
DEVICE=odroid@10.209.3.77

DEV=odroidxu4_b
#PROBLEM_SIZE="S"


#####################################################################
################################  IS  ###############################
#####################################################################
JAR_APP=benchmark-jar-app-0.1
BENCHMARK=is
PROBLEM_SIZE="B"
THREADS=1
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp scp ${JAR_DIR}/${JAR_APP}.${ZIP} ${DEVICE}:packages
tsp ssh ${DEVICE} "unzip ~/packages/${JAR_APP}.${ZIP} && mv ${JAR_APP} ~/${APP_DIRECTORY}"
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
               --size-list ${PROBLEM_SIZE}
tsp ssh ${DEVICE} "rm -rf ~/${APP_DIRECTORY}"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}

THREADS=2
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp scp ${JAR_DIR}/${JAR_APP}.${ZIP} ${DEVICE}:packages
tsp ssh ${DEVICE} "unzip ~/packages/${JAR_APP}.${ZIP} && mv ${JAR_APP} ~/${APP_DIRECTORY}"
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
               --size-list ${PROBLEM_SIZE}
tsp ssh ${DEVICE} "rm -rf ~/${APP_DIRECTORY}"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}

THREADS=4
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp scp ${JAR_DIR}/${JAR_APP}.${ZIP} ${DEVICE}:packages
tsp ssh ${DEVICE} "unzip ~/packages/${JAR_APP}.${ZIP} && mv ${JAR_APP} ~/${APP_DIRECTORY}"
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
               --size-list ${PROBLEM_SIZE}
tsp ssh ${DEVICE} "rm -rf ~/${APP_DIRECTORY}"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}

THREADS=8
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp scp ${JAR_DIR}/${JAR_APP}.${ZIP} ${DEVICE}:packages
tsp ssh ${DEVICE} "unzip ~/packages/${JAR_APP}.${ZIP} && mv ${JAR_APP} ~/${APP_DIRECTORY}"
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
               --size-list ${PROBLEM_SIZE}
tsp ssh ${DEVICE} "rm -rf ~/${APP_DIRECTORY}"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}


#####################################################################
################################  MG  ###############################
#####################################################################
JAR_APP=benchmark-jar-app-0.1
BENCHMARK=mg
PROBLEM_SIZE="B"
THREADS=1
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp scp ${JAR_DIR}/${JAR_APP}.${ZIP} ${DEVICE}:packages
tsp ssh ${DEVICE} "unzip ~/packages/${JAR_APP}.${ZIP} && mv ${JAR_APP} ~/${APP_DIRECTORY}"
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
               --size-list ${PROBLEM_SIZE}
tsp ssh ${DEVICE} "rm -rf ~/${APP_DIRECTORY}"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}

THREADS=2
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp scp ${JAR_DIR}/${JAR_APP}.${ZIP} ${DEVICE}:packages
tsp ssh ${DEVICE} "unzip ~/packages/${JAR_APP}.${ZIP} && mv ${JAR_APP} ~/${APP_DIRECTORY}"
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
               --size-list ${PROBLEM_SIZE}
tsp ssh ${DEVICE} "rm -rf ~/${APP_DIRECTORY}"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}

THREADS=4
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp scp ${JAR_DIR}/${JAR_APP}.${ZIP} ${DEVICE}:packages
tsp ssh ${DEVICE} "unzip ~/packages/${JAR_APP}.${ZIP} && mv ${JAR_APP} ~/${APP_DIRECTORY}"
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
               --size-list ${PROBLEM_SIZE}
tsp ssh ${DEVICE} "rm -rf ~/${APP_DIRECTORY}"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}

THREADS=8
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp scp ${JAR_DIR}/${JAR_APP}.${ZIP} ${DEVICE}:packages
tsp ssh ${DEVICE} "unzip ~/packages/${JAR_APP}.${ZIP} && mv ${JAR_APP} ~/${APP_DIRECTORY}"
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
               --size-list ${PROBLEM_SIZE}
tsp ssh ${DEVICE} "rm -rf ~/${APP_DIRECTORY}"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}


#####################################################################
################################  BT  ###############################
#####################################################################
JAR_APP=benchmark-jar-app-0.1
BENCHMARK=bt
PROBLEM_SIZE="W"
THREADS=1
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp scp ${JAR_DIR}/${JAR_APP}.${ZIP} ${DEVICE}:packages
tsp ssh ${DEVICE} "unzip ~/packages/${JAR_APP}.${ZIP} && mv ${JAR_APP} ~/${APP_DIRECTORY}"
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
               --size-list ${PROBLEM_SIZE}
tsp ssh ${DEVICE} "rm -rf ~/${APP_DIRECTORY}"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}

THREADS=2
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp scp ${JAR_DIR}/${JAR_APP}.${ZIP} ${DEVICE}:packages
tsp ssh ${DEVICE} "unzip ~/packages/${JAR_APP}.${ZIP} && mv ${JAR_APP} ~/${APP_DIRECTORY}"
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
               --size-list ${PROBLEM_SIZE}
tsp ssh ${DEVICE} "rm -rf ~/${APP_DIRECTORY}"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}

THREADS=4
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp scp ${JAR_DIR}/${JAR_APP}.${ZIP} ${DEVICE}:packages
tsp ssh ${DEVICE} "unzip ~/packages/${JAR_APP}.${ZIP} && mv ${JAR_APP} ~/${APP_DIRECTORY}"
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
               --size-list ${PROBLEM_SIZE}
tsp ssh ${DEVICE} "rm -rf ~/${APP_DIRECTORY}"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}

THREADS=8
NAME=${DEV}_${BENCHMARK}${THREADS}
DIR="${DIRECTORY}"
tsp scp ${JAR_DIR}/${JAR_APP}.${ZIP} ${DEVICE}:packages
tsp ssh ${DEVICE} "unzip ~/packages/${JAR_APP}.${ZIP} && mv ${JAR_APP} ~/${APP_DIRECTORY}"
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
               --size-list ${PROBLEM_SIZE}
tsp ssh ${DEVICE} "rm -rf ~/${APP_DIRECTORY}"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}