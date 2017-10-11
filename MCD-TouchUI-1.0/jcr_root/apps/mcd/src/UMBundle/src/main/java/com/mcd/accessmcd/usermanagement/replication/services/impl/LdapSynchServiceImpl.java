package com.mcd.accessmcd.usermanagement.replication.services.impl;
 
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;

import javax.jcr.Session;
import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;


import org.apache.sling.api.scripting.SlingScriptHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.security.UserManager;
import com.mcd.accessmcd.usermanagement.replication.services.ILdapSynchService;

public class LdapSynchServiceImpl implements ILdapSynchService
{
    SlingScriptHelper sling = null;

    private static final Logger log = LoggerFactory.getLogger(com.mcd.accessmcd.usermanagement.replication.services.impl.LdapSynchServiceImpl.class);

    // Dev/Staging Ldap details
//    private static final String LDAP_INITIAL_CONTEXT_FACTORY = "com.sun.jndi.ldap.LdapCtxFactory";
//    private static final String LDAP_PROVIDER_URL = "ldap://mcdeagaix015.mcd.com:13389/o=accessmcd.com,o=mcd.com";
//    private static final String LDAP_SECURITY_PRINCIPAL = "uid=mcdexchange,ou=People,o=mcd.com";
//    private static final String LDAP_SECURITY_CREDENTIALS = "4ever";

    //Judy STG Lab AD, 09/2011 
//    private static final String LDAP_INITIAL_CONTEXT_FACTORY ="com.sun.jndi.ldap.LdapCtxFactory";
//    private static final String LDAP_PROVIDER_URL="ldap://66.111.145.9:3268/OU=Users,OU=US,DC=labnarestmgmt,DC=pri";
//    private static final String LDAP_SECURITY_PRINCIPAL = "CN=svcAmcd,OU=Service Accounts,OU=US,DC=labnarestmgmt,DC=pri";
//    private static final String LDAP_SECURITY_CREDENTIALS = "SAM0410pwd!A";

    //Judy PROD AD, 12/2011
    private static final String LDAP_INITIAL_CONTEXT_FACTORY ="com.sun.jndi.ldap.LdapCtxFactory";
    private static final String LDAP_PROVIDER_URL="ldap://142.11.161.77:3268";
    private static final String LDAP_SECURITY_PRINCIPAL = "CN=svcAmcd,CN=Users,DC=narest,DC=pri";
    private static final String LDAP_SECURITY_CREDENTIALS = "SAM0410pwd!A"; 
 
    
    Hashtable<String, String> env = null;

    public LdapSynchServiceImpl(SlingScriptHelper sling, Session jcrSession, UserManager uMgr)
    {
        this.sling = sling;
        
        env = new Hashtable<String, String>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, LDAP_INITIAL_CONTEXT_FACTORY);
        env.put(Context.PROVIDER_URL, LDAP_PROVIDER_URL);
        env.put(Context.SECURITY_PRINCIPAL, LDAP_SECURITY_PRINCIPAL);
        env.put(Context.SECURITY_CREDENTIALS, LDAP_SECURITY_CREDENTIALS);
    }

    /**
     * Method is used to check user in LDAP
     * 
     * @param EID
     * @return boolean (True-> If exists, False-> If not exists)
     */
    public boolean checkUserInLDAP(String EID) throws Exception
    {
log.error("UM checkUserInLDAP"); 
        String searchFilter = "";
        boolean returnFlag = false;
        try
        {
            DirContext ctx = new InitialDirContext(env);
            //judy, ADFS, 09/2011
            //searchFilter = "(uid=" + EID.trim() + "*)";
            searchFilter = "(samAccountName=" + EID.trim() + ")";

log.error("UM search filter::"+ searchFilter); 
           
            SearchControls scon = new SearchControls();
            
            //judy, ADFS, 09/2011
            //NamingEnumeration answer = ctx.search("ou=People", searchFilter, scon);
            scon.setSearchScope(SearchControls.SUBTREE_SCOPE); // search object only
            NamingEnumeration answer = ctx.search("", searchFilter, scon);
            
            while (answer.hasMore())
            {
                returnFlag = true;
                break;
            }
log.error("UM flag::"+ returnFlag ); 

        }
        catch (Exception ex)
        {
            log.error("[LdapSynchServiceImpl.checkUserInLDAP(String EID)] exception occured" + ex.getMessage());
        }
        return returnFlag;
        
    }

    /**
     * Method to get user properties from LDAP
     * 
     * @param EID
     * @return Map Containing User Properties from LDAP
     */
    public Map getUserPropertiesFromLDAP(String EID) throws Exception
    {
        Map<String, String> propertiesMap = null;
        String searchFilter = "";
//log.error("UM getUserPropertiesFromLDAP"); 

        try
        {
            DirContext ctx = new InitialDirContext(env);
            //judy, ADFS, 09/2011
            //searchFilter = "(uid=" + EID.trim() + "*)";
            searchFilter = "(samAccountName=" + EID.trim() + ")";
            SearchControls scon = new SearchControls();
//log.error("UM searchFilter ::"+ searchFilter ); 

            //judy, ADFS, 09/2011
//            NamingEnumeration answer = ctx.search("ou=People", searchFilter, scon);
            scon.setSearchScope(SearchControls.SUBTREE_SCOPE); // search object only
            NamingEnumeration answer = ctx.search("", searchFilter, scon);

//log.error("UM answer ::"+ answer ); 
            
            String userId = "";
            String mail = "";
            String mcdAudience = "";
            String amcdRole = "";
            String givenName = "";
            String familyName = "";
            String fullName = "";
            String location = "";
            //judy, ADFS
            String distinguishedName = "";
            
            
            while (answer.hasMore())
            {
                SearchResult sr = (SearchResult) answer.next();

                if (sr == null)
                {
                    log.error("[LdapSynchServiceImpl.getUserPropertiesFromLDAP(String EID)] next SearchResult is null...continuing");
                    continue;
                }
                Attributes attrs = sr.getAttributes();
                if (attrs == null)
                {
                    log.error("[LdapSynchServiceImpl.getUserPropertiesFromLDAP(String EID)] SR attributes is null...continuing");
                    continue;
                }
                
                //judy, ADFS, 09/2011
//                Attribute attr = attrs.get("uid");
                Attribute attr = attrs.get("samAccountName");
                if (attr != null)
                {
                    userId = (String) attr.get(0);
                }
                
                attr = attrs.get("mail");
                if (attr != null)
                {
                    mail = (String) attr.get(0);
                }

                attr = attrs.get("mcdAudience");
                
                //judy,ADFS, 10/2011
                //need to change to mcdAudience mapping
                //attr =(new ADMapper()).getInstance().getMcdAudience(usersession.getCompanytype(), usersession.getRole());
                
                if (attr != null)
                {
                    mcdAudience = (String) attr.get(0);
                }
                
                attr = attrs.get("amcdRole");
                if (attr != null)
                {
                    amcdRole = (String) attr.get(0);
                }

                attr = attrs.get("givenName");
                if (attr != null)
                {
                    givenName = (String) attr.get(0);
                }
                
                attr = attrs.get("sn");
                if (attr != null)
                {
                    familyName = (String) attr.get(0);
                }
                
                //judy, ADFS, 2011
                //attr = attrs.get("cn");
                attr = attrs.get("displayName"); 
                if (attr != null)
                {
                    fullName = (String) attr.get(0);
                }
                
                // if user is not active then skip that user
                if (fullName != null && (fullName.toUpperCase().indexOf("DO NOT ") != -1 || fullName.substring(0, 5).equalsIgnoreCase("TEST ")))
                {
                    log.error("[LdapSynchServiceImpl.getUserPropertiesFromLDAP(String EID)] username " + fullName + " inactive...continuing");
                    continue;
                }

                attr = attrs.get("l");
                if (attr != null)
                {
                    location = (String) attr.get(0);
                }
                
                //judy, ADFS
                attr = attrs.get("distinguishedName");
                if (attr != null)
                {
                    distinguishedName= (String) attr.get(0);
                }
                
                
                propertiesMap = new HashMap<String, String>();
                
                propertiesMap.put("userId", userId);
                propertiesMap.put("mail", mail);
                propertiesMap.put("mcdAudience", mcdAudience);
                propertiesMap.put("amcdRole", amcdRole);
                propertiesMap.put("givenName", givenName);
                propertiesMap.put("familyName", familyName);
                propertiesMap.put("fullName", fullName);
                propertiesMap.put("location", location);
                //judy, ADFS
                propertiesMap.put("distinguishedName", distinguishedName);  


            }
            ctx.close();
        }
        catch (Exception ex)
        {
            log.error("[LdapSynchServiceImpl.checkUserInLDAP(String EID)] exception occured" + ex.getMessage());
        }

        return propertiesMap;
    }
}