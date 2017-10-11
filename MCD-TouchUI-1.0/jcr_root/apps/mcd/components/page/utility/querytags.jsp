<%--
*
* Query Tags  
* 
* 7/27/2012 Judy Zhang
* 4/16/2013 JZ update
* 7/25/2013 ECW modify for Query Only version - add depth parameter
* 4/20/2015 ECW change to tag report
*
--%>
<HTML>
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page session="false" %>
<%@ page import="java.util.*,
           javax.jcr.Session, 
           org.apache.jackrabbit.util.Text"%> 
<%@ page import="javax.jcr.*,java.io.IOException, java.text.DecimalFormat, java.io.*,com.day.cq.tagging.*"%>
<%   
        response.setHeader("Cache-Control","no-cache");
        response.setHeader("Cache-Control","no-store");
        response.setDateHeader("Expires", 0);
        response.setHeader("Pragma","no-cache");
%>

<%@include file="/libs/wcm/global.jsp" %>
<head>
<title>Tag Query Utility</title>

<style type="text/css">
table.pagetable {
    border-width: 1px 1px 1px 1px;
    border-spacing: 0px;
    border-style: solid solid solid solid;
    border-color: black black black black;
    border-collapse: collapse;
}
table.pagetable th {
    font-weight:bold;
    border-width: 1px 1px 1px 1px;
    padding: 5px 5px 5px 5px;
    border-style: solid solid solid solid;
}
table.pagetable td {
    font-size: 14px;
    border-width: 1px 1px 1px 1px;
    padding: 5px 5px 5px 5px;
    border-style: dotted dotted dotted dotted;
}
table.pagetable div.tableHandle {
    margin-left: 5px;
    max-width: 300px;
    word-wrap: break-word;
}
</style>
</head>

<body>

<%!

   public String getTags(Page pg){
        StringBuffer temp = new StringBuffer();
        try{
            
            
            
            if (pg== null) 
            {
                System.out.println("Node not found for Tag info.");
                return "";
            }



            Tag[] tags=pg.getTags();
            for(int i=0;i<tags.length;i++){ 
                temp.append(tags[i].getTitle()+"<br>");
                    
            }
                     




        }catch(Exception e){e.printStackTrace();}

            
        return temp.toString();
        }

        
%>

<%!

int count = 0;



public void scanChildTree (JspWriter out, Page rootPage,int depth, Node currentNode, Session jcrSession, String parentTitle){
    StringBuffer outBuffer = new StringBuffer("");
    String currentTags="";
    
    if (depth>0 && rootPage != null) {
        Iterator<Page> children = rootPage.listChildren();        
        int childcount=0;
        
            while (children.hasNext()) {
              try {
                Page child = children.next(); 
                
                childcount++;

                String pathtoinclude=child.getPath();

                String pageurl="https://www.accessmcd.com/"+pathtoinclude.substring(9)+".html";
                currentTags= getTags(child);
                outBuffer= new StringBuffer("");
                outBuffer.append("<tr>");
                outBuffer.append("<td>" + depth +"."+childcount+"</td>");
                //outBuffer.append("<td><a href=\""+pageurl+"\">"+pageurl+"</a></td>");
                //outBuffer.append("<td>"+parentTitle+" &gt; "+child.getTitle()+"</td>");
                outBuffer.append("<td><a href=\""+pageurl+"\">"+parentTitle+" &gt; "+child.getTitle()+"</a></td>");
                outBuffer.append("<td>" + currentTags + "</td>");                   
                outBuffer.append("</tr>"); 

                out.println(outBuffer.toString());
                scanChildTree(out, child,depth-1, currentNode,jcrSession,parentTitle+" &gt; "+child.getTitle());
            
           } catch(Exception e) {outBuffer.append("<tr><td colspan=4>Exception</tr>");} 
        }
    }
    return ;
}


    //04/16/13 add current page, JZ
public String scanCurrentPage (JspWriter out, Page rootPage, Node currentNode, Session jcrSession){
    StringBuffer outBuffer = new StringBuffer("");

   try{    
        String pathtoinclude=rootPage.getPath();
        String currentTag= getTags(rootPage);
        
        String lastReplicationAction = rootPage.getProperties().get("cq:lastReplicationAction","Deactivate");
        
        String authorName = rootPage.getProperties().get("authorName","");
        String authorEmail = rootPage.getProperties().get("authorEmail","");
        String lastModified = rootPage.getProperties().get("cq:lastModified","");
        String lastActivated = rootPage.getProperties().get("cq:lastReplicated",""); 

            
        outBuffer.append("<tr>");
        outBuffer.append("<td> 0 </td>");
        //outBuffer.append("<td><div class=\"tableHandle\">"+pathtoinclude+"</td>");
        //outBuffer.append("<td>"+rootPage.getTitle()+"</td>");
        String pageurl="https://www.accessmcd.com/"+pathtoinclude.substring(9)+".html";
        outBuffer.append("<td><a href=\""+pageurl+"\">"+rootPage.getTitle()+"</a></td>");
        outBuffer.append("<td>" + currentTag + "</td>");                   
        outBuffer.append("</tr>"); 

        out.println(outBuffer.toString());
    
        } catch(Exception e) {outBuffer.append("<tr><td colspan=4>Exception</tr>");} 
    
    return "";
}
//end current page

%>
<%
String path = (String) request.getParameter("rootPath");
if (path == null){ path = "/content/accessmcd";}
if (path.equals("/content") || path.equals("")) {path = Text.getAbsoluteParent(currentPage.getPath(), 1);}

int depth=0;
String strDepth= (String) request.getParameter("depth");
if (strDepth!= null){ 
    try{
        depth= Integer.parseInt(strDepth);
    }catch(Exception e){
    }
}
%>

<form action="#">
    <input type="hidden" name="hidAction" value="Clear"/>
    <h3>Page CUG Query Utility</h3>
    <p style="margin-top:-16px;">
       &nbsp;&nbsp;&nbsp; Query CUG pages to a certain depth under a particular Root
    </p>
    <hr style="margin-top:-8px;">
    <br><b>
    &nbsp;&nbsp;&nbsp;Enter Root &nbsp;:&nbsp;&nbsp;</b>
    <input type="text" size=100 name="rootPath" id="rootpath" value="<%=path%>"></input>
    <br><br>
    <br><b>
    &nbsp;&nbsp;&nbsp;Enter Depth &nbsp;:&nbsp;&nbsp;</b>
    <input type="text" size=10 name="depth" id="depth" value="<%=depth%>"></input>
    <br><br><input type="submit" onclick="this.form.hidAction.value='ReportOnly';" value="Tag Report" />

    <br><br>
</form>
<%  
    String hidAction = (String) request.getParameter("hidAction");
    if(hidAction != null) 
    {
     
        count = 0;
        String rootPath = (String) request.getParameter("rootPath");
        
        if (rootPath.length() == 0 || rootPath.equals("/content")) {
            rootPath = Text.getAbsoluteParent(currentPage.getPath(), 1);
        }   
    
%>
        <div class="text">    
<%      
        Page rootPage = slingRequest.getResourceResolver().adaptTo(PageManager.class).getPage(rootPath);        
        
        if(rootPage != null) {
            out.println("<br>Pages </b> under <b>"+rootPath+"</b> are -<br><br>");
                    
%>
            <table class="pagetable">
            <tr>
                <th>S.No</th>
                <th>Page</th>

                <th>Tags</th> 
            </tr>
<%         
           
            try {            
                Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
                String currentCUG="";
                scanCurrentPage(out,rootPage,currentNode, jcrSession);  
                scanChildTree(out, rootPage,depth, currentNode, jcrSession,rootPage.getTitle());
            }
            catch(Exception e) {
                log.info("**************************** Exception in CUG reporting ******************************");
            } 
%>
        </table>  
        </div>    
<% 
       }
       else { out.println("<b>Invalid Path</b>"); }             
      } 
%>    

</body>
</HTML>