<%--
  ==============================================================================
  Draws the HTML head with some default content:
  - initialization of the WCM
  - includes the current design CSS
  - sets the HTML title
  
  ==============================================================================
--%>
<%@page import="com.mcd.cq.util.search.SearchGroup,java.text.SimpleDateFormat,com.day.crx.*,com.day.cq.security.*,java.util.*,com.day.cq.tagging.*" %>

<%@include file="/apps/mcd/global/global.jsp" %><%
%><%@ page import="com.day.cq.commons.Doctype" %>


<%@ page import="com.day.cq.wcm.api.WCMMode" %>

<script language=javascript>var timingstart=new Date();</script>
<%
    String xs = Doctype.isXHTML(request) ? "/" : "";
%>



<head>


<%
//Judy added the following 
   String title = currentPage.getTitle();
   if (title==null  || title.equals("")){
       title = "No Title";
   }
       
   String metaDescription = currentPage.getDescription();
    if ((metaDescription == null) || metaDescription.equals("") ) {
        metaDescription = title;
    }

    String metaAuthor = currentPage.getLastModifiedBy();
    if ((metaAuthor == null) || metaAuthor.equals("") ) {
        metaAuthor = "[No Author Listed]";
    }
    
    String modDate="No Modified Date";
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    if (currentPage.getLastModified() != null) {
        modDate = sdf.format(currentPage.getLastModified().getTime());
    } 
    
    String metaGroups = getAllGroup(currentNode);
        
    String tmpGroup=com.mcd.cq.util.search.SearchGroup.searchGroup(metaGroups); 

    //also added the following meta info

%>  
    
<meta name="description" content="<%= metaDescription %>" />
<meta name="keywords" content="<%= WCMUtils.getKeywords(currentPage) %>" />
<meta name="author" content="<%= metaAuthor %>" />
<meta name="groupsType" content="<%= tmpGroup %>" />
<meta name="modified" content="<%= modDate %>" />
 
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"<%=xs%>>
    <meta http-equiv="keywords" content="<%= WCMUtils.getKeywords(currentPage) %>"<%=xs%>>
    
    <cq:include script="headlibs.jsp"/>
    <cq:include script="/apps/mcd/global/init.jsp"/>
    <cq:include script="sitecolors.jsp"/> 
    <cq:include script="stats.jsp"/>
    
    <% currentDesign.writeCssIncludes(pageContext); %>  
    
    <%-- Jquery Colorbox styles --%>  
    <link rel="stylesheet" type="text/css" media="screen" href="/css/jquery.mcdcolorbox.css" />
    
    <!--[if lte IE 7]>
        <link rel="stylesheet" type="text/css" media="screen" href="/css/mcdcolorbox_ie7.css" />
    <![endif]-->
    <%-- End of Jquery Colorbox styles --%>   
    <%-- Including OOB Scripts --%>    
    <%-- not needed, jquery-1.3.2 is sufficient script type="text/javascript" src="/apps/mcd/docroot/scripts/jquery-1.js"></script> --%>        
    
    <script type="text/javascript" src="/scripts/swfobject.js"></script>    
    <script type="text/javascript" src="/scripts/sling.js"></script> 
    
     
    <script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script> 
    <%-- Including Application Specific Scripts --%> 
    <script type="text/javascript" src="/scripts/common.js"></script> 
    <script type="text/javascript" src="/scripts/jquery.activetextinput.js"></script>
    <script type="text/javascript" src="/scripts/global_utils.js"></script>
    <script type="text/javascript" src="/scripts/jquery.colorbox-mod.js"></script>
    <script type="text/javascript" src="/scripts/jquery.mcdcolorbox.js"></script>
    <script type="text/javascript" src="/scripts/jquery-ui-1.7.2.custom.min.js"></script>
    <script type="text/javascript" src="/scripts/jquery.ifixpng.js"></script>  
    <script type="text/javascript" src="/scripts/DD_roundies_0.0.2a-min.js" ></script>
  
    <script type="text/javascript" src="/scripts/jquery.hoverIntent.js"></script> 
    <script type="text/javascript" src="/scripts/jquery.autocomplete.js" ></script>     
    <script type="text/javascript" src="/scripts/grayout.js"></script>
    
    <cq:includeClientLib css="accessmcd.components" />
    
     <%
    //for Calendar/Notice Board Date Picker - Author Only 
    if(WCMMode.fromRequest(request) != WCMMode.DISABLED)
    {
    %>
        <link rel="stylesheet" href="/css/datePicker.css" type="text/css" /> 
        <script type="text/javascript" src="/scripts/jdatepicker.js"></script>
    <%
    }
    %>
    <%-- js file required for calendar component --%> 
    <script type="text/javascript" src="/scripts/calendar.js"></script>
    
    <script language=javascript>
    $(window).ready(
    function(){        
        var timing=(new Date())-timingstart;
        var winlocation=window.location.href;
        var timingurl=winlocation.replace(".html",".timing.html?timing="+timing+"&source="+escape(winlocation));
        $.get(timingurl);
    });
   </script>
    <title><%= currentPage.getTitle() == null ? currentPage.getName() : currentPage.getTitle() %></title>
</head> 