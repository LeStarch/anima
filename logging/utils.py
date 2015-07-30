'''
Logging helper functions

@author: starchmd
'''
import logging
import sys

def init():
    '''
    Initialize the python logging system
    '''
    logging.basicConfig(datefmt="%Y%m%dT%H:%M:%S",level=logging.DEBUG,handlers=[logging.StreamHandler()])
    logging.info("Logging system initialized")
def logger(obj):
    '''
    Gets a logger based on given object
    @param obj - object to use for logger naming
    '''
    if hasattr(obj,"__module__"):
        return logging.getLogger(str(obj.__module__) + "." + str(obj.__class__.__name__))
    return logging.getLogger(obj)