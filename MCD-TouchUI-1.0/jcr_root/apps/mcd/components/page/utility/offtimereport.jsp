<HTML>
<%@ page import="java.util.Calendar,
        java.util.Locale,
        java.text.*,
        java.util.Iterator,
        org.apache.jackrabbit.util.Text,
        com.mcd.accessmcd.ace.manager.ACEManager,
        com.mcd.accessmcd.ace.bo.ACEConfigDataBean,
        com.day.cq.security.*,
        java.util.*, 
        java.util.regex.*,
        java.io.*,
        org.apache.commons.httpclient.*,
        org.apache.commons.httpclient.auth.*,
        org.apache.commons.httpclient.methods.*,
        com.mcd.accessmcd.usermanagement.user.manager.UserMaintenanceManager, 
        com.mcd.accessmcd.usermanagement.user.bo.GroupDataBean"%>
                                                                                
<%@include file="/apps/mcd/global/global.jsp" %>
<head>
<script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script>  
<title>ACE Offtime Report</title>
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
public String drawOfftimeReport(String rootPath, int serverno, int days, long tm_cutdate, PageManager pageManager,boolean bOutOfSynch){
    StringBuffer outBuffer = new StringBuffer("");
    String offtimes=getPublishOfftimes(serverno,rootPath,days);
    String expireFormat = "MM-dd-yyyy HH:mm a";
    SimpleDateFormat expireformatter = new SimpleDateFormat(expireFormat );
    StringTokenizer st=new StringTokenizer(offtimes,",");
    ACEManager aceManager = new ACEManager();
    long authPubOutOfSynch=0;
    while(st.hasMoreTokens()){
        String line=st.nextToken().trim();
        if(line.contains("|")){
            String path=line.split("\\|")[0];
            //;
            String expireDate=line.split("\\|")[1];
            //outBuffer.append(path+":"+expire+"<br>");
            
            Page child=pageManager.getPage(path);
            String pageTitle = "";
            String authexpireDate = "";
            String lastReplicated = "";
            String lastModified = "";
            String lastReplicationAction = "";                
            String pageAuthor = "";
            String contentAuthorEmail = ""; 
            String siteOwnerEmail = "";
            Calendar cal_expireDate;
            long tm_expireDate = -1L; 
            long tm_authexpireDate = -1L;
            long tm_lastReplicated = -1L;
            long tm_lastModified  = -1L;
            String style = "";    
            
            /* */
            
            if(child!=null){
                ACEConfigDataBean aceBean = aceManager.getACEConfigBean(aceManager.getACESitePageKey(child.getPath(),true));    
                String domainAdd = aceBean.getPubDomainAdd();
                String dateFormat = aceBean.getDateFormat();
            
                pageTitle=child.getNavigationTitle();
                if (pageTitle == null || pageTitle.equals("")) {
                    pageTitle = child.getPageTitle();
                }
                if (pageTitle == null || pageTitle.equals("")) {
                    pageTitle = child.getTitle();
                }
                if (pageTitle == null || pageTitle.equals("")) {
                    pageTitle = child.getName();
                }
                authexpireDate = child.getProperties().get("offTime",String.class);

                lastReplicationAction = child.getProperties().get("cq:lastReplicationAction",String.class);
                pageAuthor = child.getProperties().get("authorName","");              
                if(child.getProperties().get("offTime",Calendar.class)!=null){
                    cal_expireDate = child.getProperties().get("offTime",Calendar.class);
                    tm_authexpireDate = cal_expireDate.getTimeInMillis();
                    authexpireDate = displayDateAs(dateFormat,tm_authexpireDate );
                }else{
                    authexpireDate = "";
                }                
                               
                if(child.getProperties().get("cq:lastReplicated",Calendar.class)!=null){
                    Calendar cal_lastReplicated = child.getProperties().get("cq:lastReplicated",Calendar.class);
                    tm_lastReplicated = cal_lastReplicated.getTimeInMillis();
                    lastReplicated = displayDateAs(dateFormat,tm_lastReplicated);
                } 
                
                if(child.getProperties().get("cq:lastModified",Calendar.class)!=null){
                    Calendar cal_lastModified = child.getProperties().get("cq:lastModified",Calendar.class);
                    tm_lastModified = cal_lastModified.getTimeInMillis();
                    lastModified = displayDateAs(dateFormat,tm_lastModified);
                } 
                
                try{
                    tm_expireDate=expireformatter.parse(expireDate).getTime();
                    expireDate = displayDateAs(dateFormat,tm_expireDate );    
                }catch(ParseException pe){
                }
            }     
            if(bOutOfSynch && (tm_authexpireDate-tm_expireDate)<(1000*3600*24)){
                //skip
            }else{
                outBuffer.append("<tr>");
                outBuffer.append("<td>" + ++count +"</td>");
                //domainAdd="https://author.accessmcd.com/";
                //if(!("".equals(domainAdd))){
                 String pageURL = "https://author.accessmcd.com"+ path + ".html";
                 outBuffer.append("<td style=\"white-space:normal\"><a target='_new' href='"+ pageURL+"'>"+ path+"</a></td>");                            
                //}else{
                //     outBuffer.append("<td style=\"white-space:normal\">"+ path+"</td>");
                //}
                outBuffer.append("<td>"+ pageTitle +"</td>");
                outBuffer.append("<td>"+ pageAuthor +"</td>");
                if((tm_authexpireDate-tm_expireDate)>(1000*3600*24)){             
                    style = "style=\"color:black;background-color:yellow;\"";
                    authPubOutOfSynch++;
                }else{
                    style = "";
                }
                outBuffer.append("<td "+style+" class='nowrap'><b>"+expireDate+ "</b></td>"); 
                outBuffer.append("<td "+style+" class='nowrap'>"+authexpireDate+ "</td>");
                
                if(tm_cutdate > tm_expireDate){             
                    style = "style=\"color:black;background-color:pink;\"";
                }else{
                    style="";
                }
                 
                if(!("".equals(expireDate))){
                    outBuffer.append("<td "+style+" class='rightAlign'>"+ daysBetween_manaul(tm_cutdate,tm_expireDate) + "</td>");
                }else{
                    outBuffer.append("<td class='rightAlign'>"+ "" +"</td>");
                }
                if((tm_lastModified-tm_lastReplicated)>(1000*3600*24)){             
                    style = "style=\"color:black;background-color:lime;\"";
                }else{
                    style = "";
                }
                outBuffer.append("<td "+style+" class='nowrap'>"+lastModified+ "</td>"); 
                outBuffer.append("<td class='nowrap'>"+lastReplicated+ "</td>");                    
                outBuffer.append("<td class='rightAlign'>"+ daysBetween_manaul(tm_lastReplicated,tm_cutdate) + "</td>");
                outBuffer.append("</tr>"); 
            }
        }
    }
    outBuffer.append("<tr><td colspan=7>Server #"+serverno+" out of synch w/author:<b>"+authPubOutOfSynch+"</b></td></tr>"); 
   
    // return the html code as string //
    return outBuffer.toString();
}


 public static byte[] getCQ5Content(String url){
             
            byte[] retbytes="".getBytes();
            GetMethod getPageMeth=null; 
            org.apache.commons.httpclient.HttpClient client = new HttpClient();
            HostConfiguration host = client.getHostConfiguration();
            
            try {

                host.setHost(new org.apache.commons.httpclient.URI(url));
                org.apache.commons.httpclient.Credentials credentials = new UsernamePasswordCredentials("admin", "H@rs!615D");
                client.getState().setCredentials(AuthScope.ANY, credentials);
                
                getPageMeth= new GetMethod(url);
                
                getPageMeth.setDoAuthentication( true );       
                getPageMeth.getParams().setParameter("http.socket.timeout", new Integer(20000));        
                client.getParams().setAuthenticationPreemptive( true );

                int status = client.executeMethod(getPageMeth);
                              
                if(status==200){
                    //retbytes= getPageMeth.getResponseBody(); 
                    byte[] byteArray=new byte[1024];
                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream() ;
                    int count = 0 ;
                    while((count = getPageMeth.getResponseBodyAsStream().read(byteArray, 0, byteArray.length)) > 0)
                    { 
                     outputStream.write(byteArray, 0, count) ;
                    }                 
                    retbytes=outputStream.toByteArray();             
                 }      
            } catch(Exception e){
            }
            finally {
                getPageMeth.releaseConnection();
                client=null;
            }
            return retbytes;
     }


   private String getPublishOfftimes(int serverno, String rootPath, int days){
        StringBuffer sb=new StringBuffer();
        String strComma="";
        
        /*
        String[] serverlist={
        "mcdeagsun113b.mcd.com:4212"
        };
        String[] serverlist={
        "mcdeagsun113b.mcd.com:4212",        
        "mcdeagsun113b.mcd.com:4213"
        };
        ,"mcdeagsun115.mcd.com:4213"};       
        */
        String[] serverlist={
        "mcdeagsun113b.mcd.com:4212",        
        "mcdeagsun113b.mcd.com:4213",
        "mcdeagsun113b.mcd.com:4214",
        "mcdeagsun115.mcd.com:4212"
        };
       // for(int ix=0;ix<serverlist.length;ix++){
            String publishtimings=new String(getCQ5Content("http://"+serverlist[serverno]+"/content/utility/utility.offtimes.html?days="+days+"&rootPath="+rootPath));
            if(!publishtimings.equals("")){
                publishtimings=publishtimings.replaceAll("servername",serverlist[serverno]);
                sb.append(publishtimings);

            }
       // }
        return sb.toString();
    
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
    
    String hidAction = (String) request.getParameter("hidAction");
    
    int serverno=0;
    int days=30;
    boolean bOutOfSynch=false;
    
    String strserverno= (String) request.getParameter("serverno");
    if(strserverno!=null){
        try{
            serverno=Integer.parseInt(strserverno);
        }catch(Exception e){}
    }
    String strdays= (String) request.getParameter("days");
    if(strdays!=null){
        try{
            days=Integer.parseInt(strdays);
        }catch(Exception e){}
    }
    
    String strbOutOfSynch = (String) request.getParameter("bOutOfSynch");
    if(strbOutOfSynch !=null){
           bOutOfSynch=true;
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
    
    <h3>ACE Offtime Report</h3>
    <br>
    <p style="margin-top:-20px;text-align:center;">
       <i>The Report Utility will only list the pages that are in the activated state and expiring <b>on the Publish instance</b> +/- 30 days.</i>
    </p>
    <!--p style="margin-top:-10px;text-align:center;">
       <i>Any negative values under '# Of Days Until Page Expiration' will be shown in red text with a pink background.</i>
    </p-->     
    <hr style="margin-top:-8px;">
    <br><b>
    &nbsp;Enter the path for the site:&nbsp;&nbsp;</b>
    <input type="text" name="rootPath" id="rootpath" value='<%=rootPath%>' size="40px"></input>
    
    
<b>Publish Server:</b><select name="serverno" id="serverno">
<option <%=((serverno==0)?"selected":"") %> value="0">113b:4212</option>
<option <%=((serverno==1)?"selected":"") %> value="1">113b:4213</option>
<option <%=((serverno==2)?"selected":"") %> value="2">113b:4214</option>
<option <%=((serverno==3)?"selected":"") %> value="3">115:4212</option>
</select>
    
    
<b>+ Days:</b><select name="days" id="days">
<option <%=((days==30)?"selected":"") %> value="30">30</option>
<option <%=((days==60)?"selected":"") %> value="60">60</option>
<option <%=((days==90)?"selected":"") %> value="90">90</option>
<option <%=((days==180)?"selected":"") %> value="180">180</option>
</select>
<b>Out Of Synch Only:</b><INPUT type=checkbox name="bOutOfSynch" <%=(bOutOfSynch?"CHECKED":"") %>>   
    <input type=hidden name="reportType" value="offtimereport" />
    <%--
    <select name="reportType" id="reportType">
        <option value="Please select report type">Please select report type</option>
        <option value="offtimereport">Expiration Report</option>
        <!--<option value="contentauthor">Content Author</option>
        <option value="siteowner">Site Owner</option>-->
    </select>
    --%>
    <br>
    <%--<span><i style="font-size: 12px; padding-left: 10px;">DEFAULT : Absolute Parent at level 1</i></span>
    <br>--%><br>
    <input class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='ShowInfo';" value="Run" />
    <input class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='Clear';" value="Clear" />
    <!--
    <input class="formbutton" style="float:left; margin-left: 10px;" type="submit" onclick="this.form.hidAction.value='Export';" value="Export To Excel" />
    -->
    <br><br>
    <hr style=""> 
      
<%  
   
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
            if("offtimereport".equalsIgnoreCase(reportType)){
                out.println("<p style=\"margin-top:25px;font-size:12px;\">&nbsp;Upcoming Expirations <b>"+rootPath+"</b> as on <b>"+ lastcutdate +"</b> [MM.dd.yyyy HH:mm:ss] </p>");
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
            if("offtimereport".equalsIgnoreCase(reportType)){
%>
                <th>S. No</th>
                <th>Page URL</th>
                <th>Page Title</th>
                <th>Author Name</th>
                <th>Expiration Date (Publish)</th>
                <th>Expiration Date (Author)</th>
                <th># Of Days Until Page Expiration</th>
                <th>Date Last Modified</th>
                <th>Date Last Activated</th>
                <th># Of Days Since Page Last Activated</th>
<% 
                 
                 out.println(drawOfftimeReport(rootPath, serverno,days,tm_lastcutdate,pageManager,bOutOfSynch));
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