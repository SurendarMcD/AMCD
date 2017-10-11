package com.mcd.accessmcd.comments.pageevent;

import org.osgi.service.event.Event;
import org.osgi.service.event.EventHandler;
import org.apache.sling.event.EventUtil;
import org.apache.sling.runmode.RunMode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.wcm.api.Page;
import com.day.cq.wcm.api.PageManager;
import com.day.cq.wcm.api.PageEvent;
import org.apache.sling.event.JobProcessor;
import com.day.cq.wcm.api.PageModification;
import com.day.cq.wcm.api.PageModification.ModificationType;
import com.day.cq.commons.jcr.JcrUtil;
import com.day.cq.commons.RunModeUtil; 
import com.day.text.Text;
import org.osgi.service.event.EventConstants;
import org.osgi.service.component.ComponentContext;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.jcr.api.SlingRepository;
import javax.jcr.Session;
import org.apache.sling.jcr.resource.JcrResourceResolverFactory;
import javax.jcr.Node;
import javax.jcr.RepositoryException;

import java.util.Iterator;
import java.util.StringTokenizer;

import com.mcd.accessmcd.comments.constants.CommentsConstants;
import com.mcd.accessmcd.comments.util.PropertiesLoader;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;


@Component(immediate = true,metatype=false)
@Service
@Properties({
    	@Property( name="service.description",value="TrackPageActivities"),
   	 	@Property( name="service.vendor",value="MCD"),
        @Property( name = EventConstants.EVENT_TOPIC, value = PageEvent.EVENT_TOPIC),
        @Property( name="run.modes",value={"author",""})
})    


public class TrackPageActivities implements EventHandler,JobProcessor
{   
 
    /**
     * default logger
     */        
    private static final Logger log = LoggerFactory.getLogger(TrackPageActivities.class);
    
    @Reference
    private RunMode runMode;
          
    @Reference
    private SlingRepository repository;
    
    @Reference
    private JcrResourceResolverFactory resolverFactory;
    
    private static Session session = null;
    boolean enabled;
        
    protected void activate(ComponentContext ctx)
    {   
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
    
    public boolean process(Event event) {
        final PageEvent pageEvent = PageEvent.fromEvent(event);
        log.error("*************** Inside Track Page Activities Process Job ******************");
        if(pageEvent != null) {
            try {
                session = repository.loginAdministrative(null); 
                ResourceResolver resourceResolver = resolverFactory.getResourceResolver(session); 
                PageManager pageManager = resourceResolver.adaptTo(PageManager.class);
                
                final Iterator<PageModification> i = pageEvent.getModifications();
                while(i.hasNext()) {
                    final PageModification pm = i.next();
                    if(!(pm.getPath().startsWith(PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH))) ){
                        if(ModificationType.DELETED == pm.getType()){
                            Page deletedPageComment = pageManager.getPage(PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH) + pm.getPath());
                            log.error("*************** Deleted Page :::: " + pm.getPath());
                            if(null != deletedPageComment){
                                pageManager.delete(deletedPageComment,false); 
                                log.info("***** Comment has been deleted successfully *****"); 
                            }
                            
                        }
                    }   
                    if(ModificationType.MOVED == pm.getType()){
                        String subscriberPagePath = "";
                        Page movedSubscriberPage = null;
                        Page movedPageComment = pageManager.getPage(PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH)+pm.getPath()); 
                        log.error("*************** Moved Page :::: " + pm.getPath());
                        if(null != movedPageComment){
                            Page movedPageDest = pageManager.getPage(Text.getRelativeParent(PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH) + pm.getDestination(), 1));
                            subscriberPagePath = movedPageComment.getName();
                            if(null != movedPageDest){
                                pageManager.move(movedPageComment,PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH)+pm.getDestination(),null,false,true,null); 
                                subscriberPagePath =PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH)+pm.getDestination() + "/" + subscriberPagePath + "_pagecommenting";
                                log.error("************************* Subscriber Path :::::::::::::::: " + subscriberPagePath); 
                                movedSubscriberPage = pageManager.getPage(subscriberPagePath);
                                subscriberPagePath = PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH)+pm.getDestination()+pm.getDestination().substring(pm.getDestination().lastIndexOf("/"))+"_pagecommenting";
                                log.error("************************* New Subscriber Path :::::::::::::::: " + subscriberPagePath);
                                pageManager.move(movedSubscriberPage,subscriberPagePath,null,false,true,null);
                                log.info("***** Comment has been moved successfully *****");
                            }
                            else{
                                String ugcPagePath = PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH);
                                StringTokenizer pathElems = new StringTokenizer(Text.getRelativeParent(pm.getDestination(), 1), CommentsConstants.SLASH);
                                  
                                do
                                {
                                    if(!pathElems.hasMoreTokens()){
                                        break;
                                    }
                                    
                                    ugcPagePath = (new StringBuilder()).append(ugcPagePath).append(CommentsConstants.SLASH).append(pathElems.nextToken()).toString();
                                    if(resourceResolver.getResource(ugcPagePath) == null){
                                        if(ugcPagePath.equals(PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH) + CommentsConstants.SLASH + CommentsConstants.CONTENT)){
                                            try
                                            {
                                                createNode(ugcPagePath, CommentsConstants.SLING_FOLDER,session);
                                                save(session);
                                            }
                                            catch(Exception e)
                                            {
                                                log.error("failed to prepare user generated content", e);
                                            }
                                        }
                                        else{
                                            try
                                            {
                                                createPage(ugcPagePath, null, null, null,resourceResolver,session);
                                            }
                                            catch(Exception ce)
                                            {
                                                log.error("failed to prepare user generated content", ce); 
                                            }
                                        }
                                    }
                                } 
                                while(true);  
                                log.info("****** After Preparing Move Page *****");  
                                pageManager.move(movedPageComment,PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH)+pm.getDestination(),null,false,true,null);
                                subscriberPagePath =PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH)+pm.getDestination() + "/" + movedPageComment.getName() + "_pagecommenting";
                                movedSubscriberPage = pageManager.getPage(subscriberPagePath);
                                subscriberPagePath = PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH)+pm.getDestination()+pm.getDestination().substring(pm.getDestination().lastIndexOf("/"))+"_pagecommenting";
                                log.error("************************* New Subscriber Path :::::::::::::::: " + subscriberPagePath);
                                pageManager.move(movedSubscriberPage,subscriberPagePath,null,false,true,null);
                                log.info("***** Comment has been moved successfully after preparing user generated content *****");
                            }
                        } 
                    }
                }  
              session.logout();
              session = null;
            }
            catch(Exception e){
                log.error("Exception caught TrackPageActivities::::", e);
            }
            finally{
                if(session!=null)
                session.logout();
            }
        }
        return true;
    }
    
    public Page createPage(String path, String template, String resourceType, String title,ResourceResolver resourceResolver,Session session){
        String parentPath = Text.getRelativeParent(path, 1);
        String name = Text.getName(path);
        return createPage(parentPath, name, template, resourceType, title,resourceResolver,session);
    }

    public Page createPage(String parentPath, String name, String template, String resourceType, String title,ResourceResolver resourceResolver,Session session){
        Page page;
        
        try {
            if(resourceResolver.getResource(parentPath) == null){
                createNode(parentPath, CommentsConstants.GENERAL_NODE_TYPE,session);
                save(session);
            }
             
            page = ((PageManager)resourceResolver.adaptTo(PageManager.class)).create(parentPath, JcrUtil.createValidName(name), template, title);
            ((Node)page.getContentResource().adaptTo(Node.class)).setProperty(CommentsConstants.SLING_RES_TYPE, resourceType);
            
            return page;
        } catch(Exception e){
            log.error("failed to create page when moving comment", e);
            return null;
        }
    }
    
    public Node createNode(String path, String nodeType,Session session){
        try
        {
            if(path.startsWith(CommentsConstants.SLASH)){
                path = path.substring(1);
            }
            Node node;
            Node root = session.getRootNode();
            for(StringTokenizer names = new StringTokenizer(Text.getRelativeParent(path, 1), CommentsConstants.SLASH); names.hasMoreTokens();){
                String name = names.nextToken();
                
                if(!root.hasNode(name))
                {
                    root.addNode(name);
                }
                root = root.getNode(name);
            }
            
            node = root.addNode(Text.getName(path), nodeType);
            return node;
        }
        catch (Exception e)
        {
            log.error("Failed to create node when moving comment",e);
            return null;
        }
    }
    
    public void save(Session session)
    {
        //Session session = (Session)resourceResolver.adaptTo(Session.class);
        if(session == null){
            throw new IllegalArgumentException("resolver must be adaptable to session");
        }
        try
        {
            session.save();
        }
        catch(RepositoryException re)
        {
            re.printStackTrace();
            log.error("failed to save changes when moving comment", re);
        }
    }
    
     
    protected void bindRunMode(RunMode runmode)
    {
        runMode = runmode;        
    }

    protected void unbindRunMode(RunMode runmode)
    {
        if(this.runMode == runmode)
            runMode = null;
    }
       
    protected void bindRepository(SlingRepository repository)
    {
        this.repository = repository;
            
    }   
    protected void unbindRepository(SlingRepository repository)
    {       
        if(this.repository == repository)
        {
            repository = null;
        }  
        if (session!=null && session.isLive())
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
