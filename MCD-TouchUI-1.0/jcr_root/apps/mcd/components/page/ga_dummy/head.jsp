<%--
  ==============================================================================
  Draws the HTML head with some default content:
  - initialization of the WCM
  - includes the current design CSS
  - sets the HTML title
  
  ==============================================================================
--%>
<%@page import="com.day.crx.*,com.day.cq.security.*,java.util.*,com.day.cq.tagging.*" %>

<%@include file="/apps/mcd/global/global.jsp" %><%
%><%@ page import="com.day.cq.commons.Doctype" %>

<%
    String xs = Doctype.isXHTML(request) ? "/" : "";
%><head>  

    <meta http-equiv="content-type" content="text/html; charset=UTF-8"<%=xs%>>
    <meta http-equiv="keywords" content="<%= WCMUtils.getKeywords(currentPage) %>"<%=xs%>>
    
    <cq:include script="/apps/mcd/global/init.jsp"/>
    <cq:include script="stats.jsp"/>
    
    <%-- Including Design Page static.css --%>
        <% currentDesign.writeCssIncludes(pageContext); %>   
        
    <%-- js file required for GA components --%>  
        <script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script> 
        <script type="text/javascript" src="/scripts/jquery.activetextinput.js"></script>
        <script type="text/javascript" src="/scripts/global_utils.js"></script>
        <script type="text/javascript" src="/scripts/jquery.colorbox-mod.js"></script>
        <script type="text/javascript" src="/scripts/jquery.mcdcolorbox.js"></script>
        <script type="text/javascript" src="/scripts/jquery-ui-1.7.2.custom.min.js"></script>
        <script type="text/javascript" src="/scripts/jquery.ifixpng.js"></script>  
        <script type="text/javascript" src="/scripts/swfobject.js"></script> 
        <script type="text/javascript" src="/scripts/common_ga.js"></script>
        
    <%-- GA components styles --%>  
        <link rel="stylesheet" type="text/css" media="screen" href="/css/jquery.mcdcolorbox.css" />
        <link rel="stylesheet" type="text/css" media="all" href="/css/mcdonalds.css" />
        <!--[if IE 7]>
            <link rel="stylesheet" type="text/css" media="all" href="/css/ie7.css" />
        <![endif]-->
        <!--[if IE 6]>
            <link rel="stylesheet" type="text/css" media="all" href="/css/ie6.css" />
        <![endif]-->

    <title><%= currentPage.getTitle() == null ? currentPage.getName() : currentPage.getTitle() %></title>
</head> 