import os
import threading

import zmq

import anima.comm.constants
import anima.logging.utils
'''
Utility methods used within the anima-comm module.

Note: these functions are backing-library specific and should not be used outside this module.

@author: starchmd
'''
log = anima.logging.utils.logger(__name__)
context = None
def getContextSingleton():
    '''
    Creates (if necessary) and returns the single zeromq context for this process.
    Note: This is backing library specific, and so should not be used external to the communications
    library.
    @return single shared zeromq context
    '''
    global context
    if context is None:
        log.info("Creating zeromq context")
        context = zmq.Context(io_threads=anima.comm.constants.IO_THREAD_COUNT)
    return context
def getIPCName(type):
    '''
    Gets the name of the IPC socket for the given type, process, and thread.
    The IPC socket is specific to thread, and process. It is of the form:
    
    <type>-<thread-id>-<process id>
    
    Note: This function is specific for zero-mq IPC sockets, and should not be
    used external to this module.    
    @param type - type of the ipc
    '''
    return "ipc://"+os.path.join(anima.comm.constants.IPC_SOCKETS_DIR,str(type)+"-"+str(threading.current_thread().ident)+"-"+str(os.getpid()))
def getIPCNamesByType(type):
    '''
    Gets all the local ipc sockets by type.
    Note: This function is specific for zero-mq IPC sockets, and should not be
    used external to this module.
    @param type - type to filter by
    '''
    ret = []
    for listing in os.listdir(anima.comm.constants.IPC_SOCKETS_DIR):
        if listing.startswith(str(type)):
            ret.append("ipc://"+os.path.join(anima.comm.constants.IPC_SOCKETS_DIR,listing))
    return ret
def getTCPName(port):
    '''
    Gets the name of the TCP socket for the given port.
    
    Note: This function is specific for zero-mq TPC sockets, and should not be
    used external to this module.    
    @param port - port number to bind to
    '''
    return "tcp://*:"+str(port)
def checkThread(thread):
    '''
    Checks if the given thread is the current thread
    Note: ThreadingException is module-specific
    @param thread - thread identifier to check
    @throws ThreadingException on thread miss-match
    '''
    if thread != threading.current_thread().ident:
        raise anima.comm.exceptions.ThreadingException("Threading miss-match")