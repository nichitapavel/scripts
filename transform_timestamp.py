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


def main(energy_data):
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
                ts_xs, ts_xf, energy, time_ms = profile(mem, csv_compute, data, f, ts_first, ts_xf, ts_xs)
                energy_data.append({'joules': energy, 'time': time_ms})
            if ts_xs and ts_xf:
                # write_csv(local_file, data, mem)
                profile(mem, write_csv, local_file, data)
            else:
                logger.warning(f'[{cwd}][{local_file}][XS operation not found, skip this file]')


def csv_compute(data, file, ts_first, ts_xf, ts_xs):
    reader = csv.DictReader(file)
    energy = 0
    time_ms = 0
    for row in reader:
        # data_time, data_mw, data_op, data_time_xs, data_time_00, data_ms = csv_shortcuts(data)
        time = row.get(CSV_TIME)
        power_current = row.get(CSV_POWER)
        op = row.get(CSV_OP)
        ms = ''
        ts_current = read_timestamp(time)

        if ts_xs and not ts_xf:
            # When inside this condition we are at Tn and Xn with n = 1 to XF mark
            # XS is n = 0, Xn defines power in milliwatt, Tn defines time
            # energy of this zone is equal to (Xn + X(n-1))/2 * (Tn-T(n-1))
            # X(n-1) is "data['mw'][-1]", Xn is "power_current"
            # T(n-1) is "data['time'][-1]", Tn is "ts_current"
            ms = (ts_current - data['time'][-1]).microseconds
            energy += calculate_energy(power_current, data['mw'][-1], ms)
            time_ms += ms
        if op == 'XS':
            ts_xs = ts_current
            data['time_xs'] = backwards_xs_time_compute(data['time'], ts_xs)
            # data_time, data_mw, data_op, data_time_xs, data_time_00, data_ms = csv_shortcuts(data)
        if op == 'XF':
            ts_xf = ts_current
        if ts_xs:
            data['time_xs'].append(
                (ts_current - ts_xs).total_seconds()
            )

        data['time'].append(ts_current)
        data['mw'].append(power_current)
        data['op'].append(op)
        data['time_00'].append(ts_current - ts_first)
        data['ms'].append(ms)
    return ts_xs, ts_xf, energy / 1000000000, time_ms / 1000000


def calculate_energy(power, power_prev, ms):
    """ Calculate energy in joules for the zone defined by Xn, X(n-1) and { [Tn - T(n-1)] => ms }
    :param power: Xn (current power)
    :param power_prev: X(n-1) (previous power)
    :param ms: Tn-T(n-1)
    :return: float, computed energy in joules
    """
    return (float(power) + float(power_prev)) / 2 * ms


if __name__ == "__main__":
    mem = []
    energy_data = []
    profile(mem, main, energy_data)
    for item in mem:
        print(item)
    for item in energy_data:
        print(f'Joules: {item["joules"]}\t Time: {item["time"]}')
