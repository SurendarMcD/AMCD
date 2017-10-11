/*
 * Project: AcessMcd GMS
 * 
 * @(#)ProductFormServlet.java
 * Revisions:
 * Date            Programmer           Description
 * --------------------------------------------------------------------------------------------
 * 22, Jan 2011   HCL                  This Servlet Class is responsible for saving the data
 *                                      for Product forms component.
 * --------------------------------------------------------------------------------------------
 * Description:
 * This software is the confidential and proprietary information of
 * McDonald's Corp. ("Confidential Information").
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with McDonald's.
 *
 * Copyright (c) 2011 McDonald's Corp.   
 * All Rights Reserved.
 * www.accessmcd.com
 */
package com.mcd.gmt.product.servlet; 

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.Calendar;

import javax.jcr.Node;
import javax.jcr.Session;
import javax.servlet.Servlet;
import javax.servlet.ServletException;

import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.servlets.SlingAllMethodsServlet;
import org.apache.sling.jcr.api.SlingRepository;
import org.apache.sling.jcr.resource.JcrResourceResolverFactory;
import org.apache.sling.scripting.core.ScriptHelper;
import org.osgi.framework.BundleContext;
import org.osgi.service.component.ComponentContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.wcm.api.Page;
import com.day.cq.wcm.api.PageManager;
import com.day.cq.wcm.api.WCMException;
import com.mcd.gmt.product.bo.ProductDetail;
import com.mcd.gmt.product.constant.ProductConstant;
import com.mcd.gmt.product.cq.IProductService;
import com.mcd.gmt.product.cq.impl.ProductService;
import java.net.URLEncoder; 
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;


@Component(immediate=true,metatype=false)
@Service(Servlet.class)
@Properties({
    @Property( name="service.description",value="Product Form Servlet"),
    @Property( name="service.vendor",value="MCD"),
    @Property(name = "sling.servlet.resourceTypes", value="mcd/components/content/productForm"),
    @Property(name = "sling.servlet.selectors", value="productForm"),
    @Property(name = "sling.servlet.methods", value={ "GET","POST" })
})

@SuppressWarnings("serial")

public class ProductFormServlet extends SlingAllMethodsServlet
{ 
    /**
     * default logger
     */        
    private static final Logger log = LoggerFactory.getLogger(ProductFormServlet.class);
    
    /** @scr.reference */
    private SlingRepository repository;
    private BundleContext bundleContext;
    
    /** @scr.reference */ 
    private JcrResourceResolverFactory resolverFactory;
    protected ScriptHelper sling;
    
    protected Session session = null;
    private ResourceResolver resourceResolver = null;
    
    /**
     * This method is called when the bundle for this service is deployed in the CRX.
     * @param context
     * @throws Exception
     */
    protected void activate(ComponentContext ctx) throws Exception
    {
        bundleContext = ctx.getBundleContext();
        sling = new ScriptHelper(bundleContext, null);
    }
    
    /**
     * This method is called when the bundle for this service is removed from the CRX.
     * @param context
     */
    protected void deactivate(ComponentContext context)
    {
        if(session != null)
            session.logout(); 
    }
     
    /**
     * The service method of the servlet. <br>
     * This method handles all the requests to this servlet.
     * 
     * @param SlingHttpServletRequest request the request send by the client to the server
     * @param SlingHttpServletResponse response the response send by the server to the client
     * @throws ServletException if an error occurred
     * @throws IOException if an error occurred
     */
    @Override
    public void service(SlingHttpServletRequest request, SlingHttpServletResponse response) throws ServletException, IOException
    {
        log.error("Service method start....");
        Resource resource = null;
        String resourcePath = null;
        String redirectUrl = null;
        String subscriptionStatusMessage =null; 
        PrintWriter out = null;
        if(null != request.getParameter("currencyLabel")){
            log.error("Value of ************************** currencyLabel is: " + request.getParameter("currencyLabel"));
        }
        try
        {
            session = repository.loginAdministrative(null);
            resourceResolver = resolverFactory.getResourceResolver(session); 
            resource = resourceResolver.getResource(request.getResource().getPath());
            resourcePath = resource.getPath();
            String[] selectors = request.getRequestPathInfo().getSelectors();
            out = response.getWriter(); 
            String actionType = request.getParameter(ProductConstant.FORM_ACTIONTYPE) != null ? request.getParameter(ProductConstant.FORM_ACTIONTYPE).trim() : ProductConstant.BLANK;
            
            log.error("Selector in FormServlet: ==================="+selectors[0]);
            log.error("resourcePath in FormServlet: ==================="+resourcePath);
            
            if(null != selectors)
            {
               
                if(ProductConstant.SELECTOR_PRODUCTFORM.equalsIgnoreCase(selectors[0]))
                {
                    redirectUrl = productForm(request, sling, ProductConstant.SELECTOR_PRODUCTFORM, actionType);
                    /* uncomment below line for production rollout */
                    //response.sendRedirect(redirectUrl.replace(ProductConstant.CONTENT, ProductConstant.SLASH));
                    
                    /* comment below line for production rollout */
                    log.error("******************************************************** redirectURL is: " + redirectUrl);
                    response.sendRedirect(redirectUrl);
                }               
                
            }
            session.logout();
            session = null;
        }
        catch(Exception ex)
        {
            log.error("[service()]: ", ex);
        }
        finally
        {
            if(session != null)
                session.logout();
        }
        log.info("Service method end....");
    }
    
  
    /* This method saves the data segmentation form data into database.
    * @param SlingHttpServletRequest request
    * @param ScriptHelper sling
    * @param String requestType
    * @return String redirectURL
    */ 
   public String productForm(SlingHttpServletRequest request, ScriptHelper sling, String requestType, String actionType)
   {
       log.error("inside data selector method - productForm() =============");
       IProductService ipd = new ProductService(sling, session, resourceResolver);
       String addpath=ProductConstant.BLANK;
       String editpath=ProductConstant.BLANK;;
       ProductDetail productDetailBean = null;
       String resourcePath = request.getResource().getPath();
       String redirectURL = resourcePath.substring(0, resourcePath.indexOf(ProductConstant.SLASH+ProductConstant.JCR_CONTENT))+ProductConstant.EXT_HTML;
       String actionStatus = ProductConstant.BLANK;
       String pageName = ProductConstant.BLANK;
       //log.error("********************************************************** " + actionType);
       try
       {  
           
            // If Action was ADD->SUBMIT or EDIT->SUBMIT
            if( !(null==actionType) && (actionType.equals(ProductConstant.ACTION_FORM_ADD) || actionType.equals(ProductConstant.ACTION_FORM_SAVE_AS_DRAFT) ) ){
                
                //log.error(" Inside condition for ADD functionality *********************************************************************************** The action was : " + actionType);
                //invoke the SUBMIT Functionality
                
                try { 
                    productDetailBean = ipd.getProductDetail(request);
                    if(null != productDetailBean){
                        //log.error("Product Detail Bean populated *****************************************************************");
                    }
                    actionStatus = productDetailBean.getProductName();
                    actionStatus =URLEncoder.encode(actionStatus,"UTF-8"); 
                    log.error("product page name is: ***************************************** " + productDetailBean.getProductName());
                    //status = "The Product Page for " + productDetailBean.getProductName() + " is now created and activated ";
                   // addpath=productDetailBean.getProductPageName();
                    actionStatus = actionStatus.concat("|" + ipd.createPage(productDetailBean)+"|"+productDetailBean.getProductPageName());
                    
                    if( (actionStatus.indexOf(ProductConstant.EXCEPTION) != -1) ){
                        log.error("There was an exception inside ProductFormServlet");
                    } else {
                        log.error("The Status of ADD Operation is:******************************************************** " + actionStatus);
                    }
                    
                } catch(Exception exception){
                    log.error("Exception while creating a page");
                }
            } 
            // If Action was EDIT->SUBMIT or EDIT->SAVE AS DRAFT 
            else if( !(null==actionType) && (actionType.equals(ProductConstant.ACTION_FORM_UPDATE) || actionType.equals(ProductConstant.ACTION_FORM_UPDATE_SAVE_AS_DRAFT)) ){
                log.error("*********************************************************************************** The action was : " + actionType);
                try{
                    productDetailBean = ipd.getProductDetail(request);
                    actionStatus = productDetailBean.getProductName();
                    actionStatus =URLEncoder.encode(actionStatus,"UTF-8");
                    //  editpath=productDetailBean.getProductPageName(); 
                    
                    // for Page Update
                    String productPagePath = productDetailBean.getProductPagePath(); 
                    pageName = productPagePath.substring(productPagePath.lastIndexOf("/") + 1);
                    actionStatus = actionStatus.concat("|"+ ipd.updatePage(productDetailBean)+"|"+pageName);
                    
                    if( (actionStatus.indexOf(ProductConstant.EXCEPTION) != -1) ){
                        log.error("There was an exception inside ProductFormServlet");
                    } else {
                        log.error("The Status of EDIT Operation is:******************************************************** " + actionStatus);
                    }
                    
                }catch(Exception exception){
                    log.error("Exception while updating the page");
                }
                 
                //invoke the SAVE AS DRAFT Functionality  
                
            } 
            // In case no correct action was detected
            else {
                log.error("*********************************************************************************** No Action detected and actioType is: " + actionType);
            } 
        }

        /*catch(WCMException e){
            status = ProductConstant.EXCEPTION;
           log.error("Error in creating the product page for product ", e);
         
           }
        */
       catch (NumberFormatException e){
           actionStatus = ProductConstant.EXCEPTION;
           log.error("Error in parsing the string.", e);
       } 
        /*
         catch (IOException e){ 
         
         log.error("Error in parsing the string.", e);
        }
        */
       
       redirectURL = redirectURL+ProductConstant.QUESTION_MARK+ProductConstant.RETURN_STATUS+ProductConstant.EQUAL+actionStatus;
       return redirectURL;
   }
    
     
    /**
     * This method initializes the SlingRepository Object.
     * @param repository
     */
    protected void bindRepository(SlingRepository repository)
    {
        this.repository = repository;
    }
     
    /**
     * This method sets the value of SlingRepository Object to NULL.
     * @param repository
     */
    protected void unbindRepository(SlingRepository repository)
    {
        if(this.repository == repository)
        {
            repository = null;
        }
        if(session!=null && session.isLive())
            session.logout();       
        session = null;
    }
}     