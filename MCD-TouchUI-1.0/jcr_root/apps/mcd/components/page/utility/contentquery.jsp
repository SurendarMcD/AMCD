<%
/*
Lists recently updated files
Erik Wannebo 11/22/2010
*/
%>
<%@ page import="java.util.Calendar,
        java.text.SimpleDateFormat,
        java.util.*,
        java.io.*,
        javax.jcr.*,
        java.util.regex.*,
        javax.servlet.jsp.JspWriter,    
        com.day.cq.search.*,
        com.day.cq.search.result.*,
        com.day.cq.search.facets.*,
        com.day.cq.search.writer.*,
        org.apache.jackrabbit.util.Text,
        com.day.cq.wcm.foundation.*,
        org.apache.sling.api.resource.*,
        com.day.cq.security.* "%>
<%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects /> 
<HTML>
<head>
<script language='javascript'>
function openInCRXDE(path){
window.open("/crxde/#/crx.default/jcr%3aroot"+path);
}  
</script>
</head>
<body style="font-family:arial">
<h2>Content Query</h2>
<%
HttpServletRequest cqReq = request;
boolean isAdmin=false;
if(!slingRequest.getUserPrincipal().getName().equals("admin")){
    isAdmin=false;
    out.write("<b><font color=red>You need to login to use this page.</font></b><br>");
    out.write("<a href='/libs/cq/core/content/login.html?resource=/content/utility/utility.timings.html'>LOGIN HERE</a>");
    return;
}
%>  
<%!                                

public static void doSearchNew(javax.servlet.jsp.JspWriter out,String searchpath,String searchtype,String lastModifiedField,QueryBuilder builder,ResourceResolver resourceResolver){
long daysecs=24*60*60*1000;
SimpleDateFormat xpathdate =new SimpleDateFormat("yyyy-MM-dd");
try{ 
    String query="/jcr:root/home//*[ @jcr:primaryType='rep:User' and";
    String startdate=xpathdate.format((new Date()).getTime())+"T00:00:00.000Z";
    query+=" @"+lastModifiedField+" > xs:dateTime('"+startdate+"') ] order by @"+lastModifiedField+" descending";
    Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
    //out.write(query+"test");
    SimpleDateFormat sfModified=new SimpleDateFormat("MM.dd.yyyy hh:mm a");
    out.write("<table>");
    out.write("<thead style='border-bottom:1px solid black'><td><b>File</b></td><td><b>E-mail</b></td><td><b>Last Modified</b></td></thead>");
    Calendar lastLastModified=Calendar.getInstance();
    int count=0; 
    while(result.hasNext()) { 
            if(count>100000)break;
            count++;
            Resource r=(Resource)result.next();
            javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
            if (n != null) {
                String path = n.getPath();
                String outpath=""; 
                
                outpath+="<a target=_new href=\""+path+".html\">"+path+"</a>";
                
                Calendar lastModified=n.getProperty(lastModifiedField).getDate();
                String modifiedTime=sfModified.format(lastModified.getTime());
                String email=n.getProperty("rep:e-mail").getString();
                
                out.write("<tr>");
                String cellstyle="";
               
                out.write("<td"+cellstyle+">"+outpath+"</td>");
                out.write("<td"+cellstyle+">"+email+"</td>");
                out.write("<td"+cellstyle+">"+modifiedTime+"</td>");
                out.write("</tr>");
                
            }
    }
  }catch(Exception e){
      try{
          out.println(e.getMessage());
      }catch(Exception ex){
      }
  }
    
}   





public static void getOfftimes(javax.servlet.jsp.JspWriter out, QueryBuilder builder,ResourceResolver resourceResolver,int days){
long daysecs=24*60*60*1000;
SimpleDateFormat xpathdate =new SimpleDateFormat("yyyy-MM-dd");

String startdate=xpathdate.format((new Date()).getTime())+"T00:00:00.000Z";
String enddate=xpathdate.format((new Date()).getTime()+(days*1000*3600*24))+"T00:00:00.000Z";


try{ 
    String query="/jcr:root/content/accessmcd//*[@offTime > xs:dateTime('"+startdate+"') and @offTime < xs:dateTime('"+enddate+"')]";
    query+=" order by @offTime ascending";
    Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
    //out.write(query+"test");
    SimpleDateFormat sfModified=new SimpleDateFormat("MM-dd-yyyy hh:mm a");
    out.write("<table>");
    out.write("<thead style='border-bottom:1px solid black'><td><b>Path</b></td><td><b>Title</b></td><td><b>Author</b></td><td><b>Expires</b></td><td><b>Last Modified</b></td><td><b>Last Replicated</b></td></thead>");
    int count=0; 
    while(result.hasNext()) { 
            if(count>100000)break;
            count++;
            Resource r=(Resource)result.next();
            javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
            
            if (n != null) {
                String path = n.getPath();
                String outpath="https://author.accessmcd.com"+path.substring(0,path.indexOf("/jcr:content"))+".html"; 
                
                outpath="<a target=_new href=\""+outpath+"\">"+outpath+"</a>";
                
                Calendar lastModified=n.getProperty("cq:lastModified").getDate();
                String modifiedTime=sfModified.format(lastModified.getTime());
                
                // String email=n.getProperty("rep:e-mail").getString();
                
                Calendar calOffTime=n.getProperty("offTime").getDate();
                String offTime=sfModified.format(calOffTime.getTime());
                if(n.hasProperty("cq:lastReplicationAction")){
                    Calendar lastReplicated=n.getProperty("cq:lastReplicated").getDate();
                    String replicatedTime=sfModified.format(lastReplicated.getTime());
                    Property proplastReplicationAction = n.getProperty("cq:lastReplicationAction");
                    String lastReplicationAction="";
                    if(proplastReplicationAction !=null){
                        lastReplicationAction=proplastReplicationAction.getString();
                    }
                        
                    String title= n.getProperty("jcr:title").getString();
                    String authorName="";
                    if(n.hasProperty("authorName")){
                        authorName=n.getProperty("authorName").getString();
                    }
    
                    if(lastReplicationAction!=null && lastReplicationAction.equals("Activate")){
                        out.write("<tr>");
                        String cellstyle="";
                        out.write("<td>"+outpath+"</td>");
                        out.write("<td>"+title+"</td>");
                        out.write("<td>"+authorName+"</td>");
                        out.write("<td>"+offTime+"</td>");
                        out.write("<td>"+modifiedTime+"</td>");
                        out.write("<td>"+replicatedTime+"</td>");
                        out.write("</tr>");
                    }
                }
            }
    }
  }catch(Exception e){
      try{
          out.println(e.getMessage());
      }catch(Exception ex){
      }
  }
    
}   




public static void findComponents(JspWriter out,QueryBuilder builder,ResourceResolver resourceResolver){

try{ 
    String query="/jcr:root/content/accessmcd/apmea/au//*[ @sling:resourceType='mcd/components/content/searchdmc']";
    Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
    //out.write(query+"test");
    out.write("<table>");
    out.write("<thead style='border-bottom:1px solid black'><td><b>Component</b></td></thead>");
    int count=0; 
    while(result.hasNext()) { 
            if(count>10000000)break;
            count++;
            Resource r=(Resource)result.next();
            javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
            if (n != null) {
                String path = n.getPath(); 
                
                //String outpath+="<a target=_new href=\""+path+"\">"+path+"</a>";

                //String mimeType=n.getProperty("jcr:mimeType").getString();
 
                out.write("<tr>");
                String cellstyle="";              
                out.write("<td"+cellstyle+">"+path+"</td>");
                //out.write("<td"+cellstyle+">"+mimeType+"</td>");
                out.write("</tr>");
                
            }
    }
  }catch(Exception e){
      try{
          out.println(e.getMessage());
      }catch(Exception ex){
      }
  }
    
}   

public static void getComponentsPerPage(JspWriter out,QueryBuilder builder,ResourceResolver resourceResolver){

try{ 
    HashMap pageMap=new HashMap();
    String query="/jcr:root/content/accessmcd/apmea/au//*[ @sling:resourceType='mcd/components/content/searchdmc']";
    Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
    //out.write(query+"test");
    int count=0; 
    while(result.hasNext()) { 
            if(count>10000000)break;
            count++;
            Resource r=(Resource)result.next();
            javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
            if (n != null) {
                String path = n.getPath();
                String pagename=path.substring(0,path.indexOf("/jcr:content"));
                if(pageMap.containsKey(pagename)){
                    pageMap.put(pagename,(((Integer)pageMap.get(pagename)).intValue())+1);
                }else{
                    pageMap.put(pagename,1);
                }

                
            }
    }
    
    //output results
    out.write("<table>");
    out.write("<thead style='border-bottom:1px solid black'><td><b>page</b></td><td><b>count</b></td></thead>");
    Iterator iterMimes=pageMap.keySet().iterator();
    while(iterMimes.hasNext()){
        String key=(String)iterMimes.next();
        String cellstyle="";
        out.write("<tr>");
        out.write("<td"+cellstyle+">"+key+"</td>");
        out.write("<td"+cellstyle+">"+pageMap.get(key)+"</td>");
        out.write("</tr>");
    }
    out.write("</table>");

  }catch(Exception e){
      try{
          out.println(e.getMessage());
      }catch(Exception ex){
      }
  }
    
}  

public static void getDMCLinks(JspWriter out,Session session){

try{ 
    HashMap pageMap=new HashMap();
    String query="/jcr:root/content/accessmcd/apmea/au/finance//*[ @jcr:primaryType='cq:Page']";
    /*
    Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
    out.write(query+"<br>");
    int count=0; 
    while(result.hasNext()) { 
            if(count>100)break;
            count++;
            Resource r=(Resource)result.next();
            javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
            if (n != null) {
                String path = n.getPath();
                //String pagename=path.substring(0,path.indexOf("/jcr:content"));
                String dmclinks=findDMCLinks(n);
                out.write(dmclinks);
            }
    }
    */
    javax.jcr.Node parentNode=session.getNode("/content/accessmcd/na/us/natl/about_company/ptw");
    String dmclinks=findDMCLinks(parentNode,"");
    out.write(dmclinks);
    /*
    output results
    out.write("<table>");
    out.write("<thead style='border-bottom:1px solid black'><td><b>page</b></td><td><b>count</b></td></thead>");
    Iterator iterMimes=pageMap.keySet().iterator();
    while(iterMimes.hasNext()){
        String key=(String)iterMimes.next();
        String cellstyle="";
        out.write("<tr>");
        out.write("<td"+cellstyle+">"+key+"</td>");
        out.write("<td"+cellstyle+">"+pageMap.get(key)+"</td>");
        out.write("</tr>");
    }
    out.write("</table>");
   */
  }catch(Exception e){
      try{
          out.println(e.getMessage());
      }catch(Exception ex){
      }
  }
     
}  

  private static String findDMCLinks(javax.jcr.Node n,String CUG){
      String dmclinkpattern= "https://dmc.accessmcd.com[^ \\\"]*";
      //String logEntryPattern = "^([\\d.]+) (\\S+) (\\S+) \\[([\\w:/]+\\s[+\\-]\\d{4})\\] \".+?\" (\\d{3}) (\\d+) .+";
      Pattern p = Pattern.compile(dmclinkpattern);
      String ret="";
      
      try{
          String pagename=n.getPath();
          if(pagename.indexOf("jcr:content")>0){
              pagename=pagename.substring(0,pagename.indexOf("jcr:content")-1);
          }
          if (n.hasProperty("text")){
              String text=n.getProperty("text").getString();
              Matcher matcher = p.matcher(text);
              while (matcher.find()) {
                  ret+="<tr><td><a href='https://www.accessmcd.com"+pagename+".html'>https://www.accessmcd.com"+pagename+".html</a></td><td>"+matcher.group()+"</td><td>"+CUG+"</td></tr>";
              }
              //ret+=n.getProperty("text").getString()+"<br>"; 
          }
          if(n.hasProperty("documentURL")){
              ret+="<tr><td><a href='https://www.accessmcd.com"+pagename+".html'>https://www.accessmcd.com"+pagename+".html</a></td><td>"+n.getProperty("documentURL").getString()+"</td><td>"+CUG+"</td></tr>";
              //ret+=pagename+" "+n.getProperty("documentURL").getString()+"<br>";
          }
          //check for new CUG
          if(n.hasNode("jcr:content")){
              javax.jcr.Node jcrcontent=n.getNode("jcr:content");
              if(jcrcontent.hasProperty("cq:cugPrincipals")){
                    Value[] cugs=null; 
                    CUG="";
                    try {
                            cugs=jcrcontent.getProperty("cq:cugPrincipals").getValues();
                            
                        }catch (ValueFormatException e){
                            cugs = new Value[1];
                            cugs[0] = jcrcontent.getProperty("cq:cugPrincipals").getValue();
                        }
                    
                        for (int i=0; i<cugs.length ;i++ ){
                            CUG+=(i>0?",":"")+cugs[i].getString();
                        }
              }
          }
          
          //recursive
          NodeIterator ni=n.getNodes();
          while(ni.hasNext()){
              ret+=findDMCLinks(ni.nextNode(),CUG);
          }
      }catch(Exception e){
          ret+="Exception:"+e.getMessage()+"<br>";
      }
      return ret;
  }

 public static String findDMCLinksWithoutFileSizes(JspWriter out, ResourceResolver resourceResolver){ 

      String ret="";
      try{
      
        String query="/jcr:root/content/accessmcd//*[ @sling:resourceType='mcd/components/content/searchdmc']";
    
        Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
        //out.write(query+"test");
        int count=0; 
        
        while(result.hasNext()) { 
                //if(count>100)break;      
                  count++;
                    Resource r=(Resource)result.next();
                    javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
                    if (n != null) {
                        String path = n.getPath();
    
                          if(n.hasProperty("documentURL")){
                              if(!n.hasProperty("documentSize")){
                                  ret+="<tr><td><a href='https://www.accessmcd.com"+path+".html'>https://www.accessmcd.com"+path+".html</a></td><td>"+n.getProperty("documentURL").getString()+"</td><td></td></tr>";
                              }
                              //ret+=pagename+" "+n.getProperty("documentURL").getString()+"<br>";
                          }
                    }
            }
      out.write(ret);   
      }catch(Exception e){
          ret+="Exception:"+e.getMessage()+"<br>";
      }
     
      return ret;
  }




public static void genericQuery(JspWriter out, ResourceResolver resourceResolver,String query,boolean bCountOnly){

try{ 
    HashMap pageMap=new HashMap();
    out.write(query+"<br>");
    Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
 
    out.write("<table>");
    int count=0; 
    while(result.hasNext()) { 
            if(count>500000)break;
            count++;
            Resource r=(Resource)result.next();
            javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
            if (n != null && !bCountOnly){
                String path = n.getPath();
                out.write("<tr><td>"+count+"</td><td>"+path+"</td></tr>");
            }
    }
    
    out.write("</table>");

  
    out.write("Result Count="+count);

    /*
    output results
    out.write("<table>");
    out.write("<thead style='border-bottom:1px solid black'><td><b>page</b></td><td><b>count</b></td></thead>");
    Iterator iterMimes=pageMap.keySet().iterator();
    while(iterMimes.hasNext()){
        String key=(String)iterMimes.next();
        String cellstyle="";
        out.write("<tr>");
        out.write("<td"+cellstyle+">"+key+"</td>");
        out.write("<td"+cellstyle+">"+pageMap.get(key)+"</td>");
        out.write("</tr>");
    }
    out.write("</table>");
   */
  }catch(Exception e){
      try{
          out.println(e.getMessage());
      }catch(Exception ex){
      }
  }
     
}  


%>
<%
QueryBuilder builder = resourceResolver.adaptTo(QueryBuilder.class);
Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
//out.write("hello");
//doSearchNew(out,"/apps","","jcr:created",builder,resourceResolver);
//UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
//UserManager uMgr = userManagerFactory.createUserManager(jcrSession);
//getUserCount(out,uMgr);

//findComponents(out,builder,resourceResolver);
//getComponentsPerPage(out,builder,resourceResolver);
//doSearch(out,"/content","cq:Page","cq:lastModified",builder,jcrSession);
out.write("XPath Query");
out.write("<form method=GET>");
out.write("<input size=150 name=query><br>");
out.write("Count only?<input type=checkbox name=count><br>");
out.write("<input type=submit name=run><br>"); 

out.write("</form>");
int days=1;
if(request.getParameter("days")!=null && request.getParameter("days").trim()!=""){
   days=Integer.parseInt(request.getParameter("days"));
}

boolean bCountOnly=false;
if(request.getParameter("count")!=null)bCountOnly=true;

if(request.getParameter("query")!=null && request.getParameter("query").trim()!=""){
   genericQuery(out,resourceResolver,request.getParameter("query"),bCountOnly);
}else{
    out.write("<table border=1>");
    //getDMCLinks(out,jcrSession);
    //findDMCLinksWithoutFileSizes(out, resourceResolver);
    getOfftimes(out,builder,resourceResolver,days);
    out.write("</table>");
}

%>
</body>
</html>