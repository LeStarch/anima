import sys
import zmq

import anima.logging

import anima.comm.constants
import anima.comm.utils

'''
This module holds the code for the data-network proxy.

@author: starchmd
'''
log = anima.logging.utils.logger(__name__)
class Proxy(object):
    def __init__(self,publisher,subscriber,hostname=None):
        '''
        Constructs this proxy
        @param publisher - port to listen to for publisher
        @param subscriber - port to listen to for subscriber
        @param hostname - the hostname of a node in a network to connect to
        '''
        if not network is None:
            #connect()
            #getState()
            #???
            pass 
        
        context = anima.comm.utils.getContextSingleton()
        
        #Setup the XPublisher
        self.pub = context.socket(zmq.XPUB)
        name = anima.comm.utils.getTCPName(publisher)
        log.info("Binding publisher to: "+name)
        self.pub.bind(name)
        #Setup the XSubscriber
        self.sub = context.socket(zmq.XSUB)
        name = anima.comm.utils.getTCPName(subscriber)
        log.info("Binding subscriber to: "+name)
        self.pub.bind(name)
    def run(self):
        '''
        Run this proxying service
        '''
        zmq.device(zmq.FORWARDER,self.sub,self.pub)
        
    def getState(self):
        '''
        Generates the latest state (by communicating with other daemons) or 
        generates a blank state.
        '''
        state = {"channels":{}}
        return state
    def getHosts(self):
        '''
        
        '''
        pass
if __name__ == "__main__":
    '''
    Main method
    '''
    network = None
    port = -1
    if len(sys.argv) < 3 or len(sys.argv) > 4:
        print("Usage:\n\t",sys.argv[0],"<publisher port>","<subscriber port>","[network]",file=sys.stderr)
        sys.exit(-1)
    elif len(sys.argv) == 4:
        network = sys.argv[3]
    ppub = int(sys.argv[1])
    psub = int(sys.argv[2])
    proxy = Proxy(ppub,psub,network)
    proxy.run()