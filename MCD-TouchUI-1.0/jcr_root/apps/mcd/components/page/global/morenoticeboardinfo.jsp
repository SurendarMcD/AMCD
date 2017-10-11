<%--                   
  ==============================================================================

  Noice Board component

  Gets the Notice Board Data (PCIResult object) from PCIInterface Layer 
  
  Wei 02/2011 - Add, edit, delete and display notice board entries
 ==============================================================================
--%> 
<%@include file="/apps/mcd/global/global.jsp" %>

<%@page import="com.mcd.accessmcd.aucalendar.util.CalendarUtil"%>

<%@page import="java.util.*,
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
                   org.apache.sling.api.SlingHttpServletRequest,
                   com.day.cq.wcm.api.WCMMode"%>                   
                   
<%@ page import="com.day.cq.widget.HtmlLibraryManager" %><%
%>   
 
<div id="nbpost">

<%!
    //variable to check the for Australia Time Zone.
    private static final String AUS_TIME_ZONE = "aus"; 
    private static final String timeZone = "aus"; 
        
    /*
     * Method that gets the calendar-data(PCIResult object) from PCI Interface Layer.
     * @param HttpServletRequest, JcrPropertyMap
     * return an array of PCIResult object.
     */
    public Object[] getNoticeBoardInfo(HttpServletRequest cqReq, CalendarUtil util, 
            org.apache.sling.jcr.resource.JcrPropertyMap properties, SlingScriptHelper sling, JspWriter out, Date stDate, String loggedUserAudType, String loggedUserView)
        throws Exception {
        
        PCIQuery pciquery = new PCIQuery();
              
      //wei get entries for all entries  
        String resultCount = "1000";  
        String actionType = "read";
        String categoryID = "4000";
        String audience = loggedUserAudType;
        String entityType = loggedUserView;      
        String viewType = "content";
        String sortType = "rchronouuid";
              
        //System.out.println("categoryID=" + categoryID);
        
        pciquery.setAudience(audience);
        pciquery.setCategoryID(categoryID);
        pciquery.setResultCount(resultCount);
        pciquery.setSortType(sortType);
        pciquery.setEntityType(entityType);
        pciquery.setActionType(actionType);
        pciquery.setViewType(viewType);
        
        Date fromDate = stDate;
        //fromDate.setDate(fromDate.getDate() + 1);        
       
        /*Calendar tDate= Calendar.getInstance(); 
    
        tDate.setTime(fromDate);
        tDate.add(Calendar.DATE,7);                // Generating the end date of calendar..
        Date toDate = tDate.getTime(); // Getting the IST date.*/
          
        Calendar tDate= Calendar.getInstance(); 
        Calendar weekbeforeDate= Calendar.getInstance(); 
        weekbeforeDate.add(Calendar.DATE,-7);
        Date compDate=weekbeforeDate.getTime();
        if(fromDate.before(compDate)) {
            tDate.setTime(fromDate);
            tDate.add(Calendar.DATE,7); // Generating the end date of calendar..
        }
        Date toDate = tDate.getTime(); // Getting the IST date.
        toDate = DateUtil.getAusDate(toDate);
        
        //System.out.println("fromDate=" + fromDate);       
        pciquery.setFromDate(fromDate); // Calendar Start Date...
             
        // setting the time as 0:0:1 am
        toDate.setHours(23);
        toDate.setMinutes(59);
        toDate.setSeconds(59);
        //System.out.println("toDate=" + toDate);
        pciquery.setToDate(toDate);   // Calendar End Date...
        
        pciquery.setCacheRefresh(0); // OSCache refresh time is 15 minutes.
    
        Object[] results = util.getPCIContent(pciquery, sling);
         
        return results;
        
    } 

%>

<%
   String loggedUserAudType="CorpEmployees";
   String loggedUserView=""; 
   
   String publishDate = "";
   String categoryTitle = "";
   String activityName = "";
   String description = "";
   String audType = "";
   String entityType = "";
   String launchType = "";
   String activityPageURI = "";
   String calActivityDate = "";
   String serverHostDomain = "";
   String activityTitle = "";
   String uuid = "";
   String prefix = "";
   String title = "";
   String tempuuid = "";
   String tempActivityName = "";
   
   ArrayList al = new ArrayList();
   String record = "";
   String lastRecord = "";
   
   String[] fields = null;
   String[] fieldNameValue= null;
   int alSize = 0;
   String tempAudType = "";
   String tempEntityType = "";
   
   String aud1 = "";
   String link1 = "";
   String aud2 = "";
   String link2 = "";
   String display1 = "";
   String display2 = "";
   String openWin1 = "";
   String openWin2 = ""; 
     
   int displayCount = 0;  
   int tempDisplayCount = 0;
   
   int numberToDisplay = 10;
   int start = 0;
   int end = 0;
   int setDiv = 0;
   int divCount = 0;
   String moreCloseText = "";      
      
   //wei - get page handle for displaying entries just for that handle  
   String defaultView = "";
   String currentPagePath = currentPage.getPath(); 
   
   //System.out.println("currentPagePath=" + currentPagePath);
   if (currentPagePath.indexOf("/accessmcd/apmea/au") != -1) 
       defaultView = "AU"; 
   if (currentPagePath.indexOf("/accessmcd/apmea/nz") != -1) 
       defaultView = "NZ";  
       
   //out.println("defaultView=" + defaultView);      
        
   try      
    {    
        HttpServletRequest cqReq = (HttpServletRequest) request;
        CalendarUtil util = new CalendarUtil();
        final User user = slingRequest.getResourceResolver().adaptTo(User.class);
        
        if(WCMMode.fromRequest(request) == WCMMode.DISABLED) {
            loggedUserAudType = util.getLoggedUserAudType(sling, user);  
            loggedUserView = defaultView;      
        } else {
            loggedUserAudType="ALL";
            loggedUserView = "ALL";
        }
       
        //out.println("logged user audtype=" + loggedUserAudType);
        // audience type Block ends here // 
           
//judy add for date picker
          //judy add select date
        String fromDate="now";       
/*
        if (cqReq.getParameter("fromDate")!=null)
            fromDate = cqReq.getParameter("fromDate");
        SimpleDateFormat mydf = new SimpleDateFormat("MM/dd/yyyy"); 
*/

        String requestURI = cqReq.getRequestURI();
        SimpleDateFormat mydf =new SimpleDateFormat("MM_dd_yyyy");
//System.out.println("not......requestURI:: "+requestURI );   
        
        String caledarGlobPart = requestURI.substring(requestURI.lastIndexOf("/")+1);
        String urlParam[] = caledarGlobPart.split("\\.");
//System.out.println("not......urlParam:: "+urlParam.length);   
        if (urlParam.length>3 && urlParam[2]!=null&& urlParam[2].indexOf("_")>0)
           fromDate = urlParam[2];
//System.out.println("not......fromDate :: "+ fromDate );  
        
        Calendar nDate= Calendar.getInstance();
        // Date startDt = nDate.getTime();   
        Date startDt;
        
        if (!fromDate.equals("now")){
                startDt = nDate.getTime();                
              
              try{  
                Date tempDt= mydf.parse(fromDate);
                if (tempDt!=null)
                   startDt=tempDt;
              }catch(java.text.ParseException ep) {}
              
        } else {
            CalendarUtil cu = new CalendarUtil();
            startDt = cu.getStartDate();
        }
//end add
                         
        Object[] noticeBoardContent = getNoticeBoardInfo(cqReq, util, (org.apache.sling.jcr.resource.JcrPropertyMap)properties, sling, out, startDt, loggedUserAudType, loggedUserView);
         
        PCIResult pciresult = (PCIResult)noticeBoardContent[0];
        String firstDayDate = pciresult.getPublishDate();
        
        // Rendering the calendar data.
        //System.out.println("noticeBoard content length=" + noticeBoardContent.length);
        for(int i=0;i<noticeBoardContent.length;i++)
        {
            PCIResult activity = (PCIResult)noticeBoardContent[i];            
                               
            publishDate = activity.getPublishDate();
            
            
            serverHostDomain = activity.getServerHostDomain();
            calActivityDate = activity.getPublishDate();
            
            //format publishDate
            CalendarUtil cu = new CalendarUtil();
            calActivityDate = cu.formatNoticeBoardDate(calActivityDate);            
                  
            audType = activity.getAudienceType();
            entityType = activity.getEntityType();
            activityName = activity.getDocumentTitle();
            categoryTitle = activity.getCategoryTitle();
            activityPageURI = activity.getPageURI();
            launchType = activity.getLaunchType();
            description = activity.getDescription();  
            uuid = activity.getUUID();
                 
            serverHostDomain = (serverHostDomain == null) ? "" : serverHostDomain.trim();
            activityName = (activityName == null) ? "" : activityName.trim();    
            audType = (audType == null) ?  "0" : audType.trim();
            
            //wei - for display Staff instead of CorpEmployees
            if (audType.equals("CorpEmployees"))
               audType = "Staff";
                
            entityType = (entityType == null) ?  "0" : entityType.trim();
            categoryTitle = (categoryTitle == null) ? "" : categoryTitle.trim();
            activityPageURI = (activityPageURI == null) ? "" : activityPageURI.trim();
            if ("".equals(description) || (description == null)) 
                description = " ";                                    
           
            //description = (description == null) ? " " : description.trim();
            launchType = (launchType == null) ? "0" : launchType.trim();
            uuid = (uuid == null) ? "" : uuid.trim();
            
            if (activityPageURI.startsWith("/"))
                activityPageURI = (activityPageURI.equals("") ? "#" :  serverHostDomain+activityPageURI+ ".html");  
            else if ("".equals(activityPageURI))
                activityPageURI = "#";
                           
                              
    /*
            System.out.println("uuid=" + uuid);
            System.out.println("publishDate=" + publishDate);
            System.out.println("serverHostDomain=" + serverHostDomain);
            System.out.println("calActivityDate=" + calActivityDate);
            System.out.println("categoryTitle=" + categoryTitle);
            System.out.println("activityPageURI=" + activityPageURI);
            System.out.println("calActivityDate=" + calActivityDate);
            System.out.println("activityName=" + activityName);
            System.out.println("description=" + description);
            System.out.println("audType=" + audType);
            System.out.println("entityType=" + entityType);
            System.out.println("pageURI=" + activityPageURI);
            System.out.println("launchType=" + launchType);
      */
           
            //wei - for displaying audiences/links/views
            if (!uuid.equals("")) {
                            
                if (!uuid.equals(tempuuid)) {    
                    
                    record = "uuid==" + uuid + ";;" + "postingDate==" + calActivityDate + ";;" + "title==" + activityName + ";;" +
                        "description==" + description + ";;" + "audience==" + audType + "|" + activityPageURI + "|" + launchType + ";;" + 
                        "entityType==" + entityType;                   
                                                                    
                        //System.out.println("record=" + record);
                    al.add(record);
                  
               } else {
                    // update record                    
                    alSize = al.size();
                  
                    lastRecord = (String) (al.get(alSize - 1));
                    //System.out.println("lastrecord = " + lastRecord);
                              
                    fields = lastRecord.split("\\;;");
                                   
                    for (int k=0; k<fields.length; k++) {
                      fieldNameValue = fields[k].split("==");   
                      
                      if (fields[k].indexOf("uuid") != -1) uuid= fieldNameValue[1];
                      if (fields[k].indexOf("postingDate") != -1) calActivityDate = fieldNameValue[1];
                      if (fields[k].indexOf("title") != -1) activityName = fieldNameValue[1];
                      if (fields[k].indexOf("description") != -1) description = fieldNameValue[1];                                           
                      if (fields[k].indexOf("audience") != -1)  tempAudType = fieldNameValue[1];                                                           
                      if (fields[k].indexOf("entityType") != -1) tempEntityType = fieldNameValue[1];
                               
                    }//end of for loop
              
                     // System.out.println("tempAudType = " + tempAudType);       
                     // System.out.println("tempEntityType = " + tempEntityType);    
                    
                      //update audType and entity type
                   if (tempAudType.indexOf(audType) == -1 && !"".equals(audType) && !audType.equals("0")) 
                      tempAudType = tempAudType + ",," + audType + "|" + activityPageURI + "|" + launchType;
                                                     
                   if (tempEntityType.indexOf(entityType) == -1) 
                      tempEntityType = tempEntityType + "/" + entityType;  
                                  
                      //System.out.println("AudType = " + audType);       
                      //System.out.println("EntityType = " + entityType);  
                      
                                       
                   lastRecord = "uuid==" + uuid + ";;" + "postingDate==" + calActivityDate + ";;" + "title==" + activityName + ";;" +
                              "description==" + description + ";;" + "audience==" + tempAudType + ";;" + 
                              "entityType==" + tempEntityType;
                          //System.out.println("lastRecord=" + lastRecord);
                                     
                   al.remove(alSize - 1);
                   al.add(lastRecord); 
                  
                   tempAudType = "";
                   tempEntityType = "";
                   description = "";                   
               
                 }//end of else
                
                 tempuuid = uuid; 
                 prefix = "";
             }//end of if
          }
          
          
          //filtering
          alSize = al.size();
          ArrayList al1 = new ArrayList();
                  
          Iterator it = al.iterator();
          while (it.hasNext()) {
              record = (String) (it.next());
              
              String entityTypeStr = record.substring(record.indexOf("entityType="), record.length());
              String[] entityTypeFields = entityTypeStr.split("=="); 
            
              if (entityTypeFields[1].indexOf(defaultView) != -1) 
                  al1.add(record);
          }
          
          //displaying 
          alSize = al1.size();
                  
          Iterator it1 = al1.iterator();
          while (it1.hasNext()) {
          
              record = (String) (it1.next());
              //System.out.println(record);
              fields = record.split("\\;;");
                           
              for (int p=0; p<fields.length; p++) {                 
                  fieldNameValue = fields[p].split("==");  
                  
                  if (fields[p].indexOf("uuid") != -1) uuid= fieldNameValue[1];                                 
                  if (fields[p].indexOf("postingDate") != -1) calActivityDate = fieldNameValue[1];                                                
                  if (fields[p].indexOf("title") != -1) activityName = fieldNameValue[1];                                 
                  if (fields[p].indexOf("description") != -1) description = fieldNameValue[1];                                   
                  if (fields[p].indexOf("audience") != -1) audType = fieldNameValue[1];                                       
                  if (fields[p].indexOf("entityType") != -1) entityType = fieldNameValue[1];
                 
              }  
                
              if (activityName.indexOf("|") != -1) {
                  String[] prefixTitle = activityName.split("\\|");
                  prefix = prefixTitle[0].toUpperCase();
                  title = prefixTitle[1];
              } else {
                  title = activityName;
              }
                  
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
              //   System.out.println("title =" + title + " audTypeLink1=" +audTypeLink1 + " audTypeLink2=" + audTypeLink2);                  
          
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
        
              //out.println("entityType=" + entityType + "defaultView=" + defaultView);
                      
              %>
               <dl class="postListBox">
                 
                  <dt>
                  <%
                   if(WCMMode.fromRequest(request) != WCMMode.DISABLED) {
                       
                       SimpleDateFormat adtf = new SimpleDateFormat("dd MMMM yyyy"); 
                       Date adt = adtf.parse(calActivityDate);                       
                       //System.out.println("adt=" + adt); 
                       
                       CalendarUtil cu1 = new CalendarUtil();
                       Date sdt = cu1.getStartDate();                                                   
                       //System.out.println("sdt=" + sdt);
                       
                       int diff = adt.compareTo(sdt);                         
                       //System.out.println("time diff=" + diff);
                       
                       //if adt is after sdt
                       if (diff >= 0) { 
                  %>
                  <button type="button" onclick="javascript:openCalendarDialog('edit', 'noticeboard', '<%=resource.getPath()%>', '<%=uuid%>', '<%=sdt.getTime()%>');">  
                  <img src="/images/edit.png" border="0" size="10" alt="Edit" />
                  </button>
                  <button type="button" onClick="confirmDelete('<%=uuid%>', '<%=resource.getPath() %>');">
                  <img src="/images/delete.png" border="0" size="10" alt="Delete" />
                  </button>  
                  <%   }
                  }%>
                  <%=calActivityDate%>
                  </dt>
                
                  <dd>    
                    
                  <%
                   if(WCMMode.fromRequest(request) != WCMMode.DISABLED) {  
                   %>
                      <%=prefix%>:&nbsp;<%=title%>&nbsp;<%=description%>
                   <%
                     if (!aud1.equals("")) {
                       
                        if (!link1.equals("#")) { 
                                                                  
                          if(!link1.startsWith("/") && !link1.startsWith("http")) 
                        //  out.println(link1.substring(0,link1.lastIndexOf(".html")));
                            link1 = "http://"+link1;
                                               
                        %>
                          <br><font size=1><a target='<%=openWin1%>' href='<%=link1%>'><%=aud1%></a></font>
                        <%} else  {%>
                          <br><font size=1><%=aud1%></font>
                  <%    }
                  }                 
                  if (!aud2.equals("")) {
                        if (!link2.equals("#")) { 
                      
                        if(!link2.startsWith("/") && !link2.startsWith("http")) 
                             link2 = "http://"+link2;
                         
                        %>
                          <br><font size=1><a target='<%=openWin2%>' href='<%=link2%>'><%=aud2%></a></font>
                        <%} else  {%>
                          <br><font size=1><%=aud2%></font>
                  <%    }
                  } %>
                    <br><font size=1><%=entityType%></font>
                 <% }//end of WCMMode check
                  
                  else{   
                     if (!link1.equals("#")) { 
                     
                         if(!link1.startsWith("/") && !link1.startsWith("http")) 
                        //  out.println(link1.substring(0,link1.lastIndexOf(".html")));
                            link1 = "http://"+link1;
                 %>
                        <a target='<%=openWin1%>' href='<%=link1%>'><%=prefix%>:&nbsp;<%=title%></a>&nbsp;<%=description%>
                 <% } else {
                 %>
                        <%=prefix%>:&nbsp;<%=title%>&nbsp;<%=description%> 
                 <%   }
                 
                 }%> 
                               
                 
                  </dd>  
               
              </dl>
              <br>
             
              <% 
              //out.println("displayCount =" + displayCount + " num=" + tempDisplayCount + numberToDisplay);
              if (((displayCount + 1) == (numberToDisplay + tempDisplayCount)) && setDiv == 1)  { 
                  divCount++;
              %>
                 
                 </div>
                 </div>
                 <%setDiv = 0;
              }   
            
              displayCount++;
                 
               //reset values
              aud1 = "";
              link1 = "";
              aud2 = "";
              link2 = "";   
              openWin1 = "";
              openWin2 = ""; 
              
              //wei - add more link
               // out.println("displayCount=" + displayCount + " mod="  + displayCount % numberToDisplay);
               if (displayCount != 0 && (displayCount % numberToDisplay == 0) && displayCount < alSize) { 
                     
                     tempDisplayCount = displayCount;
                     start = displayCount + 1;
                     //end = displayCount + numberToDisplay;
                     
                     setDiv = 1; 
                     
                     if ((double)alSize/(double)numberToDisplay <= 2.0)
                         moreCloseText = "More";
                     else {
                         if ((alSize - displayCount) < numberToDisplay)
                              end = alSize;                                           
                         else 
                             end = displayCount + numberToDisplay;
                                                 
                         moreCloseText = "More " + start + "-" + end;
                     }
                     
                     String showHide = "display:none";
                     
                                                       
                %>
                 <div id='entries<%=displayCount%>'>
                 <p class="more"><a href='javascript:;' onclick="showHideEntry('<%=displayCount%>', '<%=moreCloseText%>')">
                 <span class='moreopen' id='moreopen<%=displayCount%>'><%=moreCloseText%></span>                                    
                 </a>
                 <div id='entry<%=displayCount%>' style='<%=showHide%>'>
                <% 
                                              
               } 
          }           
          
         // out.println("displayCount = " + displayCount + " divCount = " + divCount + " alSize=" + alSize);
         //add extra </div>
          if (displayCount > numberToDisplay) {
              // if ((displayCount - divCount * numberToDisplay) % numberToDisplay != 0)  
              if ((alSize % numberToDisplay) != 0)  {
              %>
              </div>
              </div>
          <%  }
          }          
       
 
   } catch( Exception e) {
   }
   
%>
</div>
 