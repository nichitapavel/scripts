import logging
import signal
import socket
import struct
import sys
import threading
import os
import urllib
import urlparse
from Queue import Empty, Queue
from datetime import datetime
from optparse import OptionParser
from time import sleep

from enum import Enum
from flask import request, Flask

logging.basicConfig(
    level=logging.INFO,
    # filename='thread-flask-pminfo.log',
    format='[%(process)d][%(name)s][%(levelname)s] %(message)s'
)


class Operation(Enum):
    AS = 'matrix A fill start'
    AF = 'matrix A fill finish'
    BS = 'matrix B fill start'
    BF = 'matrix B fill finish'
    XS = 'matrix compute start'
    XF = 'matrix compute finish'


# Create a single input and a single output queue for all threads.
marks = Queue()
app = Flask("server")


@app.route('/message')
def message():
    try:
        query = urllib.unquote(request.query_string)
        params = urlparse.parse_qs(query)
        timestamp = datetime.fromtimestamp(
            long(params.get('timestamp')[0]) / 1000.0
        )
        # timestamp = datetime.datetime.strftime(
        #     timestamp,
        #     '%Y/%m/%d - %H:%M:%S.%f'
        # )[:-2]

        msg = {
            'device': params.get('device')[0],
            'device timestamp': params.get('timestamp')[0],
            'local timestamp': timestamp,
            'operation': params.get('operation')[0]
        }
        marks.put(msg)
    except TypeError:
        logging.warnings('The http query is malformed')
    return ''


class FlaskThread(threading.Thread):
    def __init__(self, marks):
        super(FlaskThread, self).__init__()
        self.name = 'FlaskThread'
        self.marks = marks
        self.stop_request = threading.Event()
        self.logger = logging.getLogger(__name__)
        log = logging.getLogger('werkzeug')
        log.setLevel(logging.ERROR)

    def run(self):
        app.run(host='0.0.0.0', port=port)

    def join(self, timeout=None):
        self.stop_request.set()
        super(FlaskThread, self).join(timeout)


class PMInfoThread(threading.Thread):
    def __init__(self, marks):
        super(PMInfoThread, self).__init__()
        self.name = type(self).__name__
        self.marks = marks
        self.stop_request = threading.Event()
        self.logger = logging.getLogger(type(self).__name__)

    def run(self):
        dev_name = 'APCape8L'
        send_all_data(client, struct.pack("i", 9))
        msg = struct.pack("i", len(dev_name))
        msg += dev_name
        msg += struct.pack("i", 0)
        send_all_data(client, msg)
        count = 0
        last_ten_thousands = 0.0

        f = open(file, 'w')
        f.write('Time,Power(mWatt),Operation\n')

        while not self.stop_request.isSet():
            try:
                lines = receive_data(client, "i")
                lines_array = []

                for lin in xrange(lines):
                    line_power = receive_data(client, "d")
                    lines_array.append("%.2f" % (line_power))

                # wattage = 0.0
                # if len(lines_array) != 0:
                #     wattage = lines_array[0]
                #     last_ten_thousands += float(wattage)
                #     count += 1

                # if count > 10000:
                #     average = last_ten_thousands / count
                #     if average < 6510:
                #         self.logger.info('average below 6510')
                #         self.logger.info('average %d with count %d', average, count)
                #         pool[1].stop_request.set()
                #         self.stop_request.set()
                #
                #     else:
                #         self.logger.info('average higher 6510')
                #         self.logger.info('average %d with count %d', average, count)
                #         last_ten_thousands = 0.0
                #         count = 0

                # self.logger.info(wattage)

                if not self.marks.empty():
                    mark = self.marks.get()
                    self.marks.task_done()
                    # self.logger.info(
                    #     '[device:' + mark.get('device') +
                    #     '][device timestamp:' + mark.get('device timestamp') +
                    #     '][local timestamp:' + str(mark.get('local timestamp')) +
                    #     '][operation:' + mark.get('operation') +
                    #     ']'
                    # )
                    f.writelines(
                        "{0},{1},{2}\n".format(
                            datetime.now().strftime('%Y/%m/%d-%H:%M:%S.%f')[:-2],
                            lines_array[line],
                            mark.get('operation')
                        )
                    )
                elif len(lines_array) != 0:
                    f.writelines(
                        "{0},{1},\n".format(
                            datetime.now().strftime('%Y/%m/%d-%H:%M:%S.%f')[:-2],
                            lines_array[line]
                        )
                    )
            except Empty:
                continue

    def join(self, timeout=None):
        self.stop_request.set()
        super(PMInfoThread, self).join(timeout)


def handler():
    if mode == "read":
        send_all_data(client, struct.pack("i", 0))
        client.close()


def receive_data(client, datatype):
    try:
        msg = client.recv(struct.calcsize(datatype))
        if len(msg) == 0:
            client.close()
            sys.exit(1)
    except Exception:
        client.close()
        sys.exit(1)

    try:
        return struct.unpack(datatype, msg)[0]
    except struct.error as err:
        print('Error found! Here are the details:')
        # noinspection SpellCheckingInspection
        print('datatype: ' + datatype + '\t msg: ' + msg)
        print err
        client.close()
        sys.exit(1)


def send_all_data(client, msg):
    totalsent = 0
    while totalsent < len(msg):
        sent = client.send(msg[totalsent:])
        if sent == 0:
            raise RuntimeError
        totalsent = totalsent + sent


def main():
    logger = logging.getLogger('FLASK_PM_INFO')

    # Parsear linea de comandos
    parser = OptionParser("usage: %prog -s|--server SERVER:PORT\n"
                          "       %prog -r|--read DEVNAME [-f|--freq FREQ]")
    parser.add_option("-s", "--server", action="store", type="string", dest="server")
    parser.add_option("-r", "--read", action="store", type="string", dest="device")
    parser.add_option("-f", "--file", action="store", type="string", dest="file")
    parser.add_option("-d", "--directory", action="store", type="string", dest="directory")
    parser.add_option("-p", "--port", action="store", type="string", dest="port")
    parser.add_option("-l", "--line", action="store", type="int", dest="line")

    (options, args) = parser.parse_args()

    exit_script = False
    if not options.server or len(options.server.split(":")) != 2:
        logger.error('You must specify a pm_server SERVER:PORT!')
        exit_script = True
    elif not options.directory:
        logger.error('You must specify a working directory')
        exit_script = True
    elif not options.file:
        logger.error('You must specify a file to save data')
        exit_script = True
    elif not options.port:
        logger.error('You must specify a local port')
        exit_script = True
    elif not options.line:
        logger.error('You must specify a line to save power metrics')
        exit_script = True

    if exit_script:
        parser.print_help()
        sys.exit(-1)

    if not os.path.exists(options.directory):
        os.makedirs(options.directory)

    global client, mode, pool, file, port, line
    mode = 'read'
    file = options.directory + options.file
    port = options.port
    line = options.line - 1

    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client.connect((options.server.split(":")[0], int(options.server.split(":")[1])))
    signal.signal(signal.SIGINT, handler)

    pool = [PMInfoThread(marks=marks), FlaskThread(marks=marks)]

    for thread in pool:
        thread.daemon = True
        thread.start()

    while pool[0].is_alive() and pool[1].is_alive():
        sleep(10)
    sys.exit(0)


if __name__ == '__main__':
    main()