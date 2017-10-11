 /* World of Good JSON Replicate
* Servlet to replicate world of good json to publish
*
* HCL
*
*/

package com.mcd.accessmcd.wog;


import javax.servlet.ServletException;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.servlets.SlingAllMethodsServlet;
import org.apache.sling.jcr.api.SlingRepository;
import java.io.*;
import java.util.*;
import com.day.commons.datasource.poolservice.DataSourcePool; 
import javax.jcr.Session;
import javax.jcr.Node;
import org.apache.sling.jcr.resource.JcrResourceResolverFactory;
import org.apache.sling.api.resource.ResourceResolver;   
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;   
import org.apache.sling.runmode.RunMode;
import org.apache.sling.api.scripting.SlingScriptHelper;
import org.apache.sling.scripting.core.ScriptHelper;
import org.osgi.framework.BundleContext;
import org.osgi.service.component.ComponentContext;
import com.day.cq.replication.Agent;
import com.day.cq.replication.AgentManager;
import com.day.cq.replication.ReplicationActionType;
import com.day.cq.replication.ReplicationQueue;
import com.day.cq.replication.Replicator;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.Servlet;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;


@Component(immediate=true,metatype=false)
@Service(Servlet.class)
@Properties({
    @Property( name="service.description",value="JSON Replicate Servlet"),
    @Property( name="service.vendor",value="MCD"),
    @Property(name = "sling.servlet.paths", value="/mcd/wog/jsonreplicate"),
    @Property(name = "sling.servlet.methods", value={ "GET","POST" })
})

@SuppressWarnings("serial")

public class JSONReplicateServlet extends SlingAllMethodsServlet {

    /**
     * default logger
     */        
    private static final Logger log = LoggerFactory.getLogger(JSONReplicateServlet.class);
         
    @Reference
    private SlingRepository repository;
    private BundleContext bundleContext;
    
    @Reference 
    private JcrResourceResolverFactory resolverFactory;
    
    protected Session session = null;
    Replicator replicator = null;
    
    /**
     * This method is called when the bundle for this service is deployed in the CRX.
     * @param context
     * @throws Exception
     */
    protected void activate(ComponentContext ctx) throws Exception
    {
        bundleContext = ctx.getBundleContext();
    }
    

    /**
     * The doGet method of the servlet. <br>
     *
     * This method is called when a form has its tag value method equals to post.
     * 
     * @param request the request send by the client to the server
     * @param response the response send by the server to the client
     * @throws ServletException if an error occurred
     * @throws IOException if an error occurred
     */
    @Override
    public void doGet(SlingHttpServletRequest request,SlingHttpServletResponse response) throws ServletException,IOException {
            
            
            try{
                PrintWriter out = response.getWriter();
                session = repository.loginAdministrative(null);
                ScriptHelper sling = new ScriptHelper(bundleContext, null);
                ResourceResolver resourceResolver = resolverFactory.getResourceResolver(session);
                
                    
                
                replicator = sling.getService(Replicator.class);
                String replicationStatus = replicateJSON(session,replicator,resourceResolver);
                out.println(replicationStatus);
                session.logout();
                session = null;
            }   
            catch(Exception ex){
                log.error("******* Exception Occured in World of Good JSON Do Get Method",ex);
            }
            finally{
                if(session!=null)session.logout();
                session = null;
            }
    }
    
    public String replicateJSON(Session repSession,Replicator jsonReplicator,ResourceResolver resourceResolver){
        try{
            /*Node wogJSONNode = null;
            wogJSONNode = resourceResolver.getResource("/apps/mcd/docroot/wog/worldofgood.json/jcr:content")!=null ? resourceResolver.getResource("/apps/mcd/docroot/wog/worldofgood.json/jcr:content").adaptTo(Node.class) : null ;
            if(wogJSONNode != null){ 
                log.error("********* WOG JSON Path ********* " + wogJSONNode.getName());
                log.error("********* WOG JSON Path ********* " + wogJSONNode.getPath());
                wogJSONNode.setProperty("cq:lastReplicated",Calendar.getInstance()); 
                wogJSONNode.save();
                wogJSONNode.refresh(true);   
            }*/
            jsonReplicator.replicate(repSession, ReplicationActionType.ACTIVATE,"/apps/mcd/docroot/wog/worldofgood.json"); 
            repSession.logout();
            repSession= null;       
            return "success";
        }
        catch(Exception ex){
            log.error("******* Exception Occured in World of Good JSON Replication",ex);
            return "fail";
        }
        finally{
            if(repSession!=null)repSession.logout();
            repSession = null;
        }    
    }
    protected void bindRepository(org.apache.sling.jcr.api.SlingRepository repository)
    {
        //log.error("********** Inside bindConfigAdmin **********");
        this.repository = repository;
            
    }   
    protected void unbindRepository(org.apache.sling.jcr.api.SlingRepository repository)
    {       
        //log.error("********** Inside unbindConfigAdmin **********");
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