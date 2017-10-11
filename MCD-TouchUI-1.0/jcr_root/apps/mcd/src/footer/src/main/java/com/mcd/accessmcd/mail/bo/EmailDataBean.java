package com.mcd.accessmcd.mail.bo;

import org.apache.sling.api.scripting.SlingScriptHelper;

/**
 * This class is used generating the getter & setter 
 * for the value objects 
 *
 * @author Rajat Chawla
 * @version 1.0
 *
 */

public class EmailDataBean {
    
    private String sendTo; // for storing send to addresses //
    private String sendCC; // for storing cc addresses //
    private String sendFrom; // for storing from addresses //
    private String subject; // for storing subject //
    private String body; // for storing body of the mail //
    private SlingScriptHelper sling; // for storing sling object //
    private String attachmentPath; // attachment Path
    private String attachmentDescription; // attachment description 
    private String attachmentName; // attachment Name
    
        
    
    
    // generated getter & setters for storing the values //
    public String getSendTo() {
        return sendTo;
    }
    public void setSendTo(String sendTo) {
        this.sendTo = sendTo;
    }
    public String getSendCC() {
        return sendCC;
    }
    public void setSendCC(String sendCC) {
        this.sendCC = sendCC;
    }
    public String getSendFrom() {
        return sendFrom;
    }
    public void setSendFrom(String sendFrom) {
        this.sendFrom = sendFrom;
    }
    public String getSubject() {
        return subject;
    }
    public void setSubject(String subject) {
        this.subject = subject;
    }
    public String getBody() {
        return body;
    }
    public void setBody(String body) {
        this.body = body;
    }
    
    public SlingScriptHelper getSling() {
        return sling;
    }
    public void setSling(SlingScriptHelper sling) {
        this.sling = sling;
    }
    public String getAttachmentPath() {
        return attachmentPath;
    }
    public void setAttachmentPath(String attachmentPath) {
        this.attachmentPath = attachmentPath;
    }
    public String getAttachmentDescription() {
        return attachmentDescription;
    }
    public void setAttachmentDescription(String attachmentDescription) {
        this.attachmentDescription = attachmentDescription;
    }
    public String getAttachmentName() {
        return attachmentName;
    }
    public void setAttachmentName(String attachmentName) {
        this.attachmentName = attachmentName;
    }
    

    

}