/*******************************************************************************
 * Copyright (C) 2010 McDoanld's, Corp. All Rights Reserved. ProductService.java -
 * Handle cq product services Change Log:
 * ---------------------------------------------- Date Name Description
 ******************************************************************************/
package com.mcd.gmt.product.cq.impl;
 
import java.io.InputStream;
import java.util.Calendar; 
import java.util.ArrayList; //added - 18-11-2011 
import java.util.Iterator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

import javax.jcr.Node;
import javax.jcr.Session;

import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.scripting.SlingScriptHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.replication.Agent;
import com.day.cq.replication.AgentManager;
import com.day.cq.replication.ReplicationActionType;
import com.day.cq.replication.ReplicationQueue;
import com.day.cq.replication.Replicator;
import com.day.cq.wcm.api.Page;
import com.day.cq.wcm.api.PageManager;
import com.mcd.gmt.product.bo.MerlinDetail;
import com.mcd.gmt.product.bo.ProductDetail;
import com.mcd.gmt.product.constant.ProductConstant;
import com.mcd.gmt.product.cq.IProductService;
import java.io.UnsupportedEncodingException;

//imports from Tagging API for setting KeyWords 
import com.day.cq.tagging.Tag;
import com.day.cq.tagging.TagManager;
import org.apache.sling.api.resource.Resource; // added  - 18-11-2011


public class ProductService implements IProductService
{
    private static final Logger log = LoggerFactory.getLogger(ProductService.class);
    private String expirationPeriod;
    private String newOffTime;
    private String lastActivation;
    private String expPeriod = "6";
    private ResourceResolver resourceResolver = null;
    protected Session session = null;
    Replicator replicator = null;
    SlingScriptHelper sling = null;
    Session jcrSession = null;
    PageManager pageManager = null;
    String pageName = ProductConstant.BLANK;
    TagManager tagManager = null; // added - 18-11-2011

   //added-31-12-2011
   public String getFieldValue(String propertyValue){
       String returnValue = null;   
       returnValue = propertyValue!=null? propertyValue:"";
       try{
       returnValue=new String(returnValue.getBytes("8859_1"),"UTF-8");
       }
       catch(UnsupportedEncodingException e){
       returnValue="Null";
       }
       return returnValue;
   }
   
   
   ////
    public ProductService(SlingScriptHelper sling, Session jcrSession, ResourceResolver resourceResolver)
    {
        this.resourceResolver = resourceResolver;
        this.jcrSession = jcrSession;
        this.sling = sling;

        replicator = this.sling.getService(Replicator.class);
    } 
 
    public String createPage(ProductDetail productDetailBean)
    {
        log.error("************************************ Inside createPage method");
        String returnMsg = ProductConstant.BLANK;

        try
        {
            //pageName = new String(((productDetailBean.getProductName().trim()).replace(" ", "_")) + "_" + ((new java.util.Date()).getTime())).toLowerCase();
            pageName = productDetailBean.getProductPageName();
            PageManager pageManager = resourceResolver.adaptTo(PageManager.class);
            log.error("RootPagePath *************************************************************:  " + productDetailBean.getProductRootPath());
            log.error("The Page Name will be *********************: " + pageName);
            log.error("Template is located at *********************************************:  " + ProductConstant.TEMPLATE_PATH);
            log.error("Product's name (Title of the page is) *********************************************:  " + productDetailBean.getProductName());
            Page rootPage = !(null == pageManager.getPage(productDetailBean.getProductRootPath()))? pageManager.getPage(productDetailBean.getProductRootPath()):null;
            if(!(null==rootPage)){
                Page newProductPage = pageManager.create(productDetailBean.getProductRootPath(), pageName, ProductConstant.TEMPLATE_PATH, productDetailBean.getProductName());
                 log.error("Product's name (Title of the new Productpage is) *********************************************:  " + newProductPage );
                if (null != newProductPage) 
                {     
                    //productDetailBean.setProductName(pageName);
                    //log.error("Page Name is " + pageName);  
                    productDetailBean.setPage(newProductPage);
                    log.error("Page for " + productDetailBean.getProductName() + " created successfully at : " + newProductPage.getPath());
                }
                else{
                    log.error("Page for " + productDetailBean.getProductName() + " WAS NOT CREATED " + newProductPage.getPath());
                }
                ((Session) resourceResolver.adaptTo(javax.jcr.Session.class)).save();

                if (!newProductPage.isLocked())
                { 
                    newProductPage.lock();
                    log.error("PropertLOckkkkkkkkkkkkkkkkkkkk111111111111111111111111: ");
                    
                    Node pageNode = resourceResolver.getResource(newProductPage.getPath() + "/jcr:content").adaptTo(Node.class);
                log.error("PropertLOckkkkkkkkkkkkkkkkkkkk2222222222222222:");
                    productDetailBean.setPageNode(pageNode);
                    log.error("PropertLOckkkkkkkkkkkkkkkkkkkk3333333333333333333:");
                    // Code to Set the properties for the New Page
                    setPageProperties(productDetailBean);
                    log.error("PropertLOckkkkkkkkkkkkkkkkkkkk44444444444444:");
                    log.error("Properties set for page *************************: " + productDetailBean.getProductName());
                    log.error("Properties set for page @@@@@@@@@@@@@@@@@@@@@@@@: " + productDetailBean.getProductName());
                    newProductPage.unlock();
                    
                }
                log.error("Properties set for page 11111111111111111111: " + productDetailBean.getProductName());
                // check action //
                if (productDetailBean.getActionName().equals(ProductConstant.ACTION_FORM_ADD))
                {
                    log.error("page to be activated!!!!!!!!!!!!!!!!!!!!!!");
                    if(activatePage(productDetailBean.getPage())){
                        // returnMsg = "The Product Page for " + productBean.getProductName() + " is now created and activated ";
                        returnMsg = ProductConstant.ADDED_ACTIVATED;
                    }
                    //log.error("Page: " + productBean.getProductName() + " Activated..");
                } else if (productDetailBean.getActionName().equals(ProductConstant.ACTION_FORM_SAVE_AS_DRAFT)) {
                    // returnMsg="The Page Named:" +
                    // page.getAtom(ProductConstant.Atom_TitleText).toString() + "
                    // has been created with the handle: " + page.getHandle()+ " and
                    // has been SAVED";
                    // returnMsg="The
                    // "+page.getAtom(ProductConstant.Atom_TitleText).toString()+ "
                    // menu item page has been CREATED AND SAVED. <BR> The Page has
                    // not been activated. ";
                    returnMsg = ProductConstant.ADDED_SAVED_AS_DRAFT;
                }
            }
            
        } catch (Exception e)
        { 
            returnMsg = ProductConstant.EXCEPTION;
            log.error("Exception "+ e); 
        }
        log.error("Properties set for page 22222222222222222222: " + productDetailBean.getProductName());
        return returnMsg;
    }
    
    /**
     * This method will update a cq page with all the associated atom values
     * 
     * @param ProductDetail
     *            pds
     * @return String pagetitle.
     */
    public String updatePage(ProductDetail productBean)
    {
        // for Page Update
        String productPagePath = productBean.getProductPagePath();
        log.error("Inside productPagePath *********************!!!!!!!!!!!!***********"+productPagePath );
        Page page = null;
        String returnMsg = "";

        try
        { 
            if (!productPagePath.equals(""))
            {
                log.error("Inside updatePage *************************************************************************");
                pageManager = resourceResolver.adaptTo(PageManager.class);
                page = pageManager.getPage(productPagePath);
                productBean.setPage(page);
                Node pageNode = resourceResolver.getResource((page.getPath()+ "/jcr:content")).adaptTo(Node.class);
                log.error("******************************The Path of JCR_CONTENT NODE IS: " + pageNode.getName());
                productBean.setPageNode(pageNode);

            } else
            {

                log.error("Product Page Path not received in updatePage() method");
            }

            if (!(null == page))
            {
                if (!page.isLocked())
                {
                    page.lock();
                    // Code to Set the properties for the New Page
                    log.error("PropertLOckkkkkkkkkkkkkkkkkkkk77777777777777777777777:");
                    setPageProperties(productBean);
                    log.error("Properties set for page *************************: " + productBean.getProductName());
                    page.unlock();
                    log.error("Page updated...");
                }
            }

            if (productBean.getActionName().equals(ProductConstant.ACTION_FORM_UPDATE))
            {
                activatePage(productBean.getPage());
                // returnMsg="The Page Named : " + productBean.getProductName()
                // +" has been UPDATED AND ACTIVATED";
                if (productBean.getIsArchieved().equals("yes")) 
                {
                    // returnMsg="The "+productBean.getProductName()+ " menu
                    // item page has been UPDATED AND ARCHIVED with the URL : "
                    // +ProductConstant.PUBLISH_URL+page.getPath().replace("/content","")+".html";
                    returnMsg = ProductConstant.UPDATED_ACTIVATED_ARCHIEVED;
                } else {
                    // returnMsg="The "+productBean.getProductName()+ " menu
                    // item page has been UPDATED AND ACTIVATED with the URL : "
                    // +ProductConstant.PUBLISH_URL+page.getPath().replace("/content","")+".html";
                    returnMsg = ProductConstant.UPDATED_ACTIVATED;
                }
            } else if (productBean.getActionName().equals(ProductConstant.ACTION_FORM_UPDATE_SAVE_AS_DRAFT))
            {
                if (productBean.getIsArchieved().equals("yes"))
                {
                    // returnMsg="The "+productBean.getProductName()+ " menu
                    // item page has been UPDATED,ARCHIVED AND SAVED <BR> The
                    // Page has not been reactivated. ";
                    returnMsg = ProductConstant.UPDATED_SAVED_AS_DRAFT_ARCHIVED;
                } else
                {
                    // returnMsg="The "+productBean.getProductName()+ " menu
                    // item page has been UPDATED AND SAVED. <BR> The Page has
                    // not been reactivated. ";
                    returnMsg = ProductConstant.UPDATED_SAVED_AS_DRAFT;
                }
            }
        } catch (Exception ex)
        {     
            returnMsg = ProductConstant.EXCEPTION; 
            log.error("Page Object error " + ex.getMessage());
        }

        return returnMsg;
    }

    /**
     * This method will activate the pages
     * 
     * @param Page
     *            page
     * @return String Message
     */
    public boolean activatePage(Page page)
    {
        try
        {
            log.error("Inside activate page method###########");
            Agent agent = getThrottleAgent();
            ReplicationQueue queue = agent == null ? null : agent.getQueue();
            int num = queue == null ? 0 : queue.entries().size();
            int test = 0;
            log.error("Inside activate page method111111111111111");
            /* while (num > 0)
            {
                try
                {
                    Thread.sleep(500);
                    log.error("Inside activate page method33333333333333"); 
                } catch (InterruptedException e)
                {
                    log.error("[ProductService.activatePage()] exception occured" + e.getMessage());
                }
                num = queue.entries().size();
                test++;
            } */
            log.error("Inside activate page method2222222222222");
            replicator.replicate(jcrSession, ReplicationActionType.ACTIVATE, page.getPath());
            return true;
        } catch (Exception e)
        {
            log.error("[ProductService.activatePage()] exception occured" + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * method to retrieve the replication agent.
     * 
     * @return Agent
     */
    private Agent getThrottleAgent()
    {
        AgentManager agentMgr = sling.getService(AgentManager.class);
        for (Agent agent : agentMgr.getAgents().values())
        {
            if (agent.isEnabled())
            {
                return agent;
            }
        }
        return null;
    }

    /**
     * This method will provide the pageiterator object
     * 
     * @param Page
     *            page
     * @return PageIterator.
     */
    /*
     * public Iterator getChildren(Page page) throws Exception { return
     * getChildren(page, false); }
     */
    /**
     * This method will provide the pageiterator object
     * 
     * @param Page
     *            page
     * @return PageIterator.
     */
    /*
     * public Iterator getChildren(Page page, boolean isPublish) throws
     * Exception { Iterator<Page> pageItr = null; if(page != null) { pageItr =
     * page.listChildren(); } return pageItr; }
     */

    /**
     * This method will be used to retrieve the pageiterator
     * 
     * @param Ticket
     *            ticket
     * @return PageIterator.
     */
    public Iterator getPageIterator(Page page) throws Exception
    {
        Iterator<Page> pageItr = null;
        if (page != null)
        {
            pageItr = page.listChildren();
        }
        return pageItr;
    }

    /**
     * This method will be used to set page atom value
     * 
     * @param Page
     *            page, String atomName, String atomValue
     * @return
     */
    public void setPageProperty(Page page, String propertyName, String propertyValue) throws Exception
    {
        Node pageNode = resourceResolver.getResource(page.getPath() + "/jcr:content").adaptTo(Node.class);
        if (pageNode != null)
        {
            pageNode.setProperty(propertyName, propertyValue);
            ((Session) resourceResolver.adaptTo(javax.jcr.Session.class)).save();
        }
    }

    /**
     * This method will be used to get page object from a given path
     * 
     * @param Page
     *            page, String handle
     * @return
     */

    public Page getPage(String pagePath) throws Exception
    {
        PageManager pageManager = resourceResolver.adaptTo(PageManager.class);
        Page page = pageManager.getPage(pagePath);

        return page;
    }

    /**
     * This method will be used to get page status
     */
    public String getEvent(Page page) throws Exception
    {
        String pageStatus = ProductConstant.BLANK;
        /*
         * ReplicationService replicationService =
         * (ReplicationService)Engine.getService("com.day.cq.replication.service.ReplicationService");
         * ObservationService observationService =
         * (ObservationService)Engine.getService("com.day.cq.contentbus.service.ObservationService");
         * AuditEvent replicationEvent = null; AuditEvent observationEvent =
         * null; String pageStatus = ProductConstant.PAGE_SAVEASDRAFT; try {
         * //Retrieving the last event for the page replicationEvent =
         * replicationService.getAudit().getLatestEvent(page.getHandle());
         * observationEvent =
         * observationService.getAudit().getLatestEvent(page.getHandle()); Date
         * lastModifiedDate = new Date(); if(replicationEvent != null &&
         * ProductConstant.REPLICATION_TYPE_ACTIVATE.equals(replicationEvent.type.toString())) {
         * Date eventDate = new Date(replicationEvent.time);
         * if(eventDate.getTime() >= lastModifiedDate.getTime()) pageStatus =
         * ProductConstant.PAGE_ACTIVATE ; } } catch(Exception e) {
         * log.error("Exception in reading evemt :: " + e); }
         */
        return (pageStatus);

    }

    /**
     * This method will be used to get page status
     */
    public String setOffTime(Page page)
    {

        /*
         * String handle= page.getHandle(); try { ExpirationSchedulerManager
         * expirationSchedulerManager = new ExpirationSchedulerManager(ticket);
         * int flag = expirationSchedulerManager.checkPath(handle + "/"); int
         * flag1 = expirationSchedulerManager.checkSkipPath(handle); if(flag ==
         * 1 && flag1==1) { ExpirationDate pageExpirationDate = new
         * ExpirationDate(); String expireDateValue =
         * pageExpirationDate.getExpiryDate(page.getHandle()); //
         * log.error("expireDateValue :: " + expireDateValue);
         * while(page.isInTransaction()) { Thread.sleep(100); } try { Container
         * topContainer = page.startTransaction();
         * topContainer.getAtom("OffTime").setString(expireDateValue);
         * page.commit(); } catch(Exception e){ page.rollback(); } } }
         * catch(Exception e) { log.error("Exception in setting off time :: " +
         * e); }
         */ 
        return null;

    }

    public void setPageProperties(ProductDetail productBean)
    {
        Node pageNode = productBean.getPageNode();
        String productPageTitle = ProductConstant.BLANK;
        
        log.error("PageLockkkkkk set page properties");
        Tag currentTag = null; //addded - 18-11-2011
        ArrayList<Tag> pageTagsList = new ArrayList<Tag>(); //addded - 18-11-2011
        Tag [] pageTags = null; //addded - 18-11-2011
        Resource pageResource = null; //addded - 18-11-2011
        tagManager = resourceResolver.adaptTo(TagManager.class); //addded - 18-11-2011
        log.error("PageLockkkkkk set page properties 111111111111111111111111111");
        try
        {
            if (pageNode != null)
            {
                // pageNode.setProperty(ProductConstant.ATOM_TEMPLATE,ProductConstant.TEMPLATE_PATH);
                pageNode.setProperty(ProductConstant.Atom_TitleText,productBean.getProductName());
                pageNode.setProperty(ProductConstant.Atom_ProductDesc, productBean.getProductDesc());
                pageNode.setProperty(ProductConstant.Atom_Author, productBean.getContactName());
                pageNode.setProperty(ProductConstant.Atom_ContactEmail, productBean.getContactEmail());
                
                // added - 18-11-2011 - to set Page Tags, using Keywords
                log.error("**************************************** Just before try/catch blog for setting Tags ****************");
                try{
                    log.error("**************************** First statement Inside try/catch blog for setting Tags ****************");
                    String keyWords[] = productBean.getKeywords();
                    log.error("**************************************The count of keywords as input by author are: " + keyWords.length);
                    int tagCount=0; 
                    int size=0;
                    String currentKeyWord = null;
                    if (keyWords.length > 0) {
                     for(int count=0; count<keyWords.length; count++){
                      currentKeyWord = ProductConstant.GMS_TAGGING_PATH.concat((keyWords[count].trim()).toLowerCase());
                      log.error("******************************************************Current KeyWord is: " + currentKeyWord);
                      currentTag = tagManager.resolve(currentKeyWord);
                      log.error("************************************************ right after tagManager.resolve() call ***********");
                      if(! (null == currentTag) ){ // if a tag corresponding to the keyword exists in Tagging section
                          log.error("******************************************************** currentTag is not null **********");
                          pageTagsList.add(currentTag);
                          //pageTags[tagCount] = currentTag; //added to current keyWord to the list of tags to be stored for current page
                      }else{
                          log.error("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! currentTag not resolved !!!!!!!!!!!!!!!!");
                          log.error("**********values for tags****************************"+currentKeyWord);
                          log.error("**********id for tags****************************"+keyWords[count]);
                          log.error("**********description for tags****************************"+"Description for ".concat(keyWords[count]));
                          log.error("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Please use the above values for creating new tags !!!!!!!!!!!!!!!!");
                          currentTag = tagManager.createTag(currentKeyWord, keyWords[count], "Description for ".concat(keyWords[count]));
                          pageTagsList.add(currentTag);
                          size= pageTagsList.size();
                          for(int i=0;i<size;i++){
                          log.error("%%%%%%%%%%%%%%%%%%%TAGLIIIIISSSSSSTTT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"+ pageTagsList.get( i ) );
                          }  
                      } 
                      //tempKeyword = "CORP:gms/".concat(keyWords[count]);
                      //keyWords[count] = tempKeyword;
                     } 
                     //pageResource = (Resource) pageNode;
                     pageResource = resourceResolver.getResource(pageNode.getPath());
                     
                     if(  !(null==pageResource) && !(null==pageTagsList) ){
                          //setting the tags for page
                          pageTags = new Tag[pageTagsList.size()];
                          for(int i = 0; i  < pageTagsList.size(); i++){
                              pageTags[i] = pageTagsList.get(i);
                          }
                          tagManager.setTags(pageResource, pageTags);
                     } else {
                             
                             log.error("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Either pageResource or pageTags is null !!!!!!!!!!!!!!!");
                     }
                     
                    }
                } //close try
                catch(Exception exception){
                    log.error("!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Exception occured while setting pageTags !!!!!!!!!!!!!! : " + exception.getMessage());
                } 

                //pageNode.setProperty(ProductConstant.Atom_Keywords, productBean.getKeywords());
                pageNode.setProperty(ProductConstant.Atom_WWKBAdditionalComments, productBean.getAdditionalComment());
                pageNode.setProperty(ProductConstant.Atom_WWKBBusinessObjective, productBean.getBusinessObjective());
                pageNode.setProperty(ProductConstant.Atom_WWKBConsumerObjective, productBean.getConsumerObjective());
                
                pageNode.setProperty(ProductConstant.Atom_WWKBCountry, productBean.getCountry());
                pageNode.setProperty(ProductConstant.Atom_WWKBDateOffMenu, productBean.getOffMenuDate());
                pageNode.setProperty(ProductConstant.Atom_WWKBDateOffMenuOpt, productBean.getOffMenuDateOpt());
                pageNode.setProperty(ProductConstant.Atom_WWKBKeyLearnings, productBean.getKeyLearnings());
                pageNode.setProperty(ProductConstant.Atom_WWKBLaunchDate, productBean.getLaunchDate());
                try{
                pageNode.setProperty(ProductConstant.Atom_WWKBMenuCategory, productBean.getMenuItemCategory());
                log.error("getting menu item category"+productBean.getMenuItemCategory().toString()); 
                pageNode.setProperty(ProductConstant.Atom_WWKBMenuItemRole, productBean.getMenuItemRole());  
                pageNode.setProperty(ProductConstant.Atom_WWKBMenuCategoryTxt,productBean.getMenuItemCategoryText()); 
                log.error("::::::::::::setting menu::::::::: " + pageNode.getProperty(ProductConstant.Atom_WWKBMenuCategoryTxt).getString());
                pageNode.setProperty(ProductConstant.Atom_WWKBProductType, productBean.getMenuItemCategory());
                pageNode.setProperty(ProductConstant.Atom_WWKBProductDaypart, productBean.getProductDaypart()); 
                pageNode.setProperty(ProductConstant.Atom_WWKBTargetAudience, productBean.getTargetCustomer());
                pageNode.setProperty(ProductConstant.Atom_WWKBTargetConsumerTxt,productBean.getTargetConsumerTxt());
                }
                catch(Exception e){
                log.error("single value is being set for array values "+e.getMessage());
                }
                pageNode.setProperty(ProductConstant.Atom_WWKBMenuItemPrice, productBean.getMenuItemPrice());
                pageNode.setProperty(ProductConstant.Atom_WWKBMenuPriceBigMac, productBean.getBigMacRelativePrice());
                pageNode.setProperty(ProductConstant.Atom_WWKBMenuPriceChsBrg, productBean.getCheeseBurgerRelativePrice());
                pageNode.setProperty(ProductConstant.Atom_WWKBSalesInfo, productBean.getSalesInformation());
              
                pageNode.setProperty(ProductConstant.Atom_WWKBVersionsVariations, productBean.getMultiVersion());
                pageNode.setProperty(ProductConstant.Atom_WWKBZone, productBean.getAreaOfWorld());
                pageNode.setProperty(ProductConstant.Atom_WWKBArchievedFlag,productBean.getIsArchieved());
                pageNode.setProperty(ProductConstant.Atom_MERLINInMenuItemSpecs, productBean.getMerlinDetail().getEnteredInMenuItem());
                pageNode.setProperty(ProductConstant.Atom_MERLINInPMP, productBean.getMerlinDetail().getEnteredInPMP());
                pageNode.setProperty(ProductConstant.Atom_MERLINMenuItemID, productBean.getMerlinDetail().getMenuItemID());
                pageNode.setProperty(ProductConstant.Atom_MERLINProductSpecsEntered, productBean.getMerlinDetail().getProdSpecsEntered());
                
                pageNode.setProperty(ProductConstant.Atom_MERLINNutritionInfoXML,productBean.getMerlinDetail().getNutritionInfoXML());
                pageNode.setProperty(ProductConstant.Atom_MERLINNutritionInfoXSLT,productBean.getMerlinDetail().getNutritionInfo());
                pageNode.setProperty(ProductConstant.Atom_MERLINProductBuildXML,productBean.getMerlinDetail().getBuildInfoXML());
                pageNode.setProperty(ProductConstant.Atom_MERLINProductBuildXSLT,productBean.getMerlinDetail().getBuildInfo());
                pageNode.setProperty(ProductConstant.Atom_CurrencyVal,productBean.getCurrencyValue());
               
                //log.error("::::::::::::setting menu::::::::: " + pageNode.getProperty(ProductConstant.Atom_WWKBTargetConsumerTxt).getString()); 
                // pageNode.setProperty(ProductConstant.Atom_AudienceType, 
                // productBean.getAudienceType());
                if( (productBean.getActionName().equals(ProductConstant.ACTION_FORM_UPDATE)) ||
                    (productBean.getActionName().equals(ProductConstant.ACTION_FORM_UPDATE))) {
                    if (productBean.getProductPhotoFin() != null){
                        log.error("Update Photo if action is Edit *******************************************************");
                        Node productImageNode = (pageNode.hasNode("productimage")) ? pageNode.getNode("productimage") : pageNode.addNode("productimage", "nt:unstructured");
                        productImageNode.setProperty("jcr:lastModified", Calendar.getInstance());
                        productImageNode.setProperty("sling:resourceType", "foundation/components/image");
                        //productImageNode.setProperty("fileName", productBean.getProductPhotoName());
                        productImageNode.setProperty("imageRotate", 0);
                        Node imageFileNode = (productImageNode.hasNode("file")) ? productImageNode.getNode("file") : productImageNode.addNode("file", "nt:resource");
                        imageFileNode.setProperty("jcr:data", productBean.getProductPhotoFin());
                        imageFileNode.setProperty("jcr:mimeType", productBean.getMimeType());
                        imageFileNode.setProperty("jcr:lastModified", Calendar.getInstance());
                    }
                } else{ 
                    if (productBean.getProductPhotoFin() != null)
                    {   
                        Node productImageNode = (pageNode.hasNode("productimage")) ? pageNode.getNode("productimage") : pageNode.addNode("productimage", "nt:unstructured");
                        productImageNode.setProperty("jcr:lastModified", Calendar.getInstance());
                        productImageNode.setProperty("sling:resourceType", "foundation/components/image");
                        //productImageNode.setProperty("fileName", productBean.getProductPhotoName());
                        productImageNode.setProperty("imageRotate", 0);
                        Node imageFileNode = (productImageNode.hasNode("file")) ? productImageNode.getNode("file") : productImageNode.addNode("file", "nt:resource");
                        imageFileNode.setProperty("jcr:data", productBean.getProductPhotoFin());
                        imageFileNode.setProperty("jcr:mimeType", productBean.getMimeType());
                        imageFileNode.setProperty("jcr:lastModified", Calendar.getInstance());                  
                    }
                }
                /* added - to update the cq:modified property of the product page */
                if( (productBean.getActionName().equals(ProductConstant.ACTION_FORM_UPDATE)) ||
                    (productBean.getActionName().equals(ProductConstant.ACTION_FORM_UPDATE_SAVE_AS_DRAFT))) {
                     pageNode.setProperty("cq:lastModified", Calendar.getInstance());
                }
                /* added - to update the cq:modified property of the product page */ 
                pageNode.save();
                pageNode.refresh(true);
                ((Session) resourceResolver.adaptTo(javax.jcr.Session.class)).save();
            }
            
                 pageNode.save();
                pageNode.refresh(true);
                ((Session) resourceResolver.adaptTo(javax.jcr.Session.class)).save();

            
        } catch (Exception ex)
        {
            log.error("Exception Occured in Setting values to Atoms: " + ex);
        }
    }

    public String removeSpecialChracters(String pageTitle)
    {

        // String to form a pattern of Valid Characters for a Page Handle -
        // a-z;A-Z;0-9 and '\\s' (A whitespace)
        String validCharacters = "[^a-zA-Z0-9\\s]";
        Pattern pattern = null;
        Matcher matcher = null;
        try
        { 
            pattern = Pattern.compile(validCharacters);
            if (!pattern.matches(validCharacters, pageTitle))
            {
                matcher = pattern.matcher(pageTitle);
                pageTitle = matcher.replaceAll("");
            }
        } catch (PatternSyntaxException patternSyntaxException)
        {
            log.error(patternSyntaxException.getMessage());
        }
        return pageTitle;
    }

    public ProductDetail getProductDetail(SlingHttpServletRequest request) throws Exception
    {

        ProductDetail productDetailBean = new ProductDetail();
        MerlinDetail merlinDetailBean = new MerlinDetail();
        String photoMimeType = ProductConstant.BLANK;
        String photoName = ProductConstant.BLANK; 
        InputStream photoFileObj = null;
        
        productDetailBean.setActionName(getParameter(request, ProductConstant.FORM_ACTIONTYPE, ""));
       
        productDetailBean.setProductRootPath(getParameter(request, ProductConstant.rootpath, ""));
        productDetailBean.setProductPagePath(getParameter(request, ProductConstant.EDIT_PAGE_PATH, "")); 

        productDetailBean.setProductDesc(getFieldValue(getParameter(request, ProductConstant.FORM_PRODUCT_DESCRIPTION, "")));
        productDetailBean.setProductName(getFieldValue(getParameter(request, ProductConstant.FORM_PRODUCT_NAME, "")));  
       
         
        if(productDetailBean.getActionName().equalsIgnoreCase(ProductConstant.ACTION_FORM_ADD) 
                || productDetailBean.getActionName().equalsIgnoreCase(ProductConstant.ACTION_FORM_SAVE_AS_DRAFT)){
                productDetailBean.setProductPageName(new String(((productDetailBean.getProductName().trim()).replaceAll("[^a-zA-Z 0-9]+","").replace(" ", "_")) + "_" + ((new java.util.Date()).getTime())).toLowerCase());
                  log.error("productDetailBean.setProductPageName............................................... " + productDetailBean.getProductPageName());
        } else {  
            log.error("EDIT Action..............................................."); 
        }
        
        productDetailBean.setLaunchDate(getParameter(request, ProductConstant.FORM_LAUNCH_DATE, ""));
        
        productDetailBean.setOffMenuDateOpt(getParameter(request, ProductConstant.FORM_DATE_OFF_MENU_OPTION, ""));
        productDetailBean.setOffMenuDate(getParameter(request, ProductConstant.FORM_DATE_OFF_MENU_DATE, ""));
        
        productDetailBean.setAreaOfWorld(getParameter(request, ProductConstant.FORM_AREA_OF_WORLD, ""));
        log.error("The Country value will now be set to: " + getParameter(request, ProductConstant.FORM_COUNTRY_NAME, "SORRY NO VAL"));
        productDetailBean.setCountry(getParameter(request, ProductConstant.FORM_COUNTRY_NAME, ""));
        productDetailBean.setMenuItemPrice(getParameter(request, ProductConstant.FORM_MENU_ITEM_PRICE, ""));
        productDetailBean.setCheeseBurgerRelativePrice(getParameter(request, ProductConstant.FORM_MENU_ITEM_PRICE_CHEESEBURGER, ""));
        productDetailBean.setBigMacRelativePrice(getParameter(request, ProductConstant.FORM_MENU_ITEM_PRICE_BIGMAC, ""));
        productDetailBean.setMenuItemRole(getParameterValues(request, ProductConstant.FORM_MENU_ITEM_ROLE, new String[0]));
        productDetailBean.setProductDaypart(getParameterValues(request, ProductConstant.FORM_PRODUCT_DAYPART, new String[0]));
        productDetailBean.setTargetCustomer(getParameterValues(request, ProductConstant.FORM_TARGET_CONSUMERS, new String[0]));
        productDetailBean.setMenuItemCategory(getParameterValues(request, ProductConstant.FORM_MENU_ITEM_CATEGORY, new String[0]));
        productDetailBean.setSalesInformation(getFieldValue((getParameter(request, ProductConstant.FORM_SALES_INFORMATION, ""))));
        productDetailBean.setKeyLearnings(getFieldValue((getParameter(request, ProductConstant.FORM_KEY_LEARNINGS, ""))));
        productDetailBean.setBusinessObjective(getFieldValue((getParameter(request, ProductConstant.FORM_BUSINESS_OBJECTIVE, ""))));
        productDetailBean.setConsumerObjective(getFieldValue((getParameter(request, ProductConstant.FORM_CONSUMER_OBJECTIVE, ""))));
        log.error("!!!!!!!!!!!!!!!!!!!!!!!!! the request parameter keyWords: is: " + getParameter(request, ProductConstant.FORM_KEYWORDS, ""));
        if( !(getParameter(request, ProductConstant.FORM_KEYWORDS, "").equalsIgnoreCase("")) ){
            productDetailBean.setKeywords(getParameter(request, ProductConstant.FORM_KEYWORDS, "").split(","));  
            log.error("******************************************* immediately after setting keywords:   " + productDetailBean.getKeywords().length);
        } else{ 
            log.error("******************************************* No keywords received:   " + productDetailBean.getKeywords().length);
        }
        productDetailBean.setMultiVersion(getFieldValue((getParameter(request, ProductConstant.FORM_MULTILE_VERSIONS, ""))));
        productDetailBean.setContactName(getFieldValue((getParameter(request, ProductConstant.FORM_CONTACT_NAME, ""))));
        productDetailBean.setContactEmail(getParameter(request, ProductConstant.FORM_CONTACT_EMAIL, ""));
        productDetailBean.setAdditionalComment(getFieldValue((getParameter(request, ProductConstant.FORM_ADDITINAL_COMMENTS, ""))));
        productDetailBean.setIsArchieved(getParameter(request, ProductConstant.FORM_ARCHIEVED_TYPE, ProductConstant.FORM_ARCHIEVED_TYPE_DEFAULTVAL));
        log.error("Inside getProductDetails method ******************** : " + getParameter(request,ProductConstant.FORM_OTHER_MENU_CATEGORY_TXT,"received no value for ProductConstant.Atom_WWKBMenuCategoryTxt ") );
        productDetailBean.setMenuItemCategoryText(getFieldValue(getParameter(request,ProductConstant.FORM_OTHER_MENU_CATEGORY_TXT,"")));  
          
        productDetailBean.setTargetConsumerTxt(getParameter(request, ProductConstant.FORM_TARGET_CONSUMER_TXT, ""));
        log.error("The Target consumer is set to: " + getParameter(request,ProductConstant.FORM_TARGET_CONSUMER_TXT, "SORRY NO VAL"));
         
        if (!ProductConstant.BLANK.equalsIgnoreCase(getParameter(request, ProductConstant.FORM_PRODUCT_PHOTO, ""))) {
            //log.error("Now adding Product Photo to bean ----------- " + getParameter(request, ProductConstant.FORM_PRODUCT_PHOTO, ""));
            photoFileObj = request.getRequestParameter(ProductConstant.FORM_PRODUCT_PHOTO) != null ? request.getRequestParameter(ProductConstant.FORM_PRODUCT_PHOTO).getInputStream() : null;
            if(null!= photoFileObj){
                log.error("Photo Input Stream is obtained ---------------------------------");
            }
            photoMimeType = request.getRequestParameter(ProductConstant.FORM_PRODUCT_PHOTO) != null ? request.getRequestParameter(ProductConstant.FORM_PRODUCT_PHOTO).getContentType() : ProductConstant.BLANK;
            if( (null!= photoMimeType)&& !(photoMimeType).equalsIgnoreCase(ProductConstant.BLANK)){
                log.error("photoMimeType is ****************************************** " + photoMimeType );
            }
            //photoName = getParameter(request, ProductConstant.FORM_PRODUCT_PHOTO, "");
        }

        productDetailBean.setMimeType(photoMimeType);
        productDetailBean.setProductPhotoFin(photoFileObj); 
        //productDetailBean.setProductPhotoName(photoName);

        merlinDetailBean.setEnteredInPMP(getParameter(request, ProductConstant.FORM_ENTERED_IN_PMP, ""));
        merlinDetailBean.setEnteredInMenuItem(getParameter(request, ProductConstant.FORM_MENU_ITEM_SPEC, ""));
        merlinDetailBean.setMenuItemID(getParameter(request, ProductConstant.FORM_MENU_ITEM_ID, ""));
        merlinDetailBean.setProdSpecsEntered(getParameter(request, ProductConstant.FORM_PRODUCT_SPEC, ""));
        merlinDetailBean.setNutritionInfoXML(getParameter(request,ProductConstant.FORM_MERLINNutritionXML,""));
        merlinDetailBean.setBuildInfoXML(getParameter(request,ProductConstant.FORM_MERLINBuildXML,""));
        merlinDetailBean.setNutritionInfo(getParameter(request,ProductConstant.FORM_MERLINNutritionInfoXSLT,""));
        merlinDetailBean.setBuildInfo(getParameter(request,ProductConstant.FORM_MERLINBuildInfoXSLT,""));
       
        
        productDetailBean.setMerlinDetail(merlinDetailBean);
        productDetailBean.setCurrencyValue(getParameter(request, ProductConstant.FORM_CURRENCYVAL,""));

        return productDetailBean;
    }

    public String getParameter(SlingHttpServletRequest cqRequest, String name, String defValue)
    {
        String parameterValue = cqRequest.getParameter(name);
        if (parameterValue == null)
        {
            parameterValue = defValue;
        }
        return parameterValue;
    }
 
    public String[] getParameterValues(SlingHttpServletRequest cqRequest, String name, String[] defValue)
    {
        String parameterValue[] = cqRequest.getParameterValues(name);
        String[] finalVal;
        if (parameterValue == null || parameterValue.equals(""))
        {
            return finalVal = defValue;
        } else
            finalVal = parameterValue;

        return finalVal;

    }
}    