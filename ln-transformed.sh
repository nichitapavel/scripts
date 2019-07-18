#!/bin/bash
# set -xe

FOLDER="$2"
TYPE="$1"
if [ "${TYPE}" == "metrics" ]; then
    FILES=$(echo $(find ${FOLDER} -type f | grep metrics))
elif [ "${TYPE}" == "data" ]; then
    FILES=$(echo $(find ${FOLDER} -type f | grep -v transformed| grep -v log | grep -v png | grep data | grep csv))
else
    echo "Unkown option. Exiting..."
    exit 1
fi

IFS=' ' read -r -a LINES <<< ${FILES}

for line in ${LINES[@]};
do
    NUMBER=$(echo ${line} | awk -F '/' '{print $6}')
    TYPE=$(echo ${line} | awk -F '/' '{print $4}')
    NAME=$(echo ${line} | awk -F '/' '{print $8}')
    ln -s ${line} ${NUMBER}_${TYPE}_${NAME}
    # echo ${line} ${NUMBER}_${TYPE}_${NAME}
done
