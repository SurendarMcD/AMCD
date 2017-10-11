package com.mcd.cq.auth.impl;
/*
 * Copyright (c) 2007 McDonald's, Corp.
 * All rights reserved.
 *
 * This software is the confidential and proprietary information of McDonald's
 * Corporation. ("Confidential Information").  You shall not
 * disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into
 * with McDonald's.
 */


import java.util.HashMap;
import java.util.List;

import org.apache.log4j.Logger;
import org.jdom.Element;
import org.jdom.Namespace;



/**
 * 
 * Class to retreive and hold data from SAMLResponse.  
 * Logic for getting fields is based on SAML 2.0 xsd.
 * More info in saml-core 2.5.1.1
 * 
 * @version 1.0 Apr 2008
 * @author McDonald's Corporation
 */
public class StatusResponse {
    
    //constants
    private static final String STATUS      = "Status";
    private static final String STATUS_CODE = "StatusCode";
    private static final String VALUE       = "Value";
    private static final String ASSERTION   = "Assertion";
    private static final String SUBJECT     = "Subject";
    private static final String NAMEID      = "NameID";
    private static final String CONDITIONS  = "Conditions";
    private static final String NOTBEFORE   = "NotBefore";
    private static final String NOTONORAFTER = "NotOnOrAfter";
    private static final String AUTHNSTATEMENT = "AuthnStatement";
    private static final String SESSIONINDEX = "SessionIndex";
    
    private static Logger logger = Logger.getLogger(StatusResponse.class);
    
    private Element element;    
    private String statusCode;
    private String notBefore;
    private String notOnOrAfter;
    private String userId;
    private String sessionIndex;
    private HashMap attributeData;
    private Namespace assertNamespace = Namespace.getNamespace(SAMLConstants.NS_ASSERTION);
    private Namespace samlNamespace = Namespace.getNamespace(SAMLConstants.NS_SAML_PROTOCOL);
    
    /**
     * Constructor for StatusResponse
     * @param element the Element representing the SAMLResponse
     * @throws SAMLException if there are any exceptions while reading the response
     */
    public StatusResponse(Element element) throws SAMLException {
    //logger.error("StatusResponse constructor");
        this.element = element;
        setStatus();
        setUserId();
        if(!userId.equals("LOGOUT")){
            setSessionIndex();
            setAttributes();
            setConditions();
        }
    }
    
    //constructor for logouts
    public StatusResponse(String bypassuserid) throws SAMLException {
    //logger.error("StatusResponse constructor");
        this.userId=bypassuserid;
    }
    
    /**
     * Sets up the HashMap of assertion attributes
     */
    private void setAttributes() throws SAMLException
  {
      Namespace assertNamespace = Namespace.getNamespace("urn:oasis:names:tc:SAML:2.0:assertion");
      HashMap attributeData;
    try
    {
      this.attributeData = new HashMap();
      Element assertElement = element.getChild("Assertion", assertNamespace);
      Element attrsElement = assertElement.getChild("AttributeStatement", assertNamespace);
      List<Element> attributes = attrsElement.getChildren("Attribute", assertNamespace);
      for (Element attribute : attributes)
      {
        String name = attribute.getAttributeValue("Name");
        String value = attribute.getChildText("AttributeValue", assertNamespace);
        this.attributeData.put(name, value);
      }
    } catch (NullPointerException npe) {
      throw new SAMLException(npe);
    }
  }
    /**
     * @return the earliest time instant at which the assertion is valid (UTC)
     */
    public String getNotBefore() {
        return SAMLUtil.getNotNullString(notBefore);
    }

    /**
     * @return the time instant at which the assertion has expired (UTC)
     */
    public String getNotOnOrAfter() {
        return SAMLUtil.getNotNullString(notOnOrAfter);
    }

    /**
     * @return the status code from the SAMLResponse.
     */
    public String getStatusCode() {
        return SAMLUtil.getNotNullString(statusCode);
    }

    /**
     * @return the userID in the subject confirmation of the assertion
     */
    public String getUserId() {
        return userId;
    }


    public String getSessionIndex() {
        return sessionIndex;
    }
    
        
    /**
     * @return the attributes included in the SAML Response
     */
    public HashMap getAttributeData() {
        return this.attributeData;
    }
    
    private void setStatus() throws SAMLException {
        try {
            Element statusElement = element.getChild(STATUS, samlNamespace);
            Element statusCodeElement = statusElement.getChild(STATUS_CODE, samlNamespace);
            statusCode = statusCodeElement.getAttributeValue(VALUE);
        } catch (NullPointerException npe){
            logger.error("NullPointerException when trying to retrieve status from SAMLResponse");
            throw new SAMLException(npe);
        }
    }
    
    private void setUserId() throws SAMLException{
        try {
            Element assertElement = element.getChild(ASSERTION, assertNamespace);
            Element subjectElement = assertElement.getChild(SUBJECT, assertNamespace);
            Element nameIDElement = subjectElement.getChild(NAMEID, assertNamespace);
            userId = nameIDElement.getText().toLowerCase();
            //if(userId==null || !userId.startsWith("e") || userId.length()<7 || userId.length()>8){
            //    logger.error("Invalid userId:"+userId);
           //     userId=null;
            //}
        } catch(NullPointerException npe) {
            logger.error("NullPointerException when trying to retrieve userId from SAMLResponse");
            throw new SAMLException(npe);
        }
    }
    
    private void setSessionIndex() throws SAMLException{
        try {
            Element assertElement = element.getChild(ASSERTION, assertNamespace);
            Element authnstatmntElement = assertElement.getChild(AUTHNSTATEMENT, assertNamespace);
            sessionIndex= authnstatmntElement.getAttributeValue(SESSIONINDEX);
        } catch(NullPointerException npe) {
            logger.error("NullPointerException when trying to retrieve sessionIndex from SAMLResponse");
            throw new SAMLException(npe);
        }
    }
    
    
    private void setConditions() throws SAMLException{
        //logger.error("setConditions1");
        Element assertElement = element.getChild(ASSERTION, assertNamespace);
        Element condElement = assertElement.getChild(CONDITIONS, assertNamespace);
        if(condElement != null){
            notBefore = condElement.getAttributeValue(NOTBEFORE);
            notOnOrAfter = condElement.getAttributeValue(NOTONORAFTER);
        }
        //logger.error("setConditions2");
    }
}