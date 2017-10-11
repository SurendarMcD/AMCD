<%@page session="false" import="javax.jcr.*,
      com.day.cq.wcm.api.Page,
      com.day.cq.wcm.api.PageManager,
      org.apache.sling.api.resource.Resource,
      org.apache.sling.api.SlingHttpServletRequest,
      org.apache.sling.api.SlingHttpServletRequest,
      com.day.cq.wcm.commons.WCMUtils,
      com.day.cq.wcm.api.NameConstants,
      com.day.cq.wcm.api.designer.Designer,
      com.day.cq.wcm.api.designer.Design,
      com.day.cq.wcm.api.designer.Style,
      org.apache.sling.api.resource.ValueMap,
      com.day.cq.wcm.api.components.ComponentContext,
      com.day.cq.wcm.api.components.EditContext,
      com.mcd.util.PropertiesLoader,
      java.util.Properties,
      java.util.*, 
      java.net.*,
      java.io.*,
      com.mcd.bumper.BumperEncryption"
%>
<%
    //wei - dumpheaders
    out.println("wei's testing...<br>");
    
    SlingHttpServletRequest slingRequest = (SlingHttpServletRequest) request;
    Enumeration e = slingRequest.getHeaderNames();
    while (e.hasMoreElements()) {
        String name = (String)e.nextElement();
        String value = slingRequest.getHeader(name);
        out.println(name + " = " + value+"<br>");
    }
%>