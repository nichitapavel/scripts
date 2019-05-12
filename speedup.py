"""
Reads an .csv file with format:
device,os,benchmark,size,threads,seconds,mops
and sums up all seconds and/or mops values for
combination of "device,os,benchmark,size,threads"
that match, stores this in data variable.
If a combination is not in data variable it will not
stored.

"""

import csv
import logging
import sys

from optparse import OptionParser

logging.basicConfig(
    level=logging.INFO,
    # filename='thread-flask-pminfo.log',
    format='[%(process)d][%(asctime)s.%(msecs)03d][%(name)s][%(levelname)s]%(message)s',
    datefmt='%Y/%m/%d-%H:%M:%S'
)
logger = logging.getLogger('SPEEDUPS')


HIKEY970 = 'hikey970'
ODROIDXU4 = 'odroidxu4'
ROCK960 = 'rock960'

ANDROID = 'android'
LINUX = 'linux'

IS = 'is'
MG = 'mg'
BT = 'bt'

B = 'b'
W = 'w'

THREADS1 = '1'
THREADS2 = '2'
THREADS4 = '4'
THREADS8 = '8'


# ANDROID
hikey970_android_is_b_1='hikey970_android_is_b_1'
hikey970_android_is_b_2='hikey970_android_is_b_2'
hikey970_android_is_b_4='hikey970_android_is_b_4'
hikey970_android_mg_b_1='hikey970_android_mg_b_1'
hikey970_android_mg_b_2='hikey970_android_mg_b_2'
hikey970_android_mg_b_4='hikey970_android_mg_b_4'
hikey970_android_bt_w_1='hikey970_android_bt_w_1'
hikey970_android_bt_w_2='hikey970_android_bt_w_2'
hikey970_android_bt_w_4='hikey970_android_bt_w_4'

odroidxu4_android_is_b_1='odroidxu4_android_is_b_1'
odroidxu4_android_is_b_2='odroidxu4_android_is_b_2'
odroidxu4_android_is_b_4='odroidxu4_android_is_b_4'
odroidxu4_android_mg_b_1='odroidxu4_android_mg_b_1'
odroidxu4_android_mg_b_2='odroidxu4_android_mg_b_2'
odroidxu4_android_mg_b_4='odroidxu4_android_mg_b_4'
odroidxu4_android_bt_w_1='odroidxu4_android_bt_w_1'
odroidxu4_android_bt_w_2='odroidxu4_android_bt_w_2'
odroidxu4_android_bt_w_4='odroidxu4_android_bt_w_4'

rock960_android_is_b_1='rock960_android_is_b_1'
rock960_android_is_b_2='rock960_android_is_b_2'
rock960_android_is_b_4='rock960_android_is_b_4'
rock960_android_mg_b_1='rock960_android_mg_b_1'
rock960_android_mg_b_2='rock960_android_mg_b_2'
rock960_android_mg_b_4='rock960_android_mg_b_4'
rock960_android_bt_w_1='rock960_android_bt_w_1'
rock960_android_bt_w_2='rock960_android_bt_w_2'
rock960_android_bt_w_4='rock960_android_bt_w_4'


# LINUX
hikey970_linux_is_b_1='hikey970_linux_is_b_1'
hikey970_linux_is_b_2='hikey970_linux_is_b_2'
hikey970_linux_is_b_4='hikey970_linux_is_b_4'
hikey970_linux_is_b_8='hikey970_linux_is_b_8'
hikey970_linux_mg_b_1='hikey970_linux_mg_b_1'
hikey970_linux_mg_b_2='hikey970_linux_mg_b_2'
hikey970_linux_mg_b_4='hikey970_linux_mg_b_4'
hikey970_linux_mg_b_8='hikey970_linux_mg_b_8'
hikey970_linux_bt_w_1='hikey970_linux_bt_w_1'
hikey970_linux_bt_w_2='hikey970_linux_bt_w_2'
hikey970_linux_bt_w_4='hikey970_linux_bt_w_4'
hikey970_linux_bt_w_8='hikey970_linux_bt_w_8'

odroidxu4_linux_is_b_1='odroidxu4_linux_is_b_1'
odroidxu4_linux_is_b_2='odroidxu4_linux_is_b_2'
odroidxu4_linux_is_b_4='odroidxu4_linux_is_b_4'
odroidxu4_linux_is_b_8='odroidxu4_linux_is_b_8'
odroidxu4_linux_mg_b_1='odroidxu4_linux_mg_b_1'
odroidxu4_linux_mg_b_2='odroidxu4_linux_mg_b_2'
odroidxu4_linux_mg_b_4='odroidxu4_linux_mg_b_4'
odroidxu4_linux_mg_b_8='odroidxu4_linux_mg_b_8'
odroidxu4_linux_bt_w_1='odroidxu4_linux_bt_w_1'
odroidxu4_linux_bt_w_2='odroidxu4_linux_bt_w_2'
odroidxu4_linux_bt_w_4='odroidxu4_linux_bt_w_4'
odroidxu4_linux_bt_w_8='odroidxu4_linux_bt_w_8'

data = {
    hikey970_android_is_b_1: [],
    hikey970_android_is_b_2: [],
    hikey970_android_is_b_4: [],
    hikey970_android_mg_b_1: [],
    hikey970_android_mg_b_2: [],
    hikey970_android_mg_b_4: [],
    hikey970_android_bt_w_1: [],
    hikey970_android_bt_w_2: [],
    hikey970_android_bt_w_4: [],
    odroidxu4_android_is_b_1: [],
    odroidxu4_android_is_b_2: [],
    odroidxu4_android_is_b_4: [],
    odroidxu4_android_mg_b_1: [],
    odroidxu4_android_mg_b_2: [],
    odroidxu4_android_mg_b_4: [],
    odroidxu4_android_bt_w_1: [],
    odroidxu4_android_bt_w_2: [],
    odroidxu4_android_bt_w_4: [],
    rock960_android_is_b_1: [],
    rock960_android_is_b_2: [],
    rock960_android_is_b_4: [],
    rock960_android_mg_b_1: [],
    rock960_android_mg_b_2: [],
    rock960_android_mg_b_4: [],
    rock960_android_bt_w_1: [],
    rock960_android_bt_w_2: [],
    rock960_android_bt_w_4: [],
    hikey970_linux_is_b_1: [],
    hikey970_linux_is_b_2: [],
    hikey970_linux_is_b_4: [],
    hikey970_linux_is_b_8: [],
    hikey970_linux_mg_b_1: [],
    hikey970_linux_mg_b_2: [],
    hikey970_linux_mg_b_4: [],
    hikey970_linux_mg_b_8: [],
    hikey970_linux_bt_w_1: [],
    hikey970_linux_bt_w_2: [],
    hikey970_linux_bt_w_4: [],
    hikey970_linux_bt_w_8: [],
    odroidxu4_linux_is_b_1: [],
    odroidxu4_linux_is_b_2: [],
    odroidxu4_linux_is_b_4: [],
    odroidxu4_linux_is_b_8: [],
    odroidxu4_linux_mg_b_1: [],
    odroidxu4_linux_mg_b_2: [],
    odroidxu4_linux_mg_b_4: [],
    odroidxu4_linux_mg_b_8: [],
    odroidxu4_linux_bt_w_1: [],
    odroidxu4_linux_bt_w_2: [],
    odroidxu4_linux_bt_w_4: [],
    odroidxu4_linux_bt_w_8: []
}


def open_csv(file):
    f = open(file)
    reader = csv.DictReader(f)

    for row in reader:
        item = return_func(row)
        if data.get(item) is not None:
            data.get(item).append(float(row.get('seconds')))

    for item, values in data.items():
        if len(values) != 0:
            logger.info(f'[{item}][{media(values)}]')


def cond_func(row, device, os, benchmark, size, threads):
    if row.get('device') == device:
        if row.get('os') == os:
            if row.get('benchmark') == benchmark:
                if row.get('size') == size:
                    if row.get('threads') == threads:
                        return float(row.get('seconds'))


def return_func(row):
    device = row.get('device')
    os = row.get('os')
    benchmark = row.get('benchmark')
    size = row.get('size')
    threads = row.get('threads')
    return f'{device}_{os}_{benchmark}_{size}_{threads}'


def media(data):
    sum = 0.0
    for item in data:
        sum += item
    return sum / len(data)


def main():
    # Parsear linea de comandos
    parser = OptionParser("usage: %prog -f|--file FILE")
    parser.add_option("-f", "--file", action="store", type="string", dest="file")

    (options, args) = parser.parse_args()

    if not options.file:
        logger.error('[You must specify a .csv file]')
        parser.print_help()
        sys.exit(-1)

    file_log = logging.FileHandler('speedups.log', mode='w')
    file_log.setLevel(logging.INFO)
    file_log.setFormatter(
        logging.Formatter(
            '[%(process)d][%(asctime)s.%(msecs)03d][%(name)s][%(levelname)s]%(message)s',
            datefmt='%Y/%m/%d-%H:%M:%S'
        )
    )

    open_csv(options.file)

    logger.addHandler(
        file_log
    )


if __name__ == "__main__":
    main()
