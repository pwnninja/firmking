import imp
import sys
import os.path
import threading
import socket
from os import listdir
from threading import Event
from processor.exceptions import MessageProcessorExceptions

class ProcDirector(object):
    def __init__(self, processDir):
        self.messageProcessor = None
        self.exceptionProcessor = None
        self.exceptionList = None
        self.monitor = None
        mod_name = ""  
        self.classDir = "processor"
        
        defaultDir = os.path.join(os.path.join(os.path.dirname(os.path.realpath(__file__)), os.path.pardir),self.classDir)
        filelist = [ "exception_processor","message_processor","monitor" ]
        
        for filename in filelist:
            try:
                filepath = os.path.join(processDir, "{0}.py".format(filename))
                imp.load_source(filename, filepath)
                print("Loaded custom processor: {0}".format(filepath))
            except IOError:
                filepath = os.path.join(defaultDir, "{0}.py".format(filename))
                imp.load_source(filename, filepath)
                print("Loaded default processor: {0}".format(filepath))
                
        self.messageProcessor = sys.modules['message_processor'].MessageProcessor
        self.exceptionProcessor = sys.modules['exception_processor'].ExceptionProcessor
        self.monitor = sys.modules['monitor'].Monitor 
        self.crashQueue = Event()
    
    class MonitorWrapper(object):
        def __init__(self, targetIP, targetPort, monitor):
            self.monitor = monitor
            self.crashEvent = threading.Event()
            self.task = threading.Thread(target=self.monitor.monitorTarget,args=(targetIP,targetPort,self.signalCrashDetectedOnMain))
            self.task.daemon = True
            self.task.start()

        def signalCrashDetectedOnMain(self):
            self.crashEvent.set()
            import thread
            thread.interrupt_main()
    
    def startMonitor(self, host, port):
        self.monitorWrapper = self.MonitorWrapper(host, port, self.monitor())
        return self.monitorWrapper
        
