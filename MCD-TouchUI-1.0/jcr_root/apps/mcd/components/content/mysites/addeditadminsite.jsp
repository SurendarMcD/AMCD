<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%> 
<%@page import="java.net.*"%> 
<%    
if (isAdministrator) 
{
    userID = (String)request.getParameter("userID");
    view = (String)request.getParameter("view");
    
    String title="";
    String siteId = "";
    String siteName = "";
    String siteURI = "";
    String siteAudienceTypeStr = "";
    Map siteAudienceTypeMap = new HashMap();
    Vector<EntityType> allEntityTypes = mySitesManager.getEntityTypes(userID);
    Vector<AudienceType> allAudTypes = mySitesManager.getAudienceTypes();
    Vector<EntityType> entyTypes = null;
    Map<String, List<AudienceType>> audTypes = null;
    
    //get handles
    String handle = "";

    if (action.equals("addSite")) 
    {
        handle = pageHandle + ".mysitesadmin.html?action=confirmAddSite";
        title =langText.get("Add Site");
    } 
    else 
    { 
        handle = pageHandle + ".mysitesadmin.html?action=confirmEditSite";
        title = langText.get("Edit Site");
    
        siteId = request.getParameter("siteId");
        siteName = request.getParameter("siteName");
        //get site info
        if (siteName != null) 
        {
            Site as = mySitesManager.getAdminSite(siteName, userID);
            entyTypes = as.getEntityType();
            audTypes = as.getAudienceType();
            siteId = as.getSiteID();
            //siteName = as.getSiteName();
            siteURI = as.getSiteURI();
            for(EntityType allEntyType : entyTypes)
            {
                siteAudienceTypeStr = "";
                for(AudienceType audienceType : audTypes.get(allEntyType.getEntityType()))
                {
                    siteAudienceTypeStr += audienceType.getAudienceTypeId() + ",";
                }
                siteAudienceTypeMap.put(allEntyType.getEntityType(),siteAudienceTypeStr);
            }
        }
    }
    siteName = siteName.replaceAll("\"","&quot;");                                       
    String cancelHandle = pageHandle + ".mysitesadmin.html?userID="+userID+"&view="+view;
%>  
  <title><%=title%></title>
    <fieldset><legend><b><%=title%></b></legend>
    <hr/>
    <FORM name="mySiteEditForm" > 
        <table width="100%" border="0" cellspacing="0" cellpadding="2" class="text">
            <tr>
                <td><input type="hidden" name="siteNameOld" value="<%=siteName%>"></td>
            </tr>
            <tr>
                <td bgcolor="" valign="top">
                    <img src="/images/mysites/spacer.gif" width="30" height="1" border="0" alt=""><br>
                </td>
                <td bgcolor=""> <img src="/images/mysites/spacer.gif" width="50" height="1" border="0" alt=""></td>
                <td width="90%" bgcolor="" align="center">
                    <table width="100%" border="0" cellspacing="0" cellpadding="2" align="center" class="text">
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
                            <td class="lableTxt" align="left" valign="top" width="25%"><b><%= langText.get("Status") %></b></td>
                            <td width="3%">&nbsp;</td>
                            <td width="30%"><b><%=title%></b></td>
                            <td width="42%">&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="3"><img src="/images/mysites/spacer.gif" width="1" height="5" alt="" border="0"></td>
                        </tr>
                        <tr>
                            <td colspan="3"><img src="/images/mysites/spacer.gif" width="1" height="5" alt="" border="0"></td>
                        </tr>
                        <tr>
                            <td class="lableTxt" align="left" valign="top" width="25%"><b><%= langText.get("Site Name") %>&nbsp;<span class="txtMandatory">*</span></b></td>
                            <td width="3%">&nbsp;</td>
                            <td width="30%"><INPUT type = "text" NAME="siteName" VALUE="<%=siteName%>" size="50" maxlength="100"></td>
                            <td width="42%">&nbsp;</td>
                        </tr>   
<%
                        if (action.equals("addSite")) 
                        {
%>
                            <input type="hidden" name="action" value="confirmAddSite"/>
<% 
                        } 
                        else 
                        {
%>
                            <input type="hidden" name="action" value="confirmEditSite"/>
<%
                        }
%>  
                        <input type="hidden" name="userID" value="<%= userID %>"/>
                        <input type="hidden" name="view" value="<%= view %>"/>
                        <tr>
                            <td colspan="3"><img src="/images/mysites/spacer.gif" width="1" height="5" alt="" border="0"></td>
                        </tr>
                        <tr>
                            <td class="lableTxt" align="left" valign="top" width="25%"><b><%= langText.get("Audience Type") %>&nbsp;<span class="txtMandatory">*</span></b></td>
                            <td width="3%">&nbsp;</td>
                            <td width="30%">
                                <table>
                                    <tr valign="top">
                                    
<%
                                    int counter = 0;
                                    String separator = "";
                                    String bkEntities = "";
                                    for (EntityType entity : allEntityTypes)
                                    {
%>
                                        <script language="javascript">
                                            allEntityTypesArr[<%=counter%>] = "<%= entity.getEntityType().trim() %>";
                                        </script>
                                        <td style="padding-right: 10px;">
                                            <b><%= entity.getEntityType()%></b> <br><br>
                                            
                                            <SELECT NAME="<%= entity.getEntityType()+"AudType" %>" ID="<%= entity.getEntityType()+"AudType" %>" MULTIPLE size=7>
<%
                                                counter++;
                                                for (AudienceType audType : allAudTypes)
                                                {
                                                    siteAudienceTypeStr = (String)siteAudienceTypeMap.get(entity.getEntityType());
                                                    if(siteAudienceTypeStr == null)
                                                        siteAudienceTypeStr = "";
%>
                                                    <option value="<%=audType.getAudienceTypeId()%>" <%if (siteAudienceTypeStr.indexOf(audType.getAudienceTypeId()) != -1) {%> selected <%}%>>
                                                    <%=audType.getAudienceType()%></option>
<%
                                                }
%>
                                            </SELECT>
                                        </td>                                    
<%
                                        if(counter%3 == 0)
                                        {
%>
                                            </tr><tr>
<%
                                        }
                                        bkEntities +=  separator;
                                        bkEntities +=  entity.getEntityType();
                                        if(separator == "") separator = ",";
                                    }
%>
                                    </tr>
                                    <input type="hidden" name="entityType" id="entityType" value="<%=bkEntities%>" />
                                </table>
                            </td>
                            <td width="42%">&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="3"><img src="/images/mysites/spacer.gif" width="1" height="5" alt="" border="0"></td>
                        </tr>
                        <tr>
                            <td class="lableTxt" align="left" valign="top" width="25%"><b><%= langText.get("URL") %>&nbsp;<span class="txtMandatory">*</span></b></td>
                            <td width="3%">&nbsp;</td>
                            <td width="30%"><INPUT NAME="siteURI" VALUE="<%=siteURI%>" size="75" maxlength="255"></td>
                            <td width="42%">&nbsp;</td>
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
                                <a class="actionLink" HREF="#" onClick='validateSiteFields("mySiteEditForm",allEntityTypesArr,"<%=handle.replaceAll("/content","")%>");'><%= langText.get("Submit") %></a>
                                &nbsp;&nbsp;&nbsp;<b style="font-size:13px">|</b>&nbsp;&nbsp;&nbsp;
                                <a class="actionLink" HREF="<%=cancelHandle%>"><%= langText.get("Cancel") %></a>
                            </td>
                        </tr>
                    </table>
                    <%--
                    <table>
                        <tr>
                            <TD WIDTH="68">
                                <a class="actionLink" HREF="#" onClick='return validateSiteFields("mySiteEditForm",allEntityTypesArr);'>Submit</a>
                            </TD>
                            <TD></TD>
                            <TD></TD>
                            <TD></TD>
                            <TD></TD>
                            <TD WIDTH="68">
                                <a class="actionLink" HREF="<%=cancelHandle%>">
                                    Cancel
                                </a>
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
    </fieldset> 
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