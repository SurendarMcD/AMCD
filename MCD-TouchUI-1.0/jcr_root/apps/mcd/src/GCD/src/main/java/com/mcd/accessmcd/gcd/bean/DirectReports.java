/* 
 * DirectReports.java                                                                   
 * Developed by MCDonald Corporations, Inc.
 * Author      :- HCL                                                   
 * Description :- Object for DirectReports Array
 *
 */

package com.mcd.accessmcd.gcd.bean;


public class DirectReports{

    public String getName() {
        return Name;
    }

    public void setName(String Name) {
        this.Name = Name;
    }
    
    
    public String getOfficePhone() {
        return OfficePhone;
    }

    public void setOfficePhone(String OfficePhone) {
        this.OfficePhone = OfficePhone;
    }
    
    
    public String getEmail() {
        return EmailAddress;
    }

    public void setEmail(String EmailAddress) {
        this.EmailAddress = EmailAddress;
    }
    
    public String getEID() {
        return EID;
    }

    public void setEID(String EID) {
        this.EID = EID;
    }
    
    public String Name;
    public String OfficePhone;
    public String EmailAddress;
    public String EID;
    
}
