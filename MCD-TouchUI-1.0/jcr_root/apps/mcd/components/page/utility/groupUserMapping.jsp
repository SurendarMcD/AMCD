<%-- 
  ==============================================================================
  Group Detail Form
  ==============================================================================
--%>  
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page session="false" %><%
%><%@ page import="java.util.ArrayList,
        java.util.Iterator,
        org.apache.jackrabbit.api.JackrabbitSession,
		org.apache.jackrabbit.api.security.JackrabbitAccessControlManager,
		javax.jcr.security.Privilege,
		org.apache.jackrabbit.commons.JcrUtils,
		org.apache.jackrabbit.api.security.user.*"%><%
%><%!
private String getPropertyString(Value[] values) throws Exception {
        if (values != null) {
            if (values.length > 0) {
                return values[0].getString();
            }
        }
        return null;
    }
%><%
String groupType=request.getParameter("type");
String groupIdentifier = (groupType.equals("publish"))? "-P-" : "-A-";

UserManager userMgr = resourceResolver.adaptTo(UserManager.class);
//Iterator<Authorizable> groupIter = userMgr.findAuthorizables("rep:principalName", "CORP-A-%", UserManager.SEARCH_TYPE_GROUP);
Iterator<Resource> resIter = resourceResolver.findResources("//element(*,rep:Group)", "xpath");


%>
<table border="1" width="100%">
    <tr>
        <td width="20%">Group Name</td>
        <td width="50%">Members</td>
        <td width="30%">Administrators</td>
    </tr>
<%
    String groupHtml = "";
    int perCount =0; 
    Session session = null;
    while(resIter.hasNext()){
        Resource res = resIter.next();
        Group group = res.adaptTo(Group.class);
        String groupId = group.getID();
        String adminUsers = getPropertyString(group.getProperty("AdminUsers"));

        if(groupId.toUpperCase().indexOf(groupIdentifier) > -1)
        {
            Iterator<Authorizable> userIter = group.getMembers();
            while(userIter.hasNext()) {
                Authorizable author = userIter.next();
                if(!author.isGroup()) {
                    User user = (User) author;

                    groupHtml += "<tr><td>"+groupId+"</td><td>" + getPropertyString(user.getProperty("givenName")) + " " 
                        + getPropertyString(user.getProperty("familyName")) + " (" + user.getID() + ")" + "</td>";


                                groupHtml += "<td>";

            if(adminUsers!=null)
            {
                String[] adminUserIds = adminUsers.split(",");

                for (int i=0;i<adminUserIds.length;i++) {
                    Authorizable adminUser = (User)userMgr.getAuthorizable(adminUserIds[i]);
                    if(adminUser!=null){
                        groupHtml += getPropertyString(adminUser.getProperty("givenName")) + " " 
                                    + getPropertyString(adminUser.getProperty("familyName")) + " (" + adminUser.getID() + ")";

                    }
                } 
            }
            groupHtml += "</td></tr>";


                }
            }

        }
    }
%>
    <%=groupHtml%> 
</table>
