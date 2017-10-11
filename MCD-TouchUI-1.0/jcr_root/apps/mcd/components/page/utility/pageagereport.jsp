<HTML>
<%@ page import="java.util.Calendar,
        java.util.Locale,
        java.text.SimpleDateFormat,
        java.util.Iterator,
        java.lang.System.*,
        org.apache.jackrabbit.util.Text,
        com.mcd.accessmcd.ace.manager.ACEManager,
        com.mcd.accessmcd.ace.bo.ACEConfigDataBean,
        com.day.cq.security.*,
        java.util.*,
        org.apache.sling.commons.json.JSONObject,
        java.net.URISyntaxException,
        java.net.URL,
        java.io.InputStream,
        java.io.BufferedReader,
        java.io.InputStreamReader,
        java.nio.charset.Charset,
        java.io.Reader,
        java.io.Writer,
        java.text.DecimalFormat,
        java.io.IOException,
        com.day.cq.dam.api.*,
        org.apache.sling.commons.json.JSONArray,
        org.apache.sling.commons.json.JSONException,
        org.apache.sling.api.resource.ResourceResolver,
        java.net.URLConnection,
        java.net.HttpURLConnection,
        com.mcd.accessmcd.usermanagement.user.manager.UserMaintenanceManager, 
        com.mcd.accessmcd.usermanagement.user.bo.GroupDataBean"%>

    
                                                                                
<%@include file="/apps/mcd/global/global.jsp" %>
<head>
 <script src="/etc/designs/mcd/accessmcd/corelibs/core/js/jquery-1.3.2.min.js"></script>
<title>ACE Report Utility</title>
<style type="text/css">
body{
    font-family: verdana,sans-serif,arial;
    font-size:14px;
    width:1700px;
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
    word-break:break-word;
    
}
table.dampagetable th {
    font-weight:bold;
    border-width: 1px 1px 1px 1px;
    padding: 5px 5px 5px 5px;
    border-style: solid solid solid solid;
    background-color: #EEEEEE;
    color: #802A2A;
    font-size: 12px;
    word-break:break-word;
}
table.pagetable td {
    font-size: 11px;
    border-width: 1px 1px 1px 1px;
    padding: 5px 5px 5px 5px;
    border-style: solid solid solid solid;
    white-space:normal;
    word-break:break-word;
}
table.dampagetable td {
    font-size: 11px;
    border-width: 1px 1px 1px 1px;
    padding: 5px 5px 5px 5px;
    border-style: solid solid solid solid;
    white-space:normal;
    word-break:break-word;
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
</head>

<body>

<%!
int count;
Node metadataNode;
String[] restrictSites = {"/content/dam/accessmcd",
                          "/content/accessmcd"
                          };
   /* if(restrictSites[j].equals("/content/dam/accessmcd"))
                        
                    else if(restrictSites[j].equals("/content/accessmcd"))
*/
/** Manual Method **/  
/* This method is used to find the no of days between the given dates */  
public static long daysBetween_manaul(long dateEarly, long dateLater) {  
  return ( (dateLater/ (24 * 60 * 60 * 1000)) - (dateEarly/ (24 * 60 * 60 * 1000)) );  
}
  
/** Using Calendar - CURRENTLY NOT IN USE**/  
public static long daysBetween(Calendar startDate, Calendar endDate) {    
  /*
  Calendar dialogOfftime = Calendar.getInstance();
  dialogOfftime.setTimeInMillis(dialogOfftime_L);
  */    
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
   InputStream is = null;
    BufferedReader rd = null;
   
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
                String pageURL ="";
             
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
                            pageURL = domainAdd + pathtoinclude + ".html";
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
                            pageURL = domainAdd + pathtoinclude + ".html";
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
                            pageURL = domainAdd + pathtoinclude + ".html";
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
                           ACEManager aceManager = new ACEManager();
                           ACEConfigDataBean aceBean = aceManager.getACEConfigBean(aceManager.getACESitePageKey(damchild.getPath(),true));    
                           String domainAdd = aceBean.getPubDomainAdd();//"https://www1-int.accessmcd.com";
                           String dateFormat = aceBean.getDateFormat();//"MM.dd.yyyy HH:mm:ss";
                          
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

public boolean checkRestrictSites(String curPage){
        boolean rt = false;
        if(restrictSites!=null){
            for (int j = 0; j < restrictSites.length; j++) 
            {                           
                 if(curPage.equals(restrictSites[j])){                                                        
                    rt=true;
                }
             }  
        }
        return rt;
}

public boolean isAceSite(ArrayList userGrpList,String textValue,Writer out)throws IOException{
   // StringBuffer outBuffer = new StringBuffer("");
    boolean rt = false;// get ACE site keys    
    ACEManager aceManager = new ACEManager();
    Enumeration allURLs = aceManager.getAllSiteKeys();
    while(allURLs.hasMoreElements())
    {
        String theURL = (String)allURLs.nextElement();
       
        if (!checkRestrictSites(theURL)) {    
          
            ACEConfigDataBean aceBean = aceManager.getACEConfigBean(theURL);
            
            if(userGrpList.contains(aceBean.getGroupName()) ) {
            
                if( (textValue.equals(theURL)) || (textValue.indexOf(theURL+"/")>-1) ){
                    
                    rt=true;
                }
                
            }
        }
    }
    
    return rt;
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
    
    /*if(!(rootPath.trim()).equals(textValue.trim()))
       rootPath=textValue;*/
       
        
    // Get groups of logged in user    
    User loggedInUser = slingRequest.getResourceResolver().adaptTo(User.class);
    String loggedInUserID = loggedInUser.getID();    
       
    final UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
    ResourceBundle bundle = slingRequest.getResourceBundle(request.getLocale());
    Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
    UserManager uMgr = userManagerFactory.createUserManager(jcrSession);
    UserMaintenanceManager umManager = new UserMaintenanceManager(sling, bundle, jcrSession, uMgr, resourceResolver);
    
    ArrayList grpArrList = umManager.getUserGroupsDetails(loggedInUserID);
    ArrayList userGrpList = new ArrayList();
    GroupDataBean grpBean = null;
    for(int i = 0 ; i < grpArrList.size() ; i++)
    {
        grpBean = (GroupDataBean)grpArrList.get(i);
        userGrpList.add(grpBean.getGroupID());
    }
    
    
    String errMsg = "";
    if(!(textValue.length() > 0) && "Please select report type".equals(reportType)){
        errMsg = "ERROR : Please enter a path for site<br>ERROR : Please select report type";
    }else if(!(textValue.length() > 0) && "Please select report type".equals(reportType)){
        errMsg = "ERROR : Please enter a path for site<br>ERROR : Please select report type";
    }else if(!((textValue.length() > 0) || "Please select report type".equals(reportType))){
        errMsg = "ERROR : Please enter a path for site";
    } else if("Please select report type".equals(reportType)){
        errMsg = "ERROR : Please select report type";
    }else if(("/content/dam/accessmcd".equals(rootPath))&&(!textValue.startsWith("/content/dam/accessmcd"))){
        errMsg = "Please enter valid DAM path";
    }else if(("/content/accessmcd".equals(rootPath))&&(!textValue.startsWith("/content/accessmcd"))){
        errMsg = "Please enter valid site path";
    }else if(!(loggedInUserID.equals("admin"))) {
        if(textValue.equals("/content/dam/accessmcd"))
        {
            String textValueDam = "";
            textValueDam = textValue.replace("/content/dam","/content");
            
            if ( (checkRestrictSites(textValueDam)) || (!isAceSite(userGrpList,textValueDam,out)))
           // if ( (checkRestrictSites(textValue)) || (!isAceSite(userGrpList,textValue,out)))
            {   out.println("userGrpList:"+userGrpList+"<br>"+"textValue:"+textValue);
                errMsg = "ERROR : Sorry, you are not allowed to execute the utility on " + textValue + ". Please enter a valid site path.";        
            }
         }
         else if(textValue.equals("/content/accessmcd"))
         {
             if ( (checkRestrictSites(textValue)) || (!isAceSite(userGrpList,textValue,out)))
            {   
                errMsg = "ERROR : Sorry, you are not allowed to execute the utility on " + textValue + ". Please enter a valid site path.";        
            }
         }
    }   
%>
<a name="top"></a>

<div style="width:100%;padding-top:5px;">
<img  src='/images/accessmcd.gif' />
</div>

<form id="report" name="report" action="#" style="margin-top: -45px;width:1700px">
    <input type="hidden" name="hidAction" value="Clear"/>
    <input type="hidden" id="errorMsg" name="errorMsg" value="<%=errMsg%>"/>
    
    <h3>ACE Report Utility</h3>
    <br>
    <p style="margin-top:-20px;text-align:center;">
       <i>The Report Utility will only list the pages that are in the activated state.</i>
    </p>
      
    <hr style="margin-top:-8px;">
    <br>
     
    <!--input type="hidden" name="rootPath" id="rootpathVal" value="<%=rootPath%>"-->
    <input type="radio" name="rootPath" id="rootpath1" value='/content/dam/accessmcd'> DAM Aging Report&nbsp;
    <input type="radio" name="rootPath" id="rootpath2" value='/content/accessmcd'> Content Pages Aging Report<br><br>
    <br><b>
    &nbsp;Enter the path for the site:&nbsp;&nbsp;</b>
    <input type="text" class="rootPathText" name="textValue" id="rootpath" value="<%=textValue%>" size="40px"></input>
   
        <select name="reportType" id="reportType">
            <option value="Please select report type">Please select report type</option>
            <option value="acereport">PAGES ACE Aging report</option>
            <option value="contentauthor">PAGES Content Author</option>
            <option value="siteowner">PAGES Site Owner</option>           
        </select>
        <br>
         <label id="rootpathdam" style="font-size:12px;color:#808080;">&nbsp;The path should start with "/content/dam/accessmcd".</label>
         <label id="rootpathpage" style="font-size:12px;color:#808080;">&nbsp;The path should start with "/content/accessmcd".</label>             
      <br>
         <label style="font-size:12px;color:#808080;"> &nbsp;<b>Note:</b> Please don't append .html to the path entered </label>
         <br>
      
    <%--<span><i style="font-size: 12px; padding-left: 10px;">DEFAULT : Absolute Parent at level 1</i></span>
    <br>--%><br>
    <input id="ShowInfo" class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='ShowInfo';" value="ShowInfo" />
    <input id="Clear" class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='Clear';" value="Clear" />
    <input id="Export" class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='Export';" value="Export To Excel" />
    <br><br>
    <hr style=""> 
       
<%  
    String hidAction = (String) request.getParameter("hidAction");
    if(hidAction != null) 
    {
      if(hidAction.equals("ShowInfo"))  
      {
        count=0;
        Calendar cal_lastcutdate = Calendar.getInstance();
        long tm_lastcutdate = cal_lastcutdate.getTimeInMillis();
        String lastcutdate = displayDateAs("MM.dd.yyyy HH:mm:ss",tm_lastcutdate);        
        
        if(errMsg.length() > 0)
        {
                out.println("<p id=\"errorid\" style=\"text-align:center;color:#ce0000\"><b><span style='margin-left:18px;'>" + errMsg + "</span></b></p>");
        }
        else if(textValue.startsWith("/content/accessmcd"))
        {
%>
            <div class="text">    
<%        
            if("acereport".equalsIgnoreCase(reportType)){
                out.println("<p style=\"margin-top:25px;font-size:12px;\">&nbsp;Content Pages AGE under <b>"+textValue+"</b> as on <b>"+ lastcutdate +"</b> [MM.dd.yyyy HH:mm:ss] </p>");
            }    
            else if("siteowner".equalsIgnoreCase(reportType)){
                out.println("<p style=\"margin-top:25px;font-size:12px;\">&nbsp;Site Owner report under <b>"+textValue+"</b> as on <b>"+ lastcutdate +"</b> [MM.dd.yyyy HH:mm:ss] </p>");
            }
            else if("contentauthor".equalsIgnoreCase(reportType)){
                out.println("<p style=\"margin-top:25px;font-size:12px;\">&nbsp;Content Author report under <b>"+textValue+"</b> as on <b>"+ lastcutdate +"</b> [MM.dd.yyyy HH:mm:ss] </p>");
            }  
            Page rootPage = slingRequest.getResourceResolver().adaptTo(PageManager.class).getPage(textValue);
%>
            <table class="pagetable" width="100%" border="0" cellpadding="0" cellspacing="0">
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
            </div> 
            <br>
            <div style="text-align:center"><a href="#top"><strong>Return to Top</strong></a><div>   
<%              
           }          
          else if(textValue.startsWith("/content/dam/accessmcd"))
              {
%>
                    <div class="damtext">    
<%                    
                    if("damacereport".equalsIgnoreCase(reportType))
                    {
                        out.println("<p style=\"margin-top:25px;font-size:12px;\">&nbsp;DAM AGE under <b>"+textValue+"</b> as on <b>"+ lastcutdate +"</b> [MM.dd.yyyy HH:mm:ss] </p>");
                    }    
                    else if("damsiteowner".equalsIgnoreCase(reportType))
                    {
                        out.println("<p style=\"margin-top:25px;font-size:12px;\">&nbsp;Site Owner report under <b>"+textValue+"</b> as on <b>"+ lastcutdate +"</b> [MM.dd.yyyy HH:mm:ss] </p>");
                    }    
                    else if("damcontentauthor".equalsIgnoreCase(reportType))
                    {
                        out.println("<p style=\"margin-top:25px;font-size:12px;\">&nbsp;Content Author report under <b>"+textValue+"</b> as on <b>"+ lastcutdate +"</b> [MM.dd.yyyy HH:mm:ss] </p>");
                    }  
                    
                    Node rootNode = null;
                    if(slingRequest.getResourceResolver().getResource(textValue)!=null)
                   {   rootNode = slingRequest.getResourceResolver().getResource(textValue).adaptTo(Node.class);
                   
  %>                
                    <table class="dampagetable" width="100%" border="0" cellpadding="0" cellspacing="0">
                      <tr>
<%            
                        if("damacereport".equalsIgnoreCase(reportType))
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
                            <th>File Size</th>
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
                            <th>File Size</th>   
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
                            <th>File Size</th>
<%
                            out.println(damdrawChildTree(rootNode,tm_lastcutdate,request,reportType,metadataNode,resourceResolver,slingRequest));
                        }
%>
                      </tr>
                   </table>
                  
              </div> 
            <br>
            <div style="text-align:center"><a href="#top"><strong>Return to Top</strong></a><div>   
            
<%            
                }
                else
                {
                    out.println("<p style=\"text-align:center;color:#ce0000\"><b> Please enter a valid DAM path </b></p>");
                }
            }
      } else if(hidAction.equals("Export")) {
         if(rootPath.startsWith("/content/accessmcd"))
         {    
              if(errMsg.length() > 0){
                out.println("<p id=\"errorid\" style=\"text-align:center;color:#ce0000\"><b>" + errMsg + "</b></p>");
            } else {
                String url = "/utility/utility.exportpagereport.html?rootPath="+rootPath+"&textValue="+textValue+"&reportType="+reportType;    
               // window.location.reload();
                response.sendRedirect(url);
            }
         }
         else if(rootPath.startsWith("/content/dam/accessmcd"))
         {
             if(errMsg.length() > 0){
                out.println("<p id=\"errorid\" style=\"text-align:center;color:#ce0000\"><b>" + errMsg + "</b></p>");
            } else {
                String url = "/utility/utility.exportpagereport.html?rootPath="+rootPath+"&textValue="+textValue+"&reportType="+reportType;    
                response.sendRedirect(url);
            }
         }
      }
   }   
   
   //for damAgeReport
   
   
%> 
</form>
<script>

$(document).ready(function() { 

$('input[name=rootPath]:second').attr('checked', true);
var reportType = "<%=reportType%>";
$("#rootpathdam").hide();
$("#rootpathpage").show()
if((reportType == "damacereport") || (reportType == "damcontentauthor") || (reportType == "damsiteowner") )
{
    $('input[name=rootPath]:first').attr('checked', true);
    
    var options = '<option value="Please select report type">Please select report type</option><option value="damacereport">DAM ACE Aging report</option><option value="damcontentauthor">DAM Content Author</option><option value="damsiteowner">DAM Site Owner</option>';
    $("#reportType").html(options); 

}

if((reportType == "damacereport"))
{
    $("#reportType > [value='damacereport']").attr("selected", "true");

}else if((reportType == "damcontentauthor"))
{
    $("#reportType > [value='damcontentauthor']").attr("selected", "true");

}else if((reportType == "damsiteowner"))
{
    $("#reportType > [value='damsiteowner']").attr("selected", "true");
}

if((reportType == "acereport"))
{
     $("#reportType > option").each(function() {
    if(this.value == reportType ){
        this.selected=true;
    }
    });
    
}else if((reportType == "contentauthor"))
{
     $("#reportType > option").each(function() {
    if(this.value == reportType ){
        this.selected=true;
    }
    });
    
}else if((reportType == "siteowner"))
{
     $("#reportType > option").each(function() {
    if(this.value == reportType ){
        this.selected=true;
    }
    });
}

});

$("#rootpath1").click(function() {
     $("input.rootPathText").val(""); 
     $("#rootpathdam").show();
     $("#rootpathpage").hide();  
     var options='<option value="Please select report type">Please select report type</option>';
     options+= '<option value="damacereport">DAM ACE Aging report</option><option value="damcontentauthor">DAM Content Author</option><option value="damsiteowner">DAM Site Owner</option>';
     $("#reportType").html(options); 
            
});   
$("#rootpath2").click(function() {
     $("input.rootPathText").val("");
     $("#rootpathpage").show();
     $("#rootpathdam").hide();
     var options='<option value="Please select report type">Please select report type</option><option value="acereport">PAGES ACE Aging report</option><option value="contentauthor">PAGES Content Author</option><option value="siteowner">PAGES Site Owner</option>';
     $("#reportType").html(options);         
});

$("#Clear").click(function() {
     $("input.rootPathText").val("");   
     //alert("TEST");
     var options='<option value="Please select report type">Please select report type</option>';
     $("#reportType").html(options);  
            
}); 

$("#Export").click(function() {
    $("#errorid").hide();
            
}); 
</script>
<%!
private static String readAll(Reader rd) throws IOException {
            StringBuilder sb = new StringBuilder();
            int cp;
            while ((cp = rd.read()) != -1) {
                  sb.append((char) cp);
            }
            return sb.toString();   
      } 
%>
</body>
</HTML>