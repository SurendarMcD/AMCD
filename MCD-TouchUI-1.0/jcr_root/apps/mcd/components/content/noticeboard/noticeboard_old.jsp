<%--
  ==============================================================================

  Noice Board component

  Gets the Notice Board Data (PCIResult object) from PCIInterface Layer 
  
  Wei 02/2011 - modifying
 ==============================================================================
--%>
    
<%@include file="/apps/mcd/global/global.jsp" %>
<%@page import="java.util.Date,
                   java.util.Calendar,
                   java.util.Iterator,
                   java.util.TimeZone,
                   java.util.GregorianCalendar,
                   java.net.URLEncoder,
                   java.text.SimpleDateFormat"%>
    
<%@page import="com.mcd.accessmcd.pci.bo.PCIQuery,
                    com.mcd.accessmcd.pci.bo.PCIResult,
                    com.mcd.accessmcd.calendar.manager.CalendarManager,
                    com.mcd.accessmcd.calendar.util.DateUtil,
                    com.mcd.accessmcd.calendar.util.CalendarHelper,
                    com.mcd.accessmcd.calendar.util.DesEncrypter"%>
                    
                    
<%@ page import="com.day.cq.security.Authorizable,
                     com.day.cq.security.User,
                     com.day.cq.security.UserManager,
                     com.day.cq.security.UserManagerFactory,
                     org.apache.sling.jcr.api.SlingRepository,
                     org.apache.sling.api.scripting.SlingScriptHelper,
                     org.osgi.framework.BundleActivator"%>   
                     
                     
<%@ page import="com.day.text.Text,
                   com.day.cq.collab.blog.Blog,
                   com.day.cq.collab.blog.BlogEntry,
                   com.day.cq.widget.HtmlLibraryManager,
                   java.security.AccessControlException,
                   com.day.cq.security.Authorizable,
                   org.apache.sling.api.SlingHttpServletRequest"%>
<%@ page import="com.day.cq.widget.HtmlLibraryManager" %><%
%>

 
<!--judy  tst date picker  calendar --> 

                 <div id="jdatepicker">
                 <script type="text/javascript" src="/scripts/jdatepicker.js"></script>
                 <script type="text/javascript" src="/scripts/calendar.js"></script>
                 <link rel="stylesheet" href="/css/datePicker.css" type="text/css" />

                  <form>
                     <br>
                      pick A Date: <input name="ADate" id="posting_date"> 
                      <a href="#" onclick="javascript:displayDatePicker('ADate');"> <img src="/images/cal.gif"> </a>
                   </form>
                 </div>
    <div id="nbpost">
         
<!-- wei opening dialog for adding or editing -->           
<script>
        var noticeBoardConfig;
        var noticeBoardDialog;
        var noticeBoardDialogValues;
            
        function openNoticeBoardDialog1(action, componentName, contentID) {
                              
            noticeBoardConfig = CQ.WCM.getDialogConfig("/apps/mcd/components/content/noticeboard/dialog");
            noticeBoardDialog = CQ.WCM.getDialog(noticeBoardConfig);
            noticeBoardDialog.show();
           
            if (action == "edit") {
                //alert("contentID=" + contentID);
                      
               noticeBoardDialogValues = CQ.Util.formatData(CQ.HTTP.eval(CQ.HTTP.get('/content/utility/utility.getdialogvalues.html?contentID='+contentID)));
               noticeBoardDialog.loadcontent(noticeBoardDialog.getField('./postingDate').setValue(noticeBoardDialogValues[0].postingDate),
                                 noticeBoardDialog.getField('./title').setValue(noticeBoardDialogValues[0].title), 
                                 noticeBoardDialog.getField('./description').setValue(noticeBoardDialogValues[0].description),
                                 noticeBoardDialog.getField('./prefix').setValue(noticeBoardDialogValues[0].prefix),
                                 noticeBoardDialog.getField('./prefixText').setValue(noticeBoardDialogValues[0].prefixText),
                                 noticeBoardDialog.getField('./audienceStaff').setValue(noticeBoardDialogValues[0].audienceStaff),
                                 noticeBoardDialog.getField('./linkStaff').setValue(noticeBoardDialogValues[0].linkStaff),
                                 noticeBoardDialog.getField('./displayStaff').setValue(noticeBoardDialogValues[0].displayStaff),
                                 noticeBoardDialog.getField('./audienceFranchiees').setValue(noticeBoardDialogValues[0].audienceFranchiees),
                                 noticeBoardDialog.getField('./linkFranchiees').setValue(noticeBoardDialogValues[0].linkFranchiees),
                                 noticeBoardDialog.getField('./displayFranchiees').setValue(noticeBoardDialogValues[0].displayFranchiees),
                                 noticeBoardDialog.getField('./view').setValue(noticeBoardDialogValues[0].view),
                                 noticeBoardDialog.getField('./action').setValue(action),
                                 noticeBoardDialog.getField('./contentID').setValue(noticeBoardDialogValues[0].contentID)
                                );
            }
        }
          
       /*      
        function openNoticeBoardDialog(action, postingDate, title, description, audType, link, launchType) {
                              
            noticeBoardConfig = CQ.WCM.getDialogConfig("/apps/mcd/components/content/noticeboard/dialog");
            noticeBoardDialog = CQ.WCM.getDialog(noticeBoardConfig);
            noticeBoardDialog.show();
                  
            if (action == "edit") {
                     
               noticeBoardDialogValues = CQ.Util.formatData(CQ.HTTP.eval(CQ.HTTP.get('/content/utility/utility.getdialogvalues.html')));
               noticeBoardDialog.loadcontent(noticeBoardDialog.getField('./postingDate').setValue(postingDate),
                                 noticeBoardDialog.getField('./title').setValue(title), 
                                 noticeBoardDialog.getField('./description').setValue(description),
                                 noticeBoardDialog.getField('./prefix').setValue(''),
                                 noticeBoardDialog.getField('./prefixText').setValue(''),
                                 noticeBoardDialog.getField('./audienceStaff').setValue(audType),
                                 noticeBoardDialog.getField('./linkStaff').setValue(link),
                                 noticeBoardDialog.getField('./displayStaff').setValue(launchType),
                                 noticeBoardDialog.getField('./audienceFranchiees').setValue(audType),
                                 noticeBoardDialog.getField('./linkFranchiees').setValue(link),
                                 noticeBoardDialog.getField('./displayFranchiees').setValue(launchType),
                                 noticeBoardDialog.getField('./view').setValue(''),
                                 noticeBoardDialog.getField('./action').setValue(action),
                                 noticeBoardDialog.getField('./contentID').setValue()
                                );
            }
        }
      */    
</script>      
         
            
 
<%!
    //variable to check the for Australia Time Zone.
    private static final String AUS_TIME_ZONE = "aus"; 

    /*
     * Method that gets the calendar-data(PCIResult object) from PCI Interface Layer.
     * @param HttpServletRequest, JcrPropertyMap
     * return an array of PCIResult object.
     */
    public Object[] getCalendarInfo(HttpServletRequest cqReq, CalendarManager mngr, 
            org.apache.sling.jcr.resource.JcrPropertyMap properties, SlingScriptHelper sling, JspWriter out)
        throws Exception {

        PCIQuery pciquery = new PCIQuery();
        Calendar now = Calendar.getInstance();
    
        String resultCount = "1000";
        String actionType = "read";
        String categoryID = (String) properties.get("categoryId","3000");
        String audience = (String) properties.get("audience","CorpEmployees");
        String entityType = (String) properties.get("mcdEntity","AU");      
        String viewType = (String) properties.get("viewType","content");
        String sortType = (String) properties.get("sorttype","chrono");
        String timeZone = (String) properties.get("timezone","aus");
        
       
        pciquery.setAudience("CorpEmployees");
        pciquery.setCategoryID("3000");
        pciquery.setResultCount("10");
        pciquery.setSortType("chrono");
        pciquery.setEntityType("US");
        pciquery.setActionType(actionType);
        pciquery.setViewType(viewType);
        
        
        Date fromDate = now.getTime(); // Getting the IST date.
       
        now.add(now.DATE,6); // Getting the end date of the week.
        Date toDate = now.getTime(); // Getting the IST date.
        // Converting the US time zone into Australia(Sydney) Zone
         if(AUS_TIME_ZONE.equals(timeZone)) // Setting the Australia time zone.
         {
                fromDate = DateUtil.getAusDate(fromDate);
                toDate = DateUtil.getAusDate(toDate);
         }
System.out.println("fromdate.....="+fromDate + "toDate....=" + toDate);
        // setting the time as 0:0:1 am
        fromDate.setHours(0);
        fromDate.setMinutes(0);
        fromDate.setSeconds(1);
        pciquery.setFromDate(fromDate); // Calendar Start Date...
    
        
        // setting the time as 0:0:1 am
        toDate.setHours(23);
        toDate.setMinutes(59);
        toDate.setSeconds(59);
        pciquery.setToDate(toDate); // Calendar End Date...

        
        pciquery.setCacheRefresh(120); // OSCache refresh time is 15 minutes.

System.out.println("pciquery....."+pciquery.toQueryString(false));

    
        Object[] results = mngr.getPCIContent(pciquery, sling);
    
        return results;
    }


   /*
     * Method that gets the calendar-data(PCIResult object) from PCI Interface Layer.
     * @param HttpServletRequest, JcrPropertyMap
     * return an array of PCIResult object.
     */
    public Object[] getCalendarInfo(HttpServletRequest cqReq, CalendarManager mngr, 
            org.apache.sling.jcr.resource.JcrPropertyMap properties, SlingScriptHelper sling, JspWriter out, Date stDate)
        throws Exception {

        PCIQuery pciquery = new PCIQuery();
        Calendar now = Calendar.getInstance();
    
        String resultCount = "1000";
        String actionType = "read";
        String categoryID = (String) properties.get("categoryId","1000");
        String audience = (String) properties.get("audience","CorpEmployees");
        String entityType = (String) properties.get("mcdEntity","AU");      
        String viewType = (String) properties.get("viewType","content");
        String sortType = (String) properties.get("sorttype","chrono");
        String timeZone = (String) properties.get("timezone","aus");
        
//wei testing
/*
        pciquery.setAudience(audience);
        pciquery.setCategoryID(categoryID);
        pciquery.setResultCount(resultCount);
        pciquery.setSortType(sortType);
        pciquery.setEntityType(entityType);
        pciquery.setActionType(actionType);
        pciquery.setViewType(viewType);
*/        
        
        pciquery.setAudience("CorpEmployees");
        pciquery.setCategoryID("3000");
        pciquery.setResultCount("10");
        pciquery.setSortType("chrono");
        pciquery.setEntityType("US");
        pciquery.setActionType(actionType);
        pciquery.setViewType(viewType);
        
        
//end of testing
          
        Date fromDate = stDate; // Getting the starting date
       
        now.add(now.DATE,6); // Getting the end date of the week.
        Date toDate = now.getTime(); // Getting the IST date.
        // Converting the US time zone into Australia(Sydney) Zone
         if(AUS_TIME_ZONE.equals(timeZone)) // Setting the Australia time zone.
         {
                fromDate = DateUtil.getAusDate(fromDate);
                toDate = DateUtil.getAusDate(toDate);
         }

        // setting the time as 0:0:1 am
        fromDate.setHours(0);
        fromDate.setMinutes(0);
        fromDate.setSeconds(1);
        pciquery.setFromDate(fromDate); // Calendar Start Date...
    
        
        // setting the time as 0:0:1 am
        toDate.setHours(23);
        toDate.setMinutes(59);
        toDate.setSeconds(59);
        pciquery.setToDate(toDate); // Calendar End Date...

        
        pciquery.setCacheRefresh(120); // OSCache refresh time is 15 minutes.

//System.out.println("pciquery....."+pciquery.toQueryString(false));

    
        Object[] results = mngr.getPCIContent(pciquery, sling);
    
        return results;
    }
%>


<%
       
   String loggedUserAudType="";
   DesEncrypter encrypter = new DesEncrypter();
   String encryptedAudType="";
   
   String publishDate = "";
   String categoryTitle = "";
   String activityName = "";
   String description = "";
   String audType = "";
   String launchType = "";
   String activityPageURI = "";
   String contentID = "";
   
   try
    {
    
        HttpServletRequest cqReq = (HttpServletRequest) request;
        CalendarManager mngr = new CalendarManager();
        CalendarHelper helper = new CalendarHelper();
        final User user = slingRequest.getResourceResolver().adaptTo(User.class);
        
        String corpEmployeeAudName = "CorpEmployees"; // Employee Audience Type
        
        String franchiseeAudName = "Franchisees"; // Employee Audience Type
        
        // Getting no of weeks, calendar need to scroll for.
        String cachePageCount = properties.get("showLimit","1"); // The no of weeks, a user can scroll for.
        
        // ****** Block to find out logged-in user audience type ***** //
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
           
                    
                 }
            } catch (RepositoryException e) {
            } finally {
                if (session!=null) {
                    session.logout();
                }
            }
        }

        loggedUserAudType="CorpEmployees";
        
       // audience type Block ends here // 
        int weekdaycount = 1;               // counting the week's day.
        boolean closeCalendarDIV = false;   // variable identifies that when to close the calendar activity div. 

  
        Calendar now = Calendar.getInstance();
        Date startDt = now.getTime();   
        
            
//        Object[] calendarContent = getCalendarInfo(cqReq, mngr, (org.apache.sling.jcr.resource.JcrPropertyMap)properties, sling, out);
        Object[] calendarContent = getCalendarInfo(cqReq, mngr, (org.apache.sling.jcr.resource.JcrPropertyMap)properties, sling, out,startDt);
        System.out.println("calendarContent=" + calendarContent.length);
        
           //end selected date
      
        // StringBuffer staff contains the data of Employee audience type.
        StringBuffer staff = new StringBuffer();
        
        // StringBuffer restaurant contains the data for Franchisee users.
        StringBuffer restaurant = new StringBuffer();
        
        /*
        // Varibles that will hold the audience specific image
        String staffImagePath = "";
        String restImagePath = "";
        
        // int variables that will help in picking-up the first image path of a perticular date.
        int staffCount = 1;
        int restCount = 1;
            
        String prevActivityDate = ""; // Variable to store the previous date.
        
        String currentPagePath = currentPage.getPath(); // CQ path of the page
        if(currentPagePath != null && currentPagePath.startsWith("/content"))
            currentPagePath = currentPagePath.replace("/content/","/");
        */
      
        PCIResult pciresult = (PCIResult)calendarContent[0];
        String firstDayDate = pciresult.getPublishDate();
        
        // Rendering the calendar data.
        for(int i=0;i<calendarContent.length;i++)
        {
            closeCalendarDIV = false;
            PCIResult activity = (PCIResult)calendarContent[i];
            
            int count = i+1;
            String classCurve="calendard";              // div(curve) class for week days
            String classCalendarDiv = "calendarfgd";    // activity-div for week days
            String rndCornerClass = "calendar";         // class from calendar1-calendar5 to create rounded conrners
            String showHide = "";
            String open_close_text="";
            String opencloseclass = "";
            String activityTitle = "";
            
            boolean isStaffDataExist = false;
            boolean isFranchiseeDataExist = false;
            
            publishDate = activity.getPublishDate();
            String serverHostDomain = activity.getServerHostDomain();
            String calActivityDate = activity.getPublishDate();
            audType = activity.getAudienceType();
            activityName = activity.getDocumentTitle();
            categoryTitle = activity.getCategoryTitle();
            activityPageURI = activity.getPageURI();
            launchType = activity.getLaunchType();
            description = activity.getDescription();
            serverHostDomain = (serverHostDomain == null) ? "" : serverHostDomain.trim();
            activityName = (activityName == null) ? "" : activityName.trim();                
            audType = (audType == null) ?  "0" : audType.trim();
            categoryTitle = (categoryTitle == null) ? "" : categoryTitle.trim();
            activityPageURI = (activityPageURI == null) ? "" : activityPageURI.trim();
            description = (description == null) ? "" : description.trim();
            launchType = (launchType == null) ? "0" : launchType.trim();
            contentID = activity.getContentID();
     /*
            System.out.println("publishDate=" + publishDate);
            System.out.println("serverHostDomain=" + serverHostDomain);
            System.out.println("calActivityDate=" + calActivityDate);
            System.out.println("categoryTitle=" + categoryTitle);
            System.out.println("activityPageURI=" + activityPageURI);
            System.out.println("calActivityDate=" + calActivityDate);
            System.out.println("activityName=" + activityName);
            System.out.println("description=" + description);
            System.out.println("audType=" + audType);
            System.out.println("pageURI=" + activityPageURI);
            System.out.println("launchType=" + launchType);
       */
            
          %>
               
         <div>
         <!-- wei's testing-->
         <script>
        // var testValues = [{"postingDate":"12/02/2011",  "title":"<%=activityName%>",  "description":"wei test description",  "prefix": "For Action", "prefixText": "prefixText", "audienceStaff": "1", "linkStaff": "www.yahoo.com", "displayStaff": "2", "audienceFranchiees": "4", "linkFranchiees": "google.com/test.html", "displayFranchiees": "2", "view": "4", "action":"edit", "contentID": "<%=contentID%>"}];
        // var testTitle = "<%=activityName%>";
        // alert("tesvalues=" + testTitle);
         </script>
         
          <b><%=calActivityDate%></b><br> 
          <button type="button" onclick="javascript:openNoticeBoardDialog1('edit', 'noticeBoard', <%=contentID%>);">  
          <!--button type="button" onclick="javascript:openNoticeBoardDialog('edit', '28/02/2011','<%//=activityName%>', '<%//=description%>', '<%//=audType%>', '<%//=activityPageURI%>', '<%//=lanuchType%>');"-->  
          <!--button type="button" onclick="javascript:openNoticeBoardDialog('edit', '28/02/2011','title', 'description', '1', 'yahoo.com', '2');"-->  
          <img src="/images/edit.png" border="0" size="10" alt="Edit" />
          </button>
          <button type="button" onclick="openNoticeBoardDialog1('delete', 'noticeBoard','deleting');">
          <img src="/images/delete.png" border="0" size="10" alt="Delete" />
          </button>
          <a href=<%=activityPageURI%>><%=activityName%></a><%=description%><%=contentID%>
          <br>
         </div>
         
<%
   }
 
   } catch( Exception e) {
   }
   

%>
<!--/ul-->
</div>
<!-- wei - include a calendar --> 
        <div>
                 <script type="text/javascript" src="/scripts/datetimepicker_css.js"></script>
                 <form action="/utility/utility.calendarpostentry.html" menhod="post" target="foo" onsubmit="window.open('', 'foo', 'width=500,height=500')"--> 
                 <form>
                
                 Pick a Date: <input type="text" name="posting_date" size="16" maxlength="20" value="" id="posting_date1" style="font-size: 9pt;">
                 <a href="javascript:NewCssCal('posting_date1','mmddyyyy','dropdown',false,24)"><img src="/images/cal.gif" width="16" height="16" border="0" alt="Pick a date"></a>
                 <br>
                 <input type="hidden" name="action" value="add"> 
                 <!--input type="submit" name="submit" onClick="test();"  value="Add a New Entry"--> 
                 <button type="button" onClick="openNoticeBoardDialog1('add', 'noticeBoard', '');"><img src="/images/add.png" border="0" size="10" alt="Add a New Entry" /></button> Add a New Notice Board Entry
                 </form>
         </div> 