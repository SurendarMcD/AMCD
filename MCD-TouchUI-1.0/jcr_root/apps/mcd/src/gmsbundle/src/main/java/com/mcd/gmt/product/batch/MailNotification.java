package com.mcd.gmt.product.batch;


import java.io.PrintWriter;
 
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.activation.*;
import javax.mail.event.TransportListener;
import javax.mail.event.TransportEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;



public class MailNotification implements TransportListener
{   //Class starts here
    private static final Logger log = LoggerFactory.getLogger(MailNotification.class);
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
            properties.put("mail.transport.protocol", "smtp");
            properties.put("mail.smtp.host", mailServer);
            Session session = Session.getDefaultInstance(properties, null);
            
            Message msg = new MimeMessage(session);
            
            InternetAddress addressFrom = new InternetAddress(fromAddress, fromAddressPersonal);
            msg.setFrom(addressFrom);
                    
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toAddress));
            
            msg.setSubject(subject);
            msg.setContent(bodyText, "text/html");
            
            log.error("Sending Exception mail.... sendExceptionEmail()");
            Transport.send(msg);
            log.error("Exception mail sent from sendExceptionEmail()");
        }
        catch(Exception messagingexception)
        {
            log.error("Exception in sending exception mail." + messagingexception);
        }
    }
    
    //Sending mail with file as attachment
    public void sendMail(String bccAddress, String toEmailId, String ccEmailId, String mailServer, String subject, String bodyText, String fromAddress, String fromAddressPersonal)
    {
        
        props=new Properties();
        props.put("mail.smtp.host", mailServer);
        
        mailSession=Session.getDefaultInstance(props, null);
 
         
        //Constructing and Sending a Message
        try
        {
            log.error("1");
            
            //Starting a new Message
            message=new MimeMessage(mailSession);
 
            //Setting the Sender and Recipients
            sender=new InternetAddress(fromAddress, fromAddressPersonal);
            message.setFrom(sender);
             log.error("2 sender :: " + fromAddress);
            
            log.error("3");
            message.setRecipients(Message.RecipientType.TO,InternetAddress.parse(toEmailId));
            log.error("41 toEmailId :: " + toEmailId);
            
            
            message.setRecipients(Message.RecipientType.CC, InternetAddress.parse(ccEmailId));
            
            log.error("51");
            message.setRecipients(Message.RecipientType.BCC, InternetAddress.parse(bccAddress));
            log.error("11111");
            recipients=message.getAllRecipients();
            log.error("2222222222");
            //Setting the Subject and Headers
            message.setSubject(subject);
            log.error("6666666666");
                
            // Put parts in message
            message.setContent(bodyText, "text/html"); 
            
            log.error("9");
            //Sending the Message           
            
            log.error("10");
            
            log.error("11");
            
            Transport.send(message);
            log.error("12");
            
            
            log.error("************ GMT PAGE ACTIVATION Mail successfully sent ****************");          
        }
        catch(NullPointerException e)
        {
            log.error("!!!NullPointerException!!! ::::::::::: " + e.getMessage());
            
        }
        catch(MessagingException e)
        {
            //System.log.error(e);
            log.error("MessagingException ::::::::::::::::::::::::::::::::::::: " + e.getMessage());
        }
        catch(IllegalStateException e)
        {
            //System.log.error(e);
            log.error(" IllegalStateException ::::::::::::::::::::: " + e.getMessage());
        }
        catch(Exception ex){
            log.error("!!!exception1!!! :: " + ex);
        }
        finally
        {
            try
            {
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
                //System.log.error(e);
                log.error(e.getMessage());
            }
        }
    }

    
    
    public void messageDelivered(TransportEvent e)
    {
        log.error("*********** Message successfully delivered to: ***********");
        
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
            
        } 
        catch(Exception ert) 
        { 
            log.error( ert.getMessage() ); 
        } 

        log.error("TransportListener.messageDelivered:"+ HFID);

        Address[] valid = e.getValidSentAddresses(); 

        if (valid != null) 
        { 
            for (int i = 0; i < valid.length; i++) 
                log.error("Valid Addresses: " + valid[i]); 
        } 
        
        Address[] validUnsent = e.getValidUnsentAddresses(); 
        log.error("validUnsent : " + validUnsent);
        if (validUnsent != null) 
        { 
            for (int i = 0; i < validUnsent.length; i++) 
                log.error("Valid Unsent Addresses: " + validUnsent[i]); 
        } 
        
        Address[] invalid = e.getInvalidAddresses(); 
        log.error("invalid : " + invalid);
        if (invalid != null) 
        { 
            for (int i = 0; i < invalid.length; i++) 
                log.error("Invalid Addresses: " + invalid[i]); 
        } 
    }
 
    public void messageNotDelivered(TransportEvent e)
    {
        log.error("*********** Message not delivered ***********");
        
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
            log.error( ""+ ert.getMessage()); 
        } 
    
        log.error( "TransportListener.messageNotDelivered :"+ "" + HFID); 
    
        Address[] invalid = e.getInvalidAddresses(); 
        
        if (invalid != null) 
        { 
            for (int i = 0; i < invalid.length; i++) 
                log.error("Invalid Addresses: " + invalid[i]); 
        } 
        
        Address[] validUnsent = e.getValidUnsentAddresses(); 
        log.error("validUnsent : " + validUnsent);
        if (validUnsent != null) 
        { 
            for (int i = 0; i < validUnsent.length; i++) 
                log.error("Valid Unsent Addresses: " + validUnsent[i]); 
        } 
    }
 
    public void messagePartiallyDelivered(TransportEvent e)
    {
        log.error("*********** Message partially delivered ************");
    }

}
 