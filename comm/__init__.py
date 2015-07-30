import os
#Local imports
from anima.comm.constants import IPC_SOCKETS_DIR
'''
Initializes the communications module
@author: starchmd
'''
def setup():
    '''
    Setup code for the communications module
    '''
    if not os.path.exists(IPC_SOCKETS_DIR):
        os.mkdir(IPC_SOCKETS_DIR)
setup()