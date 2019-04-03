import logging
import os
import sys
from optparse import OptionParser


logging.basicConfig(
    level=logging.INFO,
    # filename='thread-flask-pminfo.log',
    format='[%(process)d][%(asctime)s.%(msecs)03d][%(name)s][%(levelname)s]%(message)s',
    datefmt='%Y/%m/%d-%H:%M:%S'
)


def main():
    logger = logging.getLogger('RM_LAST_LINE')

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
            f = open(local_file, 'a+')
            a = f.readlines()
            if len(a[-1]) != len(a[-2]):
                f.seek(-len(a[-1]), 2)
                f.truncate()
                f.close()


if __name__ == "__main__":
    main()
