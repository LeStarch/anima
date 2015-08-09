import threading

import zmq

import anima.comm.utils
import anima.comm.exceptions
'''
A subscriber object which receives data from a set of channels. In this way, one 
subscriber can be used to grab multiple data streams (if desired). This subscriber is
intended to subscribe to data from a network of publishers posting data, and has been
designed with that in mind. Command grabbing is implemented using a different protocol,
results in grabbing commands using this system are not guaranteed.

Channel is used to differentiate different sets of data but in reality is merely a
filter. It should be noted that messages are not sent until they have a matching 
subscriber on that channel. (This is backing library specific, but desired behavior).

Subscribers pull from multiple channels and therefore multiple IPC sockets (if running in 
local mode) or (TODO: one proxy socket if running in network mode) Subscribers CANNOT be 
passed between threads.

This class is implemented for use with the pyzmq library, however; the interface
should support other libraries technologies etc.

@author: starchmd
'''
log = anima.logging.utils.logger(__name__)
class Subscriber(object):
    '''
    A class used to subscribe to data publishers on a given set of channels.
    '''
    def __init__(self,channels=None,network=None):
        '''
        Optionally connect to a communication network and (optionally) subscribe 
        to a set of channels
        @param network - (optional) network to connect to
        @param channels - (optional) channels on which to receive messages
        '''
        self.thread = threading.current_thread().ident
        context = anima.comm.utils.getContextSingleton()
        self.socket = context.socket(zmq.SUB)
        channels = [] if channels is None else channels
        self.chans = set(channels)
        for chan in self.chans:
            self.socket.setsockopt_string(zmq.SUBSCRIBE,chan)
        self.sub(network)
    def recv(self,noblock=False):
        '''
        Receive a message from any of the current set of channels used by this
        subscriber. Optionally, don't block if no message is available returning
        None.
        @param noblock - (optional) don't block if no message available
        @return returns the message, or None if not-blocking and message unavailable
        @throws CommunicationException thrown on communication error
        @throws ThreadingException thrown if used on non-creation thread
        '''
        anima.comm.utils.checkThread(self.thread)
        #Note: receive is currently set to copy. If not efficient enough, change this.
        try:
            addr,msg = [item.decode() for item in self.socket.recv_multipart(zmq.NOBLOCK if noblock else 0)]
            log.debug("Received message \""+str(msg)+"\" on channel \""+str(addr)+"\"")
        except zmq.ZMQError as e:
            if noblock:
                log.info("Failed to receive message while not blocking")
                return None
            log.warning("Failed to receive message while blocking")
            raise anima.comm.exceptions.CommunicationException("Receive error",e)
        return msg
    def channels(self,channels=None):
        '''
        Returns old channels and optionally resets active channels to supplied list.
        @param channels - (optional) channels to receive on or None to keep the same
        @return current channel set
        @throws ThreadingException if used on non-creation thread
        '''
        anima.comm.utils.checkThread(self.thread)
        ret = list(self.chans)
        if not channels is None:
            self.chans = set(channels)
            for chan in ret:
                self.socket.setsockopt_string(zmq.UNSUBSCRIBE,chan)
            for chan in self.chans:
                self.socket.setsockopt_string(zmq.SUBSCRIBE,chan)
        return ret
    def add(self,channel):
        '''
        Adds a channel to receive on.
        @param channel - channel to add to channel set
        @throws ThreadingException thrown if used on non-creation thread
        '''
        anima.comm.utils.checkThread(self.thread)
        self.chans.add(channel)
        self.socket.setsockopt_string(zmq.SUBSCRIBE,channel)
    def rm(self,channel):
        '''
        Removes a channel from receiving on.
        @param channel - channel to remove
        @throws ThreadingException thrown if used on non-creation thread
        '''
        anima.comm.utils.checkThread(self.thread)
        self.chans.remove(channel)
        self.socket.setsockopt_string(zmq.UNSUBSCRIBE,channel)
    def sub(self,network=None):
        '''
        Attempts to subscribe to proxy on network and then locally
        as a fall-back or if network is unspecified.
        
        * This method is intended to be private within this class*
        
        @param network - (optional) network to subscribe to or None
        @throws CommunicationException thrown on error
        @throws ThreadingException thrown if used on non-creation thread
        '''
        anima.comm.utils.checkThread(self.thread)
        try:
            if not network is None:
                self.proxy(network)
                log.info("Connected to network proxy at: "+str(network))
                return
        except anima.comm.exceptions.CommunicationException as e:
            log.warning("Failed to connect to network proxy at:"+str(network)+" with error: "+str(e))
        
        self.local()
        log.info("Connected to local sockets")
    #@private
    def local(self):
        '''
        Subscribes directly to local sockets for the "publisher" zmq type

        * This method is intended to be private within this class*
        
        @throws CommunicationException thrown on error
        @throws ThreadingException thrown if used on non-creation thread
        '''
        anima.comm.utils.checkThread(self.thread)
        try:
            for sock in anima.comm.utils.getIPCNamesByType(zmq.PUB):
                self.socket.connect(sock)
        except IOError as e:
            log.warning("Error connecting to local sockets"+str(e))
            raise anima.comm.exceptions.CommunicationException("Unable to subscribe to local sockets",e)
    #@private
    def proxy(self,network):
        '''
        Subscribes to a network proxy.
        
        * This method is intended to be private within this class*
        
        @param network - network to subscribe to
        @throws CommunicationException thrown on error
        @throws ThreadingException thrown if used on non-creation thread
        '''
        anima.comm.utils.checkThread(self.thread)
        try:
            self.socket.connect(network)
        except zmq.ZMQError as e:
            log.warning("Error ")
            raise anima.comm.exceptions.CommunicationException("Unable to subscribe to proxy")