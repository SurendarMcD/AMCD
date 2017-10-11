<%--
  ==============================================================================
  ACE  Initial Scan 
  
  Judy Zhang 8/23/2010 
  ==============================================================================
--%>
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page session="false" %>
<%@ page import="java.util.*, 
                java.net.*,
                java.io.*,
                java.lang.*,
                java.util.Date,
                java.util.Calendar,
                java.text.SimpleDateFormat,
                javax.jcr.Session, 
                java.util.Enumeration,
                org.apache.sling.api.scripting.SlingScriptHelper,
                com.day.cq.security.*"%>

<%@ page import="com.mcd.accessmcd.aucalendar.dao.*"%>
<%@ page import="com.mcd.accessmcd.aucalendar.constants.*"%>
<%@ page import="com.mcd.accessmcd.aucalendar.manager.*"%>
<%@ page import="com.mcd.accessmcd.aucalendar.bean.*"%> 
<%@ page import="com.mcd.accessmcd.aucalendar.util.*"%> 
     
<%
        response.setHeader("Cache-Control","no-cache");
        response.setHeader("Cache-Control","no-store");
        response.setDateHeader("Expires", 0);
        response.setHeader("Pragma","no-cache");
  
%>  
                
<html>

<head> 

<title>Test Calendar / Notice Board Posts </title>

</head>
<body >

<table cellpadding="2" cellspacing="5" border=0 align="center" class="text">
    <tr>
        <td>

            <H1>Test Calender / Notice Board Post </H1><BR>
            <FORM id="testpostform" action="/content/utility/utility/_jcr_content.testpost.html" method="get">
            <B>Pick a Test:</B>
            <select name="testAction">
                   <option>View_Category</option>
                   <option>View_Calendar_Post</option>
                   <option>View_NoticeBoard_Post</option>
                   <option>View_Post_on_ID</option>
                   <option>Insert_Calendar_Post</option>
                   <option>Insert_NoticeBoard_Post</option>
                   <option>Delete_Calendar_Post</option>
                   <option>Delete_NoticeBoard_Post</option>
                   <option>Update_Post</option>
            </select>
            <BR><BR>
            <B>Enter test data:</B>
            <INPUT type='text' name='testData' size='150' value='' /> 
            <BR><BR>
            <BR><INPUT type='submit' value='submit' /><BR>
            </FORM>

<%!
      public void listCategory(SlingScriptHelper sling, Session jcrSession,JspWriter out){
            try {
                   System.out.println("........test list category............");
                   AUCalendarManager auCalendarManager = new AUCalendarManager(sling, jcrSession);
                   ArrayList categoryList = auCalendarManager.getCategoryList();
                   out.write("Total Categories:" + categoryList.size());

                   out.write("<table align=\"center\" border=1>");
                   out.write("<tr><td><b>CategoryID</b></td><td><b>CategoryName</b></td></tr>");     
                   Iterator categoryiter = categoryList.iterator();
        
                   while(categoryiter.hasNext()) {
                         Category category = (Category) categoryiter.next();
                         out.write("<tr><td>"+ category.getCategoryID() +"</td>");
                         out.write("<td>"+ category.getCategoryName() +"</td></tr>");
                   }
                   out.write("</table>");

             }catch(Exception e) {
                   System.out.println(e.getMessage());
                   e.printStackTrace();
             }   
      
      }


      public void listPost(String catid, SlingScriptHelper sling, Session jcrSession,JspWriter out){
            try {
                   System.out.println("........test list post " +catid+".............");
                   AUCalendarManager auCalendarManager = new AUCalendarManager(sling, jcrSession);
                   ArrayList postList = auCalendarManager.getPostList(catid);
                   out.write("Total posts:" + postList.size());

                   out.write("<table align=\"center\" border=1>");
                   out.write("<tr><td><b>Content Id</b></td><td><b>Title</b></td>");     
                   out.write("<td><b>UUID</b></td>");     
                   out.write("<td><b>Category</b></td><td><b>View</b></td>");     
                   out.write("<td><b>Actv flag</b></td><td><b>LaunchType</b></td>");     
                   out.write("<td><b>Publish Date</b></td><td><b>Description</b></td>");     
                   out.write("<td><b>Insert Date</b></td><td><b>Insert User</b></td>");     
                   out.write("<td><b>Modify Date</b></td><td><b>Modified by</b></td>");     
                   out.write("<td><b>Audience</b></td></tr>");     

                   Iterator poster = postList.iterator();
        
                   while(poster.hasNext()) {
                         PostEntry pe= (PostEntry ) poster.next();
                         out.write("<tr><td>"+ pe.getContentID() +"</td>");
                         out.write("<td>"+ pe.getTitle() +"</td>");
                         out.write("<td>"+ pe.getUUID() +"</td>");
                         out.write("<td>"+ pe.getCategoryID() +"</td>");
                         out.write("<td>"+ pe.getViewID() +"</td>");
                         out.write("<td>"+ pe.getActvFlag() +"</td>");
                         out.write("<td>"+ pe.getLaunchtype() +"</td>");
                         out.write("<td>"+ pe.getPubDate() +"</td>");
                         out.write("<td>"+ pe.getDesc() +"</td>");
                         out.write("<td>"+ pe.getInsDate() +"</td>");
                         out.write("<td>"+ pe.getInsUser() +"</td>");
                         out.write("<td>"+ pe.getModDate() +"</td>");
                         out.write("<td>"+ pe.getModUser() +"</td>");
                         out.write("<td>"+ pe.getAudienceType() +"</td></tr>");
                   }
                   out.write("</table>");

             }catch(Exception e) {
                   System.out.println(e.getMessage());
                   e.printStackTrace();
             }   
      
      }

      public void showPost(String id, SlingScriptHelper sling, Session jcrSession,JspWriter out){
            try {
                   System.out.println("........test show post on uuid:: " +id+".............");
                   AUCalendarManager auCalendarManager = new AUCalendarManager(sling, jcrSession);
//                   ArrayList postList = auCalendarManager.getPostOnCtntID(ctntid);
                   ArrayList postList = auCalendarManager.getPostOnUUID(id);
                   out.write("Total posts:" + postList.size());

                   out.write("<table align=\"center\" border=1>");
                   out.write("<tr><td><b>Content Id</b></td><td><b>Title</b></td>");     
                   out.write("<td><b>UUID</b></td>");     
                   out.write("<td><b>Category</b></td><td><b>View</b></td>");     
                   out.write("<td><b>Actv flag</b></td><td><b>LaunchType</b></td>");     
                   out.write("<td><b>Publish Date</b></td><td><b>Description</b></td>");     
                   out.write("<td><b>Insert Date</b></td><td><b>Insert User</b></td>");     
                   out.write("<td><b>Modify Date</b></td><td><b>Modified by</b></td>");     
                   out.write("<td><b>Audience</b></td></tr>");     

                   Iterator poster = postList.iterator();
        
                   while(poster.hasNext()) {
                         PostEntry pe= (PostEntry ) poster.next();
                         out.write("<tr><td>"+ pe.getContentID() +"</td>");
                         out.write("<td>"+ pe.getTitle() +"</td>");
                         out.write("<td>"+ pe.getUUID() +"</td>");
                         out.write("<td>"+ pe.getCategoryID() +"</td>");
                         out.write("<td>"+ pe.getViewID() +"</td>");
                         out.write("<td>"+ pe.getActvFlag() +"</td>");
                         out.write("<td>"+ pe.getLaunchtype() +"</td>");
                         out.write("<td>"+ pe.getPubDate() +"</td>");
                         out.write("<td>"+ pe.getDesc() +"</td>");
                         out.write("<td>"+ pe.getInsDate() +"</td>");
                         out.write("<td>"+ pe.getInsUser() +"</td>");
                         out.write("<td>"+ pe.getModDate() +"</td>");
                         out.write("<td>"+ pe.getModUser() +"</td>");
                         out.write("<td>"+ pe.getAudienceType() +"</td></tr>");
                   }
                   out.write("</table>");

             }catch(Exception e) {
                   System.out.println(e.getMessage());
                   e.printStackTrace();
             }   
      
      
      }

      public void listPost2(String catid, SlingScriptHelper sling, Session jcrSession,JspWriter out){
            try {
                   System.out.println("........test list post 2 " +catid+".............");
                   AUCalendarManager auCalendarManager = new AUCalendarManager(sling, jcrSession);
                   ArrayList postList = auCalendarManager.getPostList(catid);
                   out.write("Total posts:" + postList.size());

                   out.write("<table align=\"center\" border=1>");
                   out.write("<tr><td><b>Content Id</b></td><td><b>Title</b></td>");     
                   out.write("<td><b>UUID</b></td>");     

                   out.write("<td><b>Category</b></td><td><b>View</b></td>");     
                   out.write("<td><b>Actv flag</b></td><td><b>LaunchType</b></td>");     
                   out.write("<td><b>Publish Date</b></td><td><b>Description</b></td>");     
                   out.write("<td><b>Insert Date</b></td><td><b>Insert User</b></td>");     
                   out.write("<td><b>Modify Date</b></td><td><b>Modified by</b></td>");     
                   out.write("<td><b>Audience</b></td></tr>");     

                   Iterator poster = postList.iterator();
        
                   while(poster.hasNext()) {
                         PostEntry pe= (PostEntry ) poster.next();
                         out.write("<tr><td>"+ pe.getContentID() +"</td>");
                         out.write("<td>"+ pe.getTitle() +"</td>");
                         out.write("<td>"+ pe.getUUID() +"</td>");
                         out.write("<td>"+ pe.getCategoryID() +"</td>");
                         out.write("<td>"+ pe.getViewID() +"</td>");
                         out.write("<td>"+ pe.getActvFlag() +"</td>");
                         out.write("<td>"+ pe.getLaunchtype() +"</td>");
                         out.write("<td>"+ pe.getPubDate() +"</td>");
                         out.write("<td>"+ pe.getDesc() +"</td>");
                         out.write("<td>"+ pe.getInsDate() +"</td>");
                         out.write("<td>"+ pe.getInsUser() +"</td>");
                         out.write("<td>"+ pe.getModDate() +"</td>");
                         out.write("<td>"+ pe.getModUser() +"</td>");
                         out.write("<td>"+ pe.getAudienceType() +"</td></tr>");
                   }
                   out.write("</table>");

             }catch(Exception e) {
                   System.out.println(e.getMessage());
                   e.printStackTrace();
             }   
      
      }

      public void updatePost(String cntid, SlingScriptHelper sling, Session jcrSession,JspWriter out){
            try {
                   System.out.println("........test upate Post ............"+cntid);
                   AUCalendarManager auCalendarManager = new AUCalendarManager(sling, jcrSession);

                   PostEntry pe = new PostEntry();
                   pe.setContentID(cntid);
                   pe.setDocURL("http://www.test.html");
                   pe.setInsDate("18-MAR-11");
                   pe.setInsUser("em015416");
                   pe.setAudienceType("1");
                   pe.setCategoryID("4000");
                   pe.setViewID("4");
                   pe.setTitle("FOR ACTION: McCafe Manual Now updated. ");
                   pe.setDesc("Updated index section.");
                   pe.setLaunchtype("2");
                   pe.setActvFlag("1");
                   pe.setPubDate("2011-03-10 12:00:00");
                   
                   
                   boolean theResult = auCalendarManager.updatePost(pe);
                   if (theResult)
                        out.write("Results: Post has been updated.");



             }catch(Exception e) {
                   System.out.println(e.getMessage());
                   e.printStackTrace();
             }   
      
      }

      public void deletePost(String id, SlingScriptHelper sling, Session jcrSession,JspWriter out){
            try {
                   System.out.println("........test delete Post ............"+id);
                   AUCalendarManager auCalendarManager = new AUCalendarManager(sling, jcrSession);

                   
                   boolean theResult = auCalendarManager.deletePostByUUID(id);
                   if (theResult)
                        out.write("Results: Post has been deleted.");



             }catch(Exception e) {
                   System.out.println(e.getMessage());
                   e.printStackTrace();
             }   
      
      }

      public void insertPost(String catid, SlingScriptHelper sling, Session jcrSession,JspWriter out){
            try {
                   System.out.println("........test insert post............");
                   AUCalendarManager auCalendarManager = new AUCalendarManager(sling, jcrSession);

                   PostEntry pe = new PostEntry();
                   pe.setDocURL("http://www.test.html");
                   pe.setInsDate("19-MAR-11");
                   pe.setUUID("em015416_03090235");
                   pe.setInsUser("em015416");
                   pe.setAudienceType("1");
                   pe.setCategoryID(catid);
                   pe.setViewID("4,5");
                   pe.setTitle("FOR ACTION: New McCafe Manual Now updated. ");
                   pe.setDesc("Updated index section.");
                   pe.setLaunchtype("2");
                   pe.setActvFlag("1");
                   pe.setPubDate("2011-03-19 12:00:00");
                   
                   
                   boolean theResult = auCalendarManager.insertPost(pe);
                   if (theResult)
                        out.write("Results: Post has been inserted.");

             }catch(Exception e) {
                   System.out.println(e.getMessage());
                   e.printStackTrace();
             }   
      
      }



%>

    
<% 
        try {
            Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
            
            String pmScanType=request.getParameter("testAction");
            if (pmScanType!=null&& pmScanType.equals("View_Category")){
                listCategory(sling,jcrSession,out);
            }else if (pmScanType!=null && pmScanType.equals("View_Calendar_Post")){
                listPost("3000",sling,jcrSession,out);
            }else if (pmScanType!=null && pmScanType.equals("View_NoticeBoard_Post")){
                listPost("4000",sling,jcrSession,out);
            }else if (pmScanType!=null && pmScanType.equals("View_Post_on_ID")){
                showPost("em015416_03090235",sling,jcrSession,out);
            }else if (pmScanType!=null && pmScanType.equals("Insert_Calendar_Post")){
                insertPost("3000",sling,jcrSession,out);
            }else if (pmScanType!=null && pmScanType.equals("Insert_NoticeBoard_Post")){
                insertPost("4000",sling,jcrSession,out);
            }else if (pmScanType!=null && pmScanType.equals("Update_Post")){
                updatePost("246941",sling,jcrSession,out);
            }else if (pmScanType!=null && pmScanType.equals("Delete_NoticeBoard_Post")){
                deletePost("em015416_03090235",sling,jcrSession,out);
            }

             
             }catch (Exception e) {
                   out.write(e.getMessage());
                   e.printStackTrace();
             }
%>

        </td>
    </tr>
</table>



</body>

</html>

     
     