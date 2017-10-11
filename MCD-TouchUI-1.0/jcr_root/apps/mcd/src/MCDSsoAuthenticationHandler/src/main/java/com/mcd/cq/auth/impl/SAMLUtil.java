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


import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.security.Key;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Security;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Random;
import java.util.TimeZone;
import java.util.zip.Deflater;

import javax.xml.crypto.dsig.CanonicalizationMethod;
import javax.xml.crypto.dsig.DigestMethod;
import javax.xml.crypto.dsig.SignatureMethod;
import javax.xml.crypto.dsig.SignedInfo;
import javax.xml.crypto.dsig.Transform;
import javax.xml.crypto.dsig.XMLSignatureFactory;
import javax.xml.crypto.dsig.spec.C14NMethodParameterSpec;
import javax.xml.crypto.dsig.spec.TransformParameterSpec;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.codec.binary.Base64;
import org.apache.log4j.Logger;
import org.jcp.xml.dsig.internal.dom.XMLDSigRI;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.Namespace;
import org.jdom.input.DOMBuilder;
import org.jdom.input.SAXBuilder;
import org.jdom.output.XMLOutputter;
import org.xml.sax.SAXException;


import org.w3c.dom.Node;
import org.w3c.dom.NodeList;


/**
 * This utility class is used across the application that make up the
 * SAML-based Single Sign-On Reference Tool. It includes various helper methods
 * that are used for the SAML transactions.
 * 
 * @version 1.0 Mar 2008
 * @author McDonald's Corporation
 */

public class SAMLUtil {

    /**
     * Logger for the Class
     */
    private static Logger logger = Logger.getLogger(SAMLUtil.class);
    private static Random random = new Random();
    private static final char[] charMapping = {
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
        'p'};

    private SAMLUtil() {

    }

  /**
   * Load the Config file 
   * 
   * @param fileName file to be read
   * @return Map with collection of vendor details
   */
    public static Map loadConfig(String fileName) throws Exception {
        
        logger.info("[loadConfig] -> executing...");
        // load and parse the file
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
    
        File configFile = new File(fileName);
    
        org.w3c.dom.Document document = builder.parse(configFile);
        
        NodeList nodeList = document.getElementsByTagName("identityprovider");
        Map configMap = new HashMap();
        
        for(int i = 0; i < nodeList.getLength(); i++) {
            Node node = nodeList.item(i);
    
            String identityProviderID = node.getAttributes().getNamedItem("IdPID").getNodeValue();
            logger.info("[loadConfig] getting configuration for vendor: " + identityProviderID);
            
            //get the child nodes for externalsso node
            NodeList childNodes = node.getChildNodes();
            
            Map parmMap = new HashMap();
            
            
            for(int j=0; j < childNodes.getLength(); j++){
                Node childNode1 = childNodes.item(j);
                if(childNode1.hasChildNodes()) {
                    for(int k=0; k < childNode1.getChildNodes().getLength(); k++) {
                        Node childNode = childNode1.getChildNodes().item(k);
                        String name = childNode1.getNodeName();
                        String value = childNode.getNodeValue();
                        parmMap.put(name, value);
                    }
                }
            }
            
            // create config object 
            SAMLWrapper ssoConfig = new SAMLWrapper();
            ssoConfig.setIdentityProviderID(identityProviderID);
            ssoConfig.setProviderName((String) parmMap.get("provider-name"));
            ssoConfig.setAssertionConsumerServiceURL((String) parmMap.get("acs-url"));
            ssoConfig.setDestination ((String) parmMap.get("destination"));
            // protocol binding to be used for sending SAMLRequest
            ssoConfig.setProtocolBinding ((String) parmMap.get("protocol-binding"));
            
            configMap.put(identityProviderID, ssoConfig);
            logger.info("[loadConfig] config for vendor : " + identityProviderID + " has been completed.");
        }
    
        logger.info("[loadConfig] completed successfully.");
        
        // return config object
        return configMap;
    }

   /**
   * Generates a SAML AuthnRequest XML by replacing the specified ACS URL and
   * provider name in the SAML AuthnRequest template file. Returns the string
   * format of the XML file.
   */
  
   public static String createAuthnRequest(String acsURL, String providerName,
            String filepath) throws SAMLException {

        String authnRequest = readFileContents(filepath);
        authnRequest = replace(authnRequest, "#AUTHN_ID#", createID());
        authnRequest = replace(authnRequest, "#ISSUE_INSTANT#", getDateAndTime());
        authnRequest = replace(authnRequest, "#PROVIDER_NAME#", providerName);
        authnRequest = replace(authnRequest, "#ACS_URL#", acsURL);
        
        //logger.info("Creating AuthnRequest: " + authnRequest);
        return authnRequest;
    }

   /**
    * Returns a String containing the contents of the file located at the
    * specified path.
    * 
    * @param path location of file to be read
    * @return String containing contents of file, null if error reading file
    * @throws IOException
    */
   public static String readFileContents(String path) throws SAMLException {

     StringBuffer contents = new StringBuffer();
     BufferedReader input = null;
     try {
       input = new BufferedReader(new FileReader(new File(path)));
       String line = null;
       while ((line = input.readLine()) != null) {
         contents.append(line);
       }
       input.close();
       return contents.toString();
     } catch (FileNotFoundException e) {
       throw new SAMLException("File not found: " + path);
     } catch (IOException e) {
       throw new SAMLException("Error reading file: " + path);
     }
   }

   /**
    * Replace the old value with given value 
    * 
    */    
       
    public static String replace(String source, String oldString, String newString)
    {
        if (source == null) return source;
        
        int index = source.indexOf(oldString);
        if (index == -1) {
            return source;
        }
        
        StringBuffer sb = new StringBuffer();
        sb.append(source.substring(0,index));
        sb.append(newString);
        sb.append(source.substring(index + oldString.length()));
        
        return sb.toString();
    }        

  /**
   * Create a randomly generated string conforming to the xsd:ID datatype.
   * containing 160 bits of non-cryptographically strong pseudo-randomness, as
   * suggested by SAML 2.0 core 1.2.3. This will also apply to version 1.1
   * 
   * @return the randomly generated string
   */
  public static String createID() {
    byte[] bytes = new byte[20]; // 160 bits
    random.nextBytes(bytes);

    char[] chars = new char[40];

    for (int i = 0; i < bytes.length; i++) {
      int left = (bytes[i] >> 4) & 0x0f;
      int right = bytes[i] & 0x0f;
      chars[i * 2] = charMapping[left];
      chars[i * 2 + 1] = charMapping[right];
    }

    return String.valueOf(chars);
  }

  /**
   * Gets the current date and time in the format specified by xs:dateTime in
   * UTC form, as described in SAML 2.0 core.  This will also apply to
   * Version 1.1
   * 
   * @return the date and time as a String
   */
  public static String getDateAndTime() {

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
        dateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
        
        Date date = new Date();
        return dateFormat.format(date);
    }

  /**
   * Gets the public key from X509 digital certificate which is stored in a file
   * 
   * @param publicKeyFilepath location of public key file
   * @return the public key that will be used to verify the XML signature
   */
    public static PublicKey getPublicKey(String publicKeyFilepath) throws SAMLException {
        CertificateFactory cf;
        X509Certificate cert = null;
        PublicKey publicKey = null;
        InputStream inStream = null;        
        
        try {
            inStream = new FileInputStream(publicKeyFilepath);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            throw new SAMLException("FileNotFoundException", e);
        }
        try {
            cf = CertificateFactory.getInstance("X.509");
            cert = (X509Certificate) cf.generateCertificate(inStream);
        } catch (CertificateException e) {
            e.printStackTrace();
            throw new SAMLException("CertificateException", e);
        }
        try {
            inStream.close();
        } catch (IOException e) {
            e.printStackTrace();
            throw new SAMLException("IOException", e);
        }
        publicKey = cert.getPublicKey();
        return publicKey;
    }

    /**
     * Creates a JDOM Document from a string containing XML
     * 
     * @param samlRequestString String version of XML
     * @return JDOM Document if file contents converted successfully, null
     *         otherwise
     */
    public static Document createJdomDoc(String xmlString) throws SAMLException {
      try {
        SAXBuilder builder = new SAXBuilder();
        Document doc = builder.build(new ByteArrayInputStream(xmlString
          .getBytes("UTF-8")));
        return doc;
      } catch (IOException e) {
        throw new SAMLException("Error creating JDOM document from XML string: "
          + e.getMessage());
      } catch (JDOMException e) {
        throw new SAMLException("Error creating JDOM document from XML string: "
          + e.getMessage());
      }
    }

    /**
     * Converts a JDOM Document to a W3 DOM document.
     * 
     * @param doc JDOM Document
     * @return W3 DOM Document if converted successfully, null otherwise
     */
    public static org.w3c.dom.Document toDom(org.jdom.Document doc)
        throws SAMLException {
      try {
        XMLOutputter xmlOutputter = new XMLOutputter();
        StringWriter elemStrWriter = new StringWriter();
        xmlOutputter.output(doc, elemStrWriter);
        byte[] xmlBytes = elemStrWriter.toString().getBytes("UTF-8");
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        return dbf.newDocumentBuilder().parse(new ByteArrayInputStream(xmlBytes));
      } catch (IOException e) {
        throw new SAMLException(
          "Error converting JDOM document to W3 DOM document: " + e.getMessage());
      } catch (ParserConfigurationException e) {
        throw new SAMLException(
          "Error converting JDOM document to W3 DOM document: " + e.getMessage());
      } catch (SAXException e) {
        throw new SAMLException(
          "Error converting JDOM document to W3 DOM document: " + e.getMessage());
      }
    }
    
    public static String getNotNullString(String str){
        if(str != null){
            return str;
        } else {
            return "";
        }
    }    
    
    
    
       public static String createSAMLSignOutRequest(String idpEndpoint, String issuer, String sessionIndex, String userid, String signOutKeyStorePath, String publicKeyFilePath) throws Exception
    {
       
        //UUID used for request ID
        //String relayState=java.util.UUID.randomUUID().toString();
        
        //Date&Time
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
        Date dateNow = dateFormat.parse(SAMLUtil.getDateAndTime());
        String dateNowStr = dateFormat.format(dateNow);
                    
        String samlSignOutRequest = "<samlp:LogoutRequest ID=\""+sessionIndex+"\" Version=\"2.0\" IssueInstant=\""+dateNowStr+"\" Destination=\""+idpEndpoint+"\" Consent=\"urn:oasis:names:tc:SAML:2.0:consent:unspecified\" NotOnOrAfter=\""+dateNowStr+"\" xmlns:samlp=\"urn:oasis:names:tc:SAML:2.0:protocol\"><Issuer xmlns=\"urn:oasis:names:tc:SAML:2.0:assertion\">"+issuer+"</Issuer><NameID xmlns=\"urn:oasis:names:tc:SAML:2.0:assertion\">"+userid+"</NameID><samlp:SessionIndex>"+sessionIndex+"</samlp:SessionIndex></samlp:LogoutRequest>";                  
        
        KeyStore ks = KeyStore.getInstance(SAMLConstants.KEYSTORE_TYPE);        
        ks.load(new FileInputStream(signOutKeyStorePath), "importkey".toCharArray());
        PrivateKey privKey = (PrivateKey)ks.getKey("importkey", "importkey".toCharArray()); 
        
        CertificateFactory cf = CertificateFactory.getInstance("X.509");
        X509Certificate userCert  = (X509Certificate) cf.generateCertificate(new FileInputStream(publicKeyFilePath));
        
        
        samlSignOutRequest = getFinalString(signSAML(samlSignOutRequest, privKey, SignatureMethod.RSA_SHA1,userCert));
        
        String logoutRequest = idpEndpoint+"?binding=urn%3aoasis%3anames%3atc%3aSAML%3a2.0%3abindings%3aHTTP-Redirect&SAMLRequest="+samlSignOutRequest;

        //Logout Request Code ends  
        return logoutRequest;
        
    
    }

    
    
    
    
   public static String signSAML (String samlLogoutRequest, Key signingKey, String algorithm, X509Certificate certificate)
    {
        org.jdom.Document doc = null;
        try {
            doc = createJdomDoc(samlLogoutRequest);
        } catch (SAMLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        if (doc != null) {
            // get the jdom document's root element
            // convert it to a w3c dom element since the signing api only signs a w3c element
            // sign the w3c element
            org.w3c.dom.Element signedDomElement = null;
            try {
                signedDomElement = (org.w3c.dom.Element) signSAMLElement(toDom(doc.getRootElement()),signingKey);
            } catch (SAMLException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            
            // create a new jdom Element with the signed w3c Element
            org.jdom.Element signedJDomElement = toJdom(signedDomElement);
            
            // JDOM does not allow a node to be part of two documents at once. 
            // Before an Element can be transferred into a new Document it must first be 
            // detached from its old document using its detach() method. 
            // The detach method detaches this child from its parent or does nothing 
            // if the child has no parent.
            
            // set the jdom document's root element to the newly signed jdom element
            doc.setRootElement((org.jdom.Element) signedJDomElement.detach());
            
            // set the signed xml string in the SAMLObject
            XMLOutputter xmlOutputter = new XMLOutputter();
            //samlObject.setSignedXmlString(xmlOutputter.outputString(doc));
            samlLogoutRequest = xmlOutputter.outputString(doc);
        }
        return samlLogoutRequest;
    }
    
    private static org.w3c.dom.Element signSAMLElement(org.w3c.dom.Element w3cElement,Key signingKey) {     
        // Create a DOM XMLSignatureFactory that will be used to generate the
        // enveloped signature.
        XMLSignatureFactory sigFactory = null;
        XMLDSigRI dSigProvider = new org.jcp.xml.dsig.internal.dom.XMLDSigRI();
        Security.addProvider(dSigProvider);
            
        sigFactory = XMLSignatureFactory.getInstance("DOM", dSigProvider);  

        DigestMethod digestMethod;
        SignatureMethod signatureMethod;
        CanonicalizationMethod canonicalizationMethod;
        
        try {
            // Create a DigestMethod for the specified algorithm 
            digestMethod = sigFactory.newDigestMethod(DigestMethod.SHA1, null);
            // Create a SignatureMethod for the signature algorithm passed into the constructor
            signatureMethod = sigFactory.newSignatureMethod(SignatureMethod.RSA_SHA1, null);  
            // Create a canonicalization method for creating the signed info.
            canonicalizationMethod = sigFactory.newCanonicalizationMethod(CanonicalizationMethod.EXCLUSIVE, (C14NMethodParameterSpec) null);
            
            // Create the list of transformations that need to be applied
            // The enveloped and the canonicalization transforms are the only transforms 
            // that can be applied for SAML.
            ArrayList transformList = new ArrayList();
            
            // Enveloped transform is required to exclude the Signature element from the signature value calculation.
            Transform envTransform = sigFactory.newTransform(Transform.ENVELOPED, (TransformParameterSpec) null);
            
            // Exclusive canonicalization transform without comments
            Transform exc14nTransform = sigFactory.newTransform(CanonicalizationMethod.EXCLUSIVE, (TransformParameterSpec) null);
            
            transformList.add(envTransform);
            transformList.add(exc14nTransform);
            
            // SAML-core 5.4.2 - Signatures MUST contain a single <ds:Reference> containing a same-document reference to the ID
            // attribute value of the root element of the assertion or protocol message being signed. For example, if the
            // ID attribute value is "foo", then the URI attribute in the <ds:Reference> element MUST be "#foo".
            String id = "#" + w3cElement.getAttribute("ID");
             javax.xml.crypto.dsig.Reference ref = sigFactory.newReference(id, digestMethod, transformList, null, null);
            
            ArrayList refList = new ArrayList();
            refList.add(ref);
            
            SignedInfo signedInfo = sigFactory.newSignedInfo(canonicalizationMethod, signatureMethod, refList);
            
            // Create a DOMSignContext and specify the PrivateKey and
            // location of the resulting XMLSignature's parent element.
             javax.xml.crypto.dsig.dom.DOMSignContext signContext = new  javax.xml.crypto.dsig.dom.DOMSignContext(signingKey, w3cElement);
            
            // compute the correct location to insert the signature xml (location
            // is important because the SAML xsd's enforce sequence on signed info.
            // see "StatusResponseType" definition in saml-schema-protocol-2.0.xsd
            // for instance.)
            org.w3c.dom.Node xmlSigInsertionPoint = getXmlSignatureInsertLocation(w3cElement);
            signContext.setNextSibling(xmlSigInsertionPoint);
            
            // Create the XMLSignature, but don't sign it yet.
            javax.xml.crypto.dsig.XMLSignature signature = sigFactory.newXMLSignature(signedInfo, null);
            
            // Marshal, generate, and sign the enveloped signature.
            signature.sign(signContext);
            
            Security.removeProvider(dSigProvider.getName());
            //return w3cElement;
            
        } catch (Exception e) {
            e.printStackTrace();
        } 
        return w3cElement;
    }
    
    
    
    
    /*
     * Determines location to insert the XML <Signature> element into the SAML
     * response based on the xsd in the SAML specification
     */
    private static org.w3c.dom.Node getXmlSignatureInsertLocation(
        org.w3c.dom.Element elem) {
      org.w3c.dom.Node insertLocation = null;
      org.w3c.dom.NodeList nodeList = elem
          .getElementsByTagName("NameID");
        //logger.info("SAMLSignerImpl.getXmlSignatureInsertLocation length: " + nodeList.getLength());
        insertLocation = nodeList.item(nodeList.getLength() - 1);
      return insertLocation;
    }
    
    
    
    private static String getFinalString(String samlStr) throws Exception {
        //Deflation
        byte[] xmlBytes1 = samlStr.getBytes("UTF-8");
        java.util.zip.Deflater deflater=new Deflater(9, true);
        deflater.setInput(xmlBytes1);
        deflater.finish();
        byte[] output=new byte[xmlBytes1.length];
        int lenght=deflater.deflate(output);
                
        //Shrink final output to actual size
        byte[] finalOutput = new byte[lenght];
        System.arraycopy(output, 0, finalOutput, 0, lenght);
                
        //Base64 encoding
        byte[] base64encodedByteArray=Base64.encodeBase64(finalOutput);
        String base64encoded=new String(base64encodedByteArray);
                
        //URL encoding
        return URLEncoder.encode(base64encoded, "UTF-8");
    }
        
        
     /**
     * Converts a W3 DOM Element to a JDOM Element
     * 
     * @param element W3 DOM Element
     * @return JDOM Element
     */
    public static org.w3c.dom.Element toDom(org.jdom.Element element)
              throws SAMLException {
            return toDom(element.getDocument()).getDocumentElement();
          }
    
      
     /**
     * Converts a W3 DOM Element to a JDOM Element
     * 
     * @param e W3 DOM Element
     * @return JDOM Element
     */
    public static org.jdom.Element toJdom(org.w3c.dom.Element e) {
      org.jdom.input.DOMBuilder builder = new org.jdom.input.DOMBuilder();
      org.jdom.Element jdomElem = builder.build(e);
      return jdomElem;
    } 
} 