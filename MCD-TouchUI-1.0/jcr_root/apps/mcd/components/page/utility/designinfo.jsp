 <%--
  ==============================================================================
  Design details in one spot
  
  Erik Wannebo 8/31/2011
  ==============================================================================
--%>
<%@ page session="false" %>
<%@ page import="java.util.*, 
                java.net.*,
                java.text.*,
                java.io.*,
                javax.jcr.*,
                javax.jcr.Session,
                com.day.cq.commons.jcr.*,
                org.apache.commons.httpclient.*,
                org.apache.commons.httpclient.auth.*,
                org.apache.commons.httpclient.methods.*,
                org.w3c.dom.*,javax.xml.parsers.*,org.xml.sax.*,
                com.mcd.accessmcd.cq.migration.templates.*,
                com.mcd.accessmcd.cq.migration.util.*,
                org.apache.sling.api.resource.*
                
                "
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %><%
%><%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%
%><%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %><%
%><%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %><%
%><cq:defineObjects /> 

<%!
protected class DesignComponent{ 
public String design="";
public String section="";
public ArrayList components=new ArrayList();
public String template="";

}

public String getHeaderRow(ArrayList<String> complist){
StringBuffer sb=new StringBuffer();
sb.append("<tr style='border-bottom:1px solid black'><td valign='bottom'><b>design</b></td><td valign='bottom'><b>template</b></td><td valign='bottom'><b>section</b></td>");
for(String c:complist){
    sb.append("<td style='WRITING-MODE: tb-rl; FILTER: flipv fliph;-moz-transform: rotate(270deg);'><b>");
    //if(c.startsWith("/apps/mcd/components/content/")){
    //        out.write(c.substring(29));
    //    }else{
            sb.append(c);
    //    }
    sb.append("</b></td>");
}
sb.append("</tr>");
return sb.toString();
}

%>

<%
TreeMap<String,DesignComponent> compmap=new TreeMap();

String query="/jcr:root/etc/designs/mcd//*[ @sling:resourceType='mcd/components/content/parsys' or @sling:resourceType='foundation/components/iparsys' or @sling:resourceType='foundation/components/parsys' ]";
//String startdate=xpathdate.format((new Date()).getTime())+"T00:00:00.000Z";
//query+=" @"+lastModifiedField+" > xs:dateTime('"+startdate+"') ] ";
query+=" order by path";
Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
//out.write(query+"<br>");
SimpleDateFormat sfModified=new SimpleDateFormat("MM.dd.yyyy hh:mm a");
int count=0;
ArrayList<String> complist=new ArrayList();

while(result.hasNext()) { 
        if(count>1000)break;
        count++;
        Resource r=(Resource)result.next();
        javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
        if (n != null) {
            String path = n.getPath();
            
            String shortpath=path.substring(27,path.indexOf("jcr:content"));
            String section=path.substring(path.indexOf("jcr:content")+12);
            String template=section.substring(0,section.indexOf("/"));
            section=section.substring(section.indexOf("/")+1);
            String outpath="<a target=_new href=\""+path+".html\">"+shortpath+"</a>";
            
            //Calendar lastModified=n.getProperty(lastModifiedField).getDate();
            //String modifiedTime=sfModified.format(lastModified.getTime());
            
            if(n.hasProperty("components")){
                DesignComponent dc=new DesignComponent();
                dc.design=shortpath;
                dc.template=template;
                dc.section=section;
                String components="";
                Property p=n.getProperty("components");
                if(template.equals("g2g")){
                    try{
                       String comp=p.getString();
                       if(comp.indexOf("/")>-1)comp=comp.substring(comp.lastIndexOf("/")+1);  
                       dc.components.add(comp);
                       if(!complist.contains(comp))complist.add(comp);   
                    }catch(Exception e){  
                        Value[] componentArray=n.getProperty("components").getValues();
                        for(int i=0;i<componentArray.length;i++){
                            String comp=componentArray[i].getString();
                            if(comp.indexOf("/")>-1)comp=comp.substring(comp.lastIndexOf("/")+1); 
                            dc.components.add(comp);
                            if(!complist.contains(comp))complist.add(comp);         
                        }
                    }
                    compmap.put(section+shortpath,dc);  
                }
             }
            //out.write("<tr>"); 
            //String cellstyle=" valign='top'";  
            
        }
}
out.write("<h2>G2G Design - component settings</h2><br>");
out.write("<table>");
Collections.sort(complist);

String headerrow=getHeaderRow(complist);        
String cellstyle=" valign='top'";
//ArrayList sortedkeys=compmap.keySet();
//sortedkeys.sort();
String lastsection="";
for(String dcomp:compmap.keySet()){
        DesignComponent dc=(DesignComponent)compmap.get(dcomp);
        if(!lastsection.equals(dc.section)){
            out.write(headerrow);
            lastsection=dc.section;
        }
        out.write("<tr>"); 
        
        
        out.write("<td"+cellstyle+">"+dc.design+"</td>");
        out.write("<td"+cellstyle+">"+dc.template+"</td>");
        out.write("<td"+cellstyle+">"+dc.section+"</td>");
        for(String c:complist){
            out.write("<td align=center"+cellstyle);
            if(dc.components.contains(c)){
                out.write("bgcolor='yellow'>X</td>");
            }else{
               out.write("></td>");
            }
       }
       out.write("</tr>");

}


out.write("</table>");
       
%>
<%-- new comment:<%=newcomment --%> 