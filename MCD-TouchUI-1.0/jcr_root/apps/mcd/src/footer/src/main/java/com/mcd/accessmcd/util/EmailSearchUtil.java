package com.mcd.accessmcd.util;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import com.mcd.accessmcd.mail.bo.UserDataBean;

import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

/**
 * This class is used for searching the users from LDAP
 * 
 * @author Rajat Chawla
 * @version 1.0
 *
 */

public class EmailSearchUtil {
    
    private static final Logger log = LoggerFactory.getLogger(com.mcd.accessmcd.util.EmailSearchUtil.class);   
    
    //Production Ldap details
//    private static final String LDAP_INITIAL_CONTEXT_FACTORY ="com.sun.jndi.ldap.LdapCtxFactory";
//    private static final String LDAP_PROVIDER_URL="ldap://mcdeagaix012.mcd.com:13389/o=accessmcd.com,o=mcd.com";
//    private static final String LDAP_SECURITY_PRINCIPAL = "uid=mcdexchange,ou=People,o=mcd.com";
//    private static final String LDAP_SECURITY_CREDENTIALS = "themanbeb1ll";

    //Judy STG Lab AD, 09/2011
//    private static final String LDAP_INITIAL_CONTEXT_FACTORY ="com.sun.jndi.ldap.LdapCtxFactory";
//    private static final String LDAP_PROVIDER_URL=
//                                "ldap://66.111.145.9:3268/OU=Users,OU=US,DC=labnarestmgmt,DC=pri";
//    private static final String LDAP_SECURITY_PRINCIPAL =
//                                "CN=svcAmcd,OU=Service Accounts,OU=US,DC=labnarestmgmt,DC=pri";
//    private static final String LDAP_SECURITY_CREDENTIALS = "SAM0410pwd!A"; 


    //Judy Prod Lab AD, 09/2011 
    private static final String LDAP_INITIAL_CONTEXT_FACTORY ="com.sun.jndi.ldap.LdapCtxFactory";
    private static final String LDAP_PROVIDER_URL=
                                "ldap://66.111.144.237:3268";
    private static final String LDAP_SECURITY_PRINCIPAL =
                                "CN=svcAmcd,CN=Users,DC=narest,DC=pri"; 
    private static final String LDAP_SECURITY_CREDENTIALS = "SAM0410pwd!A"; 
 
    
    // Static variable for storing the maximum number of Users// 
    private static final int MAX_SEARCH_USERS_COUNT = 50;
    
    // method to remove the '/' from the code & append the '//' instead of that  //
    public static String escape(String sVar) {
        String retvalue = sVar;
        if ( sVar.indexOf ("'") != -1 ) {
        StringBuffer hold = new StringBuffer();
        char cVar;
        for ( int i = 0; i < sVar.length(); i++ ) {
            if ( (cVar=sVar.charAt(i)) == '\'' )
            hold.append ("\\'");
            else
            hold.append(cVar);
        }
        retvalue = hold.toString();
        }
        return retvalue;
    }
    
    // this method return the list of users that are being searched from the LDAP //
    public List searchUserName(String firstName, String lastName, boolean excludeSuperUser) {
        List usersList = new ArrayList();
        String searchFilter = "";
        int firstNameLength = firstName.trim().length();
    
        // ===================== search ldap ======================
        Hashtable env = new Hashtable();
        env.put(Context.INITIAL_CONTEXT_FACTORY,LDAP_INITIAL_CONTEXT_FACTORY);
        env.put(Context.PROVIDER_URL, LDAP_PROVIDER_URL);
        env.put(Context.SECURITY_PRINCIPAL, LDAP_SECURITY_PRINCIPAL);
        env.put(Context.SECURITY_CREDENTIALS, LDAP_SECURITY_CREDENTIALS);

        try
        {
            // Create the initial directory context
            DirContext ctx = new InitialDirContext(env);
    
            if(firstNameLength > 0){
                searchFilter = "(&(sn=" + lastName + "*)(givenName=" + firstName + "*))";
            } else {
                searchFilter = "(sn=" + lastName + "*)";
            }
            SearchControls scon = new SearchControls();
    
            // Search for objects that have those matching attributes
           //judy, ADFS, 09/2011
           scon.setSearchScope(SearchControls.SUBTREE_SCOPE); // search object only
           //NamingEnumeration answer = ctx.search("ou=People", searchFilter, scon);
           NamingEnumeration answer = ctx.search("", searchFilter, scon);

            List foundHandles = new ArrayList();
            int ct = 0;
            while (answer.hasMore()) {
                    if ( ct > MAX_SEARCH_USERS_COUNT ) {
                            break;
                    }
                    SearchResult sr = (SearchResult) answer.next();
        
                    if(sr == null) {
                        log.error("[CqUserDAO.searchUserName()] next SearchResult is null...continuing");
                        continue;
                    }
                    Attributes attrs = sr.getAttributes();
                    if(attrs == null) {
                        log.error("[CqUserDAO.searchUserName()] SR attributes is null...continuing");
                        continue;
                    }

                    //judy, ADFS, 09/2011
                    //Attribute attr = attrs.get("uid");
                    Attribute attr = attrs.get("samAccountName");
                    if(attr == null) { 
                        log.error("[CqUserDAO.searchUserName()] uid attribute is null...continuing");
                        continue;
                    }
        
                    String userId = "";
                    if(attr != null)
                        userId = (String)attr.get(0);
        
                    attr = attrs.get("cn");
                    if(attr == null) {
                            log.error("[CqUserDAO.searchUserName()] cn attribute is null...continuing");
                        continue;
                    }
                    String userName = "";
                    if(attr != null)
                        userName = (String)attr.get(0);
        
                    // if user is not active then skip that user
                    if(userName != null && (userName.toUpperCase().indexOf("DO NOT ") != -1 || userName.substring(0,5).equalsIgnoreCase("TEST ")) ) {
                        log.error("[CqUserDAO.searchUserName()] username " + userName + " inactive...continuing");
                        continue;
                    }
        
                    attr = attrs.get("mail");
                    if(attr == null) {
                        log.error("[CqUserDAO.searchUserName()] mail attribute is null...continuing");
                        //continue;
                    }
                    String emailAddr = "";
                    if(attr != null)
                        emailAddr = (String)attr.get(0);
        
                    String userHandle = "";
                    if(userId != null) {
                    String userDir = userId.substring(0, userId.length() - 2) + "xx";
                    userHandle = "/access/users/superuser/extusers/accessmcdcom/People/" + userDir + "/" + userId;
                    }
        
                    if(excludeSuperUser && userId != null){
                        if(userId.toLowerCase().trim().equals("superuser")){
                            continue;
                        }
                    }
        
                    // create the userdatabean
                    UserDataBean lbsdb = new UserDataBean();
                    lbsdb.setUserId(userId);
                    lbsdb.setName(userName);
                    lbsdb.setEmail(emailAddr);
                    
                    // add it to the list.
                    usersList.add(lbsdb);
        
                    // only count users added to bean
                    ct++;
            }
            ctx.close();

            // sort list by user name
            ComparatorUtil.sort(usersList, "getName", true);
        } 
        catch(Exception ex)
        {
            log.error("[CqUserDAO.searchUserName()] exception occured"+ex.getMessage());
        }
        return usersList;
    }           
}