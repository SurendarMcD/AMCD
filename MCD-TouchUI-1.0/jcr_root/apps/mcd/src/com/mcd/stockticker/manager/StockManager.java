
/**
 * Version: 1.0
 * Date: 
 * Purpose: A  manager class that reads the xml string and set the properties of the bean class.
 * Project: 
 *
 */

package com.mcd.stockticker.manager;

import java.io.StringReader;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import com.mcd.stockticker.bean.StockDetails;
import com.mcd.util.CacheUtil;

import com.opensymphony.oscache.general.GeneralCacheAdministrator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class StockManager {

    private String url;
    private int timeout;
    private URLHelper helper;
    final String COMPANYNAME_TO_RETRIEVE_STOCKVALUE="McDonald's Corporation";
    //final String COMPANYNAME_TO_RETRIEVE_STOCKVALUE="NASDAQ Composite";
    private static final Logger log = LoggerFactory.getLogger(StockManager.class);
    private GeneralCacheAdministrator admin = null; 
      /**
    * Class constructor
    * @param String.
    */
    public StockManager (String url, int timeout) {
    log.info("***** Stock Manager XML url ******** "+url);
        this.url = url; 
        this.timeout = timeout;
        helper = new URLHelper();
    }
     
    /*
    * Method set the value of the bean
    * return bean object.
    */
    public StockDetails getStockInfo() {
        
        StockDetails stockDetails = null;

        //added caching of Stock Details - 3/10/09 ECW
         log.info("***** getStockInfo  XML url ******** "+this.url);           
        String osKeyVal=this.url;
        try {
            admin = CacheUtil.getInstance();
            int  cacheRefreshPeriod=60;//default
            //change cache period outside market hours 3/10/09 ECW
            Calendar rightNow = Calendar.getInstance();
            if(rightNow.get(Calendar.HOUR_OF_DAY)<8 || rightNow.get(Calendar.HOUR_OF_DAY)>15)cacheRefreshPeriod=1800;           
            // try to get stockDetails from cache //
            stockDetails=(StockDetails)admin.getFromCache(osKeyVal,cacheRefreshPeriod);
         } catch (com.opensymphony.oscache.base.NeedsRefreshException nre) {
            try {
            stockDetails = new StockDetails();
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();      
            Document doc = db.parse(new InputSource(new StringReader(helper.getXML(url, timeout))));
            doc.getDocumentElement().normalize();
            NodeList nodeLst = doc.getElementsByTagName("Stock_Quote");
            int nodeSize = nodeLst.getLength();
            
            for (int s = 0; s < nodeSize; s++) {
                String companyName = "";
                Node fstNode = nodeLst.item(s);
                NamedNodeMap attributes = fstNode.getAttributes();     // Get attributes
                        for(int i = 0; i < attributes.getLength(); i++) {  // Loop through them
                        Node child = attributes.item(i);
                        if(child.getNodeName().equalsIgnoreCase("Company"))
                        {
                            companyName = child.getNodeValue();
                        }                   
                        }
                
                if ((fstNode.getNodeType() == Node.ELEMENT_NODE) && (companyName.equalsIgnoreCase(COMPANYNAME_TO_RETRIEVE_STOCKVALUE)))
                {
                    //log.error("Company name to pick values : "+companyName);              
                stockDetails.setDate(returnNodeValue(fstNode,"Date"));
                stockDetails.setTradePrice(returnNodeValue(fstNode,"Trade"));
                //log.error("SL tradeprice " + returnNodeValue(fstNode,"Trade"));
                stockDetails.setChange(returnNodeValue(fstNode,"Change"));
                //log.error("SL change price " + returnNodeValue(fstNode,"Change"));
                stockDetails.setBid(returnNodeValue(fstNode,"Bid"));
                stockDetails.setBidSize(returnNodeValue(fstNode,"BidSize"));
                stockDetails.setHigh(returnNodeValue(fstNode,"High"));
                stockDetails.setLow(returnNodeValue(fstNode,"Low"));
                stockDetails.setVolume(returnNodeValue(fstNode,"Volume"));
                stockDetails.setOpen(returnNodeValue(fstNode,"Open"));
                stockDetails.setPreviousClose(returnNodeValue(fstNode,"PreviousClose"));
                //log.error("SL Previous close " + returnNodeValue(fstNode,"PreviousClose"));
                stockDetails.setFiftyTwoWeekHigh(returnNodeValue(fstNode,"FiftyTwoWeekHigh"));
                stockDetails.setFiftyTwoWeekLow(returnNodeValue(fstNode,"FiftyTwoWeekLow"));
                stockDetails.setPeRatio(returnNodeValue(fstNode,"PERatio"));
                }
            }
            } catch (Exception e) {         
            stockDetails = null;
            log.error("StockManager getStockInfo XML parser error : "+e);
            }
            admin.putInCache(osKeyVal,stockDetails);
            }
            return stockDetails;
    }
    
    /*
    * Method return XML Document.
    */
    public Document getDocument() {     
        Document document =null;
        try {
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();          
            document = db.parse(new InputSource(new StringReader(helper.getXML(url, timeout))));
        }
        catch(Exception e)
        {
            log.error("StockManager getDocument() XML parser error : "+e.getMessage());
        }
        return document;
    }
    
    
    /*
    * Method to get node value
    * @param Node, String
    * returns XML node value as String
    */
    public String returnNodeValue(Node fstNode,String nodeName) throws Exception
    {       
        
        
            Element fstElmnt = (Element) fstNode;
            NodeList fstNmElmntLst = fstElmnt.getElementsByTagName(nodeName);
            Element fstNmElmnt = (Element) fstNmElmntLst.item(0);
            NodeList fstNm = fstNmElmnt.getChildNodes();
            String value = (String)(((Node) fstNm.item(0)).getNodeValue());
            if(nodeName.equalsIgnoreCase("Date")) // As date should be formatted '1-27-09 15:00 CT'
            {
                return convertDate(value);
            }
            else
            {
                return value;           
            }
    
    }
    
    /*
    * Method to set date '1-27-09 15:00 CT'
    * @param String
    * returns formated date as String
    */
    private String convertDate(String stockDate)  throws Exception
    {       

        Calendar now = Calendar.getInstance(Locale.US);
        SimpleDateFormat dateformat1 = new SimpleDateFormat("MMM dd yyyy hh:mma"); // Jan 27 2009 4:03PM
        dateformat1.setCalendar(now);

        SimpleDateFormat dateformat2 = new SimpleDateFormat("M-dd-yy HH:mm z"); // 1-27-09 15:00 CT
        dateformat2.setCalendar(now);
        
        
        Date inputdate = dateformat1.parse(stockDate);
        String newDate = dateformat2.format(inputdate); 
        log.debug("The formatted date : "+newDate); 
        return newDate;
        
    }

}