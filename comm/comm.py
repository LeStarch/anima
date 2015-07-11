'''
A communications object based on py-zmq

@author: starchmd
'''

class Comm(object):
    '''
    Communications
    '''
    def __init__(self):
        '''
        Constructor
        '''
        
        pass
    def send(self,channel="biaozhun"):
        '''
        Send a message on a given channel
        @param channel - (optional) communication channel
        '''
        
        
    def setup(self,channel):
        '''
        Setup a channel with both external and internal queues
        @param channel - name of channel to create
        '''
        