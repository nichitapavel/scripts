#!/bin/bash

while [ "$1" != "" ]
do
case $1 in
  -d|--directory)
    DIRECTORY=$2
    shift 2
  ;;
esac
done

if [ -z "${DIRECTORY}" ]; then
    echo "Fatal error! NO DIRECTORY PROVIDED!"
    exit 1
fi

mkdir -p ${DIRECTORY}/log
mkdir -p ${DIRECTORY}/png-sequence
mkdir -p ${DIRECTORY}/png-date
mkdir -p ${DIRECTORY}/raw-data
mkdir -p ${DIRECTORY}/transformed-csv
mv ${DIRECTORY}/*.log ${DIRECTORY}/log
mv ${DIRECTORY}/*-sequence-*.png ${DIRECTORY}/png-sequence
mv ${DIRECTORY}/*-date-*.png ${DIRECTORY}/png-date
mv ${DIRECTORY}/data-*.csv ${DIRECTORY}/raw-data
mv ${DIRECTORY}/transformed-*.csv ${DIRECTORY}/transformed-csv
