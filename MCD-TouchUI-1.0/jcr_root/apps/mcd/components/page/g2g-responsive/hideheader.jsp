<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page import="java.util.ArrayList,
        java.util.Iterator,
        java.util.Date,
        com.day.cq.wcm.api.PageFilter,
       javax.jcr.Binary,javax.jcr.Node,javax.jcr.Session,org.apache.sling.jcr.api.SlingRepository,
     org.apache.sling.api.scripting.SlingScriptHelper,
        com.day.cq.security.User,
        com.mcd.accessmcd.util.CommonUtil"%>
<%





//String path=currentPage.getPath();
 
String path=request.getParameter("basepath");
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
Page globalPage= pageManager.getPage(path);

int dep=globalPage.getDepth();
  
  
   Iterator<Page> myChildren0 = globalPage.listChildren(new PageFilter(request));  

     while(myChildren0.hasNext()){
        Page child =  (Page) myChildren0.next();
        a[k++]=child.getPath();
  
    }

pageinlevel=k;
int start=0;
for(int n=1;n<=dep;n++)
{   int pages=0;
    
    
   // out.println("start.............."+start+"Pagein level "+pageinlevel+"<br>");
    for(int m=start;m<start+pageinlevel;m++)
    {
    globalPage=pageManager.getPage(a[m]);
            
        Iterator<Page> myChildren = globalPage.listChildren(new PageFilter(request));  
    
         while(myChildren.hasNext()){
            Page child =  (Page) myChildren.next();
           
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
String propValue="";int l=0;
for(int m=0;m<a.length;m++)
{
  propValue = "Not defined."; 
if(a[m]!=null)
{
  
  
 
  if(slingRequest.getResourceResolver().getResource(a[m]+"/jcr:content")!=null)
  {                   
 Node pageNode = slingRequest.getResourceResolver().getResource(a[m]+"/jcr:content").adaptTo(Node.class);
           
 /* if(pageNode.hasProperty(property))
  {
                        propValue = pageNode.getProperty(property).getString(); 
                        //if(propValue.equalsIgnoreCase("no"))
                        {
                          out.println("<tr><td width='10%'>"+(m+1)+"</td><td width='40%'>"+a[m]+"</td><td>"+propValue+"</td></tr>");                    
                        //    out.println(a[m]+"--- "+ hideHeader +"-----<br>");
                        }
                       // else
                            
                    }
                    */
                     if(a[m].contains("test"))
                     {
                      out.println("<tr><td width='10%'>"+(++l)+"</td><td width='40%'>"+a[m]+"</td></tr>");                    
                      }
  }

}


}
%>
</table> 