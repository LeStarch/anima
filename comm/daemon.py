'''
A daemon for controlling communications on a local host

@author: starchmd
'''
import anima.comm.anima.comm.constants

class CommDaemon(object):
    def __init__(self):
        '''
        Constructs this daemon
        '''
        self.state = self.getState()
    
        
        
    def getState(self):
        '''
        Generates the latest state (by communicating with other daemons) or 
        generates a blank state.
        '''
        state = {"channels":{}}
        return state
    def getHosts(self):
        '''
        
        '''
        pass