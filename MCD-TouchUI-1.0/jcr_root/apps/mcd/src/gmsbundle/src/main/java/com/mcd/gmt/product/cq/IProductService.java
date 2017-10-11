package com.mcd.gmt.product.cq;

import java.util.Iterator;

import org.apache.sling.api.SlingHttpServletRequest;

import com.day.cq.wcm.api.Page;
import com.mcd.gmt.product.bo.ProductDetail;

public interface IProductService 
{  
    public String createPage(ProductDetail pds);
    
    public String updatePage(ProductDetail pds);
    
    public boolean activatePage(Page page) throws Exception;
    
    //public Iterator getChildren(Page page) throws Exception;
    
    //public Iterator getChildren(Page page, boolean isPublish) throws Exception;
    
    public Iterator getPageIterator(Page page) throws Exception;
    
    
    
    public void setPageProperty(Page page, String propertyName, String propertyValue) throws Exception;
    
    public Page getPage(String pagePath) throws Exception;
    
    //public ProductDetail getProductDetail(String productPagePath) throws Exception;
    
    public String getEvent(Page page) throws Exception; 
    
    public String setOffTime(Page page);
    public ProductDetail getProductDetail(SlingHttpServletRequest request)throws Exception;
    public String getParameter(SlingHttpServletRequest cqRequest,String name,String defValue);
    public String[] getParameterValues(SlingHttpServletRequest cqRequest,String name,String[] defValue);
} 
