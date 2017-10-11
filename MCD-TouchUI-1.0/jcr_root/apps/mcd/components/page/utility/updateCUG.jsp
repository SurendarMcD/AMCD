<%--
*
* Update CUG 
* 
* 7/27/2012 Judy Zhang
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
<title>CUG Update Utility</title>

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

   public String getCUG(Page rootPage)
{
String parentProps = "";
boolean pageResult = rootPage.getProperties().containsKey("cq:cugPrincipals") && rootPage.getProperties().containsKey("cq:cugEnabled");

if(pageResult)
{
       String cugEnabled=rootPage.getProperties().get("cq:cugEnabled",String.class);
       if(cugEnabled.equals("true")){
           String[] parentProp= rootPage.getProperties().get("cq:cugPrincipals",String[].class);
           for(int i=0;i<parentProp.length;i++){
                parentProps+= parentProp[i];
                if(parentProp.length!=i+1){
                       parentProps += ",";
                    }
           }      
      }else{
          parentProps+=getCUG(rootPage.getParent());
      }
}else{

parentProps+=getCUG(rootPage.getParent());}
return parentProps;
} 




   public String setCUG(Session jcrSession,String handle,String cugString){
        StringBuffer temp = new StringBuffer();
        try{
            
             javax.jcr.Node nd = jcrSession.getRootNode();
            int first = handle.indexOf("/content/");
            String jcrPath=handle.substring(first+1)+"/jcr:content";
            Node jcrNode = nd.getNode(jcrPath);
            
            if (jcrNode == null) 
            {
                System.out.println("Node not found for CUG info.");
                return "";
            }

//test only, need to comment out later, Judy
//            if (handle.indexOf("accessmcd/cug_testing")>0){
              if (jcrNode.hasProperty("cq:cugPrincipals") && jcrNode.getProperty("cq:cugPrincipals")!=null)
              {

                        try {
                                    Property pp = jcrNode.getProperty("cq:cugPrincipals");
                                    String[] fields = cugString.split("\\|"); 
//                System.out.println(" node path  ::"+ jcrNode.getPath());
                                    if( pp.isMultiple())
                                    {
                                        jcrNode.setProperty("cq:cugPrincipals", fields);
                                        jcrSession.save();
                                    }else{
                                        pp.remove();
                                        jcrNode.setProperty("cq:cugPrincipals", fields);
                                        jcrSession.save();
                                    }
                                                         
                        }catch (Exception e ){
                                    System.out.println("set cugs exception :: "+ e);
                        
                        }
                    
               }
//             }         //end test


        }catch(Exception e){e.printStackTrace();}

            
        return temp.toString();
        }
        
%>

<%!

int count = 0;

public String drawChildTree (Page rootPage, Node currentNode, Session jcrSession){
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
                String oldCug = getCUG(rootPage);
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
                    
                    
                    setCUG(jcrSession,pathtoinclude,newCug);
                
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
                }//end if oldcug
        
                outBuffer.append(drawChildTree(child,currentNode,jcrSession));
            }
        } catch(Exception e) {outBuffer.append("<tr><td colspan=4>Exception</tr>");} 
        
    }
    return outBuffer.toString();
}

public String scanChildTree (Page rootPage, Node currentNode, Session jcrSession){
    StringBuffer outBuffer = new StringBuffer("");
    if (rootPage != null) {
        Iterator<Page> children = rootPage.listChildren();        
        try {
            while (children.hasNext()) {
                Page child = children.next(); 
                String pathtoinclude=child.getPath();
                String oldCug = getCUG(rootPage);
                String lastReplicationAction = child.getProperties().get("cq:lastReplicationAction","Deactivate");
                
                String authorEmail = child.getProperties().get("authorEmail","");
                String lastModified = child.getProperties().get("cq:lastModified","");
                String lastActivated = child.getProperties().get("cq:lastReplicated",""); 

//System.out.println("pathtoinclude ::"+pathtoinclude);                
//System.out.println("oldCug ::"+oldCug );                
//System.out.println("lastReplicationAction ::"+lastReplicationAction );                

//                if("Activate".equals(lastReplicationAction) && (null != oldCug && (!("").equals(oldCug )))) { 
//                if("Activate".equals(lastReplicationAction) && (null != oldCug && (!("").equals(oldCug )&&(oldCug.indexOf("DEFAULT-Owner_Operator")>-1||oldCug.indexOf("DEFAULT-Suppliers_Vendors")>-1)))) {

//                if((null != oldCug && (!("").equals(oldCug )&&(oldCug.indexOf("DEFAULT-Owner_Operator")>-1||oldCug.indexOf("DEFAULT-Suppliers_Vendors")>-1)))) {
                   
                    
                    
                    outBuffer.append("<tr>");
                    outBuffer.append("<td>" + ++count +"</td>");
                    outBuffer.append("<td><div class=\"tableHandle\">"+pathtoinclude+"</td>");
//                    outBuffer.append("<td>"+child.getTitle()+"</td>");
                    outBuffer.append("<td>"+authorEmail +"</td>");
                    outBuffer.append("<td>"+ lastModified  +"</td>");
                    outBuffer.append("<td>"+ lastActivated +"</td>"); 
                    outBuffer.append("<td>" + oldCug + "</td>");                   
                    outBuffer.append("</tr>"); 
//                }
        
                outBuffer.append(scanChildTree(child,currentNode,jcrSession));
            }
        } catch(Exception e) {outBuffer.append("<tr><td colspan=4>Exception</tr>");} 
        
    }
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
    <h3>Page CUG Update Utility</h3>
    <p style="margin-top:-16px;">
       &nbsp;&nbsp;&nbsp; Update CUG on all pages under a particular Root
    </p>
    <hr style="margin-top:-8px;">
    <br><b>
    &nbsp;&nbsp;&nbsp;Enter Root &nbsp;:&nbsp;&nbsp;</b>
    <input type="text" name="rootPath" id="rootpath" value="<%=path%>"></input>
    <br><br>
    <input type="submit" onclick="this.form.hidAction.value='ReportOnly';" value="CUG Report" />
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
                 out.println(drawChildTree(rootPage,currentNode, jcrSession ));
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
                <!-- th>Page Title</th -->
                <th>Author Email</th> 
                <th>Last Modified</th> 
                <th>Last Activated</th> 
                <th>CUG</th> 
            </tr>
<%         
           
            try {            
                Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);  
                out.println(scanChildTree(rootPage,currentNode, jcrSession ));
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