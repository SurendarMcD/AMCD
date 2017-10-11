<%--    
  ==============================================================================
 
  Calendar component

  Gets the Calendar-Data (PCIResult object) from PCIInterface Layer and make an
  AJAX call using globing pattern to load the calendar-data of next/previous weeks.
  
  Wei 01/2011 - Add, edit, delete and display calendar entries
 ==============================================================================
--%>
      
<%@include file="/apps/mcd/global/global.jsp" %>
<%@page import="java.util.Date,
                   java.util.Calendar,
                   java.util.Iterator,
                   java.util.TimeZone,
                   java.util.GregorianCalendar,
                   java.net.URLEncoder,
                   java.text.SimpleDateFormat,
                   java.util.LinkedHashMap,
                   java.util.Collection,
                   java.util.Iterator,
                   java.util.Map,
                   java.util.Set,
                   java.util.ArrayList"%>
    
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
                   org.apache.sling.api.SlingHttpServletRequest,
                   com.day.cq.wcm.api.WCMMode" %>                   
                   
<%@page import="com.mcd.accessmcd.aucalendar.util.CalendarUtil"%>
                   
<%@ page import="com.day.cq.widget.HtmlLibraryManager" %><%
%>
<%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects/>
<%
   response.setHeader("Cache-Control","no-cache");
   response.setHeader("Cache-Control","no-store");
   response.setDateHeader("Expires", 0);
   response.setHeader("Pragma","no-cache");
%>
<div id="calendarpart"> 

<%!
    //variable to check the for Australia Time Zone.
    private static final String AUS_TIME_ZONE = "aus"; 
    
    /*
     * Method that gets the calendar-data(PCIResult object) from PCI Interface Layer.
     * @param HttpServletRequest, JcrPropertyMap
     * return an array of PCIResult object.
     */
    public Object[] getCalendarInfo(HttpServletRequest cqReq, CalendarManager mngr, 
            org.apache.sling.jcr.resource.JcrPropertyMap properties, SlingScriptHelper sling, JspWriter out, Date stDate, String loggedUserAudType, String loggedUserView)
        throws Exception {

        PCIQuery pciquery = new PCIQuery();
        
        String resultCount = "1000";
        String actionType = "read";
        String categoryID = "3000";
        String audience = loggedUserAudType;
        String entityType = loggedUserView;  
        String viewType = "content";
        String sortType = "chronouuid";
        String timeZone = "aus";
             
        pciquery.setAudience(audience);
        pciquery.setCategoryID(categoryID);
        pciquery.setResultCount(resultCount);
        pciquery.setSortType(sortType);
        pciquery.setEntityType(entityType);
        pciquery.setActionType(actionType);
        pciquery.setViewType(viewType);      

        Date fromDate = stDate;
        Calendar tDate= Calendar.getInstance(); 
        tDate.setTime(fromDate);
        tDate.add(Calendar.DATE,6);                // Generating the end date of calendar..
        Date toDate = tDate.getTime(); // Getting the IST date.
        
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
        pciquery.setToDate(toDate);   // Calendar End Date...
        
        pciquery.setCacheRefresh(0); // OSCache refresh time is 0 minutes.
       //  pciquery.setCacheRefresh(120); // OSCache refresh time is 15 minutes.
    
        Object[] results = mngr.getPCIContent(pciquery, sling);
    
        return results;
    }
    
%>

<%
   
   String loggedUserAudType="CorpEmployees";
   String loggedUserView="";
   DesEncrypter encrypter = new DesEncrypter();
   String encryptedAudType="";
   String tempuuid = "";   
   String tempView = "";   
   
   ArrayList al = new ArrayList();
   String record = "";
   String lastRecord = "";
   
   String[] fields = null;
   String[] fieldNameValue= null;
   int alSize = 0;
   String tempAudType = "";
   String tempAudType1 = "";
   String tempEntityType = "";
   
   String aud1 = "";
   String link1 = "";
   String aud2 = "";
   String link2 = "";
   String display1 = "";
   String display2 = "";
   String openWin1 = "";
   String openWin2 = "";  
   String audRecord = "";  
   String  tempCalActivityDate  = "";  
   boolean showOtherDay = false;
   
   
   String defaultView = "";
   String viewPagePath = currentPage.getPath(); 
   
   String tEntity = "";
   //System.out.println("page path=" + viewPagePath);
   if (viewPagePath.indexOf("/accessmcd/apmea/au") != -1) 
      defaultView = "AU"; 
   if (viewPagePath.indexOf("/accessmcd/apmea/nz") != -1) 
      defaultView = "NZ"; 
      
   /*System.out.println("address=" + defaultView);*/
       
   Map<String,String> audMap=new LinkedHashMap<String, String>();
    
   try
    {
        HttpServletRequest cqReq = (HttpServletRequest) request;
        
//judy add for date picker
          //judy add select date
        String fromDate="now";
       
/*
        if (cqReq.getParameter("fromDate")!=null)
            fromDate = cqReq.getParameter("fromDate");
        SimpleDateFormat mydf = new SimpleDateFormat("MM/dd/yyyy"); 
*/

        SimpleDateFormat mydf =new SimpleDateFormat("MM_dd_yyyy");
        Calendar nDate= Calendar.getInstance(); 
        Date stDate= nDate.getTime();

        String requestURI = cqReq.getRequestURI();
//System.out.println("not......requestURI:: "+requestURI );   
        
        String caledarGlobPart = requestURI.substring(requestURI.lastIndexOf("/")+1);
        String urlParam[] = caledarGlobPart.split("\\.");
//System.out.println("not......urlParam:: "+urlParam.length);   
        if (urlParam.length>3 && urlParam[2]!=null)
           fromDate = urlParam[2];
//System.out.println("not......fromDate :: "+ fromDate );  

        if (!fromDate.equals("now")){
              try{  
                Date tempDt= mydf.parse(fromDate);
                if (tempDt!=null)
                   stDate=tempDt;
              }catch(java.text.ParseException ep) {}
        }
          
        nDate.setTime(stDate);
        nDate.add(Calendar.DATE,7);                
        String nextWk = mydf.format(nDate.getTime()); 
//        nextWk = DateUtil.getAusDate(nextWk );
        
        nDate.add(Calendar.DATE,-14);                
        String preWk = mydf.format(nDate.getTime()); 
//end add        
        CalendarManager mngr = new CalendarManager();
        CalendarHelper helper = new CalendarHelper();
        CalendarUtil util = new CalendarUtil();
        final User user = slingRequest.getResourceResolver().adaptTo(User.class);
        
        String corpEmployeeAudName = "CorpEmployees"; // Employee Audience Type
        
        String franchiseeAudName = "Franchisees"; // Employee Audience Type
        
        // Getting no of weeks, calendar need to scroll for.
        String cachePageCount = properties.get("showLimit","1"); // The no of weeks, a user can scroll for.
        
        if(WCMMode.fromRequest(request) == WCMMode.DISABLED) {
             loggedUserAudType = util.getLoggedUserAudType(sling, user);  
             loggedUserView = defaultView;
             encryptedAudType= encrypter.encrypt(loggedUserAudType).replace("/","");
        } else {
            loggedUserAudType = "ALL";
            loggedUserView = "ALL";
            encryptedAudType = "ALL";            
        }

//judy, encrypt the aud
      //  if (loggedUserAudType!=null && !loggedUserAudType.equalsIgnoreCase("ALL"))
       //     encryptedAudType= encrypter.encrypt(loggedUserAudType).replace("/","");

//System.out.println("loggedUserAudType ::"+ loggedUserAudType  );
//System.out.println("encryptedAudType::"+ encryptedAudType);



             
       // audience type Block ends here // 
        int weekdaycount = 1;               // counting the week's day.
        boolean closeCalendarDIV = false;   // variable identifies that when to close the calendar activity div. 

        Object[] calendarContent = getCalendarInfo(cqReq, mngr, (org.apache.sling.jcr.resource.JcrPropertyMap)properties, sling, out,stDate, loggedUserAudType, loggedUserView);
        
        //end selected date
        
        // StringBuffer staff contains the data of Employee audience type.
        StringBuffer staff = new StringBuffer();
        
        // StringBuffer restaurant contains the data for Franchisee users.
        StringBuffer restaurant = new StringBuffer();
        
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
        
        /**** Getting first day-date of calendar ****/
        PCIResult pciresult = (PCIResult)calendarContent[0];
        String firstDayDate = pciresult.getPublishDate();
        
        
        //Map<String,String> audMap=new LinkedHashMap<String, String>();
        
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
            
            String serverHostDomain = activity.getServerHostDomain();
            String calActivityDate = activity.getPublishDate();
            String audType = activity.getAudienceType();
            
            String entityType = activity.getEntityType();
            String activityName = activity.getDocumentTitle();
            String categoryTitle = activity.getCategoryTitle();
            String activityPageURI = activity.getPageURI();
            String uuid = activity.getUUID();
            
              
            uuid = (uuid == null) ? "" : uuid.trim();
            //out.println("uuid=" + uuid);

            serverHostDomain = (serverHostDomain == null) ? "" : serverHostDomain.trim();
            activityName = (activityName == null) ? "" : activityName.trim();                
            audType = (audType == null) ?  "" : audType.trim();
            
            //wei - for display Staff instead of CorpEmployees
            if (audType.equals("CorpEmployees"))
                audType = "Staff";            
            
            //out.println("AUDType : " + audType + "<br>");    
            entityType = (entityType == null) ?  "0" : entityType.trim();
            categoryTitle = (categoryTitle == null) ? "" : categoryTitle.trim();
            activityPageURI = (activityPageURI == null) ? "" : activityPageURI.trim();
            
            //out.println("Entity Type : " + entityType + "<br>" );
            /*if(!audMap.containsKey(audType)){
                audMap.put(audType,activityPageURI); 
            }*/              
 
            // Getting the name of the day (Sunday/Monday/etc...)
            //String weekday = DateUtil.getDay(calActivityDate, "MM-dd-yyyy hh:mm:ss");
            String weekday = DateUtil.getDay(calActivityDate);
                        
            String month=DateUtil.getMonth(calActivityDate);
            
            // Getting the date (1/2/3/...) to load the date icon image through css sprite..
            Date dateOfActivity = DateUtil.stringToDate(calActivityDate);
            
            if(firstDayDate.equals(calActivityDate))                  // Checking if fisrt entry is of Today's date
            {
                classCurve="calendarh";                 // div(curve) class for today
                classCalendarDiv = "calendarfgd_big_today";   // activity-div class for today
                // karan - uncommented this code to match html 
                activityTitle = "Today's Highlights"; 
                showHide = "display:block";
                open_close_text = "close";
                opencloseclass = "closeimageicon";
                /* wei - comment out here */
            }
            else if("saturday".equalsIgnoreCase(weekday) || "sunday".equalsIgnoreCase(weekday)) // Checking for sat & sun
            {
                classCurve="calendar_curve";            // div(curve) class for week-end days
                classCalendarDiv = "calendarfg";        // activity-div class for week-end days
                rndCornerClass = "calendar_curve";
                
                activityTitle = weekday;
                showHide = "display:none";
                open_close_text = "open";
                opencloseclass = "openimageicon";
                /*if(!"".equals(calActivityDate) && !"".equals(activityName)){
                        
                        classCurve="calendarh";                 
                        classCalendarDiv = "calendarfgd_big_today";  
                        
                        showHide = "display:block";
                        open_close_text = "close";
                        opencloseclass = "closeimageicon";
                         
                      
               } */   
            }
            else                                       // Running block for rest of the weed days.
            {
                activityTitle = weekday;
                showHide = "display:none";
                open_close_text = "open";
                opencloseclass = "openimageicon";
                
                 /*if(!"".equals(calActivityDate) && !"".equals(activityName)){
                        classCurve="calendarh";                 
                        classCalendarDiv = "calendarfgd_big_today";  
                        
                        showHide = "display:block";
                        open_close_text = "close";
                        opencloseclass = "closeimageicon";
                 }*/    
            } 
              
                
               
            // Initializing the string buffers to contain the data for staff and restaurant users.
            if(!prevActivityDate.equals(calActivityDate))
            {
                if(weekdaycount == 1 )
                {
    %>                      
                    <div class='firstdiv'> 
     
                      <DIV class='calendarLeft'>
                        <B class='calendarh calendarRoundCorners'>
                        <%=  helper.topRoundCorner(rndCornerClass) %>
                        
                        <DIV class=activityMyWeek id=activityMyWeek >
                            <DIV id=calendar_day><div class='myweekahead' ></div><SPAN class=act_left_area>My week ahead</SPAN></DIV>
                            <DIV id=calendardayMyWeek class=calendardayMyWeek></DIV>
                        </DIV>
                        <B class='calendarh calendarRoundCorners'>
                        <%=  helper.bottomRoundCorner(rndCornerClass) %>
                    </DIV>
                       
                    <div class='calendarRight'>
                        <B class='calendarh calendarRoundCorners'>
                        <%=  helper.topRoundCorner(rndCornerClass) %>
                        <div class='showToday'>
                            <div class="showToday_text"> <a href="javascript:getCalData('<%= currentPagePath %>', '<%=encryptedAudType %>', 0, '<%= cachePageCount %>','now')">Show me today</a></div>
                            <div class='showToday_image'>
                                <a href='#'  onClick='window.location.reload();' class='showToday_LinkStyle' >
                                    <div class='refresh_image'></div><div class='refresh_text'>refresh</div>
                                </a>
                            </div>
                            <div class='clearBoth'></div>
                        </div>
                        <B class='calendarh calendarRoundCorners'> 
                        <%=  helper.bottomRoundCorner(rndCornerClass) %>
                        
                    </div> 
    <%          
                   //wei - commented out the following two lines
                   staff = new StringBuffer("\n\r<div class='staffdetails'>");
                   restaurant = new StringBuffer("\n\r<div class='restDetails'>");
                   // staff = new StringBuffer("\n\r<div class='staffdetails'><h3>Staff</h3>");
                   // restaurant = new StringBuffer("\n\r<div class='restDetails'><h3>Licensees / Restaurants</h3>");
                    
                }else
                {
                    staff = new StringBuffer("\n\r<div class='staffdetails'>");
                    restaurant = new StringBuffer("\n\r<div class='restDetails'>");
                }
    %>
        
                <div class='calendar' >
                <b class='<%=classCurve%> calendarRoundCorners' >
                <%=  helper.topRoundCorner(rndCornerClass) %>
                         
                 <div id='activity<%=count%>'  class='<%=classCalendarDiv%>' >     
                   
                      <div id='calendar_day'>
                           <div class='act_month_area'><%=month%></div>
                           <div class='dateicon<%=dateOfActivity.getDate()%>'></div>
                          
                          <span class='act_left_area'><%=activityTitle%></span>
                          
                          <span class='act_right_area'>
                           <%--
                              <a href='javascript:;' onclick="showOrHide('activity<%=count%>','calendarday<%=count%>', 'img<%=count%>', 'openclose<%=count%>', 'open_close_img_div<%=count%>')" >
                              --%>
                              <a id="calShowHide" href='javascript:;' onclick="showHideDay('<%=count%>')" >
                                  <span class='openclose' id='openclose<%=count%>' ><%=open_close_text%></span>  
                                  <div id="open_close_img_div<%=count%>" class='<%=opencloseclass%>' ></div>
                             </a>
                          </span>
    
                      </div>            

              
                      <div class='calendarday' id='calendarday<%=count%>' style='<%=showHide%>' >
                      
                      
    <%                
                
            }
            
            
            //wei - modify here for external url:
            if (activityPageURI.startsWith("/"))
                activityPageURI = (activityPageURI.equals("") ? "#" :  serverHostDomain+activityPageURI+ ".html");  
            else if ("".equals(activityPageURI))
                activityPageURI = "#";                           
              
            String launchType  = activity.getLaunchType();
            String openWin = "";
            
            if(launchType==null){
                launchType = "";
            }           
            if(launchType.equals("2")){
                openWin = "_blank";             
            } 
            
             //out.println("Aud Type : " + audType + "   I : " + i +"<br>");      
            if (!uuid.equals("")) {
                if (!uuid.equals(tempuuid)) {
                    
                    record = "uuid==" + uuid + ";;" + "title==" + activityName + ";;" + "postingDate==" + calActivityDate + ";;"
                             + "audience==" + audType + "|" + activityPageURI + "|" + launchType + ";;" + 
                              "entityType==" + entityType;
                                                                
                    //System.out.println("record=" + record);
                    al.add(record); 
                }
                else{
                    // update record
                    alSize = al.size();
                    
                    lastRecord = (String) (al.get(alSize - 1));
                    //System.out.println("lastrecord = " + lastRecord);
                    
                    fields = lastRecord.split("\\;;");
                    
                    for (int k=0; k<fields.length; k++) {
                        fieldNameValue = fields[k].split("==");   
                    
                        if (fields[k].indexOf("uuid") != -1) uuid= fieldNameValue[1];
                        if (fields[k].indexOf("title") != -1) activityName = fieldNameValue[1];
                        if (fields[k].indexOf("postingDate") != -1) tempCalActivityDate = fieldNameValue[1];
                        if (fields[k].indexOf("audience") != -1)  tempAudType = fieldNameValue[1];   
                        
                        //if(currentPage.getPath().startsWith("/content/accessmcd/apmea/au") && fieldNameValue[1].equalsIgnoreCase("AU"))                                                        
                            if (fields[k].indexOf("entityType") != -1) tempEntityType = fieldNameValue[1];
                        //if(currentPage.getPath().startsWith("/content/accessmcd/apmea/nz") && fieldNameValue[1].equalsIgnoreCase("NZ"))    
                           // if (fields[k].indexOf("entityType") != -1) tempEntityType = fieldNameValue[1];
                    
                    }//end of for loop
                      
                    // System.out.println("tempAudType = " + tempAudType);       
                    //out.println("tempEntityType = " + tempEntityType);    
                    
                    //update audType and entity type
                    if (tempAudType.indexOf(audType) == -1 && !"".equals(audType) && !audType.equals("0")) 
                        tempAudType = tempAudType + ",," + audType + "|" + activityPageURI + "|" + launchType;
                    
                    if (tempEntityType.indexOf(entityType) == -1) 
                        tempEntityType = tempEntityType + "/" + entityType;  
                    
                    //out.println("Temp Aud Type :: " + tempAudType +"<br>");   
                    lastRecord = "uuid==" + uuid + ";;" + "postingDate==" + tempCalActivityDate + ";;" + "title==" + activityName + ";;" + "audience==" + tempAudType + ";;" + 
                    "entityType==" + tempEntityType;
                    
                      
                    al.remove(alSize - 1);
                    al.add(lastRecord); 
                    
                    tempAudType = "";
                    tempEntityType = "";
                    } //end of else
                     tempuuid = uuid;    
                 } // end of uuid if       
                     
                 
            
            
            prevActivityDate = calActivityDate;
   
            if(calendarContent.length > (i+1))
            {
                PCIResult nextAct = (PCIResult)calendarContent[i+1];
                String nextActDate = nextAct.getPublishDate();
                
                if(!nextActDate.equals(calActivityDate))
                {
                    closeCalendarDIV = true;  
                }
            }
            else
            {
                closeCalendarDIV = true;
            }
               
                                    
            if(closeCalendarDIV)
            {
                // re-assigning '1' to variable to pick the first image of next date.
                staffCount = 1;
                restCount = 1;                
                
                 //displaying
                     //out.println("AL Size: " + al.size() + "<br>");     
                Iterator it = al.iterator();
                for(int m=0; m<al.size(); m++){
                    //out.println("AL RC " + m + " : " + al.get(m) + "<br>"); 
                }
                while (it.hasNext()) {
                    record = (String) (it.next());
                    fields = record.split("\\;;");
                    
                    for (int p=0; p<fields.length; p++) {
                        fieldNameValue = fields[p].split("==");  
                    
                        if (fields[p].indexOf("uuid") != -1) uuid= fieldNameValue[1];                                 
                        if (fields[p].indexOf("title") != -1) activityName = fieldNameValue[1];   
                        if (fields[p].indexOf("postingDate") != -1) tempCalActivityDate = fieldNameValue[1];                                 
                        if (fields[p].indexOf("audience") != -1) audType = fieldNameValue[1];                                       
                        if (fields[p].indexOf("entityType") != -1) entityType = fieldNameValue[1];
                        //out.println("tempcalActivityDate  : " + tempCalActivityDate+ "<br>"); 
                        String[] audTypeFields = null;
                        String[] audTypeLinkFields1 = null;
                        String[] audTypeLinkFields2 = null;
                      
                        String audTypeLink1 = "";
                        String audTypeLink2 = ""; 
                             
                        //process audience type
                        
                        if (audType.indexOf(",,") != -1) {
                            audTypeFields = audType.split("\\,,");
                            audTypeLink1 = audTypeFields[0];
                            audTypeLink2 = audTypeFields[1];
                        } else {
                            audTypeLink1 = audType;  
                            audTypeLink2 = "";  
                        }
                        
                        if (!audTypeLink1.equals("")) {
                            if (audTypeLink1.indexOf("|") != -1) {
                                audTypeLinkFields1 = audTypeLink1.split("\\|");
                                aud1 = audTypeLinkFields1[0];
                                link1 = audTypeLinkFields1[1];
                                display1 = audTypeLinkFields1[2];
                            }
                        }
                          
                        if (!audTypeLink2.equals("")) {
                            if (audTypeLink2.indexOf("|") != -1) {
                                audTypeLinkFields2 = audTypeLink2.split("\\|");
                                aud2 = audTypeLinkFields2[0];
                                link2 = audTypeLinkFields2[1];
                                display2 = audTypeLinkFields2[2];
                            }
                        }
                        if(display1==null || display1.equals("0")) openWin1 = "";
                        if(display2==null || display2.equals("0")) openWin2 = "";
                        if(display1.equals("2")) openWin1 = "_blank";             
                        if(display2.equals("2")) openWin2 = "_blank"; 
                      
                      audType="";  
                    }//end of for loop      
                          
                  if (entityType.indexOf(defaultView) != -1) {
                  if(prevActivityDate.equals(tempCalActivityDate))  {      
                    
                  if(WCMMode.fromRequest(request) == WCMMode.DISABLED){
                      //restaurant.append(activityName+"<br>");
                      if (!link1.equals("#")) {
                          if(!link1.startsWith("/") && !link1.startsWith("http"))
                              link1 = "http://"+link1;
                              
                              restaurant.append("<a target='"+openWin1+"' href='"+link1+"'>"+activityName+"</a><br>");
                      }
                      else{
                          restaurant.append(activityName+"<br>");
                      }
                  } 
                  else{
                      String btns= "<button type=\"button\" onClick=\"openCalendarDialog('edit', 'calendar', '"+resource.getPath()+"','" + uuid + "', '')\"><img src=\"/images/edit.png\" border=\"0\" size=\"10\" alt=\"Edit\"></button><button type=\"button\" value=\"Delete\" onClick=\"confirmDelete('" + uuid + "','"+resource.getPath()+"');\"><img src=\"/images/delete.png\" border=\"0\" size=\"10\" alt=\"Delete\"></button>";       
                      restaurant.append(btns +"&nbsp;"+activityName+"<br>");
                     if (!aud1.equals("")){
                          if (!link1.equals("#")) {
                              if(!link1.startsWith("/") && !link1.startsWith("http"))
                                  link1 = "http://"+link1;
                                  
                                  restaurant.append("<a target='"+openWin1+"' href='"+link1+"'>"+aud1+"</a><br>");
                          }
                          else{
                              restaurant.append(aud1+"<br>");
                          }
                      }
                       
                      if (!aud2.equals("")){
                          if (!link2.equals("#")) {
                          
                              if(!link2.startsWith("/") && !link2.startsWith("http"))
                                  link2 = "http://"+link2;
                                                
                              restaurant.append("<a target='"+openWin2+"' href='"+link2+"'>"+aud2+"</a><br>");
                          }
                          else{
                              restaurant.append(aud2+"<br>");
                          }
                      }  
                      restaurant.append("<font size=1>"+entityType+"</font><br>");   
                  }     
                  
                  } 
                   
                  }     
                            
                    aud1 = "";
                    link1 = "";
                    aud2 = "";
                    link2 = "";   
                    openWin1 = "";
                    openWin2 = "";     
                }//end of while loop               
                
                if (!restaurant.toString().equals("")) {
                   out.println("<form>" + restaurant.toString() +"</form></div>"); 
                }
                
    %>      
    
   
                 <div class='todaysIcon'>                                          
    <%
               
                if((!"".equals(staffImagePath)) && (franchiseeAudName.equalsIgnoreCase(loggedUserAudType) || corpEmployeeAudName.equalsIgnoreCase(loggedUserAudType))) // Displaying the calendar image..
                {
    %>
                       <img src='<%= staffImagePath %>' />
    <%
              
                }
               
    %>     
              </div> 
       
            </div>         
          </div>           
       
          <b class='<%= classCurve %> calendarRoundCorners'> 
          <%=  helper.bottomRoundCorner(rndCornerClass) %> 
       </div>              
          <div class='blank_space'></div> 
    <%
    
              if(firstDayDate.equals(calActivityDate))
              {
    %>
                    </div> 
    <%              
              }
              // reinitialising the images to get the images for next date...
              staffImagePath = "";
              restImagePath = "";
            } // End of if(closeCalendarDIV)
            weekdaycount++;
            
          //cheking whether the tabs will be opened / closed
            if(count > 1 && ((isFranchiseeDataExist && (franchiseeAudName.equalsIgnoreCase(loggedUserAudType)))
                    || ((isStaffDataExist || isFranchiseeDataExist) 
                            && corpEmployeeAudName.equalsIgnoreCase(loggedUserAudType))))
            {  
             //out.println("Inside count if :: " + count);  
             %>
               
               <script>
               // Calling method to open the non-blank division.
                //   javascript:showOrHide('activity<%=count%>','calendarday<%=count%>', 'img<%=count%>', 'openclose<%=count%>', 'open_close_img_div<%=count%>');
                showHideDay('<%=count %>');
                
               </script>
               
    <%      }
    
        } // End of for loop.
                  
    %>  
 
<div id="scrollWks">
        
         <table class="calNavLinks">
            <tr>  
                <td align="left" width="50%" valign="top">
                    <div id="link_prev">
                        <b class="calendarh calendarRoundCorners">
                        
                        <%=  helper.topRoundCorner("calendar") %>
                        <div class="calendar_prevlink">
                            <span >
                                <div class="leftimageicon" id="leftimageicon" ></div>
                                <div class="prevlinkenabled" id="prevlinkenabled">
                                    <a href="javascript:getCalData('<%= currentPagePath %>', '<%=encryptedAudType %>', -1, '<%= cachePageCount %>','<%=preWk%>')" > Show me the last 7 days</a>
                                </div>
                                <div class="prevlinkdisabled" id="prevlinkdisabled" style="display:none;" >
                                    Show me the last 7 days
                                </div>
                            </span>                 
                        </div>
        
                        <b class="calendarh calendarRoundCorners">
                        <%=  helper.bottomRoundCorner("calendar") %> 
                    </div>
                </td>
                <td align="right" valign="top">          
                    <div id="link_next">
                        <b class="calendarh calendarRoundCorners"> 
                        <%=  helper.topRoundCorner("calendar") %>
        
                        <div class="calendar_nextlink">  
                            <span >
                                <div class="rightimageicon" id="rightimageicon"></div>
                                <div class="nextlinkenabled" id="nextlinkenabled">
                                    <a href="javascript:getCalData('<%= currentPagePath %>', '<%=encryptedAudType %>', 1, '<%= cachePageCount %>','<%=nextWk%>')" > Show me the next 7 days</a>
                                </div>
                                <div class="nextlinkdisabled" id="nextlinkdisabled" style="display:none;">
                                    Show me the next 7 days
                                </div>                            
                            </span>                 
                        </div>
        
                        <b class="calendarh calendarRoundCorners">
                        <%=  helper.bottomRoundCorner("calendar") %>
                    </div>
                </td>
            </tr>
        </table>
</div>

       
</div>   
<script>
<%
        for(int e=1;e<calendarContent.length;e++)
        {
                int ecount = e+1;  
%>
                          
                     var calHTML = $("#calendarday<%=ecount %> div.restDetails").html();
                     if(calHTML != '' && calHTML != null && calHTML !='</FORM>'){
                         //alert("calendarday <%=ecount %> :: "+ $("#calendarday<%=ecount %> div.restDetails").html());
                         //$('#calShowHide').triggerHandler('click');
                         showHideDay('<%=ecount%>')
                     }               
                       
                 
<%            
        }
        %>
</script>
<%
    }catch(Exception ex)
    {
         log.error("Calendar Information can't be retrieved "+ex);
    }
     
%>
</script>     
   
 
 
 
 
 
 
 
 