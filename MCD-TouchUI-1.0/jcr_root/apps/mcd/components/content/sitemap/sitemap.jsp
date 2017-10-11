<%--
    Site Map Component  

  ==============================================================================

--%>
<%@ page import="com.day.cq.wcm.foundation.Sitemap,
        org.apache.jackrabbit.util.Text"%><%
%><%@include file="/apps/mcd/global/global.jsp"%><%

    String rootPath = properties.get("rootPath", "");
    if (rootPath.length() > 0) {
        if (rootPath.startsWith("path:")) {
            rootPath = rootPath.substring(5,rootPath.length());
        }
    } else {
        long absParent = currentStyle.get("absParent", 3L);
        rootPath = Text.getAbsoluteParent(currentPage.getPath(), (int) absParent);
    }
    
    String sitemapTitle = properties.get("jcr:title",String.class);
    if((!"".equals(sitemapTitle)) && (null!=sitemapTitle))
    {
        %>
        <div class="sitemaptitle">
           <%= sitemapTitle %>
        </div>
        <%
    }
    %><div><%
    Page rootPage = slingRequest.getResourceResolver().adaptTo(PageManager.class).getPage(rootPath);
    Sitemap stm = new Sitemap(rootPage);
    stm.draw(out);
    %>

</div>