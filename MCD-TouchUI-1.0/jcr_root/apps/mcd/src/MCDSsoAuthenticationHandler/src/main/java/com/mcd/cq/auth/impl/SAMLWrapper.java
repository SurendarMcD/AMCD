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
 * This class contains all the information related to the SAML message.
 * 
 * @version 1.0 Mar 2008
 * @author McDonald's Corporation
 */
public class SAMLWrapper {
    
    private String providerName;
    private String assertionConsumerServiceURL;
    private String issueInstant;
    private String protocolBinding;
    private String relayStateURL;
    private String destination;
    private String version;
    private String issuerElement;
    private String identityProviderID;

    /**
     * @return the assertionConsumerServiceURL
     */
    public String getAssertionConsumerServiceURL() {
        return assertionConsumerServiceURL;
    }
    /**
     * @param assertionConsumerServiceURL the assertionConsumerServiceURL to set
     */
    public void setAssertionConsumerServiceURL(String assertionConsumerServiceURL) {
        this.assertionConsumerServiceURL = assertionConsumerServiceURL;
    }
    /**
     * @return the destination
     */
    public String getDestination() {
        return destination;
    }
    /**
     * @param destination the destination to set
     */
    public void setDestination(String destination) {
        this.destination = destination;
    }
    /**
     * @return the identityProviderID
     */
    public String getIdentityProviderID() {
        return identityProviderID;
    }
    /**
     * @param identityProviderID the identityProviderID to set
     */
    public void setIdentityProviderID(String identityProviderID) {
        this.identityProviderID = identityProviderID;
    }
    /**
     * @return the issueInstant
     */
    public String getIssueInstant() {
        return issueInstant;
    }
    /**
     * @param issueInstant the issueInstant to set
     */
    public void setIssueInstant(String issueInstant) {
        this.issueInstant = issueInstant;
    }
    /**
     * @return the issuerElement
     */
    public String getIssuerElement() {
        return issuerElement;
    }
    /**
     * @param issuerElement the issuerElement to set
     */
    public void setIssuerElement(String issuerElement) {
        this.issuerElement = issuerElement;
    }
    /**
     * @return the protocolBinding
     */
    public String getProtocolBinding() {
        return protocolBinding;
    }
    /**
     * @param protocolBinding the protocolBinding to set
     */
    public void setProtocolBinding(String protocolBinding) {
        this.protocolBinding = protocolBinding;
    }
    /**
     * @return the providerName
     */
    public String getProviderName() {
        return providerName;
    }
    /**
     * @param providerName the providerName to set
     */
    public void setProviderName(String providerName) {
        this.providerName = providerName;
    }
    /**
     * @return the relayStateURL
     */
    public String getRelayStateURL() {
        return relayStateURL;
    }
    /**
     * @param relayStateURL the relayStateURL to set
     */
    public void setRelayStateURL(String relayStateURL) {
        this.relayStateURL = relayStateURL;
    }
    /**
     * @return the version
     */
    public String getVersion() {
        return version;
    }
    /**
     * @param version the version to set
     */
    public void setVersion(String version) {
        this.version = version;
    }
    
    
}
