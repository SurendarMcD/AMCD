0. <%--
  ==============================================================================

  Calendar component

  Gets the Calendar-Data (PCIResult object) from PCIInterface Layer and make an
  AJAX call using globing pattern to load the calendar-data of next/previous weeks.
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
                    com.mcd.accessmcd.calendar.manager.CalendarManager,
                    com.mcd.accessmcd.calendar.util.DateUtil,
                    com.mcd.accessmcd.calendar.util.CalendarHelper,
                    com.mcd.accessmcd.calendar.util.DesEncrypter"
    %>
    <%@ page import="com.day.cq.security.Authorizable,
                     com.day.cq.security.User,
                     com.day.cq.security.UserManager,
                     com.day.cq.security.UserManagerFactory,
                     org.apache.sling.jcr.api.SlingRepository,
                     org.apache.sling.api.scripting.SlingScriptHelper,
                     org.osgi.framework.BundleActivator
                     
    "%>    
    
    <%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
    <sling:defineObjects/>
                    
        <!-- Creating Unique calendar id to identify if more than one calendar component
             put on a single page... 
         -->
        <div id="calendarpart"> 
           <div id="ajaximage" class="ajaximage">  
                <div style="float:left;"><img src="/apps/mcd/docroot/images/ajax-loader.gif" /></div>
                <h3>&nbsp;&nbsp;Loading...</h3>
           </div> <!--  End of ajaximage <div> -->
    
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
        String categoryID = (String) properties.get("categoryId","1000");
        String audience = (String) properties.get("audience","CorpEmployees");
        String entityType = (String) properties.get("mcdEntity","AU");      
        String viewType = (String) properties.get("viewType","content");
        String sortType = (String) properties.get("sorttype","chrono");
        String timeZone = (String) properties.get("timezone","aus");
        
    
        pciquery.setAudience(audience);
        pciquery.setCategoryID(categoryID);
        pciquery.setResultCount(resultCount);
        pciquery.setSortType(sortType);
        pciquery.setEntityType(entityType);
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
    
        Object[] results = mngr.getPCIContent(pciquery, sling);
    
        return results;
    }
       
%>
<%
   String loggedUserAudType="";
   DesEncrypter encrypter = new DesEncrypter();
   String encryptedAudType="";
   
   

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
        
        //loggedUserAudType="CorpEmployees";
        
       // audience type Block ends here // 
        int weekdaycount = 1;               // counting the week's day.
        boolean closeCalendarDIV = false;   // variable identifies that when to close the calendar activity div. 
        Object[] calendarContent = getCalendarInfo(cqReq, mngr, (org.apache.sling.jcr.resource.JcrPropertyMap)properties, sling, out);
    
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
            String activityName = activity.getDocumentTitle();
            String categoryTitle = activity.getCategoryTitle();
            String activityPageURI = activity.getPageURI();

            serverHostDomain = (serverHostDomain == null) ? "" : serverHostDomain.trim();
            activityName = (activityName == null) ? "" : activityName.trim();                
            audType = (audType == null) ?  "" : audType.trim();
            categoryTitle = (categoryTitle == null) ? "" : categoryTitle.trim();
            activityPageURI = (activityPageURI == null) ? "" : activityPageURI.trim();
    
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
                
                activityTitle = "Today's Highlights";
                showHide = "display:block";
                open_close_text = "close";
                opencloseclass = "closeimageicon";
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
            }
            else                                       // Running block for rest of the weed days.
            {
                activityTitle = weekday;
                showHide = "display:none";
                open_close_text = "open";
                opencloseclass = "openimageicon";
            }

            // Initializing the string buffers to contain the data for staff and restaurant users.
            if(!prevActivityDate.equals(calActivityDate))
            {
                if(weekdaycount == 1 )
                {
    %>                      
                    <div class='firstdiv'> <!--  First division of calendar. -->
    
                      <DIV class='calendarLeft'>
                        <B class='calendarh calendarRoundCorners'>
                        <!--  Creating top rounded corners -->
                        <%=  helper.topRoundCorner(rndCornerClass) %>
                        
                        <DIV class=activityMyWeek id=activityMyWeek >
                            <DIV id=calendar_day><div class='myweekahead' ></div><SPAN class=act_left_area>My week ahead at McDonald's </SPAN></DIV>
                            <DIV id=calendardayMyWeek class=calendardayMyWeek></DIV>
                        </DIV>
                        <B class='calendarh calendarRoundCorners'>
                        <!--  Creating bottom rounded corners -->
                         <%=  helper.bottomRoundCorner(rndCornerClass) %>
                    </DIV>
                       
                    <div class='calendarRight'>
                        <B class='calendarh calendarRoundCorners'>
                        <!--  Creating top rounded corners -->
                        <%=  helper.topRoundCorner(rndCornerClass) %>
                        <div class='showToday'>
                            <div class="showToday_text"> <a href='#' onClick="JavaScript:getAjaxData('<%= currentPagePath %>', '<%=encryptedAudType %>', 0, '<%= cachePageCount %>')">Show me today</a></div>
                            <div class='showToday_image'>
                                <a href='#'  onClick='window.location.reload();' class='showToday_LinkStyle' >
                                    <div class='refresh_image'></div><div class='refresh_text'>refresh</div>
                                </a>
                            </div>
                            <div class='clearBoth'></div>
                        </div>
                        <B class='calendarh calendarRoundCorners'> 
                         <!--  Creating bottom rounded corners -->
                         <%=  helper.bottomRoundCorner(rndCornerClass) %>
                        
                    </div> 
    <%          
                    staff = new StringBuffer("\n\r<div class='staffdetails'><h3>Staff</h3>");
                    restaurant = new StringBuffer("\n\r<div class='restDetails'><h3>Licensees / Restaurants</h3>");
                }else
                {
                    staff = new StringBuffer("\n\r<div class='staffdetails'>");
                    restaurant = new StringBuffer("\n\r<div class='restDetails'>");
                }
    %>
                <div class='calendar' >
                <b class='<%=classCurve%> calendarRoundCorners' >
                <!--  Creating top rounded corners -->
                <%=  helper.topRoundCorner(rndCornerClass) %>
                         
                 <div id='activity<%=count%>'  class='<%=classCalendarDiv%>' >     
                   
                      <div id='calendar_day'>
                           <div class='act_month_area'><%=month%></div>
                          <div class='dateicon<%=dateOfActivity.getDate()%>'></div>
                          
                          <span class='act_left_area'><%=activityTitle%></span>
                          
                          <span class='act_right_area'>
                              <a href='javascript:;' onclick="showOrHide('activity<%=count%>','calendarday<%=count%>', 'img<%=count%>', 'openclose<%=count%>', 'open_close_img_div<%=count%>')" >
                                  <span class='openclose' id='openclose<%=count%>' ><%=open_close_text%></span>  
                                  <div id="open_close_img_div<%=count%>" class='<%=opencloseclass%>' ></div>
                             </a>
                          </span>
    
                      </div>              <!--  end of calendar_day <div>  -->
              
                      <div class='calendarday' id='calendarday<%=count%>' style='<%=showHide%>' >
    <%                
            }
    
            /* If there is no pageURL associated with any of calendar activity, then targetting it to
             *  blank URL(#) to avoid creation of broken links...
             */
            activityPageURI = (activityPageURI.equals("") ? "#" :  serverHostDomain+activityPageURI);
            
            /*getting lauchType from the PCIResult and open links in new or same window
              0 and 1 -> open link in the same window
              2 and 3 -> open link in the new window
            */
            String launchType  = activity.getLaunchType();
            String openWin = "";
            
            if(launchType==null){
                launchType = "";
            }           
            if(launchType.equals("2") || launchType.equals("3")){
                openWin = "_blank";             
            }           
            // end of addition of opening window code
            
            // preparing the divisions for Employee and Franchisee users.
            if((!activityName.equals("")) && (audType.indexOf(franchiseeAudName) > -1 )&& (audType.indexOf(corpEmployeeAudName) > -1 )) // Checking if audience type is of restaurant type.
            {
                restaurant.append("\n\r <a target='"+openWin+"' href='"+activityPageURI+"'>"+activityName+"</a> <br>");
                if((restCount == 1) || (restImagePath.equals(""))){
                    restImagePath = activity.getImageURI();
                    restImagePath = (restImagePath == null) ? "" : restImagePath.trim();
                    restCount++;
                }
                isFranchiseeDataExist = true;
            }
            else if((!activityName.equals("")) && (audType.indexOf(corpEmployeeAudName) > -1 ))
            {
                staff.append("\n\r <a target='"+openWin+"' href='"+activityPageURI+"'>"+activityName+"</a> <br>");
                if((staffCount == 1) || (staffImagePath.equals(""))){
                    staffImagePath = activity.getImageURI();
                    staffImagePath = (staffImagePath == null) ? "" : staffImagePath.trim();
                    staffCount++;
                }
                isStaffDataExist = true;
            } 
              
            /*********** Displaying the data on the page *****************/
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
                
                if(!restaurant.toString().equals("") && (franchiseeAudName.equalsIgnoreCase(loggedUserAudType) || corpEmployeeAudName.equalsIgnoreCase(loggedUserAudType)))
                {
                    // end of Div staffdetails (opening in restaurant SB)
                    out.println(restaurant+"</div>");            // Writing Restaurant details on the page
                }
                if(!staff.toString().equals("") && corpEmployeeAudName.equalsIgnoreCase(loggedUserAudType)) 
                {
                    // end of div staffdetails (opening in staff SB)
                    out.println(staff+"</div>");                 // Writing staff details on the page
                }
                
                if(franchiseeAudName.equalsIgnoreCase(loggedUserAudType))
                {
                    staffImagePath = restImagePath;
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
       
            </div>          <!--    end of  <weekday+count> -->
          </div>            <!--    end of <div calendarfg*> -->
       
          <b class='<%= classCurve %> calendarRoundCorners'> 
          <!--  Creating bottom rounded corners -->
          <%=  helper.bottomRoundCorner(rndCornerClass) %> 
       </div>               <!--  > end of calendar div -->
          <div class='blank_space'></div> 
    <%
    
              if(firstDayDate.equals(calActivityDate))
              {
    %>
                    </div> <!--  Closing firstdiv -->
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
    %>
               <script>
               // Calling method to open the non-blank division.
                   javascript:showOrHide('activity<%=count%>','calendarday<%=count%>', 'img<%=count%>', 'openclose<%=count%>', 'open_close_img_div<%=count%>');
               </script>
    <%
            } 
        } // End of for loop.
    %>
        
        </div> <!-- End of div calendarpart -->
    
        <!--  Creating Next and Previous Navigation Links ..  -->
        <table class="calNavLinks">
            <tr>  
                <td align="left">
                    <div id="link_prev">
                        <b class="calendarh calendarRoundCorners">
                        <!--  Creating top rounded corners -->
                        <%=  helper.topRoundCorner("calendar") %>
        
                        <div class="calendar_prevlink">
                            <span >
                                <div class="leftimageicon" id="leftimageicon" ></div>
                                <div class="prevlinkenabled" id="prevlinkenabled">
                                    <a href="#" onclick="JavaScript:getAjaxData('<%= currentPagePath %>', '<%=encryptedAudType %>', -1, '<%= cachePageCount %>')" > Show me the previous 7 days</a>
                                </div>
                                <div class="prevlinkdisabled" id="prevlinkdisabled" style="display:none;" >
                                    Show me the previous 7 days
                                </div>
                            </span>                 
                        </div>
        
                        <b class="calendarh calendarRoundCorners">
                        <!--  Creating bottom rounded corners -->
                        <%=  helper.bottomRoundCorner("calendar") %> 
                    </div>
                </td>
                <td align="right">          
                    <div id="link_prev">
                        <b class="calendarh calendarRoundCorners"> 
                        <!--  Creating top rounded corners -->
                        <%=  helper.topRoundCorner("calendar") %>
        
                        <div class="calendar_nextlink">  
                            <span >
                                <div class="rightimageicon" id="rightimageicon"></div>
                                <div class="nextlinkenabled" id="nextlinkenabled">
                                    <a href="#"  onclick="JavaScript:getAjaxData('<%= currentPagePath %>', '<%=encryptedAudType %>', 1, '<%= cachePageCount %>')" > Show me the next 7 days</a>
                                </div>
                                <div class="nextlinkdisabled" id="nextlinkdisabled" style="display:none;">
                                    Show me the next 7 days
                                </div>                            
                            </span>                 
                        </div>
        
                        <b class="calendarh calendarRoundCorners">
                        <!--  Creating bottom rounded corners -->
                        <%=  helper.bottomRoundCorner("calendar") %>
                    </div>
                </td>
            </tr>
        </table>
<%
    }catch(Exception ex)
    {
        log.error("Calendar Information can't be retrieved "+ex);
    }
%>      
            
        
