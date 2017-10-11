package com.mcd.accessmcd.usermanagement.replication.services.impl;

import javax.jcr.Session;

import org.apache.sling.api.scripting.SlingScriptHelper;
import org.apache.sling.jcr.api.SlingRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.replication.Agent;
import com.day.cq.replication.AgentManager;
import com.day.cq.replication.ReplicationActionType;
import com.day.cq.replication.ReplicationQueue;
import com.day.cq.replication.Replicator;
import com.day.cq.security.Group;
import com.day.cq.security.User;
import com.day.cq.security.UserManager;
import com.mcd.accessmcd.usermanagement.replication.services.IReplicationService;

public class ReplicationServiceImpl implements IReplicationService
{
    private static final Logger log = LoggerFactory.getLogger(com.mcd.accessmcd.usermanagement.replication.services.impl.ReplicationServiceImpl.class);
    SlingScriptHelper sling = null;
    
    UserManager uMgr = null;
    Replicator replicator = null;
    SlingRepository repos=null;
    
    public ReplicationServiceImpl(SlingScriptHelper sling, Session jcrSession, UserManager uMgr) throws Exception
    {
        this.sling = sling;
        repos= sling.getService(SlingRepository.class); 
        this.uMgr = uMgr;
        replicator = sling.getService(Replicator.class);
    }
    
    /**
     * Method to replicate group on publish instances.
     * 
     * @param groupID
     */
    public boolean replicateGroupOnPublish(String groupID) throws Exception
    {
                                           
        Session session=null;
        try
        {
            Agent agent = getThrottleAgent();
            ReplicationQueue queue = agent == null ? null : agent.getQueue();
            int num = queue == null ? 0 : queue.entries().size();
            int test = 0;
            while (num > 0)
            {
                try
                {
                    Thread.sleep(500);
                }
                catch (InterruptedException e)
                {
                    log.error("[ReplicationServiceImpl.replicateGroupOnPublish()] exception occured" + e.getMessage());
                }
                num = queue.entries().size();
                test++;
            } 
            Group group=(Group)uMgr.get(groupID);
            session = repos.loginAdministrative(null);
            replicator.replicate(session, ReplicationActionType.ACTIVATE,group.getHomePath());
            replicator.replicate(session, ReplicationActionType.ACTIVATE,group.getHomePath()+"/profile"); 
            session.logout();
            session = null;
            return true;
        }
        catch(Exception e)
        {
            log.error("[ReplicationServiceImpl.replicateGroupOnPublish()] exception occured" + e.getMessage());
            e.printStackTrace();
            return false;
        }
        finally{
            if(session!=null)session.logout();
            session = null;
        }
    }

    /**
     * Method to replicate user on publish instances.
     * 
     * @param EID
     */
    public boolean replicateUserOnPublish(String EID) throws Exception
    {
        Session session=null;
        try
        {
            Agent agent = getThrottleAgent();
            ReplicationQueue queue = agent == null ? null : agent.getQueue();
            int num = queue == null ? 0 : queue.entries().size();
            int test = 0;

            while (num > 0)
            {
                try
                {
                    Thread.sleep(500);
                }
                catch (InterruptedException e)
                {
                    log.error("[ReplicationServiceImpl.replicateUserOnPublish()] exception occured" + e.getMessage());
                }
                num = queue.entries().size();
                test++;
            }
            
            
            User user=(User)uMgr.get(EID);
            session = repos.loginAdministrative(null);
            System.out.println("***** replicateUserOnPublish *****");
            replicator.replicate(session, ReplicationActionType.ACTIVATE,user.getHomePath());
            System.out.println("***** replicateUserOnPublish 1111*****");
            session.logout();
            System.out.println("***** replicateUserOnPublish 2222*****");
            session = null;
            System.out.println("***** replicateUserOnPublish 3333*****");
            return true;
        }
        catch(Exception e)
        {
            log.error("[ReplicationServiceImpl.replicateUserOnPublish()] exception occured" + e.getMessage());
            e.printStackTrace();
            return false;
        } 
        finally{
            if(session!=null)session.logout();
            session = null;
        }      
    }
    
    /**
     * method to retrieve the replication agent.
     * @return Agent
     */
    private Agent getThrottleAgent()
    {
        AgentManager agentMgr = sling.getService(AgentManager.class);
        for (Agent agent : agentMgr.getAgents().values())
        {
            if (agent.isEnabled())
            {
                return agent;
            }
        }
        return null;
    }
}