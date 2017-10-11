<%--
  ==============================================================================

  Notice Board Archive page 

  Gets the archived Notice Board data from PCIInterface Layer and make an
  AJAX call using globing pattern to load the Notice Board posts of selected week
  
  Judy Zhang 
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
                com.mcd.accessmcd.pci.util.XMLUtils,
                com.mcd.accessmcd.calendar.util.DesEncrypter"
                
                
%>

    <%@ page import="com.day.cq.security.Authorizable,
                     com.day.cq.security.User,
                     com.day.cq.security.UserManager,
                     com.day.cq.security.UserManagerFactory,
                     org.apache.sling.jcr.api.SlingRepository,
                     org.apache.sling.api.scripting.SlingScriptHelper,
                     org.osgi.framework.BundleActivator"
                     
    %>   
   <%@page import="java.io.*,
               java.io.InputStream,
               java.net.URL,
               java.text.*,
               java.util.*" %>

    
                    
    <script type="text/javascript" src="/scripts/sling.js"></script> 
    <script type="text/javascript" src="/scripts/archivedposts.js"></script> 


 

<div class="archiveHeaderSection">
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
  <div class="welcomeContent">
    <div class="welcomeText">
      <div class="archiveWelcomeMessage">Archived Posts (26 weeks)</div>
    </div>
  </div>
  <!--For rendering bottom round corners-->
  <div class="welcomeRoundCorner">
   <b class="roundcorneryellow"> <b class="roundcorneryellow5"></b> <b class="roundcorneryellow4"></b> 
   <b class="roundcorneryellow3"></b> <b class="roundcorneryellow2"><b></b></b> <b class="roundcorneryellow1"><b></b></b></b> </div>

<div class="archiveNoticeBoard">  
 <div class="archivePost-c1 floatLeft">
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
      <dl class="archiveList1">

<%!

        private String[] strMonths = new String[]{ 
                            "January",                      
                            "February",                     
                            "March",                  
                            "April",
                            "May",  
                            "June",         
                            "July",                   
                            "August",                    
                            "September",                    
                            "October",                    
                            "November",                   
                            "December"                 
                            };

%>

<%


   String loggedUserAudType="";
   String encryptedAudType="";

   //retrieve the values of View entity type, default is AU
   String viewText=properties.get("viewtext","AU");

   String currentPagePath = currentPage.getPath(); // CQ path of the page
   if(currentPagePath != null && currentPagePath.startsWith("/content"))
       currentPagePath = currentPagePath.replace("/content/","/");
        


//JZ: either do this or get the audience type passed in

        DesEncrypter encrypter = new DesEncrypter();
        final User user = slingRequest.getResourceResolver().adaptTo(User.class);
        
        String corpEmployeeAudName = "CorpEmployees"; // Employee Audience Type
        
        String franchiseeAudName = "Franchisees"; // Employee Audience Type
       
        // ****** get logged-in user audience type ***** //
        SlingRepository repos= sling.getService(SlingRepository.class);  
        UserManagerFactory fact =sling.getService(UserManagerFactory.class);
      
        if (!(repos==null || fact==null)) {
            Session session = null;
            try {
                session = repos.loginAdministrative(null);
                final UserManager umgr = fact.createUserManager(session);


                if(umgr.hasAuthorizable(user.getID())){
                    Authorizable auth = umgr.get(user.getID());
                  
                    // code to retrieve the audience type of the logged in user
                    Node userProfileNode = (Node) session.getItem(user.getHomePath() + "/profile");

                    if(userProfileNode.hasProperty("mcdAudience"))
                     { 

                        loggedUserAudType=userProfileNode.getProperty("mcdAudience").getValue().getString();
                        
                        //code to encrypt the Audience type of the logged in user
                        encryptedAudType = encrypter.encrypt(loggedUserAudType).replace("/","");
                       
                     }else{
                         if(null!=user.getProperty("./rep:mcdAudience")){
                             loggedUserAudType=user.getProperty("./rep:mcdAudience");
                             encryptedAudType = encrypter.encrypt(loggedUserAudType).replace("/","");
                         
                         }         
                     
                    }
                    
                    //let admin to view staff posts
                    if("admin".equalsIgnoreCase(user.getID())){
                             loggedUserAudType="CorpEmployees";
                             encryptedAudType = encrypter.encrypt(loggedUserAudType).replace("/","");
                    }
                 }
            
            session.logout();
            session = null;
            } catch (RepositoryException e) {
            } finally {
                if (session!=null) {
                    session.logout();
                }
            }
        }
        
/*
System.out.println("loggedUserAudType........"+loggedUserAudType);
System.out.println("encryptedAudType ........"+encryptedAudType );
System.out.println("currentPagePath  .........."+currentPagePath );

       encryptedAudType = "CorpEmployees";

//judy, set audience type to logged in user type
       if(loggedUserAudType!=null&&!loggedUserAudType.equals("")){
           encryptedAudType = loggedUserAudType;
           
       }
//end set audience type
*/
       
       String cachePageCount ="7";
       int disp_wks =0;

        PCIQuery pciquery = new PCIQuery();
        Calendar now = Calendar.getInstance();
//        now.add(Calendar.DATE,-7);
        Calendar endTime = Calendar.getInstance();

//for testing only
//        now.set(2011,6,4);
      
        String s1Wk = "";
        String e1Wk = "";

//judy add special date for compare,04/19
       Calendar cutOffDate= Calendar.getInstance();
       if (currentPagePath.indexOf("/apmea/nz")>0)
           cutOffDate.set(2011,Calendar.APRIL,18);
       else 
           cutOffDate.set(2011,Calendar.APRIL,11);

        

        Date fromDate = now.getTime(); // Getting the current date.
        int lastDate = now.get(Calendar.DATE); 


        SimpleDateFormat dispSDF = new SimpleDateFormat("EEEEEE d MMMMMMM");
//judy, change formatter,0323
//        SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
        SimpleDateFormat formatter = new SimpleDateFormat("MM_dd_yyyy");
        
        
       
        for (int i=0;i<7;i++){

             
       if (now.get(Calendar.DAY_OF_WEEK)!=2){
             for (int j=0;j<7;j++){
                now.add(Calendar.DATE,-1);
                if (now.get(Calendar.DAY_OF_WEEK)==2)
                         break;
             }
       }//end if 
%>
   
              <%
//judy, 03/16/2011, fix display date

                       endTime.setTime(now.getTime());      
                       endTime.add(Calendar.DATE,-6); 
                       disp_wks++;

                       if (i==0){
                           s1Wk =  formatter.format(endTime.getTime());        
                           e1Wk =  formatter.format(now.getTime());        
                       }
                       
                       
//add cutoff date                       
                       if(disp_wks>=1 && disp_wks<=26&& now.after(cutOffDate)){                       
//                       if(disp_wks>=1 && disp_wks<=26){                       
                       
              %>
              <dt><%=strMonths[now.get(Calendar.MONTH)]%> <%=now.get(Calendar.YEAR)%></dt> 
              <dd><a href="javascript:getPosts('<%=encryptedAudType %>', '<%=viewText%>',
               '<%= currentPagePath%>','<%=formatter.format(endTime.getTime())%>','<%=formatter.format(now.getTime()) %>')"> <%= dispSDF.format(now.getTime()) %> </a></dd>


             <% }
                 Calendar mon=now;

                 for (int m=1;m<5;m++){
                      if (mon.get(Calendar.DAY_OF_MONTH)<=7)
                            break;
                 
                      mon.add(Calendar.DAY_OF_MONTH,-7);

                      endTime.setTime(mon.getTime());      
//judy,03/16/2011
//                      endTime.add(Calendar.DATE,6);  
                      endTime.add(Calendar.DATE,-6);  
                      disp_wks++;

//add cutoff date                       
                       if(disp_wks>=1 && disp_wks<=26&& mon.after(cutOffDate)){                       
//                      if(disp_wks>=1 && disp_wks<=26){                       
              %>       
           
       <class="showToday_text">
       <dd><a href="javascript:getPosts('<%=encryptedAudType %>', '<%=viewText%>', 
       '<%=currentPagePath%>','<%=formatter.format(endTime.getTime())%>','<%=formatter.format(now.getTime())%>')"> <%= dispSDF.format(mon.getTime()) %> </a></dd>
 
              <%}

                  }//end for            
              %>
               

       
    <%                   now.add(Calendar.MONTH,-1); 
                   lastDate = now.getActualMaximum(Calendar.DATE); 
                   now.set(Calendar.DAY_OF_MONTH,lastDate);
     }%>

  
<script type="text/javascript" src="jquery/jquery.js"></script>
<script type="text/javascript">

$(document.getElementsByTagName('archivedpost')[0]).ready(function() {
  getPosts('<%=encryptedAudType %>', '<%=viewText%>', '<%=currentPagePath%>','<%=s1Wk%>','<%=e1Wk%>');
  
});
</script>
</dl>
 </div>
     
    </div>
  </div>
  <!--For rendering bottom round corners-->
  <div class="welcomeRoundCorner"> <b class="roundcorneryellow"> 
  <b class="roundcorneryellow5"></b> <b class="roundcorneryellow4"></b> 
  <b class="roundcorneryellow3"></b> <b class="roundcorneryellow2"><b></b></b> <b class="roundcorneryellow1"><b></b></b></b> </div>
  
</div>

      
<div id="archivedpost" ></div> 
     
</div>
<div class="clear"></div>