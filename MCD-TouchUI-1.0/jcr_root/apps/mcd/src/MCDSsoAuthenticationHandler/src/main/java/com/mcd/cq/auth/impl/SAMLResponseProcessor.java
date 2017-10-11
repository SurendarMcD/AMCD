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
 
import java.io.UnsupportedEncodingException;
import java.security.PublicKey;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Calendar;

import org.apache.commons.codec.binary.Base64;
import org.apache.log4j.Logger;



/**
 * SAMLResponseProcessor validates the SAMLResponse received from identity
 * provider and allow the user to login successfully.
 * 
 * @version 1.0 Mar 2008
 * @author McDonald's Corporation
 */

public class SAMLResponseProcessor {

    private static Logger logger = Logger.getLogger(SAMLResponseProcessor.class);


    public StatusResponse getStatusResponse(String samlString, String publicKeyFilePath) throws SAMLException {
        try {
            // Read and check the SAML parameters.
            if (samlString == null || samlString.trim().length() == 0) {
                logger.error("[64base encoded SAML message cannot be null or empty. samlString = ]" + samlString );
                throw new SAMLException("[64base encoded SAML message cannot be null or empty. samlString = ]" + samlString);
            }

            if (publicKeyFilePath == null || publicKeyFilePath.trim().length() == 0) {
                logger.error("[Public Key File Path cannot be null or empty. publicKeyFilePath = ]" + publicKeyFilePath );
                throw new SAMLException("Public Key File Path cannot be null or empty.");
            }

            //logger.info("[SP (new) received SAMLResponse]");

            PublicKey publicKey = SAMLUtil.getPublicKey(publicKeyFilePath);

            // decode message based on HTTP POSTBinding rules
            // the SAMLResponse will always use the HTTP POSTBinding based on 
            // the SAML Web SSO profile. 
            String decodedString = decodeMessage(samlString);
            
            //logger.error("Decoded:"+decodedString);
            
            // get the values from the xml string and put into instance of
            // StatusResponse
            //logger.error("SAMLResponse (new):getStatusResponse");
            if(decodedString.indexOf("LogoutResponse")>-1){
                StatusResponse logoutStatusResponse=new StatusResponse("LOGOUT");
                return logoutStatusResponse;
            }
            StatusResponse statusResponse = getStatusResponse(decodedString);
            //logger.error("SAMLResponse (new):verifying status");
            if (verifyReponse(decodedString, statusResponse, publicKey)) {
                return statusResponse;
            } else {
                logger.error("[SP verifification of SAMLResponse failed]");
                throw new SAMLException("[SP verifification of SAMLResponse failed]");
            }

        } catch (Exception e) {
            logger.error("Error Processing SAMLResponse." + e.getMessage());
            throw new SAMLException("Error processing SAMLResponse.", e);
        }
    }

    private boolean verifyReponse(String decodedString,
            StatusResponse statusResponse, PublicKey publicKey)
            throws SAMLException {
        // check the StatusCode
        if (!statusResponse.getStatusCode().equals(
                SAMLConstants.STATUSCCODE_SUCCESS)) {
            logger.error("SAMLStatus is not success code.  It is: "
                    + statusResponse.getStatusCode());
            return false;
        }
        //logger.error("verifyResponse1.");
        // Verify the XML Signature.
        SAMLSignatureVerifier signatureVerifier = new SAMLSignatureVerifierImpl(
                publicKey);
        try {
        //logger.error("verifyResponse1a.");
            if (!signatureVerifier.verify(decodedString)) {
                logger.error("Signature did not verify.");
                return false;
            }
            //logger.error("verifyResponse1b.");
        } catch (SAMLException e1) {
            e1.printStackTrace();
            throw new SAMLException();
        }
//logger.error("verifyResponse2.");
        // check the date conditions
        SimpleDateFormat currentdateFormat = new SimpleDateFormat(
                "yyyy-MM-dd'T'HH:mm:ss'Z'");
        SimpleDateFormat dateFormat = new SimpleDateFormat(
                "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
        Date currentDateLower;//tolerance bound
        Date currentDateUpper;//tolerance bound
        int toleranceMinutes=5;//minutes
        Date notBeforeDate;
        Date notOnOrAfterDate;
        
        //logger.error("currentDate:"+SAMLUtil.getDateAndTime());
        //logger.error("notbefore:"+statusResponse.getNotBefore());
        //logger.error("notonorafter:"+statusResponse.getNotOnOrAfter());
        try {
            currentDateLower= currentdateFormat.parse(SAMLUtil.getDateAndTime());
            // add a second to current date to avoid milliseconds issue
            Calendar cal=Calendar.getInstance();
            cal.setTime(currentDateLower);
            // in case there are slight differences in time between servers
            // I noted 1-2 seconds occasionally while testing - Erik W
            //changing to +/- 5 minutes 4/21/2012 ECW
            cal.add(Calendar.MINUTE, toleranceMinutes); 
            currentDateUpper=cal.getTime();
            cal.add(Calendar.MINUTE, (-2)*toleranceMinutes); 
            currentDateLower=cal.getTime();
            
            notBeforeDate = dateFormat.parse(statusResponse.getNotBefore());
            notOnOrAfterDate = dateFormat.parse(statusResponse.getNotOnOrAfter());

            if (currentDateUpper.compareTo(notBeforeDate) < 0) {
                logger.error("Condition Failed: Current date is before the notBeforeDate");
                logger.error("Current date: " + currentDateUpper);
                logger.error("NotBeforeDate: " + notBeforeDate);
                return false;
            }
            if (currentDateLower.compareTo(notOnOrAfterDate) >= 0) {
                logger.error("Condition Failed: Current date is after the notOneOrAfterDate");
                logger.error("Current date: " + currentDateLower);
                logger.error("NotOnOrAfterDate: " + notOnOrAfterDate);
                return false;
            }
        } catch (ParseException e) {
            logger.error("Error parsing condition dates from SAMLResponse");
            e.printStackTrace();
        }

        return true;
    }

    private StatusResponse getStatusResponse(String samlString)
            throws SAMLException {

        org.jdom.Document document;
        try {
            document = SAMLUtil.createJdomDoc(samlString);
        } catch (SAMLException e) {
            throw new SAMLException(
                    "Error creating JdomDoc from samlObject xmlString", e);
        }
        //logger.error("getStatusResponse: getRootElement");
        org.jdom.Element element = document.getRootElement();
        //logger.error("getStatusResponse: creating StatusReponse");
        StatusResponse statusResponse = new StatusResponse(element);
        return statusResponse;
    }

    private String decodeMessage(String encodedRequestXmlString)
            throws SAMLException {
        //logger.error("Decoding this: " + encodedRequestXmlString);
        byte[] xmlBytes;
        try {
            xmlBytes = encodedRequestXmlString.getBytes("UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            throw new SAMLException("decodeMessage Error decoding message", e);
        }

        // Base64 decode it
        Base64 base64Decoder = new Base64();
        byte[] base64DecodedByteArray = base64Decoder.decode(xmlBytes);
        String decodedMessage = "";
        try{
            decodedMessage = new String(base64DecodedByteArray,"UTF-8");
        }catch(Exception e){
            e.printStackTrace();
            throw new SAMLException("decodeMessage Error decoding message", e);
        }

        //logger.error("Decoded: " + decodedMessage);
        
        return decodedMessage;
    }

}