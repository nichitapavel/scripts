import os
from datetime import datetime, timedelta
import logging
import sys
import csv
from optparse import OptionParser


logging.basicConfig(
    level=logging.INFO,
    # filename='thread-flask-pminfo.log',
    format='[%(process)d][%(asctime)s.%(msecs)03d][%(name)s][%(levelname)s]%(message)s',
    datefmt='%Y/%m/%d-%H:%M:%S'
)


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

    for local_file in os.listdir(os.curdir):
        if not local_file.startswith('transformed') and local_file.endswith('.csv'):
            logger.info('[{0}][{1}]'.format(os.getcwd(), local_file))
            ts = None
            ts_ln = None
            ts_first = None
            f = open(local_file, 'r')
            reader = csv.DictReader(f)
            for row in reader:
                op = row.get('Operation')
                if op == 'XS':
                    ts = datetime.strptime(row.get('Time'), '%Y/%m/%d-%H:%M:%S.%f')
                    ts_ln = reader.line_num
            f.close()

            tr_f = open(
                'transformed-{}'.format(local_file),
                'w'
            )
            header = reader.fieldnames
            header.append('Transformed Time - XS')
            header.append('Transformed Time - 00')
            header.append('Number of measurement')
            header.append('Sequential number of measurement')
            writer = csv.DictWriter(tr_f, header)
            writer.writeheader()

            f = open(local_file, 'r')
            reader = csv.DictReader(f)
            for row in reader:
                if reader.line_num == 2:
                    ts_first = datetime.strptime(row.get('Time'), '%Y/%m/%d-%H:%M:%S.%f')
                ts_op = datetime.strptime(row.get('Time'), '%Y/%m/%d-%H:%M:%S.%f')
                row['Transformed Time - XS'] = (ts_op - ts).total_seconds()
                row['Transformed Time - 00'] = ts_op - ts_first
                row['Number of measurement'] = reader.line_num - ts_ln
                row['Sequential number of measurement'] = reader.line_num - 1
                writer.writerow(row)
            f.close()
            tr_f.close()


if __name__ == "__main__":
    main()
