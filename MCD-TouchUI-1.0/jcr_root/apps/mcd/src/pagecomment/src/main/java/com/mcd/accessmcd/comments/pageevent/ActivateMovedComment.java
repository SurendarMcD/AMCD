package com.mcd.accessmcd.comments.pageevent;

import org.osgi.service.event.Event;
import org.osgi.service.event.EventHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.day.cq.replication.*;
import com.day.cq.replication.ReplicationActionType;
import com.day.cq.replication.ReplicationAction;

import org.osgi.framework.BundleContext;
import org.osgi.service.component.ComponentContext;
import org.apache.sling.scripting.core.ScriptHelper;

import com.day.cq.wcm.api.Page;
import com.day.cq.wcm.api.PageManager;
import com.day.cq.commons.RunModeUtil; 

import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.jcr.api.SlingRepository;
import javax.jcr.Session;
import org.apache.sling.jcr.resource.JcrResourceResolverFactory;
import org.apache.sling.event.JobProcessor;
import org.apache.sling.event.EventUtil;
import org.osgi.service.event.EventConstants;
import org.apache.sling.runmode.RunMode;

import com.mcd.accessmcd.comments.util.PropertiesLoader;
import com.mcd.accessmcd.comments.util.NodeUtility; 
import javax.jcr.Node;   
import com.mcd.accessmcd.comments.constants.CommentsConstants;

import java.util.List;
import java.util.ArrayList;
import javax.jcr.Node;
import javax.jcr.Value;
import javax.jcr.NodeIterator;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;


@Component(immediate = true,metatype=false)
@Service
@Properties({
    	@Property( name="service.description",value="ActivateMovedComment"),
   	 	@Property( name="service.vendor",value="MCD"),
        @Property( name = EventConstants.EVENT_TOPIC, value = ReplicationAction.EVENT_TOPIC),
        @Property( name="run.modes",value={"author",""})
})

public class ActivateMovedComment implements EventHandler,JobProcessor
{   

    /**
     * default logger
     */        
    private static final Logger log = LoggerFactory.getLogger(ActivateMovedComment.class);
    
    @Reference
    private RunMode runMode;
          
    @Reference
    private SlingRepository repository;

    private BundleContext bundleContext;
    
    @Reference
    private JcrResourceResolverFactory resolverFactory;
    
    
    boolean enabled;
        
    protected void activate(ComponentContext ctx)
    {   
        bundleContext = ctx.getBundleContext();
        String modes[] = (String[])ctx.getProperties().get(CommentsConstants.RUN_MODES);
        enabled = !RunModeUtil.disableIfNoRunModeActive(runMode, modes, ctx, log);
    }
   
    public void handleEvent(Event event)
    {
        if(enabled) {
            if(EventUtil.isLocal(event))
                EventUtil.processJob(event, this);
        }
    } 
     
    
    public boolean process(Event event)
    {
        Session session = null;
        ReplicationAction replication = ReplicationAction.fromEvent(event);
        if(replication!=null)   
        {
            try
            {
                ScriptHelper sling = new ScriptHelper(bundleContext, null);
                session = repository.loginAdministrative(null); 
                Replicator replicator = sling.getService(Replicator.class);
                ResourceResolver resourceResolver = resolverFactory.getResourceResolver(session); 
                String commentPagePath = PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH)+replication.getPath();
                PageManager pageManager = resourceResolver.adaptTo(PageManager.class);  
                Page activatedPage = pageManager.getPage(replication.getPath());
                
                if(null != activatedPage) {
                    Page commentPage = pageManager.getPage(commentPagePath);
                    Node activatedNode = resourceResolver.getResource(replication.getPath()).adaptTo(Node.class);
                    Node subChildNode = getComponentNode(activatedNode);
                    
                    if(activatedNode.getNode(CommentsConstants.JCR_CONTENT).hasProperty("replicationAgent")) {
                        activatedNode.getNode(CommentsConstants.JCR_CONTENT).getProperty("replicationAgent").remove();
                        activatedNode.getNode(CommentsConstants.JCR_CONTENT).save();
                    } else {
                        if(ReplicationActionType.ACTIVATE == replication.getType() && null != subChildNode){
                           if(null == commentPage) {                       
                               NodeUtility nodeUtility = new NodeUtility(resourceResolver.getResource(subChildNode.getPath()));
                               nodeUtility.createNodePath("");                     
                               commentPage = pageManager.getPage(commentPagePath);                       
                           }                   
                           
                           if(null != commentPage){                   
                                    
                                Node commentNode = resourceResolver.getResource(commentPagePath).adaptTo(Node.class);
                                Node contentNode = commentNode.getNode(CommentsConstants.JCR_CONTENT);
                                Node pagecommentingNode = resourceResolver.getResource(commentPagePath + "/" + activatedPage.getName() + "_pagecommenting/" + CommentsConstants.JCR_CONTENT).adaptTo(Node.class);                        
                               
                                if(subChildNode.hasProperty("default_eids")) {
                                    List defaultUsers = new ArrayList();
                                    if(subChildNode.getProperty("default_eids").isMultiple()) {
                                        Value[] values = subChildNode.getProperty("default_eids").getValues(); 
                                        for(int i = 0 ; i < values.length ; i++)
                                        { 
                                            defaultUsers.add(values[i].getString());   
                                        }
                                    } else {
                                        defaultUsers.add(subChildNode.getProperty("default_eids").getValue().getString());
                                    }
                                    
                                    pagecommentingNode.setProperty("DefaultUsers",(String[])defaultUsers.toArray(new String[0]));
                                    pagecommentingNode.setProperty("modified","true");
                                    pagecommentingNode.save();
                                    pagecommentingNode.refresh(true); 
                                }                        
                               
                               replicator.replicate(session, ReplicationActionType.ACTIVATE, commentPagePath);
                               // Deactivate the disabled comment
                               if(contentNode.hasProperty(CommentsConstants.LAST_REPLICATION_ACTION)){ 
                                    Node commentsContentNode = contentNode.getNode("pagecommenting");
                                    disableComment(session, commentsContentNode, replicator, true);
                               }
                           }          
                        }
                    }
                    if(ReplicationActionType.DEACTIVATE == replication.getType()){  
                        if(null != commentPage){
                            replicator.replicate(session, ReplicationActionType.DEACTIVATE, commentPagePath);
                        }
                    }
                } else {
                    Node commentNode = resourceResolver.getResource(replication.getPath()).adaptTo(Node.class);
                    disableComment(session, commentNode, replicator, false);
                }
            }//end try block
            catch(Exception e)
            {   
                log.error("Exception caught ActivateMovedComment::::", e);
            } 
            finally{
                if(session!=null)
                    session.logout();
            }  
        }
        return true;
     }
    
    public Node getComponentNode(Node activatedNode) {
        
        try {        
            activatedNode = activatedNode.getNode(CommentsConstants.JCR_CONTENT);
            if(activatedNode.hasNodes()) {
                NodeIterator nodeIterator = activatedNode.getNodes(); 
                while(nodeIterator.hasNext()){
                    Node childNode = nodeIterator.nextNode();
                    if(childNode.hasNodes()){
                        NodeIterator childNodeIterator = childNode.getNodes();
                        while(childNodeIterator.hasNext()){
                            Node subChildNode = childNodeIterator.nextNode();
                            if(subChildNode.getName().equals("pagecommenting")) {
                                return subChildNode;
                            } 
                        }
                    }
                }
            }            
        } catch(Exception e) {   
            log.error("Exception caught ActivateMovedComment::::" + e);
        }
        
        return null;
    }
    
    public void disableComment(Session session,Node commentNode, Replicator replicator, boolean forceDisable) throws Exception {
        if(commentNode!=null && (commentNode.isNodeType(CommentsConstants.COMMENT_NODE_TYPE) || forceDisable)) {
            NodeIterator commentNodeIter = commentNode.getNodes();
            while(commentNodeIter.hasNext()) {
                Node childCommentNode = commentNodeIter.nextNode();
                if(CommentsConstants.DEACTIVATE.equalsIgnoreCase(childCommentNode.getProperty(CommentsConstants.LAST_REPLICATION_ACTION).getString())){
                    log.info("[disableComment] Deactivating comment at path : " + childCommentNode.getPath());
                    replicator.replicate(session, ReplicationActionType.DEACTIVATE, childCommentNode.getPath());
                } else {
                    disableComment(session, childCommentNode, replicator, false);
                }
            }
        } else {
            log.error("Replicated Page " + commentNode.getPath() + " is not present.");
        }
    }
         
     protected void bindRunMode(RunMode runmode)
    {
        log.error("********** Inside BindRunMode **********");
        runMode = runmode;        
    }

    protected void unbindRunMode(RunMode runmode)
    {
        log.error("********** Inside UnBindRunMode **********");
        if(runMode == runmode)
            runMode = null;
    }
       
    protected void bindRepository(SlingRepository repository)
    {
        log.error("********** Inside BindRepository **********");
        this.repository = repository;
            
    }   
    protected void unbindRepository(SlingRepository repository)
    {       
        repository = null;
    }


	protected void bindResolverFactory(JcrResourceResolverFactory resolverFactory)
    {
        //log.error("********** Inside bindConfigAdmin **********");
        this.resolverFactory = resolverFactory;
            
    }   
    protected void unbindResolverFactory(JcrResourceResolverFactory resolverFactory)
    {       
        //log.error("********** Inside unbindConfigAdmin **********");
        resolverFactory = null;
    }
}   
