import datetime
from flyingcircus.base import readline

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
# XXXXXXXXX_<device>_<os>_<bench>_<class>_<threads>[_<iteration>].<suffix>
# Where XXXXXXXXX is whatever, it must not contain '_' char
# <device> is the name of the device, example: 'hikey970', 'odroidxu4a'...
# <os> is the operating system, either 'android' or 'linux'
# <bench> is the name of npb benchmark, usually has a length of 2 chars, examples: 'is', 'fe'...
# <class> is the size of the benchmark, has a length of 1 char, examples: 's', 'w', 'c'...
# <iteration> is used for energy data files (csv's) and denotes the number of iteration that was running
# <suffix> is the format of the file, usually '.log' and '.csv'

def csv_name_parsing(filename):
    parts = filename.split('_')
    csv_row = {
        'device': parts[-6],
        'os': parts[-5],
        'benchmark': parts[-4],
        'class': parts[-3],
        'threads': parts[-2],
    }
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
    if len(rows[0]) != len(rows[1]):  # Is the last row valid?
        file.seek(file.tell() - len(rows[0]))
        file.truncate()
    file.seek(0)  # Set the current position in file at beginning


def first_timestamp(file):
    file.readline()
    ts_first = read_timestamp(file.readline().split(',')[0])
    file.seek(0)  # Set the current position in file at beginning
    return ts_first
