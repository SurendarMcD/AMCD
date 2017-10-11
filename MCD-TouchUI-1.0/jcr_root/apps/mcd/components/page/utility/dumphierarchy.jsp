<%--
  ==============================================================================
  Dumps the content hierarchy
  
  Erik Wannebo 5/19/2010
  ==============================================================================
--%>
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page session="false" %>
<%@ page import="java.util.*, 
                java.net.*,
                java.io.*,
                javax.jcr.*" 
                %>
<html>
<head>
<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
 %>   
<title>Node Hierarchy</title>
<style>
a   {
    font-weight: normal; 
    color: #0000ff; 
    font-family: Verdana, Arial, Helvetica, sans-serif; 
    text-decoration: none;
    }
    
a:visited 
    {
    color: #0000ff;
    }

a:hover 
    {
    color: #333366;
    }
    
body {
    background-color: #ffffff;
    margin: 0px 0px 0px 0px;
    margin-bottom: 0px;
    margin-left: 0px;
    margin-right: 0px;
    margin-top: 0px;
    padding-bottom: 0px;
    padding-left: 0px;
    padding-right: 0px;
    padding-top: 0px;
    }
</style>

</head>
<body >
 
        
<%!           
    public String bold(String val){
        return "<B>"+val+"</B>";
    }

    public String tr(String val){
        return "<TR>"+val+"</TR>";
    }
    
    public String td(String val){
        return "<TD>"+val+"</TD>";
    }
    
    public String tag(String tg,String val){
        return "<"+tg+">"+val+"</"+tg+">";
   }
    
    public String getHierarchy(Node node,int level,int maxlevel){
        String BR="<br>";
        String msg="";
        if(level>maxlevel)return "MAX DEPTH "+maxlevel+" EXCEEDED"+BR;
        try{
            msg+=node.getPath()+BR;
            NodeIterator niter=node.getNodes();
            while(niter.hasNext()){
                Node child=niter.nextNode();
                if(!child.getName().equals("jcr:content"))
                      msg+=getHierarchy(child,level+1,maxlevel);
            }
        }catch(Exception e){
            
        }
        return msg;
     }
    
%>
<% 
if(!slingRequest.getUserPrincipal().getName().equals("admin")){
    out.write("<b><font color=red>You need to login to use this page.</font></b><br>");
    out.write("<a href='/libs/wcm/auth/content/login.html?resource=/content/utility/utility.dumphierarchy.html'>LOGIN HERE</a>");
    return;
}
Session session = slingRequest.getResourceResolver().adaptTo(Session.class);
Node root=session.getRootNode();

String path=request.getParameter("path");
/*
if(path==null || path.equals("")){
    out.write("Please provide a path.");
    return;
}
*/
path="content";
path="etc/tags/default";
Node contentNode=root.getNode(path);
String msg=getHierarchy(contentNode,1,2);
out.write(msg);
%>


</body>

</html>
 