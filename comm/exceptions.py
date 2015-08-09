'''
Exceptions for the communication class

@author starchmd
'''
class CommunicationException(Exception):
    '''
    An exception thrown when something when wrong when communicating.
    '''
    def __init__(self,message,error):
        '''
        Creates an exception
        @param message - message for this exception
        @param error - error that caused this exception
        '''
        self.message = message
        self.error = error

class ThreadingException(Exception):
    '''
    An exception thrown when a thread-specific object is used in a
    thread different from its creation.
    '''
    def __init__(self,message,error):
        '''
        Creates an exception
        @param message - message for this exception
        '''
        self.message = message