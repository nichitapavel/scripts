import csv
import logging
import os
import sys
from optparse import OptionParser

logging.basicConfig(
    level=logging.INFO,
    format='[%(process)d][%(asctime)s.%(msecs)03d][%(name)s][%(levelname)s]%(message)s',
    datefmt='%Y/%m/%d-%H:%M:%S'
)
logger = logging.getLogger('ENERGY')


def open_csv(file):
    f = open(file)
    reader = csv.DictReader(f)
    data = {'mw': [], 'micro_s': []}

    for row in reader:
        data['mw'].append(float(row.get('miliWatt')))
        data['micro_s'].append(int(row.get('micro_seconds')))
    return data


def energy_consumed(data):
    energy = 0
    size = len(data.get('mw'))
    time = 0
    for i in range(0, size):
        micro_s = data.get('micro_s')[i]
        energy += data.get('mw')[i] * micro_s
        time += micro_s
    # returned miliWatt * micro seconds, divide by a billion to get Watt * seconds = 1 Joule
    # returned micro seconds, divide by a million to get seconds
    return energy / 1000000000, time / 1000000


def main():
    # Parsear linea de comandos
    parser = OptionParser("usage: %prog -d|--directory DIRECTORY")
    parser.add_option("-d", "--directory", action="store", type="string", dest="directory")

    (options, args) = parser.parse_args()

    if not options.directory:
        logger.error('[You must specify a working directory]')
        parser.print_help()
        sys.exit(-1)

    os.chdir(options.directory)

    file_log = logging.FileHandler('energy.log', mode='w')
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

    for f in os.listdir(os.curdir):
        if f.endswith('.xsxf'):
                data = open_csv(options.directory + f)
                if data is not None:
                    energy, total_time = energy_consumed(data)
                    logger.info(f'[{os.getcwd()}][{f}][{energy} joules][{total_time} seconds]')


if __name__ == "__main__":
    main()
