package com.mcd.cq.caching;

import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.servlets.SlingSafeMethodsServlet;
import org.apache.sling.jcr.api.SlingRepository;
import org.apache.jackrabbit.JcrConstants;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import javax.servlet.Servlet;
import javax.jcr.Session;
import javax.jcr.SimpleCredentials;
import javax.jcr.Node;
import javax.jcr.RepositoryException;
import javax.jcr.PathNotFoundException;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;

@Component(immediate=true,metatype=false)
@Service(Servlet.class)
@Properties({
    @Property( name="service.description",value="MCD Secure Cache"),
    @Property( name="service.vendor",value="MCD"),
    @Property(name = "sling.servlet.paths", value="/etc/secureservlet")
})

public class PermissionHeadServlet extends SlingSafeMethodsServlet {        
    
    private static final Logger log = LoggerFactory.getLogger(PermissionHeadServlet.class);    

    /** @scr.reference */
    private SlingRepository repository;

    public void doHead(SlingHttpServletRequest request, SlingHttpServletResponse response) {        
        String pageUrl = request.getParameter("uri");   

        //String userID = request.getHeader("sm_user");
        //log.info("PermissionHeadServlet:remoteUser:"+request.getRemoteUser());
        String userID = request.getRemoteUser();
     
        boolean hasAccess = false; 
        try {   
            //log.info("PermissionHeadServlet verify user " + userID + " permissions to access page " +  pageUrl);
            pageUrl = parseUrl(pageUrl);
            hasAccess = hasReadAccess(pageUrl, userID);
        } catch (Exception e) {
            log.error("PermissionHeadServlet.doHead Exception " + e.getMessage());
        }
        if (hasAccess) { 
            //log.info("PermissionHeadServlet: OK");           
            response.setStatus(SlingHttpServletResponse.SC_OK);        
        } else {            
            //log.info("PermissionHeadServlet: Unauthorized");           
            response.setStatus(SlingHttpServletResponse.SC_UNAUTHORIZED);        
        }    
    }
    
    private boolean hasReadAccess(String pageUrl, String userID) {                        
        log.info("PermissionHeadServlet.hasReadAcess() " + pageUrl + " userid " + userID);
        Session adminSession = null;
        Session userSession = null;
        try{
            adminSession = repository.loginAdministrative(null); 
            userSession = adminSession.impersonate(new SimpleCredentials(userID,"".toCharArray()));
            //log.info("PermissionHeadServlet.hasReadAcess: impersonate user " + userSession.getUserID());
            Node root = userSession.getRootNode();
            //log.info("PermissionHeadServlet.hasReadAcess: root node " + root);
            repository.getDefaultWorkspace();
            String contentNode = "content/";
            if(!contentNode.equalsIgnoreCase(pageUrl.substring(0,8))){
                pageUrl = contentNode+pageUrl;
            }
            //log.info("PermissionHeadServlet.hasReadAcess: relPath " + pageUrl);
            Node pageNode = root.getNode(pageUrl);
            //log.info("PermissionHeadServlet.hasReadAcess: PageNode " + pageNode);
            String path = pageNode.getPath();
            //log.info("PermissionHeadServlet.hasReadAcess: PageNode path " + path);
            userSession.checkPermission(path, "read");
            if(pageNode.hasNode(JcrConstants.JCR_CONTENT)) {
                String contentNodePath = path + "/" + "jcr:content";
                userSession.checkPermission(contentNodePath, "read");
            }
         }catch(PathNotFoundException e){
             log.error("PermissionHeadServlet.hasReadAccess: PathNotFoundException " + e.getMessage());
             return false;
         }catch(RepositoryException re){
             log.error("PermissionHeadServlet.hasReadAccess: RepositoryException " + re.getMessage());
             return false;
         }catch(java.security.AccessControlException e) {
             log.error("PermissionHeadServlet.hasReadAccess: AccessControlException " + e.getMessage());
             return false;
         } finally {
            userSession.logout();
            adminSession.logout();
         }
         return true;    
    }    
        
    /*
     * @param pageUrl
     */
    private String parseUrl(String pageUrl){
        try {
            pageUrl = pageUrl.substring(1, pageUrl.length());
            int periodIndex = pageUrl.indexOf(".");
            pageUrl = pageUrl.substring(0,periodIndex);
        } catch(Exception e){
            log.error("PermissionHeadServlet.parseUrl Exception " + e.getMessage());
        }
        return pageUrl;
    }
             
}