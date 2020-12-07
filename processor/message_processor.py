import errno
import socket
from processor.exceptions import *

class MessageProcessorExtraParams(object):
    def __init__(self, messageNumber, subcomponentNumber, isFuzzed, originalSubcomponents, actualSubcomponents):
        self.messageNumber = messageNumber
        self.subcomponentNumber = subcomponentNumber
        self.isFuzzed = isFuzzed
        self.originalSubcomponents = originalSubcomponents
        self.actualSubcomponents = actualSubcomponents
        self.originalMessage = bytearray().join(self.originalSubcomponents)
        self.actualMessage = bytearray().join(self.actualSubcomponents)

class MessageProcessor(object):
    def __init__(self):
        self.postReceiveStore = {}
    
    def preConnect(self, runNumber, targetIP, targetPort):
        pass
    
    def preFuzzSubcomponentProcess(self, subcomponent, extraParams):
        return subcomponent
    
    def preFuzzProcess(self, message, extraParams):
        return message

    def preSendSubcomponentProcess(self, subcomponent, extraParams):
        return subcomponent
    
    def preSendProcess(self, message, extraParams):
        return message

    def postReceiveProcess(self, message, extraParams):
        self.postReceiveStore[int(extraParams.messageNumber)] = message
