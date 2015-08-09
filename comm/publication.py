import threading

import zmq

import anima.comm.utils
import anima.comm.exceptions
'''
A publisher object which publishes data to a single channel. This publisher is
intended to publish data to a network of subscribers looking to read that data, and
has been designed with that in mind. Command passing is implemented using a different
protocol, results in passing commands using this system are not guaranteed.

Channel is used to differentiate different sets of data but in reality is merely a
filter. It should be noted that messages are not sent until they have a matching 
subscriber on that channel. (This is backing library specific, but desired behavior).

Publishers can only sent on one channel at a time, and are backed by exactly one local
IPC socket. Publishers CANNOT be passed between threads.

This class is implemented for use with the pyzmq library, however; the interface
should support other libraries technologies etc.

@author: starchmd
'''
log = anima.logging.utils.logger(__name__)
class Publisher(object):
    '''
    A class representing an object that is used to publish data on a given channel.
    '''
    def __init__(self,channel,network=None):
        '''
        Connect to a communication network on a given channel.
        @param network - network to connect to
        @param channel - channel on which to send messages
        '''
        self.thread = threading.current_thread().ident
        context = anima.comm.utils.getContextSingleton()
        self.socket = context.socket(zmq.PUB)
        self.chan = channel
        name = anima.comm.utils.getIPCName(zmq.PUB)
        log.info("Binding to "+name)
        self.socket.bind(name)
    def send(self,message):
        '''
        Send a message from this publisher
        @param message - message to send
        @throws CommunicationException on error
        @throws ThreadingException if used on non-creation thread
        '''
        anima.comm.utils.checkThread(self.thread)
        #Note: receive is currently set to copy. If not efficient enough, change this.
        try:
            self.socket.send_multipart([self.channel().encode(),message.encode()])
            log.debug("Sent message \""+str(message)+"\" on channel \""+str(self.channel())+"\"")
        except zmq.ZMQError as e:
            log.warning("Failed to send message")
            raise anima.comm.exceptions.CommunicationException("Send failure",e)
    def channel(self,channel=None):
        '''
        Returns old channel and optionally resets channel
        @param channel - (optional) new channel to send on or None
        @return current channel
        @throws ThreadingException if used on non-creation thread
        '''
        anima.comm.utils.checkThread(self.thread)
        ret = self.chan
        if not channel is None:
            self.chan = channel
        return ret