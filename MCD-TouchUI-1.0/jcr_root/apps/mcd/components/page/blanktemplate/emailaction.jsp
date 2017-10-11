     <%-- ########################################### 
     # DESCRIPTION: Email form 
     # will be displayed with the search option this form is responsible for sending mail 
     # Author: Rajat Chawla 
     # 
     # 
     # UPDATE HISTORY       
     # 1.0  Rajat Chawla, 03/10/2009,Initial version 
     # 
     ##############################################--%>
     <!DOCTYPE html>
    <%@ include file="/apps/mcd/global/global.jsp"%>
    <%@ page language = "java" %>
    <%@ page import="java.util.StringTokenizer,java.util.Iterator" %>
    <%@ page import="com.day.cq.security.User" %> 
    <%@ page import="com.day.cq.security.Group" %>
    <%@ page import="com.day.cq.security.UserManager,com.day.cq.security.Authorizable" %>
    <%@ page import="com.day.cq.security.UserManagerFactory" %>
    <%@page import="com.mcd.accessmcd.mail.manager.EmailManager,com.mcd.accessmcd.mail.bo.EmailDataBean"%>
    <%@ page import="java.net.URLEncoder,java.net.URLDecoder"  %>
    <%@page import="org.apache.sling.jcr.api.SlingRepository,com.mcd.accessmcd.common.ShareEmail" %>
    <%@ page import="java.util.ResourceBundle" %>
    <%@ page import="java.util.Locale,com.day.cq.i18n.I18n" %>
    <%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %> 
    <sling:defineObjects/>
    <html> 
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="STYLESHEET" type="text/css" href="/apps/mcd/docroot/wog/style/emailfooter.css">
    <link rel="stylesheet" type="text/css" href="/apps/mcd/docroot/wog/style/media_queries_email.css"> 
    <!--[if lt IE 9]>
        <script src="https://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
    <![endif]-->
    <script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script>  
    <script type="text/javascript" src="/apps/mcd/docroot/scripts/common.js"></script>
    <title><%= currentPage.getTitle() %></title>
    
    
    </head>
    <body> 
     <% 
     String factId = "";
     if(null != request.getParameter("factId")){
         factId = request.getParameter("factId");
     }
     // creating user object //
     final User user = slingRequest.getResourceResolver().adaptTo(User.class);
     // getting the bundle value on the basis of the language selected//
     ResourceBundle bundle =resourceBundle;

     %>   
       
       
    
    <%!
        // method to replace the specified text from the variable //
        protected String replaceStr(String strIn,String from, String to){
        //for debugging
        String strReturn="";
        StringTokenizer st = new StringTokenizer(strIn,from);
        while(st.hasMoreTokens()){
            strReturn+=st.nextToken()+to;
        }
        return(strReturn);
    }
    %>
    
    <% 
    // code to retrieved the prefix from the URL//
    String prefixAMCD="";
        if(null!=request.getParameter("prefixAMCD"))
        {
            prefixAMCD=URLDecoder.decode(request.getParameter("prefixAMCD"));
        }
    
    String sendTo = "";
    String subject= "";
    String body = "";
    String factTitle = "";
    String sendFrom = "";
    String title ="no title";
    String securityWarn = "Hungry for McDonald's info that's actually true? We're servin' up the facts from the <b><u></i>McDonald's Fast Facts Generator</i><u></b>. Visit this fun and interactive site to learn (and share) information about McDonald's. Also, visit our <a href='http://www.aboutmcdonalds.com/mcd/country/map.html'>social media sites around the world</a> to ask specific questions about our good food, people, and community practices and get your facts straight ... from McDonald's.";
    String subHandle="";
    
    // code to retrieve the sub handle value from the request object //
    if(null!=request.getParameter("hostLink"))
    {
        subHandle=URLDecoder.decode(request.getParameter("hostLink"));      
    }
    
    
    String senderEmail = "";
    String senderName = "";
    String senderID ="";
    String senderRole ="";
    String linkWarn = "*Please note that you might not have access to this link if you are in a different role group than the sender.";
    
         // code to retrive the sender details //
     SlingRepository repos= sling.getService(SlingRepository.class);  
     UserManagerFactory fact =sling.getService(UserManagerFactory.class);
     if (!(repos==null || fact==null)) {
         Session session = null;
         try {
             //  create session from repository's method loginAdministrative 
             session = repos.loginAdministrative(null);
             final UserManager umgr = fact.createUserManager(session);
             if(umgr.hasAuthorizable(user.getID())){
                 Authorizable auth = umgr.get(user.getID());
                 // code to get sender ID             
                 senderID = user.getID();
                 // code to get sender email and full name
                 
                 // 03-12-09 : old code of fetching email and name from profile node
                 //senderEmail = auth.getProfile().getPrimaryMail();
                 //senderName = auth.getProfile().getFormattedName();
                 
                 // 03-12-09 : new code of fetching email and name from cq:authorizable node   
                /* if(null!=user.getProperty("rep:e-mail")) {
                     senderEmail=user.getProperty("rep:e-mail");
                 }
                 else if(null!=user.getProperty("rep:email")) {
                     senderEmail = user.getProperty("rep:email");
                 }
                 else { 
                     senderEmail = auth.getProfile().getPrimaryMail();
                 }
                 if(null!=user.getProperty("rep:fullname")) {
                    senderName = user.getProperty("rep:fullname");  
                 }
                 else {
                    senderName = auth.getProfile().getFormattedName();
                 }
                 */
                 // temp - 12/22
                 Node userProfileNode = (Node) session.getItem(user.getHomePath() + "/profile");
                 //senderEmail=senderEmail+userProfileNode.getPath()+"|||";
                 //senderEmail=senderEmail+userProfileNode.getName();
                
                 // Find user's Full Name
                 if(userProfileNode.hasProperty("rep:fullname"))
                 { 
                     senderName=userProfileNode.getProperty("rep:fullname").getValue().getString();
                 }
                 else
                 {
                     if(userProfileNode.hasProperty("givenName"))
                     {
                     senderName=userProfileNode.getProperty("givenName").getValue().getString();
                     }
                     if (userProfileNode.hasProperty("familyName"))
                     {
                         senderName = senderName + " " + userProfileNode.getProperty("familyName").getValue().getString();
                     }
                     if(null!=user.getProperty("rep:fullname"))  // added for the new Auto synched process
                     {
                         senderName =user.getProperty("rep:fullname");
                     }
                     
                     
                 }
                 
                 if(userProfileNode.hasProperty("rep:email"))
                 {
                    senderEmail=senderEmail+userProfileNode.getProperty("rep:email").getValue().getString();
                 }
                 else if(userProfileNode.hasProperty("email"))
                     {
                        senderEmail=senderEmail+userProfileNode.getProperty("email").getValue().getString();
                     }
                     else
                     {
                         if(null!=user.getProperty("rep:e-mail"))  // added for the new Auto synched process
                         {
                         senderEmail=user.getProperty("rep:e-mail");
                         }
                     }
                 
                     
                 
                 // temp - 12/22
                 
                 // iterating for the list of groups in which the user has been assigned //
                 Iterator<Group>  theGroups  = auth.memberOf(); 
                 while(theGroups.hasNext())
                 {
                   Group group = theGroups.next();
                   // setting sendrole from the group name //
                   String groupName = group.getName();
                   // sendRole will be assign all the group names in which the user lies //
                   senderRole = senderRole + groupName; 
                 }     
             }
         } catch (RepositoryException e) {
         } finally {
             if (session!=null) {
                 session.logout();
             }
         }
     }
     // assign  title the value of the current page title // 
     title = currentPage.getTitle();     
     // assign subject of the mail     
     subject = senderName +" "+bundle.getString("PAF_SUBJECTLINE") + title;
    
    if (request.getParameter("hidPrefixAMCD")!=null)
        prefixAMCD = URLDecoder.decode(request.getParameter("hidPrefixAMCD"));
    
    if (request.getParameter("hidSubHandle")!=null)
        subHandle = URLDecoder.decode(request.getParameter("hidSubHandle"));
    
    String linkInfo = "<B>"+bundle.getString("PAF_LINKTITLE")+ title +"</B><BR>"+"<B>"+ bundle.getString("PAF_ARTICLE")+"</B> " + prefixAMCD +subHandle+"<BR><BR>";
    String sendEmail = "no";
    
    if (request.getParameter("hidSendEmail")!=null)
       sendEmail = request.getParameter("hidSendEmail");
    
    if ( sendEmail !=null && sendEmail.equalsIgnoreCase("yes") ) {
    
    if (request.getParameter("hidShareUserEmail")!=null)
             sendTo = request.getParameter("hidShareUserEmail");
    if (request.getParameter("hidEmailsubject")!=null)
        subject = java.net.URLDecoder.decode(request.getParameter("hidEmailsubject"),"UTF-8");     
    if (request.getParameter("hidEmailcontent")!=null){
        //body = java.net.URLDecoder.decode(request.getParameter("hidEmailcontent"),"UTF-8")+"<BR><BR>"+ linkInfo + bundle.getString("PAF_LINKWARN") +"<BR><BR>"+bundle.getString("PAF_LEGAL");
        if (request.getParameter("facttitle")!=null){
            factTitle = java.net.URLDecoder.decode(request.getParameter("facttitle"),"UTF-8");
        }
        //body = "<b>" + factTitle + "</b><BR><BR>" + java.net.URLDecoder.decode(request.getParameter("hidEmailcontent"),"UTF-8")+"<BR><BR>"+ "<BR><BR>"+bundle.getString("PAF_LEGAL_SHARE");
        body = java.net.URLDecoder.decode(request.getParameter("hidEmailcontent"),"UTF-8")+"<BR><BR>"+ "<BR><BR>"+bundle.getString("PAF_LEGAL_SHARE");
    }
    if (request.getParameter("emailfrom")!=null)
     sendFrom = request.getParameter("emailfrom");
    try
       {  
          String sendBody = replaceStr(body,"\n","<BR>");
          String addFrom = senderEmail+","+senderName;
          // creating the emailmanager.class & emaildatabean object //  
           EmailManager emailManager= new EmailManager();
           ShareEmail shareEmail = new ShareEmail();
           EmailDataBean mdb = new EmailDataBean(); 
           // setting the values to the bean //
           mdb.setSendTo(sendTo);
           mdb.setSendFrom(addFrom);
           mdb.setSubject(subject);
           mdb.setBody(sendBody);
           mdb.setSling(sling);
           // calling method to send the mail //
           boolean breturn=shareEmail.sendMail(mdb);
              if(breturn)
               {  
                   // method to store the mail data into database //
                   emailManager.postEmailData(senderID,senderRole,subHandle,title,sendTo,sling);
               }
           }
            catch (Exception e)
             {
             log.error(e.toString());
             }
    }
    %>  
    
    <%
    // code when the form is submitted //
    
    if ( sendEmail !=null && sendEmail.equalsIgnoreCase("yes") ){
        %>
        
        <form name=frmEmailAnother method="GET" target="">
        
        
        <input type=hidden name="hidPrefixAMCD" value="">
        <input type=hidden name="hidSubHandle" value="">
        <input type=hidden name="factId" id="factId" >
        
        <table width="100%" border="0"   cellspacing="0" cellpadding="0">
        <tr><td> &nbsp; </td></tr>
        <tr><td> &nbsp; </td></tr>
        <tr><td class="FootertitleBlack" align="center"><b> <%= bundle.getString("PAF_THANKYOU") %> </b></td></tr>
        <tr><td> &nbsp; </td></tr>
        <tr><td class="FootertitleBlack" align="center"><b> The Fact has been SENT.</b></td></tr>
        <tr><td> &nbsp; </td></tr>
        <tr><td class="FootertitleGrey" align="center"><b> Do you want to share this Fact with someone else? </b></td></tr>
        <tr><td> &nbsp; </td></tr>
           <tr bgcolor="" class="assetLabel">
            <td align="center">
                <nobr><a href="#" onclick="sendAnother();" class="contentlnkbold"><img src="/apps/mcd/docroot/images/action_send.gif" border=0 align=absmiddle><%= bundle.getString("PAF_ANOTHER") %></a></nobr> 
                <font class="txt3">|</font>
                <nobr><a href="#" onclick="javascript:window.parent.$.fancybox.close();" class="contentlnkbold"><img src="/apps/mcd/docroot/images/icon_button_close.gif" border=0 align=absmiddle><%= bundle.getString("PAF_CANCEL") %></a></nobr> 
                <br>
            </td>
           </tr>     
        </table>
        </form>
        <%
    }else{
    %>
    <form name=frmEmailAction method="GET" target="">
    <input type=hidden name="hidSendEmail" value="no" >
    <input type=hidden name="hidEmailsubject" value="" >
    <input type=hidden name="hidEmailcontent" value="" >
    <input type=hidden name="facttitle" id="facttitle" value="" >
    <input type=hidden name="hidShareUserEmail" value="" >
    <input type=hidden name="hidPrefixAMCD" value="">
    <input type=hidden name="hidSubHandle" value="">
    <input type=hidden name="factId" id="factId" >
    
    
    <div class="emailwrapper">
        <div class="FootertitleGrey"><%= bundle.getString("PAF_SENDLINKTO") %></div>
          
        
        <div class="Footerbodybold">
            <div class="leftside">&nbsp; <%= bundle.getString("PAF_TO") %>:</div>
            <div>
                <TEXTAREA NAME="sendToEmail" COLS=35 ROWS=2 ID="sendToEmail" ></TEXTAREA>
                <a href="#" onclick="return searchuser('to');" class="contentlnkbold"><img src="/apps/mcd/docroot/images/icon_searchemail.gif" border="0" align="absmiddle" ALT="Search for User"></a>
            </div>
        </div>
        
        
        <div class="Footerbodybold">
            <div class="leftside">&nbsp;</div>
            <div class="FootertitleRed"><%= bundle.getString("PAF_MOREADDR") %></div>
        </div>
        
        
        <div class="Footerbodybold">
            <div class="leftside">&nbsp;</div>
            <div><INPUT type="checkbox" name="hidAddMe" value="addme"><%=bundle.getString("PAF_ADDME") %></div>
        </div>
        <div class="clear">&nbsp;</div>
        
        <div class="Footerbodybold">
            <div class="leftside">&nbsp; <%= bundle.getString("PAF_FROMNAME") %>:</div>
            <div><input type="text" name="emailfromname" id="emailfromname" value="<%=senderName%>" ></div>
        </div>
        <div class="clear">&nbsp;</div>               
        
        <div class="Footerbodybold">
            <div class="leftside">&nbsp; <%= bundle.getString("PAF_FROM") %>:</div>
            <div><input type="text" name="emailfrom" id="emailfrom" value="<%=senderEmail%>" ></div>
        </div>
        <div class="clear">&nbsp;</div>               
        
        <div class="Footerbodybold">
            <div class="leftside">&nbsp; <%= bundle.getString("PAF_SUBJECT") %>:</div>
            <div><input type="text" name="emailsubject" id="emailsubject"></div>
        </div>
        <div class="clear">&nbsp;</div>
        
        <div class="Footerbodybold">
            <div class="leftside">&nbsp; <%= bundle.getString("PAF_BODY") %>:</div>
            <div><TEXTAREA class=query NAME="emailcontent" id="emailcontent" COLS=35 ROWS=7></TEXTAREA></div>
        </div>
        <div class="clear">&nbsp;</div>
        
        <div class="Footerbodybold">
            <div class="leftside">&nbsp;</div>
            <div>
                <a href="#" onclick="sendEmail('<%=senderEmail%>');" class="contentlnkbold"><img src="/apps/mcd/docroot/images/action_send.gif" border="0" align="absmiddle"> <%=bundle.getString("PAF_SUBMIT") %> </a><span style="margin:0 5px;">|</span><a href="#" onclick="javascript:window.parent.$.fancybox.close();" class="contentlnkbold"><img src="/apps/mcd/docroot/images/icon_button_close.gif" border="0" align="absmiddle"> <%=bundle.getString("PAF_CLOSE") %> </a>
            </div>
        </div>
        <div class="clear">&nbsp;</div>    
    </div>
    
    </form>
    
    
    <%}%>
    <script>
    function sendEmail(email){
        var myform = document.frmEmailAction;
        var email = myform.emailfrom.value;
        if (TrimString(email).length==0) {
             alert("Your Email is empty.");   
         return false;
        }
        if (email !=null && !validateEmailAddr(myform.emailfrom.value) ) {
            return false;
        }   
        
        if (myform.hidAddMe.checked){
            if (myform.sendToEmail.value != ""){
                    myform.hidShareUserEmail.value = myform.sendToEmail.value + "," + email;
            }else{
                    myform.hidShareUserEmail.value = email;
            }
        }else{
                myform.hidShareUserEmail.value = myform.sendToEmail.value;
        }
           if (validateEmail('<%= langText.get("Email Address(es) is empty")%>'))
           {
               myform.hidSendEmail.value = "yes";
               myform.hidEmailsubject.value = buildURL(myform.emailsubject.value);       
               myform.hidEmailcontent.value = buildURL(myform.emailcontent.value.replace(/\n/gi,"<BR>"));
               myform.hidPrefixAMCD.value='<%= URLDecoder.decode(prefixAMCD)%>';
               myform.hidSubHandle.value='<%= URLEncoder.encode(subHandle)%>';
               myform.factId.value='<%= factId%>';
               myform.submit();
            }
        return true;
    }

    function sendAnother(){
        wogShareEmail();
        var myform = document.frmEmailAnother;
        myform.hidPrefixAMCD.value='<%= URLDecoder.decode(prefixAMCD)%>';
        myform.hidSubHandle.value='<%= URLEncoder.encode(subHandle)%>';
        myform.factId.value='<%= factId%>';
        myform.submit();
        
        return true;
    }
    
    function searchuser(arg) {  
        var popSearchWin = window.open('<%= currentPage.getPath().replace("/content/","/")%>'+'.emailsearch.html', 'popSearchWin', 'height=300,width=600,scrollbars=yes,status=yes,toolbar=no,menubar=no,location=no,resizable=yes');
        popSearchWin.focus(); 
        return false;
    
    }
    
    function wogShareEmail(){
        var factIdParam = "<%=factId%>";
        $.ajax({        
            url: "/apps/mcd/docroot/wog/worldofgood.json",
            type: 'GET',
            dataType: 'json',
            timeout : '20000', 
            error: function(){
                //alert("Error In Retrieving Image Gallery Data"); 
                return;   
            },
            success: function(data){
                var wogData = data;
                for(i=0; i<wogData.length; i++){
                    var factId = wogData[i].FactId;
                    if(factId == factIdParam){
                        $("#facttitle").val(wogData[i].Title);
                        $("#emailsubject").val(wogData[i].ShareTitle);
                        $("#emailcontent").val("<b>"+wogData[i].Title+"</b>" + "\n" + wogData[i].Description);
                    }
                }
            }
        });
        
        
    }
    
    $(document).ready(function(){  
        wogShareEmail();
    });
    </script>
   <style>
        body {
           overflow:hidden;
        }
    </style>     
</body>
</html>      