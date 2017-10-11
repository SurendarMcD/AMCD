package com.mcd.accessmcd.mail.dao;

import org.apache.sling.api.scripting.SlingScriptHelper;

/**
 * This interface is used for inserting the mail data into database  
 *
 * @author Rajat Chawla
 * @version 1.0
 *
 */

public interface IEmailDAO {
    // interface for storing the values in the database //
    public void postEmailData (String sender_id, String sender_role, String article_url, String article_name, String sendto,SlingScriptHelper sling);

}