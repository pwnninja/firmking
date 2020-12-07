import codecs
import os
import os.path
from copy import deepcopy

class MessageSubComponent(object):
    def __init__(self, message, isFuzzed):
        self.message = message
        self.isFuzzed = isFuzzed
        self._altered = message
    
    def setAlteredByteArray(self, byteArray):
        self._altered = byteArray
    
    def getAlteredByteArray(self):
        return self._altered
    
    def getOriginalByteArray(self):
        return self.message
         
class Message(object):
    class Direction:
        Outbound = "outbound"
        Inbound = "inbound"
    
    class Format:
        CommaSeparatedHex = 0 # 00,01,02,20,2a,30,31
        Ascii = 1 # asdf\x00\x01\x02
        Raw = 2 # a raw byte array from a pcap
        
    def __init__(self):
        self.direction = -1
        self.isFuzzed = False
        self.subcomponents = []

    def getOriginalSubcomponents(self):
        return map(lambda subcomponent: subcomponent.message, self.subcomponents)
    
    def getAlteredSubcomponents(self):
        return map(lambda subcomponent: subcomponent.getAlteredByteArray(), self.subcomponents)
    
    def getOriginalMessage(self):
        return bytearray().join(map(lambda subcomponent: subcomponent.message, self.subcomponents))
    
    def getAlteredMessage(self):
        return bytearray().join(map(lambda subcomponent: subcomponent.getAlteredByteArray(), self.subcomponents))
    
    def resetAlteredMessage(self):
        for subcomponent in self.subcomponents:
            subcomponent.setAlteredByteArray(subcomponent.message)
    
    def setMessageFrom(self, sourceType, message, isFuzzed):
        if sourceType == self.Format.CommaSeparatedHex:
            message = bytearray(map(lambda x: x.decode("hex"), message.split(",")))
        elif sourceType == self.Format.Ascii:
            message = self.deserializeByteArray(message)
        elif sourceType == self.Format.Raw:
            message = message
        else:
            raise RuntimeError("Invalid sourceType")
        
        self.subcomponents = [MessageSubComponent(message, isFuzzed)]
        
        if isFuzzed:
            self.isFuzzed = True
    
    def appendMessageFrom(self, sourceType, message, isFuzzed, createNewSubcomponent=True):
        if sourceType == self.Format.CommaSeparatedHex:
            newMessage = bytearray(map(lambda x: x.decode("hex"), message.split(",")))
        elif sourceType == self.Format.Ascii:
            newMessage = self.deserializeByteArray(message)
        elif sourceType == self.Format.Raw:
            newMessage = message
        else:
            raise RuntimeError("Invalid sourceType")
        
        if createNewSubcomponent:
            self.subcomponents.append(MessageSubComponent(newMessage, isFuzzed))
        else:
            self.subcomponents[-1].message += newMessage

        if isFuzzed:
            self.isFuzzed = True
    
    def isOutbound(self):
        return self.direction == self.Direction.Outbound
    
    def __eq__(self, other):
        return self.direction == other.direction and self.message == other.message 

    @classmethod
    def serializeByteArray(cls, byteArray):
        return repr(str(byteArray))

    def deserializeByteArray(cls, string):
        return bytearray(codecs.escape_decode(string[1:-1])[0])

    def getAlteredSerialized(self):
        if len(self.subcomponents) < 1:
            return "{0} {1}\n".format(self.direction, "ERROR: No data in message.")
        else:
            serializedMessage = "{0}{1} {2}\n".format("fuzz " if self.subcomponents[0].isFuzzed else "", self.direction, self.serializeByteArray(self.subcomponents[0].getAlteredByteArray()))
            
            for subcomponent in self.subcomponents[1:]:
                serializedMessage += "sub {0}{1}\n".format("fuzz " if subcomponent.isFuzzed else "", self.serializeByteArray(subcomponent.getAlteredByteArray()))
            
            return serializedMessage
    
    def getSerialized(self):
        if len(self.subcomponents) < 1:
            return "{0} {1}\n".format(self.direction, "ERROR: No data in message.")
        else:
            serializedMessage = "{0} {1}{2}\n".format(self.direction, "fuzz " if self.subcomponents[0].isFuzzed else "", self.serializeByteArray(self.subcomponents[0].message))
            
            for subcomponent in self.subcomponents[1:]:
                serializedMessage += "sub {0}{1}\n".format("fuzz " if subcomponent.isFuzzed else "", self.serializeByteArray(subcomponent.message))
            
            return serializedMessage

    def _extractMessageComponents(self, serializedData):
        firstQuoteSingle = serializedData.find('\'')
        lastQuoteSingle = serializedData.rfind('\'')
        firstQuoteDouble = serializedData.find('"')
        lastQuoteDouble = serializedData.rfind('"')
        firstQuote = -1
        lastQuote = -1
        
        if firstQuoteSingle == -1 or firstQuoteSingle == lastQuoteSingle:
            firstQuote = firstQuoteDouble
            lastQuote = lastQuoteDouble
        elif firstQuoteDouble == -1 or firstQuoteDouble == lastQuoteDouble:
            firstQuote = firstQuoteSingle
            lastQuote = lastQuoteSingle
        elif firstQuoteSingle < firstQuoteDouble:
            firstQuote = firstQuoteSingle
            lastQuote = lastQuoteSingle
        else:
            firstQuote = firstQuoteDouble
            lastQuote = lastQuoteDouble
        
        if firstQuote == -1 or lastQuote == -1 or firstQuote == lastQuote:
            raise RuntimeError("Invalid message data, no message found")

        messageData = serializedData[firstQuote:lastQuote+1]
        serializedData = serializedData[:firstQuote].split(" ")
        
        return (serializedData, messageData)
   
    def setFromSerialized(self, serializedData):
        serializedData = serializedData.replace("\n", "")
        (serializedData, messageData) = self._extractMessageComponents(serializedData)
        
        if len(messageData) == 0 or len(serializedData) < 1:
            raise RuntimeError("Invalid message data")
        
        direction = serializedData[0]
        args = serializedData[1:-1]
        
        if direction != "inbound" and direction != "outbound":
            raise RuntimeError("Invalid message data, unknown direction {0}".format(direction))
        
        isFuzzed = False
        if "fuzz" in args:
            isFuzzed = True
            if len(serializedData) < 3:
                raise RuntimeError("Invalid message data")
        
        self.direction = direction
        self.setMessageFrom(self.Format.Ascii, messageData, isFuzzed)
    
    def appendFromSerialized(self, serializedData, createNewSubcomponent=True):
        serializedData = serializedData.replace("\n", "")
        (serializedData, messageData) = self._extractMessageComponents(serializedData)
        
        if createNewSubcomponent:
            if len(messageData) == 0 or len(serializedData) < 1 or serializedData[0] != "sub":
                raise RuntimeError("Invalid message data")
        else:
            if len(messageData) == 0:
                raise RuntimeError("Invalid message data")
        
        args = serializedData[1:-1]
        
        isFuzzed = False
        if "fuzz" in args:
            isFuzzed = True
        
        self.appendMessageFrom(self.Format.Ascii, messageData, isFuzzed, createNewSubcomponent=createNewSubcomponent)

class MessageCollection(object):
    def __init__(self):
        self.messages = []
    
    def addMessage(self, message):
        self.messages.append(message)
    
    def doClientMessagesMatch(self, otherMessageCollection):
        for i in range(0, len(self.messages)):
            if not self.messages[i].isOutbound():
                continue
            try:
                if self.messages[i] != otherMessageCollection.messages[i]:
                    return False
            except IndexError:
                return False
        
        return True


class Logger(object):
    def __init__(self, folderPath):
        self._folderPath = folderPath
        if os.path.exists(folderPath):
            print("Data output directory already exists: %s" % (folderPath))
            exit()
        else:
            try:
                os.makedirs(folderPath)
            except:
                print("Unable to create logging directory: %s" % (folderPath))
                exit()

        self.resetForNewRun()

    def setReceivedMessageData(self, messageNumber, data):
        self.receivedMessageData[messageNumber] = data

    def setHighestMessageNumber(self, messageNumber):
        self._highestMessageNumber = messageNumber

    def outputLastLog(self, runNumber, messageCollection, errorMessage):
        return self._outputLog(runNumber, messageCollection, errorMessage, self._lastReceivedMessageData, self._lastHighestMessageNumber)

    def outputLog(self, runNumber, messageCollection, errorMessage):
        return self._outputLog(runNumber, messageCollection, errorMessage, self.receivedMessageData, self._highestMessageNumber)

    def _outputLog(self, runNumber, messageCollection, errorMessage, receivedMessageData, highestMessageNumber):
        with open(os.path.join(self._folderPath, str(runNumber)), "w") as outputFile:
            print("Logging run number %d" % (runNumber))
            outputFile.write("Log from run with seed %d\n" % (runNumber))
            outputFile.write("Error message: %s\n" % (errorMessage))

            if highestMessageNumber == -1 or runNumber == 0:
                outputFile.write("Failed to connect on this run.\n")
               
            if(errorMessage == "Connection refused: Assuming we crashed the server, logging previous run and halting"):
                with open(os.path.join(self._folderPath, "ConnectionRefused.txt"), "w") as outputFile2:
                    outputFile2.write("Connection refused: Assuming we crashed the server, logging previous run and halting: " + str(runNumber) + "\n")	

            outputFile.write("\n")

            i = 0
            for message in messageCollection.messages:
                outputFile.write("Packet %d: %s" % (i, message.getSerialized()))

                if message.isFuzzed:
                    outputFile.write("Fuzzed Packet %d: %s\n" % (i, message.getAlteredSerialized()))
                
                if receivedMessageData.has_key(i):
                    if receivedMessageData[i] != message.getOriginalMessage():
                        outputFile.write("Actual data received for packet %d: %s" % (i, Message.serializeByteArray(receivedMessageData[i])))
                    else:
                        outputFile.write("Received expected data\n")

                if highestMessageNumber == i:
                    if message.isOutbound():
                        outputFile.write("This is the last message sent\n")
                    else:
                        outputFile.write("This is the last message received\n")

                outputFile.write("\n")
                i += 1

    def resetForNewRun(self):
        try:
            self._lastReceivedMessageData = deepcopy(self.receivedMessageData)
            self._lastHighestMessageNumber = self._highestMessageNumber
        except AttributeError:
            self._lastReceivedMessageData = {}
            self._lastHighestMessageNumber = -1

        self.receivedMessageData = {}
        self.setHighestMessageNumber(-1)
