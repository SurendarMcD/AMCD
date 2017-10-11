 package com.mcd.utility; 
 
 import org.slf4j.Logger;
 import org.slf4j.LoggerFactory;
 import com.day.cq.replication.*; 
 import org.apache.sling.api.resource.Resource;
 import org.apache.sling.api.resource.ResourceResolver; 
 import javax.jcr.Session;
 
import java.util.Iterator;

import org.apache.sling.api.scripting.SlingScriptHelper;
 
 import com.day.cq.commons.LabeledResource;
 import javax.jcr.Node;
 import com.day.cq.replication.ReplicationException;
 import org.apache.jackrabbit.util.Text;
 import javax.jcr.RepositoryException;
  
 //Class to activate a particulatr tree structure
    public class Processor {

        /**
         * default logger
         */
        private static final Logger log = LoggerFactory.getLogger(Processor.class);
        private final Replicator replicator;        
        private final SlingScriptHelper sling;
        private final ResourceResolver resolver;
        private final Session session;
        private int tCount;
        private int aCount;

        public Processor(Replicator replicator, ResourceResolver resolver, SlingScriptHelper sling) {
            this.replicator = replicator;
            this.resolver = resolver;
            this.session = resolver.adaptTo(Session.class);
            this.sling = sling;
        }
        
        //start the activation process
        public void process(String path) {            
            
            Resource res = resolver.getResource(path);
            if (res == null) {
                log.error("Zip file not uploaded correctly.");
                return;
            }
            
            

            tCount = aCount = 0;
            try {
                process(res);
                                
            } catch (Exception e) {
                log.error("Error during processing: " + e);
                log.error("Error during tree activation of " + path);
            }     
                        
           
        }
        
        //retrieve the replication agent
        private Agent getThrottleAgent() {
            // get the first enabled agents
            AgentManager agentMgr = sling.getService(AgentManager.class);
            for (Agent agent: agentMgr.getAgents().values()) {
                if (agent.isEnabled()) {
                    return agent;
                }
            }
            return null;
        }

        //activates the tree structure
        private boolean process(Resource res)
                throws RepositoryException, ReplicationException {

            Node node = res.adaptTo(Node.class);
            if (!node.isNodeType("nt:hierarchyNode")) {
                return false;
            }
            
            String title = Text.getName(res.getPath());
            LabeledResource lr = res.adaptTo(LabeledResource.class);
            if (lr != null && lr.getTitle() != null) {
                title = lr.getTitle();
            }
              log.error("Title : "+title);          
            tCount++;

            Agent agent = getThrottleAgent();
            ReplicationQueue queue = agent == null ? null : agent.getQueue();
            int num= queue == null ? 0 : queue.entries().size();
            int test=0;
            
            while (num>0) {
               
                try { 
                    Thread.sleep(500);
                } catch (InterruptedException e) {
                    // ignore
                }
                num=queue.entries().size();
                test++;
            } 
                            
              try {
                  //activating the node
                  replicator.replicate(session, ReplicationActionType.ACTIVATE, res.getPath());
                  //this.session.logout();
                  
              } catch (ReplicationException e) {
                  log.error("Error during processing: ", e.toString());
                  log.error("Error during tree activation of " + res.getPath(), e);
              }
              
              aCount++;            
            
                      
            Iterator<Resource> iter = resolver.listChildren(res);
            while (iter.hasNext()) {
                process(iter.next());
            }
            return true;
        }
    } 