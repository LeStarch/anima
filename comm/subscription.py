import os


import zmq

import anima.comm.utils
import anima.comm.exceptions
'''
A subscriber object which subscribes to data.

This class is implemented for use with the pyzmq library, however; the interface
should support other libraries technologies etc.

@author: starchmd
'''
log = anima.logging.utils.logger(__name__)
class Subscribe(object):
    def __init__(self,network,channel=None):
        '''
        Connect to a communication network
        @param network - network to connect to
        @param channel - channel on which to receive messages
        '''
        context = anima.comm.utils.getContextSingleton()
        socket = context.socket(zmq.SUB)
        if not channel is None:
            socket.setsockopt(zmq.SUBSCRIBE,channel)
        self.sub
        
    def recv(self,noblock=False):
        '''
        Receive a message from this subscriber
        @param noblock - (optional) don't block n this socket
        '''
        #Note: receive is currently set to copy. If not efficient enough, change this.
        try:
            msg = self.socket.recv(zmq.NOBLOCK if noblock else 0)
        except zmq.ZMQError as e:
            return None
        return msg
    def channel(self,channel=None):
        '''
        Returns old channel and optionally resets channel
        @param channel - (optional) channel to to filter by or None
        '''
        ret = socket.getsockopt(zmq.SUBSCRIBE)
        if not channel is None:
            socket.setsockopt(zmq.SUBSCRIBE,channel)
        return ret
    @private
    def sub(self,network):
        '''
        Attempts to subscribe to proxy on network and then locally
        @param network - (optional) network to subscribe to or None
        '''
        try:
            if not network is None:
                self.proxy(network)
                log.info("Connected to network proxy at: "+str(network))
                return
        except anima.comm.exceptions.CommunicationException as e:
            log.warning("Failed to connect to network proxy at:"+str(network)+" with error: "+str(e))
        
        self.local()
        log.info("Connected to local sockets")
    @private
    def local(self):
        '''
        Subscribes directly to local sockets 
        @throws exception on error
        '''
        try:
            socks = [os.path.join(anima.comm.utils.IPC_PATH,listing) for listing in os.listdir(anima.comm.utils.IPC_PATH)]
            for sock in socks:
                self.socket.connect("ipc:"+sock)
        except IOError as e:
            log.warning("Error connecting to local sockets"+str(e))
            raise anima.comm.exceptions.CommunicationException("Unable to subscribe to local sockets",e)
    @private
    def proxy(self,network):
        '''
        Subscribes to a network proxy
        @param network - network to connect to
        @throws exception on error
        '''
        try:
            self.socket.connect(network)
        except zmq.ZMQError as e:
            log.warning("Error ")
            raise anima.comm.exceptions.CommunicationException("Unable to subscribe to proxy")