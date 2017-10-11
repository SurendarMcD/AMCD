<%@page import="java.net.*"%> 
<%
userID = (String)request.getParameter("userID");  
view = (String)request.getParameter("view");

if (isAdministrator) 
{
    String addSiteHandle = currentPage.getPath() + ".mysitesadmin.html?action=addSite&userID="+userID+"&view="+view;
    String editSiteHandle = currentPage.getPath() + ".mysitesadmin.html?action=editSite&userID="+userID+"&view="+view;
    String deleteSiteHandle = currentPage.getPath() + ".mysitesadmin.html?action=deleteSite&userID="+userID+"&view="+view;
    String viewAdminUsers = currentPage.getPath() + ".mysitesadmin.html?action=viewAdminUsers&userID="+userID+"&view="+view;
    String searchHandle = currentPage.getPath() + ".mysitesadmin.html?action=search&userID="+userID+"&view="+view;
    String showAllHandle = currentPage.getPath() + ".mysitesadmin.html?userID="+userID+"&view="+view;
    
    List al = new ArrayList();
    al = (List) request.getAttribute("adminSiteList");
                                
    if (al.size() == 0)   
    {
        out.println("<font class=\"resultMsg\">"+bundle.getString("MB_NO_SITES_FOUND")+"</font>");
    }
%>
    <title><%= langText.get("Configure Admin Sites") %></title>
    <fieldset><legend><b><%= langText.get("Configure Admin Sites") %></b></legend>
    <hr/><br>
    <table border="0" cellspacing="0" cellpadding="2" width="100%">
    <tbody align="center">
    <tr>
        <td>    
            <!-- Display Menu Buttons -->
            <table border="0" cellspacing="0" cellpadding="2" width="800">
                <tr>
                    <td align="left">
                        <a href="<%=addSiteHandle%>" class="actionLink"><%= langText.get("Add a New Site") %></a>
                        &nbsp;&nbsp;&nbsp;<b style="font-size:13px">|</b>&nbsp;&nbsp;&nbsp;
                        <a href="<%=deleteSiteHandle%>" class="actionLink" onclick='validateSiteAndSubmit("delete"); return false;'><%= langText.get("Delete Sites") %></a>                        
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td> 
            <table border="0" cellspacing="0" cellpadding="2" bgcolor=CCCCCC width="800">   
                <form name="mySiteSearchForm" method="GET" action="<%=searchHandle%>" onsubmit = 'return (mySiteAction("go", ""));'>
                    <input type="hidden" name="userID" value="<%= userID %>"/>
                    <input type="hidden" name="view" value="<%= view %>"/>
                    <input type="hidden" name="action" id = "action" value=""/>
                                    
                    <tr>
                        <td>
                            <img src='/images/mysites/icon_filter.gif' border=0 alt="Search A Site"><font class="lableTxt"><b><%= langText.get("Filter") %>: </b></font>
                            <INPUT type=RADIO value="searchna"  name="searchby" class="assetTable" checked><font class="lableTxt"><b><%= langText.get("By Site Name") %></b></font>
                            <input type="text" name="searchKeywords" value='' maxlength="50" size="25">
                
                            <INPUT type="button" onClick='javascript:mySiteAction("go", "");' class="text" value = '<%= langText.get("Go") %>' id = 'btnGo'/>
                            <INPUT type="button" onClick='javascript:mySiteAction("showAll", "<%=showAllHandle%>");' class="text" value = '<%= langText.get("Show All") %>'/>
                     
                        </td>
                    </tr>
                </form>
            </table>
        </td>
    </tr>
            
       <tr>
           <td>
               <table class="dataTable" border="1" cellpadding="2" cellspacing="0" width="800" >
                   <form name="myForm" method="GET" action="<%=deleteSiteHandle%>">
       
                       <input type="hidden" name="userID" value="<%= userID %>"/>
                       <input type="hidden" name="view" value="<%= view %>"/>
                       <input type="hidden" name="action" value=""/>
                       <tr  class="lableTxt" bgcolor="#f8f8ff" align="center">
                           <td align="center" colspan="3" nowrap><br><input type="checkbox" name="checkAllSiteId" value="yes" onClick="javascript:checkAllSites();">&nbsp;<b><%= langText.get("Select All") %></b>&nbsp;<br>&nbsp;</td>
                           <td><b><%= langText.get("Site Name") %></b><br></td>
                           <td width = "50"><b><%= langText.get("View") %></b><br></td>  
                           <td width = "150"><b><%= langText.get("Audience Type") %></b><br></td>
                       </tr>    
<%   
                    if (al.size() != 0) 
                    {
                        String audienceType = "";
                        String siteNam = "";
                        for (Iterator liter = al.iterator(); liter.hasNext();  ) 
                        {
                            Site as = new Site();
                            as = (Site) liter.next();
                            siteNam = as.getSiteName();
                            siteNam = siteNam.replaceAll("\\%","%25").replaceAll("&","%26").replaceAll("\\+","%2B").replaceAll("\"","%22").replaceAll("\\\\","%5C").replaceAll("\\#","%23");
                           
%>
                            <tr bgcolor="#FFFFFF" valign="top">
                                <td valign="top" nowrap align="center" colspan="2"><input type="checkbox" name="siteId" value="<%=URLEncoder.encode(as.getSiteName().replaceAll("\"","&quot;"),"ISO-8859-1")%>"></td>
                                <td align="center" valign="top">
                                    
                                    <a href="<%=editSiteHandle%>&siteName=<%=URLEncoder.encode(siteNam,"ISO-8859-1")%>">
                                        <img src="/images/mysites/edit.gif" border="0" alt="Edit a Site">
                                    </a> 
                                </td> 
                                <td><a href='javascript:gotoSite("<%=basePath%>", "<%=as.getSiteURI()%>")' class="contentlnk"><%=as.getSiteName()%></a></td>
                                <td colspan = 2>
                                
                                    <table border="0" cellpadding="2" cellspacing="0" width="100%">
<%
                                    for(EntityType entity : as.getEntityType())
                                    {
                                        audienceType = "";
%>
                                        <tr>
                                            <td width = "25%">-<%= entity.getEntityType() %></td>
<%
                                            if(as.getAudienceType().get(entity.getEntityType()) != null)
                                            {
                                                for(AudienceType audType : as.getAudienceType().get(entity.getEntityType()))
                                                {
                                                    audienceType += "-" + audType.getAudienceType() + "<br>";
                                                }
                                            }
%>
                                            <td width = "75%"><%=audienceType%></td>
                                        </tr>
<%
                                    }
%>
                                    </table>
                                </td>
                            </tr>
<%
                        }
                        }
%>
                    </form>
                </table>
            </td>
        </tr>
                        
    <tr>
        <td>    
            <!-- Display Menu Buttons -->
            <table border="0" cellspacing="0" cellpadding="2" width="800">
                <tr>
                    <td align="left">
                        <a href="<%=addSiteHandle%>" class="actionLink"><%= langText.get("Add a New Site") %></a>
                        &nbsp;&nbsp;&nbsp;<b style="font-size:13px">|</b>&nbsp;&nbsp;&nbsp;
                        <a href="<%=deleteSiteHandle%>" class="actionLink" onclick='validateSiteAndSubmit("delete"); return false;'><%= langText.get("Delete Sites") %></a>                        
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
<fieldset> 
<%
}
else 
{
    out.println("<font class=\"resultMsg\">"+bundle.getString("MB_NO_ACCESS")+"</font>");
}
%> 