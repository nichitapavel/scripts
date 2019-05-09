#!/bin/bash
#set -x

DEVICE=$1
OS=$2
NUMBER=$3

FILE=data.log
BKP_FILE=${FILE}.bkp
BENCH=bench.txt
TIME=time.txt
MOPS=mops.txt
CLASS=class.txt
THREAD=threads.txt


if [ "${OS}" == "android" ]; then
  grep "Benchmarks\|Time in seconds\|Mops total\|Class\|Threads requested" $(find . -type f | grep "metrics" | cut -b 1,2 --complement) > ${FILE}
  grep Benchmarks ${FILE} | awk -F ')' '{print $2}' | awk '{print $1}' > ${BENCH}
  grep "Time in seconds" ${FILE} | awk -F '=' '{print $2}' | awk '{print $1}' > ${TIME}
  grep "Mops" ${FILE} | awk -F '=' '{print $2}' | awk '{print $1}' > ${MOPS}
  grep "Class" ${FILE} | awk -F '=' '{print $2}' | awk '{print $1}' > ${CLASS}

  LINE_NUMBERS=$(echo $(grep -n -A 1 Mops ${FILE} | grep Bench | awk -F '-' '{print $1}' | sort -r))
  IFS=' ' read -r -a LINES <<< ${LINE_NUMBERS}

  cp ${FILE} ${BKP_FILE}
  for line in ${LINES[@]};
  do
    sed -i "${line}iThreads requested = 1" ${FILE}
  done

  grep "Threads" ${FILE} | awk -F '=' '{print $2}' | awk '{print $1}' > ${THREAD}
  wc -l ${BENCH} ${CLASS} ${TIME} ${MOPS} ${THREAD}
  # TODO tr stuff to be checked
  paste -d "," ${BENCH} ${CLASS} ${THREAD} ${TIME} ${MOPS} | awk '$0="'${DEVICE}','${OS}',"$0' | tr '[:upper:]' '[:lower:]' > ${DEVICE}-${OS}-${NUMBER}.csv

elif [ "${OS}" == "linux" ]; then
  grep "Benchmark:\|Time in seconds\|Mops total" $(find . -type f | grep "metrics" | cut -b 1,2 --complement) > ${FILE}
  grep "Benchmark:" ${FILE} | awk -F ':' '{print $3 $4 $5}' | awk '{print $1","$4","$6}' > ${BENCH}
  grep "Time in seconds" ${FILE} | awk -F '=' '{print $2}' | awk '{print $1}' > ${TIME}
  grep "Mops" ${FILE} | awk -F '=' '{print $2}' | awk '{print $1}' > ${MOPS}
  wc -l ${BENCH} ${CLASS} ${TIME} ${MOPS} ${THREAD}
  paste -d "," ${BENCH} ${TIME} ${MOPS} | awk '$0="'${DEVICE}','${OS}',"$0' | tr '[:upper:]' '[:lower:]' > ${DEVICE}-${OS}-${NUMBER}.csv
fi

head ${DEVICE}-${OS}-${NUMBER}.csv