package com.mcd.cq.auth.impl;

import java.security.Key;
import java.security.PublicKey;
import java.security.Security;
import java.util.Iterator;
import java.util.List;
import javax.xml.crypto.MarshalException;
import javax.xml.crypto.dsig.Reference;
import javax.xml.crypto.dsig.SignedInfo;
import javax.xml.crypto.dsig.Transform;
import javax.xml.crypto.dsig.XMLSignature;
import javax.xml.crypto.dsig.XMLSignature.SignatureValue;
import javax.xml.crypto.dsig.XMLSignatureException;
import javax.xml.crypto.dsig.XMLSignatureFactory;
import javax.xml.crypto.dsig.dom.DOMValidateContext;
import org.apache.log4j.Logger;
import org.jcp.xml.dsig.internal.dom.XMLDSigRI;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;


public class SAMLSignatureVerifierImpl
  implements SAMLSignatureVerifier
{
  private static Logger logger = Logger.getLogger(SAMLSignatureVerifierImpl.class);
  private Key verificationKey = null;

  public SAMLSignatureVerifierImpl(PublicKey signingKey)
  {
    setVerificationKey(signingKey);
  }

  public boolean verify(String signedXMLString)
    throws SAMLException
  {
    org.jdom.Document document = SAMLUtil.createJdomDoc(signedXMLString);
    org.w3c.dom.Document w3cDocument = SAMLUtil.toDom(document);
    return verifyDocument(w3cDocument, true);
  }

  private boolean checkTransforms(Reference reference)
  {
    boolean canonicalTransformFound = false;
    boolean envelopedTransformFound = false;
    List transforms = reference.getTransforms();

    for (int j = 0; j < transforms.size(); ++j) {
      Transform transform = (Transform)transforms.get(j);
      if (transform.getAlgorithm().equals("http://www.w3.org/2001/10/xml-exc-c14n#")) {
        canonicalTransformFound = true;
      } else if (transform.getAlgorithm().equals("http://www.w3.org/2000/09/xmldsig#enveloped-signature")) {
        envelopedTransformFound = true;
      } else {

        return false;
      }
    }

    return ((canonicalTransformFound) && (envelopedTransformFound));
  }

  private boolean verifyDocument(org.w3c.dom.Document document, boolean signatureRequired)
    throws SAMLException
  {
    boolean coreValidity = false; 

    try
    {
      NodeList nl = document.getElementsByTagNameNS("http://www.w3.org/2000/09/xmldsig#", 
        "Signature");
      if (nl.getLength() == 0) {
        throw new SAMLException("Cannot find Signature element");
      }

      DOMValidateContext valContext = new DOMValidateContext(getVerificationKey(), 
        nl.item(0));
 
      XMLDSigRI dSigProvider = new XMLDSigRI();
      Security.addProvider(dSigProvider);

      XMLSignatureFactory signatureFactory = 
        XMLSignatureFactory.getInstance("DOM", dSigProvider);

      XMLSignature signature = null;
      signature = signatureFactory.unmarshalXMLSignature(valContext);
      SignedInfo signedInfo = signature.getSignedInfo();
      List references = signedInfo.getReferences();

      if (references.size() != 1) {
        logger.error("Error verify signature.  More than one reference in SignedInfo found.");
        return false;
      }
      Reference reference = (Reference)references.get(0);

      String assertionUri = "#" + document.getDocumentElement().getAttribute("ID");

      if (!(checkTransforms(reference))) {
        coreValidity = false;
      }
      coreValidity = signature.validate(valContext); 

      if (!(coreValidity)) {
        logger.error("Signature failed core validation");

        boolean sv = signature.getSignatureValue().validate(valContext);
        if (!(sv))
        {
          Iterator i = signature.getSignedInfo().getReferences().iterator();
          for (int j = 0; i.hasNext(); ++j) {
            boolean refValid = ((Reference)i.next()).validate(valContext);
            logger.info("ref[" + j + "] validity status: " + refValid);
          }
        }
      } else {
        logger.debug("Signature passed core validation");
      }

      valContext.setProperty("javax.xml.crypto.dsig.cacheReference", Boolean.TRUE);

      Security.removeProvider(dSigProvider.getName());
    } catch (MarshalException e) {
      e.printStackTrace();
      throw new SAMLException("Error unmarshalling XMLSignature", e);
    } catch (XMLSignatureException e) {
      e.printStackTrace();
      throw new SAMLException("Error verifying XMLSignature", e);
    }
    return coreValidity;
  }

  public void setVerificationKey(Key verificationKey) {
    this.verificationKey = verificationKey;
  }

  public Key getVerificationKey() {
    return this.verificationKey;
  }
}