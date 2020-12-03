#!/bin/bash

set -x

# Use tsp to a specific queue
export TMPDIR=/var/log/tsp/odroidxu4_bd
export TS_MAXFINISHED=20
export TS_SOCKET=/var/log/tsp/odroidxu4_b

DIRECTORY=~/data/november/release/odroidxu4_linux/02/
LOOPS=1
LINE=2
PMLIB_SERVER=10.209.3.195:6526
PM_INFO=10.209.3.80
PM_INFO_PORT=500${LINE}
SYSTEM=linux
DEVICE=odroid

DEV=odroidxu4

# JAR_DIR=~/development/releases/beta
JAR_DIR=${DIRECTORY}

ZIP=zip
APP_DIRECTORY=benchmark-jar-app

# JAR_APP=benchmark-jar-app-0.1
# JAR_APP=benchmark-jar-app-0.2-debug
JAR_APP=benchmark-jar-app-0.2


# tsp scp ${JAR_DIR}/${JAR_APP}.${ZIP} ${DEVICE}:packages/.
tsp ssh ${DEVICE} "unzip ~/packages/${JAR_APP}.${ZIP} && mv ${JAR_APP} ~/${APP_DIRECTORY}"


#####################################################################
################################  IS  ###############################
#####################################################################
# BENCHMARK=is
# PROBLEM_SIZE="b"

# THREADS=1
# NAME=${DEV}_${SYSTEM}_${BENCHMARK}_${PROBLEM_SIZE}_${THREADS}
# DIR="${DIRECTORY}"
# tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
#                --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
#                -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
#                --size-list ${PROBLEM_SIZE^^}

# THREADS=2
# NAME=${DEV}_${SYSTEM}_${BENCHMARK}_${PROBLEM_SIZE}_${THREADS}
# DIR="${DIRECTORY}"
# tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
#                --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
#                -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
#                --size-list ${PROBLEM_SIZE^^}

# THREADS=4
# NAME=${DEV}_${SYSTEM}_${BENCHMARK}_${PROBLEM_SIZE}_${THREADS}
# DIR="${DIRECTORY}"
# tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
#                --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
#                -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
#                --size-list ${PROBLEM_SIZE^^}

# THREADS=8
# NAME=${DEV}_${SYSTEM}_${BENCHMARK}_${PROBLEM_SIZE}_${THREADS}
# DIR="${DIRECTORY}"
# tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
#                --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
#                -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
#                --size-list ${PROBLEM_SIZE^^}


#####################################################################
################################  MG  ###############################
#####################################################################
# BENCHMARK=mg
# PROBLEM_SIZE="b"

# THREADS=1
# NAME=${DEV}_${SYSTEM}_${BENCHMARK}_${PROBLEM_SIZE}_${THREADS}
# DIR="${DIRECTORY}"
# tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
#                --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
#                -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
#                --size-list ${PROBLEM_SIZE^^}

# THREADS=2
# NAME=${DEV}_${SYSTEM}_${BENCHMARK}_${PROBLEM_SIZE}_${THREADS}
# DIR="${DIRECTORY}"
# tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
#                --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
#                -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
#                --size-list ${PROBLEM_SIZE^^}

# THREADS=4
# NAME=${DEV}_${SYSTEM}_${BENCHMARK}_${PROBLEM_SIZE}_${THREADS}
# DIR="${DIRECTORY}"
# tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
#                --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
#                -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
#                --size-list ${PROBLEM_SIZE^^}

# THREADS=8
# NAME=${DEV}_${SYSTEM}_${BENCHMARK}_${PROBLEM_SIZE}_${THREADS}
# DIR="${DIRECTORY}"
# tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
#                --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
#                -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
#                --size-list ${PROBLEM_SIZE^^}


#####################################################################
################################  BT  ###############################
#####################################################################
BENCHMARK=bt
PROBLEM_SIZE="w"

# THREADS=1
# NAME=${DEV}_${SYSTEM}_${BENCHMARK}_${PROBLEM_SIZE}_${THREADS}
# DIR="${DIRECTORY}"
# tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
#                --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
#                -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
#                --size-list ${PROBLEM_SIZE^^}

# THREADS=2
# NAME=${DEV}_${SYSTEM}_${BENCHMARK}_${PROBLEM_SIZE}_${THREADS}
# DIR="${DIRECTORY}"
# tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
#                --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
#                -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
#                --size-list ${PROBLEM_SIZE^^}

THREADS=4
NAME=${DEV}_${SYSTEM}_${BENCHMARK}_${PROBLEM_SIZE}_${THREADS}
DIR="${DIRECTORY}"
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
               --size-list ${PROBLEM_SIZE^^}

# THREADS=8
# NAME=${DEV}_${SYSTEM}_${BENCHMARK}_${PROBLEM_SIZE}_${THREADS}
# DIR="${DIRECTORY}"
# tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
#                --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
#                -s ${SYSTEM} -t ${THREADS} -b ${BENCHMARK} --device ${DEVICE}\
#                --size-list ${PROBLEM_SIZE^^}


#####################################################################
#############################  CLEANING  ############################
#####################################################################
tsp ssh ${DEVICE} "rm -rf ~/${APP_DIRECTORY}"
