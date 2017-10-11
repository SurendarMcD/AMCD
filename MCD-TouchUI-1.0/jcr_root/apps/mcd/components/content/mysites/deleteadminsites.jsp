<%@page import="java.net.*"%>  
<%
userID = (String)request.getParameter("userID");        
view = (String)request.getParameter("view");

if (isAdministrator)
{
    String deleteSiteHandle = currentPage.getPath() + ".mysitesadmin.html?action=confirmDeleteSite&userID="+userID+"&view="+view;
    String[] siteNames = request.getParameterValues("siteId");
    String[] siteNamesDB = new String[siteNames.length];
    for(int i=0; i< siteNames.length; i++){
        siteNamesDB[i] = URLDecoder.decode(siteNames[i],"ISO-8859-1");
    }
    List<Site> al = new ArrayList<Site>();
    al = mySitesManager.getSites(siteNamesDB, userID);     

    if (al.size() == 0) 
    {
        out.println("<font class=\"resultMsg\">"+bundle.getString("MB_NO_SITES_FOUND")+"</font>");
    }  
        
    String cancelHandle = pageHandle + ".mysitesadmin.html?userID="+userID+"&view="+view;
%>
  <title><%= langText.get("Delete Sites") %></title>
    <fieldset><legend><b><%= langText.get("Delete Sites") %></b></legend>
    <hr/><br> 
    <table border="0" cellspacing="0" cellpadding="2" width="100%">
    <tbody align="center">
    
    <tr>
        <td>    
            <!-- Display Menu Buttons -->
           <table border="0" cellspacing="0" cellpadding="2" width="700">
                <tr>
                    <td align="left">
                        <a class="actionLink" HREF="#" onClick='return validateDeleteSiteIDs("mySiteDeleteForm");'><%= langText.get("Delete") %></a>
                        &nbsp;&nbsp;&nbsp;<b style="font-size:13px">|</b>&nbsp;&nbsp;&nbsp;
                        <a class="actionLink" HREF="<%=cancelHandle%>"><%= langText.get("Cancel") %> </a>                        
                    </td>
                </tr>
            </table>
            
              
        </td>
    </tr>
<%
    if (al.size() != 0) 
    {
%>
        <tr>
            <td>
                <table class="dataTable" border="1" cellpadding="2" cellspacing="0" width="700">
                <tbody align="center">
                    <form name="mySiteDeleteForm" method="GET" action="<%=deleteSiteHandle%>">        
                        <input type="hidden" name="userID" value="<%= userID %>"/>
                        <input type="hidden" name="view" value="<%= view %>"/>
                        <input type="hidden" name="action" value=""/>
                        <tr  class="lableTxt" bgcolor="#f8f8ff">
                            <td width="18%"><br><input type="checkbox" name="checkAllSiteId" value="yes" onClick="javascript:checkAllDeletedSites();">&nbsp;<b><%= langText.get("Select All") %></b>&nbsp;<br>&nbsp;</td>
                            <td width="50%"><b><%= langText.get("Site Name") %></b><br></td>
                            <td width="18%"><b><%= langText.get("View") %></b><br></td>
                        </tr>   
    
<%
                        String audienceType = "";
                        for (Iterator liter = al.iterator(); liter.hasNext();  ) 
                        {
                            Site as = new Site();
                            as = (Site) liter.next();
%>
                            <tr bgcolor="#FFFFFF" valign="top">
                                <td width="18%" valign="top" nowrap><input type="checkbox" name="siteId" value="<%=as.getSiteID()%>"></td>
                                <td width="50%" align="left" style="padding-left:5px;"><a href='javascript:gotoSite("<%=as.getSiteURI()%>")' class="contentlnk"><%=as.getSiteName()%></a></td>
                                <td width="18%" valign="top"><%=((EntityType)as.getEntityType().get(0)).getEntityType()%></td>
                            </tr>
<%
                        }
%>
                    </form>
                    </tbody>
                </table>
            </td>
        </tr>
<% 
    }
%>
    <tr>
        <td>    
            <!-- Display Menu Buttons -->
           <table border="0" cellspacing="0" cellpadding="2" width="700">
                <tr>
                    <td align="left">
                        <a class="actionLink" HREF="#" onClick='return validateDeleteSiteIDs("mySiteDeleteForm");'><%= langText.get("Delete") %></a>
                        &nbsp;&nbsp;&nbsp;<b style="font-size:13px">|</b>&nbsp;&nbsp;&nbsp;
                        <a class="actionLink" HREF="<%=cancelHandle%>"> <%= langText.get("Cancel") %> </a>                        
                    </td>
                </tr>
            </table>
            
              
        </td>
    </tr>
</tbody>
</table>
</td></tr>
</tbody>
</table>
<%
}
else
{
    out.println("<font class=\"resultMsg\">"+bundle.getString("MB_NO_ACCESS")+"</font>");
}
%> 