<HTML>
<%@ page import="java.util.Calendar,
        java.util.Locale,
        java.text.SimpleDateFormat,
        java.util.Iterator,
        org.apache.jackrabbit.util.Text"%>
<%@ page import="javax.jcr.*, java.util.HashMap, java.util.Iterator,java.io.IOException, java.text.DecimalFormat"%>
<%   
        response.setHeader("Cache-Control","no-cache");
        response.setHeader("Cache-Control","no-store");
        response.setDateHeader("Expires", 0);
        response.setHeader("Pragma","no-cache");
%>

<%@include file="/libs/wcm/global.jsp" %>
<head>
<title>Tree Size Utility</title>
 
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
    white-space:nowrap;
    font-size: 14px;
    border-width: 1px 1px 1px 1px;
    padding: 5px 5px 5px 5px;
    border-style: dotted dotted dotted dotted;
}
</style>
</head>

<body>
  
<%!
int count = 0;
String sizePropVal="";
String imgNodeToCount = "";
double d = 0.00;
public String drawChildTree (Page rootPage, Node currentNode, Float requiredSize){
    StringBuffer outBuffer = new StringBuffer("");
    if (rootPage != null) {
        // code to retirieve the child pages of the selected page in the itertor object
        Iterator<Page> children = rootPage.listChildren();       
        
        try {
            while (children.hasNext()) {
                Page child = children.next(); 
                String pathtoinclude=child.getPath();
                Node homes=(Node)currentNode.getSession().getItem(pathtoinclude);
                long pageSize = getPageSize((Node) homes);                
                
                //if(pageSize >1024*1024*requiredSize){  
                    outBuffer.append("<tr>");
                    outBuffer.append("<td>" + ++count +"</td>");
                    outBuffer.append("<td><div style=\"margin-left:15px;\"><img src=\"/images/bullets/bullet.gif\"/>&nbsp;&nbsp;"+pathtoinclude+"</td>");
                    outBuffer.append("<td>"+child.getTitle()+"</td>");
                    outBuffer.append("<td>" + toHuman(pageSize) + "</td>");                   
                    outBuffer.append("</tr>"); 
                //}                
                d += Double.valueOf(toHuman(pageSize)).doubleValue();
                outBuffer.append(drawChildTree(child,currentNode,requiredSize));
            }  
            System.out.println("********** Size of Tree ********** " + d);
        } catch(Exception e) {outBuffer.append("<tr><td colspan=4>Exception</tr>");} 
        
    }
    // return the html code as string //
    return outBuffer.toString();
}

public void traverse(Node parent, HashMap accounts, String accountname) throws Exception {
           
            if (accountname!=null) {
                if (!accounts.containsKey(accountname)) {
                    HashMap counter=new HashMap();
                    counter.put("size", 0L);
                    accounts.put(accountname, counter);
                }
            }
            
            NodeIterator nodes=parent.getNodes();
            
            while (nodes.hasNext()) {
                
                Node node=nodes.nextNode();
                if(node.getName().indexOf("graphicalmenu") > -1){
                    //System.out.println("It is graphicalmenu");
                    if(node.hasProperty("size")){
                    sizePropVal = node.getProperty("size").getString();
                   // System.out.println("size is : " + sizePropVal  );
                    imgNodeToCount = "image" + sizePropVal;
                    imgNodeToCount = imgNodeToCount.trim();
                    }
                }                
                //System.out.println("Current Node is: " + node.getName() );              
                String actn=accountname;
               
                if (actn==null){ 
                    actn=node.getName();
                }
                if(actn.equals("jcr:content")){
                    //System.out.println("Node now is: " + node.getName());
                    //System.out.println("actn: " + actn);
                    
                    if( (node.getParent().getName().indexOf("graphicalmenu") > -1) && !(node.getName().equals(imgNodeToCount)) ){
                        //System.out.println("Skipping node: " + node.getName());
                        continue;
                    }else{
                        traverse(node, accounts, actn);
                    }
                } else {
                    continue;
                }
            }
            
            PropertyIterator props=parent.getProperties();

            while (props.hasNext()) {
                Property prop=props.nextProperty();
                if (prop.getDefinition().isMultiple()) {
                } else {
                    if (accountname!=null) {
                        HashMap counter=(HashMap)accounts.get(accountname);
                        counter.put("size", ((Long)counter.get("size"))+prop.getLength());                        
                }                
            } 
        }
  }

public String toHuman(long num) {
        double k=1024.0;
        double m=1024.0*k;
        double g=1024.0*m;
        
        DecimalFormat df = new DecimalFormat("#.################");
        String hsize=Long.toString(num);
        
        hsize = df.format(num/m);
        
        /*if (num>g) {
            hsize=df.format(num/g)+"GB";
        } else
        if (num>m) {
            hsize=df.format(num/m)+"MB";
        } else 
        if (num>k) {
            hsize=df.format(num/k)+"KB";
        } else {
            hsize=hsize+" bytes";
        }*/
        
       
        return hsize;
}

public long getPageSize(Node homes) throws Exception {
    
    HashMap accounts=new HashMap();
    traverse(homes, accounts, null);

    Iterator keys=accounts.keySet().iterator();
    long size=0L;
    while (keys.hasNext()) {
        String a=(String) keys.next();
        HashMap counter=(HashMap) accounts.get(a);
        size=(Long) counter.get("size");
    }
    return size;
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
       &nbsp;&nbsp;&nbsp; List content pages with content size under a particular Root
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
    
    String requiredSizeVal="1";  // for default 
    Resource res= slingRequest.getResourceResolver().getResource("/apps/cq/core/config/pageSize");
    try {
        if(null!=res) {
        Node pageSize=res.adaptTo(Node.class);
        requiredSizeVal=pageSize.getProperty("pagemaxsize").getValue().getString();
        }
    } catch(Exception e){}
    Float requiredSize = Float.parseFloat(requiredSizeVal);
%>
        <div class="text">    
<%      
        Page rootPage = slingRequest.getResourceResolver().adaptTo(PageManager.class).getPage(rootPath);        
        
        if(rootPage != null) {
            out.println("<br>Pages with content size more than <b>" + requiredSizeVal + "MB</b> under <b>"+rootPath+"</b> are -<br><br>");
                    
%>
            <table class="pagetable">
            <tr>
                <th>S.No</th>
                <th>Page Handle</th>
                <th>Page Title</th>
                <th>Page Size</th>            
            </tr>
<% 
            
           Node homes=(Node)currentNode.getSession().getItem(rootPath);
           
             System.out.println("RootPath is: " + rootPath); //added now
           long pageSize = getPageSize((Node) homes);                
           //System.out.println("The size now is: " + toHuman(pageSize)  );        
                
           //if(pageSize >1024*1024*requiredSize){       
               String title = rootPage.getTitle();  
               out.print("<tr>");
               out.print("<td>" + ++count +"</td>");
               out.print("<td><div style=\"margin-left:15px;\"><img src=\"/images/bullets/bullet.gif\"/>&nbsp;&nbsp;"+rootPath+"</td>");
               out.print("<td>"+title+"</td>");
               out.print("<td>" + toHuman(pageSize) + "</td>");                   
               out.print("</tr>"); 
           //}
        
           out.println(drawChildTree(rootPage,currentNode,requiredSize));
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