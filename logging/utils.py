'''
This module is used to establish a common logging format and usage-pattern for 
the anima-project through utility functions.

This module is upon standard python logging, and is not a proper wrapper, thus raw python-logging
calls are used.

Thus DO NOT attempt to replace python logging with another logging library that is not duck-type 
compatible.

@author: starchmd
'''
import logging
import sys

started=False
def init():
    '''
    Initialize the python logging system. Needs to be called only once.
    '''
    if started:
        return
    logging.basicConfig(datefmt="%Y%m%dT%H:%M:%S",level=logging.DEBUG,handlers=[logging.StreamHandler()])
    logging.info("Logging system initialized")
    global started
    started=True
def logger(obj):
    '''
    Gets a logger based for given object, and starts the logging system if not already started.
    @param obj - object used to name logger. Uses __module__ attribute, or obj directly without __module__
    '''
    if not started:
        init()
    if hasattr(obj,"__module__"):
        return logging.getLogger(str(obj.__module__) + "." + str(obj.__class__.__name__))
    return logging.getLogger(obj)