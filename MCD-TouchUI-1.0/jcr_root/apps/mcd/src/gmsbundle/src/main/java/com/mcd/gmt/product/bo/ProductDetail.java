package com.mcd.gmt.product.bo;

import java.io.File;
import java.io.InputStream;

import javax.jcr.Node;

import org.apache.sling.jcr.api.SlingRepository;

import com.day.cq.wcm.api.Page;
import com.mcd.gmt.product.constant.ProductConstant;
 
/** 
 * @ HCL
 */
public class ProductDetail {
    
    private String productRootPath = ProductConstant.BLANK;
    private String productName = ProductConstant.BLANK;
    private String productPagePath = ProductConstant.BLANK; 
    private String productDesc = ProductConstant.BLANK;
    private String LaunchDate = ProductConstant.BLANK;
    private String offMenuDate = ProductConstant.BLANK; 
    private String offMenuDateOpt = ProductConstant.BLANK;
    private String areaOfWorld = ProductConstant.BLANK;
    private String country = ProductConstant.BLANK;
    private String isArchieved = ProductConstant.BLANK;
    private String bigMacRelativePrice = ProductConstant.BLANK;
    private String cheeseBurgerRelativePrice = ProductConstant.BLANK;
    private String menuItemPrice = ProductConstant.BLANK;
    private String salesInformation = ProductConstant.BLANK;
    private String[] productDaypart = {};
    private String[] targetCustomer = {};
    private String[] menuItemCategory = {};
    private String menuItemCategoryText = ProductConstant.BLANK;
    private String targetConsumerTxt = ProductConstant.BLANK;
    private String[] menuItemRole = {};
    private String consumerObjective = ProductConstant.BLANK;
    private String businessObjective = ProductConstant.BLANK;
    private String keyLearnings = ProductConstant.BLANK;
    private String[] keywords = {};
    private String multiVersion = ProductConstant.BLANK;
    private String contactName = ProductConstant.BLANK;
    private String contactEmail = ProductConstant.BLANK;
    private String additionalComment = ProductConstant.BLANK;
    private String actionType = ProductConstant.BLANK;
    private String audienceType = ProductConstant.BLANK;    
    private String productPhotoName = ProductConstant.BLANK;
    private String mimeType = ProductConstant.BLANK;   
    private InputStream productPhotoFin;    
    private MerlinDetail merlinDetail = new MerlinDetail();
    private String actionName = ProductConstant.BLANK;
    private String csdName = ProductConstant.BLANK;
    private String currencyValue = ProductConstant.BLANK;
    private String productPageName = ProductConstant.BLANK;

    private Page page;
     
    public String getProductPageName() {
        return productPageName ; 
    }
    public void setProductPageName(String productPageName) {
        this.productPageName = productPageName ;
    }
    public String getCurrencyValue() {
        return currencyValue;
    }
    public void setCurrencyValue(String currencyValue) {
        this.currencyValue = currencyValue;
    }
    private Node pageNode;    
    private SlingRepository repository;
    
    public String getProductPhotoName()
    {
        return productPhotoName;
    }
    public void setProductPhotoName(String productPhotoName)
    {
        this.productPhotoName = productPhotoName;
    }
    public String getProductRootPath() {
        return productRootPath;
    }
    public void setProductRootPath(String productRootPath) {
        this.productRootPath = productRootPath;
    }
    public String[] getProductDaypart() {
        return productDaypart;
    }
    public void setProductDaypart(String[] productDaypart) {
        this.productDaypart = productDaypart;
    }
    public String[] getTargetCustomer() {
        return targetCustomer;
    }
    public void setTargetCustomer(String[] targetCustomer) {
        this.targetCustomer = targetCustomer;
    }
    public String[] getMenuItemCategory() {
        return menuItemCategory;
    }
    public void setMenuItemCategory(String[] menuItemCategory) {
        this.menuItemCategory = menuItemCategory;
    }
    public String[] getMenuItemRole() {
        return menuItemRole;
    }
    public void setMenuItemRole(String[] menuItemRole) {
        this.menuItemRole = menuItemRole;
    }
    public String getMimeType() {
        return mimeType;
    }
    public void setMimeType(String mimeType) {
        this.mimeType = mimeType;
    }
    public Node getPageNode() {
        return pageNode;
    }
    public void setPageNode(Node pageNode) {
        this.pageNode = pageNode;
    }
    public SlingRepository getRepository() {
        return repository;
    }
    public void setRepository(SlingRepository repository) {
        this.repository = repository;
    }
    public String getProductName() {
        return productName;
    }
    public void setProductName(String productName) {
        this.productName = productName;
    }
    public String getProductDesc() {
        return productDesc;
    }
    public void setProductDesc(String productDesc) {
        this.productDesc = productDesc;
    }
    public String getLaunchDate() {
        return LaunchDate;
    }
    public void setLaunchDate(String launchDate) {
        LaunchDate = launchDate;
    }
    public String getOffMenuDate() {
        return offMenuDate;
    }
    public void setOffMenuDate(String offMenuDate) {
        this.offMenuDate = offMenuDate;
    }
    public String getOffMenuDateOpt() {
        return offMenuDateOpt;
    }
    public void setOffMenuDateOpt(String offMenuDateOpt) {
        this.offMenuDateOpt = offMenuDateOpt;
    }
    public String getAreaOfWorld() {
        return areaOfWorld;
    }
    public void setAreaOfWorld(String areaOfWorld) {
        this.areaOfWorld = areaOfWorld;
    }
    public String getCountry() {
        return country;
    }
    public void setCountry(String country) {
        this.country = country;
    }
    public String getBigMacRelativePrice() {
        return bigMacRelativePrice;
    }
    public void setBigMacRelativePrice(String bigMacRelativePrice) {
        this.bigMacRelativePrice = bigMacRelativePrice;
    }
    public String getCheeseBurgerRelativePrice() {
        return cheeseBurgerRelativePrice;
    }
    public void setCheeseBurgerRelativePrice(String cheeseBurgerRelativePrice) {
        this.cheeseBurgerRelativePrice = cheeseBurgerRelativePrice;
    }
    public String getMenuItemPrice() {
        return menuItemPrice;
    }
    public void setMenuItemPrice(String menuItemPrice) {
        this.menuItemPrice = menuItemPrice;
    }
    public String getSalesInformation() {
        return salesInformation;
    }
    public void setSalesInformation(String salesInformation) {
        this.salesInformation = salesInformation;
    }
    
    public String getMenuItemCategoryText() {
        return menuItemCategoryText;
    }
    public void setMenuItemCategoryText(String menuItemCategoryText) {
        this.menuItemCategoryText = menuItemCategoryText;
    }
    
    public String getConsumerObjective() {
        return consumerObjective;
    }
    public void setConsumerObjective(String consumerObjective) {
        this.consumerObjective = consumerObjective;
    }
    public String getBusinessObjective() {
        return businessObjective;
    }
    public void setBusinessObjective(String businessObjective) {
        this.businessObjective = businessObjective;
    }
    public String getKeyLearnings() {
        return keyLearnings;
    }
    public void setKeyLearnings(String keyLearnings) {
        this.keyLearnings = keyLearnings;
    }
    public String[] getKeywords() {
        return keywords;
    }
    public void setKeywords(String[] keywords) {
        this.keywords = keywords;
    }
    public String getMultiVersion() {
        return multiVersion;
    }
    public void setMultiVersion(String multiVersion) {
        this.multiVersion = multiVersion;
    }
    public String getContactName() {
        return contactName;
    }
    public void setContactName(String contactName) {
        this.contactName = contactName;
    }
    public String getContactEmail() {
        return contactEmail;
    }
    public void setContactEmail(String contactEmail) {
        this.contactEmail = contactEmail;
    }
    public String getAdditionalComment() {
        return additionalComment;
    }
    public void setAdditionalComment(String additionalComment) {
        this.additionalComment = additionalComment;
    }
    public InputStream getProductPhotoFin() {
        return productPhotoFin;
    }
    public void setProductPhotoFin(InputStream productPhotoFin) {
        this.productPhotoFin = productPhotoFin;
    }
    public MerlinDetail getMerlinDetail() {
        return merlinDetail;
    }
    public void setMerlinDetail(MerlinDetail merlinDetail) {
        this.merlinDetail = merlinDetail;
    }
    public String getActionName() {
        return actionName;
    }
    public void setActionName(String actionName) {
        this.actionName = actionName;
    }
   
    
    public String getCsdName() {
        return csdName;
    }
    public void setCsdName(String csdName) {
        this.csdName = csdName;
    }
    public Page getPage() {
        return page;
    }
    public void setPage(Page page) {
        this.page = page;
    }
    public String getIsArchieved() {
        return isArchieved;
    }
    public void setIsArchieved(String isArchieved) {
        this.isArchieved = isArchieved;
    }
    public String getTargetConsumerTxt() {
        return targetConsumerTxt;
    }
    public void setTargetConsumerTxt(String targetConsumerTxt) {
        this.targetConsumerTxt = targetConsumerTxt;
    }
    public String getActionType() {
        return actionType;
    }
    public void setActionType(String actionType) {
        this.actionType = actionType;
    }
        public String getAudienceType() {
        return audienceType;
    }
    public void setAudienceType(String audienceType) {
        this.audienceType = audienceType;
    }
    public String getProductPagePath() {
        return productPagePath;
    }
    public void setProductPagePath(String productPagePath) {
        this.productPagePath = productPagePath;
    }
    
} 