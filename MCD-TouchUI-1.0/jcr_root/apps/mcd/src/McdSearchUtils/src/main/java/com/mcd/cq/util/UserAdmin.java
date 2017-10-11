package com.mcd.cq.util;

import org.apache.commons.httpclient.*;
import org.apache.commons.httpclient.auth.*;
import org.apache.commons.httpclient.methods.*;

import com.day.cq.security.*;


/*
* Utility class used for:
* - creating a user
* - triggering an LDAP synch of user attributes
*/

public class UserAdmin{

   
   private static String CRX_SERVER="localhost";
    
    public static User createUser(UserManager uMgr, String userid) throws Exception {
                       
            User user=null;
            try{
                //need to supply a password, and since it doesn't get updated w/LDAP password
                //it needs to be something random (LDAP login still works, and apparently doesn't
                //rely on this password)
                String password=Double.toString(Math.random());
                String principalname="uid="+userid+",ou=People,o=accessmcd.com,o=mcd.com";
                String path="/home/users/"+userid.substring(0,6)+"xx/";
                user=(User)uMgr.createUser(userid,password,principalname,path);
            }catch(NoSuchAuthorizableException e){
                return user;
            }
            
            return user;
        }
 
 
           // Method to trigger an LDAP synch of a user
           // Done in a hack-ish way of making an HTTP request
           // to /crx/config/ldap.jsp
           // This functionality is buried in CRX, and not exposed to CQ/Felix--
           // One alternative may have been to package a number of CRX jars with this bundle??
           // but for now this works OK.
           
     public static boolean synchUserFromLdap(CRXInfoService crxinfo, String userid){
      
            boolean bRet=false;
            String userdn="uid="+userid+",ou=People,o=accessmcd.com,o=mcd.com";
            PostMethod postAuth=null;
            PostMethod postSynch=null;
            
            org.apache.commons.httpclient.HttpClient client = new HttpClient();
            HostConfiguration host = client.getHostConfiguration();
            
            try {
                host.setHost(new org.apache.commons.httpclient.URI("http://"+UserAdmin.CRX_SERVER+":"+crxinfo.getCRXPort(), true));
                //System.out.println("crx port:"+crxinfo.getCRXPort());
                org.apache.commons.httpclient.Credentials credentials = new UsernamePasswordCredentials("admin", crxinfo.getCRXAdminPassword());
                client.getState().setCredentials(AuthScope.ANY, credentials);
                
                postSynch= new PostMethod("http://"+UserAdmin.CRX_SERVER+":"+crxinfo.getCRXPort()+"/crx/config/ldap.jsp");
                postSynch.addParameter("dn", userdn);
                postSynch.addParameter("dir", "");
                
                postSynch.setDoAuthentication( true );       
                postSynch.getParams().setParameter("http.socket.timeout", new Integer(30000));        
                client.getParams().setAuthenticationPreemptive( true );
                
                postAuth= new PostMethod("http://"+UserAdmin.CRX_SERVER+":"+crxinfo.getCRXPort()+"/crx/login.jsp");
                postAuth.addParameter("UserId", "admin");
                postAuth.addParameter("Password", crxinfo.getCRXAdminPassword());
            
                //authenticate first
                int status = client.executeMethod(postAuth);
                //then do LDAP synch
                status = client.executeMethod(postSynch);   
                
                if(status==200)bRet=true;            
            } catch(Exception e){
            }
            finally {
                postAuth.releaseConnection();
                postSynch.releaseConnection();
                client=null;
            }
            return bRet;
     }

}