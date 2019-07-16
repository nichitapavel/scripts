import datetime
import os

from flyingcircus.base import readline

from custom_exceptions import UnsupportedNumberOfCores
from transform_timestamp import logger

# Devices used in testing
HIKEY970 = 'hikey970'
ODROIDXU4_A = 'odroidxu4a'
ODROIDXU4_B = 'odroidxu4b'
ROCK960 = 'rock960'

# Expected datetime formats
TS_LONG_FORMAT = '%Y/%m/%d-%H:%M:%S.%f'
TS_FORMAT = [
    TS_LONG_FORMAT,
    '%H:%M:%S.%f',
    '%H:%M:%S',
]

# CSV header names
CSV_TIME = 'Time'
CSV_POWER = 'Power(mWatt)'
CSV_OP = 'Operation'


# Files naming scheme:
# [<type>_]XXXXXXXXX_<device>_<os>_<bench>_<class>_<threads>[_<iteration>].<suffix>
# Where XXXXXXXXX is whatever, it must not contain '_' char
# <type> is the app mode, currently 'release' or 'debug'
# <device> is the name of the device, example: 'hikey970', 'odroidxu4a'...
# <os> is the operating system, either 'android' or 'linux'
# <bench> is the name of npb benchmark, usually has a length of 2 chars, examples: 'is', 'fe'...
# <class> is the size of the benchmark, has a length of 1 char, examples: 's', 'w', 'c'...
# <iteration> is used for energy data files (csv's) and denotes the number of iteration that was running
# <suffix> is the format of the file, usually '.log' and '.csv'

def csv_name_parsing(filename):
    csv_row = {}
    parts = filename.split('.')
    if parts[-1] == 'csv':
        parts_csv = parts[-2].split('_')
        csv_row = {}
        try:
            csv_row.update({'type': parts_csv[-8]})
        except IndexError:
            csv_row.update({'type': ''})
            pass
        csv_row.update({
            'device': parts_csv[-6],
            'os': parts_csv[-5],
            'benchmark': parts_csv[-4],
            'size': parts_csv[-3],
            'threads': parts_csv[-2],
            'iteration': parts_csv[-1]
        })
    elif parts[-1] == 'log':
        parts_log = parts[-2].split('_')
        csv_row = {}
        try:
            csv_row.update({'type': parts_log[-7]})
        except IndexError:
            csv_row.update({'type': ''})
            pass
        csv_row.update({
            'device': parts_log[-5],
            'os': parts_log[-4],
            'benchmark': parts_log[-3],
            'size': parts_log[-2],
            'threads': parts_log[-1],
        })
    return csv_row


def read_timestamp(timestamp):
    for item in TS_FORMAT:
        try:
            ts = datetime.datetime.strptime(timestamp, item)
            return ts
        except ValueError:
            pass
    return None


def is_valid_last_row(rows):
    if rows[-2][CSV_OP] is None or \
            len(rows[-2][CSV_TIME]) != len(rows[-2][CSV_TIME]) or \
            rows[-1][CSV_POWER] is None or \
            len(rows[-2][CSV_POWER]) != len(rows[-2][CSV_POWER]):
        return False
    return True


def check_last_row(file):
    rows = []  # Save the last 2 rows here

    # Only iterate 2 times to get the last 2 rows
    for row in readline(file, reverse=True):
        if len(rows) < 2:
            rows.append(row)
        else:
            break
    if len(rows) < 2:
        logger.warning(f'[{file}][Pogit cssibly empty]')
    else:
        if len(rows[0]) != len(rows[1]):  # Is the last row valid?
            file.seek(file.tell() - len(rows[0]))
            file.truncate()
    file.seek(0)  # Set the current position in file at beginning


def first_timestamp(file):
    # TODO a line can contain NULL byte, this script does not control this use case
    file.readline()
    ts_first = read_timestamp(file.readline().split(',')[0])
    file.seek(0)  # Set the current position in file at beginning
    return ts_first


def set_cores(req_cores):
    """
    Function to set the number of cores to be used. If the requested number of cores exceeds what the
    system has an exception is raised, otherwise will set requested number of cores.
    In case the number of cores is not specified it will be set with these requirements:
    1. for systems with more than 4 cores, always will leave 2 cores for os and other computations, ie. a system
      with 16 cores will use a maximum 14 cores for your task.
    2. for system with less or equal to 4 cores all available cores will be used.
    :param req_cores: integer with the requested cores set by argument '-c/--cores'
    :return: number of cores to be used
    """
    sys_cores = os.cpu_count()
    if req_cores is None:
        if sys_cores > 4:
            return sys_cores - 2
        else:
            return sys_cores
    if req_cores > sys_cores or req_cores <= 0:
        raise UnsupportedNumberOfCores(f'Requested cores \'{req_cores}\' is not supported, available cores: {sys_cores}')
    return req_cores
