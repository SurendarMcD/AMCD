//Judy Zhang , 08/22/2010
//Mail notification tool

package com.mcd.accessmcd.ace.scheduler;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.PrintWriter;
 
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;
import javax.mail.event.TransportListener;
import javax.mail.event.TransportEvent;
import java.util.logging.Logger;
import com.mcd.accessmcd.ace.scheduler.ContentExpirationLogger;

public class MailNotification implements TransportListener
{   //Class starts here
//    private ContentExpirationLogger log = ContentExpirationLogger.getInstance("MailNotification");
    private PrintWriter out=null;
    private String to;   
    private Properties props=null;
    private Session mailSession=null;
    private Transport transport=null;
 
    private MimeMessage message;
    private InternetAddress sender;
    private InternetAddress[] toList=null;
    private Address[] recipients=null;
    private Multipart mailBody;
    private MimeBodyPart mainBody;
    
    //Sends Exception mail
    protected void sendExceptionEmail(String toAddress, String subject, String bodyText, String mailServer, String fromAddress, String fromAddressPersonal) throws Exception
    {
        try
        {
            Properties properties = new Properties();
            properties.put("mail.smtp.host", mailServer);
            Session session = Session.getDefaultInstance(properties, null);
            
            Message msg = new MimeMessage(session);
            
            InternetAddress addressFrom = new InternetAddress(fromAddress, fromAddressPersonal);
            msg.setFrom(addressFrom);
                    
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toAddress));
            
            msg.setSubject(subject);
                msg.setContent(bodyText, "text/html");
                Transport.send(msg);
            ContentExpirationLogger.info("Exception mail sent.");
        }
        catch(Exception messagingexception)
        {
            
        }
    }
    
    //Sending mail with file as attachment
    public void sendMail(String bccAddress, ArrayList adminEmailId, ArrayList membersEmailId, String mailServer, 
    String subject, String bodyText, String fromAddress, String filePath, String fileName, String fromAddressPersonal)
    {
        ContentExpirationLogger.info("***** MailNotification.sendMail starting *****");
        props=new Properties();
        props.put("mail.transport.protocol", "smtp");
        props.put("mail.smtp.host", mailServer);
        
        mailSession=Session.getInstance(props);
 
        //Selecting a Transport mechanism
        try
        {
            transport=mailSession.getTransport();
            transport.addTransportListener(this);
        }
        catch(NoSuchProviderException e)
        { 
            ContentExpirationLogger.info(e.getMessage());
        }
 
        //Constructing and Sending a Message
        try
        {
            
            //Starting a new Message
            message=new MimeMessage(mailSession);
 
            //Setting the Sender and Recipients
            sender=new InternetAddress(fromAddress, fromAddressPersonal);
            message.setFrom(sender);
             
            Address toAddress[] = new Address[adminEmailId.size()];
            for (int i=0; i<adminEmailId.size(); i++){
                InternetAddress internetaddress = new InternetAddress((String)adminEmailId.get(i));
                toAddress[i] = internetaddress;
                ContentExpirationLogger.info("***** To Email Addresses *****" + (String)adminEmailId.get(i));  
                //System.out.println("***** To Email Addresses *****" + (String)adminEmailId.get(i)); 
            }
            message.setRecipients(Message.RecipientType.TO, toAddress);
            if(membersEmailId.size() > 0){
                Address ccAddress[] = new Address[membersEmailId.size()];
                for(int i=0; i<membersEmailId.size(); i++)
                {
                        InternetAddress internetaddress = new InternetAddress((String)membersEmailId.get(i));
                        ccAddress[i] = internetaddress;  
                        ContentExpirationLogger.info("***** CC Email Addresses *****" + (String)membersEmailId.get(i));    
                        //System.out.println("***** CC Email Addresses *****" + (String)membersEmailId.get(i));     
                }
                    message.setRecipients(Message.RecipientType.CC, ccAddress);
            }    
            message.setRecipients(Message.RecipientType.BCC, InternetAddress.parse(bccAddress));
            
            //Setting the Subject and Headers
            message.setSubject(MimeUtility.encodeText(subject,"UTF-8", "B"));
             // create the message part 
            MimeBodyPart messageBodyPart = new MimeBodyPart();

                //Setting the Message body
                messageBodyPart.setContent(bodyText, "text/html; charset=utf-8");

                Multipart multipart = new MimeMultipart();
                multipart.addBodyPart(messageBodyPart);

                // Part two is attachment
                messageBodyPart = new MimeBodyPart();
                DataSource source = new FileDataSource(filePath);
                messageBodyPart.setDataHandler(new DataHandler(source));
                messageBodyPart.setFileName(fileName);
                multipart.addBodyPart(messageBodyPart);

                // Put parts in message
                message.setContent(multipart); 
            message.setHeader("X-mailer", "MailNotification v1.0");                 
            message.saveChanges();
            
            //Sending the Message           
            transport.connect();
            ContentExpirationLogger.info("************ 1 ****************"); 
            recipients=message.getAllRecipients();
            ContentExpirationLogger.info("************ 2 ****************"); 
            transport.sendMessage(message, recipients);
            ContentExpirationLogger.info("************ 3 ****************"); 
            transport.close();
            
            ContentExpirationLogger.info("************ ContentExpiration Mail successfully sent ****************");          
        }
        catch(NullPointerException e)
        {
            if(recipients==null || recipients.length==0)
            {
                //System.log.info(e);
                ContentExpirationLogger.info("No recipient addresses");
            }
            else
            {
                //System.log.info(e);
                ContentExpirationLogger.info(e.getMessage());
            }
        }
        catch(MessagingException e)
        {
            //System.log.info(e);
            ContentExpirationLogger.info("***** MessagingException1 *****");
            ContentExpirationLogger.info(e.getMessage());
        }
        catch(IllegalStateException e)
        {
            //System.log.info(e);
            ContentExpirationLogger.info("***** MessagingException2 *****");
            ContentExpirationLogger.info(e.getMessage());
        }
        catch(Exception ex){
            ContentExpirationLogger.info("***** MessagingException3 *****");
            ContentExpirationLogger.info(ex.getMessage());
            //java.io.StringWriter sw = new java.io.StringWriter();
            //ex.printStackTrace(new PrintWriter(sw));
            //ContentExpirationLogger.info(sw.toString());
        }
        finally
        {
            try
            {
            ContentExpirationLogger.info("*****InFinally *****");
                props=null;
                mailSession=null;
                transport=null;
                message=null;
                sender=null;
                mailBody=null;
                mainBody=null;
                //to=null;
                subject=null;
                bodyText=null;
            }
            catch(Exception e)
            {
                //System.log.info(e);
                ContentExpirationLogger.info(e.getMessage());
            }
        }
    }

    
    
    public void messageDelivered(TransportEvent e)
    {
        ContentExpirationLogger.info( "*********** Message successfully delivered to: ***********");
/*        
        String HFID = null; 
        Message msgDel=e.getMessage(); 
        try 
        { 
            String[] HFIDArr = msgDel.getHeader("Return-Receipt-To"); 
            if (HFIDArr != null) 
            { 
                for (int i = 0; i < HFIDArr.length; i++) 
                { 
                    HFID=HFIDArr[i].toString(); 
                } 
            }
            
            Enumeration enum = msgDel.getAllHeaders();
            while(enum.hasMoreElements())
            {
                String test= ((Header)enum.nextElement()).getName();
                 
                ContentExpirationLogger.info("Header Name :: "+test);
            } 
        } 
        catch(Exception ert) 
        { 
            ContentExpirationLogger.info( ert.getMessage() ); 
        } 

        ContentExpirationLogger.info("TransportListener.messageDelivered:"+ HFID);

        Address[] valid = e.getValidSentAddresses(); 

        if (valid != null) 
        { 
            for (int i = 0; i < valid.length; i++) 
                ContentExpirationLogger.info("Valid Addresses: " + valid[i]); 
        } 
        
        Address[] validUnsent = e.getValidUnsentAddresses(); 
        ContentExpirationLogger.info("validUnsent : " + validUnsent);
        if (validUnsent != null) 
        { 
            for (int i = 0; i < validUnsent.length; i++) 
                ContentExpirationLogger.info("Valid Unsent Addresses: " + validUnsent[i]); 
        } 
        
        Address[] invalid = e.getInvalidAddresses(); 
        ContentExpirationLogger.info("invalid : " + invalid);
        if (invalid != null) 
        { 
            for (int i = 0; i < invalid.length; i++) 
                ContentExpirationLogger.info("Invalid Addresses: " + invalid[i]); 
        } 
*/
    }
 
    public void messageNotDelivered(TransportEvent e)
    {
        ContentExpirationLogger.info("*********** Message not delivered ***********");
        
        String HFID=null;
        Message msgDel=e.getMessage(); 
        try 
        { 
            String[] HFIDArr=msgDel.getHeader("To"); 
            if (HFIDArr != null) 
            { 
                for (int i = 0; i < HFIDArr.length; i++) 
                { 
                    HFID=HFIDArr[i].toString(); 
                } 
            } 
        } 
        catch(Exception ert) 
        { 
            ContentExpirationLogger.info( ""+ ert.getMessage()); 
        } 
    
        ContentExpirationLogger.info( "TransportListener.messageNotDelivered :"+ "" + HFID); 
    
        Address[] invalid = e.getInvalidAddresses(); 
        
        if (invalid != null) 
        { 
            for (int i = 0; i < invalid.length; i++) 
                ContentExpirationLogger.info("Invalid Addresses: " + invalid[i]); 
        } 
        
        Address[] validUnsent = e.getValidUnsentAddresses(); 
        ContentExpirationLogger.info("validUnsent : " + validUnsent);
        if (validUnsent != null) 
        { 
            for (int i = 0; i < validUnsent.length; i++) 
                ContentExpirationLogger.info("Valid Unsent Addresses: " + validUnsent[i]); 
        } 
    }
 
    public void messagePartiallyDelivered(TransportEvent e)
    {
        ContentExpirationLogger.info("*********** Message partially delivered ************");
    }

}  