#!/bin/bash
# set -x

FOLDER=$1
FILES=$(echo $(find ${FOLDER} -type f | grep transformed))
IFS=' ' read -r -a LINES <<< ${FILES}

for line in ${LINES[@]};
do
    NUMBER=$(echo ${line} | awk -F '/' '{print $4}')
    NAME=$(echo ${line} | awk -F '/' '{print $7}')
    ln -s ${line} ${NUMBER}-${NAME}
done
