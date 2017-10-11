<%--
*
* Query CUG 
* 
* 7/27/2012 Judy Zhang
* 4/16/2013 JZ update
* 7/25/2013 ECW modify for Query Only version - add depth parameter
*
--%>
<HTML>
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page session="false" %>
<%@ page import="java.util.*,
           javax.jcr.Session, 
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
<title>CUG Query Utility</title>

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

   public String getCUG(Session jcrSession,String handle){
        StringBuffer temp = new StringBuffer();
        try{
            
             javax.jcr.Node nd = jcrSession.getRootNode();

//            String handle = currentNode.getPath();
            int first = handle.indexOf("/content/");

            String jcrPath=handle.substring(first+1)+"/jcr:content";
            
            Node jcrNode = nd.getNode(jcrPath);
            
            if (jcrNode == null) 
            {
                System.out.println("Node not found for CUG info.");
                return "";
            }


            // default values
//            String cugEnalbed="false";
//            if (jcrNode.hasProperty("cq:cugEnabled") && jcrNode.getProperty("cq:cugEnabled")!=null)
//                cugEnalbed=jcrNode.getProperty("cq:cugEnabled").getString();


            Value[] cugs=null;
//            if (cugEnalbed.equalsIgnoreCase("true")){
//                String cugPrinciples="";
                if (jcrNode.hasProperty("cq:cugPrincipals") && jcrNode.getProperty("cq:cugPrincipals")!=null)
                {

                        try {
                            cugs=jcrNode.getProperty("cq:cugPrincipals").getValues();
                            
                        }catch (ValueFormatException e){
                            cugs = new Value[1];
                            cugs[0] = jcrNode.getProperty("cq:cugPrincipals").getValue();
                        }
                    
                        for (int i=0; i<cugs.length ;i++ ){
                            temp.append(cugs[i].getString()+"|");
                        }
                }
                     
//            }

            //System.out.println("CUG principles :: " + temp);

        }catch(Exception e){e.printStackTrace();}

            
        return temp.toString();
        }

   public String setCUG(Session jcrSession,String handle,String cugString){
        
        return "";
        }
        
%>

<%!

int count = 0;

public String drawChildTree (JspWriter out, Page rootPage, Node currentNode, Session jcrSession, String currentCUG){
    StringBuffer outBuffer = new StringBuffer("");
    if (rootPage != null) {
        // code to retirieve the child pages of the selected page in the itertor object
        Iterator<Page> children = rootPage.listChildren();       
        try {
            while (children.hasNext()) {
                Page child = children.next(); 
                String pathtoinclude=child.getPath();
                //cq:cugEnabled, cq:cugPrincipals
//                String oldCug = child.getProperties().get("cq:cugPrincipals","");
                String oldCug = getCUG(jcrSession,pathtoinclude);
                String newCug = oldCug;
                if (oldCug!=null && (oldCug.indexOf("DEFAULT-Suppliers_Vendors")>-1 && oldCug.indexOf("default-agency")<0) )
                    newCug = newCug+"default-agency|";
//                if (oldCug!=null && (oldCug.indexOf("DEFAULT-Franchisee_Restaurant_Manager")>0 && oldCug.indexOf("default-franchisee_office_staff")<0) )
                if (oldCug!=null && (oldCug.indexOf("DEFAULT-Owner_Operator")>-1 && oldCug.indexOf("default-franchisee_office_staff")<0) )
                    newCug = newCug+"default-franchisee_office_staff|";
                String lastReplicationAction = child.getProperties().get("cq:lastReplicationAction","Deactivate");
                String authorEmail = child.getProperties().get("authorEmail","");
                String lastModified = child.getProperties().get("cq:lastModified","");
                String lastActivated = child.getProperties().get("cq:lastReplicated","");

//                if("Activate".equals(lastReplicationAction) && (null != oldCug && (!("").equals(oldCug )))) {
//                if("Activate".equals(lastReplicationAction) && (null != oldCug && (!("").equals(oldCug )&&(oldCug.indexOf("DEFAULT-Owner_Operator")>-1||oldCug.indexOf("DEFAULT-Suppliers_Vendors")>-1)))) {

                if( (null != oldCug && (!("").equals(oldCug )&&(oldCug.indexOf("DEFAULT-Owner_Operator")>-1||oldCug.indexOf("DEFAULT-Suppliers_Vendors")>-1)))) {
                    
                    
                    //setCUG(jcrSession,pathtoinclude,newCug);
                
                    outBuffer.append("<tr>");
                    outBuffer.append("<td>" + ++count +"</td>");
                    outBuffer.append("<td><div class=\"tableHandle\">"+pathtoinclude+"</td>");
//                    outBuffer.append("<td>"+child.getTitle()+"</td>");
                    outBuffer.append("<td>"+authorEmail +"</td>");
                    outBuffer.append("<td>"+ lastModified  +"</td>");
                    outBuffer.append("<td>"+ lastActivated +"</td>");
                    outBuffer.append("<td>" + oldCug + "</td>");                   
                    outBuffer.append("<td>" + newCug + "</td>");                   
                    outBuffer.append("</tr>");
                    out.println(outBuffer); 
                }//end if oldcug
        
                currentCUG=drawChildTree(out, child,currentNode,jcrSession, currentCUG);
            }
        } catch(Exception e) {outBuffer.append("<tr><td colspan=4>Exception</tr>");} 
        
    }
    
    return currentCUG;
}

public void scanChildTree (JspWriter out, Page rootPage,int depth, Node currentNode, Session jcrSession, String parentTitle, String parentCUG){
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
                //currentCUG=newCug+","+newCug.length()+"|"+parentCUG+","+parentCUG.length();
                /*
                String lastReplicationAction = child.getProperties().get("cq:lastReplicationAction","Deactivate");
                
                String authorName = rootPage.getProperties().get("authorName","");
                String authorEmail = child.getProperties().get("authorEmail","");
                String lastModified = child.getProperties().get("cq:lastModified","");
                String lastActivated = child.getProperties().get("cq:lastReplicated",""); 
                */
                String pageurl="https://www.accessmcd.com/"+pathtoinclude.substring(9)+".html";
                String newCug = getCUG(jcrSession,pathtoinclude);
                String newCugHighlighted="";
                StringTokenizer st=new StringTokenizer(newCug,"|");
                while(st.hasMoreTokens()){
                    String token=(String)st.nextToken();
                    if(!token.toLowerCase().contains("default"))token="<font style='background-color:yellow'>"+token+"</font>";
                   
                    token=token.replace("DEFAULT-Employee","Emp");
                    token=token.replace("DEFAULT-Owner_Operator","OO");
                    token=token.replace("DEFAULT-Franchisee_Restaurant_Manager","FRM");
                    token=token.replace("DEFAULT-McOpCo_Restaurant_Manager","MRM");
                    token=token.replace("DEFAULT-Suppliers_Vendors","SV");
                    token=token.replace("DEFAULT-Crew","Crew");
                    token=token.replace("default-franchisee_office_staff","FOS");
                    token=token.replace("default-agency","Ag"); 
                    
                    newCugHighlighted+=token+"|";
                }
                if(!newCug.equals("")){
                    currentCUG=newCugHighlighted;
                }else{
                    currentCUG=parentCUG;
                }
                
//System.out.println("pathtoinclude ::"+pathtoinclude);                
//System.out.println("oldCug ::"+oldCug );                
//System.out.println("lastReplicationAction ::"+lastReplicationAction );                

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
                scanChildTree(out, child,depth-1, currentNode,jcrSession,parentTitle+" &gt; "+child.getTitle(),currentCUG);
            
           } catch(Exception e) {outBuffer.append("<tr><td colspan=4>Exception</tr>");} 
        }
    }
    return ;
}


    //04/16/13 add current page, JZ
public String scanCurrentPage (JspWriter out, Page rootPage, Node currentNode, Session jcrSession, String currentCUG){
    StringBuffer outBuffer = new StringBuffer("");

   try{    
                String pathtoinclude=rootPage.getPath();
                String newCug = getCUG(jcrSession,pathtoinclude);
                if(!newCug.equals(""))currentCUG=newCug;
                String lastReplicationAction = rootPage.getProperties().get("cq:lastReplicationAction","Deactivate");
                
                String authorName = rootPage.getProperties().get("authorName","");
                String authorEmail = rootPage.getProperties().get("authorEmail","");
                String lastModified = rootPage.getProperties().get("cq:lastModified","");
                String lastActivated = rootPage.getProperties().get("cq:lastReplicated",""); 

                    
                    outBuffer.append("<tr>");
                    outBuffer.append("<td> 0 </td>");
                    outBuffer.append("<td><div class=\"tableHandle\">"+pathtoinclude+"</td>");
                    outBuffer.append("<td>"+rootPage.getTitle()+"</td>");
                  //  outBuffer.append("<td>"+authorName +"</td>");
                  //  outBuffer.append("<td>"+authorEmail +"</td>");
                   // outBuffer.append("<td>"+ lastModified  +"</td>");
                    //outBuffer.append("<td>"+ lastActivated +"</td>"); 
                    outBuffer.append("<td>" + currentCUG + "</td>");                   
                    outBuffer.append("</tr>"); 

        out.println(outBuffer.toString());
    
        } catch(Exception e) {outBuffer.append("<tr><td colspan=4>Exception</tr>");} 
    
    return currentCUG;
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
    <br><br>    <input type="submit" onclick="this.form.hidAction.value='ReportOnly';" value="CUG Report" />
    <!--input type="submit" onclick="this.form.hidAction.value='ShowInfo';" value="CUG Update" /-->
    <!--input type="submit" onclick="this.form.hidAction.value='clear';" value="Clear" /-->
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
            out.println("<br>Pages </b> under <b>"+rootPath+"</b> are -<br><br>");
                    
%>
            <table class="pagetable">
            <tr>
                <th>S.No</th>
                <th>Page Handle</th>
                <!-- th>Page Title</th -->
                <th>Author email</th> 
                <th>Last Modified</th> 
                <th>Last Activated</th> 
                <th>old CUG</th> 
                <th>new CUG</th>           
            </tr>
<%         
           
            try {
                 Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);  
                 drawChildTree(out, rootPage,currentNode, jcrSession,"");
            }
            catch(Exception e) {
                log.info("****************************Exception in CUG updating******************************");
            } 
%>
        </table>  
        </div>    
<% 
       }
       else { out.println("<b>Invalid Path</b>"); }             
      } 
      else if(hidAction.equals("ReportOnly")) 
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
                <th>Page Handle</th>
                <th>Page Title</th>
                <!--
                <th>Author Name</th> 
                <th>Author Email</th> 
                <th>Last Modified</th> 
                <th>Last Activated</th> 
                -->
                <th>CUG</th> 
            </tr>
<%         
           
            try {            
                Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
                String currentCUG="";
                currentCUG=scanCurrentPage(out,rootPage,currentNode, jcrSession,"");  
                scanChildTree(out, rootPage,depth, currentNode, jcrSession,rootPage.getTitle(),currentCUG);
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


    }
%>    

</body>
</HTML>