import javax.servlet.ServletException;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.servlets.SlingAllMethodsServlet;

import java.io.*;
import java.util.Enumeration; 
import com.day.commons.datasource.poolservice.DataSourcePool; 

import javax.jcr.Session;
      
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;   


 
/** * @scr.service interface="javax.servlet.Servlet"

 * @scr.component immediate="true" metatype="no"

 * @scr.property name="service.description" value="AU Calendar Insert Post"

 * @scr.property name="service.vendor" value="MCD"
 
 * @scr.property name="sling.servlet.methods" values.0="GET" values.1="POST"
 
 * @scr.property name="sling.servlet.paths" value="/mcd/accessmcd/aucalendar/servlet/AUCalendarInsertPost"


 */

@SuppressWarnings("serial")

/* AU Calendar InsertPost
* Servlet to insert dialog value into database
*
* Digvijay 02-15-2011
*/ 

public class AUCalendarInsertPost extends SlingAllMethodsServlet {

    /** @scr.reference */
    private org.apache.sling.jcr.api.SlingRepository repository;
    
    /** @scr.reference */
    private DataSourcePool dbService;
 
      
    private static final Logger log = LoggerFactory.getLogger(AUCalendarInsertPost.class);

    @Override

    protected void doGet(SlingHttpServletRequest request,SlingHttpServletResponse response) throws ServletException,IOException {
            
            log.info("***** Inside Get Method *****");
            String contentId = "";
            String action = "";
            try{
                Session session = repository.loginAdministrative(null);
                
                if(null != request.getParameter("contentId")){
                    contentId = request.getParameter("contentId");
                    log.info("Content ID ::"+ contentId);
                }
                 
                if(null != request.getParameter("action")){
                    action = request.getParameter("action");
                    log.info("Action ::"+ action);
                }
                
                session.logout();
                session = null;
                 
                /*if("delete".equals(action)){
                    AUCalendarManager auCalendarManager = new AUCalendarManager(dbService,session);
                    deletePostData(contentId,auCalendarManager);
                }*/
            }catch(Exception ex){
            }                
    }

    @Override
    
    protected void doPost(SlingHttpServletRequest request,SlingHttpServletResponse response) throws ServletException,IOException {
            
            log.info("********* Inside Post *********");
            /*this.doGet(request,response);
            String title = request.getParameter("./title");
            log.info("*********** Title Post ************" + title);*/
            Enumeration en = request.getParameterNames();
            //log.info("************ Enu Object ********"+en);
            while (en.hasMoreElements()) {
                
                String paramName = (String) en.nextElement();
                log.info("** paramName ** " + paramName);
                
            } 
            /*String postingDate = "";
            String title = "";
            String description = "";
            
            String audienceStaff = "0";
            String linkStaff = "";
            String displayStaff = "0";
            
            String audienceFranchiees = "0";
            String linkFranchiees = "";
            String displayFranchiees = "0";
            
            String[] view = {};
            String postingType = "";
            String categoryId = "";
            
            String prefix = "";
            String prefixText = "";
            
            try{
                Session session = repository.loginAdministrative(null);
                                
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
                
                if(null != request.getParameter("./view")){
                    view = request.getParameterValues("./view");
                    log.info("View ::" + view.toString());
                    
                }
                
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
                
                AUCalendarManager auCalendarManager = new AUCalendarManager(dbService,session);  
                insertPostData(postingDate,title,description,audienceStaff,linkStaff,displayStaff,
                            audienceFranchiees,linkFranchiees,displayFranchiees,view,prefix,
                            prefixText,postingType,categoryId,auCalendarManager);
                              
                
            }
            catch(Exception ex){}*/
              

    } 
     
   
    /*private void insertPostData(String postingDate,String title,String description,String audienceStaff, String linkStaff,String displayStaff,
                            String audienceFranchiees,String linkFranchiees,String displayFranchiees,String[] view,String prefix,
                            String prefixText,String postingType,String categoryId,AUCalendarManager auCalendarManager){
                            
             try{
              
                 if("1".equals(postingType)){
                     
                     for (int i=0; i<view.length; i++) {
                     
                         if (!audienceStaff.equals("0")) {
                             PostEntry calAudienceStaff = new PostEntry();
                             calAudienceStaff.setPubDate(postingDate);
                             calAudienceStaff.setTitle(title);
                             calAudienceStaff.setAudienceType(audienceStaff);
                             calAudienceStaff.setDocURL(linkStaff);
                             calAudienceStaff.setLaunchtype(displayStaff);
                             calAudienceStaff.setCategoryID(categoryId);
                             calAudienceStaff.setViewID(view[i]);
                             calAudienceStaff.setActvFlag("1");
                             
                             boolean theResult = auCalendarManager.insertPost(calAudienceStaff);
                             log.info("***** Data has been inserted for Calendar Audience Staff *****");
                         }
                         
                         if (!audienceFranchiees.equals("0")) {
                             PostEntry calAudienceFranchisee = new PostEntry();
                             calAudienceFranchisee.setPubDate(postingDate);
                             calAudienceFranchisee.setTitle(title);
                             calAudienceFranchisee.setAudienceType(audienceFranchiees);
                             calAudienceFranchisee.setDocURL(linkFranchiees);
                             calAudienceFranchisee.setLaunchtype(displayFranchiees);
                             calAudienceFranchisee.setCategoryID(categoryId);
                             calAudienceFranchisee.setViewID(view[i]);
                             calAudienceFranchisee.setActvFlag("1");
                             boolean theResult = auCalendarManager.insertPost(calAudienceFranchisee);
                             log.info("***** Data has been inserted for Calendar Audience Franchise *****"); 
                         }   
                     }                     
                  }
                  else if("2".equals(postingType)){
                      String[] postingDates = postingDate.split(",");
                      if("other".equalsIgnoreCase(prefixText)){
                          title = prefixText + ":" + title;
                      }
                      else{
                          title = prefix + ":" + title;    
                      }
                       
                      for (int p=0; p<postingDates.length; p++){
                            
                          String[] postingDateSplit = postingDates[p].split("/");
                          String date = postingDateSplit[0];
                          String month = postingDateSplit[1];
                          String year = postingDateSplit[2];
                           
                          String convertedPostingDate = year + "-" + month + "-" + date;
                          log.info("***** Before Format Date *****");
                          DateFormat formatPostingDate = new SimpleDateFormat("yyyy-MM-dd");
                          log.info("***** After Format Date *****" );  
                          String finalPostingDate = "";
                          try{ 
                              Date parsedPostingDate = formatPostingDate.parse(convertedPostingDate);  
                              finalPostingDate = formatPostingDate.format(parsedPostingDate); 
                          }    
                          catch (ParseException e) {
                              log.error("Error::",e);
                              e.printStackTrace();   
                          }
                          log.info("FinalPosting Date :: " + finalPostingDate); 
                          for (int i=0; i<view.length; i++) {
                             if (!audienceStaff.equals("0")) {
                                 PostEntry nbAudienceStaff = new PostEntry();
                                 nbAudienceStaff.setPubDate(convertedPostingDate);
                                 nbAudienceStaff.setTitle(title);
                                 nbAudienceStaff.setDesc(description);
                                 nbAudienceStaff.setAudienceType(audienceStaff);
                                 nbAudienceStaff.setDocURL(linkStaff);
                                 nbAudienceStaff.setLaunchtype(displayStaff);
                                 nbAudienceStaff.setCategoryID(categoryId);
                                 nbAudienceStaff.setViewID(view[i]);
                                 nbAudienceStaff.setActvFlag("1");
                                 
                                 boolean theResult = auCalendarManager.insertPost(nbAudienceStaff);
                                 log.info("***** Data has been inserted for Notice Board Audience Staff *****");
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
                                 nbAudienceFranchiee.setViewID(view[i]);
                                 nbAudienceFranchiee.setActvFlag("1");
                                 boolean theResult = auCalendarManager.insertPost(nbAudienceFranchiee); 
                                 log.info("***** Data has been inserted for Notice Board Audience Franchise *****");      
                             }
                          }
                          
                      }
                  }
                }
                catch(Exception ex){}
    }  
    
    private void deletePostData(String contentId,AUCalendarManager auCalendarManager){
        log.info("***** Inside Delete Post Data Method *****");
        try{
            boolean theResult = auCalendarManager.deletePost(contentId);
            log.info("***** Data has been deleted for Notice Board *****"+theResult); 
        }catch(Exception ex){
        }    
    }   */                        
}    