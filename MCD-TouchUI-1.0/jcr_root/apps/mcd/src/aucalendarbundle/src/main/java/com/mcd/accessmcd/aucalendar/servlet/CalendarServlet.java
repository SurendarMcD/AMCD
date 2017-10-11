package com.mcd.accessmcd.aucalendar.servlet;

import javax.servlet.ServletException;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.servlets.SlingAllMethodsServlet;

import java.io.*;
import com.day.commons.datasource.poolservice.DataSourcePool; 

import javax.jcr.Session;
import org.apache.sling.jcr.resource.JcrResourceResolverFactory;
import org.apache.sling.api.resource.ResourceResolver;
import com.day.cq.security.profile.Profile;
import com.day.cq.security.User;

import com.mcd.accessmcd.aucalendar.bean.PostEntry;
import com.mcd.accessmcd.aucalendar.manager.AUCalendarManager;       
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;   
import java.util.UUID;
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
    @Property(name = "sling.servlet.paths", value="/mcd/accessmcd/aucalendar/servlet/CalendarServlet"),
    @Property(name = "sling.servlet.methods", value={ "GET","POST" })
})

@SuppressWarnings("serial")

/* AU Calendar InsertPost
* Servlet to insert dialog value into database
*
* Digvijay 02-15-2011
*
* moved to aucalendarbundle, com.mcd.accessmcd.aucalendar.servlet package 
* removed a bunch of comments/logging
* consolidated code
* Erik 03-15-2011
*/ 

public class CalendarServlet extends SlingAllMethodsServlet {

    @Reference
    private org.apache.sling.jcr.api.SlingRepository repository;
    
    @Reference
    private DataSourcePool dataSourceService;
 
    @Reference
    private JcrResourceResolverFactory resolverFactory;
      
    private static final Logger log = LoggerFactory.getLogger(CalendarServlet.class);

    private static final String CALENDAR_POST_TYPE = "1";
    private static final String NOTICEBOARD_POST_TYPE = "2";
   
    @Override

    protected void doGet(SlingHttpServletRequest request,SlingHttpServletResponse response) throws ServletException,IOException {
            log.debug("***** Inside Get Method *****");
            doPost(request,response);
    }


    @Override
    
    protected void doPost(SlingHttpServletRequest request,SlingHttpServletResponse response) throws ServletException,IOException {
            
            log.debug("********* Inside Post *********");
            
            String uuid = readParameter(request,"uuid");           
            String action = readParameter(request,"./action");            
            if(action.equals(""))action = readParameter(request,"action");   //delete is different
            
            Session session =null;
            try{
                session = repository.loginAdministrative(null);         
                AUCalendarManager auCalendarManager = new AUCalendarManager(dataSourceService,session);  
                
                if("delete".equals(action) || "edit".equals(action)){
                    //edits also require a delete
                    deletePostData(uuid,auCalendarManager);
                }
                if("insert".equals(action) || "edit".equals(action)){
                    ResourceResolver resourceResolver = resolverFactory.getResourceResolver(session);
                    Profile userProfile = resourceResolver.adaptTo(User.class).getProfile();
                    insertPostData(request, userProfile,auCalendarManager);
                }                                
            }   
            catch(Exception ex){}
            finally{
                if(session!=null)session.logout();
            }
              
            //return 'ok' to avoid javascript error
            response.setContentType("text/html");
            response.setStatus(200);
            PrintWriter out = response.getWriter();
            out.println("ok");
            
    } 
     
   
    private void insertPostData(SlingHttpServletRequest request, Profile userProfile,AUCalendarManager auCalendarManager){
             
            String postingDate = readParameter(request,"./postingDate");
            String title = readParameter(request,"./title");
            String description = readParameter(request,"./description");
            
            String audienceStaff = readParameter(request,"./audienceStaff");
            String linkStaff = readParameter(request,"./linkStaff");
            String displayStaff = readParameter(request,"./displayStaff");
            
            String audienceFranchiees = readParameter(request,"./audienceFranchiees");
            String linkFranchiees = readParameter(request,"./linkFranchiees");
            String displayFranchiees = readParameter(request,"./displayFranchiees");
            
            String viewAU = readParameter(request,"./viewAU");
            String viewNZ = readParameter(request,"./viewNZ");
             
            String view = viewAU;
            if(!viewAU.equals("") && !viewNZ.equals(""))
                view+=","+viewNZ;
            else
                view += viewNZ;
            if("".equals(view)) return;
            
            String postingType = readParameter(request,"./postingType");
            String categoryId = readParameter(request,"./categoryId");
            
            String prefix = readParameter(request,"./prefix");
            String prefixText = readParameter(request,"./prefixText");               
            
             try{          
                     PostEntry newPost = new PostEntry();
                     String[] postingDates = postingDate.split(",");
                     
                     //Fields common to all post types
                     newPost.setTitle(title);
                     newPost.setCategoryID(categoryId);
                     newPost.setViewID(view);
                     newPost.setActvFlag("1");
                                         
                     newPost.setInsUser(userProfile.getAuthorizable().getID()); 

                     //Additional Notice Board fields
                     if(NOTICEBOARD_POST_TYPE.equals(postingType)){
                          if("other".equalsIgnoreCase(prefixText)){
                              title = prefixText.toUpperCase() + "|" + title;
                          }
                          else{
                              //wei - changed ":" to "|"
                              title = prefix.toUpperCase() + "|" + title;    
                          } 
                          newPost.setTitle(title);
                     }
                     
                     //insert the posts for dates / audience types
                     for (int p=0; p<postingDates.length; p++){
                         String insertUUID = UUID.randomUUID().toString();
                         log.debug("Insert UUID : " + insertUUID);
                         newPost.setUUID(insertUUID);

                         newPost.setPubDate(postingDates[p]);
                         if(NOTICEBOARD_POST_TYPE.equals(postingType))
                             newPost.setPubDate(convertPostingDate(postingDates[p]));
                         if (!audienceStaff.equals("0")) {
                             newPost.setAudienceType(audienceStaff);
                             newPost.setDocURL(linkStaff);
                             newPost.setLaunchtype(displayStaff);
                             if(auCalendarManager.insertPost(newPost))
                                 log.debug("***** Data has been inserted for Notice Board Audience Staff *****");
                         }
                         if (!audienceFranchiees.equals("0")) {
                             newPost.setAudienceType(audienceFranchiees);
                             newPost.setDocURL(linkFranchiees);
                             newPost.setLaunchtype(displayFranchiees);
                             if(auCalendarManager.insertPost(newPost))
                                 log.debug("***** Data has been inserted for Notice Board Audience Staff *****");
                         }
                     }
                }
                catch(Exception ex){}
    } 
    
    private void deletePostData(String deleteUUID,AUCalendarManager auCalendarManager){
       
        try{    
            boolean theResult = auCalendarManager.deletePostByUUID(deleteUUID);
            if(true == theResult)
                log.debug("***** Data has been deleted for Notice Board-Calendar *****"); 
        }catch(Exception ex){ 
        }    
    }             
    
    private String convertPostingDate(String olddate){
        String[] postingDateSplit = olddate.split("/");
        String date = postingDateSplit[0];
        String month = postingDateSplit[1];
        String year = postingDateSplit[2];
        return year + "-" + month + "-" + date;
    }
        
    private String readParameter(SlingHttpServletRequest request, String parametername){
        String returnval="";
        if(request.getParameter(parametername)!=null){
            returnval= request.getParameter(parametername);
            log.debug("readParameter:"+parametername+"::"+ returnval);
        }
        return returnval;
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

    protected void bindDataSourceService(DataSourcePool dataSourceService)
    {
        //log.error("********** Inside bindConfigAdmin **********");
        this.dataSourceService = dataSourceService;

    }   
    protected void unbindDataSourceService(DataSourcePool dataSourceService)
    {       
        //log.error("********** Inside unbindConfigAdmin **********");
        dataSourceService = null;
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