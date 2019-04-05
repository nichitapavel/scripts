#!/bin/bash

# Use tsp to a specific queue
export TMPDIR=/var/log/tsp/odroidxu4_bd
export TS_MAXFINISHED=20
export TS_SOCKET=/var/log/tsp/odroidxu4_b

JAR_DIR=~/development/releases/jar-app/
ZIP=zip
APP_DIRECTORY=matrix-jar-app

# DIRECTORY=~/data/odroid-ubuntu-model-b/odroidxu4_b/
DIRECTORY=~/data/testing/odroidxu4_b/
LOOPS=1
LINE=2
PMLIB_SERVER=10.209.2.79:6526
PM_INFO=10.209.3.126
PM_INFO_PORT=5002
SYSTEM=linux
DEVICE=odroid@10.209.2.111


JAR_APP=matrix-jar-app-0.4.1-int
NAME=odroidxu4_b_int
tsp scp ${JAR_DIR}/${JAR_APP}.${ZIP} ${DEVICE}:packages
tsp ssh ${DEVICE} "unzip ~/packages/${JAR_APP}.${ZIP} && mv ${JAR_APP} ~/${APP_DIRECTORY}"
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} --device ${DEVICE}
tsp ssh ${DEVICE} "rm -rf ~/${APP_DIRECTORY}"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}

JAR_APP=matrix-jar-app-0.4.1
NAME=odroidxu4_b_float
tsp scp ${JAR_DIR}/${JAR_APP}.${ZIP} ${DEVICE}:packages
tsp ssh ${DEVICE} "unzip ~/packages/${JAR_APP}.${ZIP} && mv ${JAR_APP} ~/${APP_DIRECTORY}"
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} --device ${DEVICE}
tsp ssh ${DEVICE} "rm -rf ~/${APP_DIRECTORY}"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}

JAR_APP=matrix-jar-app-0.4
NAME=odroidxu4_b_roundup
tsp scp ${JAR_DIR}/${JAR_APP}.${ZIP} ${DEVICE}:packages
tsp ssh ${DEVICE} "unzip ~/packages/${JAR_APP}.${ZIP} && mv ${JAR_APP} ~/${APP_DIRECTORY}"
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS}  --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} --device ${DEVICE}
tsp ssh ${DEVICE} "rm -rf ~/${APP_DIRECTORY}"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}
