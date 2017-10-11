<%/*
Lists recently updated files
Erik Wannebo 11/22/2010
*/
%>
<%@ page import="java.util.Calendar,
        java.text.SimpleDateFormat,
        java.util.*,
        java.io.*,
        javax.jcr.*,
        com.day.cq.search.*,
        com.day.cq.search.result.*,
        com.day.cq.search.facets.*,
        com.day.cq.search.writer.*,
        org.apache.jackrabbit.util.Text,
        com.day.cq.wcm.foundation.*,
        org.apache.sling.api.resource.*,
        com.mcd.accessmcd.ace.manager.ACEManager,
        com.mcd.accessmcd.ace.bo.ACEConfigDataBean"%>
<%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects />
<HTML>
<TITLE>Recently Updated Files</TITLE>
<head>
<script language='javascript'>
function openInCRXDE(path){
window.open("/crx/de/#/crx.default/jcr%3aroot"+path);
}
</script>
</head>
<body style="font-family:arial">
<h2>Recently Updated Files</h2>
 
<%!
 
public static void doSearchNew(JspWriter out,String searchpath,String searchtype,String lastModifiedField,QueryBuilder builder,ResourceResolver resourceResolver){
long daysecs=24*60*60*1000;
SimpleDateFormat xpathdate =new SimpleDateFormat("yyyy-MM-dd");
try{
    String query="/jcr:root//*[ ";
    
    String startdate=xpathdate.format((new Date()).getTime()+((1-11)*daysecs))+"T00:00:00.000Z";
    query+=" @"+lastModifiedField+" > xs:dateTime('"+startdate+"') ] order by @"+lastModifiedField+" descending";
    
    Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
    SimpleDateFormat sfModified=new SimpleDateFormat("MM.dd.yyyy hh:mm a");
    out.write("<table>");
    out.write("<thead style='border-bottom:1px solid black'><td><b>File</b></td><td><b>Last Modified</b></td></thead>");
    Calendar lastLastModified=Calendar.getInstance();
    while(result.hasNext()) {
            Resource r=(Resource)result.next();
            javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
            if (n != null) {
                String path = n.getPath();
                if(path.endsWith("/jcr:content"))path=path.substring(0,path.lastIndexOf("/jcr:content"));
                if(path.startsWith("/apps") || path.startsWith("/libs") || path.startsWith("/etc")){
                    String outpath="";
                    
                    String highlightedfile=path.substring(0,path.lastIndexOf("/"))+"<b>"+path.substring(path.lastIndexOf("/"))+"</b>";
                    if(searchpath=="/content"){
                        outpath+="<a target=_new href=\""+path+".html\">"+highlightedfile+"</a>";
                    }else{
                        outpath+="<a target=_new href=\""+path+"\">";
                        outpath+="<font";
                        if(path.startsWith("/libs"))outpath+=" color='red'";
                        if(path.startsWith("/etc"))outpath+=" color='green'";
                        outpath+=">";
                        outpath+=highlightedfile+"</font></a>";
                    }
                    if(searchpath=="/apps")outpath+="&nbsp;<a href=\"javascript:openInCRXDE('"+path+"')\">crxde</a>";
                    
                    //diff link
                    outpath+="&nbsp;<a target=_new href=\"/content/utility/utility.diff.html?";
                    outpath+="host1=http%3A%2F%2Fmcdeagsun107a.mcd.com%3A4214";
                    outpath+="&page1="+path;
                    outpath+="&host2=http%3A%2F%2Fmcdeagsun107b.mcd.com%3A4217";
                    outpath+="\">diff</a>";
                    
                    Calendar lastModified=n.getProperty("jcr:lastModified").getDate();
                    String modifiedTime=sfModified.format(lastModified.getTime());
                    out.write("<tr>");
                    String cellstyle="";
                    if(lastModified.get(Calendar.DATE)!=lastLastModified.get(Calendar.DATE)){
                        //different day
                        cellstyle=" style='border-top:1px solid black;'";
                        lastLastModified=lastModified;
                    }
                   
                    out.write("<td"+cellstyle+">"+outpath+"</td>");
                    out.write("<td"+cellstyle+">"+modifiedTime+"</td>");
                    out.write("</tr>");
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
 public static void doSearch(JspWriter out,String searchpath,String searchtype,String lastModifiedField,QueryBuilder builder,Session session) {
        
        try{
        
        // create query description as hash map (simplest way, same as form post)
        Map<String, String> map = new HashMap<String, String>();
        map.put("path", searchpath);
        if(searchtype!="")map.put("type", searchtype);
        map.put("relativedaterange.property", "jcr:content/"+lastModifiedField);
        map.put("relativedaterange.lowerBound", "-7d");
 
        map.put("orderby", "@jcr:content/"+lastModifiedField);
        map.put("orderby.sort", "desc");
        map.put("p.limit", "-1");
          
        Query query = builder.createQuery(PredicateGroup.create(map), session);
 
        SearchResult result = query.getResult();
        SimpleDateFormat sfModified=new SimpleDateFormat("MM.dd.yyyy hh:mm a");
        // paging metadata
        int hitsPerPage = result.getHits().size(); // 20 (set above) or lower
        long totalMatches = result.getTotalMatches();
        long offset = result.getStartIndex();
        //long numberOfPages = totalMatches / 20;
        out.write("<table>");
        out.write("<thead style='border-bottom:1px solid black'><td><b>File</b></td><td><b>Last Modified</b></td></thead>");
        // iterating over the results
        Calendar lastLastModified=Calendar.getInstance();
        for (Hit hit : result.getHits()) { 
            String path = hit.getPath();
            String highlightedfile=path.substring(0,path.lastIndexOf("/"))+"<b>"+path.substring(path.lastIndexOf("/"))+"</b>";
            if(searchpath=="/content"){
                path="<a target=_new href=\""+path+".html\">"+highlightedfile+"</a>";
            }else{
                path="<a target=_new href=\""+path+"\">"+highlightedfile+"</a>";
            }
            if(searchpath=="/apps")path+="&nbsp;<a href=\"javascript:openInCRXDE('"+path+"')\">crxde</a>";
            ValueMap props = hit.getProperties();
            Calendar lastModified=(Calendar)props.get(lastModifiedField);
            String modifiedTime=sfModified.format(lastModified.getTime());
            out.write("<tr>");
            String cellstyle="";
            if(lastModified.get(Calendar.DATE)!=lastLastModified.get(Calendar.DATE)){
                //different day
                cellstyle=" style='border-top:1px solid black;'";
                lastLastModified=lastModified;
            }
            //Calendar created=(Calendar)props.get("jcr:created");
            //String createdTime=sfModified.format(created.getTime());
             //out.write(sfModified.format(lastModified.getTime())+"<br>");
            out.write("<td"+cellstyle+">"+path+"</td>");
            out.write("<td"+cellstyle+">"+modifiedTime+"</td>");
            //out.write("<td>"+createdTime+"</td>");
            //for(String k : props.keySet()) 
             //   out.write(k+":"+props.get(k)+"<br>");
            out.write("</tr>");
        }
        out.write("</table>");
        


        }catch(Exception e){}

    }
    
%>
<%
QueryBuilder builder = resourceResolver.adaptTo(QueryBuilder.class);
Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
//out.write("hello");
doSearchNew(out,"/apps","","jcr:lastModified",builder,resourceResolver);
doSearch(out,"/content","cq:Page","cq:lastModified",builder,jcrSession);
//doSearch(out,"/content/accessmcd/na/us","cq:Page","cq:lastReplicated",builder,jcrSession);
%>
</body>
</html>