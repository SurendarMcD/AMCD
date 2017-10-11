<HTML>
<%@ page import="java.util.Calendar,
        java.util.Locale,
        java.text.SimpleDateFormat,
        java.util.Iterator,
        org.apache.jackrabbit.util.Text,
        com.mcd.accessmcd.ace.manager.ACEManager,
        com.mcd.accessmcd.ace.bo.ACEConfigDataBean,
        com.day.cq.security.*,
        java.util.*, 
        com.mcd.accessmcd.usermanagement.user.manager.UserMaintenanceManager, 
        com.mcd.accessmcd.usermanagement.user.bo.GroupDataBean"%>
                                                                                
<%@include file="/apps/mcd/global/global.jsp" %>
<head>
<script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script>  
<title>ACE Report Utility</title>
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
table.pagetable th {
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
.nowrap{
    white-space:nowrap;
}
.rightAlign{
    text-align:right;
}
</style>
</head>

<body>
<%!
int count;

String[] restrictSites = {"/content",
                          "/content/accessmcd",
                          "/content/utility"
};
    

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
public String drawChildTree (Page rootPage, long tm_cutdate, HttpServletRequest request,String reportType,PageManager pageManager){
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
                    pageAuthor = child.getProperties().get("jcr:description","");
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
                               
                if("Activate".equals(lastReplicationAction)){
                    String style = "style=\"color:red;background-color:pink;\"";
                    String domainAdd = "http://author.accessmcd.com";
                                                                        
                    String pathtoinclude=child.getPath(); 
                    int frPath1 = pathtoinclude.indexOf("/en");  
                    String firstPath = pathtoinclude.substring(0,frPath1+3).replaceAll("/content","").replaceAll("en","fr");
                    String secondPath = pathtoinclude.substring(frPath1+3);
                    String frPagePath = "/content"+firstPath+secondPath;
                     
                                             
                    //pathtoinclude = pathtoinclude.replace("/content/","/");
                    if("contentauthor".equalsIgnoreCase(reportType)){
                        Page frPage = pageManager.getPage(frPagePath);
                        if(frPage != null){
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
                outBuffer.append(drawChildTree(child,tm_cutdate,request,reportType,pageManager));
            }
        } finally {         
             
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

public boolean isAceSite(ArrayList userGrpList,String rootPath){
    boolean rt = false;
    
    // get ACE site keys    
    ACEManager aceManager = new ACEManager();
    Enumeration allURLs = aceManager.getAllSiteKeys();
    while(allURLs.hasMoreElements())
    {
        String theURL = (String)allURLs.nextElement();
        
        if (!checkRestrictSites(theURL)) {            
            ACEConfigDataBean aceBean = aceManager.getACEConfigBean(theURL);
            if(userGrpList.contains(aceBean.getGroupName()) ) {
                if( (rootPath.equals(theURL)) || (rootPath.indexOf(theURL+"/")>-1) ){
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
    if(!(rootPath.length() > 0) && "Please select report type".equals(reportType)){
        errMsg = "ERROR : Please enter a path for site<br>ERROR : Please select report type";
    }else if(!((rootPath.length() > 0) || "Please select report type".equals(reportType))){
        errMsg = "ERROR : Please enter a path for site";
    } else if("Please select report type".equals(reportType)){
        errMsg = "ERROR : Please select report type";
    }else if(!(loggedInUserID.equals("admin"))) {
        if ( (checkRestrictSites(rootPath)) || (!isAceSite(userGrpList,rootPath))){
            errMsg = "ERROR : Sorry, you are not allowed to execute the utility on " + rootPath + ". Please enter a valid site path.";        
        }
    }    
%>
<a name="top"></a>

<div style="width:100%;padding-top:5px;">
<img  src='/images/accessmcd.gif' />
</div>

<form id="report" name="report" action="#" style="margin-top: -45px;">
    <input type="hidden" name="hidAction" value="Clear"/>
    <input type="hidden" id="errorMsg" name="errorMsg" value="<%=errMsg%>"/>
    
    <h3>ACE Report Utility</h3>
    <br>
    <p style="margin-top:-20px;text-align:center;">
       <i>The Report Utility will only list the pages that are in the activated state.</i>
    </p>
    <!--p style="margin-top:-10px;text-align:center;">
       <i>Any negative values under '# Of Days Until Page Expiration' will be shown in red text with a pink background.</i>
    </p-->     
    <hr style="margin-top:-8px;">
    <br><b>
    &nbsp;Enter the path for the site:&nbsp;&nbsp;</b>
    <input type="text" name="rootPath" id="rootpath" value='<%=rootPath%>' size="40px"></input>
    <select name="reportType" id="reportType">
        <option value="Please select report type">Please select report type</option>
        <option value="acereport">ACE Aging report</option>
        <option value="contentauthor">Content Author</option>
        <option value="siteowner">Site Owner</option>
    </select>
    <br>
    <%--<span><i style="font-size: 12px; padding-left: 10px;">DEFAULT : Absolute Parent at level 1</i></span>
    <br>--%><br>
    <input class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='ShowInfo';" value="ShowInfo" />
    <input class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='Clear';" value="Clear" />
    <input class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='Export';" value="Export To Excel" />
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
        if(errMsg.length() > 0){
            out.println("<p style=\"text-align:center;color:#ce0000\"><b><span style='margin-left:18px;'>" + errMsg + "</span></b></p>");
        } else {
%>
            <div class="text">    
<%        
            if("acereport".equalsIgnoreCase(reportType)){
                out.println("<p style=\"margin-top:25px;font-size:12px;\">&nbsp;Content Pages AGE under <b>"+rootPath+"</b> as on <b>"+ lastcutdate +"</b> [MM.dd.yyyy HH:mm:ss] </p>");
            }    
            else if("siteowner".equalsIgnoreCase(reportType)){
                out.println("<p style=\"margin-top:25px;font-size:12px;\">&nbsp;Site Owner report under <b>"+rootPath+"</b> as on <b>"+ lastcutdate +"</b> [MM.dd.yyyy HH:mm:ss] </p>");
            }
            else if("contentauthor".equalsIgnoreCase(reportType)){
                out.println("<p style=\"margin-top:25px;font-size:12px;\">&nbsp;Content Author report under <b>"+rootPath+"</b> as on <b>"+ lastcutdate +"</b> [MM.dd.yyyy HH:mm:ss] </p>");
            }  
            Page rootPage = slingRequest.getResourceResolver().adaptTo(PageManager.class).getPage(rootPath);
%>
            <table class="pagetable" width="100%">
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
                out.println(drawChildTree(rootPage,tm_lastcutdate,request,reportType,pageManager));
            }
            else if("siteowner".equalsIgnoreCase(reportType)){
%>           
                <th>S. No</th>
                <th>Page URL</th>
                <th>Page Title</th>
                <th>Site Owner Name</th>
                <th>Site Owner Email</th>
<%
                out.println(drawChildTree(rootPage,tm_lastcutdate,request,reportType,pageManager));
            }
            else if("contentauthor".equalsIgnoreCase(reportType)){
%>           
                <th>S. No</th>
                <th>Page URL</th>
                <th>Page Title</th>
                <th>Content Author Name</th>
                <th>Content Author Email</th>
<%
                out.println(drawChildTree(rootPage,tm_lastcutdate,request,reportType,pageManager));
            }
%>
            </tr>
            </table>
            </div> 
            <br>
            <div style="text-align:center"><a href="#top"><strong>Return to Top</strong></a><div>   
<%              
          }
      } else if(hidAction.equals("Export")) {
          if(errMsg.length() > 0){
            out.println("<p style=\"text-align:center;color:#ce0000\"><b>" + errMsg + "</b></p>");
        } else {
            String url = "/utility/utility.exportpagereport.html?rootPath="+rootPath+"&reportType="+reportType;    
            response.sendRedirect(url);
        }
      }
   }   
%> 
</form>
<script> 
$(document).ready(function() { 
    $("#reportType > option").each(function() {
        if(this.value == '<%=reportType%>'){
            this.selected=true;
        }
    });
});
</script>
</body>
</HTML>