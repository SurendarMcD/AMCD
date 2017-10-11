<%--                                                                                                                                                                                                                                                                                                                                                                        
  ============================================================================= 
      
  Noice Board component                                   
  
  Gets the Notice Board Da ta (PCIResult object) from PCIInterface Layer  
  
  Wei 02/2011 - Add, edit, delete and display notice board entries  
  Judy 03/2011 - change this to be including the morenoticeboardinfo.jsp
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
                   
<%@ page import="com.day.text.Text,
                   com.day.cq.collab.blog.Blog,
                   com.day.cq.collab.blog.BlogEntry,
                   com.day.cq.widget.HtmlLibraryManager,
                   java.security.AccessControlException,
                   com.day.cq.security.Authorizable,
                   org.apache.sling.api.SlingHttpServletRequest,
                   com.day.cq.wcm.api.WCMMode"%>    
                                    
    
        
<div id="masterDiv" >   
       
<%  
    CalendarUtil cu = new CalendarUtil();
    Date startDate = cu.getStartDate();
    SimpleDateFormat df = new SimpleDateFormat("EEEE dd MMMM"); 
   // SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy"); 
%>  
                           
<div id="borderRight" class="borderRight"> 
  <h1 style="text-align:left;padding-left:14px">Posts from <%=df.format(startDate.getTime())%></h1>
  
   <%
       if(WCMMode.fromRequest(request) != WCMMode.DISABLED) {
   %>  
    <div id="jdatepicker" style="font-size:11px; font-weight:bold; color:#000; padding:5px 15px 0;">
          <script type="text/javascript" src="/scripts/jdatepicker.js"></script>
          <script type="text/javascript" src="/scripts/calendar.js"></script>
          <link rel="stylesheet" href="/css/datePicker.css" type="text/css" />
        
          <form>  
             <br>
             <% 
                 SimpleDateFormat mydf = new SimpleDateFormat("d/MM/yyyy"); 
                 Calendar myc = Calendar.getInstance();
                 Date myd = myc.getTime();
                 myd = com.mcd.accessmcd.calendar.util.DateUtil.getAusDate(myd);
                 
                 String myday = mydf.format(myd);

                 String myPagePath = currentPage.getPath(); // CQ path of the page
                 if(myPagePath != null && myPagePath.startsWith("/content"))
                       myPagePath = myPagePath.replace("/content/","/");
               
             %>
              <input name="APath" id="posting_path" type='hidden' value='<%=myPagePath%>'> 

              Pick A Date: <input name="ADate" id="posting_date" disabled="disabled"> 
              <a href="javascript:displayDatePicker('ADate');"> <img src="/images/cal.gif"> </a>
              <br>Please click on the calendar icon to select a date
          </form>
          <form>
          <button type="button" onClick="openCalendarDialog('add', 'noticeboard', '<%=resource.getPath() %>', '', '<%=startDate.getTime()%>');"><img src="/images/add.png" border="0" size="10" alt="Add a New Entry" /></button> Add a New Notice Board Entry
          </form>
    </div>      
    <%}%> 
           
    <div> 
      <cq:include script="/apps/mcd/components/page/global/morenoticeboardinfo.jsp" /> 
    </div>  
    
    <%
    if(WCMMode.fromRequest(request) != WCMMode.DISABLED) {
    %>  
    <div style="font-size:11px; font-weight:bold; color:#000; padding:5px 15px 0;">
        <form>
        <button type="button" onClick="openCalendarDialog('add', 'noticeboard', '<%=resource.getPath() %>', '', '<%=startDate.getTime()%>');"><img src="/images/add.png" border="0" size="10" alt="Add a New Entry" /></button> Add a New Notice Board Entry
        </form>  
    </div> 
    <%}%>
      
   <%
//judy add special date for compare,04/19
       Calendar cutDate= Calendar.getInstance();
       cutDate.set(2011,Calendar.APRIL,18);

        String nblink = "/accessmcd/apmea/au/noticeboard.html?loc=au";
        Page myPage = currentPage;
        if (myPage!=null&&myPage.getPath()!=null&&myPage.getPath().indexOf("/accessmcd/apmea/nz")>0){
            nblink = "/accessmcd/apmea/nz/noticeboard.html?loc=nz";
            cutDate.set(2011,Calendar.APRIL,25);
        }


       Calendar ckDate= Calendar.getInstance();
       
       if (ckDate.after(cutDate)){
       
   %>
     <p class="archive" align="right"><a href="<%=nblink%>">Archived Posts</a></p>
   <%}%>  

</div>

   
    
</div>
 <SCRIPT type=text/javascript>   
    // For Rounded corners of NoticeBoard 
    DD_roundies.addRule("#borderRight",'12px 12px 12px 12px',true);
</SCRIPT>               
          