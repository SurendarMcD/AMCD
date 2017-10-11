<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*, 
                java.net.*,
                java.io.*, 
                javax.jcr.*,
                com.day.cq.security.*"%>
                
<%@ page import="com.mcd.accessmcd.mysites.bean.SiteList"%>
<%@ page import="com.mcd.accessmcd.mysites.constants.*"%>
<%@ page import="com.mcd.accessmcd.mysites.manager.*"%>
<%@ page import="com.mcd.accessmcd.mysites.bean.*"%>
<%@ page buffer="1024kb"%>
<%@ include file="/apps/mcd/global/global.jsp"%> 
<%
//String path = getServletContext().getRealPath("/");
//String path = request.getContextPath();
//String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path;
String pageTitle = currentPage.getTitle();
//String siteURL = path+currentPage.getPath()+".html"; 
//siteURL = siteURL.replaceAll("/content/","/");
%>  

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

  <head> 
    <script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script>
    <link rel="STYLESHEET" type="text/css" href="/css/add_editbookmarks.css">
    <title>Add a BookMark</title>
    
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">    
    
    <SCRIPT language=Javascript>
        function AddBookMarkAction(override) 
        {
            var title = trim(document.getElementById('pageTitle').value);
            
            if(title == '')
            {
                alert('Please Enter Page Title.'); 
                return false;
            }
            
            document.AddBookMarkForm.override.value = override;
            document.AddBookMarkForm.SaveBookMark.value = '1';
            document.AddBookMarkForm.submit();
            return true;
        }
        function trim(strTemp)
        {
            return strTemp.replace(/^\s*/, "").replace(/\s*$/, ""); 
        }
        
        $(document).ready(function(){
            document.AddBookMarkForm.pageURL.value=parent.location.toString().replace("/content/","/");
        });
    </script>
    
  </head>
  <body>
  <form name="AddBookMarkForm" method="GET" action="<%=currentPage.getPath()%>.addtobookmark.html?SaveBookMark=1">
    
        <input type ="hidden" id="SaveBookMark" name="SaveBookMark" value="0"/>
        <input type ="hidden" id="override" name="override" value="N"/>
        <h2>Add a BookMark.</h2>
        <p>Add this webpage as a bookmark. To access your bookmark, select the My Bookmarks link.</p>
          
        <table style="width:100%">
            <tr>
                <td width="22%">Page Title:</td>
                <td><input style="width:200px" type = "text" name = "pageTitle" id = "pageTitle" value = '<%= pageTitle %>' maxlength="50" /></td>
            </tr>
            <tr> <td> </td> <td> </td> </tr>
            <tr> 
                <td>Page URL:</td>
                <td><input style="width:430px" type="text" name="pageURL" id="pageURL" readonly="readonly" value="" /></td>
            </tr>
            <tr height="25px"> <td colspan = '2'> </td> </tr>
            <tr>
                <td align = 'center' colspan = '2'>
                    <a style="cursor: pointer; font-weight:bold;text-decoration:none;font-size:8pt;"  onClick='javascript:AddBookMarkAction("N");' value = 'Add'><img align="absMiddle" src="/images/add.png" />&nbsp;Add</a>&nbsp; &nbsp;|&nbsp; &nbsp;
                    <a style="cursor: pointer; font-weight:bold;text-decoration:none;font-size:8pt;"  onClick='javascript:window.parent.killColorBox();' value = 'Cancel'><img align="absMiddle" src="/images/cancel.gif" />&nbsp;Cancel</a>
                </td>
            </tr>
        </table>
      
<%  
    final UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
    Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
    User loggedInUser = slingRequest.getResourceResolver().adaptTo(User.class);
    ResourceBundle bundle = slingRequest.getResourceBundle(request.getLocale());
    String userId = loggedInUser.getID(); 
    String save = request.getParameter("SaveBookMark");
    String title = request.getParameter("pageTitle");
    if(title != null)
        title = title.trim();
    String url = request.getParameter("pageURL");
    String override = request.getParameter("override");
    boolean overrideFlag = false;
    if(override == null || override.equalsIgnoreCase("N"))
    {
        overrideFlag = false;
    }
    else
    {
        overrideFlag = true;
    }
    try 
    {
        MySitesManager mySitesManager = new MySitesManager(sling, jcrSession);
        if ("1".equals(save)) 
        {    
            Site site = new Site();
            site.setActiveIndicator("Y");
            site.setSiteName(title);
            site.setSiteURI(url);
            String statusCode = mySitesManager.addToMySites(userId, site, overrideFlag);
            if(statusCode.equalsIgnoreCase(MySitesConstants.BOOKMARK_ADDED_SUCCESSFULLY))
            {
%>          
                <script>
                    alert('<%= bundle.getString(statusCode) %>');
                    window.parent.changeRequestFlag('1');
                    //window.opener.window.location.reload(true);
                    window.parent.killColorBox();
                </script>
<%
            }
            else if(statusCode.equalsIgnoreCase(MySitesConstants.BOOKMARK_ALREADY_EXISTS_OVERRIDE))
            {
%>          
                <script>
                    document.AddBookMarkForm.pageTitle.value = '<%= title%>';
                    var r = window.confirm('<%= bundle.getString(statusCode) %>');
                    if (r == true) 
                    {
                        AddBookMarkAction("Y");
                    }
                    else
                    {
                        
                    }
                </script>
<%
            }
            else if(statusCode.equalsIgnoreCase(MySitesConstants.BOOKMARK_UPDATED_SUCCESSFULLY))
            {
%>          
                <script>
                    alert('<%= bundle.getString(statusCode) %>');
                    window.parent.changeRequestFlag('1');
                    window.parent.killColorBox();
                </script>
<%
            }
            else if(statusCode.equalsIgnoreCase(MySitesConstants.FAV_BOOKMARK_SITE_LIMIT_EXEEDED))
            {
%>          
                <script>
                    alert('<%= bundle.getString(statusCode).replaceAll("maxVal", String.valueOf(MySitesConstants.MAX_SITES)) %>');
                    window.parent.changeRequestFlag('1'); 
                    window.parent.killColorBox();
                </script>
<%
            }
        }
    } 
    catch (Exception e) 
    {
        e.printStackTrace();
    } 
%> 
  </form>
  </body>