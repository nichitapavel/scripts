#!/bin/bash


VERSION="v0.1-jp"

usage="jp.sh -c [CORES] -p [ROOT]
Analyze raw data of energy usage. Each step is queued to Task Spooler.

Required arguments:
CORES    - Number or parallel proccesses for data analysis.
               Some steps require a high amount of RAM. If your PC hangs up, use less cores.
ROOT     - Root path of where your data is ([root])"


while [ "$1" != "" ]
do
case $1 in
  -c)
    G_CORES=$2
    shift 2
  ;;
  -p)
    ROOT_PATH=$2
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

CORES=G_CORES

for item in "01" "02" "03" "04" "05" "06" "10" "11" "12"; do
    tsp /home/pavel/git/python-scripts/.venv-37/bin/python /home/pavel/git/python-scripts/metrics_log_process.py -c ${CORES} -d ${ROOT_PATH}/sym_link/sym_link_metrics/ -s ${item}
    tsp mv /sym_link/sym_link_metrics/metrics_data.csv /sym_link/sym_link_metrics/metrics_data_${item}.csv
    tsp ln -s /sym_link/sym_link_metrics/metrics_data_${item}.csv /sym_link/metrics_data_${item}.csv

    if [ ${item} == "04" ]; then
        CORES=2
    else
        CORES=G_CORES
    fi
    tsp /home/pavel/git/python-scripts/.venv-37/bin/python /home/pavel/git/python-scripts/data_csv_process.py -c ${CORES} -d /sym_link/sym_link_data/ -s ${item}
    tsp mv /sym_link/sym_link_data/processed_data.csv /sym_link/sym_link_data/processed_data_${item}.csv
    tsp ln -s /sym_link/sym_link_data/processed_data_${item}.csv /sym_link/processed_data_${item}.csv

    tsp /home/pavel/git/python-scripts/.venv-37/bin/python /home/pavel/git/python-scripts/merge.py --df /sym_link/processed_data_${item}.csv --mf /sym_link/metrics_data_${item}.csv --sd /sym_link/
    tsp mv /sym_link/merge_data.csv /sym_link/merge_data_${item}.csv
done

tsp /home/pavel/git/python-scripts/.venv-37/bin/python /home/pavel/git/python-scripts/data_jp.py -d /sym_link/
tsp /home/pavel/git/python-scripts/.venv-37/bin/python /home/pavel/git/python-scripts/stats.py --df /sym_link/merge_data.csv --sd /sym_link/stats
tsp bash -c "mv /sym_link/stats/*.png /sym_link/stats/graphs/."

tsp bash -c "cd /home/pavel/Desktop/ && tar -cf - data_0306_01/ | xz --threads=8 > \"/home/pavel/data/compressed/2020-01-09-10-10-10 data jp 2019 paper.tar.xz\""
tsp bash -c "cd /home/pavel/Desktop/ && tar -cf - data_0306_01/ | xz --threads=8 > \"2020-01-09-10-10-10 data jp 2019 paper.tar.xz\""
