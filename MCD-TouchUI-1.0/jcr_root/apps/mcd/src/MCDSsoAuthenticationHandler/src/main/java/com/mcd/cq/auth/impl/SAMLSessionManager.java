package com.mcd.cq.auth.impl;

import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Cookie;

import org.apache.log4j.Logger;

import java.util.*;


/*
* Class to keep track of users that are currently logged in
* through SAML
*
* Erik Wannebo 8/8/11
*/

public class SAMLSessionManager{

    private static final String SSO_COOKIE_NAME="CQADFS";
    private static final int COOKIE_EXPIRATION_MINS=-1; //<0 session scope
    private static final int SESSION_MAX_AGE_MINS=120;
    
    private String FULL_NAME_ATTRIBUTE="http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name";
    private String FIRST_NAME_ATTRIBUTE="http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname";
    private String LAST_NAME_ATTRIBUTE="http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname";
    private String EMAIL_ATTRIBUTE="http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress";

    private String ROLE_ATTRIBUTE="http://schemas.microsoft.com/ws/2008/06/identity/claims/role";
    private String LOCATION_ATTRIBUTE="http://schemas.microsoft.com/ws/2008/06/identity/claims/l";
    private String COMPANYTYPE_ATTRIBUTE="http://schemas.microsoft.com/ws/2008/06/identity/claims/companytype";

    private static Date nextSessionPurgeDate=null;
    private static Map<String,SAMLUserSession> userSessionMap=null;
    private final Logger log; 
    private static SAMLSessionManager mgr;
    
    public SAMLSessionManager(){
        this.log = (Logger)Logger.getLogger(this.getClass());
        userSessionMap = new HashMap<String,SAMLUserSession>();
        setNextSessionPurgeDate();
    }
    
    private void setNextSessionPurgeDate(){
         Calendar cal=Calendar.getInstance();
         cal.setTime(new Date());
         cal.add(Calendar.MINUTE, SESSION_MAX_AGE_MINS);
         this.nextSessionPurgeDate=cal.getTime();
    }
    
    private synchronized void purgeSessions(){

         ArrayList<String> toremove=new ArrayList();
         for(String s: userSessionMap.keySet()){
             SAMLUserSession sess=userSessionMap.get(s);
             if(sess.isExpired()){
                 toremove.add(s);
             }
         }
         synchronized(this.userSessionMap) {
             for(String s: toremove){
                 userSessionMap.remove(s);
             }
         }
         this.setNextSessionPurgeDate();
    }
    
    public static SAMLSessionManager getInstance(){
        if(mgr==null)
            mgr=new SAMLSessionManager();        
        if(mgr.nextSessionPurgeDate.compareTo(new Date())<0)
            mgr.purgeSessions();
        return mgr;
    }
    
     /* Get the user session from the session cookie
        Returns null if there is no valid session
      */
    public SAMLUserSession getUserSession(HttpServletRequest request){
      String sessionID=getSessionIDFromCookie(request, SSO_COOKIE_NAME);
      if(sessionID==null){
          //log.error("sessionID is null");
          return null;
          }
      if(!userSessionMap.containsKey(sessionID)){
          return null;
      }
      SAMLUserSession usersession=(SAMLUserSession)userSessionMap.get(sessionID);
      if(usersession.isExpired()){
          //remove session from map
          synchronized(this.userSessionMap) {
              this.userSessionMap.remove(sessionID);
          }
          usersession=null;
          return null;
      }
      
      return usersession;
  
    }
    
    public SAMLUserSession addUserSession(HttpServletResponse response, StatusResponse samlresponse, String renderid){
        SAMLUserSession usersession=new SAMLUserSession(SESSION_MAX_AGE_MINS);
        SAMLUser samlUser=usersession.getSamlUser();
        if(samlresponse.getUserId()!=null){
            samlUser.setUserid(samlresponse.getUserId());
            samlUser.setSessionIndex(samlresponse.getSessionIndex());
            HashMap samlattributes=samlresponse.getAttributeData();
            if(samlattributes.containsKey(FULL_NAME_ATTRIBUTE)){
                samlUser.setFullname((String)samlattributes.get(FULL_NAME_ATTRIBUTE));
            }
            if(samlattributes.containsKey(EMAIL_ATTRIBUTE)){
                samlUser.setMail((String)samlattributes.get(EMAIL_ATTRIBUTE));
            }
            if(samlattributes.containsKey(ROLE_ATTRIBUTE)){
                samlUser.setRole((String)samlattributes.get(ROLE_ATTRIBUTE));
            }
            if(samlattributes.containsKey(LOCATION_ATTRIBUTE)){
                samlUser.setLocation((String)samlattributes.get(LOCATION_ATTRIBUTE));
            }
            if(samlattributes.containsKey(COMPANYTYPE_ATTRIBUTE)){
                samlUser.setCompanytype((String)samlattributes.get(COMPANYTYPE_ATTRIBUTE));
            }
            if(samlattributes.containsKey(FIRST_NAME_ATTRIBUTE)){
                samlUser.setFirstname((String)samlattributes.get(FIRST_NAME_ATTRIBUTE));
            }
            if(samlattributes.containsKey(LAST_NAME_ATTRIBUTE)){
                samlUser.setLastname((String)samlattributes.get(LAST_NAME_ATTRIBUTE));
            }
    
            
            String sessionid=createSessionId();
            userSessionMap.put(sessionid,usersession);
            //add cookie to response
            Cookie sessioncookie=new Cookie(SSO_COOKIE_NAME,sessionid);
            sessioncookie.setMaxAge(COOKIE_EXPIRATION_MINS*60);
            sessioncookie.setPath("/");
            response.addCookie(sessioncookie);
            
            Cookie stickycookie=new Cookie("renderid",renderid);
            stickycookie.setMaxAge(-1);
            stickycookie.setPath("/");
            response.addCookie(stickycookie);
            return usersession;
       }
       return null;
    }
    
    /* UUID.randomUUID is available only for Java 1.5+ */
    private String createSessionId(){
        int attempts=0;
        String newid=UUID.randomUUID().toString().substring(24,32);
        while(attempts++<10 && this.userSessionMap.containsKey(newid)){
            newid=UUID.randomUUID().toString().substring(24,32);
        }
        if(this.userSessionMap.containsKey(newid)){
            log.error("ERROR creating session id");
            return null;
        }
        return newid;
    }
  
     
     private String getSessionIDFromCookie(HttpServletRequest request, String cookiename){
         Cookie[] cookies = request.getCookies();

        if (cookies != null) {
         for (Cookie cookie : cookies) {
           if (cookie.getName().equals(cookiename)) {
             return cookie.getValue();
        
            }

          }
        }
        return null;
  
      }
      
   

}