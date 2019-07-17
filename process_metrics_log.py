import logging
import os
from multiprocessing import Manager, Pool

from common import csv_name_parsing, log_to_file, profile, write_csv_list_of_dict, parse_args

logging.basicConfig(
    level=logging.INFO,
    # filename='thread-flask-pminfo.log',
    format='[%(process)d][%(asctime)s.%(msecs)03d][%(name)s][%(levelname)s]%(message)s',
    datefmt='%Y/%m/%d-%H:%M:%S'
)

logger = logging.getLogger('TRANSFORM_METRICS')


def metrics_compute(file):
    data = []
    name_parsed = csv_name_parsing(file)
    with open(file, 'r') as f:
        lines = f.readlines()
        i = 0
        while i < len(lines):
            if 'Run:' in lines[i]:
                metric_dict = {}
                metric_dict.update(name_parsed)
                iteration = int(lines[i].split()[2])
                metric_dict.update({'iteration': f'{iteration:03}'})
                time_npb = ''
                mops = ''
                i += 1
                try:
                    while 'Run:' not in lines[i]:
                        if 'Time in ' in lines[i]:
                            time_npb = float(lines[i].split()[5])
                        elif 'Mops ' in lines[i]:
                            mops = float(lines[i].split()[4])
                        i += 1
                    i -= 1
                except IndexError:
                    pass
                metric_dict.update({'time_npb': time_npb, 'mops': mops})
                data.append(metric_dict)

            i += 1
    return data


def get_files():
    """
    Returns a list of files reverse sorted by size.
    Bigger files are first processed to try and maximize the efficiency.
    This does not guaranty that bigger files will always take more time
    to process then smaller files.
    :return: a list of string representing files in current directory
    """
    files = os.listdir(os.curdir)
    files_ret = []
    for filename in files:
        if filename.startswith('03') and filename.endswith('.log'):
            files_ret.append(filename)
    return files_ret


def main():
    options = parse_args(logger)
    os.chdir(options.directory)
    logger.addHandler(log_to_file())

    cwd = os.getcwd()
    files = get_files()
    processed_data = []


    # TODO mem profiling not working with mp
    with Pool(options.cores) as p:
        results = [p.apply_async(metrics_compute, (file,)) for file in files]
        for result in results:
            processed_data.extend(result.get())

    profile(mem, 'main', write_csv_list_of_dict, 'metrics_data.csv', processed_data, logger)


if __name__ == "__main__":
    with Manager() as manager:
        mem = manager.list()
        profile(mem, 'global', main)

        mem.sort()
        for item in mem:
            print(item)
