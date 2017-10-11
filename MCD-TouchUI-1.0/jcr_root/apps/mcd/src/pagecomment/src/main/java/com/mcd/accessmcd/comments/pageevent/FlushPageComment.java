/*
 * Project: AccessMCD
 *
 * @(#)NotificationService.java
 * Revisions:
 * Date            Programmer           Description
 * ---------------------------------------------------------------------------------------------
 * 27,April 2011   HCL                  This Class implements the Notification Service that acts
                                        as the listener when a comment node is added to send
                                        emails to the subscribed users
 * ---------------------------------------------------------------------------------------------
 * Description:
 * This software is the confidential and proprietary information of
 * McDonald's Corp. ("Confidential Information").
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with McDonald's.
 *
 * Copyright (c) 2010 McDonalds Corp.
 * All Rights Reserved.
 * www.mcdonalds.com
 */

package com.mcd.accessmcd.comments.pageevent; 

import javax.jcr.Node;
import javax.jcr.Session;
import org.apache.sling.jcr.api.SlingRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import javax.jcr.observation.EventIterator;
import javax.jcr.observation.EventListener;
import com.mcd.accessmcd.comments.util.PropertiesLoader;
import javax.jcr.observation.Event;
import com.day.cq.commons.RunModeUtil;
import com.mcd.accessmcd.comments.constants.CommentsConstants;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.jcr.resource.JcrResourceResolverFactory;
import org.osgi.framework.BundleContext;
import org.osgi.service.component.ComponentContext;
import org.apache.sling.scripting.core.ScriptHelper;
import org.apache.sling.runmode.RunMode;
import com.day.cq.wcm.api.Page;
import com.day.cq.wcm.api.PageManager;
import com.day.cq.replication.AgentIdFilter;
import com.day.cq.replication.Replicator;
import com.day.cq.replication.ReplicationOptions;
import com.day.cq.replication.ReplicationActionType;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;


@Component(immediate = true,metatype=false)
@Service
@Properties({
    	@Property( name="service.description",value="Comments Notification"),
   	 	@Property( name="service.vendor",value="MCD"),
    	@Property( name="run.modes",value={"author",""})
})

 
public class FlushPageComment implements EventListener{ 

    @Reference
    private SlingRepository repository;
    
    @Reference 
    private JcrResourceResolverFactory resolverFactory;
    
    @Reference
    private RunMode runMode;
    
    private Session observationSession;
    private String rootPath = "";
    private ComponentContext ctx;
    private BundleContext bundleContext;
    
    private static final Logger log = LoggerFactory.getLogger(FlushPageComment.class); 

    private boolean enabled;

    public String getRepository() {
        return repository.getDescriptor(SlingRepository.REP_NAME_DESC);
    }

    protected void activate(ComponentContext ctx)
    {   
        this.ctx = ctx;
        bundleContext = this.ctx.getBundleContext();
        String modes[] = (String[])ctx.getProperties().get(CommentsConstants.RUN_MODES);
        enabled = !RunModeUtil.disableIfNoRunModeActive(runMode, modes, ctx, log); 
         
        try {
          observationSession = repository.loginAdministrative(null);                    
          startService(observationSession, resolverFactory);
        } catch (Exception re) {
          log.error("[activate()] Exception while adding listener for Page Commenting Flush Page Comment Service: "+ re.getMessage());       
        }
        
        log.info("[activate()] Inside Activate Bundle Context for Page Commenting Flush Page Comment Service: " + bundleContext );
    }
    
    protected void deactivate(ComponentContext context)
    {
        try {
            observationSession.getWorkspace().getObservationManager().removeEventListener(this);
        } catch(Exception e) {
            log.error("[unbindRepository()] Exception while removing the event listener: " , e);
        }
        if (observationSession.isLive()) 
                    observationSession.logout();       
        observationSession = null; 
    } 

    protected void bindRepository(SlingRepository repository) {       
        this.repository = repository;
        
    }
    
    public void startService(Session observationSession, JcrResourceResolverFactory resolverFactory) {        
        try {                                  
            if(enabled) {                
                log.info("[startService()] Starting Page Commenting Flush Page Comment Service");                
                
                // Reading root node from properties file 
                rootPath = PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH);
                
                //adding event listener on addition of any node
                observationSession.getWorkspace().getObservationManager().addEventListener(this,getModificationTypes(),rootPath , true, null,null, true);             
            }                
        } catch (Exception ex) {
            log.error("[startService()] Exception while starting Page Commenting Flush Page comment Service: " + ex.getMessage());
        }
    }

    private static int getModificationTypes() {
        return Event.PROPERTY_CHANGED;
    }

    public void onEvent(EventIterator eventIterator) {
        try {
            
            Event event = null;
            String eventPath = "";
            
            while(eventIterator.hasNext()) {
                event = eventIterator.nextEvent();
                eventPath = event.getPath();
                
                                
                if(event.getType() == Event.PROPERTY_CHANGED)  {                    
                    ResourceResolver resourceResolver = resolverFactory.getResourceResolver(observationSession);
                    Resource res = resourceResolver.getResource(eventPath.substring(0,eventPath.lastIndexOf("/")));
                    Node propertyNode = res.adaptTo(Node.class);
                                      
                    
                    if(propertyNode != null) {                        
                        
                        
                        if(eventPath.endsWith("cq:lastReplicated") && propertyNode.isNodeType("cq:Comment")) {
                            log.info("[onEvent()] Page Commenting Flush Comments");                  
                            PageManager pageManager=resourceResolver.adaptTo(PageManager.class);  
                            Page commentPage = pageManager.getContainingPage(propertyNode.getPath());
                            Page page = pageManager.getPage(commentPage.getPath().replace("/content/mcdcomments",""));
                            
                            if(null != page) {
                                String agentIds = PropertiesLoader.getProperty("replicationAgentIds");
                                if(null != agentIds) {
                                    Node pageNode = resourceResolver.getResource(page.getPath()+"/jcr:content").adaptTo(Node.class);
                                    pageNode.setProperty("replicationAgent","flush");
                                    pageNode.save();
                                    pageNode.refresh(true);
                                    AgentIdFilter replicationAgents = new AgentIdFilter(agentIds.split(","));
                                    ReplicationOptions opts = new ReplicationOptions();
                                    log.error("************************** Flushing Page ::::::: " + page.getPath());
                                    opts.setFilter(replicationAgents);
                                    ScriptHelper sling = new ScriptHelper(bundleContext, null);
                                    Replicator replicator = sling.getService(Replicator.class);
                                    replicator.replicate(observationSession, ReplicationActionType.ACTIVATE, page.getPath(), opts);
                                    
                                }
                            }
                        }
                        
                    }                    
                }                
            } 
        }catch(Exception e)
        {               
            log.error("[onEvent()] Exception during Event Handling of Page Commenting Flush Comment Page Service: ",e);
        }
    }
    
    protected void unbindRepository(SlingRepository repository) {
        log.info("[unbindRepository()] Unbinding Repository for Page Commenting Flush Comment Page Service");
        if(this.repository == repository) {
            repository = null;
        }
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
    
    protected void bindRunMode(RunMode runmode)
    {       
        runMode = runmode;        
    }

    protected void unbindRunMode(RunMode runmode)
    {        
        if(runMode == runmode)
            runMode = null;
    }
    
}
    