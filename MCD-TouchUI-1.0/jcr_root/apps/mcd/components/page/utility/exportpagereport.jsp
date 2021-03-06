<%@ page contentType="application/vnd.ms-excel"%>
<%@ page import="java.util.Calendar,
        java.util.Locale,
        java.text.SimpleDateFormat,
        java.util.Iterator,
        com.day.cq.dam.api.*,
        org.apache.jackrabbit.util.Text,
        com.mcd.accessmcd.ace.manager.ACEManager,
        java.text.DecimalFormat,
        org.apache.sling.api.resource.ResourceResolver,
        com.mcd.accessmcd.ace.bo.ACEConfigDataBean"%>
                                
<%@include file="/apps/mcd/global/global.jsp" %>

<style type="text/css">
body{
    font-family: verdana,sans-serif,arial;
    font-size:14px;
}
h3{
    text-align:center;
    text-decoration:underline;
    font-size:20px;
    /*color: #005ACC;*/
}
input.formbutton
{  
   font-family:verdana,sans-serif;
   font-weight:bold;
   color:#FFFFFF;
   background-color:#0077BB;
}
table.pagetable {
    border-width: 1px 1px 1px 1px;
    border-spacing: 0px;
    border-style: solid solid solid solid;
    border-color: black black black black;
    border-collapse: collapse;
}
table.dampagetable {
    border-width: 1px 1px 1px 1px;
    border-spacing: 0px;
    border-style: solid solid solid solid;
    border-color: black black black black;
    border-collapse: collapse;
}
table.pagetable th {
    font-weight:bold;
    border-width: 1px 1px 1px 1px;
    padding: 5px 5px 5px 5px;
    border-style: solid solid solid solid;
    background-color: #EEEEEE;
    color: #802A2A;
    font-size: 12px;
}
table.dampagetable th {
    font-weight:bold;
    border-width: 1px 1px 1px 1px;
    padding: 5px 5px 5px 5px;
    border-style: solid solid solid solid;
    background-color: #EEEEEE;
    color: #802A2A;
    font-size: 12px;
}
table.pagetable td {
    font-size: 11px;
    border-width: 1px 1px 1px 1px;
    padding: 5px 5px 5px 5px;
    border-style: dotted dotted dotted dotted;
}
table.dampagetable td {
    font-size: 11px;
    border-width: 1px 1px 1px 1px;
    padding: 5px 5px 5px 5px;
    border-style: dotted dotted dotted dotted;
}
.nowrap{
    white-space:nowrap;
}
.rightAlign{
    text-align:right;
}
.error
{
 border:1px solid red;
}
</style>

<%!
int count;
Node metadataNode;
/** Manual Method **/  
/* This method is used to find the no of days between the given dates */  
public static long daysBetween_manaul(long dateEarly, long dateLater) {  
  return ( (dateLater/ (24 * 60 * 60 * 1000)) - (dateEarly/ (24 * 60 * 60 * 1000)) );  
}
  
/** Using Calendar - CURRENTLY NOT IN USE**/  
public static long daysBetween(Calendar startDate, Calendar endDate) {    
     
  Calendar date = (Calendar) startDate.clone();  
  long daysBetween = 0;  
  while (date.before(endDate)) {  
    date.add(Calendar.DAY_OF_MONTH, 1);  
    daysBetween++;  
  }  
  return daysBetween;  
} 

/* Returns the Date String in requested Display Format */
public String displayDateAs(String displayFormat, long displayDate){        
    //Default Display Format
    if("".equals(displayFormat)){
        displayFormat = "dd/MM/yyyy HH:mm:ss";
    }    
    SimpleDateFormat sdf =new SimpleDateFormat(displayFormat,Locale.US);
    return sdf.format(displayDate);
}

/* To render the Page Report Table */
public String drawChildTree (Page rootPage, long tm_cutdate, HttpServletRequest request,String reportType){
    StringBuffer outBuffer = new StringBuffer("");
    if (rootPage != null) {
        // code to retirieve the child pages of the selected page in the itertor object
        Iterator<Page> children = rootPage.listChildren();       
        try {
            while (children.hasNext()) {
                Page child = children.next();               
                             
                String expireDate = child.getProperties().get("offTime",String.class);
                String lastReplicated = child.getProperties().get("cq:lastReplicated",String.class);
                String lastReplicationAction = child.getProperties().get("cq:lastReplicationAction",String.class);                
                String pageAuthor = "";
                String contentAuthorEmail = "";
                String siteOwnerEmail = "";
                if("acereport".equalsIgnoreCase(reportType)){
                    pageAuthor = child.getProperties().get("authorName","");
                }    
                else if("siteowner".equalsIgnoreCase(reportType)){
                    pageAuthor = child.getProperties().get("siteOwnerName","");
                    siteOwnerEmail = child.getProperties().get("siteOwnerEmail","");
                }
                else if("contentauthor".equalsIgnoreCase(reportType)){
                    pageAuthor = child.getProperties().get("authorName","");
                    contentAuthorEmail = child.getProperties().get("authorEmail","");
                }      
                
                String pageTitle = child.getNavigationTitle();
                if (pageTitle == null || pageTitle.equals("")) {
                    pageTitle = child.getPageTitle();
                }
                if (pageTitle == null || pageTitle.equals("")) {
                    pageTitle = child.getTitle();
                }
                if (pageTitle == null || pageTitle.equals("")) {
                    pageTitle = child.getName();
                }
                
                // To get the Domain Address and Date Format for the Page / Site
                ACEManager aceManager = new ACEManager();
                ACEConfigDataBean aceBean = aceManager.getACEConfigBean(aceManager.getACESitePageKey(child.getPath(),true));    
                String domainAdd = aceBean.getPubDomainAdd();
                String dateFormat = aceBean.getDateFormat();
                
                long tm_expireDate = -1L;                
                if(child.getProperties().get("offTime",Calendar.class)!=null){
                    Calendar cal_expireDate = child.getProperties().get("offTime",Calendar.class);
                    tm_expireDate = cal_expireDate.getTimeInMillis();
                    expireDate = displayDateAs(dateFormat,tm_expireDate);
                }else{
                    expireDate = "";
                }                
                                
                long tm_lastReplicated = -1L;
                if(child.getProperties().get("cq:lastReplicated",Calendar.class)!=null){
                    Calendar cal_lastReplicated = child.getProperties().get("cq:lastReplicated",Calendar.class);
                    tm_lastReplicated = cal_lastReplicated.getTimeInMillis();
                    lastReplicated = displayDateAs(dateFormat,tm_lastReplicated);
                }
                
                if("Activate".equals(lastReplicationAction)){
                    String style = "";    
                    if(tm_cutdate > tm_expireDate){             
                        style = "style=\"color:red;background-color:pink;\"";
                    }
                                                                        
                    String pathtoinclude=child.getPath();                        
                    pathtoinclude = pathtoinclude.replace("/content/","/");
                                                                                                                                            
                    
                    if("acereport".equalsIgnoreCase(reportType)){
                        outBuffer.append("<tr>");
                        outBuffer.append("<td>" + ++count +"</td>");
                        if(!("".equals(domainAdd))){
                            String pageURL = domainAdd + pathtoinclude + ".html";
                            outBuffer.append("<td style=\"white-space:normal\"><a href='"+ pageURL +"'>"+ pageURL +"</a></td>");                            
                        }else{
                            outBuffer.append("<td style=\"white-space:normal\">"+ pathtoinclude +"</td>");
                        }
                        outBuffer.append("<td>"+ pageTitle +"</td>");
                        outBuffer.append("<td>"+ pageAuthor +"</td>");
                        outBuffer.append("<td class='nowrap'>"+expireDate+ "</td>"); 
                        if(!("".equals(expireDate))){
                            outBuffer.append("<td "+style+" class='rightAlign'>"+ daysBetween_manaul(tm_cutdate,tm_expireDate) + "</td>");
                        }else{
                            outBuffer.append("<td class='rightAlign'>"+ "" +"</td>");
                        }
                        outBuffer.append("<td class='nowrap'>"+lastReplicated+ "</td>");                    
                        outBuffer.append("<td class='rightAlign'>"+ daysBetween_manaul(tm_lastReplicated,tm_cutdate) + "</td>");
                        outBuffer.append("</tr>");
                    }
                    else if("siteowner".equalsIgnoreCase(reportType)){
                        if(!"".equalsIgnoreCase(pageAuthor.trim())){
                            outBuffer.append("<tr>");
                            outBuffer.append("<td>" + ++count +"</td>");
                            if(!("".equals(domainAdd))){
                                String pageURL = domainAdd + pathtoinclude + ".html";
                                outBuffer.append("<td style=\"white-space:normal\"><a href='"+ pageURL +"'>"+ pageURL +"</a></td>");                            
                            }else{
                                outBuffer.append("<td style=\"white-space:normal\">"+ pathtoinclude +"</td>");
                            }
                            outBuffer.append("<td>"+ pageTitle +"</td>");
                            outBuffer.append("<td width='10%'>"+ pageAuthor +"</td>");
                            outBuffer.append("<td class='nowrap' width='10%'>"+siteOwnerEmail+ "</td>");
                            outBuffer.append("</tr>");
                        }     
                    }
                    else if("contentauthor".equalsIgnoreCase(reportType)){
                        if(!"".equalsIgnoreCase(pageAuthor.trim())){
                            outBuffer.append("<tr>");
                            outBuffer.append("<td>" + ++count +"</td>");
                            if(!("".equals(domainAdd))){
                                String pageURL = domainAdd + pathtoinclude + ".html";
                                outBuffer.append("<td style=\"white-space:normal\"><a href='"+ pageURL +"'>"+ pageURL +"</a></td>");                            
                            }else{
                                outBuffer.append("<td style=\"white-space:normal\">"+ pathtoinclude +"</td>");
                            }
                            outBuffer.append("<td>"+ pageTitle +"</td>");
                            outBuffer.append("<td width='10%'>"+ pageAuthor +"</td>");
                            outBuffer.append("<td class='nowrap' width='10%'>"+contentAuthorEmail+ "</td>");
                            outBuffer.append("</tr>");
                        }    
                    }       
                    
                }
                outBuffer.append(drawChildTree(child,tm_cutdate,request,reportType));
            }
        } finally {         
             
        }
    }
    // return the html code as string //
    return outBuffer.toString();
}

/*TO render DAM Age Report */
public String damdrawChildTree (Node rootNode, long tm_cutdate, HttpServletRequest request,String reportType, Node metadataNode, ResourceResolver resourceResolver, SlingHttpServletRequest slingRequest)throws RepositoryException
{
    StringBuffer outBuffer = new StringBuffer("");
   
   
    
    if (rootNode != null) 
    {  
        // code to retirieve the child pages of the selected page in the itertor object
       if(rootNode.isNodeType("sling:OrderedFolder"))
       {
          Iterator<Node> damchildren = rootNode.getNodes();   
          try 
          { 
               while (damchildren.hasNext()) 
               {
                   Node damchild = damchildren.next();
                   DamManager damManager = resourceResolver.adaptTo(DamManager.class);
                   Session session = slingRequest.getResourceResolver().adaptTo(Session.class);
                   
                   if((damchild.isNodeType("dam:Asset"))&&(damchild.getPath().indexOf("/jcr:content")==-1))    
                   { 
                       Node jcrNode = slingRequest.getResourceResolver().getResource(damchild.getPath()+"/jcr:content").adaptTo(Node.class);
                       metadataNode = slingRequest.getResourceResolver().getResource(damchild.getPath()+"/jcr:content/metadata").adaptTo(Node.class);
                      
                       String lastReplicated ="";
                       String lastReplicationAction ="";
                       String pageAuthor = "";
                       String contentAuthorEmail = "";
                       String siteOwnerEmail = "";
                       String expireDate ="";
                       String pathtoinclude ="";
                       String assetUrl="";
                       String assetURL = "";
                       int countnode=0;
                      
                       /*fetching the properties lastReplicated and lastReplicationAction*/
                       if(jcrNode.hasProperty("cq:lastReplicated"))
                             lastReplicated = jcrNode.getProperty("cq:lastReplicated").getString();
                         
                       if(jcrNode.hasProperty("cq:lastReplicationAction"))
                             lastReplicationAction = jcrNode.getProperty("cq:lastReplicationAction").getString();                
                      /*end of fetching the properties lastReplicated and lastReplicationAction*/     
                      
                      
                      /*fetching properties Name and Email address of Asset author, Content author and Siteowner  */
                       if("damacereport".equalsIgnoreCase(reportType))
                       {
                            if(metadataNode.hasProperty("authname"))
                                  pageAuthor = metadataNode.getProperty("authname").getString();
                       }    
                       else if("damsiteowner".equalsIgnoreCase(reportType))
                       {
                            if(metadataNode.hasProperty("siteownername"))
                                   pageAuthor = metadataNode.getProperty("siteownername").getString();
                            if(metadataNode.hasProperty("siteowneremail"))
                                    siteOwnerEmail = metadataNode.getProperty("siteowneremail").getString();
                       }
                       else if("damcontentauthor".equalsIgnoreCase(reportType))
                        {
                            if(metadataNode.hasProperty("authname"))
                                pageAuthor = metadataNode.getProperty("authname").getString();
                            if(metadataNode.hasProperty("authemail"))     
                                contentAuthorEmail = metadataNode.getProperty("authemail").getString();
                        }
                       /*end of fetching properties Name and Email address*/
                       
                       /*fetching title of the asset*/
                       String pageTitle="";
                       if(metadataNode.hasProperty("dc:title"))
                        {
                           pageTitle = metadataNode.getProperty("dc:title").getString();
                        } 
                        else
                        {
                           if (pageTitle == null || pageTitle.equals("")) 
                                    pageTitle = damchild.getName();
                        }
                       /*end of fetching Asset title*/
                        
                       // To get the Domain Address and Date Format for the Page / Site
                      /* String domainAdd = "https://www1-int.accessmcd.com";
                       String dateFormat = "MM.dd.yyyy HH:mm:ss";
                      */
                        ACEManager aceManager = new ACEManager();
                        ACEConfigDataBean aceBean = aceManager.getACEConfigBean(aceManager.getACESitePageKey(damchild.getPath(),true));    
                        String domainAdd = aceBean.getPubDomainAdd();
                        String dateFormat = aceBean.getDateFormat();
                        
                        
                      /*Generating table for only activated assets*/
                        if("Activate".equals(lastReplicationAction))
                        {
                            
                            /* to get the size of the asset*/
                             double renditionSize =0;
                             String fileSize="bytes";
                             DecimalFormat df = new DecimalFormat("###.##");

                            String assetBinaryPath = (damchild.getPath()).replaceFirst("/content","/var");
                            Asset asset = damManager.createAssetStructure(assetBinaryPath,session,true);
                            Rendition assetDAMRendition = asset.getCurrentOriginal();
                            if(assetDAMRendition!=null)
                            {
                                renditionSize = (assetDAMRendition.getSize());
                                if(renditionSize>(1024*1024*1024))
                                {
                                    renditionSize= (double)renditionSize/(1024*1024*1024);
                                    fileSize= "GB";
                                }
                                else if(renditionSize>(1024*1024))
                                {
                                    renditionSize= (double)(renditionSize)/(1024*1024);
                                    fileSize= "MB";
                                }
                                else if(renditionSize>1024)
                                {
                                    renditionSize= (double)(renditionSize/1024);
                                    fileSize= "KB";
                                }
                                else
                                {
                                    fileSize= "bytes";
                                }
                               
                            }
                           /*end of code to get the file size*/
                            
                           /*fetching the offtime of the Asset*/
                            long tm_expireDate = -1L;      
                           if(jcrNode.hasProperty("offTime"))
                           {    
                               if(jcrNode.getProperty("offTime").getDate()!=null)
                                {
                                    Calendar cal_expireDate = jcrNode.getProperty("offTime").getDate();
                                    tm_expireDate = cal_expireDate.getTimeInMillis();
                                    expireDate = displayDateAs(dateFormat,tm_expireDate);
                                }
                                else
                                    expireDate = "";
                           } 
                           /*end of fetching offTime*/
                            
                            long tm_lastReplicated = -1L;
                            if(jcrNode.hasProperty("cq:lastReplicated"))
                            {
                                if(jcrNode.getProperty("cq:lastReplicated").getDate()!=null)
                                {
                                    Calendar cal_lastReplicated = jcrNode.getProperty("cq:lastReplicated").getDate();
                                    tm_lastReplicated = cal_lastReplicated.getTimeInMillis();
                                    lastReplicated = displayDateAs(dateFormat,tm_lastReplicated);
                                 
                                }
                             }
                             
                             
                            String style = "";    
                            if(tm_cutdate > tm_expireDate)
                            {             
                                style = "style=\"color:red;background-color:pink;\"";
                            }
                             
                            pathtoinclude=jcrNode.getPath();  
                            pathtoinclude = pathtoinclude.replace("/content/","/");
                             
                            if("damacereport".equalsIgnoreCase(reportType))
                            {
                                outBuffer.append("<tr>");
                                outBuffer.append("<td>" + ++count +"</td>");
                                if(!("".equals(domainAdd)))
                                {
                                    assetUrl = domainAdd + pathtoinclude;
                                    int m = assetUrl.lastIndexOf("/jcr:content");
                                   
                                    assetURL= assetUrl.substring(0,m);
                                    outBuffer.append("<td style=\"white-space:normal\"><a href='"+ assetURL +"'>"+ assetURL +"</a></td>");                            
                                }else
                                {
                                    outBuffer.append("<td style=\"white-space:normal\">"+ pathtoinclude +"</td>");
                                }
                                outBuffer.append("<td>"+ pageTitle +"</td>");
                                outBuffer.append("<td>"+ pageAuthor +"</td>");
                                outBuffer.append("<td class='nowrap'>"+expireDate+ "</td>"); 
                                if(!("".equals(expireDate)))
                                {
                                    outBuffer.append("<td "+style+" class='rightAlign'>"+ daysBetween_manaul(tm_cutdate,tm_expireDate) + "</td>");
                                }else
                                {
                                    outBuffer.append("<td class='rightAlign'>"+ "" +"</td>");
                                }
                                outBuffer.append("<td class='nowrap'>"+lastReplicated+ "</td>");                    
                                outBuffer.append("<td class='rightAlign'>"+ daysBetween_manaul(tm_lastReplicated,tm_cutdate) + "</td>");
                                outBuffer.append("<td>"+df.format(renditionSize)+"&nbsp;"+fileSize+"</td>");
                                outBuffer.append("</tr>"); 
                             }
                            else if("damsiteowner".equalsIgnoreCase(reportType))
                            {
                                if(!"".equalsIgnoreCase(pageAuthor.trim()))
                                {
                                    outBuffer.append("<tr>");
                                    outBuffer.append("<td>" + ++count +"</td>");
                                    if(!("".equals(domainAdd)))
                                    {
                                    assetUrl = domainAdd + pathtoinclude;
                                    int m = assetUrl.lastIndexOf("/jcr:content");
                                    assetURL= assetUrl.substring(0,m);
                                    outBuffer.append("<td style=\"white-space:normal\"><a href='"+ assetURL +"'>"+ assetURL +"</a></td>");                            
                                    }
                                    else
                                    {
                                        outBuffer.append("<td style=\"white-space:normal\">"+ pathtoinclude +"</td>");
                                    } 
                                    outBuffer.append("<td>"+ pageTitle +"</td>");
                                    outBuffer.append("<td width='10%'>"+ pageAuthor +"</td>");
                                    outBuffer.append("<td class='nowrap' width='10%'>"+siteOwnerEmail+ "</td>");
                                     outBuffer.append("<td>"+df.format(renditionSize)+"&nbsp;"+fileSize+"</td>");
                                    outBuffer.append("</tr>");
                                }    
                            }  
                            else if("damcontentauthor".equalsIgnoreCase(reportType))
                            {
                                if(!"".equalsIgnoreCase(pageAuthor.trim()))
                                {
                                    outBuffer.append("<tr>");
                                    outBuffer.append("<td>" + ++count +"</td>");
                                    if(!("".equals(domainAdd)))
                                    {
                                    assetUrl = domainAdd + pathtoinclude;
                                    int m = assetUrl.lastIndexOf("/jcr:content");
                                    assetURL= assetUrl.substring(0,m);
                                    outBuffer.append("<td style=\"white-space:normal\"><a href='"+ assetURL +"'>"+ assetURL +"</a></td>");                            
                                    }
                                    else
                                    {
                                        outBuffer.append("<td style=\"white-space:normal\">"+ pathtoinclude +"</td>");
                                    }
                                    outBuffer.append("<td>"+ pageTitle +"</td>");
                                    outBuffer.append("<td width='10%'>"+ pageAuthor +"</td>");
                                    outBuffer.append("<td class='nowrap' width='10%'>"+contentAuthorEmail+ "</td>");
                                     outBuffer.append("<td>"+df.format(renditionSize)+"&nbsp;"+fileSize+"</td>");
                                    outBuffer.append("</tr>");
                                }    
                            }    
                            
                        }
                       }
                       outBuffer.append(damdrawChildTree(damchild,tm_cutdate,request,reportType,metadataNode,resourceResolver,slingRequest));
                    
                }
             }catch(Exception e){}
              }
       }  
     // return the html code as string //
    return outBuffer.toString();
}

%>

<%
    
        
    String rootPath = (String) request.getParameter("rootPath");
    if( (!(rootPath != null)) || (!(rootPath.length() > 0)) ){
            rootPath = "";
    }
    String reportType = "";
    if(null != request.getParameter("reportType")){
        reportType = request.getParameter("reportType");
    }
     String textValue = "";
    if(null != request.getParameter("textValue")){
        textValue = request.getParameter("textValue");
    }
    
    
                    
    count=0;
    Calendar cal_lastcutdate = Calendar.getInstance();
    long tm_lastcutdate = cal_lastcutdate.getTimeInMillis();
    String lastcutdate = displayDateAs("MM.dd.yyyy HH:mm:ss",tm_lastcutdate);
    if(textValue.startsWith("/content/accessmcd"))
    {
        if("acereport".equalsIgnoreCase(reportType)){
            response.setHeader("Content-Disposition", "attachment; filename=\"AccessMCD-PageAgeReport.xls\"");
            out.println("Content Pages AGE under <b>"+textValue+"</b> as on <b>"+ lastcutdate +"</b> [MM.dd.yyyy HH:mm:ss] <br><br>");
        }    
        else if("siteowner".equalsIgnoreCase(reportType)){
            response.setHeader("Content-Disposition", "attachment; filename=\"AccessMCD-SiteOwnerReport.xls\"");  
            out.println("Site Owner report under <b>"+textValue+"</b> as on <b>"+ lastcutdate +"</b> [MM.dd.yyyy HH:mm:ss] <br><br>");
        }
        else if("contentauthor".equalsIgnoreCase(reportType)){
            response.setHeader("Content-Disposition", "attachment; filename=\"AccessMCD-ContentAuthorReport.xls\"");  
            out.println("Content Author report under <b>"+textValue+"</b> as on <b>"+ lastcutdate +"</b> [MM.dd.yyyy HH:mm:ss] <br><br>");
        }    
        
         Page rootPage = slingRequest.getResourceResolver().adaptTo(PageManager.class).getPage(textValue);
         %>
         <table class="pagetable" width="100%" cellpadding="0" cellspacing="1" border="1">
            <tr>
        <%            
            if("acereport".equalsIgnoreCase(reportType)){
        %>
                <th>S. No</th>
                <th>Page URL</th>
                <th>Page Title</th>
                <th>Author Name</th>
                <th>Expiration Date</th>
                <th># Of Days Until Page Expiration</th>
                <th>Date Last Activated</th>
                <th># Of Days Since Page Last Activated</th>
        <% 
                out.println(drawChildTree(rootPage,tm_lastcutdate,request,reportType));
            }
            else if("siteowner".equalsIgnoreCase(reportType)){
        %>           
                <th>S. No</th>
                <th>Page URL</th>
                <th>Page Title</th>
                <th>Site Owner Name</th>
                <th>Site Owner Email</th>
        <%
                out.println(drawChildTree(rootPage,tm_lastcutdate,request,reportType));
            }
            else if("contentauthor".equalsIgnoreCase(reportType)){
        %>           
                <th>S. No</th>
                <th>Page URL</th>
                <th>Page Title</th>
                <th>Content Author Name</th>
                <th>Content Author Email</th>
        <%
                out.println(drawChildTree(rootPage,tm_lastcutdate,request,reportType));
            }
        %>
            </tr>
        </table> 
<%        
    }
    else if(textValue.startsWith("/content/dam/accessmcd")) 
    {
        if("damacereport".equalsIgnoreCase(reportType)){
            response.setHeader("Content-Disposition", "attachment; filename=\"AccessMCD-DAMAgeReport.xls\"");
            out.println("DAM AGE under <b>"+textValue+"</b> as on <b>"+ lastcutdate +"</b> [MM.dd.yyyy HH:mm:ss] <br><br>");
        }    
        else if("damsiteowner".equalsIgnoreCase(reportType)){
            response.setHeader("Content-Disposition", "attachment; filename=\"AccessMCD-DAMSiteOwnerReport.xls\"");  
            out.println("Site Owner report under <b>"+textValue+"</b> as on <b>"+ lastcutdate +"</b> [MM.dd.yyyy HH:mm:ss] <br><br>");
        }
        else if("damcontentauthor".equalsIgnoreCase(reportType)){
            response.setHeader("Content-Disposition", "attachment; filename=\"AccessMCD-DAMContentAuthorReport.xls\"");  
            out.println("Content Author report under <b>"+textValue+"</b> as on <b>"+ lastcutdate +"</b> [MM.dd.yyyy HH:mm:ss] <br><br>");
        }    
        
        Node rootNode = slingRequest.getResourceResolver().getResource(textValue).adaptTo(Node.class);
        %>
            <table class="dampagetable" width="100%" cellpadding="0" cellspacing="1" border="1">
                <tr>
                 <% if("damacereport".equalsIgnoreCase(reportType))
                    {
                    %>
                        <th>S. No</th>
                        <th>Asset URL</th>
                        <th>Asset Title</th>
                        <th>Author Name</th>
                        <th>Expiration Date</th>
                        <th># Of Days Until Asset Expiration</th>
                        <th>Date Last Activated</th>
                        <th># Of Days Since Asset Last Activated</th>
                        <th>File Size(in Bytes)</th>
                    <% 
                        out.println(damdrawChildTree(rootNode,tm_lastcutdate,request,reportType,metadataNode,resourceResolver,slingRequest));
                           
                     }
                     else if("damsiteowner".equalsIgnoreCase(reportType))
                     {
                     %>           
                        <th>S. No</th>
                        <th>Asset URL</th>
                        <th>Asset Title</th>
                        <th>Site Owner Name</th>
                        <th>Site Owner Email</th>
                        <th>File Size(in Bytes)</th>   
                      <%
                          out.println(damdrawChildTree(rootNode,tm_lastcutdate,request,reportType,metadataNode,resourceResolver,slingRequest));
                        
                     }
                     else if("damcontentauthor".equalsIgnoreCase(reportType))
                     {
                     %>           
                        <th>S. No</th>
                        <th>Asset URL</th>
                        <th>Asset Title</th>
                        <th>Content Author Name</th>
                        <th>Content Author Email</th>
                        <th>File Size(in Bytes)</th>
                     <%
                         out.println(damdrawChildTree(rootNode,tm_lastcutdate,request,reportType,metadataNode,resourceResolver,slingRequest));
                     }%>
                  </tr>
           </table>
  <%}%>   
