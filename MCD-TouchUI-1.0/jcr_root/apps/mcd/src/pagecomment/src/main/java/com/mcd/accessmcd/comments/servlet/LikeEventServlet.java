/*
 * Project: AccessMCD
 *
 * @(#)CommentingEventServlet.java
 * Revisions:
 * Date            Programmer           Description
 * --------------------------------------------------------------------------------------------
 * 27,April 2011   HCL                  This Servlet Class calls the methods to create,
 *                                      subscribe and unsubscribe the user to/from the comment.
 * --------------------------------------------------------------------------------------------
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
 
package com.mcd.accessmcd.comments.servlet;

import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.text.DateFormat;
import java.util.TimeZone;
import java.util.Locale;
import java.util.Map;
import javax.jcr.Node;
import javax.jcr.Session;
import javax.jcr.*;
import javax.servlet.ServletException;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.servlets.SlingAllMethodsServlet;
import org.apache.sling.jcr.api.SlingRepository;
import org.apache.sling.jcr.resource.JcrResourceResolverFactory;
import org.osgi.service.component.ComponentContext;
import org.osgi.framework.BundleContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.sling.runmode.RunMode; 
import com.mcd.accessmcd.comments.util.NodeUtility; 
import com.mcd.accessmcd.comments.constants.CommentsConstants;
import com.mcd.accessmcd.comments.util.PropertiesLoader;
import com.mcd.accessmcd.comments.util.UserDetails;
import com.mcd.accessmcd.comments.util.CommonUtilities;
import com.day.cq.commons.jcr.JcrUtil;
import javax.jcr.Value; 
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.net.URLDecoder; 
import com.day.cq.security.User;
import javax.servlet.Servlet;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;


@Component(immediate=true,metatype=false)
@Service(Servlet.class)
@Properties({
    @Property( name="service.description",value="Calendar Servlet"),
    @Property( name="service.vendor",value="MCD"),
    @Property(name = "sling.servlet.resourceTypes", value={ "mcd/components/content/pagecommenting","mcd/components/content/pagecommenting/replies" }),
    @Property(name = "sling.servlet.selectors", value="likeComments"),
    @Property(name = "sling.servlet.methods", value="POST")
})

@SuppressWarnings("serial")
public class LikeEventServlet extends SlingAllMethodsServlet
{
    /**
     * default logger
     */        
    private static final Logger log = LoggerFactory.getLogger(LikeEventServlet.class);
    
    @Reference
    private RunMode runMode;
          
    @Reference
    private SlingRepository repository;
    private BundleContext bundleContext;
    
    @Reference 
    private JcrResourceResolverFactory resolverFactory;
    
    NodeUtility nodeUtility;    
    protected Session session = null;
    private ResourceResolver resourceResolver = null;
    
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
     * This method is called when the bundle for this service is removed from the CRX.
     * @param context
     */
    protected void deactivate(ComponentContext context)
    {
        if(session != null)
                session.logout(); 
                session = null;
    }
     
    /**
     * The doPost method of the servlet. <br>
     *
     * This method is called when a form has its tag value method equals to post.
     * 
     * @param request the request send by the client to the server
     * @param response the response send by the server to the client
     * @throws ServletException if an error occurred
     * @throws IOException if an error occurred
     */
    @Override
    public void doPost(SlingHttpServletRequest request, SlingHttpServletResponse response) throws ServletException, IOException
    {
        boolean hasPermission = false;
        String redirectUrl = null;
        Resource resource = null;
        String resourcePath = null;
        String contentType = null;
        
        try{
            session = repository.loginAdministrative(null);
            log.info("****** Session Object ****** ::: " + session ); 
            resourceResolver = resolverFactory.getResourceResolver(session); 
            log.info("****** ResourceResolver Object ****** ::: " + resourceResolver );
             
            resource = resourceResolver.getResource(request.getResource().getPath());
            resourcePath = resource.getPath();
            log.error("********************** Resource Path ::::::::::::::: " + resourcePath);
            if (resource != null)
            {
                try
                {
                    if(session == null)
                    {
                        log.error("[doPost()] session is null");
                        hasPermission = false;
                    }
                    session.checkPermission((PropertiesLoader.getProperty(CommentsConstants.COMMENT_PAGE_PATH)) + (CommentsConstants.ADD_NODE_PATH) + (System.currentTimeMillis()), CommentsConstants.ADD_NODE);
                    hasPermission = true;
                }
                catch(Exception e)
                {
                    log.error("[doPost()] "+(("user '") + (session.getUserID()) + ("' not allowed to add nodes under ")+ (CommentsConstants.COMMENT_PAGE_PATH)), e);
                    hasPermission = false;
                }
            }
            
            if (hasPermission)
            {
                log.info("***************************INSIDE SERVLET******************************");
                nodeUtility = new NodeUtility(resource);
                String[] selectors = request.getRequestPathInfo().getSelectors();
                log.info("[doPost()] selectors[0]: "+selectors[0]);
                if(null != selectors)
                {
                    if(selectors[0].equalsIgnoreCase(CommentsConstants. SELECTOR_LIKE_COMMENT))
                    {
                        String[] returnVal = likeComments(request);
                        contentType = returnVal[0];
                        redirectUrl = returnVal[1];
                    }
                    
                }
            } 
            else 
            {
                redirectUrl = resourcePath;
                contentType = "url"; 
            }
        }
        catch(Exception ex){
            log.error("***** Error in CommentingEventingServlet doPost method *****",ex);
        }
        finally{
            if(session != null)
                session.logout();
                session = null;
                
        }  
        if("content".equals(contentType)) {
            response.setContentType("text/html; charset=UTF-8");
            response.setStatus(200);
            PrintWriter out = response.getWriter();
            out.println(redirectUrl);
        } else {
            response.sendRedirect(redirectUrl.replace("/content/","/"));
        }
        
    }

    /**
     * This method is called when a user creates a comment on a page.
     * @param request
     * @param response
     */
    public String[] likeComments(SlingHttpServletRequest request) throws IOException
    {
    
        log.error("********************INSIDE like COMMENT***********************");
        
        final User user = request.getResourceResolver().adaptTo(User.class);//instantiate User object
        String authorId = user.getID();
        Node likeNode;
        long likeCount=0;
        boolean value=false;
        String  pauth=CommentsConstants.BLANK;
        String redirectUrl = (request.getHeader("Referer").indexOf("?")==-1)? request.getHeader("Referer") : request.getHeader("Referer").substring(0,request.getHeader("Referer").indexOf("?"));
        String nodeContent = CommentsConstants.BLANK;
        log.error("request.getHeader(CommentsConstants.REQUEST_REFERER---1111111111---->"+request.getHeader(CommentsConstants.REQUEST_REFERER));
        try
        {
                                
            log.error("[addComment()] Comment Author: "+authorId);
            
            String path = CommentsConstants.BLANK;
            if (request.getParameter("path") != null)
            {
                path = (String)request.getParameter("path");
            }
             Node pageNode = resourceResolver.getResource(path).adaptTo(Node.class);       
                       
             String nodeName = "like";
                       
            if(!pageNode.hasNode(JcrUtil.createValidName(nodeName)))                  
            {
            log.error("inside if condition----> "+JcrUtil.createValidName(nodeName));
             likeNode = pageNode.addNode(JcrUtil.createValidName(nodeName), CommentsConstants.COMMENT_NODE_TYPE);
                     
                if(likeNode!= null)
                 {   
                    log.error("New Node created properties not set");   
                    likeCount=likeCount+1;              
                    likeNode.setProperty(CommentsConstants.PROP_ADDED, Calendar.getInstance()); 
                    likeNode.setProperty(CommentsConstants.SLING_RES_TYPE, PropertiesLoader.getProperty(CommentsConstants.LIKE_COMPONENT_PATH));
                    likeNode.setProperty(CommentsConstants.LIKE_IDENTIFIER, authorId);
                    likeNode.setProperty(CommentsConstants.LIKE_COUNT, likeCount);
                    log.error("******************** Setting Node Properties ---------------------- " + likeNode);
                    likeNode.setProperty(CommentsConstants.CQ_DISTRIBUTE, true); 
                    log.error("****************** Getting Referrer -------------------- " + request.getHeader(CommentsConstants.REQUEST_REFERER));
                    likeNode.setProperty(CommentsConstants.REFERER, request.getHeader(CommentsConstants.REQUEST_REFERER));
                    log.error("****************** Getting RootNode -------------------- " + nodeUtility.getRootNode());
                    //pageNode.save();
                    Node content = nodeUtility.getRootNode().getParent();
                    content.setProperty(CommentsConstants.PROP_LAST_MODIFIED, Calendar.getInstance());
                    content.setProperty(CommentsConstants.PROP_LAST_MODIFIED_BY, content.getSession().getUserID());
                    //content.setProperty(CommentsConstants.CQ_DISTRIBUTE, true);
                    //content.save();
                    
                }
                else
                {
                    log.error("[createComment()] Failed to create Node.");
                    return new String[]{"url",redirectUrl};
                }
           }
           else if(pageNode.hasNode("like"))
            {
                  log.error("if Node Exists----------->"+pageNode.getName());
                  likeNode= pageNode.getNode("like");
                  log.error("Nodeiii---->"+likeNode.getPath());   
                  if(likeNode.getName().equals("like"))
                  {     log.error("Node is equal to like");        
                      if(likeNode.hasProperty(CommentsConstants.LIKE_IDENTIFIER)&& likeNode.hasProperty(CommentsConstants.LIKE_COUNT))
                      {     log.error("likeIdentifier"+likeNode.getPath());
                            pauth = likeNode.getProperty(CommentsConstants.LIKE_IDENTIFIER).getString(); 
                            log.error("author Name-------"+pauth);
                            likeCount = likeNode.getProperty(CommentsConstants.LIKE_COUNT).getLong();
                            log.error("like Count----------"+likeCount);
                            if(pauth.contains(","))
                            {
                                String [] allauth=pauth.split(",");
                                for(String gp:allauth)                            
                                { 
                                    if(authorId.trim().equalsIgnoreCase(gp))
                                    {
                                        //commentNode.setProperty(CommentsConstants.LIKE_COUNT, likeCount);
                                        value=true;
                                        break;
                                    }                            
                                }
            
                                if(!value)
                                {
                                    String pauthList=likeNode.getProperty(CommentsConstants.LIKE_IDENTIFIER).getString();
                                    long likeCountNum = likeNode.getProperty(CommentsConstants.LIKE_COUNT).getLong();
                                    Node parentNode = likeNode.getParent();
                                    likeNode.remove();
                                    parentNode.save();
                                    Node test= pageNode.addNode("like", CommentsConstants.COMMENT_NODE_TYPE);
                                    pauth=pauthList+","+authorId.trim();
                                    test.setProperty(CommentsConstants.LIKE_IDENTIFIER, pauth);
                                    likeCount=likeCountNum+1;
                                    test.setProperty(CommentsConstants.LIKE_COUNT, likeCount);
                                    test.setProperty(CommentsConstants.PROP_ADDED, Calendar.getInstance()); 
                                    test.setProperty(CommentsConstants.SLING_RES_TYPE, PropertiesLoader.getProperty(CommentsConstants.LIKE_COMPONENT_PATH)); 
                                    test.setProperty(CommentsConstants.CQ_DISTRIBUTE, true);
                                    test.setProperty(CommentsConstants.PROP_LAST_MODIFIED, Calendar.getInstance());
                                    test.setProperty(CommentsConstants.PROP_LAST_MODIFIED_BY, test.getSession().getUserID());
                                    Node test1 = nodeUtility.getRootNode().getParent();
                                    log.error("Parent h------>"+test1.getPath());
                                    test1.setProperty(CommentsConstants.PROP_LAST_MODIFIED, Calendar.getInstance());
                                    test1.setProperty(CommentsConstants.PROP_LAST_MODIFIED_BY, test1.getSession().getUserID());
                                    //test1.setProperty(CommentsConstants.CQ_DISTRIBUTE, true);
                                    //pageNode.save();
                                    //test1.save();
                                }  
                            } 
                            else
                            {
                                if(pauth.trim().equalsIgnoreCase(authorId))
                                {
                                    log.error("nodeID is same");
                                    //commentNode.setProperty(CommentsConstants.LIKE_COUNT, likeCount);
                                    value=true;
                                }
                                else
                                {
                                    String pauthLists=likeNode.getProperty(CommentsConstants.LIKE_IDENTIFIER).getString();
                                    long likeCountNums = likeNode.getProperty(CommentsConstants.LIKE_COUNT).getLong();
                                    Node parentNode = likeNode.getParent();
                                    likeNode.remove();log.error("Node Removed");
                                    parentNode.save();
                                    log.error("Node Saved---"+parentNode.getPath());
                                    Node test= pageNode.addNode("like", CommentsConstants.COMMENT_NODE_TYPE);
                                    log.error("-------------addNode------------------>"+test.getPath()+"NOdetype----->"+CommentsConstants.COMMENT_NODE_TYPE);
                                    log.error("************************AUTHLIST******************"+pauthLists);
                                    pauth=pauthLists+","+authorId.trim();
                                    test.setProperty(CommentsConstants.LIKE_IDENTIFIER, pauth);
                                    likeCount=likeCountNums+1;
                                    test.setProperty(CommentsConstants.LIKE_COUNT, likeCount);
                                    test.setProperty(CommentsConstants.PROP_ADDED, Calendar.getInstance()); 
                                    test.setProperty(CommentsConstants.SLING_RES_TYPE, PropertiesLoader.getProperty(CommentsConstants.LIKE_COMPONENT_PATH)); 
                                    test.setProperty(CommentsConstants.CQ_DISTRIBUTE, true);
                                    test.setProperty(CommentsConstants.PROP_LAST_MODIFIED, Calendar.getInstance());
                                    test.setProperty(CommentsConstants.PROP_LAST_MODIFIED_BY, test.getSession().getUserID());
                                    Node test1 = nodeUtility.getRootNode().getParent();
                                    log.error("Parent h------>"+test1.getPath());
                                    test1.setProperty(CommentsConstants.PROP_LAST_MODIFIED, Calendar.getInstance());
                                    test1.setProperty(CommentsConstants.PROP_LAST_MODIFIED_BY, test1.getSession().getUserID());
                                    //test1.setProperty(CommentsConstants.CQ_DISTRIBUTE, true);
                                    value=false;
                                    //pageNode.save();
                                    //test1.save();
                                }     
                            }
                      }
                      else 
                        { 
                            value=false;
                            likeNode.setProperty(CommentsConstants.LIKE_IDENTIFIER, authorId);
                            likeCount=likeCount+1;
                            likeNode.setProperty(CommentsConstants.LIKE_COUNT, likeCount);
                            likeNode.setProperty(CommentsConstants.PROP_ADDED, Calendar.getInstance()); 
                            likeNode.setProperty(CommentsConstants.SLING_RES_TYPE, PropertiesLoader.getProperty(CommentsConstants.LIKE_COMPONENT_PATH)); 
                            likeNode.setProperty(CommentsConstants.CQ_DISTRIBUTE, true);
                            likeNode.setProperty(CommentsConstants.PROP_LAST_MODIFIED, Calendar.getInstance());
                            likeNode.setProperty(CommentsConstants.PROP_LAST_MODIFIED_BY, likeNode.getSession().getUserID());
                            //likeNode.getParent().save();
                        }   
                  }else{//do nothing
                  }
                
               
            }
            
            session.save();
        }
        catch (Exception e)
        {
            log.error("addComment failed to add the comment ", e);
            return new String[]{"url",redirectUrl};
        }
        
        log.error("******************* like Added Successfully* ************************* ");
        return new String[]{"content",Long.toString(likeCount)};
    }
     
 
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
 