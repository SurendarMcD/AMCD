<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page import="java.util.ArrayList,
        java.util.Iterator,
        java.util.Date,
        com.day.cq.wcm.api.PageFilter,
       javax.jcr.Binary,javax.jcr.Node,javax.jcr.NodeIterator,javax.jcr.Session,org.apache.sling.jcr.api.SlingRepository,
     org.apache.sling.api.scripting.SlingScriptHelper,
        com.day.cq.security.User,
        com.mcd.accessmcd.util.CommonUtil"%>
<%





//String path=currentPage.getPath();
 
//String path=request.getParameter("basepath");
String path="/content/dam/accessmcd";
String property=request.getParameter("property");
String filename="report";
if(path.contains("/"))
{
    filename=filename+path.replaceAll("/","_")+"_"+property;
}

    response.reset();
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-type","application/xls");
    response.setHeader("Content-disposition","inline; filename="+filename+".xls");
String [] a=new String[5000];

int k=0;
int pageinlevel=0;
Node globalPage= slingRequest.getResourceResolver().getResource(path).adaptTo(Node.class);

int dep=globalPage.getDepth();
  
  
   NodeIterator myChildren0 = globalPage.getNodes();  

     while(myChildren0.hasNext()){
        Node child =  (Node) myChildren0.next();
        a[k++]=child.getPath();
  
    }

pageinlevel=k;
int start=0;
for(int n=1;n<=dep;n++)
{   int pages=0;
    
    
   // out.println("start.............."+start+"Pagein level "+pageinlevel+"<br>");
    for(int m=start;m<start+pageinlevel;m++)
    {
    globalPage=slingRequest.getResourceResolver().getResource(a[m]).adaptTo(Node.class);
            
        NodeIterator myChildren = globalPage.getNodes();  
    
         while(myChildren.hasNext()){
            Node child =  (Node) myChildren.next();
           
            a[k++]=child.getPath();
            pages++;
           //out.println(m+".............."+child.getPath()+"<br>");  

               
         }
      
    } 
    start=k-pages;    pageinlevel=pages;
   
}



             Session session=null;
             
              SlingRepository repos=null;

              repos= sling.getService(SlingRepository.class); 
 
              session=repos.loginAdministrative(null); 

  %>
  
 <b>Checking base path <font color="red"><%=path%></font> for <font color="red"><%=property%></font> Property</b><br>
<table border=1>
<tr backgroundcolor="yellow"><td width="10%">S.No</td><td width="40%">path</td><td><%=property%> value</td></tr>
 <%           
String propValue="";int l=0;String[] specialChar={"*","/","[","]","!","|","&",":"};
for(int m=0;m<a.length;m++)
{
  propValue = "Not defined."; 
if(a[m]!=null)
{
  
  
 
  if(slingRequest.getResourceResolver().getResource(a[m])!=null)
  {                   
 Node pageNode = slingRequest.getResourceResolver().getResource(a[m]).adaptTo(Node.class);
           
 //if(pageNode.hasProperty(property)){
                        //propValue = pageNode.getProperty(property).getString(); 
                        propValue=pageNode.getName();
                        for(int i=0;i<specialChar.length;i++){ 
                        if(propValue.contains(specialChar[i]) && !((propValue.contains("jcr:content")) || (propValue.contains("rep:policy"))))
                        {
                          out.println("<tr><td width='10%'>"+(m+1)+"</td><td width='40%'>"+a[m]+"</td><td>"+propValue+"</td></tr>");                    
                          break;  //out.println(a[m]+"--- "+ hideHeader +"-----<br>");
                        }
                        }
                       // else
                            
                   // }
                    
                    
  }

}


}
%>
</table> 