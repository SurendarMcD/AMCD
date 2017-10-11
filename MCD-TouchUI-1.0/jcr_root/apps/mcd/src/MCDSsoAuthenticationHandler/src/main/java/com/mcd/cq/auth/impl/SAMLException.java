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
 * An exception class for when there's a problem handling SAML
 * messages.
 * 
 * @version 1.0 Mar 2008
 * @author McDonald's Corporation
 */

public class SAMLException extends Exception {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * Constructs a new SAMLException with null as its detail message
     */
    public SAMLException() {
    }

    /**
     * Constructs a new SAMLException with the specified detail message.
     */ 
    public SAMLException(String message) {
        super(message);
        System.out.println("SAML Exception: " + message);
    }

    /**
     * Constructs a new SAMLException with the specified detail message and cause.
     */
    public SAMLException(String msg, Throwable cause) {
        super(msg, cause);
        System.out.println("SAML Exception: " + msg);
    }

    /**
     * Constructs a new exception with the specified cause and a detail message
     * of (cause==null ? null : cause.toString()) (which typically contains
     * the class and detail message of cause).
     */ 
    public SAMLException(Throwable cause) {
        super(cause);
    }
}
