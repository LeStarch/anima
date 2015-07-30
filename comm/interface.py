import datetime
import os

import anima.comm.utils
import anima.logging.utils
'''
A communications object based on py-zmq

@author: starchmd
'''
class Communication(object):
    def __init__(self,pid=os.getpid()):
        '''
        Construct the communication interface
        '''
        self.pid = pid
        self.log = anima.logging.utils.logger(self)
        self.publisher = anima.comm.utils.connection(self.pid)
        self.state = self.getState()
    def send(self,message,channel=anima.comm.utils.channel()):
        '''
        Send a message on a given channel
        @param message - message to send
        @param channel - (optional) communication channel
        '''
        stamp = datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%S.%f")
        msg="{0}{1}|{2}".format(channel,stamp,message)
        self.log.info("Sending message: '{0}'".format(msg))
        self.publisher.send_string(msg)        
    def recv(self,pid=None,channel=anima.comm.utils.channel()):
        '''
        Receive a message on a given channel
        @param channel - (optional) name of the channel to receive
        '''
        if not channel in self.state["bindings"]:
            self.state["bindings"][channel] =  anima.comm.utils.binding(channel,pid=)
        return self.state["bindings"][channel].recv_string().split("|")[1]
    def getState(self):
        '''
        Gets the current state
        '''
        return {"bindings":{}}