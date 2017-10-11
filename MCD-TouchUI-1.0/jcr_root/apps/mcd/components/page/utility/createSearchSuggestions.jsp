<%
/* *************************
* Form to populate search suggestion components 
*
* Erik Wannebo 10/6/2014
*********************************/
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
        com.day.cq.commons.jcr.*,
        java.nio.charset.Charset
" pageEncoding="UTF-8"%>
<%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects />
<HTML>
<TITLE>Populate Suggestions</TITLE>
<head>
</head>
<body>
<%!

private static final Charset UTF8_CHARSET = Charset.forName("UTF-8");

public static String decodeUTF8(byte[] bytes) {
    return new String(bytes, UTF8_CHARSET);
}

public static byte[] encodeUTF8(String string) {
    return string.getBytes(UTF8_CHARSET);
}

public static Iterator<Resource> searchNodes(ResourceResolver resourceResolver, String contentPath, String searchTerm){

try{
    
    String query = "/jcr:root"+contentPath+"//*[jcr:contains(., '"+searchTerm+"')] order by jcr:path"; 
    Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
    return result;
    }catch(Exception e){
    }
    return null;
}

public String getSuggestionForm(String title, String url, boolean newWindow, String description, String keywords, String view) throws Exception 
    {
        String retString="";
        
        retString="<fieldset><legend>Add Search Suggestion</legend>";
        retString+="<FORM id=\"maintform\" name=\"maintform\" action=\"\" method=\"get\">";
        retString+="<B>Title:</B><INPUT size=200 name=\"title\"value=\""+title+"\"></INPUT><BR>";
        retString+="<B>URL:</B><INPUT size=200 name=\"url\"value=\""+url+"\"></INPUT><BR>";
        retString+="<B>New Window:</B><INPUT type=checkbox name=\"newWindow\" "+(newWindow?"SELECTED":"")+"></INPUT><BR>";
        retString+="<B>Description:</B><TEXTAREA rows=5 cols=80 name=\"description\">"+ description+"</TEXTAREA><BR>";
        retString+="<B>Keywords:</B><INPUT size=200 name=\"keywords\" value=\""+keywords+"\"></INPUT><BR>";
        retString+="<B>View</B><SELECT name=\"view\" >";
        retString+="<OPTION value=\"\" "+ (view.equals("")?"SELECTED":"")+"></OPTION>";
        retString+="<OPTION value=\"corp\" "+ (view.equals("corp")?"SELECTED":"")+">Global</OPTION>";
        retString+="<OPTION value=\"us\" "+ (view.equals("us")?"SELECTED":"")+">US</OPTION>";
        retString+="</SELECT><br>";
    
        retString+="<INPUT class='btn' type=\"submit\" value=\"SUBMIT\" /><br>";
        retString+="</FORM></fieldset><br><br>";
        
        return(retString);
    }

public static String addSuggestion(Session jcrSession, String view, String title, String link, boolean newWin,String summary, String keywords){
String ret="";
   try{
   
    
    String page="";
    if(view.equals("us"))page="/content/accessmcd/na/us/util/searchsuggestions";
    if(view.equals("corp"))page="/content/accessmcd/corp/util/searchsuggestions";
    if(page.equals(""))return ret;
    
    javax.jcr.Node parentNode=jcrSession.getNode(page+"/jcr:content/maincontentpara");
  
    

       javax.jcr.Node destPar=null;
       int parcount=0;
       while(parcount<1000){
           if(!parentNode.hasNode("searchsuggestion"+parcount))break;
           parcount++;
       }
       
       destPar=parentNode.addNode("searchsuggestion"+parcount,"nt:unstructured");
       //destPar.setProperty(JcrConstants.JCR_ENCODING, "UTF-8");
       JcrUtil.setProperty(destPar,"sling:resourceType","mcd/components/content/searchsuggestion"); 
       JcrUtil.setProperty(destPar,"suggestion",title); 
       JcrUtil.setProperty(destPar,"sitelink",link); 
       JcrUtil.setProperty(destPar,"summary",summary); 
       if(newWin)JcrUtil.setProperty(destPar,"newWindow",true);
       
       //parse keywords
       if(keywords.startsWith("|"))keywords=keywords.substring(1);
       JcrUtil.setProperty(destPar,"keywords",keywords.split("\\,"));
       
       //destPar.setProperty("keywords",keywords);
       
       jcrSession.save();
       ret="NODE ADDED: searchsuggestion"+parcount;
        
   }catch(Exception e){
   }
   
   return ret;
   
}
%>
<%
Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);

//javax.jcr.Node parentNode=jcrSession.getNode("/content/accessmcd/corp/util/searchsuggestions/jcr:content"); 
//javax.jcr.Node parentNode=jcrSession.getNode("/content/accessmcd/na/mcweb/fr/util/searchsuggestions/jcr:content");
//javax.jcr.Node parentNode=jcrSession.getNode("/content/accessmcd/apmea/nz/util/searchsuggestions/jcr:content");

javax.jcr.Node parentNode=jcrSession.getNode("/content/accessmcd/na/us/util/searchsuggestions/jcr:content");





String pmTitle=request.getParameter("title");
String pmURL=request.getParameter("url");
String pmDescription=request.getParameter("description");
String pmKeywords=request.getParameter("keywords");
String pmNewWindow=request.getParameter("newWindow");
String pmView=request.getParameter("view");

boolean boolNewWindow=false;

if(pmTitle==null)pmTitle="";
if(pmURL==null)pmURL="";
if(pmDescription==null)pmDescription="";
if(pmKeywords==null)pmKeywords="";
if(pmNewWindow!=null)boolNewWindow=true;
if(pmView==null)pmView="";

javax.jcr.Node   destPar=parentNode.addNode("maincontentpara","nt:unstructured");
JcrUtil.setProperty(destPar,"sling:resourceType","/apps/mcd/components/content/parsys"); 
  





String strForm=getSuggestionForm(pmTitle, pmURL,boolNewWindow, pmDescription, pmKeywords, pmView);
if(!pmView.equals(""))out.println(addSuggestion(jcrSession,pmView,pmTitle,pmURL,boolNewWindow,pmDescription,pmKeywords)); 
out.println(strForm);






 %>
 </body>