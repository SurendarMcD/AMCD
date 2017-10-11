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




/**
 * <p>
 * SAMLConstants holds the common constants that will be used within 
 * this component. The class is not to be instantiated.
 * </p>
 * 
 * @version 1.0 Mar 2008
 * @author McDonald's Corporation
 */

public class SAMLConstants {

    public static final String PREFIX_SAML_PROTOCOL = "samlp";
    public static final String NS_SAML_PROTOCOL = "urn:oasis:names:tc:SAML:2.0:protocol";
    public static final String NS_ASSERTION = "urn:oasis:names:tc:SAML:2.0:assertion";
    public static final String BINDING_HTTP_REDIRECT = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect";
    public static final String BINDING_HTTP_POST = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST";    
    public static final String STATUSCCODE_SUCCESS = "urn:oasis:names:tc:SAML:2.0:status:Success";
    
    public static final String AUTHN_REQUEST = "config/AuthnRequest.xml";
    public static final String PUBLIC_KEY_FILE_PATH = "./keys/mcdonalds_extsso.crt";
    public static final String SP_CONFIG = "spconfig";
    public static final String IDP_ID = "MCD";
    
    public static final String KEYSTORE_TYPE = "JKS";
    
    private SAMLConstants() {

    }
}