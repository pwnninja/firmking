class Monitor(object):
    def monitorTarget(self, targetIP, targetPort, signalMain):
        # Can do something like:
        # while True:
        #   read file, etc
        #   if errorConditionHasOccurred:
        #       signalMain()
        #
        # Calling signalMain() at any time will indicate to Mutiny
        # that the target has crashed and a crash should be logged
        pass
