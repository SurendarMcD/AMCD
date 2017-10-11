package com.mcd.cq.auth.impl;

//a helper class to represent user sessions

import java.util.Calendar;
import java.util.Date;

public class SAMLUserSession {
    
         
        private SAMLUser samlUser;
         
        private Date expires=null;
         
         protected SAMLUserSession(int sessionMaxAgeMins){
             Calendar cal=Calendar.getInstance();
             cal.setTime(new Date());
             cal.add(Calendar.MINUTE, sessionMaxAgeMins);
             Date expireDate=cal.getTime();
             this.expires=expireDate;
             samlUser=new SAMLUser();
         }
         
         public SAMLUser getSamlUser() {
            return samlUser;
        }

        public void setSamlUser(SAMLUser samlUser) {
            this.samlUser = samlUser;
        }

        protected boolean isExpired(){
             return (this.expires.compareTo(new Date())<0);
         }
        
         
}
