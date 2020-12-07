from kingcore.fuzzer_types import MessageCollection, Message
from kingcore.menu_functions import validateNumberRange
import os.path
import sys

class FuzzerData(object):
    def __init__(self):
        self.messageCollection = MessageCollection()
        self.processorDirectory = "default"
        self.failureThreshold = 3
        self.failureTimeout = 5
        self.proto = "tcp"
        self.port = 0
        self.sourcePort = -1
        self.sourceIP = "0.0.0.0"
        self.shouldPerformTestRun = True
        self.receiveTimeout = 1.0
        self.comments = {}
        self._readComments = ""
        self.messagesToFuzz = [] 
    
    def readFromFile(self, filePath, quiet=False):
        with open(filePath, 'r') as inputFile:
            self.readFromFD(inputFile, quiet=quiet)
    
    def _pushComments(self, commentSectionName):
        self.comments[commentSectionName] = self._readComments
        self._readComments = ""

    def _appendComments(self, commentSectionName):
        if commentSectionName in self.comments:
            self.comments[commentSectionName] += self._readComments
        else:
            self.comments[commentSectionName] = self._readComments
        self._readComments = ""


    def readFromFD(self, fileDescriptor, quiet=False):
        messageNum = 0
        
        self._readComments = ""
        
        for line in fileDescriptor:
            if line.startswith("#") or line == "\n":
                self._readComments += line
                continue
            
            line = line.replace("\n", "")

            if not line.startswith("#") and not line == "" and not line.isspace():
                args = line.split(" ")
                
                try:
                    if args[0] == "processor_dir":
                        self.processorDirectory = args[1]
                        self._pushComments("processor_dir")
                    elif args[0] == "failureThreshold":
                        self.failureThreshold = int(args[1])
                        self._pushComments("failureThreshold")
                    elif args[0] == "failureTimeout":
                        self.failureTimeout = int(args[1])
                        self._pushComments("failureTimeout")
                    elif args[0] == "proto":
                        self.proto = args[1]
                        self._pushComments("proto")
                    elif args[0] == "port":
                        self.port = int(args[1])
                        self._pushComments("port")
                    elif args[0] == "sourcePort":
                        self.sourcePort = int(args[1])
                        self._pushComments("sourcePort")
                    elif args[0] == "sourceIP":
                        self.sourceIP = args[1]
                        self._pushComments("sourceIP")
                    elif args[0] == "shouldPerformTestRun":
                        if args[1] == "0":
                            self.shouldPerformTestRun = False
                        elif args[1] == "1":
                            self.shouldPerformTestRun = True
                        else:
                            raise RuntimeError("shouldPerformTestRun must be 0 or 1")
                        self._pushComments("shouldPerformTestRun")
                    elif args[0] == "receiveTimeout":
                        self.receiveTimeout = float(args[1])
                        self._pushComments("receiveTimeout")
                    elif args[0] == "messagesToFuzz":
                        print("WARNING: It looks like you're using a legacy .fu file with messagesToFuzz set.  This is now deprecated, so please update to the new format")
                        self.messagesToFuzz = validateNumberRange(args[1], flattenList=True)
                        self._pushComments("message0")
                    elif args[0] == "unfuzzedBytes":
                        print("ERROR: It looks like you're using a legacy .fu file with unfuzzedBytes set.  This has been replaced by the new multi-line format.  Please update your .fu file.")
                        sys.exit(-1)
                    elif args[0] == "inbound" or args[0] == "outbound":
                        message = Message()
                        message.setFromSerialized(line)
                        self.messageCollection.addMessage(message)
                        if messageNum in self.messagesToFuzz:
                            message.isFuzzed = True
                        if not quiet:
                            print("\tMessage #{0}: {1} bytes {2}".format(messageNum, len(message.getOriginalMessage()), message.direction))
                        self._pushComments("message{0}".format(messageNum))
                        messageNum += 1
                        lastMessage = message
                    elif args[0] == "sub":
                        if not 'message' in locals():
                            print("\tERROR: 'sub' line declared before any 'message' lines, throwing subcomponent out: {0}".format(line))
                        else:
                            message.appendFromSerialized(line)
                            if not quiet:
                                print("\t\tSubcomponent: {1} additional bytes".format(messageNum, len(message.subcomponents[-1].message)))
                    elif line.lstrip()[0] == "'" and 'message' in locals():
                        message.appendFromSerialized(line.lstrip(), createNewSubcomponent=False)
                    else:
                        if not quiet:
                            print("Unknown setting in .fu file: {0}".format(args[0]))
                    self._appendComments("message{0}".format(messageNum-1))
                except Exception as e:
                    print("Invalid line: {0}".format(line))
                    raise e
        self._pushComments("endcomments")
                        

    def _getComments(self, commentSectionName):
        if commentSectionName in self.comments:
            return self.comments[commentSectionName]
        else:
            return ""

    def setMessagesToFuzzFromString(self, messagesToFuzzStr):
        self.messagesToFuzz = validateNumberRange(messagesToFuzzStr, flattenList=True)

    def writeToFile(self, filePath, defaultComments=False, finalMessageNum=-1):
        origFilePath = filePath
        tail = 0
        while os.path.isfile(filePath):
            tail += 1
            filePath = "{0}-{1}".format(origFilePath, tail)
            print("File %s already exists" % (filePath,))
        
        if origFilePath != filePath:
            print("File {0} already exists, using {1} instead".format(origFilePath, filePath))

        with open(filePath, 'w') as outputFile:
            self.writeToFD(outputFile, defaultComments=defaultComments, finalMessageNum=finalMessageNum)
        
        return filePath

    def writeToFD(self, fileDescriptor, defaultComments=False, finalMessageNum=-1):
        if not defaultComments and "start" in self.comments:
            fileDescriptor.write(self.comments["start"])
        
        if defaultComments:
            comment = "# Directory containing any custom exception/message/monitor processors\n"
            comment += "# This should be either an absolute path or relative to the .fu file\n"
            comment += "# If set to \"default\", Mutiny will use any processors in the same\n"
            comment += "# folder as the .fu file\n"
            fileDescriptor.write(comment)
        else:
            fileDescriptor.write(self._getComments("processor_dir"))
        fileDescriptor.write("processor_dir {0}\n".format(self.processorDirectory))
        
        if defaultComments:
            fileDescriptor.write("# Number of times to retry a test case causing a crash\n")
        else:
            fileDescriptor.write(self._getComments("failure_threshold"))
        fileDescriptor.write("failureThreshold {0}\n".format(self.failureThreshold))
        
        if defaultComments:
            fileDescriptor.write("# How long to wait between retrying test cases causing a crash\n")
        else:
            fileDescriptor.write(self._getComments("failureTimeout"))
        fileDescriptor.write("failureTimeout {0}\n".format(self.failureTimeout))
        
        if defaultComments:
            fileDescriptor.write("# How long for recv() to block when waiting on data from server\n")
        else:
            fileDescriptor.write(self._getComments("receiveTimeout"))
        fileDescriptor.write("receiveTimeout {0}\n".format(self.receiveTimeout))
        
        if defaultComments:
            fileDescriptor.write("# Whether to perform an unfuzzed test run before fuzzing\n")
        else:
            fileDescriptor.write(self._getComments("shouldPerformTestRun"))
        sPTR = 1 if self.shouldPerformTestRun else 0
        fileDescriptor.write("shouldPerformTestRun {0}\n".format(sPTR))
        
        if defaultComments:
            fileDescriptor.write("# Protocol (udp or tcp)\n")
        else:
            fileDescriptor.write(self._getComments("proto"))
        fileDescriptor.write("proto {0}\n".format(self.proto))
        
        if defaultComments:
            fileDescriptor.write("# Port number to connect to\n")
        else:
            fileDescriptor.write(self._getComments("port"))
        fileDescriptor.write("port {0}\n".format(self.port))
        
        if defaultComments:
            fileDescriptor.write("# Port number to connect from\n")
        else:
            fileDescriptor.write(self._getComments("sourcePort"))
        fileDescriptor.write("sourcePort {0}\n".format(self.sourcePort))

        if defaultComments:
            fileDescriptor.write("# Source IP to connect from\n")
        else:
            fileDescriptor.write(self._getComments("sourceIP"))
        fileDescriptor.write("sourceIP {0}\n\n".format(self.sourceIP))

        if finalMessageNum == -1:
            finalMessageNum = len(self.messageCollection.messages)-1
        if defaultComments:
            fileDescriptor.write("# The actual messages in the conversation\n# Each contains a message to be sent to or from the server, printably-formatted\n")
        for i in range(0, finalMessageNum+1):
            message = self.messageCollection.messages[i]
            if not defaultComments:
                fileDescriptor.write(self._getComments("message{0}".format(i)))
            fileDescriptor.write(message.getSerialized())
              
        if not defaultComments:
            fileDescriptor.write(self._getComments("endcomments"))
