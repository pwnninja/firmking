class LogCrashException(Exception):
    pass

class AbortCurrentRunException(Exception):
    pass

class RetryCurrentRunException(Exception):
    pass

class LogAndHaltException(Exception):
    pass

class LogLastAndHaltException(Exception):
    pass

class HaltException(Exception):
    pass

class MessageProcessorExceptions(object):
    all = [LogCrashException, AbortCurrentRunException, RetryCurrentRunException, LogAndHaltException, LogLastAndHaltException, HaltException]

class ConnectionClosedException(Exception):
    pass

