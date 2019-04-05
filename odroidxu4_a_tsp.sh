#!/bin/bash

# Use tsp to a specific queue
export TMPDIR=/var/log/tsp/odroidxu4_ad
export TS_MAXFINISHED=20
export TS_SOCKET=/var/log/tsp/odroidxu4_a

# DIRECTORY=~/data/odroid-and444-model-a/odroidxu4_a/
DIRECTORY=~/data/testing/odroidxu4_a/
LOOPS=1
LINE=1
PMLIB_SERVER=10.209.2.79:6526
PM_INFO=10.209.3.126
PM_INFO_PORT=5001
SYSTEM=android
DEVICE=10.209.2.95:5555
APPIUM_PORT=8201


AND_APP=~/development/releases/android-app/app-debug-v1.4.1-int.apk
NAME=odroidxu4_a_int
tsp adb -s ${DEVICE} install -r -t ${AND_APP}
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS} --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} --device ${DEVICE} --appium-port ${APPIUM_PORT}
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}

AND_APP=~/development/releases/android-app/app-debug-v1.4.1.apk
NAME=odroidxu4_a_float
tsp adb -s ${DEVICE} install -r -t ${AND_APP}
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS} --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} --device ${DEVICE} --appium-port ${APPIUM_PORT}
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}

AND_APP=~/development/releases/android-app/app-debug-v1.4.apk
NAME=odroidxu4_a_roundup
tsp adb -s ${DEVICE} install -r -t ${AND_APP}
tsp metrics.sh -n ${NAME} -d ${DIRECTORY} -l ${LOOPS} --line ${LINE}\
               --pmlib-server ${PMLIB_SERVER} --pm-info ${PM_INFO} -p ${PM_INFO_PORT}\
               -s ${SYSTEM} --device ${DEVICE} --appium-port ${APPIUM_PORT}
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/rm_last_line.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/python-scripts/.venv/bin/python ~/git/python-scripts/transform_timestamp.py -d "${DIRECTORY}/${NAME}/"
tsp ~/git/plots/.venv/bin/python ~/git/plots/wattios.py -d "${DIRECTORY}/${NAME}/"
tsp mv-data.sh -d ${DIRECTORY}/${NAME}
