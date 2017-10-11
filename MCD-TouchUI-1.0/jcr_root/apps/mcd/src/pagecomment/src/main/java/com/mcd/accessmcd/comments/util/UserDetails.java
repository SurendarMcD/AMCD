package com.mcd.accessmcd.comments.util;

import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;
import com.mcd.accessmcd.comments.constants.CommentsConstants;

public class UserDetails { 
    
    private static final Logger log = LoggerFactory.getLogger(UserDetails.class); 
    
    public static Map<String, String> getUserPropertiesFromLDAP(String EID)
    {
        Map<String, String> propertiesMap = null;

        Hashtable<String, String> env = new Hashtable<String, String>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, 
        PropertiesLoader.getProperty(CommentsConstants.LDAP_INITIAL_CONTEXT_FACTORY));
        env.put(Context.PROVIDER_URL, 
        PropertiesLoader.getProperty(CommentsConstants.LDAP_PROVIDER_URL));
        env.put(Context.SECURITY_PRINCIPAL, 
        PropertiesLoader.getProperty(CommentsConstants.LDAP_SECURITY_PRINCIPAL));
        env.put(Context.SECURITY_CREDENTIALS, 
        PropertiesLoader.getProperty(CommentsConstants.LDAP_SECURITY_CREDENTIALS));

        String searchFilter = CommentsConstants.BLANK;
        try
        {
            DirContext ctx = new InitialDirContext(env);
            //judy,ADFS, 09/2011
//            searchFilter = "(uid=" + EID.trim() + "*)";
            searchFilter = "(samAccountName=" + EID.trim() + "*)";

            SearchControls scon = new SearchControls();

            //judy, ADFS, 09/2011
            scon.setSearchScope(SearchControls.SUBTREE_SCOPE); // search object only
            NamingEnumeration<SearchResult> answer = ctx.search("", searchFilter, scon);
            //NamingEnumeration<SearchResult> answer = ctx.search("ou=People", searchFilter, scon);
            
            String userId = CommentsConstants.BLANK;
            String mail = CommentsConstants.BLANK;
            String fullName = CommentsConstants.BLANK;
            
            while (answer.hasMore())
            {
                SearchResult sr = answer.next();

                if (sr == null)
                {
                    log.error("getUserPropertiesFromLDAP()] next SearchResult is null.");
                    continue;
                }
                Attributes attrs = sr.getAttributes();
                if (attrs == null)
                {
                    log.error("[getUserPropertiesFromLDAP()] SR attributes is null.");
                    continue;
                }
                
                Attribute attr = attrs.get(CommentsConstants.UID);
                if (attr != null)
                {
                    userId = (String) attr.get(0);
                }
                
                attr = attrs.get(CommentsConstants.MAIL);
                if (attr != null)
                {
                    mail = (String) attr.get(0);
                }

               // attr = attrs.get(CommentsConstants.COMMENTNODE);
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

                propertiesMap = new HashMap<String, String>();
                
                propertiesMap.put(CommentsConstants.USERID, userId);
                propertiesMap.put(CommentsConstants.MAIL, mail);
                propertiesMap.put(CommentsConstants.FULLNAME, CommonUtilities.capitalizeFirstLetters(fullName));
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