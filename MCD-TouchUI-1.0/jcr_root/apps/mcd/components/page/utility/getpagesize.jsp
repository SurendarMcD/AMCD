<%@include file="/libs/wcm/global.jsp"%><%
%><%@ page import="javax.jcr.*,
                 java.util.HashMap, java.util.Iterator,java.io.IOException, java.text.DecimalFormat"%><%
%>
<%@ page import="java.util.ResourceBundle" %>
<%@ page import="java.util.Locale" %>

<%

       //Added by Rajat Chawla @ 7th Sept 2010
       
        response.setHeader("Cache-Control","no-cache");
        response.setHeader("Cache-Control","no-store");
        response.setDateHeader("Expires", 0);
        response.setHeader("Pragma","no-cache");

       // Rajat Coded Ended 

%><%!
String sizePropVal="";
String imgNodeToCount = "";
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
%><%!
public String toHuman(long num) {
        double k=1024.0;
        double m=1024.0*k;
        double g=1024.0*m;
        
        DecimalFormat df = new DecimalFormat("#.##");
        String hsize=Long.toString(num);
        
        if (num>g) {
            hsize=df.format(num/g)+"GB";
        } else
        if (num>m) {
            hsize=df.format(num/m)+"MB";
        } else 
        if (num>k) {
            hsize=df.format(num/k)+"KB";
        } else {
            hsize=hsize+" bytes";
        }
        
       
        return hsize;
}
%><%!
public long getPageSize(Node homes, JspWriter out) throws Exception {
    
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
%><%
//Node homes=(Node)currentNode.getSession().getItem("/content/accessmcd/apmea/au");
Page assetsPage = pageManager.getPage(request.getParameter("path"));

Node homes=(Node)currentNode.getSession().getItem(request.getParameter("path"));
//Node homes=(Node)currentNode.getSession().getItem("/content/geometrixx/en/toolbar/contacts/jcr:content");
 
long longSize = getPageSize((Node) homes, out);
if((assetsPage!=null) && assetsPage.getPath().startsWith("/content/accessmcd/assets_page"))
    longSize = 9961472;


String strPageSize = toHuman(longSize);

String validationPageSize = "";
// return empty string if size is less than 12.5MB

// chenges done by Rajat Chawla  // 
// For retireving the Max Page Size from a node //
String pageSizeVal="1";  // for default 

ResourceBundle bundle = slingRequest.getResourceBundle(request.getLocale());

Resource res= slingRequest.getResourceResolver().getResource("/apps/cq/core/config/pageSize");


if(null!=res)
{
Node pageSize=res.adaptTo(Node.class);
pageSizeVal=pageSize.getProperty("pagemaxsize").getValue().getString();
}





//  changed for dynamic page Size //
//if(longSize >1024*1024*12.5){

if(longSize > 1024*1024*Float.parseFloat(pageSizeVal)){
    //validationPageSize = strPageSize ; 
    // alert msg for the checking 
    
    validationPageSize = bundle.getString("PAGE_SIZE_ALERT1")+ pageSizeVal +bundle.getString("PAGE_SIZE_ALERT2"); 
}

%>
[{"pagesize":"<%=validationPageSize%>","disppagesize":"<%=strPageSize%>"}]