'''
Communication utilities for setting-up connections.

@author: starchmd
'''
import os
import zmq

import anima.comm.constants
import anima.logging.utils

log = anima.logging.utils.logger(__name__)

context = None
def getContextSingleton():
    '''
    Creates (if necessary) and returns the single zeromq context for this process
    @return single shared zeromq context
    '''
    global context
    if context is None:
        log.info("Creating zeromq context")
        context = zmq.context(io_threads=anima.comm.constants.IO_THREAD_COUNT)
    return context
#    Get any sockets that currently exist in the system
#    @return - list of current sockets
#    '''
#    sockets = [sock for sock in os.listdir(anima.comm.constants.IPC_SOCKETS_DIR)
#                    if sock.startswith(anima.comm.constants.IPC_PUBLISHER_PREFIX)]
#    ret = {}
#    for sock in sockets:
#        ret[sock.lstrip(anima.comm.constants.IPC_PUBLISHER_PREFIX)] = os.path.join(anima.comm.constants.IPC_SOCKETS_DIR,
#                                                                                   anima.comm.constants.IPC_PUBLISHER_PREFIX)
#    for k,v in ret.items():
#        log.info("Loaded socket information: {0}:{1}".format(k,v))
#    return ret
def connection(pid=os.getpid()):
    '''
    Sets up a publisher connection for the current process
    @param pid - (optional) process identification
    @return - connection
    '''
    location="{0}://{1}".format("ipc",os.path.join(anima.comm.constants.IPC_SOCKETS_DIR,
                                            anima.comm.constants.IPC_PUBLISHER_PREFIX+
                                            str(pid)))
    context = zmq.Context.instance()
    sock = context.socket(zmq.PUB)
    sock.connect(location)
    log.info("Connected to publisher socket: {0}".format(location))
    return sock
def channel(pid=os.getpid(),channel=anima.comm.constants.DEFAULT_CHANNEL):
    '''
    Returns the default channel
    @param pid - (optional) process identification
    @param channel - (optional) partial name of channel
    @return - full name of channel
    '''
    return "{0}-{1}".format(pid,channel)
def binding(channel=channel()):
    '''
    Get a binding to a channel
    @param channel - (optional) name of channel to connect to
    @return - socket connection
    '''
    location="{0}://{1}".format("ipc",os.path.join(anima.comm.constants.IPC_SOCKETS_DIR,
                                            anima.comm.constants.IPC_PUBLISHER_PREFIX+
                                            channel.split("-")[0]))
    context = zmq.Context.instance()
    sock = context.socket(zmq.SUB)
    sock.setsockopt_string(zmq.SUBSCRIBE,channel)
    sock.bind(location)
    log.info("Bound to subscriber socket: {0} on channel {1}".format(location,channel))
    return sock