import csv
import datetime
import logging
import os
import sys
from optparse import OptionParser

import psutil

from common import read_timestamp, CSV_TIME, CSV_POWER, CSV_OP, TS_LONG_FORMAT, check_last_row, \
    first_timestamp

logging.basicConfig(
    level=logging.INFO,
    # filename='thread-flask-pminfo.log',
    format='[%(process)d][%(asctime)s.%(msecs)03d][%(name)s][%(levelname)s]%(message)s',
    datefmt='%Y/%m/%d-%H:%M:%S'
)


def memory():
    return psutil.Process().memory_full_info().vms // 1024 // 1024


def profile(mem, function, *args):
    start = datetime.datetime.now()
    mem_1 = memory()
    str_prf = f'm1: {memory()}MB\t'
    ret = function(*args)
    t = datetime.datetime.now() - start
    mem_2 = memory()
    mem.append(f'{function.__name__ }\t' + str_prf + f'm2: {mem_2}MB\t time: {t}\tmd: {mem_2 - mem_1}MB')
    return ret


def backwards_xs_time_compute(data_time, ts_xs):
    time_xs = []
    for item in data_time:
        time_xs.append(
            (item-ts_xs).total_seconds()
        )
    return time_xs


def csv_shortcuts(data):
    data_time = data.get('time')
    data_mw = data.get('mw')
    data_op = data.get('op')
    data_time_xs = data.get('time_xs')
    data_time_00 = data.get('time_00')
    data_ms = data.get('ms')
    return data_time, data_mw, data_op, data_time_xs, data_time_00, data_ms


def write_csv(file, csv_data):
    # data_time, data_mw, data_op, data_time_xs, data_time_00, data_ms = csv_shortcuts(csv_data)
    with open(f'transformed-{file}', 'w') as f:
        header = csv_data.keys()
        writer = csv.DictWriter(f, header)
        writer.writeheader()
        for i in range(0, len(csv_data['time'])):
            writer.writerow({
                # data_time has datetime.datetime objects, I keep the initial format TS_LONG_FORMAT from common.py
                # and slash the last 2 digits of microseconds
                # 'time': data_time[i],
                'time': csv_data['time'][i].strftime(TS_LONG_FORMAT)[:-2],
                'mw': csv_data['mw'][i],
                'op': csv_data['op'][i],
                'time_xs': csv_data['time_xs'][i],
                'time_00': csv_data['time_00'][i],
                'ms': csv_data['ms'][i]
            })


def main():
    logger = logging.getLogger('TRANSFORM_CSV')

    # Parsear linea de comandos
    parser = OptionParser("usage: %prog -d|--directory DIRECTORY")
    parser.add_option("-d", "--directory", action="store", type="string", dest="directory")

    (options, args) = parser.parse_args()

    if not options.directory:
        logger.error('[You must specify a working directory]')
        parser.print_help()
        sys.exit(-1)

    os.chdir(options.directory)

    file_log = logging.FileHandler('transform_csv.log', mode='w')
    file_log.setLevel(logging.INFO)
    file_log.setFormatter(
        logging.Formatter(
            '[%(process)d][%(asctime)s.%(msecs)03d][%(name)s][%(levelname)s]%(message)s',
            datefmt='%Y/%m/%d-%H:%M:%S'
        )
    )

    logger.addHandler(
        file_log
    )

    cwd = os.getcwd()
    mem.append(f'Default memory: {memory()}M')
    for local_file in os.listdir(os.curdir):
        # if not local_file.startswith('transformed') and local_file.endswith('.csv'):
        # if local_file == '01_small_file.csv':
        if local_file == '02_medium_file.csv':
        # if local_file == '03_big_file.csv':
            logger.info(f'[{cwd}][{local_file}]')
            data = {'time': [], 'mw': [], 'op': [], 'time_xs': [], 'time_00': [], 'ms': []}
            ts_xs = None
            ts_xf = None
            with open(local_file, 'r+') as f:
                ts_first = profile(mem, first_timestamp, f)
                profile(mem, check_last_row, f)
                reader = profile(mem, csv.DictReader, f)
                ts_xs, ts_xf = profile(mem, csv_compute, data, reader, ts_first, ts_xf, ts_xs)
            if ts_xs:
                # write_csv(local_file, data, mem)
                profile(mem, write_csv, local_file, data)
            else:
                logger.warning(f'[{cwd}][{local_file}][XS operation not found, skip this file]')


def csv_compute(data, reader, ts_first, ts_xf, ts_xs):
    for row in reader:
        # data_time, data_mw, data_op, data_time_xs, data_time_00, data_ms = csv_shortcuts(data)
        time = row.get(CSV_TIME)
        power = row.get(CSV_POWER)
        op = row.get(CSV_OP)
        ms = ''
        ts_current = read_timestamp(time)

        if op == 'XS':
            ts_xs = ts_current
            data['time_xs'] = backwards_xs_time_compute(data['time'], ts_xs)
            # data_time, data_mw, data_op, data_time_xs, data_time_00, data_ms = csv_shortcuts(data)
        if op == 'XF':
            ts_xf = ts_current
        if ts_xs and not ts_xf:
            ms = (ts_current - data['time'][-1]).microseconds
        if ts_xs:
            data['time_xs'].append(
                (ts_current - ts_xs).total_seconds()
            )

        data['time'].append(ts_current)
        data['mw'].append(power)
        data['op'].append(op)
        data['time_00'].append(ts_current - ts_first)
        data['ms'].append(ms)
    return ts_xs, ts_xf


if __name__ == "__main__":
    mem = []
    profile(mem, main)
    for item in mem:
        print(item)
