package com.mcd.accessmcd.aucalnbservlet;

import javax.servlet.Servlet;
import javax.servlet.ServletException;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.servlets.SlingAllMethodsServlet;

import java.io.*;
import java.util.Enumeration; 
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
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;
  
 
@Component(immediate=true,metatype=false)
@Service(Servlet.class)
@Properties({
    @Property( name="service.description",value="AU Calendar Insert Post"),
    @Property( name="service.vendor",value="MCD"),
    @Property(name = "sling.servlet.paths", value="/mcd/accessmcd/aucalnbservlet/AUCalendarInsertPost"),
    @Property(name = "sling.servlet.methods", value={ "GET","POST" })
})

@SuppressWarnings("serial")

/* AU Calendar InsertPost
* Servlet to insert dialog value into database
*
* Digvijay 02-15-2011
*/ 

public class AUCalendarInsertPost extends SlingAllMethodsServlet {

    @Reference
    private org.apache.sling.jcr.api.SlingRepository repository;
    
    @Reference
    private DataSourcePool dataSourceService;
 
    @Reference 
    private JcrResourceResolverFactory resolverFactory;
      
    private static final Logger log = LoggerFactory.getLogger(AUCalendarInsertPost.class);
    
    @Override

    protected void doGet(SlingHttpServletRequest request,SlingHttpServletResponse response) throws ServletException,IOException {
            
            log.info("***** Inside Get Method *****");
            String deleteUUID = "";
            String deleteAction = "";
            try{
                Session session = repository.loginAdministrative(null);
                
                if(null != request.getParameter("uuid")){
                    deleteUUID = request.getParameter("uuid");
                    log.info("Delete UUID In Get ::"+ deleteUUID);
                }
                 
                if(null != request.getParameter("action")){
                    deleteAction = request.getParameter("action");
                    log.info("Delete Action In Get ::"+ deleteAction ); 
                }
                   
                if("delete".equals(deleteAction )){
                    AUCalendarManager auCalendarManager = new AUCalendarManager(dataSourceService,session);
                    deletePostData(deleteUUID ,auCalendarManager);
                }
            }catch(Exception ex){
            }                
    }

    @Override
    
    protected void doPost(SlingHttpServletRequest request,SlingHttpServletResponse response) throws ServletException,IOException {
            
            log.info("********* Inside Post *********");
            
            String postingDate = "";
            String title = "";
            String description = "";
            
            String audienceStaff = "0";
            String linkStaff = "";
            String displayStaff = "0";
            
            String audienceFranchiees = "0";
            String linkFranchiees = "";
            String displayFranchiees = "0";
            
            String viewAU = "";
            String viewNZ = "";
            String view = "";
            
            String postingType = "";
            String categoryId = "";
            
            String prefix = "";
            String prefixText = "";
            
            String uuid = "";
            String insertUUID = "";
            String action = "";
            
            //wei - changed for getting UUID on 4/25
            //UUID uid = UUID.randomUUID();
            //insertUUID = uid.toString();
            
            insertUUID=String.valueOf(System.currentTimeMillis());
            log.info("Insert UUID : " + insertUUID);
            
            String deleteAction = "";
            String deleteUUID = "";
            
            try{
                Session session = repository.loginAdministrative(null);
                ResourceResolver resourceResolver = resolverFactory.getResourceResolver(session);
                Profile userProfile = resourceResolver.adaptTo(User.class).getProfile();
                 
                if(null != request.getParameter("./postingDate")){
                    postingDate = request.getParameter("./postingDate");
                    log.info("Posting Date :: " + postingDate);
                }
                
                if(null != request.getParameter("./title")){
                    title = request.getParameter("./title");
                    log.info("Title :: " + title);
                }
                
                if(null != request.getParameter("./description")){
                    description = request.getParameter("./description");
                    log.info("Description :: " + description);
                }
                
                if(null != request.getParameter("./audienceStaff")){
                    audienceStaff = request.getParameter("./audienceStaff");
                    log.info("audienceStaff :: " + audienceStaff );
                }
                
                if(null != request.getParameter("./linkStaff")){
                    linkStaff = request.getParameter("./linkStaff");
                    log.info("linkStaff :: " + linkStaff );
                }
                
                if(null != request.getParameter("./displayStaff")){
                    displayStaff = request.getParameter("./displayStaff");
                    log.info("displayStaff :: " + displayStaff );
                }
                
                if(null != request.getParameter("./audienceFranchiees")){
                    audienceFranchiees = request.getParameter("./audienceFranchiees");
                    log.info("audienceFranchiees :: " + audienceFranchiees );
                }
                
                if(null != request.getParameter("./linkFranchiees")){
                    linkFranchiees = request.getParameter("./linkFranchiees");
                    log.info("linkFranchiees :: " + linkFranchiees );
                }
                
                if(null != request.getParameter("./displayFranchiees")){
                    displayFranchiees = request.getParameter("./displayFranchiees");
                    log.info("displayFranchiees :: " + displayFranchiees );
                }
                
                if(null != request.getParameter("./viewAU")){
                    viewAU = request.getParameter("./viewAU");
                }
                
                if(null != request.getParameter("./viewNZ")){
                    viewNZ = request.getParameter("./viewNZ");
                }
                if(!"".equals(viewAU) && "".equals(viewNZ)){
                    view = viewAU;
                    log.info("AU View ::" + view);
                }
                else if(!"".equals(viewNZ) && "".equals(viewAU)){
                    view = viewNZ;
                    log.info("NZ View ::" + view);
                }
                else if( !"".equals(viewAU) && !"".equals(viewNZ) ){
                    view = viewAU + "," + viewNZ;
                    log.error("Concat View :: " + view);
                }
                log.error("Final View :: " + view);
                 
                if(null != request.getParameter("./postingType")){
                    postingType = request.getParameter("./postingType");
                    log.info("postingType :: " + postingType );
                }
                
                if(null != request.getParameter("./categoryId")){
                    categoryId = request.getParameter("./categoryId");
                    log.info("categoryId :: " + categoryId );
                }
               
                if(null != request.getParameter("./prefix")){
                    prefix = request.getParameter("./prefix");
                    log.info("Prefix ::" + prefix);
                    
                }
                
                if(null != request.getParameter("./prefixText")){
                    prefixText = request.getParameter("./prefixText");
                    log.info("prefixText ::" + prefixText); 
                    
                }
                              
                if(null != request.getParameter("./uuid")){
                    uuid = request.getParameter("./uuid");
                    log.info("UUID ::"+ uuid);
                }
                
                if(null != request.getParameter("uuid")){
                    deleteUUID = request.getParameter("uuid");
                    log.info("Delete UUID ::"+ deleteUUID);
                }
                 
                if(null != request.getParameter("./action")){
                    action = request.getParameter("./action");
                    log.info("Action ::"+ action);
                }
                 
                if(null != request.getParameter("action")){
                    deleteAction = request.getParameter("action");
                    log.info("Delete Action ::"+ deleteAction ); 
                }
                
                if(!"".equals(deleteAction)){
                    action = deleteAction;
                }
                
             
                AUCalendarManager auCalendarManager = new AUCalendarManager(dataSourceService,session);  
                
                if("edit".equalsIgnoreCase(action)){
                    editPostData(postingDate,title,description,audienceStaff,linkStaff,displayStaff,
                                audienceFranchiees,linkFranchiees,displayFranchiees,prefix,
                                prefixText,postingType,categoryId,auCalendarManager,view,uuid,userProfile);
                }
                else if("delete".equals(action)){
                    deletePostData(deleteUUID,auCalendarManager);
                }
                else{
                    insertPostData(postingDate,title,description,audienceStaff,linkStaff,displayStaff,
                                audienceFranchiees,linkFranchiees,displayFranchiees,prefix,
                                prefixText,postingType,categoryId,auCalendarManager,view,insertUUID,userProfile);
                }                                
            }   
            catch(Exception ex){}
              
            //return 'ok' to avoid javascript error
            response.setContentType("text/html");
            response.setStatus(200);
            PrintWriter out = response.getWriter();
            out.println("ok");
            

    } 
     
   
    private void insertPostData(String postingDate,String title,String description,String audienceStaff, String linkStaff,String displayStaff,
                            String audienceFranchiees,String linkFranchiees,String displayFranchiees,String prefix,
                            String prefixText,String postingType,String categoryId,AUCalendarManager auCalendarManager,
                            String view,String insertUUID,Profile userProfile){
                            
             try{
              
                  if("1".equals(postingType)){
                     
                         if(!"".equals(view)){
                         
                             if (!audienceStaff.equals("0")) {
                                 PostEntry calAudienceStaff = new PostEntry();
                                 calAudienceStaff.setPubDate(postingDate);
                                 calAudienceStaff.setTitle(title);
                                 calAudienceStaff.setAudienceType(audienceStaff);
                                 calAudienceStaff.setDocURL(linkStaff);
                                 calAudienceStaff.setLaunchtype(displayStaff);
                                 calAudienceStaff.setCategoryID(categoryId);
                                 calAudienceStaff.setViewID(view);
                                 calAudienceStaff.setActvFlag("1");
                                 calAudienceStaff.setUUID(insertUUID);
                                 calAudienceStaff.setInsUser(userProfile.getAuthorizable().getID());
                                  
                                 boolean theResult = auCalendarManager.insertPost(calAudienceStaff);
                                 if(true == theResult)
                                     log.info("***** Data has been inserted for AU Calendar Audience Staff *****");
                             }
                             
                             if (!audienceFranchiees.equals("0")) {
                                 PostEntry calAudienceFranchisee = new PostEntry();
                                 calAudienceFranchisee.setPubDate(postingDate);
                                 calAudienceFranchisee.setTitle(title);
                                 calAudienceFranchisee.setAudienceType(audienceFranchiees);
                                 calAudienceFranchisee.setDocURL(linkFranchiees);
                                 calAudienceFranchisee.setLaunchtype(displayFranchiees);
                                 calAudienceFranchisee.setCategoryID(categoryId);
                                 calAudienceFranchisee.setViewID(view);
                                 calAudienceFranchisee.setActvFlag("1");
                                 calAudienceFranchisee.setUUID(insertUUID);
                                 calAudienceFranchisee.setInsUser(userProfile.getAuthorizable().getID());
                                  
                                 boolean theResult = auCalendarManager.insertPost(calAudienceFranchisee);
                                 if(true == theResult)
                                     log.info("***** Data has been inserted for AU Calendar Audience Franchise *****"); 
                             }   
                         }
                  }
                  else if("2".equals(postingType)){
                      log.info("***** Inside Posting Type 2 *****" );
                      String[] postingDates = postingDate.split(",");
                      if("other".equalsIgnoreCase(prefix)){
                          title = prefixText.toUpperCase() + "|" + title;
                      }
                      else{
                          //wei - changed ":" to "|"
                          title = prefix.toUpperCase() + "|" + title;    
                      } 
                      
                      if(!"".equals(view)){  
                          for (int p=0; p<postingDates.length; p++){
                             //wei - changed the following
                             //UUID uid = UUID.randomUUID();
                             //insertUUID = uid.toString();
                             
                             insertUUID=String.valueOf(System.currentTimeMillis());
                             log.info("***** Inside Posting Date Loop *****");  
                             String[] postingDateSplit = postingDates[p].split("/");
                             String date = postingDateSplit[0];
                             String month = postingDateSplit[1];
                             String year = postingDateSplit[2];
                               
                             String convertedPostingDate = year + "-" + month + "-" + date;
                              
                             if (!audienceStaff.equals("0")) {
                                 PostEntry nbAudienceStaff = new PostEntry();
                                 nbAudienceStaff.setPubDate(convertedPostingDate);
                                 nbAudienceStaff.setTitle(title);
                                 nbAudienceStaff.setDesc(description);
                                 nbAudienceStaff.setAudienceType(audienceStaff);
                                 nbAudienceStaff.setDocURL(linkStaff);
                                 nbAudienceStaff.setLaunchtype(displayStaff);
                                 nbAudienceStaff.setCategoryID(categoryId);
                                 nbAudienceStaff.setViewID(view);
                                 nbAudienceStaff.setActvFlag("1");
                                 nbAudienceStaff.setUUID(insertUUID);
                                 nbAudienceStaff.setInsUser(userProfile.getAuthorizable().getID());
                                 
                                 boolean theResult = auCalendarManager.insertPost(nbAudienceStaff);
                                 if(true == theResult)
                                     log.info("***** Data has been inserted for AU Notice Board Audience Staff *****");
                             }
                                
                             if (!audienceFranchiees.equals("0")) {
                                 PostEntry nbAudienceFranchiee = new PostEntry();
                                 nbAudienceFranchiee.setPubDate(convertedPostingDate);
                                 nbAudienceFranchiee.setTitle(title);
                                 nbAudienceFranchiee.setDesc(description);
                                 nbAudienceFranchiee.setAudienceType(audienceFranchiees);
                                 nbAudienceFranchiee.setDocURL(linkFranchiees);
                                 nbAudienceFranchiee.setLaunchtype(displayFranchiees);
                                 nbAudienceFranchiee.setCategoryID(categoryId);
                                 nbAudienceFranchiee.setViewID(view);
                                 nbAudienceFranchiee.setActvFlag("1");
                                 nbAudienceFranchiee.setUUID(insertUUID);
                                 nbAudienceFranchiee.setInsUser(userProfile.getAuthorizable().getID());
                                    
                                 boolean theResult = auCalendarManager.insertPost(nbAudienceFranchiee); 
                                 if(true == theResult)
                                     log.info("***** Data has been inserted for AU Notice Board Audience Franchise *****"); 
                                     
                                 // Inserting data for Franchisee Office Staff
                                 PostEntry nbAudienceFranchieeStaff = new PostEntry();
                                 nbAudienceFranchieeStaff.setPubDate(convertedPostingDate);
                                 nbAudienceFranchieeStaff.setTitle(title);
                                 nbAudienceFranchieeStaff.setDesc(description);
                                 nbAudienceFranchieeStaff.setAudienceType("8");
                                 nbAudienceFranchieeStaff.setDocURL(linkFranchiees);
                                 nbAudienceFranchieeStaff.setLaunchtype(displayFranchiees);
                                 nbAudienceFranchieeStaff.setCategoryID(categoryId);
                                 nbAudienceFranchieeStaff.setViewID(view);
                                 nbAudienceFranchieeStaff.setActvFlag("1");
                                 nbAudienceFranchieeStaff.setUUID(insertUUID);
                                 nbAudienceFranchieeStaff.setInsUser(userProfile.getAuthorizable().getID());
                                    
                                 boolean theResultStaff = auCalendarManager.insertPost(nbAudienceFranchieeStaff); 
                                 if(true == theResultStaff)
                                     log.info("***** Data has been inserted for AU Notice Board Audience Franchise Staff *****");         
                             }  
                          }
                       }
                    }
                }
                catch(Exception ex){}
    }  
    
    private void editPostData(String postingDate,String title,String description,String audienceStaff, String linkStaff,String displayStaff,
                            String audienceFranchiees,String linkFranchiees,String displayFranchiees,String prefix,
                            String prefixText,String postingType,String categoryId,AUCalendarManager auCalendarManager,
                            String view,String uuid,Profile userProfile){
                            
             try{
               
                  if("1".equals(postingType)){
                     
                         if(!"".equals(view)){
                             boolean deletePost = auCalendarManager.deletePostByUUID(uuid);   
                             if (!audienceStaff.equals("0")) {
                                 PostEntry calAudienceStaff = new PostEntry();
                                 calAudienceStaff.setPubDate(postingDate);
                                 calAudienceStaff.setTitle(title);
                                 calAudienceStaff.setAudienceType(audienceStaff);
                                 calAudienceStaff.setDocURL(linkStaff);
                                 calAudienceStaff.setLaunchtype(displayStaff);
                                 calAudienceStaff.setCategoryID(categoryId);
                                 calAudienceStaff.setViewID(view);
                                 calAudienceStaff.setActvFlag("1");
                                 calAudienceStaff.setUUID(uuid);
                                 calAudienceStaff.setModUser(userProfile.getAuthorizable().getID());
                                 
                                 //boolean deletePost = auCalendarManager.deletePostByUUID(uuid);
                                 if(true == deletePost){
                                     boolean theResult = auCalendarManager.insertPost(calAudienceStaff);
                                     if(true == theResult)
                                         log.info("***** Data has been updated for AU-NZ Calendar Audience Staff *****");
                                 }
                             }
                             
                             if (!audienceFranchiees.equals("0")) {
                                 PostEntry calAudienceFranchisee = new PostEntry();
                                 calAudienceFranchisee.setPubDate(postingDate);
                                 calAudienceFranchisee.setTitle(title);
                                 calAudienceFranchisee.setAudienceType(audienceFranchiees);
                                 calAudienceFranchisee.setDocURL(linkFranchiees);
                                 calAudienceFranchisee.setLaunchtype(displayFranchiees);
                                 calAudienceFranchisee.setCategoryID(categoryId);
                                 calAudienceFranchisee.setViewID(view);
                                 calAudienceFranchisee.setActvFlag("1");
                                 calAudienceFranchisee.setUUID(uuid);
                                 calAudienceFranchisee.setModUser(userProfile.getAuthorizable().getID());
                                 
                                 //boolean deletePost = auCalendarManager.deletePostByUUID(uuid);
                                 if(true == deletePost){
                                     boolean theResult = auCalendarManager.insertPost(calAudienceFranchisee);
                                     if(true == theResult)
                                         log.info("***** Data has been updated for AU-NZ Calendar Audience Staff *****");
                                 }
                             }   
                         }
                  }
                  else if("2".equals(postingType)){
                      log.info("***** Inside Posting Type 2 *****" );
                      String[] postingDates = postingDate.split(",");
                      if("other".equalsIgnoreCase(prefix)){
                          title = prefixText + "|" + title;
                      }
                      else{
                          title = prefix + "|" + title;    
                      }
                       
                      if(!"".equals(view)){
                          boolean deletePost = auCalendarManager.deletePostByUUID(uuid);    
                          for (int p=0; p<postingDates.length; p++){
                              log.info("***** Inside Posting Date Loop *****");  
                              String[] postingDateSplit = postingDates[p].split("/");
                              String date = postingDateSplit[0];
                              String month = postingDateSplit[1];
                              String year = postingDateSplit[2];
                               
                              String convertedPostingDate = year + "-" + month + "-" + date;
                              
                              //log.info("***** Inside View Loop *****"); 
                                 if (!audienceStaff.equals("0")) {
                                     PostEntry nbAudienceStaff = new PostEntry();
                                     nbAudienceStaff.setPubDate(convertedPostingDate);
                                     nbAudienceStaff.setTitle(title);
                                     nbAudienceStaff.setDesc(description);
                                     nbAudienceStaff.setAudienceType(audienceStaff);
                                     nbAudienceStaff.setDocURL(linkStaff);
                                     nbAudienceStaff.setLaunchtype(displayStaff);
                                     nbAudienceStaff.setCategoryID(categoryId);
                                     nbAudienceStaff.setViewID(view);
                                     nbAudienceStaff.setActvFlag("1");
                                     nbAudienceStaff.setUUID(uuid);
                                     nbAudienceStaff.setModUser(userProfile.getAuthorizable().getID());
                                       
                                     //boolean deletePost = auCalendarManager.deletePostByUUID(uuid);
                                     if(true == deletePost){
                                         boolean theResult = auCalendarManager.insertPost(nbAudienceStaff);
                                         if(true == theResult)
                                             log.info("***** Data has been updated for AU-NZ Notice Board Audience Staff *****");
                                     }
                                 }  
                                    
                                 if (!audienceFranchiees.equals("0")) {
                                     PostEntry nbAudienceFranchiee = new PostEntry();
                                     nbAudienceFranchiee.setPubDate(convertedPostingDate);
                                     nbAudienceFranchiee.setTitle(title);
                                     nbAudienceFranchiee.setDesc(description);
                                     nbAudienceFranchiee.setAudienceType(audienceFranchiees);
                                     nbAudienceFranchiee.setDocURL(linkFranchiees);
                                     nbAudienceFranchiee.setLaunchtype(displayFranchiees);
                                     nbAudienceFranchiee.setCategoryID(categoryId);
                                     nbAudienceFranchiee.setViewID(view);
                                     nbAudienceFranchiee.setActvFlag("1");
                                     nbAudienceFranchiee.setUUID(uuid);
                                     nbAudienceFranchiee.setModUser(userProfile.getAuthorizable().getID());
                                     
                                     //boolean deletePost = auCalendarManager.deletePostByUUID(uuid);
                                     if(true == deletePost){
                                         boolean theResult = auCalendarManager.insertPost(nbAudienceFranchiee);
                                         if(true == theResult)
                                             log.info("***** Data has been updated for AU-NZ Notice Board Audience Franchise *****");
                                     }
                                     
                                     PostEntry nbAudienceFranchieeStaff = new PostEntry();
                                     nbAudienceFranchieeStaff.setPubDate(convertedPostingDate);
                                     nbAudienceFranchieeStaff.setTitle(title);
                                     nbAudienceFranchieeStaff.setDesc(description);
                                     nbAudienceFranchieeStaff.setAudienceType("8");
                                     nbAudienceFranchieeStaff.setDocURL(linkFranchiees);
                                     nbAudienceFranchieeStaff.setLaunchtype(displayFranchiees);
                                     nbAudienceFranchieeStaff.setCategoryID(categoryId);
                                     nbAudienceFranchieeStaff.setViewID(view);
                                     nbAudienceFranchieeStaff.setActvFlag("1");
                                     nbAudienceFranchieeStaff.setUUID(uuid);
                                     nbAudienceFranchieeStaff.setModUser(userProfile.getAuthorizable().getID());
                                     
                                     //boolean deletePost = auCalendarManager.deletePostByUUID(uuid);
                                     if(true == deletePost){
                                         boolean theResultStaff = auCalendarManager.insertPost(nbAudienceFranchieeStaff);
                                         if(true == theResultStaff)
                                             log.info("***** Data has been updated for AU-NZ Notice Board Audience Franchise Staff *****");
                                     }
                                 }  
                          }
                       } 
                    }
                }
                catch(Exception ex){}
    }
        
    private void deletePostData(String deleteUUID,AUCalendarManager auCalendarManager){
        //log.info("***** Inside Delete Post Data Method *****" + deleteUUID); 
        try{    
            boolean theResult = auCalendarManager.deletePostByUUID(deleteUUID);
            if(true == theResult)
                log.info("***** Data has been deleted for Notice Board-Calendar *****"); 
        }catch(Exception ex){ 
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