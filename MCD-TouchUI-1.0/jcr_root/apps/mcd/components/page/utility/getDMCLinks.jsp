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
<h2>Find DMC Links</h2>
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


public static void getDMCLinks(JspWriter out,Session session,String path){

try{ 
    HashMap pageMap=new HashMap();
    String query="/jcr:root"+path+"//*[ @jcr:primaryType='cq:Page']";
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
    
    out.write("<table>");
    out.write("<thead style='border-bottom:1px solid black'><td><b>Page</b></td><td><b>DMC Link</b></td><td><b>CUG</b></td></thead>");
    
    javax.jcr.Node parentNode=session.getNode(path);
    String dmclinks=findDMCLinks(parentNode,"");
    out.write(dmclinks);
    out.write("</table>");
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
          // Cindy Navarro - check accordian component
         if (n.hasProperty("accordiandata")){
              Value[] acc_data = n.getProperty("accordiandata").getValues();
              for(int i=0; i<acc_data.length; i++){
                  Matcher matcher = p.matcher(acc_data[i].getString());
                  while (matcher.find()) {
                       ret+="<tr><td><a href='https://www.accessmcd.com"+pagename+".html'>https://www.accessmcd.com"+pagename+".html</a></td><td>"+matcher.group()+"</td><td>"+CUG+"</td></tr>";
                  }
              }
              //ret+=n.getProperty("text").getString()+"<br>"; 
          }
/*         
          // Cindy Navarro - check table component
          if (n.hasProperty("tableData")){
              String text=n.getProperty("tableData").getString();
              Matcher matcher = p.matcher(text);
              while (matcher.find()) {
                  ret+="<tr><td><a href='https://www.accessmcd.com"+pagename+".html'>https://www.accessmcd.com"+pagename+".html</a></td><td>"+matcher.group()+"</td><td>"+CUG+"</td></tr>";
              }
              //ret+=n.getProperty("text").getString()+"<br>"; 
          }   
*/             
          if (n.hasProperty("text")){
              String text=n.getProperty("text").getString();
              Matcher matcher = p.matcher(text);
              while (matcher.find()) {
                  ret+="<tr><td><a href='https://www.accessmcd.com"+pagename+".html'>https://www.accessmcd.com"+pagename+".html</a></td><td>"+matcher.group()+"</td><td>"+CUG+"</td></tr>";
              }
              
          }
          /*Missing imagelinks*/
          if (n.hasProperty("imageLink")){
              String text=n.getProperty("imageLink").getString();
              Matcher matcher = p.matcher(text);
              while (matcher.find()) {
                  ret+="<tr><td><a href='https://www.accessmcd.com"+pagename+".html'>https://www.accessmcd.com"+pagename+".html</a></td><td>"+matcher.group()+"</td><td>"+CUG+"</td></tr>";
              }
              //ret+=n.getProperty("text").getString()+"<br>";  
          }        
          if(n.hasProperty("documentURL")){
              ret+="<tr><td><a href='https://www.accessmcd.com"+pagename+".html'>https://www.accessmcd.com"+pagename+".html</a></td><td>"+n.getProperty("documentURL").getString()+"</td><td>"+CUG+"</td></tr>";
              
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







%>
<%
QueryBuilder builder = resourceResolver.adaptTo(QueryBuilder.class);
Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);

String path="";
if(request.getParameter("path")!=null && request.getParameter("path").trim()!=""){
   path=request.getParameter("path");
}

//out.write("Find DMC Links");
out.write("<form method=GET>");
out.write("Path: <input size=150 name=path value='"+path+"'><br>");
out.write("<input type=submit name=run><br>"); 

out.write("</form>");


if(!path.equals("")){
    out.write("<table border=1>");
    getDMCLinks(out,jcrSession,path);
    //findDMCLinksWithoutFileSizes(out, resourceResolver);

    out.write("</table>");
}
    


%>
</body>
</html>