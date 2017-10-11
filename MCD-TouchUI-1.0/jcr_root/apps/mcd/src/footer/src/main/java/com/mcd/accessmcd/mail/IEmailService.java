package com.mcd.accessmcd.mail;

import com.mcd.accessmcd.mail.bo.EmailDataBean;

/**
 * This interface is used for sending mail 
 *
 * @author Rajat Chawla
 * @version 1.0
 *
 */

public interface IEmailService {

    // method  for sending mail //
    public boolean sendMail(EmailDataBean bean);
}