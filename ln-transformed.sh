#!/bin/bash
# set -xe

VERSION="v0.2-jp"

usage="ln-transformed.sh -t [DATA TYPE] -p [FOLDER]
Create symbolic links to original metrics or data(usually watt) files.
The [ARGUMENTS] must be passed in defined order.

Required arguments:
DATA TYPE    - Data type of files to be symbolic linked.
               Only accepts two possible values: \"metrics\" or \"data\"
FOLDER       - Relative path of the folder where files to be symbolic linked
               are located."


while [ "$1" != "" ]
do
case $1 in
  -t)
    TYPE=$2
    shift 2
  ;;
  -p)
    FOLDER="$2"
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


#WHAT="/$3/"
if [ "${TYPE}" == "metrics" ]; then
    # FILES=$(echo $(find ${FOLDER} -type f | grep metrics | grep ${WHAT}))
    FILES=$(echo $(find ${FOLDER} -type f | grep metrics))
elif [ "${TYPE}" == "data" ]; then
    # FILES=$(echo $(find ${FOLDER} -type f | grep -v transformed| grep -v log | grep -v png | grep data | grep csv | grep ${WHAT}))
    FILES=$(echo $(find ${FOLDER} -type f | grep -v transformed| grep -v log | grep -v png | grep data | grep csv))
fi

IFS=' ' read -r -a LINES <<< ${FILES}

for line in ${LINES[@]};
do
    # ALL DEVICES
    NUMBER=$(echo ${line} | awk -F '/' '{print $4}' | awk -F '_' '{print $1}')
    DEVICE=$(echo ${line} | awk -F '/' '{print $3}' | awk -F '-' '{print $1}' | awk -F '_' '{print $1}')
    OS=$(echo ${line} | awk -F '/' '{print $3}' | awk -F '-' '{print $2}')
    BENCH_THREADS=$(echo ${line} | awk -F '/' '{print $7}' | awk -F '_' '{print $2}')

    # ODROIDXU4
    if [ "${DEVICE}" == "odroidxu4" ]; then
      OS=$(echo ${line} | awk -F '/' '{print $3}' | awk -F '_' '{print $3}')
      BENCH_THREADS=$(echo ${line} | awk -F '/' '{print $7}' | awk -F '_' '{print $3}')
    # ROCK960
    elif [ "${DEVICE}" == "rock960" ]; then
      OS=$(echo ${line} | awk -F '/' '{print $3}' | awk -F '_' '{print $2}')
    fi

    # METRICS
    if [ "${TYPE}" == "metrics" ]; then
      CLASS="o"
      # echo ${line} ${NUMBER}_${DEVICE}_${OS}_${BENCH_THREADS:0:2}_${CLASS}_${BENCH_THREADS:2:5}
      ln -s ${line} ${NUMBER}_${DEVICE}_${OS}_${BENCH_THREADS:0:2}_${CLASS}_${BENCH_THREADS:2:5}

    # DATA
    elif [ "${TYPE}" == "data" ]; then
      # ODROIDXU4
      if [ "${DEVICE}" == "odroidxu4" ]; then
        CLASS=$(echo ${line} | awk -F '/' '{print $7}' | awk -F '_' '{print $3}' | awk -F '-' '{print $2}')
        ITERATION=$(echo ${line} | awk -F '/' '{print $7}' | awk -F '_' '{print $3}' | awk -F '-' '{print $3}')
      # HIKEY970 & ROCK960
      else
        CLASS=$(echo ${line} | awk -F '/' '{print $7}' | awk -F '_' '{print $2}' | awk -F '-' '{print $2}')
        ITERATION=$(echo ${line} | awk -F '/' '{print $7}' | awk -F '_' '{print $2}' | awk -F '-' '{print $3}')
      fi
      # echo ${line} ${NUMBER}_${DEVICE}_${OS}_${BENCH_THREADS:0:2}_${CLASS,,}_${BENCH_THREADS:2:1}_${ITERATION}
      ln -s ${line} ${NUMBER}_${DEVICE}_${OS}_${BENCH_THREADS:0:2}_${CLASS,,}_${BENCH_THREADS:2:1}_${ITERATION}
    fi

done
