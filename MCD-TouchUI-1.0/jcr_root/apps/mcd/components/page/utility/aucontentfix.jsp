<%-- 
  ==============================================================================
  Script to update AU content for Flexi-Column changes
 
  Erik Wannebo 8/12/2010
  ==============================================================================
--%>
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page session="false" %>
<%@ page import="java.util.*, 
                java.net.*,
                java.io.*,
                javax.jcr.*,
                javax.jcr.security.*,
                java.security.Principal,
                com.day.cq.security.util.CqActions,
                org.apache.sling.api.*,
                org.apache.jackrabbit.api.*,
                org.apache.jackrabbit.api.security.*,
                org.apache.jackrabbit.api.security.user.*,
                com.day.cq.wcm.foundation.Paragraph,
                com.day.cq.wcm.foundation.ParagraphSystem
                "%>
<html>
<head>
<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
 %>   
<title>AU Content Fix</title>
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
   
  
  
    
    public String fixHierarchy(Session session, Node node,HttpServletRequest request,SlingHttpServletRequest slingRequest, int level,int maxlevel,boolean bUpdate){
        String BR="<br>";
        String msg="";
        try{
          if(level>maxlevel || node.getPath().equals("/home"))return "";
           msg+="<tr><td valign=top>"+node.getPath()+"</td>";
           
            Resource resPage=slingRequest.getResourceResolver().getResource(node.getPath()+"/jcr:content/contentpar");
            ParagraphSystem parSys = new ParagraphSystem(resPage, request.getParameter("cq_diffTo"));
            for (Paragraph par: parSys.paragraphs()) {
              String nodeName =   par.getPath().substring(par.getPath().lastIndexOf("/")+1);
              if(nodeName.toLowerCase().indexOf("colctrl")>-1) {
                  Node columnCntrlNode = slingRequest.getResourceResolver().getResource(par.getPath()).adaptTo(Node.class);
                  if(columnCntrlNode.hasProperty("backgroundColumnctrlValue")){
                      
                          //msg+="<td>"+columnCntrlNode.getProperty("backgroundColumnctrlValue").getValue().getString()+"</td>";
                          String oldcolors=columnCntrlNode.getProperty("backgroundColumnctrlValue").getValue().getString();
                          
                          String newcolors=oldcolors.replaceAll("yellow","sitecolor3");
                          newcolors=newcolors.replaceAll("darkgrey","sitecolor5");
                          newcolors=newcolors.replaceAll(",",":");
                          if(oldcolors.equals("No Color"))newcolors="sitecolor2"; // white
                          msg+="<td>"+oldcolors+" <font color=red>"+newcolors+"</font>";
                          String paddingTop="10";
                          String paddingBottom="10";
                          if(columnCntrlNode.hasProperty("paddingTop")){
                              paddingTop=columnCntrlNode.getProperty("paddingTop").getValue().getString();
                          }
                          //if(paddingTop.equals("10"))paddingTop="8";
                          if(columnCntrlNode.hasProperty("paddingBottom")){
                              paddingBottom=columnCntrlNode.getProperty("paddingBottom").getValue().getString();
                          }
                          
                          if(bUpdate){
                              //the old paddingTop,paddingBottom are really marginTop,marginBottom for the new flexicolumn
                              columnCntrlNode.setProperty("backgroundColumnctrl",newcolors);
                              if(!columnCntrlNode.hasProperty("marginTop")){
                                  columnCntrlNode.setProperty("marginTop",paddingTop);
                                  columnCntrlNode.setProperty("marginBottom",paddingBottom);
                              }
                              columnCntrlNode.setProperty("marginRight","0");
                              columnCntrlNode.setProperty("marginLeft","0");
                              columnCntrlNode.setProperty("paddingTop","11");
                              columnCntrlNode.setProperty("paddingBottom","11");
                              columnCntrlNode.setProperty("paddingRight","16");
                              columnCntrlNode.setProperty("paddingLeft","16");
                              columnCntrlNode.save();
                              msg+=" <font color=red><b>UPDATED</b></font>";
                          }
                          msg+="</td>";
                      }
              }
            }    
 
            msg+="</tr>";
            NodeIterator niter=node.getNodes();
            while(niter.hasNext()){
                Node child=niter.nextNode();
                if(!child.getName().equals("jcr:content"))
                      msg+=fixHierarchy(session,child,request,slingRequest,level+1,maxlevel,bUpdate);
            }

        }catch(Exception e){
            
        }
        return msg;
     }
     
     private String fixContent(Session session, HttpServletRequest request, SlingHttpServletRequest slingRequest, String url, int depth, boolean bUpdate)
     throws Exception {
        
        Node root=session.getRootNode();
        
        Node contentNode=null;
        contentNode=root.getNode(url);
      
        return fixHierarchy(session,contentNode,request,slingRequest,1,depth,bUpdate);
     }
    
%>
<% 
if(!slingRequest.getUserPrincipal().getName().equals("admin")){
    out.write("<b><font color=red>You need to login to use this page.</font></b><br>");
    out.write("<a href='/libs/wcm/auth/content/login.html?resource=/content/utility/utility.securityreport.html'>LOGIN HERE</a>");
    return;
}
//JackrabbitSession session=request.getNode().getSession();
Session session = slingRequest.getResourceResolver().adaptTo(Session.class);
if(session==null){
    out.write("null session");
    return;
}
Node root=session.getRootNode();
//ACLManager aclmgr=session.getACLManager();
//out.write("root:"+root.getName());

String path=request.getParameter("path");

boolean bUpdate=true;
String msg=""; 
msg+=fixContent(session, request, slingRequest, "content/accessmcd/apmea/au",10,bUpdate);
//msg+=fixContent(session, request, slingRequest,"content/accessmcd/apmea/au/IT_licensee",3,bUpdate);
//msg+=fixContent(session, request, slingRequest, "content/accessmcd/apmea/au/rmhc_au",2,bUpdate);
if(bUpdate)session.save();
out.write("<table border=1>"+msg+"</table>");

session.logout();
%>


</body>
 
</html> 
 
