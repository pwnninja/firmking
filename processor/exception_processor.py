import errno
import socket
from processor.exceptions import *

class ExceptionProcessor(object):

    def __init__(self):
        pass

    def processException(self, exception):
        print(str(exception))
        if isinstance(exception, socket.error):
            if exception.errno == errno.ECONNREFUSED:
                raise LogLastAndHaltException("Connection refused: Assuming we crashed the server, logging previous run and halting")
            elif "timed out" in str(exception):
                raise AbortCurrentRunException("Server closed the connection")
            else:
                if exception.errno:
                    raise AbortCurrentRunException("Unknown socket error: %d" % (exception.errno))
                else:
                    raise AbortCurrentRunException("Unknown socket error: %s" % (str(exception)))
        elif isinstance(exception, ConnectionClosedException):
            raise AbortCurrentRunException("Server closed connection: %s" % (str(exception)))
        elif exception.__class__ not in MessageProcessorExceptions.all:
            raise LogCrashException(str(exception))
