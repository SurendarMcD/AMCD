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

package com.mcd.cq.auth.impl;

import java.security.Key;


/**
 * <p>
 * SAMLSignatureVerifier interface. Outlines the behavior of SAMLSignatureVerifier classes that implement 
 * this interface.
 * </p>
 * 
 * @version 1.0 Mar 2008
 * @author McDonald's Corporation
 */

public interface SAMLSignatureVerifier {
   
    /**
     * <p> Sets the verification key that is going to be used by this verifier to verify the Digital Signature.
     * </p>
     *
     * @param verificationKey the key to use, it may be null to indicate that only attached keys in KeyInfo or
     * Certificates are to be used.
     */
    public void setVerificationKey(Key verificationKey);

    /**
     * <p> Gets the verification key that is going to be used by this verifier to verify the Digital Signature.
     * </p>
     *
     * @return the key that is being used, or null to indicate that only attached keys in KeyInfo or Certificates
     * are to be used.
     */
    public Key getVerificationKey();
    
    /**
     * <p> Verifies an affixed signature.  It will verify that the signature conforms to the 
     * Digital Signature standards, and if so will proceed to verify the actual validity of the Signature using 
     * any attached keys or certificates provided, as well as the provided Verification Key. </p>
     *
     * @return a boolean indicating the validity of any digital signatured attached to the SAML Object.
     * @param signedXMLString the xml string to verify.
     * @throws SAMLException if a problem occurs while verifying the signature.
     */
    public boolean verify(String signedXMLString) throws SAMLException;
    
}