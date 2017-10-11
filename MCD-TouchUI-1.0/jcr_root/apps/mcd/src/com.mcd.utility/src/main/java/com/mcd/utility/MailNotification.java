package com.mcd.utility;

import java.io.PrintWriter;
import java.io.StringWriter; 
import java.util.Properties;
import javax.mail.Transport;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MailNotification
{   //Class starts here
    private static final Logger log = LoggerFactory.getLogger(MailNotification.class);
    
     
    //private Properties props=null;
   
                    
    //Sends Exception mail
    public void sendExceptionEmail(Exception exception)    {
        try
        {
            StringWriter sw = new StringWriter();
            exception.printStackTrace(new PrintWriter(sw));
            
            Properties properties = new Properties();
            properties.put("mail.smtp.host", "localhost");
            Session session = Session.getDefaultInstance(properties, null);
            
            Message msg = new MimeMessage(session);
            
            InternetAddress addressFrom = new InternetAddress("donotreply@us.mcd.com", "US Redesign");
            msg.setFrom(addressFrom);
                    
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse("deepali.goyal@hcl.in,karan_aggarwal@hcl.in"));
            
            msg.setSubject("Exception");
                msg.setContent(sw.toString(), "text/html"); 
            log.error("************************Sending Exception mail1.");
                Transport.send(msg);
            log.error("############################Exception mail sent.");
            session=null;
        }
        catch(Exception messagingexception)
        {
            log.error("########################Exception in sending exception mail." + messagingexception.getMessage());
        }        
    }    
}