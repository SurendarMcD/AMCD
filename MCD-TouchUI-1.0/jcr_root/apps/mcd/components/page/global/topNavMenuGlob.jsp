<%@ page import="com.day.cq.wcm.api.PageFilter,
            java.util.Iterator,
            com.mcd.accessmcd.util.CommonUtil"%><%
%><%@include file="/apps/mcd/global/global.jsp"%><%
%><%@page session="false" %><%
%><% 
    String rootPath = currentPage.getPath(); 
    String homeImagePath = currentDesign.getPath() + "/images/topnav_aunew_home.gif";
    // getting resource of top navigation menu bar for the view specific root page
    String redirectTarget = "";
    
    Resource topNavViewRes = slingRequest.getResourceResolver().getResource(currentPage.getPath()+"/jcr:content/menubarpara");
    // retrieving the listroot property from the view specific root page
    if(null != topNavViewRes){
        Node topNavViewNode = topNavViewRes.adaptTo(Node.class);
        rootPath = topNavViewNode.hasProperty("listroot")? topNavViewNode.getProperty("listroot").getString() : currentPage.getPath();
    }
    %>
        <ul id="navMenu">
            <li id="auNewHome">
                <a href="<%=currentPage.getPath()%>.html" ><img src="<%=homeImagePath%>" /></a>
            </li>
    <%
    if(null != rootPath){
        Page rootPage = pageManager.getPage(rootPath);
        
        if(rootPage != null) {
            // getting the child iterator from the root page for the main menu
            Iterator<Page> rootPageIter = rootPage.listChildren(new PageFilter(request));
            int count = 0;
            CommonUtil commonUtil = new CommonUtil();
            while(rootPageIter.hasNext()){
                Page childPage = (Page) rootPageIter.next();
                
                if(rootPageIter.hasNext()){
                %>
                <li>
                    <a href="#" ><span class="mainItemTextPosition"><%=commonUtil.getTitle(childPage)%></span></a>
                <%
                } else{
                %>
                <li id="lastmenuitem">
                    <a href="#" ><span class="mainItemTextPosition"><%=commonUtil.getTitle(childPage)%></span></a>
                <%
                }
                
                // getting the page iterator from child pages for the sub menus
                Iterator<Page> childPageIter = childPage.listChildren(new PageFilter(request));
                if(childPageIter.hasNext()){
                    %>
                        <ul>
                    <%
                    while(childPageIter.hasNext()){
                        Page subMenuPage = (Page) childPageIter.next();
                        Node subMenuNode = slingRequest.getResourceResolver().getResource(subMenuPage.getPath()+"/jcr:content").adaptTo(Node.class);
                        redirectTarget = subMenuPage.getProperties().get("redirectTarget",subMenuPage.getPath());
                        redirectTarget = redirectTarget.startsWith("/content")? redirectTarget.replaceAll("/content/","/") + ".html" : redirectTarget;
                        %>
                        <li>
                            <%-- calling the javascript function for menu reporting & opening the page in the same frame or in new window --%>
                            <a href="javascript:menuGoTo('<%=redirectTarget%>','<%= subMenuPage.getProperties().get("launchType","_self")%>','A','0','<%= subMenuNode.getIdentifier() %>');">
                            <span class="subItemTextPosition"><%= commonUtil.getTitle(subMenuPage) %></span>
                            </a>
                        </li>
                        <%
                    }
                    %>
                        </ul>
                    <% 
                }
                %>
                </li>
                <%
                count++;
            }
        }
    }
%>
    </ul>