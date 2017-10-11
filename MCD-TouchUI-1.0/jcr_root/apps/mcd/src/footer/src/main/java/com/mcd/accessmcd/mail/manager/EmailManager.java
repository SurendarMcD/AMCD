package com.mcd.accessmcd.mail.manager;

import org.apache.sling.api.scripting.SlingScriptHelper;
import com.mcd.accessmcd.mail.IEmailService;
import com.mcd.accessmcd.mail.bo.EmailDataBean;
import com.mcd.accessmcd.mail.dao.IEmailDAO;
import com.mcd.accessmcd.mail.dao.EmailDAOImpl;
import com.mcd.accessmcd.mail.EmailServiceImpl;

/**
 * This class is used for sending mail & saving the mail data in the database
 *
 * @author Rajat Chawla
 * @version 1.0
 *
 */
public class EmailManager {
    
    // creating object for the respective classes //
    IEmailService emailService = new EmailServiceImpl();
    IEmailDAO emailDAO = new EmailDAOImpl();

    
    // method to send the mail and return true or false accordingly//
    public boolean sendEmail(EmailDataBean bean)
    {
        
        boolean flag=emailService.sendMail(bean);
        return flag;
    }
    
    // method to data of the mail into the database // 
    public void postEmailData(String sender_id, String sender_role, String article_url, String article_name, String sendto,SlingScriptHelper sling)
    {
        emailDAO.postEmailData(sender_id, sender_role, article_url, article_name, sendto, sling);
    }
}