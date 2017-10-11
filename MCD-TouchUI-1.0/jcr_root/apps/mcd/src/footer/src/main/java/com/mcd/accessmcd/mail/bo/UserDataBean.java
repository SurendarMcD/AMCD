package com.mcd.accessmcd.mail.bo;

/**
 * This class is used generating the getter & setter 
 * for the value objects 
 *
 * @author Rajat Chawla
 * @version 1.0
 *
 */

public class UserDataBean {
    private String name; // storing name of the users //
    private String email; // for storing email addresses //
    private String userId; // for storing the userid //

    // generating the getter & setters for the values //
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getUserId() {
        return userId;
    }
    public void setUserId(String userId) {
        this.userId = userId;
    }


}