package com.mcd.cq.auth.impl;

// a helper class to represent user attributes returned by SAML
// not currently utilized in CQ5

public class SAMLUser {
    
         private String userid="";
         private String fullname="";
         private String firstname="";
         private String lastname="";
         private String mail="";
         private String companytype="";
         private String role="";
         private String location="";
         private String sessionindex="";
         
       public String getCompanytype() {
            return companytype;
        }

        public void setCompanytype(String companytype) {
            this.companytype = companytype;
        }

        public String getRole() {
            return role;
        }

        public void setRole(String role) {
            this.role = role;
        }

        public String getLocation() {
            return location;
        }

        public void setLocation(String location) {
            this.location = location;
        }

        public String getUserid() {
        return userid;
     }

        public void setUserid(String userid) {
        this.userid = userid;
     }

        public String getMail() {
        return mail;
     }

        public void setMail(String mail) {
        this.mail = mail;
     }
       
        public String getFullname() {
            return fullname;
        }

        public void setFullname(String fullname) {
            this.fullname = fullname;
        }
         public String getFirstname() {
            return firstname;
         }

         public void setFirstname(String firstname) {
            this.firstname = firstname;
         }
         public String getLastname() {
                return lastname;
            }

         public void setLastname(String lastname) {
                this.lastname = lastname;
            }
         
         public String getSessionIndex() {
            return sessionindex ;
         }

        public void setSessionIndex(String sessionindex) {
            this.sessionindex = sessionindex;
         }

       
}