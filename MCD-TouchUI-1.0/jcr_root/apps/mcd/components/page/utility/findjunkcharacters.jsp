<%--
*
* Find Junk Characters in Rich Text Fields
* which contributes to stop script error
* 
* 5/22/2014 ECW  
*
--%>
<HTML>
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page session="false" %>
<%@ page import="java.util.*,
           javax.jcr.Session, 
           javax.jcr.*,
           org.apache.sling.api.resource.*,
           org.apache.commons.lang.StringEscapeUtils,
           org.apache.jackrabbit.util.Text"%> 
<%@ page import="javax.jcr.*,java.io.IOException, java.text.DecimalFormat, java.io.*"%>
<%   
        response.setHeader("Cache-Control","no-cache");
        response.setHeader("Cache-Control","no-store");
        response.setDateHeader("Expires", 0);
        response.setHeader("Pragma","no-cache");
%>

<%@include file="/libs/wcm/global.jsp" %>
<head>
<title>Find Junk Characters Utility</title>

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

<script language='javascript'>
function openInCRXDE(path){
window.open("/crx/de/#/crx.default/jcr%3aroot"+escape(path));
}
</script>
</head>

<body>

<%!

int count = 0;

public static String findJunkCharacters(JspWriter out, ResourceResolver resourceResolver,String path,String tofind){ 

      String ret="";
      StringBuffer outBuffer=new StringBuffer();
      try{
      
        String query="/jcr:root"+path+"//*[ @sling:resourceType='mcd/components/content/everything']";
    
        Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
        //out.write(query+"test");
        int count=0; 
        
        while(result.hasNext()) { 
                //if(count>100)break;      
                  count++;
                    Resource r=(Resource)result.next();
                    javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
                    if (n != null) {
                        path = n.getPath();
                        if(n.hasProperty("text")){
                                String text =n.getProperty("text").getString();
                                if(text.contains(tofind)){
                                   
                                    String escapedToFind=StringEscapeUtils.escapeHtml(tofind);
                                    String escapedtext=StringEscapeUtils.escapeHtml(text);
                                    String highlightedtext=escapedtext.replace(escapedToFind,"<mark>"+escapedToFind+"</mark>");
                                    outBuffer= new StringBuffer("");
                                    outBuffer.append("<tr>");
                                    outBuffer.append("<td>" + count+"</td>");
                                    outBuffer.append("<td><a href=\"javascript:openInCRXDE('"+path+"')\">" + path+"</a></td>");
                                    outBuffer.append("<td>" + highlightedtext+ "</td>");                   
                                    outBuffer.append("</tr>"); 
                                    out.write(outBuffer.toString());
                                }
                       }
                       
                    }
            }
         
      }catch(Exception e){
          ret+="Exception:"+e.getMessage()+"<br>";
      }
     
      return ret;
  }

public void scanContentTree (JspWriter out, Page rootPage,int depth, Node currentNode, Session jcrSession, String parentTitle){
    StringBuffer outBuffer = new StringBuffer("");
    String currentCUG="";
    
    if (depth>0 && rootPage != null) {
        Iterator<Page> children = rootPage.listChildren();        
        int childcount=0;
        
            while (children.hasNext()) {
              try {
                Page child = children.next(); 
                
                childcount++;

                String pathtoinclude=child.getPath();

                /*
                String lastReplicationAction = child.getProperties().get("cq:lastReplicationAction","Deactivate");
                
                String authorName = rootPage.getProperties().get("authorName","");
                String authorEmail = child.getProperties().get("authorEmail","");
                String lastModified = child.getProperties().get("cq:lastModified","");
                String lastActivated = child.getProperties().get("cq:lastReplicated",""); 
                */
                String pageurl="https://www.accessmcd.com/"+pathtoinclude.substring(9)+".html";
        

//                if("Activate".equals(lastReplicationAction) && (null != oldCug && (!("").equals(oldCug )))) { 
//                if("Activate".equals(lastReplicationAction) && (null != oldCug && (!("").equals(oldCug )&&(oldCug.indexOf("DEFAULT-Owner_Operator")>-1||oldCug.indexOf("DEFAULT-Suppliers_Vendors")>-1)))) {

//                if((null != oldCug && (!("").equals(oldCug )&&(oldCug.indexOf("DEFAULT-Owner_Operator")>-1||oldCug.indexOf("DEFAULT-Suppliers_Vendors")>-1)))) {
                    outBuffer= new StringBuffer("");
                    outBuffer.append("<tr>");
                    outBuffer.append("<td>" + depth +"."+childcount+"</td>");
                    outBuffer.append("<td><a href=\""+pageurl+"\">"+pageurl+"</a></td>");
                    outBuffer.append("<td>"+parentTitle+" &gt; "+child.getTitle()+"</td>");
                   // outBuffer.append("<td>"+authorName +"</td>");
                  //  outBuffer.append("<td>"+authorEmail +"</td>");
                   // outBuffer.append("<td>"+ lastModified  +"</td>");
                   // outBuffer.append("<td>"+ lastActivated +"</td>"); 
                   outBuffer.append("<td>" + currentCUG + "</td>");                   
                    outBuffer.append("</tr>"); 
//                }


                out.println(outBuffer.toString());
                scanContentTree(out, child,depth-1, currentNode,jcrSession,parentTitle+" &gt; "+child.getTitle());
            
           } catch(Exception e) {outBuffer.append("<tr><td colspan=4>Exception</tr>");} 
        }
    }
    return ;
}




%>
<%
String path = (String) request.getParameter("rootPath");
if (path == null){ path = "";}
String tofind= (String) request.getParameter("tofind");
if (tofind== null){ tofind= "enter string to find";}
//if (path.equals("/content") || path.equals("")) {path = Text.getAbsoluteParent(currentPage.getPath(), 1);}

%>

<form action="#">
    <input type="hidden" name="hidAction" value="Clear"/>
    <h3>Find Junk Characters Utility</h3>
    <p style="margin-top:-16px;">
       &nbsp;&nbsp;&nbsp; 
    </p>
    <hr style="margin-top:-8px;">
    <br><b>
    &nbsp;&nbsp;&nbsp;Enter Root &nbsp;:&nbsp;&nbsp;</b>
    <input type="text" size=100 name="rootPath" id="rootpath" value="<%=path%>"></input>
    <br>
    <br><b>
    &nbsp;&nbsp;&nbsp;Characters to find &nbsp;:&nbsp;&nbsp;</b>
    <input type="text" size=100 name="tofind" id="rootpath" value="<%=tofind%>"></input>
    <br><br>
    <br><b>

    <br><br>    <input type="submit" onclick="this.form.hidAction.value='ReportOnly';" value="Junk Characters Report" />
    <!--input type="submit" onclick="this.form.hidAction.value='ShowInfo';" value="CUG Update" /-->
    <!--input type="submit" onclick="this.form.hidAction.value='clear';" value="Clear" /-->
    <br><br>
</form>
<%  
    String hidAction = (String) request.getParameter("hidAction");
    count = 0;

    
%>
        <div class="text">    
<%      
              
        
        if(path!= "") {
           Page rootPage = slingRequest.getResourceResolver().adaptTo(PageManager.class).getPage(path);  
           
           out.println("<br>Pages </b> under <b>"+path+"</b> containing junk characters -<br><br>");
                    
%>
            <table class="pagetable">
            <tr>
                <th>S.No</th>
                <th>Component</th>
                <th>Text</th>

            </tr>
<%         
           
            try {            
                Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
                
                findJunkCharacters(out, slingRequest.getResourceResolver(),path,tofind);
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
      
%>    

</body>
</HTML>