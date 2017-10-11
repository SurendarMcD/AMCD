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
 <script language='javascript'>
function openInCRXDE(path){
window.open("/crxde/#/crx.default/jcr%3aroot"+path);
}  
</script>
<title>Content Inventory Report Utility</title>
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

table.pagetable td {
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
public String drawChildTree (Page rootPage, long tm_cutdate, HttpServletRequest request){
    StringBuffer outBuffer = new StringBuffer("");
   InputStream is = null;
    BufferedReader rd = null;
   
    if (rootPage != null) {
        // code to retirieve the child pages of the selected page in the itertor object
        
        Iterator<Page> children = rootPage.listChildren();       
        try {
            while (children.hasNext()) {
                Page child = children.next();   
                            
                String lastReplicationAction = child.getProperties().get("cq:lastReplicationAction",String.class);      
                String lastReplicated = child.getProperties().get("cq:lastReplicated",String.class);
                String contentAuthor = "";
                String contentAuthorEmail = "";
                String siteOwnerEmail = "";
                String siteOwner="";
                String pageURL ="";
                String pageTitle = child.getNavigationTitle();
                
                    contentAuthor = child.getProperties().get("authorName","");
                    contentAuthorEmail = child.getProperties().get("authorEmail","");
                    siteOwner = child.getProperties().get("siteOwnerName","");
                    siteOwnerEmail = child.getProperties().get("siteOwnerEmail","");
                    String[] tag = child.getProperties().get("cq:tags",String[].class);
                   // String[] cug = child.getProperties().get("cq:cugPrincipals",String[].class);
                    String tags ="";
                    //String cugs =""; 
                    String cugs = getCug(child);
                    if (pageTitle == null || pageTitle.equals("")) {
                        pageTitle = child.getPageTitle();
                    }
                    if (pageTitle == null || pageTitle.equals("")) {
                        pageTitle = child.getTitle();
                    }
                    if (pageTitle == null || pageTitle.equals("")) {
                        pageTitle = child.getName();
                    }
                   
                    if(tag!=null && tag.length>0){
                            for(int i=0;i<tag.length;i++){
                               if(tag[i]!=null && tag[i]!=""){
                                    tags += tag[i]; 
                                    if(tag.length!=i+1){
                                       tags += ",";
                                       
                                    }
                                }    
                            }
                        }
                        
                    /*    if(cug!=null && cug.length>0){
                            for(int i=0;i<cug.length;i++){
                                if(cug[i]!=null && cug[i]!=""){
                                    cugs+=cug[i];
                                    if(cug.length!=i+1){
                                       cugs +=","; 
                                      
                                    }
                                }
                            }
                        }
                   */
                
                // To get the Domain Address and Date Format for the Page / Site
                ACEManager aceManager = new ACEManager();
                ACEConfigDataBean aceBean = aceManager.getACEConfigBean(aceManager.getACESitePageKey(child.getPath(),true));    
                String domainAdd = aceBean.getPubDomainAdd();
                String dateFormat = aceBean.getDateFormat();
                                
                long tm_lastReplicated = -1L;
                if(child.getProperties().get("cq:lastReplicated",Calendar.class)!=null){
                    Calendar cal_lastReplicated = child.getProperties().get("cq:lastReplicated",Calendar.class);
                    tm_lastReplicated = cal_lastReplicated.getTimeInMillis();
                    lastReplicated = displayDateAs(dateFormat,tm_lastReplicated);
                }
                if("Activate".equals(lastReplicationAction)){
                   
                                                                        
                    String pathtoinclude=child.getPath();                        
                    pathtoinclude = pathtoinclude.replace("/content/","/");
                    
                        outBuffer.append("<tr>");
                        outBuffer.append("<td>" + ++count +"</td>");
                        outBuffer.append("<td>"+ pageTitle +"</td>");
                        if(!("".equals(domainAdd))){
                            pageURL = domainAdd + pathtoinclude + ".html";
                            outBuffer.append("<td style=\"white-space:normal\"><a href='"+ pageURL +"'>"+ pageURL +"</a></td>");                            
                        }else{
                            outBuffer.append("<td style=\"white-space:normal\">"+ pathtoinclude +"</td>");
                        }
                        outBuffer.append("<td>"+ tags+"</td>");
                        outBuffer.append("<td>"+ cugs+"</td>");
                        outBuffer.append("<td>"+ contentAuthor+"</td>");
                        outBuffer.append("<td class='nowrap' width='10%'>"+contentAuthorEmail+ "</td>");
                        outBuffer.append("<td class='nowrap' width='10%'>"+ siteOwner+"</td>");
                        outBuffer.append("<td class='nowrap' width='10%'>"+siteOwnerEmail+ "</td>");
                        outBuffer.append("<td class='nowrap' width='10%'>"+lastReplicated+ "</td>");                    
                        outBuffer.append("</tr>"); 
                  
                }
                
                outBuffer.append(drawChildTree(child,tm_cutdate,request));
            }
        } finally {         
             
        }
    }
    // return the html code as string //
    return outBuffer.toString();
}

public String getCug(Page rootPage)
{
String parentProps = "";
boolean pageResult = rootPage.getProperties().containsKey("cq:cugPrincipals");
if(pageResult)
{
       String[] parentProp= rootPage.getProperties().get("cq:cugPrincipals",String[].class);
       for(int i=0;i<parentProp.length;i++){
       
            parentProps+= parentProp[i];
            if(parentProp.length!=i+1){
                   parentProps += ",";
                   
                }
       }      
}else{

parentProps+=getCug(rootPage.getParent());}
return parentProps;
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
    if(!((textValue.length() > 0) )){
        errMsg = "ERROR : Please enter a path for site";
    }
    else if(("/content/accessmcd".equals(rootPath))&&(!textValue.startsWith("/content/accessmcd"))){
        errMsg = "Please enter valid site path";
    }else if(!(loggedInUserID.equals("admin"))) {
         if(textValue.equals("/content/accessmcd"))
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
    <input type="hidden" name="rootPath" id="rootpathVal" value="/content/accessmcd"/>
    <h3>Content Inventory Report Utility</h3>
    <br>
    <p style="margin-top:-20px;text-align:center;">
       <i>The Report Utility will only list the pages that are in the activated state.</i>
    </p>
      
    <hr style="margin-top:-8px;">
    <br>
    
     <br><b>
    &nbsp;Enter the path for the site:&nbsp;&nbsp;</b>
    <input type="text" class="rootPathText" name="textValue" id="rootpath" value="<%=textValue%>" size="40px"></input>
       <br>
          <label id="rootpathpage" style="font-size:12px;color:#808080;">&nbsp;The path should start with "/content/accessmcd".</label>             
      <br>
         <label style="font-size:12px;color:#808080;"> &nbsp;<b>Note:</b> Please don't append .html to the path entered </label>
         <br>
      
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
              
            Page rootPage = slingRequest.getResourceResolver().adaptTo(PageManager.class).getPage(textValue);
%>
            <table class="pagetable" width="100%" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <th>S. No</th>
                <th>Page Title</th>
                <th>Page URL</th>
                <th>Tag/Keywords</th>
                <th>CUG</>
                <th>Author Name</th>
                <th>Author Name Email</th>
                <th>Site Owner Name</th>
                <th>Site Owner Email</th>             
                <th>Last Activated Date</th>

<% 
                out.println(drawChildTree(rootPage,tm_lastcutdate,request));
                }
  %>    
            </tr>
            </table>
            </div> 
            <br>
            <div style="text-align:center"><a href="#top"><strong>Return to Top</strong></a><div>   
<%              
         
               
            }
       else if(hidAction.equals("Export")) {
            if(errMsg.length() > 0){
                out.println("<p id=\"errorid\" style=\"text-align:center;color:#ce0000\"><b>" + errMsg + "</b></p>");
            } else { 
                String url = "/utility/utility.exportcontentinventoryreport.html?rootPath="+rootPath+"&textValue="+textValue;    
               // window.location.reload();
                response.sendRedirect(url);
            }
         
         
      }
   }   
  
   
%> 
</form>
<script>

$("#Clear").click(function() {
     $("input.rootPathText").val("");   
            
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