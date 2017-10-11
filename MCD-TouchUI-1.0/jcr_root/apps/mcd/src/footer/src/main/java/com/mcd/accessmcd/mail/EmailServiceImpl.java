package com.mcd.accessmcd.mail;

import org.apache.commons.mail.EmailAttachment;
import org.apache.commons.mail.HtmlEmail;
import org.apache.commons.mail.MultiPartEmail;

import com.day.cq.mailer.MailService;
import com.mcd.accessmcd.mail.bo.EmailDataBean;
import java.util.StringTokenizer;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

/**
 * This class is used for sending mail & creating the Mail body, 
 * subject line & send to list
 *
 * @author Rajat Chawla
 * @version 1.0
 */
public class EmailServiceImpl implements IEmailService{
    
    private static final Logger log = LoggerFactory.getLogger(EmailServiceImpl.class);
    
    
    // method to send mail  return true for successful sending the mail //
    public boolean sendMail(EmailDataBean bean)
    {
        boolean flag=false;
        try {
            //  code to send the mail from the mail details retireved from felix console //
            MailService mailService = bean.getSling().getService(MailService.class);
            // this method will call the createHtmlMail method to set the values of the mail //
            MultiPartEmail  email =  new MultiPartEmail();
            HtmlEmail emailHTML = new HtmlEmail();
            
            // condition to check the attachment is available or not //
            if(null!=bean.getAttachmentPath())
            {
                 email=createMultiPartMail(bean);
                 mailService.sendEmail(email);
            }else
            {
                 emailHTML= createHtmlMail(bean);
                 mailService.sendEmail(emailHTML);
            }
            
            // method to send mail //
            
            
            flag=true;  // setting true for successful sending the mail //
        } catch (Exception e) {
            log.error("[EmailServiceImpl] exception"+e.getMessage());
            flag=false;
        }
        return flag;
    }
     // method to set the values for the mail to be sent // 
    public HtmlEmail createHtmlMail(EmailDataBean bean) throws Exception
    {
         HtmlEmail email = new HtmlEmail();
         String toEmail="";
         
          if(!bean.getSendTo().equals("")){
              // splitting the to addresses on the basis of , through stringTokenizer //
               StringTokenizer stNames=new StringTokenizer(bean.getSendTo(),",");
               while(stNames.hasMoreTokens()){
                toEmail=stNames.nextToken();
                // setting the to addresses to the email add to method for sending mails //
                email.addTo(toEmail);
                }}
                // splitting the from values on the basis of , as it has the from email adress & name of the sender //
              if(!bean.getSendFrom().equals("")){
                String fromArr[]= bean.getSendFrom().split(","); 
                email.setFrom(fromArr[0],fromArr[1]);
              }
          // setting the email subject & email HTML body //       
         email.setSubject(bean.getSubject());
         email.setHtmlMsg(bean.getBody());
         return email;
    }

    
     // method to set the values for the mail to be sent // 
    public MultiPartEmail createMultiPartMail(EmailDataBean bean) throws Exception
    {
        MultiPartEmail email = new MultiPartEmail();
        EmailAttachment attachment = new EmailAttachment();
        String toEmail="";
         
          if(!bean.getSendTo().equals("")){
              // splitting the to addresses on the basis of , through stringTokenizer //
               StringTokenizer stNames=new StringTokenizer(bean.getSendTo(),",");
               while(stNames.hasMoreTokens()){
                toEmail=stNames.nextToken();
                // setting the to addresses to the email add to method for sending mails //
                email.addTo(toEmail);
                }}
                // splitting the from values on the basis of , as it has the from email adress & name of the sender //
              if(!bean.getSendFrom().equals("")){
                String fromArr[]= bean.getSendFrom().split(","); 
                email.setFrom(fromArr[0],fromArr[1]);
              }
              
              // attachment details //
              attachment.setPath(bean.getAttachmentPath());
              attachment.setDisposition(EmailAttachment.ATTACHMENT);
              attachment.setDescription(bean.getAttachmentDescription());
              attachment.setName(bean.getAttachmentName());
                  
             // setting the email subject & email body //     
             email.setSubject(bean.getSubject());
             email.setMsg(bean.getBody());
             email.attach(attachment);
         
         return email;
    }   
    
}