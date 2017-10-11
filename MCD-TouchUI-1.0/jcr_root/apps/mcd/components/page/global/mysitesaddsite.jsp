<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">  
<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ include file="/apps/mcd/global/global.jsp"%>   
<%@ page import="java.net.*"%> 
<%
     /*response.setHeader("Cache-Control","no-cache");
     response.setHeader("Cache-Control","no-store"); 
     response.setDateHeader("Expires", 0);
     response.setHeader("Pragma","no-cache"); */               
%>
 
<%  
 
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

String bookMarkType = request.getParameter("bookMarkType");
log.error("bookMarkType---"+bookMarkType);
String mode = request.getParameter("mode");
log.error("mode        ---"+mode);
String readOnly = "";
if(bookMarkType.equalsIgnoreCase("global"))
{
    readOnly = "readonly";
}
String siteID=request.getParameter("siteID");
String siteName=URLDecoder.decode(request.getParameter("siteName"),"UTF-8");  
//String siteName=URLEncoder.encode((String)request.getParameter("siteName"),"UTF-8"); 
//out.println("siteName    ---"+request.getParameter("siteName"));
//out.println("siteName    ---"+siteName);
siteName = siteName.replaceAll("\\|","&");
String oldSiteName=request.getParameter("oldSiteName");   
//String oldSiteName=URLEncoder.encode((String)request.getParameter("oldSiteName"),"UTF-8");   
log.error("oldSiteName ---"+oldSiteName);
oldSiteName = oldSiteName.replaceAll("\\|","&");
  
log.error("siteID      ---"+siteID);


if(mode.equalsIgnoreCase("Add"))
{
    oldSiteName = " ";
}
String siteURL = request.getParameter("siteURL");
log.error("siteURL     ---"+siteURL);
siteURL = siteURL.replaceAll("\\|","&");

String sourceList = request.getParameter("sourceList"); 
String style = request.getParameter("class");

log.error("sourceList  ---"+sourceList);
log.error("style       ---"+style);

%>

<html>
  <head>   
    
    <title><%=mode %> BookMark</title>
    
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">    
    
    <link rel="STYLESHEET" type="text/css" href="/css/add_editbookmarks.css"> 
    <SCRIPT language=Javascript>
    
    function addOptions()
    {
        var title = trim(document.getElementById('pageTitle').value);
        var URL = trim(document.getElementById('pageURL').value);
        var isLinkUpdated = '';
        title = title.replace(/'/g,"&#39;");
        title = title.replace(/"/g,"&quot;");
        var oldTitle = '<%= oldSiteName.replaceAll("'","&#39;").replaceAll("\"","&quot;")%>';
        
        if(title == '')
        {
            alert('Please Enter Page Title.');
            return false;
        }
        if(URL == '')
        {
            alert('Please Enter Page URL.');
            return false;
        }
        
        if('<%= sourceList %>' == 'favorite')
        {
            isLinkUpdated = 'Y';
        }
        else
        {
            if(oldTitle == title)
            {
                isLinkUpdated = 'N';
            }
            else
            {
                isLinkUpdated = 'Y';
            }
        }  
        
        //var newText = title;
        var newText = encodeURI(title);
        newText = newText.replace(/&#39;/g,"'");
        newText = newText.replace(/&quot;/g,"\"");
        //var newValue = '<%= siteID %>'+'^$^'+title+'^$^'+URL+'^$^'+isLinkUpdated+'^$^'+'<%= oldSiteName.replaceAll("'","&#39;").replaceAll("\"","&quot;") %>';
        var newValue = '<%= siteID %>'+'^$^'+newText+'^$^'+URL+'^$^'+isLinkUpdated+'^$^'+oldTitle;
        newValue = newValue.replace(/&#39;/g,"'");
        newValue = newValue.replace(/&quot;/g,"\"");
        
        var retValue = window.parent.addOptionFromPopup(newText, newValue, '<%= mode %>', '<%= sourceList %>', '<%= style %>');
        if(retValue == '')
        {
            window.parent.killColorBox(); 
            //window.close();
        }
        else
        {
            alert(retValue);
            return false;
        }
    }
    function trim(strTemp)
    {
        return strTemp.replace(/^\s*/, "").replace(/\s*$/, ""); 
    }
    
    </SCRIPT>
  </head>
  
  <body>
    <h2><%=mode %><%= langText.get("a Bookmark.") %></h2>
    <hr>
    <p><%= langText.get("Add this webpage as a bookmark. To access your bookmark, select the My Bookmarks link.") %></p>
    <table style="width:100%" border=0>
        <tr>
            <td width="14%"><b><%= langText.get("Page Title") %>:</b></td>  
            <td> <input style="width:200px" type="text" name="pageTitle" id="pageTitle" value="<%= siteName %>" maxlength="50"/></td>
        </tr> 
        <tr> 
            <td><b><%= langText.get("Page URL") %>:</b></td>
            <td><input style="width:430px" <%= readOnly %> type="text" name="pageURL" id="pageURL" value="<%= siteURL %>"/></td>
        </tr>   
        <tr height="25px"> <td colspan = '2'> </td> </tr> 
        <tr>
            <td align="center" colspan='2'>
                
                <% 
                if (mode.equalsIgnoreCase("Add"))
                {%>
                    
                    <a style="width:60px;cursor: pointer;color:#000000;font-size:8pt;font-weight:bold;" onClick="javascript:addOptions();"><img align="absMiddle" src="/images/add.png"/> <%= langText.get("Add") %></a>
                <%
                } 
                else if (mode.equalsIgnoreCase("Edit"))
                {%>
                    <a style="width:60px;cursor: pointer;color:#000000;font-size:8pt;font-weight:bold;" onClick="javascript:addOptions();"><img align="absMiddle" src="/images/edit.png"/>&nbsp;<%= langText.get("Edit") %></a>
                <%
                }
                %>
                &nbsp;&nbsp;|&nbsp;&nbsp;<a style="width:60px;cursor: pointer;color:#000000;font-size:8pt;font-weight:bold;" onClick="javascript:window.parent.killColorBox();window.parent.refresh();"><img align="absMiddle" src="/images/cancel.gif"/> <%= langText.get("Cancel") %></a>  
            </td>
        </tr>
    </table>
  </body>
</html>     