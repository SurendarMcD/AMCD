<%--   
  ==============================================================================
  Retrieve data from database and fill in the entry while doing Edit
  
  Wei Wu 02/28/2011
  ==============================================================================
--%> 
<%@include file="/apps/mcd/global/global.jsp" %>

<%@page import="com.mcd.accessmcd.aucalendar.util.CalendarUtil"
%>

<%@page import="java.util.Date,
                   java.util.Iterator,
                   java.util.ArrayList"
%>
<%@page import="com.mcd.accessmcd.aucalendar.bean.PostEntry,
                    com.mcd.accessmcd.aucalendar.manager.AUCalendarManager"
%>

<%
//System.out.println("in getvalues");
//constants
String AUDIENCE_STAFF = "1";
String AUDIENCE_FRANCHIEES = "4";
String VIEW_AU = "4";
String VIEW_NZ = "5";
String CALENDAR = "calendar";
String NOTICE_BOARD = "noticeboard";

String postingDate = "";
String[] prefixTitleArr = null;
String title = "";
String description = " ";
String prefix = "";
//String prefixText = "";
String audienceStaff = "0";
String linkStaff = "";
String displayStaff = "0";
String audienceFranchiees = "0";
String linkFranchiees = "";
String displayFranchiees = "0";
String viewAU = "0";
String viewNZ = "0";
String audience = "";
String view = "";

//date variables
String[] dateTime = null;
String dateStr = "";
String[] dates = null;
String year = "";
String month = "";
String day = "";

String componentName = request.getParameter("component");
String uuid = request.getParameter("uuid");

//System.out.println(" uuid=" + uuid);

//insert calendar post 
Session jcrSession = null;

try {
    jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
    AUCalendarManager auCalendarManager = new AUCalendarManager(sling, jcrSession);

    ArrayList al = new ArrayList();
    al = auCalendarManager.getPostOnUUID(uuid);

    PostEntry pe = new PostEntry(); 
    Iterator itr = al.iterator();    
 
    while(itr.hasNext())  {
     pe = (PostEntry) itr.next();
     
     //posting date
     postingDate = pe.getPubDate();
     
     //2011-03-03 00:00:00.0
     //formating
     dateTime = postingDate.split(" ");
     dateStr = dateTime[0];
     //System.out.println("dateStr=" + dateStr);
       
     dates = dateStr.split("-");
     
     year = dates[0];
     month = dates[1];
     day = dates[2];
    
     dateStr = day + "/" + month + "/" + year;
     
     //title
     title = pe.getTitle();
    
     if (componentName.equals(NOTICE_BOARD) && title.indexOf("|") != -1) {
         prefixTitleArr = title.split("\\|");
         
         prefix = prefixTitleArr[0];
         /*
         if (prefix.equals("FOR ACTION") || prefix.equals("FOR INFORMATION")) {
             prefixText = "";
         } else {
             prefix = "OTHER";
             prefixText = prefixTitleArr[0];
         }*/
         title = prefixTitleArr[1];
     }
     
     CalendarUtil cu = new CalendarUtil();
     
     if (title.indexOf("\"") != -1) {
         title = cu.replaceString(title, "\"", "\\\"");
        //System.out.println(title);
     }          
     //description  
     if (componentName.equals(NOTICE_BOARD))
         description = pe.getDesc();
     
     if (description == null)
          description = "";   
           
     if (description.indexOf("\"") != -1) {
         description = cu.replaceString(description, "\"", "\\\"");
        //System.out.println(description);
     }   
     
     //audiences
     audience = pe.getAudienceType();
     
     if (audience.equals("1")) {
         audienceStaff = AUDIENCE_STAFF;
         linkStaff = pe.getDocURL();
         displayStaff = pe.getLaunchtype();
     }
     
     if (audience.equals("4")) {
         audienceFranchiees = AUDIENCE_FRANCHIEES;
         linkFranchiees = pe.getDocURL();
         displayFranchiees = pe.getLaunchtype();
     }
     
     //view   
     view = pe.getViewID();
     if (view.equals("4"))
         viewAU = VIEW_AU;
     if (view.equals("5"))
         viewNZ = VIEW_NZ;
         
             
   /*
     System.out.println("dateStr=" + dateStr);
     System.out.println("title=" + title);
     System.out.println("prefix=" + prefix);
     System.out.println("desctiption=" + description);
     System.out.println("audiencesStaff=" + audienceStaff);
     System.out.println("linkStaff=" + linkStaff);
     System.out.println("displayStaff=" + displayStaff);
     System.out.println("audiencesFranchiees=" + audienceFranchiees);
     System.out.println("linkFranchiees=" + linkFranchiees);
     System.out.println("displayFranchiees=" + displayFranchiees);
     System.out.println("viewAU=" + viewAU);
     System.out.println("viewNZ=" + viewNZ);
   */
        
  } 
  
  if (linkStaff == null)
      linkStaff = "";
  if (linkFranchiees == null)
      linkFranchiees = "";    

} 
catch(Exception ex){}
finally{
  if(jcrSession!=null)jcrSession.logout();
}

%>

<% if (componentName.equals(CALENDAR)) {%>
[{"postingDate": "<%=dateStr%>", "title":"<%=title%>",  
"audienceStaff": "<%=audienceStaff%>", "linkStaff": "<%=linkStaff%>", 
"displayStaff": "<%=displayStaff%>", "audienceFranchiees": "<%=audienceFranchiees%>", "linkFranchiees": "<%=linkFranchiees%>", 
"displayFranchiees": "<%=displayFranchiees%>", "viewAU": "<%=viewAU%>", "viewNZ": "<%=viewNZ%>", 
"postingType": "1", "categoryId": "3000", "action": "edit", "uuid": "<%=uuid%>"}]

<% } else {%>
[{"postingDate": "<%=dateStr%>", "title":"<%=title%>",  "description":"<%=description%>",  "prefix": "<%=prefix%>", 
"audienceStaff": "<%=audienceStaff%>", "linkStaff": "<%=linkStaff%>", 
"displayStaff": "<%=displayStaff%>", "audienceFranchiees": "<%=audienceFranchiees%>", "linkFranchiees": "<%=linkFranchiees%>", 
"displayFranchiees": "<%=displayFranchiees%>", "viewAU": "<%=viewAU%>", "viewNZ": "<%=viewNZ%>", 
"postingType": "2", "categoryId": "4000", "action": "edit", "uuid": "<%=uuid%>"}]
<%}%>

