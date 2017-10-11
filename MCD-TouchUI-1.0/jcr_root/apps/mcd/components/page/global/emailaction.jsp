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

    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="STYLESHEET" type="text/css" href="/apps/mcd/docroot/css/emailfooter.css">
    <script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script>  
    <script type="text/javascript" src="/apps/mcd/docroot/scripts/common.js"></script>
    <title><%= currentPage.getTitle() %></title>
    </head>
    
     <% 
     // creating user object //
     final User user = slingRequest.getResourceResolver().adaptTo(User.class);
     // getting the bundle value on the basis of the language selected//
     ResourceBundle bundle =resourceBundle;

     %>   
    
        <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
            <tr>
            <td>&nbsp;</td>
                </tr>
        </table>        
        <table width="90%" align="center" border="0" cellspacing="0" cellpadding="0" class="grey1bg">
            <tr>
            <td align="left" width="100%" class="FootertitleGrey"><b>&nbsp;&nbsp;<%= bundle.getString("PAF_TITLE") %></b></td>
            <td>&nbsp;</td>
                </tr>
         </table>       
    
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
    
      public String rejectCheck(String expression,String param){ 
    
    for (int i = 0; i < expression.length(); i++){
    String c = "" + expression.charAt(i);   
 
    param = param.replace(c,"");
    }
    return(param.trim());
    }
    %>
    
    <% 
    // code to retrieved the prefix from the URL//
    String prefixAMCD="";
    String regex= "/[-!$%&^<>*()_+@|~\"\'`=\\#{}\\[\\]:;?,.\\/]";
        if(null!=request.getParameter("prefixAMCD"))
        {
            prefixAMCD=URLDecoder.decode(request.getParameter("prefixAMCD"));
             prefixAMCD = rejectCheck(regex,prefixAMCD);
        }
    
    String sendTo = "";
    String subject= "";
    String body = "";
    String sendFrom = "";
    String title ="no title";
    String securityWarn = "The information contained in this e-mail and any accompanying documents is confidential, may be privileged, and is intended solely for the person and/or entity to whom it is addressed (i.e. those identified in the 'To' and 'cc' box). They are the property of McDonald's Corporation. Unauthorized review,use, disclosure, or copying of this communication, or any part thereof, is strictly prohibited and may be unlawful. If you have received this e-mail in error, please return the e-mail and attachments to the sender and delete the e-mail and attachments and any copy from your system. McDonald's thanks you for your cooperation.";
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
        prefixAMCD = rejectCheck(regex,prefixAMCD);
    if (request.getParameter("hidSubHandle")!=null)
        subHandle = URLDecoder.decode(request.getParameter("hidSubHandle"));
        subHandle = rejectCheck(regex,subHandle);
    String linkInfo = "<B>"+bundle.getString("PAF_LINKTITLE")+ title +"</B><BR>"+"<B>"+ bundle.getString("PAF_ARTICLE")+"</B> " + prefixAMCD +subHandle+"<BR><BR>";
    String sendEmail = "no";
    
    if (request.getParameter("hidSendEmail")!=null)
       sendEmail = request.getParameter("hidSendEmail");
        sendEmail= rejectCheck(regex,sendEmail);
    if ( sendEmail !=null && sendEmail.equalsIgnoreCase("yes") ) {
    
    if (request.getParameter("hidShareUserEmail")!=null)
             sendTo = request.getParameter("hidShareUserEmail");
              sendTo= rejectCheck(regex,sendTo);
    if (request.getParameter("hidEmailsubject")!=null)
        subject = request.getParameter("hidEmailsubject");
        subject = java.net.URLDecoder.decode(subject,"UTF-8");   
        subject= rejectCheck(regex,subject);  
    if (request.getParameter("hidEmailcontent")!=null)
        body = request.getParameter("hidEmailcontent");
        body= rejectCheck(regex,body);
        body = java.net.URLDecoder.decode(body,"UTF-8")+"<BR><BR>"+ linkInfo + bundle.getString("PAF_LINKWARN") +"<BR><BR>"+bundle.getString("PAF_LEGAL");
    if (request.getParameter("emailfrom")!=null)
     sendFrom = request.getParameter("emailfrom");
     sendFrom= rejectCheck(regex,sendFrom);
     
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
        
        <table width="100%" border="0"   cellspacing="0" cellpadding="0">
        <tr><td> &nbsp; </td></tr>
        <tr><td> &nbsp; </td></tr>
        <tr><td class="FootertitleBlack" align="center"><b> <%= bundle.getString("PAF_THANKYOU") %> </b></td></tr>
        <tr><td> &nbsp; </td></tr>
        <tr><td class="FootertitleBlack" align="center"><b> <%= bundle.getString("PAF_MSG_SENT") %> </b></td></tr>
        <tr><td> &nbsp; </td></tr>
        <tr><td class="FootertitleGrey" align="center"><b> <%= bundle.getString("PAF_SENDMORE") %> </b></td></tr>
        <tr><td> &nbsp; </td></tr>
           <tr bgcolor="" class="assetLabel">
            <td align="center">
                <nobr><a href="#" onclick="sendAnother();" class="contentlnkbold"><img src="/apps/mcd/docroot/images/action_send.gif" border=0 align=absmiddle><%= bundle.getString("PAF_ANOTHER") %></a></nobr> 
                <font class="txt3">|</font>
                <nobr><a href="#" onclick="javascript:window.parent.killColorBox();" class="contentlnkbold"><img src="/apps/mcd/docroot/images/icon_button_close.gif" border=0 align=absmiddle><%= bundle.getString("PAF_CANCEL") %></a></nobr> 
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
    <input type=hidden name="hidShareUserEmail" value="" >
    <input type=hidden name="hidPrefixAMCD" value="">
    <input type=hidden name="hidSubHandle" value="">
    
    
    <table width="90%" align="center" border="0"   cellspacing="0" cellpadding="0">
       <tr  class="FootertitleGrey" valign="top">
            <td align="center">
               &nbsp; <%= bundle.getString("PAF_SENDLINKTO") %>
        </td>
       </tr>    
    
       <tr  class="Footerbodybold" valign="top">
        <td>
            <table width="100%" border="0"   cellspacing="0" cellpadding="0">
               <tr  class="Footerbodybold" valign="top" >
                <td>
                       &nbsp; <%= bundle.getString("PAF_TO") %>:
                </td>
                <td>
                        <TEXTAREA class=query NAME="sendToEmail" COLS=35 ROWS=2 ID="sendToEmail" ></TEXTAREA>
                   <!--input type="text" name="sendToEmail" size ="55" value="" -->
               
                        &nbsp;<nobr><a href="#" onclick="return searchuser('to');" class="contentlnkbold"><img src="/apps/mcd/docroot/images/icon_searchemail.gif" border=0 align=absmiddle ALT="Search for User"></a> </nobr>
                    
                </td>
               </tr>
                <tr>
                    <td>
                </td>
                        <td valign=top class="FootertitleRed">
                           <%= bundle.getString("PAF_MOREADDR") %>
                        </td>
                </tr>
                <tr>
                    <td>
                </td>
                        <td >
                               <INPUT TYPE=CHECKBOX NAME="hidAddMe" value="addme">
                           <%=bundle.getString("PAF_ADDME") %>
                        </td>
                </tr>
               <tr  class="Footerbodybold" valign="top">
                <td>
                       &nbsp; <%= bundle.getString("PAF_FROMNAME") %>:
                </td>
                <td>
                   <input type="text" name="emailfromname" size ="55" value="<%=senderName%>" disabled>
                </td>
               </tr>
               <tr  class="Footerbodybold" valign="top">
                <td>
                       &nbsp; <%= bundle.getString("PAF_FROM") %>:
                </td>
                <td>
                   <input type="text" name="emailfrom" size ="55" value="<%=senderEmail%>" disabled>
                </td>
               </tr>
               <tr  class="Footerbodybold" valign="top">
                <td>
                       &nbsp; <%= bundle.getString("PAF_SUBJECT") %>:
                </td>
                <td>
                   <input type="text" name="emailsubject" size ="55" value="<%=subject%>" >
                </td>
               </tr>
                       <tr><td></td><tr>
                   <tr>
                        <td valign=top  class="Footerbodybold">
                            &nbsp; <%= bundle.getString("PAF_BODY") %>:
                        </td>
                    <td valign=top  class="query">
                        <TEXTAREA class=query NAME="emailcontent" COLS=35 ROWS=7></TEXTAREA>
                    </td>
                    </tr>
                        
                <tr>
                    <td>
                </td>
                        <td valign=top>
                               <!--INPUT type="button" name="mysubmit" onclick="return sendEmail('<%=senderEmail%>');" value="Submit"> </nobr-->
                           <nobr><a href="#" onclick="sendEmail('<%=senderEmail%>');" class="contentlnkbold"><img src="/apps/mcd/docroot/images/action_send.gif" border=0 align=absmiddle> <%=bundle.getString("PAF_SUBMIT") %> </a></nobr> 
                           <font class="txt3">|</font>
                           <nobr><a href="#" onclick="javascript:window.parent.killColorBox();" class="contentlnkbold"><img src="/apps/mcd/docroot/images/icon_button_close.gif" border=0 align=absmiddle> <%=bundle.getString("PAF_CLOSE") %> </a></nobr> 
                           <br>
    
                        </td>
                </tr>
                  </table>
            </td>
        </tr>              
    
    </table>
    
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
               myform.submit();
            }
        return true;
    }

    function sendAnother(){
        var myform = document.frmEmailAnother;
        myform.hidPrefixAMCD.value='<%= URLDecoder.decode(prefixAMCD)%>';
        myform.hidSubHandle.value='<%= URLEncoder.encode(subHandle)%>';
        myform.submit();
        return true;
    }
    
    function searchuser(arg) {  
        var popSearchWin = window.open('<%= currentPage.getPath().replace("/content/","/")%>'+'.emailsearch.html', 'popSearchWin', 'height=300,width=600,scrollbars=yes,status=yes,toolbar=no,menubar=no,location=no,resizable=yes');
        popSearchWin.focus(); 
        return false;
    
    }
    </script>
      
     