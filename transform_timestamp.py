import csv
import datetime
import logging
import os
import sys
from optparse import OptionParser

import psutil

from common import read_timestamp, CSV_TIME, CSV_POWER, CSV_OP, check_last_row, \
    first_timestamp, csv_name_parsing

logging.basicConfig(
    level=logging.INFO,
    # filename='thread-flask-pminfo.log',
    format='[%(process)d][%(asctime)s.%(msecs)03d][%(name)s][%(levelname)s]%(message)s',
    datefmt='%Y/%m/%d-%H:%M:%S'
)


def log_to_file():
    file_log = logging.FileHandler('transform_csv.log', mode='w')
    file_log.setLevel(logging.INFO)
    file_log.setFormatter(
        logging.Formatter(
            '[%(process)d][%(asctime)s.%(msecs)03d][%(name)s][%(levelname)s]%(message)s',
            datefmt='%Y/%m/%d-%H:%M:%S'
        )
    )
    return file_log


def memory():
    return psutil.Process().memory_full_info().vms // 1024 // 1024


def profile(m, function, *args):
    start = datetime.datetime.now()
    mem_1 = memory()
    str_prf = f'm1: {memory()}MB'
    ret = function(*args)
    t = datetime.datetime.now() - start
    mem_2 = memory()
    m.append(f'{function.__name__}\t{str_prf}\tm2: {mem_2}MB\t time: {t}\tmd: {mem_2 - mem_1}MB')
    return ret


def backwards_xs_time_compute(data_time, ts_xs):
    time_xs = []
    for ts in data_time:
        time_xs.append(
            (ts - ts_xs).total_seconds()
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


def write_csv_dict_with_lists(filename, csv_data):
    # data_time, data_mw, data_op, data_time_xs, data_time_00, data_ms = csv_shortcuts(csv_data)
    with open(filename, 'w') as f:
        header = list(csv_data.keys())
        writer = csv.DictWriter(f, header)
        writer.writeheader()
        # upper range defined by any list from the csv_data, since they all are equal
        for i in range(0, len(csv_data[header[0]])):
            data_dict = {}
            for key in header:
                data_dict[key] = csv_data[key][i]
            writer.writerow(data_dict)


def write_csv_list_of_dict(filename, csv_data):
    try:
        with open(filename, 'w') as f:
            header = csv_data[0].keys()
            writer = csv.DictWriter(f, header)
            writer.writeheader()
            writer.writerows(csv_data)
    except IndexError:
        logger.warning(f'[NO DATA IN ENERGY CSV]')


def parse_args():
    # Parsear linea de comandos
    parser = OptionParser("usage: %prog -d|--directory DIRECTORY")
    parser.add_option("-d", "--directory", action="store", type="string", dest="directory")
    (options, args) = parser.parse_args()
    if not options.directory:
        logger.error('[You must specify a working directory]')
        parser.print_help()
        sys.exit(-1)
    return options


def get_files():
    files = os.listdir(os.curdir)
    files_return = []
    for filename in files:
        if filename.startswith('data') and filename.endswith('.csv'):
            if f'transformed-{filename}' not in files:
                files_return.append(filename)
    return files_return


def main(energy_csv):
    global logger
    logger = logging.getLogger('TRANSFORM_CSV')

    options = parse_args()
    os.chdir(options.directory)
    logger.addHandler(log_to_file())

    cwd = os.getcwd()
    files = get_files()
    mem.append(f'Default memory: {memory()}M')
    for file in files:
        file_compute(cwd, energy_csv, file)


def file_compute(cwd, energy_csv, file):
    logger.info(f'[{cwd}][{file}]')
    mem.append(f'***************************** {file} *****************************')
    data = {'time_str': [], 'time': [], 'mw': [], 'op': [], 'time_xs': [], 'time_00': [], 'ms': []}
    ts_xs = None
    ts_xf = None
    with open(file, 'r+') as f:
        energy_dict = csv_name_parsing(file)
        ts_first = profile(mem, first_timestamp, f)
        profile(mem, check_last_row, f)
        ts_xs, ts_xf, energy_dict['joules'], energy_dict['time'] = \
            profile(mem, csv_compute, data, f, ts_first, ts_xf, ts_xs)
    if ts_xs and ts_xf:
        # write_csv(file, data, mem)
        del data['time']
        energy_csv.append(energy_dict)
        profile(mem, write_csv_dict_with_lists, f'transformed-{file}', data)
    else:
        logger.warning(f'[{cwd}][{file}][XS operation not found, skip this file]')


def csv_compute(data, file, ts_first, ts_xf, ts_xs):
    reader = csv.DictReader(file)
    energy = 0
    time_ms = 0
    # TODO a line can contain NULL byte, this script does not control this use case
    for row in reader:
        # data_time, data_mw, data_op, data_time_xs, data_time_00, data_ms = csv_shortcuts(data)
        time_str = row.get(CSV_TIME)
        power_current = row.get(CSV_POWER)
        op = row.get(CSV_OP)
        ms = ''
        ts_current = read_timestamp(time_str)
        # Order of these conditions is important
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

        data['time_str'].append(time_str)
        data['time'].append(ts_current)
        data['mw'].append(power_current)
        data['op'].append(op)
        data['time_00'].append(ts_current - ts_first)
        data['ms'].append(ms)
    return ts_xs, ts_xf, energy / 1000000000, time_ms / 1000000


def calculate_energy(power, power_prev, ms):
    """
    Calculate energy in joules for the zone defined by Xn, X(n-1) and { [Tn - T(n-1)] => ms }
    :param power: Xn (current power)
    :param power_prev: X(n-1) (previous power)
    :param ms: Tn-T(n-1)
    :return: float, computed energy in joules
    """
    return (float(power) + float(power_prev)) / 2 * ms


def pre_compute_checks(file):
    """
    Checks in file:
    1. return the first timestamp that appears in file
    2. checks if last row is valid (complete data), if no deletes it
    3. searches and returns timestamp of XS and XF marks
    :param file: csv file with raw data
    :return: xs, xf and first timestamps
    """
    ts_first = first_timestamp(file)
    check_last_row(file)
    ts_xs, ts_xf = None, None
    reader = csv.DictReader(file)
    for row in reader:
        op = row.get(CSV_OP)
        if op == 'XS':
            ts_xs = read_timestamp(row.get(CSV_TIME))
        if op == 'XF':
            ts_xf = read_timestamp(row.get(CSV_TIME))

    return ts_xs, ts_xf, ts_first


if __name__ == "__main__":
    mem = []
    energy_data = []
    profile(mem, main, energy_data)
    profile(mem, write_csv_list_of_dict, 'energy.csv', energy_data)

    for item in mem:
        print(item)
