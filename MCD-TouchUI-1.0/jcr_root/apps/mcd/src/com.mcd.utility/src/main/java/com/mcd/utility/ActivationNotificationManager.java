package com.mcd.utility;

import org.osgi.service.event.Event;
import org.osgi.service.event.EventHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.day.cq.replication.Replicator;
import com.day.cq.replication.ReplicationAction;
import org.osgi.framework.BundleContext;
import org.osgi.service.component.ComponentContext;
import org.apache.sling.scripting.core.ScriptHelper;
import com.day.cq.wcm.api.Page;
import com.day.cq.wcm.api.PageManager;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.jcr.api.SlingRepository;
import javax.jcr.Session;
import org.apache.sling.jcr.resource.JcrResourceResolverFactory;
import org.apache.sling.event.JobProcessor;
import org.apache.sling.event.EventUtil;
import org.osgi.service.event.EventConstants;
import org.apache.sling.runmode.RunMode;
import com.day.cq.security.profile.Profile;
import com.mcd.utility.Processor;
import com.mcd.utility.PropertiesLoader;
import javax.jcr.Node;
import com.mcd.utility.ClearCache;
import com.mcd.utility.MailNotification;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;


@Component(immediate = true,metatype=false)
@Service
@Properties({
    	@Property( name="service.description",value="ActivationNotificationManager"),
   	 	@Property( name="service.vendor",value="MCD"),
        @Property( name = EventConstants.EVENT_TOPIC, value = ReplicationAction.EVENT_TOPIC),
        @Property( name="run.modes",value="author")
})


public class ActivationNotificationManager implements EventHandler,JobProcessor
{   

    /**
     * default logger
     */        
    private static final Logger log = LoggerFactory.getLogger(ActivationNotificationManager.class);
    
    @Reference
    private RunMode runMode;
           
    @Reference
    private SlingRepository repository;

    private ComponentContext ctx;
    private BundleContext bundleContext;
    
    @Reference 
    private JcrResourceResolverFactory resolverFactory;
    
    
    private static Session session;
    Profile userProfile = null;
        
    protected void activate(ComponentContext ctx)
    {   
        this.ctx = ctx;
        bundleContext = this.ctx.getBundleContext();
        log.error("******* Inside Activate Bundle Context ****** ::: " + bundleContext );
    }
   
    public void handleEvent(Event event)
    {
        if(EventUtil.isLocal(event))
            EventUtil.processJob(event, this);
    } 
    
     
    public boolean process(Event event)
    {
        ReplicationAction replication = ReplicationAction.fromEvent(event);
        MailNotification mailnotification = new MailNotification();
        log.error("************************* replication path ***************************:: " + replication.getPath());    
        if(replication!=null && "ACTIVATE".equalsIgnoreCase(replication.getType().getName()))   
        {
            if(replication.getPath().indexOf("/assets_page/")!=-1 && replication.getPath().indexOf("/content/")!=-1)
            {
                try
                {                 
                
                    ScriptHelper sling = new ScriptHelper(bundleContext, null);                     
                    session = repository.loginAdministrative(null); 
                    ResourceResolver resourceResolver = resolverFactory.getResourceResolver(session); 
                    PageManager pageManager=resourceResolver.adaptTo(PageManager.class);
                    Page page = pageManager.getPage(replication.getPath());
                    log.error("************************* replication path :: " + replication.getPath()); 
                    Node docRootNode = null;
                    docRootNode = resourceResolver.getResource(replication.getPath()+"/jcr:content/flashutility")!=null ? resourceResolver.getResource(replication.getPath()+"/jcr:content/flashutility").adaptTo(Node.class) : null ;
                    
                    if(docRootNode != null)
                    {
                        if(docRootNode.hasProperty("docroot_path"))
                        {
                            if(!"".equals(docRootNode.getProperty("docroot_path").getValue().getString()))
                            {
                                //Properties prop = PropertiesLoader.loadProperties("/local2/app/day/cq-5.3/dep_auth_dev_53/crx-quickstart/flashutility.properties");
                                //log.error("***************Properties Value**********************" + prop.getProperty("cachePath_"+page.getAbsoluteParent(1).getName())); 
   
                                //activate docroot
                                Replicator repl = sling.getService(Replicator.class);
                                Processor p = new Processor(repl, resourceResolver, sling);
                                p.process(docRootNode.getProperty("docroot_path").getValue().getString());
                                
                                //clear cache
                                /* ClearCache clearCache=new ClearCache();
                                clearCache.deleteCacheFolder("/local2/apache/www3.development.mcdonalds.com/dispcache/flash_component_url");
                                clearCache.deleteCacheFolder("/local2/apache/www3.development.mcdonalds.com/dispcache/flash_component_url"); */

                            }
                             
                        }
                    }                  
                }//end try block
                catch(Exception e)
                {   
                    log.error("************Exception caught in FlashUtility ActivationNotificationManager********* ::::" + e);
                    mailnotification.sendExceptionEmail(e);
                   
                } finally {
                    if(null != session)
                        session.logout();
                }
                
            }
        }// end outermost if
        return true;
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
        log.error("********** Inside UnBindRepository **********");
        if (session.isLive())
                    session.logout();       
        session = null;
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