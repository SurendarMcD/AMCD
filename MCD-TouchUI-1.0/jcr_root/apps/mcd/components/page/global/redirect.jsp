<%@ page import="com.day.cq.wcm.foundation.ELEvaluator" %>
<%--
  Copyright 1997-2008 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Redirect content script.

  Displays the redirected url as link if present.

  ==============================================================================

--%><%@include file="/apps/mcd/global/global.jsp" %><%

    // try to resolve the redirect target in order to the the title
    String path = properties.get("redirectTarget", "");
    // resolve variables in path
    path = ELEvaluator.evaluate(path, slingRequest, pageContext);
    if (path.length() > 0) {
        Page target = pageManager.getPage(path);
        String title = target == null ? path : target.getTitle();
        // If condition added so that '.html/' is not added always
        if(path.startsWith("/content") && path.indexOf(".html")==-1)
            path = path + ".html";
        
        %><p>This page redirects to <a href="<%= path %>"><%= title %></a></p><%
    }
%> 