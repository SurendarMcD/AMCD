<%@ page import="java.util.Iterator"%> 
<%@ page import="java.lang.String"%>

<%@ page import="java.util.TreeMap"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.StringTokenizer"%>
<%@ page import="com.mcd.accessmcd.mysites.manager.MySitesManager"%>
<%@ page import="com.mcd.accessmcd.mysites.bean.*"%>
<%@ page import="java.util.*, 
                java.net.*, 
                java.io.*,
                javax.jcr.*,
                com.day.cq.security.*"%>
<%@ include file="/apps/mcd/global/global.jsp"%> 
           
<%
    response.setHeader("Cache-Control","no-cache");
    response.setHeader("Cache-Control","no-store");
    response.setDateHeader("Expires", 0);
    response.setHeader("Pragma","no-cache");
    
    String regex= "/[-!$%&^<>*()_+@|~\"\'`=\\#{}\\[\\]:;?,.\\/]";
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path;

    final UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
    Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
    User loggedInUser = slingRequest.getResourceResolver().adaptTo(User.class);
    
    String userID = loggedInUser.getID();
    //String userID = request.getParameter("userID");
    String view = request.getParameter("view");
    view= rejectCheck(regex,view);
    MySitesManager mySitesManager = new MySitesManager(sling, jcrSession);
    FavoriteSiteList favSiteList = mySitesManager.getFavourtiteSites(userID, view);
    boolean isAdministrator = favSiteList.isAdministrator();
    boolean isSuperUser = favSiteList.isSuperUser();
    List favSites = favSiteList.getFavoriteSiteList();
    Iterator favSitesItr = favSites.iterator(); 
    
    String editBookmarkURL= prop.getProperty(view.toLowerCase()+"BookmarkPage")+".html?view="+view;
    String[] domainNames = prop.getProperty("domainNames").split(",");
    
    String editSitesURL = currentPage.getPath()+".mysitesadmin.html?action=viewAdminSites&view="+view+"&userID="+userID;
    String editUserURL = currentPage.getPath()+".mysitesadmin.html?action=viewAdminUsers&view="+view+"&userID="+userID;
%>
<%! 
 
      public String rejectCheck(String expression,String param){ 
    
    for (int i = 0; i < expression.length(); i++){
    String c = "" + expression.charAt(i);   
 
    param = param.replace(c,"");
    }
    return(param.trim());
}
%> 
    <li>&nbsp;</li>
    <li>&nbsp;<a href="<%=editBookmarkURL%>"><%= langText.get("Edit My Bookmarks") %></a></li>
<%  
    if(isAdministrator)
    {
%>
        <li>&nbsp;<a href="#" onclick="window.open('<%= editSitesURL %>','', 'location=yes,menubar=yes,toolbar=yes,scrollbars=yes,status=yes,resizable=yes,width=850,height=500')"><%= langText.get("Configure Admin Sites") %></a></li>     
<%
    }
    if(isSuperUser)
    {
%>
        <li>&nbsp;<a href="#" onclick="window.open('<%= editUserURL %>','', 'location=yes,menubar=yes,toolbar=yes,scrollbars=yes,status=yes,resizable=yes,width=500,height=350')"><%= langText.get("Configure Users") %></a></li>        
<%
    }
%>
    <li>&nbsp;--------</li>  <!-- addition of a single line in mysite submenu  target="MyFrame"-->
    
<%
    Site site = null;
    boolean selfPageFlag = false;
    while (favSitesItr.hasNext()) 
    { 
        site = (Site)favSitesItr.next();
    
        String linkDesc=site.getSiteName();
        
        if(linkDesc == null)
            linkDesc = "";
%>      
        <li>&nbsp;
<%
        String linkValue = null;
        if(site.getSiteURI() == null)
            linkValue = "";
        else
            linkValue=(String)site.getSiteURI();
        
        if(linkValue.startsWith("ext_http"))
        {
            linkValue = linkValue.replace("ext_http","http");
        }
        else
        {
            if (linkValue.indexOf("http") == -1) 
            {
                if (!linkValue.startsWith("/")) 
                {
                    linkValue = "http://" + linkValue;
                }
                else
                {
                    linkValue = basePath+linkValue;
                    linkValue = linkValue.replace("/content/","/");
                }
            }
        }
        for(int i = 0 ; i < domainNames.length ; i++)
        {
            if(linkValue.indexOf(domainNames[i].trim()) != -1)
            {
                selfPageFlag = true;
                break;
            }
        }
        if(selfPageFlag)
        {
%>
            <a href="#" onclick="javascript:window.open('<%= linkValue %>', '_self', 'location=yes,menubar=yes,resizable=yes,toolbar=yes,scrollbars=yes,status=yes,width=800,height=600')">
                <%= linkDesc %>
            </a>
<%        
        }
        else
        {
%>
            <a href="#" onclick="javascript:window.open('<%= linkValue %>', '', 'location=yes,menubar=yes,resizable=yes,toolbar=yes,scrollbars=yes,status=yes,width=800,height=600')">
                <%= linkDesc %>
            </a>
<%        
        }
%>         
    </li>
<%
        selfPageFlag = false;
    } //end of while
%>
<li>&nbsp;</li>