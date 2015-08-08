'''
Communication exception

@author starchmd
'''
class CommunicationException(Exception):
    def __init__(self,message,error):
        '''
        Creates an exception
        @param message - message for this exception
        @param error - error that caused this exception
        '''
        self.message = message
        self.error = error