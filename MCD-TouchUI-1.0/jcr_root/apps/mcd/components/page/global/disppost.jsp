 <%--
 ==============================================================================
  To display the archived posts ( one week)
  Judy Zhang , 2011  
 ==============================================================================
--%> 
    
     <%@include file="/apps/mcd/global/global.jsp" %>
    <%@page import="java.util.Date,
                   java.util.Calendar,
                   java.util.Iterator,
                   java.util.TimeZone,
                   java.util.GregorianCalendar,
                   java.net.URLEncoder,
                   java.text.SimpleDateFormat
                   " %>
     
    <%@page import="com.mcd.accessmcd.pci.bo.PCIQuery,
                com.mcd.accessmcd.pci.bo.PCIResult,
                com.mcd.accessmcd.pci.util.PCIProperties,
                com.mcd.accessmcd.pci.dao.IPCIContentDao,
                com.mcd.accessmcd.pci.facade.impl.PCIContentDeliveryFacadeImpl,
                com.mcd.accessmcd.calendar.util.DesEncrypter,
                sun.misc.BASE64Encoder,
                com.mcd.accessmcd.pci.util.XMLUtils" 
    %>
    
    
    
    <%@ page import="com.day.cq.security.Authorizable,
                     com.day.cq.security.User,
                     com.day.cq.security.UserManager,
                     com.day.cq.security.UserManagerFactory,
                     org.apache.sling.jcr.api.SlingRepository,
                     org.apache.sling.api.scripting.SlingScriptHelper
                     
    "%>    
    
                   
<%@page import="com.mcd.accessmcd.aucalendar.util.CalendarUtil,
                com.day.cq.wcm.api.WCMMode" %>  
        
     <div id="archivedpost">
      
    
    <%!
 
     //variable to check the for Australia Time Zone.
     private static final String AUS_TIME_ZONE = "aus"; 
     private static final String NZ_TIME_ZONE = "nz"; 
     private static final String AU_DOMAIN = "https://www1.accessmcd.com"; 
     private static final String NZ_DOMAIN = "https://www1.accessmcd.com"; 
    
     /*
     * Method that gets the calendar-data(PCIResult object) from PCI Interface Layer.
     * @param HttpServletRequest, CalndarManger, JcrPropertyMap
     * return an array of PCIResult object.
     */   
//     public PCIResult[] getPostInfo(HttpServletRequest cqReq, SlingScriptHelper sling, JspWriter out)throws Exception{
     public PCIResult[] getPostInfo(String aud, HttpServletRequest cqReq, SlingScriptHelper sling, JspWriter out)throws Exception{
     
    
    
        Calendar now = Calendar.getInstance(); 
        PCIQuery pciquery=new PCIQuery();
        PCIContentDeliveryFacadeImpl pci=new PCIContentDeliveryFacadeImpl(sling);

        DesEncrypter encrypter = new DesEncrypter();
        
        String requestURI = cqReq.getRequestURI();
        String actionType="read";
        String resultCount = "1000";
        
        String categoryID = "4000";
        String viewType = "content";        
        String entityType = "AU";
        String sortType = "rchrono";
        String audience = aud;
        String timeZone = "";
        

        String caledarGlobPart = requestURI.substring(requestURI.lastIndexOf("/")+1);
        // Getting the week(next/prev) no.
        String urlParam[] = caledarGlobPart.split("\\.");
        String startDate = urlParam[2];
        String endDate   = urlParam[3];
        
        
//        if(urlParam[4]!=null)
  //         audience  = encrypter.decrypt(urlParam[4]);
           
        entityType= urlParam[5];
        SimpleDateFormat sdf=new SimpleDateFormat("MM_dd_yyyy");
        

        pciquery.setAudience(audience );
        pciquery.setCategoryID(categoryID );
        pciquery.setResultCount(resultCount );
        pciquery.setSortType(sortType );
        pciquery.setEntityType(entityType );
        pciquery.setActionType(actionType);
        pciquery.setViewType(viewType );

    
    try{
        Date dtFromDate=sdf.parse(startDate);
        pciquery.setFromDate(dtFromDate);
        Date dtToDate=sdf.parse(endDate);
        pciquery.setToDate(dtToDate);
    }catch(Exception e){
    }

//judy, uncomment for now
//        pciquery.setCacheRefresh(120); // OSCache refresh time is 15 minutes.
        
        PCIResult[] results = pci.getPCIContent(pciquery);
//        Object[] results = util.getPCIContent(pciquery, sling);

        
        return results;
    }    
     
    %> 
    
    <%
    
    
    String loggedUserAudType="";
//    String encryptedAudType="";
    
    // variable to store the details of divs need to be expanded;
    String expndDivDetail = "";
        
    try
    {
        
        HttpServletRequest cqReq = (HttpServletRequest) request;
        String requestURI = cqReq.getRequestURI();
        String caledarGlobPart = requestURI.substring(requestURI.lastIndexOf("/")+1);
        String urlParam[] = caledarGlobPart.split("\\.");
        String stTime = urlParam[2];
         
         if (stTime!=null){
             SimpleDateFormat old_df = new SimpleDateFormat("MM_dd_yyyy"); 
             SimpleDateFormat new_df = new SimpleDateFormat("EEEEEEEE d MMMMMMMMM"); 
             Date today = old_df.parse(stTime);  
             stTime= new_df.format(today);           
         }

        
        String corpEmployeeAudName = "CorpEmployees"; // Employee Audience Type
        
        String franchiseeAudName = "Franchisees"; // Employee Audience Type


         CalendarUtil util = new CalendarUtil();
        final User user = slingRequest.getResourceResolver().adaptTo(User.class);
        
//        if(WCMMode.fromRequest(request) == WCMMode.DISABLED) {
            loggedUserAudType = util.getLoggedUserAudType(sling, user);  
//        }
        
        //allow admin to view staff posts 
        if("admin".equalsIgnoreCase(user.getID()))
               loggedUserAudType="CorpEmployees";

//out.print("loggedUserAudType::"+loggedUserAudType);

        
        // *** End of audience type block ***//
    
        int weekdaycount = 1;               // counting the week's day.
        boolean closeCalendarDIV = false;   // variable identifies that when to close the calendar activity div. 
        response.setContentType("text/html;charset=UTF-8");
        
//        PCIResult[] postContent = getPostInfo(cqReq, sling, out);
        PCIResult[] postContent = getPostInfo(loggedUserAudType,cqReq, sling, out);
        

        StringBuffer staff = new StringBuffer();
        
        //display details
        staff.append("<dl class=\"archiveList2\">");
        staff.append("<h1>Posts from "+stTime +"</h1>");
        if (postContent.length<=0){
            staff.append("<h1> No posts for this week.</h1>");
        
        }else{    
        
          for (int k=0;k<postContent.length;k++){
               com.mcd.accessmcd.pci.bo.PCIResult thepost=(com.mcd.accessmcd.pci.bo.PCIResult)postContent[k];
               
               String pubDate = thepost.getPublishDate();

               if (pubDate !=null){
                   SimpleDateFormat old_df = new SimpleDateFormat("MM.dd.yy"); 
                   SimpleDateFormat new_df = new SimpleDateFormat("d MMMMMMMMMM yyyy"); 
                   Date pubday = old_df.parse(pubDate );  
                   pubDate = new_df.format(pubday );           
               }

            // If there is no pageURL associated with any of calendar activity, then targetting it to
            //  blank URL(#) to avoid creation of broken links...
             
               String linkURL= "#";
               if(thepost.getPageURI()!=null)
                  linkURL = thepost.getPageURI();

            
            String serverHostDomain = thepost.getServerHostDomain();
            serverHostDomain = (serverHostDomain == null) ? "" : serverHostDomain.trim();
            linkURL = (linkURL == null) ? "" : linkURL.trim();


            
            if (linkURL .startsWith("/")){
                linkURL = (linkURL.equals("") ? "#" :  serverHostDomain +linkURL+ ".html");  
            }else if ("".equals(linkURL)){
                linkURL = "#";
            }               
                      
            if(!linkURL.startsWith("#")&&!linkURL.startsWith("/") && !linkURL.startsWith("http")) 
                linkURL = "http://"+linkURL;                      
//System.out.println("linkURL ::"+linkURL );
        
            //getting lauchType from the PCIResult and open links in new or same window
            //  0 and 1 -> open link in the same window
            //  2 and 3 -> open link in the new window
            
            String launchType  = thepost.getLaunchType();
            String openWin = "";
            
            if(launchType.equals("2") || launchType.equals("3")){
                openWin = "_blank";             
            }           

            //judy, 03/16/2011, display empty string
            String sTitle = "";
            String sDesc ="";
            
            if (thepost.getDocumentTitle()!=null){
                sTitle = thepost.getDocumentTitle().replaceFirst("\\|",":");
            }    
                
            if (thepost.getDescription()!=null)
                sDesc = thepost.getDescription();
                              
                              
               staff.append("<dt>"+ pubDate  +"<dt><dd>");
               if (!linkURL.equals("#")){
                   staff.append("<a href='"+linkURL+"' target='"+openWin +"'>");
               }    
               staff.append(sTitle + "</a>&nbsp;"+ sDesc +"</dd>");
                             
                             
           }
        }
      staff.append("</dl>");
      
      expndDivDetail = staff.toString();

    }catch(Exception ex)
    {
        log.error("PostInformation can't be retrieved "+ex);
    } 
%>
    
    </div> <!-- End of div archivepost-->
    
    <div class="archivePost-c2 floatLeft">
           <div class="archiveRoundCorner">
   <b class="roundcorneryellow"> 
   <b class="roundcorneryellow1">
   <b></b>
   </b> 
   <b class="roundcorneryellow2">
   <b>
   </b></b> 
   <b class="roundcorneryellow3"></b> 
   <b class="roundcorneryellow4"></b> 
   <b class="roundcorneryellow5"></b>
   </b> 
   </div>
  <div class="welcomeContent archiveContentHolder">
    <div class="welcomeText">
      <div class="archiveWelcomeMessage">
    <!--<div id="expndDivID" >-->
        <%= expndDivDetail.trim()  %>
    <!--</div>-->
 </div>
     
    </div>
  </div>
  <!--For rendering bottom round corners -->
  <div class="welcomeRoundCorner"> <b class="roundcorneryellow"> <b class="roundcorneryellow5"></b>
  <b class="roundcorneryellow4"></b> <b class="roundcorneryellow3"></b> <b class="roundcorneryellow2"><b></b></b> 
  <b class="roundcorneryellow1"><b></b></b></b> </div>
   
</div>







   