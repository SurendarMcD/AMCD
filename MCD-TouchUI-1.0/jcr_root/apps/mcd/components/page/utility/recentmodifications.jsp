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
        com.day.cq.wcm.api.Page,
        com.day.cq.wcm.api.PageManager,
        org.apache.jackrabbit.util.Text,
        com.day.cq.wcm.foundation.*,
        org.apache.sling.api.resource.*,
        com.mcd.accessmcd.ace.manager.ACEManager,
        com.mcd.accessmcd.ace.bo.ACEConfigDataBean,
        org.apache.commons.lang.StringEscapeUtils,
        com.day.cq.wcm.api.WCMMode"%>
<%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>

<sling:defineObjects />
<HTML>
<TITLE>Recent Modifications</TITLE>
<head>
<link rel="stylesheet" href="/etc/designs/mcd/accessmcd/corelibs/core.css" type="text/css">
<link rel="stylesheet" href="/etc/designs/mcd/accessmcd/corelibs/components/content.css" type="text/css">
<link rel="stylesheet" href="/etc/designs/mcd/accessmcd/g2g/g2g_maroon/clientlib.css" type="text/css">


<script language='javascript'>
function openInCRXDE(path){
window.open("/crx/de/#/crx.default/jcr%3aroot"+path);
}
</script>
</head>
<body style="font-family:arial">
<h2>Recent Modifications</h2>
 
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
 public static ArrayList doSearch(JspWriter out,String searchpath,String timeframe,String searchtype,QueryBuilder builder,Session session) {
        
       ArrayList ar=new ArrayList();
       String ret="";
       try{
        
        // create query description as hash map (simplest way, same as form post)
        Map<String, String> map = new HashMap<String, String>();
        map.put("path", searchpath);
        if(searchtype!="")map.put("type", searchtype); 
        //map.put("relativedaterange.property", "jcr:content/cq:lastReplicated");
        map.put("relativedaterange.property", "jcr:lastModified");
        String lowerbound="-"+timeframe+"h";
        map.put("relativedaterange.lowerBound", lowerbound); 
         
        //map.put("orderby", "jcr:content/cq:lastReplicated");
        map.put("orderby", "@jcr:lastModified");
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
        
        ret+="total matches:"+totalMatches;
        ret+="<table>";
        ret+="<thead style='border-bottom:1px solid black'><td><b>File</b></td><td><b>Last Modified</b></td><td><b>Created Time</b></td></thead>";
        // iterating over the results
        Calendar lastLastModified=Calendar.getInstance();
        for (Hit hit : result.getHits()) { 
            String path = hit.getPath();
            ar.add(hit.getPath());
            //out.write("hit:"+path);
            String highlightedfile=path.substring(0,path.lastIndexOf("/"))+"<b>"+path.substring(path.lastIndexOf("/"))+"</b>";
            if(searchpath.startsWith("/content")){
                path="<a target=_new href=\""+path+".html\">"+highlightedfile+"</a>";
            }else{
                path="<a target=_new href=\""+path+"\">"+highlightedfile+"</a>";
            }
            if(searchpath=="/apps")path+="&nbsp;<a href=\"javascript:openInCRXDE('"+path+"')\">crxde</a>";
            ValueMap props = hit.getProperties();
            //Calendar lastReplicated=(Calendar)props.get("cq:lastReplicated");
            
            Calendar lastModified=(Calendar)props.get("jcr:lastModified");
            String modifiedTime=sfModified.format(lastModified.getTime());
            //String modifiedTime=sfModified.format(lastReplicated.getTime());
            ret+="<tr>";
            String cellstyle="";
            if(lastModified.get(Calendar.DATE)!=lastLastModified.get(Calendar.DATE)){
                //different day
                cellstyle=" style='border-top:1px solid black;'";
                lastLastModified=lastModified;
            }
            //Calendar created=(Calendar)props.get("jcr:created");
            //String createdTime=sfModified.format(created.getTime());
             //out.write(sfModified.format(lastModified.getTime())+"<br>");
            ret+="<td"+cellstyle+">"+path+"</td>";
            

            
            //out.write("<td"+cellstyle+">"+replicatedTime+"</td>");
            ret+="<td"+cellstyle+">"+modifiedTime+"</td>";
            
            //out.write("<td>"+createdTime+"</td>");
            //for(String k : props.keySet()) 
             //   out.write(k+":"+props.get(k)+"<br>");
            ret+="</tr>";
            ret+="<tr><td><div style='display:inline;' >";

            ret+="</div></td></tr>";
        }
        ret+="</table>";
        


    } catch (Exception e) {
        // Log errors always



    } 
    return ar;
    }








    
%>
<%
QueryBuilder builder = resourceResolver.adaptTo(QueryBuilder.class);
Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
//out.write("hello");
//doSearchNew(out,"/apps","","jcr:lastModified",builder,resourceResolver);
//doSearch(out,"/content","cq:Page","cq:lastModified",builder,jcrSession);

//WCMMode mode = WCMMode.DISABLED.toRequest(request);

String searchpath= (String) request.getParameter("searchpath");
if(searchpath==null || searchpath.equals(""))searchpath="/accessmcd/corp";

String timeframe= (String) request.getParameter("timeframe");
if(timeframe==null || timeframe.equals(""))timeframe="1";

out.println("<FORM name=\"recentmodifications\" action=\"\" method=\"GET\">");

out.println("<B>Path:</B><SELECT name=\"searchpath\" >");
out.println("<OPTION value=\"/accessmcd/corp\" "+ (searchpath.equals("/accessmcd/corp")?"SELECTED":"")+">/accessmcd/corp</OPTION>");
out.println("<OPTION value=\"/accessmcd/na/us\" "+ (searchpath.equals("/accessmcd/na/us")?"SELECTED":"")+">/accessmcd/na/us</OPTION>");
out.println("<OPTION value=\"/accessmcd/na/us/natl\" "+ (searchpath.equals("/accessmcd/na/us/natl")?"SELECTED":"")+">/accessmcd/na/us/natl</OPTION>");
out.println("<OPTION value=\"/accessmcd/na/us/natl/regns\" "+ (searchpath.equals("/accessmcd/na/us/natl/regns")?"SELECTED":"")+">/accessmcd/na/us/natl/regns</OPTION>");
out.println("<OPTION value=\"/accessmcd/na/mcweb\" "+ (searchpath.equals("/accessmcd/na/mcweb")?"SELECTED":"")+">/accessmcd/na/mcweb</OPTION>");
out.println("<OPTION value=\"/accessmcd/apmea\" "+ (searchpath.equals("/accessmcd/apmea")?"SELECTED":"")+">/accessmcd/apmea</OPTION>");
out.println("<OPTION value=\"/accessmcd/mcd\" "+ (searchpath.equals("/accessmcd/mcd")?"SELECTED":"")+">/accessmcd/mcd</OPTION>");
out.println("</SELECT>");

out.println("<B>Modified in last:</B><SELECT name=\"timeframe\" >");
out.println("<OPTION value=\"1\" "+ (timeframe.equals("1")?"SELECTED":"")+">1 hour</OPTION>");
out.println("<OPTION value=\"3\" "+ (timeframe.equals("3")?"SELECTED":"")+">3 hours</OPTION>");
out.println("<OPTION value=\"6\" "+ (timeframe.equals("6")?"SELECTED":"")+">6 hours</OPTION>");
out.println("<OPTION value=\"12\" "+ (timeframe.equals("12")?"SELECTED":"")+">12 hours</OPTION>");
out.println("<OPTION value=\"24\" "+ (timeframe.equals("24")?"SELECTED":"")+">24 hours</OPTION>");
out.println("</SELECT>");


out.println("<INPUT TYPE=SUBMIT value=\"Get Report\">");
 
out.println("</FORM>");
searchpath="/content"+searchpath; 
try{
    //String searchpath="/content/accessmcd/na/us";
    //searchpath="/content/accessmcd/corp";
    
    ArrayList arl=doSearch(out,searchpath,timeframe,"",builder,jcrSession);
    Iterator it=arl.iterator();
    int count=0;
    String lastpagelink="";
    while(it.hasNext() && count<10000){
        String path=(String)it.next();
        String pagelink=path.substring(8,path.indexOf("jcr:content")-1)+".html";

        String pathlink=path.substring(0,path.indexOf("jcr:content")-1);
        //out.println("pathlink:"+pathlink);
 
        Page currentPage= slingRequest.getResourceResolver().adaptTo(PageManager.class).getPage(pathlink);
        if(!pagelink.equals(lastpagelink)){
        %>
        <table style='width:1000px; border:1px solid black; background-color: #dddddd;' ><tr><td>
        <!--h2><a href="<%=pagelink%>"><%=pagelink%></a></h2><br-->
 
 
 
   <!-- BREADCRUMB -->
        <div class="breadCrumbBg">
        <div class="breadCrumb" id="divBreadCrumb">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
                <td valign="middle" class="breadCrumbBg">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                        <td width="1" class="breadCrumbImg"><img src="/etc/designs/mcd/accessmcd/g2g/g2g_maroon/images/0.gif" alt="spacer" ></td>
                  
                        <!-- BREAD CRUMBS  -->
                        <td class="breadCrumb"> 

                             <%    
                                int currentLevel = currentPage.getDepth();
                                int level=1;
                                String delim="";
                                
                                while ( level <= currentLevel) {
                                    Page trail = currentPage.getAbsoluteParent((int) level);
                                    
                                    if (trail == null) {
                                        
                                        break;
                                    }
                                    String title = trail.getNavigationTitle();
                                    if (title == null || title.equals("")) {
                                        title = trail.getPageTitle();
                                    }
                                    if (title == null || title.equals("")) {
                                        title = trail.getTitle();
                                    }
                                    if (title == null || title.equals("")) {
                                        title = trail.getName();
                                    } 
                                    %><%= delim %><%        
                                     
                                        String trailPath = trail.getPath();
                                        int lastIndex = trailPath.lastIndexOf("/");
                                        if(lastIndex!=-1){
                                            //path = trailPath.substring(lastIndex+1,trailPath.length()); 

                                                %>
                                                <a href="<%= Text.escape(trail.getPath(), '%', true) %>.html">
                                                <%
                                                                                  
   
                                    %>                                       
                                        <%= StringEscapeUtils.escapeHtml(title) %></a>
                                        <%}
                                    delim = "<span class='breadCrumbSeperator'>"+">"+"</span>";
                                    level++;
                                }
                           %>
 
 
 
                           </td>
                      <!-- /BREAD CRUMBS -->                     
                    </tr>
                </table>
              </td>
        </tr>
        </table>
      </div>    
   </div>
   
 
        </td></tr></table>
        <%
        lastpagelink=pagelink;
        }
        if(!path.toLowerCase().endsWith("image") && !path.toLowerCase().endsWith("/pci")){
        %>
        <table style='width:1000px; border:1px solid black;'><tr><td>
        
        <div style="display:inline;" style="width:1000px;"><sling:include path="<%=path%>"/></div>
        </td></tr></table>
        <%
        }
        count++;
    }

}catch(Exception e){
}
finally {
       //mode.toRequest(request);
    }
%>
</body>
</html>  