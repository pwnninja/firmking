import argparse
import datetime
import errno
import ssl
import imp
import os.path
import os
import signal
import socket
import subprocess
import sys
import threading
import time
from copy import deepcopy
from kingcore.proc_director import ProcDirector
from kingcore.fuzzer_types import Message, MessageCollection, Logger
from kingcore.packets import PROTO,IP
from processor.exceptions import *
from processor.message_processor import MessageProcessorExtraParams
from kingcore.fuzzerdata import FuzzerData

RADAMSA=os.path.abspath(os.path.join(__file__, "/usr/bin/radamsa") )
MIN_RUN_NUMBER=0
MAX_RUN_NUMBER=-1  
SEED_LOOP = []
DUMPDIR = ""

def sendPacket(connection, addr, outPacketData):
    connection.settimeout(fuzzerData.receiveTimeout)
    if connection.type == socket.SOCK_STREAM:
        connection.send(outPacketData)
    else:
        connection.sendto(outPacketData,addr)
    print("\tSent %d byte packet" % (len(outPacketData)))
    print("\tSent: %s" % (outPacketData))
    print("\tRaw Bytes: %s" % (Message.serializeByteArray(outPacketData)))

def receivePacket(connection, addr, bytesToRead):
    readBufSize = 4096
    connection.settimeout(fuzzerData.receiveTimeout)
    if connection.type == socket.SOCK_STREAM or connection.type == socket.SOCK_DGRAM:
        response = bytearray(connection.recv(readBufSize))
    else:
        response = bytearray(connection.recvfrom(readBufSize,addr))  
    if len(response) == 0:
        raise ConnectionClosedException("Server has closed the connection")
    if bytesToRead > readBufSize:
        i = readBufSize
        while i < bytesToRead:
            response += bytearray(connection.recv(readBufSize))
            i += readBufSize          
    print("\tReceived %d bytes" % (len(response)))
    print("\tReceived: %s" % (response))
    return response

def getRunNumbersFromArgs(strArgs):
    if "-" in strArgs:
        testNumbers = strArgs.split("-")
        if len(testNumbers) == 2:
            if len(testNumbers[1]):
                return (int(testNumbers[0]), int(testNumbers[1]))
            else:                   
                return (int(testNumbers[0]),-1)
        else:
            sys.exit("Invalid test range given: %s" % args)
    else:
        return (int(strArgs),int(strArgs)) 

def performRun(fuzzerData, host, logger, messageProcessor, seed=-1):
    if logger != None:
        logger.resetForNewRun()
    if host == "localhost":
        host = "127.0.0.1"
    if "." in host:
        socket_family = socket.AF_INET
        addr = (host,fuzzerData.port)
    try:
        messageProcessor.preConnect(seed, host, fuzzerData.port) 
    except AttributeError:
        pass
    if fuzzerData.proto == "tcp":
        connection = socket.socket(socket_family,socket.SOCK_STREAM)
    elif fuzzerData.proto == "tls":
        try:
            _create_unverified_https_context = ssl._create_unverified_context
        except AttributeError:
            pass
        else:
            ssl._create_default_https_context = _create_unverified_https_context
        tcpConnection = socket.socket(socket_family,socket.SOCK_STREAM)
        connection = ssl.wrap_socket(tcpConnection)
    elif fuzzerData.proto == "udp":
        connection = socket.socket(socket_family,socket.SOCK_DGRAM)
    elif fuzzerData.proto in PROTO:
        connection = socket.socket(socket_family,socket.SOCK_RAW,PROTO[fuzzerData.proto]) 
        if fuzzerData.proto != "raw":
            connection.setsockopt(socket.IPPROTO_IP,socket.IP_HDRINCL,0)
        addr = (host,0)
        try:
            connection = socket.socket(socket_family,socket.SOCK_RAW,PROTO[fuzzerData.proto]) 
        except Exception as e:
            print(e)
            print("Unable to create raw socket, please verify that you have sudo access")
            sys.exit(0)
    else:
        addr = (host,0)
        try: 
            connection = socket.socket(socket_family,socket.SOCK_RAW,int(fuzzerData.proto)) 
            connection.setsockopt(socket.IPPROTO_IP,socket.IP_HDRINCL,0)
        except Exception as e:
            print(e)
            print("Unable to create raw socket, please verify that you have sudo access")
            sys.exit(0)
    if fuzzerData.proto == "tcp" or fuzzerData.proto == "udp" or fuzzerData.proto == "tls":
        if fuzzerData.sourcePort != -1:
            if fuzzerData.sourceIP != "" or fuzzerData.sourceIP != "0.0.0.0":
                connection.bind((fuzzerData.sourceIP, fuzzerData.sourcePort))
            else:
                connection.bind(('0.0.0.0', fuzzerData.sourcePort))
        elif fuzzerData.sourceIP != "" and fuzzerData.sourceIP != "0.0.0.0":
            connection.bind((fuzzerData.sourceIP, 0))
    if fuzzerData.proto == "tcp" or fuzzerData.proto == "tls":
        connection.connect(addr)
    i = 0   
    for i in range(0, len(fuzzerData.messageCollection.messages)):
        message = fuzzerData.messageCollection.messages[i]
        message.resetAlteredMessage()
        if message.isOutbound():
            doesMessageHaveSubcomponents = len(message.subcomponents) > 1
            originalSubcomponents = list(map(lambda subcomponent: subcomponent.getOriginalByteArray(), message.subcomponents))          
            if doesMessageHaveSubcomponents:
                for j in range(0, len(message.subcomponents)):
                    subcomponent = message.subcomponents[j] 
                    actualSubcomponents = list(map(lambda subcomponent: subcomponent.getAlteredByteArray(), message.subcomponents))
                    prefuzz = messageProcessor.preFuzzSubcomponentProcess(subcomponent.getAlteredByteArray(), MessageProcessorExtraParams(i, j, subcomponent.isFuzzed, originalSubcomponents, actualSubcomponents))
                    subcomponent.setAlteredByteArray(prefuzz)
            else:
                actualSubcomponents = list(map(lambda subcomponent: subcomponent.getAlteredByteArray(), message.subcomponents))
                prefuzz = messageProcessor.preFuzzProcess(actualSubcomponents[0], MessageProcessorExtraParams(i, -1, message.isFuzzed, originalSubcomponents, actualSubcomponents))
                message.subcomponents[0].setAlteredByteArray(prefuzz)
            if seed > -1:
                print("\nseed:")
                print(seed)
                for subcomponent in message.subcomponents:
                    if subcomponent.isFuzzed:
                        radamsa = subprocess.Popen([RADAMSA, "--seed", str(seed)], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                        byteArray = subcomponent.getAlteredByteArray()
                        (fuzzedByteArray, error_output) = radamsa.communicate(input=byteArray)
                        fuzzedByteArray = bytearray(fuzzedByteArray)
                        subcomponent.setAlteredByteArray(fuzzedByteArray)           
            if doesMessageHaveSubcomponents:
                for j in range(0, len(message.subcomponents)):
                    subcomponent = message.subcomponents[j] 
                    actualSubcomponents = list(map(lambda subcomponent: subcomponent.getAlteredByteArray(), message.subcomponents))
                    presend = messageProcessor.preSendSubcomponentProcess(subcomponent.getAlteredByteArray(), MessageProcessorExtraParams(i, j, subcomponent.isFuzzed, originalSubcomponents, actualSubcomponents))
                    subcomponent.setAlteredByteArray(presend)
            actualSubcomponents = list(map(lambda subcomponent: subcomponent.getAlteredByteArray(), message.subcomponents))
            byteArrayToSend = messageProcessor.preSendProcess(message.getAlteredMessage(), MessageProcessorExtraParams(i, -1, message.isFuzzed, originalSubcomponents, actualSubcomponents))
            if args.dumpraw:
                loc = os.path.join(DUMPDIR,"%d-outbound-seed-%d"%(i,args.dumpraw))
                if message.isFuzzed:
                    loc+="-fuzzed"
                with open(loc,"wb") as f:
                    f.write(repr(str(byteArrayToSend))[1:-1])
            sendPacket(connection, addr, byteArrayToSend)
        else: 
            messageByteArray = message.getAlteredMessage()
            data = receivePacket(connection,addr,len(messageByteArray))
            if data == messageByteArray:
                print("\tReceived expected response")
            if logger != None:
                logger.setReceivedMessageData(i, data)       
            messageProcessor.postReceiveProcess(data, MessageProcessorExtraParams(i, -1, False, [messageByteArray], [data]))
            if args.dumpraw:
                loc = os.path.join(DUMPDIR,"%d-inbound-seed-%d"%(i,args.dumpraw))
                with open(loc,"wb") as f:
                    f.write(repr(str(data))[1:-1])
        if logger != None:  
            logger.setHighestMessageNumber(i)
        i += 1  
    connection.close()

if len(sys.argv) < 3:
    sys.argv.append('-h')
desc =  "======== Firmking Fuzzer ==========\n" 
epi = "==" * 26 + '\n'
parser = argparse.ArgumentParser(description=desc,epilog=epi)
parser.add_argument("file_path", help="Path to xx.fu")
parser.add_argument("target_host", help="Target IP")
parser.add_argument("-s","--sleeptime",help="Time to sleep between fuzz cases (float)",type=float,default=0)
seed_constraint = parser.add_mutually_exclusive_group()
seed_constraint.add_argument("-r", "--range", help="Run only the specified cases. Acceptable arg formats: [ X | X- | X-Y ], for integers X,Y") 
seed_constraint.add_argument("-l", "--loop", help="Loop/repeat the given finite number range. Acceptible arg format: [ X | X-Y | X,Y,Z-Q,R | ...]")
seed_constraint.add_argument("-d", "--dumpraw", help="Test single seed, dump to 'dumpraw' folder",type=int)
verbosity = parser.add_mutually_exclusive_group()
verbosity.add_argument("-q", "--quiet", help="Don't log the outputs",action="store_true")
verbosity.add_argument("--log", help="Log all the outputs",action="store_true")
args = parser.parse_args()

fuzzerFilePath = args.file_path
host = args.target_host
if args.range:
    (MIN_RUN_NUMBER, MAX_RUN_NUMBER) = getRunNumbersFromArgs(args.range)
elif args.loop:
    SEED_LOOP = validateNumberRange(args.loop,True) 
if not os.path.exists(RADAMSA):
    sys.exit("Could not find radamsa in %s..." % RADAMSA)
isReproduce = False
log = False
if args.quiet:
    isReproduce = True
elif args.log:
    log = True
outputDataFolderPath = os.path.join("%s_%s" % (os.path.splitext(fuzzerFilePath)[0], "logs"), datetime.datetime.now().strftime("%Y-%m-%d,%H%M%S"))
fuzzerFolder = os.path.abspath(os.path.dirname(fuzzerFilePath))
messageProcessor = None
monitor = None
optionDict = {"unfuzzedBytes":{}, "message":[]}
fuzzerData = FuzzerData()
print("Reading in fuzzer data from %s..." % (fuzzerFilePath))
fuzzerData.readFromFile(fuzzerFilePath)
processorDirectory = fuzzerData.processorDirectory
if processorDirectory == "default":
    processorDirectory = fuzzerFolder
else:
    processorDirectory = os.path.join(fuzzerFolder, processorDirectory)
procDirector = ProcDirector(processorDirectory)
monitor = procDirector.startMonitor(host,fuzzerData.port)
logger = None 
if not isReproduce:
    print("Logging to %s" % (outputDataFolderPath))
    logger = Logger(outputDataFolderPath)
if args.dumpraw:
    if not isReproduce:
        DUMPDIR = outputDataFolderPath
    else:
        DUMPDIR = "dumpraw"
        try:
            os.mkdir("dumpraw")
        except:
            print("Unable to create dumpraw dir")
            pass

exceptionProcessor = procDirector.exceptionProcessor()
messageProcessor = procDirector.messageProcessor()
i = MIN_RUN_NUMBER-1 if fuzzerData.shouldPerformTestRun else MIN_RUN_NUMBER
failureCount = 0
loop_len = len(SEED_LOOP)

while True:
    lastMessageCollection = deepcopy(fuzzerData.messageCollection)
    wasCrashDetected = False
    print("\n** Sleeping for %.3f seconds **" % args.sleeptime)
    time.sleep(args.sleeptime) 
    try:
        try:
            if args.dumpraw:
                print("\n\nPerforming single raw dump case: %d" % args.dumpraw)
                performRun(fuzzerData, host, logger, messageProcessor, seed=args.dumpraw)  
            elif i == MIN_RUN_NUMBER-1:
                print("\n\nPerforming test run without fuzzing...")
                performRun(fuzzerData, host, logger, messageProcessor, seed=-1) 
            elif loop_len: 
                print("\n\nFuzzing with seed %d" % (SEED_LOOP[i%loop_len]))
                performRun(fuzzerData, host, logger, messageProcessor, seed=SEED_LOOP[i%loop_len]) 
            else:
                print("\n\nFuzzing with seed %d" % (i))
                performRun(fuzzerData, host, logger, messageProcessor, seed=i) 
            if log:
                try:
                    logger.outputLog(i, fuzzerData.messageCollection, "log ")
                except AttributeError:
                    pass               
        except Exception as e:
            if monitor.crashEvent.isSet():
                print("Crash event detected")
                try:
                    logger.outputLog(i, fuzzerData.messageCollection, "Crash event detected")
                except AttributeError: 
                    pass
                monitor.crashEvent.clear()
            elif log:
                try:
                    logger.outputLog(i, fuzzerData.messageCollection, "log ")
                except AttributeError:
                    pass
            if e.__class__ in MessageProcessorExceptions.all:
                raise e
            else:
                exceptionProcessor.processException(e)
                print("Exception ignored: %s" % (str(e)))
    except LogCrashException as e:
        if failureCount == 0:
            try:
                print("MessageProcessor detected a crash")
                logger.outputLog(i, fuzzerData.messageCollection, str(e))
            except AttributeError:  
                pass   
        if log:
            try:
                logger.outputLog(i, fuzzerData.messageCollection, "log ")
            except AttributeError:
                pass
        failureCount = failureCount + 1
        wasCrashDetected = True
    except AbortCurrentRunException as e:
        print("Run aborted: %s" % (str(e)))   
    except RetryCurrentRunException as e:
        print("Retrying current run: %s" % (str(e)))
        continue       
    except LogAndHaltException as e:
        if logger:
            logger.outputLog(i, fuzzerData.messageCollection, str(e))
            print("Received LogAndHaltException, logging and halting")
        else:
            print("Received LogAndHaltException, halting but not logging (quiet mode)")
        exit()       
    except LogLastAndHaltException as e:
        if logger:
            if i > MIN_RUN_NUMBER:
                print("Received LogLastAndHaltException, logging last run and halting")
                if MIN_RUN_NUMBER == MAX_RUN_NUMBER:
                    logger.outputLastLog(i, lastMessageCollection, str(e))
                    print("Logged case %d" % i)
                else:
                    logger.outputLastLog(i-1, lastMessageCollection, str(e))
            else:
                print("Received LogLastAndHaltException, skipping logging (due to last run being a test run) and halting")
        else:
            print("Received LogLastAndHaltException, halting but not logging (quiet mode)")
        exit()
    except HaltException as e:
        print("Received HaltException halting")
        exit()
    if wasCrashDetected:
        if failureCount < fuzzerData.failureThreshold:
            print("Failure %d of %d allowed for seed %d" % (failureCount, fuzzerData.failureThreshold, i))
            print("The test run didn't complete, continuing after %d seconds..." % (fuzzerData.failureTimeout))
            time.sleep(fuzzerData.failureTimeout)
        else:
            print("Failed %d times, moving to next test." % (failureCount))
            failureCount = 0
            i += 1
    else:
        i += 1
    if MAX_RUN_NUMBER >= 0 and i > MAX_RUN_NUMBER:
        exit()
    if args.dumpraw:
        exit()
