<%--                                                           
  ==============================================================================
  
  Calendar component                                       

  Gets the Calendar-Data (PCIResult object) from PCIInterface Layer and make an
  AJAX call using globing pattern to load the calendar-data of next/previous weeks.
  
  Wei 01/2011 - Add, edit, delete and display calendar entries        
  Judy 03/2011 - add pick date,ajax , change to including morecalendarinfo.jsp
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
                   org.apache.sling.api.SlingHttpServletRequest,
                   com.day.cq.wcm.api.WCMMode"%>
                   
<%@ page import="com.day.cq.widget.HtmlLibraryManager" %><% 
%>
<%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects/> 
 
<%   
   /*response.setHeader("Cache-Control","no-cache");
   response.setHeader("Cache-Control","no-store");
   response.setDateHeader("Expires", 0);
   response.setHeader("Pragma","no-cache");   */
    
%>
         
   <%
       if(WCMMode.fromRequest(request) != WCMMode.DISABLED)
       {
   %>
                 <div id="jdatepicker" style="font-size:11px; font-weight:bold; color:#000; padding:5px 0 0;" >
                 
                 

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
              <input name="BPath" id="posting_path" type='hidden' value='<%=myPagePath%>'> 
              
              Pick A Date: <input name="BDate" id="posting_date" disabled="disabled" > 
                      <a href="javascript:displayDatePicker('BDate');"> <img src="/images/cal.gif"> </a>
                      <br>Please click on the calendar icon to select a date
                  </form> 
<!-- wei add the add button at the top--> 
                  <form>
                  <button type="button" onClick="openCalendarDialog('add', 'calendar', '<%=resource.getPath() %>', '', '');"><img src="/images/add.png" border="0" size="10" alt="Add a New Entry" /></button> Add a New Calendar Entry
                  </form>  
                   
                 </div> 
 <%
         }
 %>
<div>     
  <cq:include script="/apps/mcd/components/page/global/morecalendarinfonew.jsp" />
</div> 

<%
    if(WCMMode.fromRequest(request) != WCMMode.DISABLED){
%>  
<div style="font-size:11px; font-weight:bold; color:#000; padding:5px 0 0;">
     <form>
     <button type="button" onClick="openCalendarDialog('add', 'calendar', '<%=resource.getPath() %>', '', '');"><img src="/images/add.png" border="0" size="10" alt="Add a New Entry" /></button> Add a New Calendar Entry
     </form> 
</div>
<%
    }
%>

    
        
  
