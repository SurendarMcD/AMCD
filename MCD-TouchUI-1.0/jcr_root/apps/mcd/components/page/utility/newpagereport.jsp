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
        java.util.regex.*,
        javax.servlet.jsp.JspWriter,    
        com.day.cq.search.*,
        com.day.cq.search.result.*,
        com.day.cq.search.facets.*,
        com.day.cq.search.writer.*,
        org.apache.jackrabbit.util.Text,
        com.day.cq.wcm.foundation.*,
        org.apache.sling.api.resource.*,
        com.day.cq.security.*,
        com.day.cq.wcm.api.Page 
        "%>
<%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects />
<HTML>
<TITLE>New Page Report</TITLE>
<head>
<script language="javascript" src="/scripts/jquery-1.3.2.min.js"></script>
<script language="javascript" src="/scripts/jquery-ui-1.7.2.datepicker.min.js" ></script> 
<link rel="stylesheet" href="/css/jquery-ui-1.7.2.datepicker.css" type="text/css" />
</head>
<body style="font-family:arial">
<h2>New Page Report</h2>
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




public String getCug(Page rootPage)
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
          parentProps+=getCug(rootPage.getParent());
      }
}else{

parentProps+=getCug(rootPage.getParent());}
return parentProps;
}  



public String getCugCheckboxes(String cug){
String ret="";
return "<td>"+(cug.contains("DEFAULT-Employee")?"X":"")+"</td>" +
"<td>"+(cug.contains("DEFAULT-McOpCo_Restaurant_Manager")?"X":"")+"</td>" +
"<td>"+(cug.contains("DEFAULT-Owner_Operator")?"X":"")+"</td>" +
"<td>"+(cug.contains("default-franchisee_office_staff")?"X":"")+"</td>" +
"<td>"+(cug.contains("DEFAULT-Franchisee_Restaurant_Manager")?"X":"")+"</td>" +
"<td>"+(cug.contains("DEFAULT-Suppliers_Vendors")?"X":"")+"</td>" +
"<td>"+(cug.contains("default-agency")?"X":"")+"</td>" +
"<td>"+(cug.contains("DEFAULT-Crew")?"X":"")+"</td>"
;
}

static <K,V extends Comparable<? super V>> 
    SortedSet<Map.Entry<K,V>> entriesSortedByValues(Map<K,V> map) {
        SortedSet<Map.Entry<K,V>> sortedEntries = new TreeSet<Map.Entry<K,V>>(
            new Comparator<Map.Entry<K,V>>() {
                public int compare(Map.Entry<K,V> e1, Map.Entry<K,V> e2) {
                    int res = e2.getValue().compareTo(e1.getValue());
                    return res != 0 ? res : 1;
                }
            }
        );
        sortedEntries.addAll(map.entrySet());
        return sortedEntries;
    }

public void genericQuery(JspWriter out, ResourceResolver resourceResolver,String query,boolean bCountOnly){

try{ 
    TreeMap pageMap=new TreeMap();
    out.write(query+"<br>");
    Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
 
    out.write("<table border='1'>");
    int count=0; 
    while(result.hasNext()) { 
            if(count>500000)break;
            count++;
            Resource r=(Resource)result.next();
            javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
            //com.day.cq.wcm.api.Page n = r.adaptTo(com.day.cq.wcm.api.Page.class);
            if (n != null && !bCountOnly){
                String path = n.getPath();
                String cug= getCug(r.adaptTo(com.day.cq.wcm.api.Page.class));
                //String cug="";
                
                //out.write("<tr><td>"+count+"</td><td>"+path+"</td>"+getCugCheckboxes(cug)+"<td>"+cug+"</td></tr>");
                String url="https://www.accessmcd.com"+path+".html";
                pageMap.put(path,"<tr><td><a href=\""+url+"\">"+url+"</a></td>"+getCugCheckboxes(cug)+"<td>"+cug+"</td></tr>");
            }

            
            
            
    }
    
   //SortedSet sortedpages = entriesSortedByValues(pageMap);
    Iterator iterpages=pageMap.keySet().iterator();
    while(iterpages.hasNext()){
        String key=(String)iterpages.next();
        //String url=(String)e1.getKey();
        String html=(String)pageMap.get(key);
        out.write(html);   
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

String startDate="";
if(request.getParameter("startDate")!=null && request.getParameter("startDate").trim()!=""){
   startDate=request.getParameter("startDate");
   startDate=startDate.replaceAll("/","-");
}
   
out.write("<form method=GET>");
out.write("<b>Pages Created Since:</b><input size=10 id=startDate name=startDate value='"+startDate+"'><br>");
out.write("Count only?<input type=checkbox name=count><br>");
out.write("<input type=submit name=run><br>"); 

out.write("</form>");
out.println("<script language='javascript'>");
out.println("$(document).ready(function(){");
out.println("$(\"#startDate\").datepicker({dateFormat: \"yy-mm-dd\"})");
out.println("});");
out.println("</script>");


boolean bCountOnly=false;
if(request.getParameter("count")!=null)bCountOnly=true;

if(!startDate.equals("")){
   String query="/jcr:root/content/accessmcd//*[(jcr:primaryType='cq:Page') and (jcr:created > xs:dateTime('"+startDate+"T00:00:00.000Z'))]";
   genericQuery(out,resourceResolver,query,bCountOnly);
}else{
out.println("<font color=red>Please enter a start date.</font>");
}

%>
</body>
</html>