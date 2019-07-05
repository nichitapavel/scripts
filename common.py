import datetime

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
