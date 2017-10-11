package com.mcd.accessmcd.common.helper;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import com.mcd.accessmcd.pci.bo.PCIQuery;
import com.mcd.accessmcd.pci.bo.PCIResult;
import com.mcd.accessmcd.pci.facade.IPCIContentDeliveryFacade; 
import com.mcd.accessmcd.pci.facade.impl.PCIContentDeliveryFacadeImpl;
import com.day.cq.wcm.api.Page;
import com.mcd.util.PropertiesLoader; 
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import java.util.Date;
import com.mcd.util.CacheUtil;
import com.opensymphony.oscache.base.NeedsRefreshException;
import com.opensymphony.oscache.general.GeneralCacheAdministrator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.api.scripting.SlingScriptHelper;
import java.io.StringReader;
import org.xml.sax.InputSource;
import com.mcd.accessmcd.common.helper.XMLHelper;




/**
 * This class is used as an interact with PCI Java interface layer.
 *
 * @author HCL
 * @version 1.0
 *
 */
public class PCIHelper {
    private static final Logger log;
    
    static 
    {
        log = LoggerFactory.getLogger(PCIHelper.class);
    }
    
    final static String  PCIACTIONTYPE= "read";
    private static GeneralCacheAdministrator admin = null;
    
    /** 
    * Retrieves SiteFinder data from PCI
    *   
    * @return PCIQuery
    * @param Page Object, String Page Qualident, String sortType
    * @exception contentbusexception
    */
    public PCIQuery prepareQueryObjectSF(ValueMap properties, String sortTypeVal, String audienceTypeVal)
    throws Exception
    {   
        String contentIndxCat = (String)properties.get("categoryId");
        String resultCount = "10000";//default result count
        String mcdEntity = (String)properties.get("entityType");
        String sortType = sortTypeVal;
        String audienceType = audienceTypeVal;  
        String actionType=PCIACTIONTYPE;
        String viewType="sf";   
              
        PCIQuery pciQuery = new PCIQuery();
       
        pciQuery.setAudience(audienceType);  
        pciQuery.setCategoryID(contentIndxCat);
        pciQuery.setResultCount(resultCount); 
        pciQuery.setSortType(sortType);
        pciQuery.setEntityType(mcdEntity);
        pciQuery.setActionType(actionType);
        pciQuery.setViewType(viewType);
        
        return pciQuery;
    } 
    
    public String getSiteFinderContent(Page page, ValueMap properties, String themeName, String audienceTypeVal, SlingScriptHelper sling) throws Exception
    {
        
        IPCIContentDeliveryFacade pciContentFacade = new PCIContentDeliveryFacadeImpl(sling);
        XMLHelper xmlHelper = new XMLHelper(); 
        String xmlContent="";
        String xsltPath=(String)properties.get("xslPath");
        String htmlContent=""; 
        PCIQuery pciQuery=null; 
        String sortType = "alpha";
        String osKeyVal="";
        pciQuery=prepareQueryObjectSF(properties, sortType,audienceTypeVal); 
        int cacheRefreshPeriod = 900; //default to 15 min
        try {            
            osKeyVal=pciQuery.getOSCacheKey();
            admin = CacheUtil.getInstance();
            String cacheRefreshPeriodTemp =PropertyHelper.getPropValue("commonp.properties","CDC_OScachekey_RefreshTime");
            if(cacheRefreshPeriodTemp !=null){
              cacheRefreshPeriod =new Integer(cacheRefreshPeriodTemp); 
            }
 
            // checking key from cache // 
            htmlContent=(String)admin.getFromCache(osKeyVal,cacheRefreshPeriod);

        } catch (com.opensymphony.oscache.base.NeedsRefreshException nre) {
            Document xmlDocument = pciContentFacade.getPCIContentAsXMLDocument(pciQuery); 
            htmlContent=xmlHelper.generateHTMLString(xmlDocument,xsltPath,page,properties,sortType,themeName,sling);
            admin.putInCache(pciQuery.getOSCacheKey(),htmlContent);
 
        } 
            pciQuery.setCacheRefresh(cacheRefreshPeriod); 
          
 
        return htmlContent; 
    }
     
 
  
  
      public String getTabContent(PCIResult[] results,String xsltFilePath ,String OSkey,ValueMap properties, SlingScriptHelper sling) throws Exception {
        
            XMLHelper xmlHelper = new XMLHelper(); 
            String htmlContent="";
            String host="";
            String XMLstr="<?xml version='1.0'  encoding='UTF-8' ?><newstab>";
            if(results!=null){
                            for (int ix=0;ix<results.length;ix++){ 
                                           PCIResult result=results[ix];
                                           XMLstr+="<viewentry>";
                                           XMLstr+="\n<count>"+ix+"</count>";
                                           host="";
                                           if(result.getServerHostDomain()!=null && !result.getServerHostDomain().trim().equals("") ){host=result.getServerHostDomain();}

                                           if(result.getPublishDate()!=null){
                                                     XMLstr+="\n<pubdate>"+getDateFormat(filterInvalidXMLchars(result.getPublishDate()),"mm.dd.yy","mm.dd.yyyy")+"</pubdate>";
                                            }else{
                                                     XMLstr+="\n<pubdate> </pubdate>";
                                             }
                                           if(result.getDocumentTitle()!=null){
                                                     XMLstr+="\n<doctitle><![CDATA["+result.getDocumentTitle()+"]]></doctitle>";
                                           }else{
                                                     XMLstr+="\n<doctitle> </doctitle>";
                                            }
                                          if(result.getCategoryID()!=null){
                                                     XMLstr+="\n<categoryID>"+filterInvalidXMLchars(result.getCategoryID())+"</categoryID>";
                                           }else{
                                                     XMLstr+="\n<categoryID> </categoryID>";         
                                            }
                                          if(result.getDescription()!=null){
                                                     XMLstr+="\n<description><![CDATA["+result.getDescription()+"]]></description>";
                                           }else{
                                                     XMLstr+="\n<description> </description>";
                                            }
                                         if(result.getTypeCode()!=null){
                                                     XMLstr+="\n<typeCode>"+filterInvalidXMLchars(result.getTypeCode())+"</typeCode>";
                                           }else{
                                                     XMLstr+="\n<typeCode> </typeCode>";
                                           }
                                         if(result.getCategoryTitle()!=null){
                                                     XMLstr+="\n<categoryTitle><![CDATA["+result.getCategoryTitle()+"]]></categoryTitle>";
                                          }else{
                                                     XMLstr+="\n<categoryTitle> </categoryTitle>";
                                           }
                                        if(result.getImageURI()!=null){

                                                     XMLstr+="\n<imageURI>"+filterInvalidXMLchars(result.getImageURI())+"</imageURI>";
                                          }else{
                                                     XMLstr+="\n<imageURI></imageURI>";
                                           }
                                        if(result.getThumbnailURI()!=null){
                                                    XMLstr+="\n<thumbnailURI>"+result.getThumbnailURI()+"</thumbnailURI>";
                                        }else{
                                                    XMLstr+="\n<thumbnailURI></thumbnailURI>";
                                         }
                                        if(result.getCreationDate()!=null){
                                                    XMLstr+="\n<creationDate>"+filterInvalidXMLchars(result.getCreationDate())+"</creationDate>";
                                         }else{
                                                    XMLstr+="\n<creationDate> </creationDate>";
                                          }
                                       if(result.getPageURI()!=null){
                                                    XMLstr+="\n<pageuri>"+host+filterInvalidXMLchars(java.net.URLDecoder.decode(result.getPageURI()))+"</pageuri>";
                                        }else {
                                                    XMLstr+="\n<pageuri>"+host+"</pageuri>";
                                         }
                                       XMLstr+="</viewentry>";
        
                      } 
          
                      XMLstr=XMLstr+"</newstab>";
           
       
 
                       String transformedXML = "";    
                        
                       final ClassLoader oldLoader =   Thread.currentThread().getContextClassLoader();
                          
                          
                          try{
       
                              
                              
                                  int cacheRefreshPeriod = 900; //default to 15 min
                                  String osKeyVal=OSkey;
                             if(!osKeyVal.trim().equals("") )
                             {
                                  try {            
                              
                                        
                              
                                           admin = CacheUtil.getInstance();
                                           String cacheRefreshPeriodTemp =PropertyHelper.getPropValue("commonp.properties","CDC_OScachekey_RefreshTime");
        
                                           if(cacheRefreshPeriodTemp !=null){
                                                     cacheRefreshPeriod =new Integer(cacheRefreshPeriodTemp); 
                                            }
 
                                           // checking key from cache // 
                                           htmlContent=(String)admin.getFromCache(osKeyVal,cacheRefreshPeriod);
                    
                                 } catch (com.opensymphony.oscache.base.NeedsRefreshException nre) 
                                  {
            
                       
                                            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
                                            DocumentBuilder builder = factory.newDocumentBuilder();
                                            Document d=builder.parse(new InputSource(new StringReader(XMLstr)));
                                            htmlContent= xmlHelper.transformedXML(d,xsltFilePath,sling);
                                            admin.putInCache(osKeyVal,htmlContent);
                                   }
                              
                            }else{
                                            
                                            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
                                            DocumentBuilder builder = factory.newDocumentBuilder();
                                            Document d=builder.parse(new InputSource(new StringReader(XMLstr)));
                                            htmlContent= xmlHelper.transformedXML(d,xsltFilePath,sling);
                                } 
                          }catch(Exception e){
                                            log.error("[PciHelper.getTabContent()] Exception:"+e.getMessage());
                           }  
        
             }
        return htmlContent; 
    }
      
      
      
      
      
      
      
      public String filterInvalidXMLchars(String str){
        
        if(str.contains("<"))
        {
         str=str.replaceAll("<","&#60;");
         }
        if(str.contains(">"))
        {
         str=str.replaceAll(">","&#62;");
         }
        if(str.contains("\""))
        {
         str=str.replaceAll("\"","&#34;");
         }
        if(str.contains("'"))
        {
         str=str.replaceAll("'","&#039;");
         }
         if(str.contains("&"))
         {
         str=str.replaceAll("&","&#38;");
         }
         
      return str;
      }
      
       
      public  String getDateFormat(String strDate,String fromFormat,String toFormat)
      {
          String fdate="";
          try{
              DateFormat formatter;
              formatter = new SimpleDateFormat(fromFormat);
              Date date =  (Date)formatter.parse(strDate);
              formatter = new SimpleDateFormat(toFormat);
              fdate = formatter.format(date);
          }catch(ParseException e){
              fdate="";
           }
      return fdate;
      } 
     
}
