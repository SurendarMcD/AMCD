
/**
 * Version: 1.0
 * Date: 
 * Purpose: A helper class to connect with the URL and read the xml output stream.
 * Project: 
 *
 */

package com.mcd.stockticker.manager;

import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class URLHelper {
    
    private static final Logger log = LoggerFactory.getLogger(URLHelper.class);
    
    /*
    * Connect with the url
    * return response as String
    */
    public String getXML(String url,int timeout)
    {
        String xmlString = "";
        
        try {
            URL stockUrl = new URL(url);
            //log.error("StockTicker URLHelper URL "+url + " timeout " + timeout);
        
            URLConnection connection = stockUrl.openConnection();
            connection.setConnectTimeout(timeout);
            connection.connect();
            //log.error("connected.");
            InputStream inputStream = connection.getInputStream();
            //log.error("Input stream");
            int i = 0;
            while((i=inputStream.read()) != -1 )
            {
                xmlString +=  (char)i;  
                //log.error("XMLString "  + xmlString);         
            }
        
        }catch (java.net.SocketTimeoutException se){
            log.error("URLHelper.getXML StockTicker: Connectioon Timeout");
            xmlString = "";
        } catch (IOException e) {
                log.error("URLHelper.getXML StockTicker: Fatal transport error: " + e.getMessage());
            xmlString = "";
        } catch (Exception e) {
            e.printStackTrace();
            log.error("Url Connection Error "+e);
            xmlString = "";
        }
        
        //this.getMcdStock(url,timeout);
        return xmlString;
    }
     
    
    
/*  private String getMcdStock(String url, int theTimeout) {
    //log.error(" URL " + url + " Timeout " + theTimeout);
        // String url = "https://www.shareholder.com/irxml/irxmlJS1.cfm?COMPANYID=MCD&PIN=306811600&FUNCTION=StockQuote&VERSION=2&TICKER=MCD&";
        //url="http://developer.webpartz.com/iuploadsrvc.aspx?commandtype=3&command=comment.get&accesskey=cc9f762e-91e2-4a3a-a6c2-ee71814cab2b&companyid=667&blogitemid=529400&sort=BlogItemCommentInfo.Id%20DESC";
        String mcdStockInfo = "";
 
        // Create an instance of HttpClient.
        HttpClient client = new HttpClient();
 
        //Set the timeout for waiting for data
            //client.setTimeout(10000); //10 seconds
            //client.setTimeout(theTimeout); 
                client.getHttpConnectionManager().getParams().setSoTimeout(theTimeout);
 
            // Create a method instance.
            GetMethod method = new GetMethod(url);
 
         // Provide custom retry handler is necessary
            method.getParams().setParameter(HttpMethodParams.RETRY_HANDLER,new DefaultHttpMethodRetryHandler(3, false));
        
            try {
    
        //  log.error("Status Text>>>" +HttpStatus.getStatusText(statusCode));
                // Execute the method.
                int statusCode = client.executeMethod(method);
            
        //  log.error("McdStockTicker.getMcdStockInfo() status code " + statusCode);
                if (statusCode != HttpStatus.SC_OK) {
                    log.error("Method failed: " + method.getStatusLine());
                }
                
                byte[] responseBody = method.getResponseBody();
 
                // Deal with the response.
                // Use caution: ensure correct character encoding and is not binary data
                mcdStockInfo = (new String(responseBody));
 
            } catch (HttpException e) {
                log.error("McdStockTicker.getMcdStockInfo() Fatal protocol violation: " + e.getMessage());
                //e.printStackTrace();
                mcdStockInfo = "";
            } catch (IOException e) {
                log.error("McdStockTicker.getMcdStockInfo() Fatal transport error: " + e.getMessage());
            //e.printStackTrace();
                mcdStockInfo = "";
            } finally {
                // Release the connection.
            //log.error("McdStockTicker.getMcdStockInfo() release connection");
                method.releaseConnection();
            }
        //mcdStockInfo= "var RECORDCOUNTStockQuote=\"1\",COLUMNLISTStockQuote=\"ASK,BID,CHANGE,COMPANYNAME,DATETIME,DIVIDEND,EPS,EXCHANGE,HIGH,LASTDATETIME,LASTPRICE,LONGNAME,LOW,OPEN,PCHANGE,PE,PREVIOUSCLOSE,SHARES,SHORTNAME,TICKER,TRADES,VOLUME,YEARHIGH,YEARLOW,YIELD\",ASK1=\"0\",BID1=\"0\",CHANGE1=\"0.650\",COMPANYNAME1=\"\",DATETIME1=\"2008-09-18 10:14:10\",DIVIDEND1=\"0.375\",EPS1=\"3.810\",EXCHANGE1=\"NYSE\",HIGH1=\"63.700\",LASTDATETIME1=\"2008-09-18 10:14:10\",LASTPRICE1=\"63.170\",LONGNAME1=\"McDonald's Corp.\",LOW1=\"62.530\",OPEN1=\"63.380\",PCHANGE1=\"1.040\",PE1=\"16.000\",PREVIOUSCLOSE1=\"62.520\",SHARES1=\"1124678\",SHORTNAME1=\"McDonald's Corp.\",TICKER1=\"MCD\",TRADES1=\"6661\",VOLUME1=\"1805900\",YEARHIGH1=\"67.000\",YEARLOW1=\"49.360\",YIELD1=\"2.419\",IRXMLSTATUS=\"No Error\",IRXMLSTATUSCODE=\"0\"";
            log.error("mcdStockInfo " + mcdStockInfo);
        return mcdStockInfo;
        }*/

}