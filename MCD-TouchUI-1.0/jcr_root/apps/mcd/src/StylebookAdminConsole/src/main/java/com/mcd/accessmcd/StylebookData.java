package com.mcd.accessmcd;

import java.util.Date;


public class StylebookData{
    
    private int id;  
    private String key; 
    private String description; 
    private String relatedItems;
    private String status;
    private Date createdDate;
    private Date updatedDate;
    private String updatedUser;    
    
  
     
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id= id;
    }
    
    public String getKey() {
        return key;
    }
    public void setKey(String key) {
        this.key= key;
    }
    
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description= description;
    }
    
    public String getRelatedItems() {
        return relatedItems;
    }
    public void setRelatedItems(String relatedItems) {
        this.relatedItems= relatedItems;
    }
    
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status= status;
    }
    
    public Date getCreatedDate() {
        return createdDate;
    }
    public void setCreatedDate(Date createdDate) {
        this.createdDate= createdDate;
    }
    
    public Date getUpdatedDate() {
        return updatedDate;
    }
    public void setUpdatedDate(Date updatedDate) {
        this.updatedDate= updatedDate;
    }
    
    public String getUpdatedUser() {
        return updatedUser;
    }
    public void setUpdatedUser(String updatedUser) {
        this.updatedUser= updatedUser;
    }
    
    
}

