package com.mcd.gmt.product.bo;

import com.mcd.gmt.product.constant.ProductConstant;

public class MerlinDetail {
    
    private String enteredInPMP = ProductConstant.BLANK;
    private String enteredInMenuItem = ProductConstant.BLANK;
    private String menuItemID = ProductConstant.BLANK;
    private String prodSpecsEntered = ProductConstant.BLANK;
    private String nutritionInfo = ProductConstant.BLANK;
    private String buildInfo = ProductConstant.BLANK;
    private String nutritionInfoXML = ProductConstant.BLANK;
    private String buildInfoXML = ProductConstant.BLANK;
    
    
    public String getNutritionInfo() {
        return nutritionInfo;
    }
    public void setNutritionInfo(String nutritionInfo) {
        this.nutritionInfo = nutritionInfo;
    }
    public String getBuildInfo() {
        return buildInfo;
    }
    public void setBuildInfo(String buildInfo) {
        this.buildInfo = buildInfo;
    }
    public String getEnteredInPMP() {
        return enteredInPMP;
    }
    public void setEnteredInPMP(String enteredInPMP) {
        this.enteredInPMP = enteredInPMP;
    }
    public String getEnteredInMenuItem() {
        return enteredInMenuItem;
    }
    public void setEnteredInMenuItem(String enteredInMenuItem) {
        this.enteredInMenuItem = enteredInMenuItem;
    }
    public String getMenuItemID() {
        return menuItemID;
    }
    public void setMenuItemID(String menuItemID) {
        this.menuItemID = menuItemID;
    }
    public String getProdSpecsEntered() {
        return prodSpecsEntered;
    }
    public void setProdSpecsEntered(String prodSpecsEntered) {
        this.prodSpecsEntered = prodSpecsEntered;
    }
    public String getNutritionInfoXML() {
        return nutritionInfoXML;
    }
    public void setNutritionInfoXML(String nutritionInfoXML) {
        this.nutritionInfoXML = nutritionInfoXML;
    }
    public String getBuildInfoXML() {
        return buildInfoXML;
    }
    public void setBuildInfoXML(String buildInfoXML) {
        this.buildInfoXML = buildInfoXML;
    }
} 