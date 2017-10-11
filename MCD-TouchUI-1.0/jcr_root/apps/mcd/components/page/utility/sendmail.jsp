<%--
  ==============================================================================
  Test sending of HTML email
  
    Erik Wannebo 5/11/2017 
  ==============================================================================
--%>
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page session="false" %>
<%@ page import="java.util.*, 
                java.net.*,
                java.io.*,
                java.lang.*,
                java.util.Date,
                java.util.Calendar,
                java.text.SimpleDateFormat,
                javax.jcr.Session, 
                java.util.Enumeration,
                org.apache.sling.api.scripting.SlingScriptHelper,
                com.day.cq.security.*,
				com.mcd.accessmcd.mail.bo.EmailDataBean,
				com.mcd.accessmcd.common.ShareEmail,
				com.day.cq.mailer.MailService,
				com.adobe.acs.commons.email.EmailService,
				org.apache.commons.mail.HtmlEmail"
                    %>
<%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %> 
<sling:defineObjects/>

     
<%
        response.setHeader("Cache-Control","no-cache");
        response.setHeader("Cache-Control","no-store");
        response.setDateHeader("Expires", 0);
        response.setHeader("Pragma","no-cache");
  
%>  
                
<html>

<head> 

<title>Send HTML Email </title>

</head>
<body >
<%
boolean breturn=false;

    try{
        /*
        ShareEmail shareEmail = new ShareEmail();
           EmailDataBean mdb = new EmailDataBean(); 
           // setting the values to the bean //
           mdb.setSendTo("erik.wannebo@us.mcd.com");
           mdb.setSendFrom("noreply@us.mcd.com");
           mdb.setSubject("SharePlus Test");
           String strBody="a href='https://spo.mcd.com/' data-scheme='shareplus://spo.mcd.com/'>shareplus link</a>";
           mdb.setBody(strBody);
           mdb.setSling(sling);
           breturn=shareEmail.sendMail(mdb);

           // calling method to send the mail //


          MailService mailService = (MailService)bean.getSling().getService(MailService.class);

            HtmlEmail email = shareEmail.createHtmlMail(mdb);
            email.setCharset("UTF-8");
            mailService.sendEmail(email);
			breturn=true;
            */

		EmailService emailService = sling.getService(EmailService.class);
		HtmlEmail email = new HtmlEmail();
        email.setHostName("dalsmtprelay.mcd.com");
        email.addTo("erik.wannebo@us.mcd.com", "Erik Wannebo");
        email.setFrom("erik.wannebo@us.mcd..com", "Erik Wannebo");
        email.setSubject("Test SharePlus link");

        // set the html message //
        email.setHtmlMsg("<html><a href='https://spo.mcd.com/' data-scheme='shareplus://spo.mcd.com/'>shareplus link</a></html>");
         
        // set the alternative message
        email.setTextMsg("Your email client does not support HTML messages");
        email.send();

		breturn=true;


        //
}catch(Exception e){
}


%>
Email Sent:<%=breturn%>


</body>

</html>

     
     