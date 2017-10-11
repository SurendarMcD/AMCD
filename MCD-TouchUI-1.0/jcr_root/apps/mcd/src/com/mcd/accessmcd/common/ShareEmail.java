package com.mcd.accessmcd.common;

import com.mcd.accessmcd.mail.EmailServiceImpl;
import com.mcd.accessmcd.mail.IEmailService;
import com.mcd.accessmcd.mail.bo.EmailDataBean;
import org.apache.sling.api.scripting.SlingScriptHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.day.cq.mailer.MailService;
import java.util.StringTokenizer;
import org.apache.commons.mail.HtmlEmail;


public class ShareEmail
{
  
  private static final Logger log = LoggerFactory.getLogger(ShareEmail.class);
  IEmailService emailService = new EmailServiceImpl();
  
  public boolean sendMail(EmailDataBean bean)
  {
    boolean flag = false;
    try
    {
      MailService mailService = (MailService)bean.getSling().getService(MailService.class);

      HtmlEmail email = createHtmlMail(bean);
      email.setCharset("UTF-8");
      mailService.sendEmail(email);
      flag = true;
      System.out.println("***** Sending Email From ShareEmail Java *****");
      
    } catch (Exception e) {
      log.error("[EmailServiceImpl] exception" + e.getMessage());
      flag = false;
    }
    return flag;
  }

  public HtmlEmail createHtmlMail(EmailDataBean bean) throws Exception
  {
    HtmlEmail email = new HtmlEmail();
    String toEmail = "";

    if (!bean.getSendTo().equals(""))
    {
      StringTokenizer stNames = new StringTokenizer(bean.getSendTo(), ",");
      while (stNames.hasMoreTokens()) {
        toEmail = stNames.nextToken();

        email.addTo(toEmail);
      }
    }
    if (!bean.getSendFrom().equals("")) {
      String[] fromArr = bean.getSendFrom().split(",");
      //email.setFrom(fromArr[0], fromArr[1]);
      email.setFrom("noreply@mcdonalds.com", fromArr[1]);
    }

    email.setSubject(bean.getSubject());
    email.setHtmlMsg(bean.getBody());
    return email;
  }
 
}  