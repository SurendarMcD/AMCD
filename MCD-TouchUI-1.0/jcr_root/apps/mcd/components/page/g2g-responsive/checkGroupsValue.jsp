<%@include file="/apps/mcd/global/global.jsp"%>

<%
    response.setHeader("Cache-Control","no-cache");
    response.setHeader("Cache-Control","no-store");
    response.setDateHeader("Expires", 0);
    response.setHeader("Pragma","no-cache"); 

    String groups = "";
    boolean flag = false;
    String check = "false";

    if(request.getParameter("groups")!=null)
    {
         groups  = request.getParameter("groups");  
         if(groups.startsWith(",")||groups.endsWith(",")||groups.contains(",,"))
         {
            flag = true;               
         }
    }
    
    if(flag == true)
    {
        check = "true";
    }
    
%>

[{"check":"<%=check%>"}] 