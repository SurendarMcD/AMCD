<%
if(isSuperuser) 
{
    userID = (String)request.getParameter("userID");
    view = (String)request.getParameter("view");
    
    String title="";
    String entityType = "";
    String manageUserFlag = "";
    AdminUser au = new AdminUser();
    String userId = "";

    String handle = "";

    if (action.equals("addUser")) 
    {
        handle = pageHandle + ".mysitesadmin.html?action=confirmAddUser";
        title = langText.get("Add User");
    } 
    else if (action.equals("editUser")) 
    {
        handle = pageHandle + ".mysitesadmin.html?action=confirmEditUser";
        title = langText.get("Edit User");
        
        userId = request.getParameter("userId");
        if (userId != null) 
        {
            au = mySitesManager.getAdminUser(userId, view);
            userId = au.getUserId();
            entityType = au.getEntityType();
            manageUserFlag = au.getManageUserFlag();
              //out.println(au.getUserId() + " " + au.getEntityType() + " " + au.getManageUserFlag());
        }
    }
    String cancelHandle = pageHandle + ".mysitesadmin.html?action=viewAdminUsers&userID="+userID+"&view="+view;
   
%>
  <title><%=title%></title>
    <fieldset><legend><b><%=title%></b></legend>
    <hr/>
<FORM METHOD="GET" name="mySiteEditForm" ACTION="<%=handle%>"> 

<table width="100%" border="0" cellspacing="0" cellpadding="2" class="text">
<% 
    if (action.equals("addUser")) 
    {%>
        <input type="hidden" name="action" value="confirmAddUser"/>
    <% } 
    else 
    {%>
                <input type="hidden" name="action" value="confirmEditUser"/>
        
    <%} %>
            
    <input type="hidden" name="userID" value="<%= userID %>"/>
    <input type="hidden" name="view" value="<%= view %>"/>
    <tr>
        <td bgcolor="" valign="top">
            <img src="/images/mysites/spacer.gif" width="30" height="1" border="0" alt="">
        </td>
        <td bgcolor="">
            <img src="/images/mysites/spacer.gif" width="30" height="1" border="0" alt="">
        </td>
        <td width="90%" bgcolor="" align="">
        <!-- content -->
        
        <table width="380" border="0" cellspacing="0" cellpadding="2" align="" class="text">
            <tr>
                <td colspan="3" align="right">
                    <img src="/images/mysites/spacer.gif" width="1" height="5" alt="" border="0">
                    <span class="txtMandatory">* <%= langText.get("indicates mandatory") %></span>
                 </td>
            </tr>
            <tr>
                <td colspan="3"><img src="/images/mysites/spacer.gif" width="1" height="5" alt="" border="0"></td>
            </tr>
            <tr>
                <td width="25%" class="lableTxt" align="left" valign="top"><b><%= langText.get("Status") %></b></td>
                <td width="8%" >&nbsp;</td>
                <td width="55%" ><b><%=title%></b></td>
                <td width="12%" >&nbsp;</td>
            </tr>
            <tr>
                <td colspan="3"><img src="/images/mysites/spacer.gif" width="1" height="5" alt="" border="0"></td>
            </tr>
            <tr>
                <td colspan="3"><img src="/images/mysites/spacer.gif" width="1" height="5" alt="" border="0"></td>
            </tr>
<%
            if (action.equals("addUser")) {
%>
                <tr>
                    <td class="lableTxt" align="left" valign="top"><b><%= langText.get("UserId") %>&nbsp;<span class="txtMandatory">*</span></b></td>
                    <td>&nbsp;</td>
                    <td><INPUT TYPE="text" NAME="userId" size="8" maxlength="10"></td>
                    <td>&nbsp;</td>
                </tr>
<%          } else {
%>
           
            <tr>
                <td class="lableTxt" align="left" valign="top"><b><%= langText.get("UserId") %>&nbsp;<span class="txtMandatory">*</span></b></td>
                <td>&nbsp;</td>
                <td><input type="hidden" name="userId" value="<%=userId%>"><%=userId%></td>
                <td>&nbsp;</td>
            </tr>
<%}%>
    
            <%--tr>
                <td colspan="3"><input type="hidden" name="entityType" value="<%=entityType%>">
            </tr--%>
            
            <tr>
                <td colspan="3"><img src="/images/mysites/spacer.gif" width="1" height="5" alt="" border="0"></td>
            </tr>
            <tr>
                <td class="lableTxt" align="left" valign="top" NOWRAP ><b><%= langText.get("Manage User(s)") %></b></td>
                <td>&nbsp;</td>
                <td><INPUT type="checkbox" NAME="manageUserFlag" <%if(au.getManageUserFlag().equals("Y")) {%> VALUE="<%=au.getManageUserFlag()%>" checked <%} else {%> VALUE="Y"<%}%>><%= langText.get("yes") %></td>
                <td>&nbsp;</td>
            </tr>
                                                
            <tr>
                <td colspan="3"><img src="/images/mysites/spacer.gif" width="1" height="5" alt="" border="0"></td>
            </tr>
            <tr>
                <td colspan="3"><img src="/images/mysites/spacer.gif" width="1" height="5" alt="" border="0"></td>
            </tr>
            <tr>
                <td colspan="3"><img src="/images/mysites/spacer.gif" width="1" height="5" alt="" border="0"></td>
            </tr>
            <tr>
                <td colspan="3" align="center">
                    <img src="/images/mysites/spacer.gif" width="1" height="5" alt="" border="0">
                    <a class="actionLink" HREF="#" onClick='return validateUserFields("mySiteEditForm");'><%= langText.get("Submit") %></a>                                       
                    &nbsp;&nbsp;&nbsp;<b style="font-size:13px">|</b>&nbsp;&nbsp;&nbsp;
                    <a class="actionLink" HREF="<%=cancelHandle%>"><%= langText.get("Cancel") %></AA
                </td>
            </tr>
                        
            
            
            </table>
       <%--
       <table>
          <tr><td>&nbsp;</td></tr>
           <tr>
               <TD WIDTH="68">
                   <a class="actionLink" HREF="#" onClick='return validateUserFields("mySiteEditForm");'>Submit</a>
               </TD>
               <TD></TD>
               <TD></TD>
               <TD></TD>
               <TD></TD>
               <TD WIDTH="68">
                  <a  class="actionLink" HREF="<%=cancelHandle%>">Cancel</A>                               
               </TD>
               <TD></TD>
               <TD></TD>
               <TD></TD>
               <TD></TD>
           </TR>
       </TABLE>
       --%>
</td>
</tr>
</table>

</FORM>
</td></tr>
</tbody>
</table>
<%} 
else 
{
        out.println("<font class=\"resultMsg\">"+bundle.getString("MB_NO_ACCESS")+"</font>");
}
%> 
