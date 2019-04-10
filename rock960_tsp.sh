#!/bin/bash

# Use tsp to a specific queue
export TMPDIR=/var/log/tsp/rock960d
export TS_MAXFINISHED=20
export TS_SOCKET=/var/log/tsp/rock960

# DIRECTORY=~/data/rock960-and71/rock960/
DIRECTORY=~/data/testing/rock960/
LOOPS=1
LINE=3
PMLIB_SERVER=10.209.3.198:6526
PM_INFO=10.209.3.126
PM_INFO_PORT=5003
SYSTEM=android
DEVICE=10.209.3.196:5555
APPIUM_PORT=8203


AND_APP=~/development/releases/android-app/app-debug-v1.4.2-int.apk
NAME=rock960_int
tsp adb -s ${DEVICE} install -r -t ${AND_APP}
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS} --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} --device ${DEVICE} --appium-port ${APPIUM_PORT}
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}

AND_APP=~/development/releases/android-app/app-debug-v1.4.2-float.apk
NAME=rock960_float
tsp adb -s ${DEVICE} install -r -t ${AND_APP}
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS} --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} --device ${DEVICE} --appium-port ${APPIUM_PORT}
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}

AND_APP=~/development/releases/android-app/app-debug-v1.4.2-roundup.apk
NAME=rock960_roundup
tsp adb -s ${DEVICE} install -r -t ${AND_APP}
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS} --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} --device ${DEVICE} --appium-port ${APPIUM_PORT}
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}
