<HTML>
<%@ page import="java.util.Iterator,
        org.apache.jackrabbit.util.Text"%> 
<%@ page import="javax.jcr.*, java.util.HashMap, java.util.Iterator,java.io.IOException, java.text.DecimalFormat, java.io.*"%>
<%   
        response.setHeader("Cache-Control","no-cache");
        response.setHeader("Cache-Control","no-store");
        response.setDateHeader("Expires", 0);
        response.setHeader("Pragma","no-cache");
%>

<%@include file="/libs/wcm/global.jsp" %>
<head>
<title>Off Time Utility</title>

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
int count = 0;
public String drawChildTree (Page rootPage, Node currentNode, Writer output){
    StringBuffer outBuffer = new StringBuffer("");
    if (rootPage != null) {
        // code to retirieve the child pages of the selected page in the itertor object
        Iterator<Page> children = rootPage.listChildren();       
        try {
            while (children.hasNext()) {
                Page child = children.next(); 
                String pathtoinclude=child.getPath();
                String offTime = child.getProperties().get("offTime","");
                String lastReplicationAction = child.getProperties().get("cq:lastReplicationAction","Deactivate");

                if("Activate".equals(lastReplicationAction) && (null != offTime && (!("").equals(offTime)))) {
                    output.write(pathtoinclude + "=" + offTime + "\r"); 
                    outBuffer.append("<tr>");
                    outBuffer.append("<td>" + ++count +"</td>");
                    outBuffer.append("<td><div class=\"tableHandle\">"+pathtoinclude+"</td>");
                    outBuffer.append("<td>"+child.getTitle()+"</td>");
                    outBuffer.append("<td>" + offTime + "</td>");                   
                    outBuffer.append("</tr>"); 
                }
        
                outBuffer.append(drawChildTree(child,currentNode,output));
            }
        } catch(Exception e) {outBuffer.append("<tr><td colspan=4>Exception</tr>");} 
        
    }
    // return the html code as string //
    return outBuffer.toString();
}

%>
<%
String path = (String) request.getParameter("rootPath");
if (path == null){ path = "/content/accessmcd";}
if (path.equals("/content") || path.equals("")) {path = Text.getAbsoluteParent(currentPage.getPath(), 1);}
%>

<form action="#">
    <input type="hidden" name="hidAction" value="Clear"/>
    <h3>Page Size Utility</h3>
    <p style="margin-top:-16px;">
       &nbsp;&nbsp;&nbsp; List all pages with off time under a particular Root
    </p>
    <hr style="margin-top:-8px;">
    <br><b>
    &nbsp;&nbsp;&nbsp;Enter Root &nbsp;:&nbsp;&nbsp;</b>
    <input type="text" name="rootPath" id="rootpath" value="<%=path%>"></input>
    <br>
    <span><i style="font-size: 13px; padding-left: 10px;">DEFAULT : Absolute Parent at level 1</i></span>
    <br><br>
    <input type="submit" onclick="this.form.hidAction.value='ShowInfo';" value="ShowInfo" />
    <input type="submit" onclick="this.form.hidAction.value='clear';" value="Clear" />
    <br><br>
</form>
<%  
    String hidAction = (String) request.getParameter("hidAction");
    if(hidAction != null) 
    {
      if(hidAction.equals("ShowInfo")) 
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
            out.println("<br>Pages with off time </b> under <b>"+rootPath+"</b> are -<br><br>");
                    
%>
            <table class="pagetable">
            <tr>
                <th>S.No</th>
                <th>Page Handle</th>
                <th>Page Title</th>
                <th>Offtime</th>            
            </tr>
<%         
            Writer output = null;
            try {            
                File file = new File("/app/mcd/cms/fs05/wcm1_auth_prod/crx-quickstart/server/logs/offTimeScan.txt"); 
                output = new BufferedWriter(new FileWriter(file));
                out.println(drawChildTree(rootPage,currentNode, output));
            }
            catch(Exception e) {
                log.info("****************************Exception in creating file******************************");
            } finally {
                output.close();
            }
%>
        </table>  
        </div>    
<% 
       }
       else { out.println("<b>Invalid Path</b>"); }             
      } 
    }
%>    

</body>
</HTML>