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

package com.mcd.accessmcd.comments.notification; 

import java.util.List;
import java.util.ArrayList;
import javax.jcr.Node;
import javax.jcr.Value;
import javax.jcr.NodeIterator;
import javax.jcr.Session;
import org.apache.sling.jcr.api.SlingRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import javax.jcr.observation.EventIterator;
import javax.jcr.observation.EventListener;
import com.mcd.accessmcd.comments.util.PropertiesLoader;
import javax.jcr.observation.Event;
import com.day.cq.commons.RunModeUtil;
import com.mcd.accessmcd.comments.bean.EmailDataBean;
import com.mcd.accessmcd.comments.service.EmailManager;
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
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;


@Component(immediate=true,metatype=false)
@Service
@Properties({
    @Property( name="service.description",value="Comments Notification"),
    @Property( name="service.vendor",value="MCD"),
    @Property(name = "run.modes", value={"author",""})
})


public class NotificationService implements EventListener{ 

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
    
    private static final Logger log = LoggerFactory.getLogger(NotificationService.class);

    private boolean enabled;
    boolean isMaster = false;

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
          log.error("[activate()] Exception while adding listener for Page Commenting Email Sender Notification Service: "+ re.getMessage());       
        }
        
        log.info("[activate()] Inside Activate Bundle Context for Page Commenting Email Sender Notification Service: " + bundleContext );
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

    public void startService(Session observationSession, JcrResourceResolverFactory resolverFactory) {        
        try {                                  
            if(enabled) {                
                log.info("[startService()] Starting Page Commenting Email Sender Notification Service");                
                
                // Reading root node from properties file 
                rootPath = PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH);
                
                //adding event listener on addition of any node
                observationSession.getWorkspace().getObservationManager().addEventListener(this,getModificationTypes(),rootPath , true, null,null, true);             
            }                
        } catch (Exception ex) {
            log.error("[startService()] Exception while starting Page Commenting Email Sender Notification Service: " + ex.getMessage());
        }
    }

    private static int getModificationTypes() {
        return Event.NODE_ADDED | Event.PROPERTY_ADDED;
    }

    public void onEvent(EventIterator eventIterator) {
        try {
            
            ScriptHelper sling = new ScriptHelper(bundleContext, null);
            Event event = null;
            String eventPath = "";
            
            while(eventIterator.hasNext()) {
                event = eventIterator.nextEvent();
                eventPath = event.getPath();
                //Added condition for disabling email notification ehrn like button is clicked
                if(!eventPath.endsWith("like")) {
                    EmailDataBean mailData = new EmailDataBean();
                    ResourceResolver resourceResolver = resolverFactory.getResourceResolver(observationSession);
                                    
                    if(event.getType() == Event.NODE_ADDED) {
                        
                        Resource res = resourceResolver.getResource(eventPath);
                        Node commentNode = res.adaptTo(Node.class);
                    
                        if(commentNode != null && commentNode.isNodeType(CommentsConstants.COMMENT_NODE_TYPE)) {                   
                            
                            log.info("[onEvent()] Page Commenting Email Sender Notification Service: Comment added: " + eventPath);
                            System.out.println("[onEvent()] Page Commenting Email Sender Notification Service: Comment added: " + eventPath);                  
                            
                            //setting mail action to added
                            mailData.setMailAction(CommentsConstants.EMAIL_ADD_ACTION);                    
                            
                            //sending mail
                                    //if(isMaster){
                                        System.out.println("************** Hi This is master instance from where email is going **************");
                                        EmailManager mailManager = new EmailManager(sling, resourceResolver, commentNode); 
                                        mailManager.sendMail(mailData);
                                    /*}
                                    else{
                                        System.out.println("************** Hi This is slave instance from where email is not going **************");
                                    } */   
                        }  
                    
                    } else if(event.getType() == Event.PROPERTY_ADDED && eventPath.endsWith(CommentsConstants.UNSUBSCRIBE_USER_PROPERTY))  {                    
                        Resource res = resourceResolver.getResource(eventPath.substring(0,eventPath.lastIndexOf("/")));
                        Node propertyNode = res.adaptTo(Node.class);
                        PageManager pageManager=resourceResolver.adaptTo(PageManager.class);                    
                        
                        if(propertyNode != null) {                        
                            
                            log.info("[onEvent()] Page Commenting Email Sender Notification Service: User unsubscribed: " + propertyNode.getProperty("unsubscribedUser").getValue().getString());                  
                            
                            Page page = pageManager.getPage(propertyNode.getProperty(CommentsConstants.COMMENTS_PAGE_PATH).getValue().getString());
                            
                            List defaultUsers = null;
                            Node pageNode = resourceResolver.getResource(page.getPath()+"/jcr:content").adaptTo(Node.class);
                            String eid = propertyNode.getProperty(CommentsConstants.UNSUBSCRIBE_USER_PROPERTY).getValue().getString();
                            if(pageNode.hasNodes()) {
                                NodeIterator nodeIterator = pageNode.getNodes(); 
                                while(nodeIterator.hasNext()){
                                    Node childNode = nodeIterator.nextNode();
                                    
                                    if(childNode.hasNodes()){
                                        NodeIterator childNodeIterator = childNode.getNodes();
                                        while(childNodeIterator.hasNext()){
                                            Node subChildNode = childNodeIterator.nextNode();
                                            
                                            if(subChildNode.getName().equals("pagecommenting")) {
                                                if(subChildNode.hasProperty("default_eids")) {
                                                    defaultUsers = new ArrayList();
                                                    if(subChildNode.getProperty("default_eids").isMultiple()) {
                                                        Value[] values = subChildNode.getProperty("default_eids").getValues(); 
                                                        int j = 0;
                                                        for(int i = 0 ; i < values.length ; i++)
                                                        { 
                                                            if(! values[i].getString().equalsIgnoreCase(eid))
                                                            {                                                        
                                                                defaultUsers.add(values[i].getString());
                                                                j++; 
                                                            }                                                    
                                                        }
                                                    } else {
                                                        String defaultEid = subChildNode.getProperty("default_eids").getValue().getString();
                                                        if(!defaultEid.equalsIgnoreCase(eid)) { 
                                                            defaultUsers.add(defaultEid);
                                                        }
                                                    }
                                                    
                                                    subChildNode.getProperty("default_eids").remove();
                                                    subChildNode.save();
                                                    
                                                    if(null != defaultUsers) {
                                                        subChildNode.setProperty("default_eids",(String[])defaultUsers.toArray(new String[0]));
                                                        subChildNode.save();
                                                        subChildNode.refresh(true); 
                                                    }
                                                } 
                                            } 
                                        }
                                    }
                                }
                            } 
            
                            //setting values in bean
                            mailData.setMailAction(CommentsConstants.EMAIL_UNSUBSCRIBE_ACTION);  
                            mailData.setMailTo(eid);                  
                            mailData.setPageTitle(page.getTitle());
                            mailData.setCommentSubscribeURL(propertyNode.getProperty(CommentsConstants.REFERER).getValue().getString());
                            
                                    //if(isMaster){
                                        System.out.println("************** Hi This is master instance from where unsubscribe email is going **************");
                                        EmailManager mailManager = new EmailManager(sling, resourceResolver); 
                                        mailManager.sendMail(mailData);
                                    /*}
                                    else{
                                        System.out.println("************** Hi This is slave instance from where unsubscribe email is not going **************");
                                    } */  
                            
                            //removing the unsubscribedUser property 
                            propertyNode.getProperty(CommentsConstants.UNSUBSCRIBE_USER_PROPERTY).remove(); 
                            observationSession.save(); 
                        }                    
                    } 
                }               
            } 
        }catch(Exception e)
        {               
            log.error("[onEvent()] Exception during Event Handling of Page Commenting Email Sender Notification Service: ",e);
        }
    }
    
    /*protected void unbindRepository(SlingRepository repository) {
        log.info("[unbindRepository()] Unbinding Repository for Page Commenting Email Sender Notification Service");
        if(this.repository == repository) {
            repository = null;
        }
    } */ 
    
	/**
     * This method initializes the SlingRepository Object.
     * @param repository
     */
    protected void bindRepository(SlingRepository repository)
    {
        this.repository = repository;
    }
    /**
     * This method sets the value of SlingRepository Object to NULL.
     * @param repository
     */
    protected void unbindRepository(SlingRepository repository)
    {
        if(this.repository == repository)
        {
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