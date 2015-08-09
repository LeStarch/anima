'''
Constants used within the anima-comm package.

TODO: Change this into a configuration module
'''
'''
The directory used to hold all IPC sockets created by the communications module.
'''
IPC_SOCKETS_DIR="/tmp/anima-ipc"

'''
Number of IO threads to use for this process when building the zero-mq context.

This value is implementation library specific, and should be set to 1 IO thread per GB/s 
expected to be pushed through this module in the current process.
'''
IO_THREAD_COUNT=1
