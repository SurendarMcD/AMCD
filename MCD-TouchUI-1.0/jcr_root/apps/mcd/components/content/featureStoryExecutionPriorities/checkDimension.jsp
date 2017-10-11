<%-- Follow us component.
     Author : Nitin Sharma

 --%>
<%@include file="/apps/mcd/global/global.jsp"%>
<%
    response.setHeader("Cache-Control","no-cache");
    response.setHeader("Cache-Control","no-store");
    response.setDateHeader("Expires", 0);
    response.setHeader("Pragma","no-cache"); 
    String path = request.getParameter("path");
    int height = Integer.parseInt(request.getParameter("height"));
    int width = Integer.parseInt(request.getParameter("width"));
    long h,w,h1,w1;
    h=0;w=0;
    h1 = height;
    w1 = width;
    String isValid = "false";
        Node pageNode = resourceResolver.getResource(path+"/jcr:content/metadata").adaptTo(Node.class); 
       if(pageNode.hasProperty("tiff:ImageLength"))
       {
        w = Long.parseLong(pageNode.getProperty("tiff:ImageLength").getString());
       } 
       if(pageNode.hasProperty("tiff:ImageWidth"))
       {
        h = Long.parseLong(pageNode.getProperty("tiff:ImageWidth").getString());
       } 
     
    
    if(h1 == h && w1 == w) {                    // if the flag is true , the newly created node has been deleted
           isValid= "true";
    } 
%>
{"validity":[{"valid":"<%= isValid%>"}]} 
 