<%
userID = (String)request.getParameter("userID");
view = (String)request.getParameter("view");
String allAdminUsers = "";
if (isSuperuser) 
{
    String adminSiteHandle = pageHandle + ".mysitesadmin.html?userID="+userID+"&view="+view;
    String addUserHandle = pageHandle + ".mysitesadmin.html?action=addUser&userID="+userID+"&view="+view;
    String editUserHandle = pageHandle + ".mysitesadmin.html?action=editUser&userID="+userID+"&view="+view;
    String editAllUsersHandle = pageHandle + ".mysitesadmin.html?action=confirmEditAllUser&userID="+userID+"&view="+view;
    String deleteUserHandle = pageHandle + ".mysitesadmin.html?action=confirmDeleteUser&userID="+userID+"&view="+view;
    
    List al = (List) request.getAttribute("adminUserList");
    if (al.size() == 0) 
    {
        out.println("<font color=\"red\">"+bundle.getString("MB_NO_USERS_FOUND")+"</font>");
    }
%>
<title><%= langText.get("Configure Users") %></title>
<fieldset><legend><b><%= langText.get("Configure Users") %></b></legend>
<hr/><br>
<table border="0" cellspacing="0" cellpadding="2" width="98%">
<tbody align="center">
<tr>
    <td>    
      <!-- Display Menu Buttons -->
      <table border="0" cellspacing="0" cellpadding="2" width="450">
      <tr>
         <td align="left">
                <a href="<%=addUserHandle%>" class="actionLink"><%= langText.get("Add a New User") %></a>
                &nbsp;&nbsp;&nbsp;<b style="font-size:13px">|</b>&nbsp;&nbsp;&nbsp; 
                <a href="<%=deleteUserHandle%>" class="actionLink" onclick='validateSiteAndSubmitUser("delete"); return false;'><%= langText.get("Delete Users") %></a>
                &nbsp;&nbsp;&nbsp;<b style="font-size:13px">|</b>&nbsp;&nbsp;&nbsp; 
                <a href="<%=editAllUsersHandle%>" class="actionLink" onclick='validateSiteAndSubmitUser("UpdateAll"); return false;'><%= langText.get("Submit") %></a>
        </td>
      </tr>
     </table>
   </td>
</tr>
<tr>
<td>
<table class="dataTable" border="1" cellpadding="2" cellspacing="0" width="450">
<tbody align="center">
    <form name="myForm" method="GET" action="<%=deleteUserHandle%>">
        
        <input type="hidden" name="userID" value="<%= userID %>"/>
        <input type="hidden" name="view" value="<%= view %>"/>
        <input type="hidden" name="action" value=""/>
            
        <tr  class="lableTxt" bgcolor="#f8f8ff" align="center">
            <td width="18%" colspan="3" nowrap><br>
                <input type="checkbox" name="checkAllUserId" value="yes" onClick="javascript:checkAllUsers();">&nbsp;<b><%= langText.get("Select All") %></b>&nbsp;<br>&nbsp;
            </td>
            <td width="30%"><b><%= langText.get("User Id") %></b><br></td>
            <td width="30%"><b><%= langText.get("View") %></b><br></td>
            <td width="15%"><b><%= langText.get("Manage User(s)") %></b><br></td>                                               
        </tr>        
<%  
        for (Iterator liter = al.iterator(); liter.hasNext();) 
        {
            AdminUser au = new AdminUser();
            au = (AdminUser) liter.next();
            allAdminUsers = allAdminUsers+au.getUserId()+"|"+au.getEntityType().toUpperCase()+"#";
%>
            <tr>
                <td colspan="2" nowrap><input type="checkbox" name="adminUserId" value="<%=au.getUserId()%>_<%=au.getEntityType()%>"></td>
                <td align="center" valign="top">
                    <a href="<%=editUserHandle%>&userId=<%=au.getUserId()%>">
                        <img src="/images/mysites/edit.gif" border="0" alt="<%= langText.get("Edit a User") %>"></a> 
                </td>
                <td width="30%"><%=au.getUserId()%></td>
                <td width="30%">-<%=au.getEntityType().toUpperCase()%></td>
                <td width="15%">
                    <input type = 'checkbox' <%=au.getManageUserFlag().equalsIgnoreCase("Y")? "checked" : ""%> name = '<%=au.getUserId()%>ManageFlag' id = '<%=au.getUserId()%>+ManageFlag' value = 'Y'/>
                </td>    
            </tr>
<%
        }
        allAdminUsers = allAdminUsers.substring(0, allAdminUsers.length()-1);
%>
    <input type='hidden' value = '<%=allAdminUsers%>' name = 'AdminUsers' id = 'AdminUsers'/>
</form>
</tbody>
</table>
</td>
</tr>
<tr>
    <td>    
      <!-- Display Menu Buttons -->
      <table border="0" cellspacing="0" cellpadding="2" width="450">
      <tr>
         <td align="left">
                <a href="<%=addUserHandle%>" class="actionLink"><%= langText.get("Add a New User") %></a>
                &nbsp;&nbsp;&nbsp;<b style="font-size:13px">|</b>&nbsp;&nbsp;&nbsp; 
                <a href="<%=deleteUserHandle%>" class="actionLink" onclick='validateSiteAndSubmitUser("delete"); return false;'><%= langText.get("Delete Users") %></a>
                &nbsp;&nbsp;&nbsp;<b style="font-size:13px">|</b>&nbsp;&nbsp;&nbsp; 
                <a href="<%=editAllUsersHandle%>" class="actionLink" onclick='validateSiteAndSubmitUser("UpdateAll"); return false;'><%= langText.get("Submit") %></a>
        </td>
      </tr>
     </table>
   </td>
</tr>
</tbody>
</table>
</fieldset>
<% 
}
else
{
    out.println("<font color=\"red\">"+bundle.getString("MB_NO_ACCESS")+"</font>");
}
%>