import csv
import datetime
import logging
import os
import sys
from optparse import OptionParser

import psutil

from common import read_timestamp, CSV_TIME, CSV_POWER, CSV_OP, is_valid_last_row, TS_LONG_FORMAT

logging.basicConfig(
    level=logging.INFO,
    # filename='thread-flask-pminfo.log',
    format='[%(process)d][%(asctime)s.%(msecs)03d][%(name)s][%(levelname)s]%(message)s',
    datefmt='%Y/%m/%d-%H:%M:%S'
)


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


def write_csv(file, csv_data, mem):
    data_time, data_mw, data_op, data_time_xs, data_time_00, data_ms = csv_shortcuts(csv_data)
    tr_f = open(
        f'transformed-{file}',
        'w'
    )
    header = csv_data.keys()
    writer = csv.DictWriter(tr_f, header)
    writer.writeheader()
    start = datetime.datetime.now()
    for i in range(0, len(data_time)):
        writer.writerow({
            # data_time has datetime.datetime objects, I keep the initial format TS_LONG_FORMAT from common.py
            # and slash the last 2 digits of microseconds
            'time': data_time[i].strftime(TS_LONG_FORMAT)[:-2],
            'mw': data_mw[i],
            'op': data_op[i],
            'time_xs': data_time_xs[i],
            'time_00': data_time_00[i],
            'ms': data_ms[i]
        })
    m = psutil.virtual_memory()
    mem.append(f'After data to dict: {m.percent}, used: {m.used // 1024 // 1024}, free: {m.free // 1024 // 1024}')
    print(datetime.datetime.now() - start)


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
    mem = []
    m = psutil.virtual_memory()
    mem.append(f'Default memory: {m.percent}, used: {m.used // 1024 // 1024}, free: {m.free // 1024 // 1024}')
    for local_file in os.listdir(os.curdir):
        if not local_file.startswith('transformed') and local_file.endswith('.csv'):
        # if local_file == 'data-odroidxu4_a_mg4-B-087.csv':
        # if local_file == 'test_file.csv':
            logger.info(f'[{cwd}][{local_file}]')
            data = {'time': [], 'mw': [], 'op': [], 'time_xs': [], 'time_00': [], 'ms': []}
            data_time, data_mw, data_op, data_time_xs, data_time_00, data_ms = csv_shortcuts(data)
            xs_zone = False
            xf_zone = False
            ts_xs = None
            f = open(local_file, 'r')
            reader = csv.DictReader(f)
            csv_list = list(reader)
            m = psutil.virtual_memory()
            mem.append(f'After list(reader): {m.percent}, used: {m.used // 1024 // 1024}, free: {m.free // 1024 // 1024}')
            ts_first = read_timestamp(
                csv_list[0][CSV_TIME]
            )
            f.close()
            if not is_valid_last_row(csv_list[-2:]):
                del csv_list[-1]
            # reader.fieldnames
            # list(reader)  # converts a csv reader to a list of it's values
            for i in range(0, len(csv_list)):
                time = csv_list[i][CSV_TIME]
                power = csv_list[i][CSV_POWER]
                op = csv_list[i][CSV_OP]
                ms = ''
                ts_op = read_timestamp(time)

                if op == 'XS':
                    ts_xs = read_timestamp(time)
                    xs_zone = True
                    # MUST UPDATE REFERENCE TO DATA!
                    data['time_xs'] = backwards_xs_time_compute(data_time, ts_xs)
                    data_time, data_mw, data_op, data_time_xs, data_time_00, data_ms = csv_shortcuts(data)
                if op == 'XF':
                    xf_zone = True
                if xs_zone and not xf_zone:
                    ms = (
                            read_timestamp(time) - data_time[-1]
                    ).microseconds
                if ts_xs:
                    data_time_xs.append(
                        (ts_op - ts_xs).total_seconds()
                    )

                data_time.append(ts_op)
                data_mw.append(power)
                data_op.append(op)
                data_time_00.append(ts_op - ts_first)
                data_ms.append(ms)

            m = psutil.virtual_memory()
            mem.append(f'After first for: {m.percent}, used: {m.used // 1024 // 1024}, free: {m.free // 1024 // 1024}')

            if ts_xs:
                write_csv(local_file, data, mem)
            else:
                logger.warning(f'[{cwd}][{local_file}][XS operation not found, skip this file]')

    for item in mem:
        print(item)


if __name__ == "__main__":
    main()
    m = psutil.virtual_memory()
    print(f'final: {m.percent}, used: {m.used // 1024 // 1024}, free: {m.free // 1024 // 1024}')
