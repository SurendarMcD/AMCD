package com.mcd.accessmcd.searchhistory.manager.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.sling.api.scripting.SlingScriptHelper;
import java.util.Properties;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.LinkedHashMap;
import java.io.StringWriter;
import javax.mail.*;
import javax.mail.internet.*;
import com.mcd.accessmcd.ace.manager.ACEMailManager;
import com.mcd.accessmcd.searchhistory.bean.HistoryItem;
import com.mcd.accessmcd.searchhistory.util.SearchHistoryUtil;
import com.mcd.accessmcd.searchhistory.dao.SearchHistoryDao;
import com.mcd.accessmcd.searchhistory.dao.impl.SearchHistoryDaoImpl;
import com.mcd.accessmcd.searchhistory.manager.SearchHistoryManager;

public class SearchHistoryManagerImpl implements SearchHistoryManager {
     private String lang ="en";
    
    private static final Logger log = LoggerFactory.getLogger(SearchHistoryManagerImpl.class);
    private ACEMailManager mailConfigProp =  new ACEMailManager(lang);
    
    public Map<String, List<HistoryItem>> getUserSearchHistory(String userId, String noOfDays, 
            String dateFormat, String displayOrder, SlingScriptHelper sling, String lang) throws Exception {
        Map<String, List<HistoryItem>> resultMap = null;
        //Get fromDate from noOfDays
        Date fromDate = SearchHistoryUtil.getFromDate(noOfDays);
        //Retreive user search history from database
        SearchHistoryDao historyDao = new SearchHistoryDaoImpl();
        try
        {
        List<HistoryItem> searchHistoryList = historyDao.getHistoryItems(userId, fromDate, displayOrder, sling);
        //Iterate over the history list to get the final result

        if(null != searchHistoryList && searchHistoryList.size() > 0) {
            resultMap = new LinkedHashMap<String, List<HistoryItem>>();
            for(HistoryItem item : searchHistoryList) {
                String formattedDate = SearchHistoryUtil.getFormattedDate(item.getDate(), dateFormat,lang);
                log.info("Query Text :: " + item.getQueryText());
                if(resultMap.containsKey(formattedDate)) {
                    List<HistoryItem> itemList = resultMap.get(formattedDate);
                    itemList.add(item);
                } else {
                    List<HistoryItem> itemList = new ArrayList<HistoryItem>();
                    itemList.add(item);
                     //create a new List from the Set
                    List<HistoryItem> tempList= new ArrayList<HistoryItem>();
                    for (HistoryItem dupWord : itemList) {
                        if (!tempList.contains(dupWord)) {
                            tempList.add(dupWord);
                            log.error("Adding entry in map for date " + formattedDate + " and query text " + dupWord.getQueryText());
                        }
                         //resultMap.put(formattedDate, tempList);
                         //log.error("Adding entry in map for date " + formattedDate + " and query text " + dupWord.getQueryText());
                    }

                    resultMap.put(formattedDate, tempList);
                   //log.info("Adding entry in map for date " + formattedDate + " and query text " + dupWord.getQueryText());
                }
            }
            resultMap = removeDuplicates(resultMap);
        }
            return resultMap;       
        } catch (SQLException sqle) {
            sendExceptionMail(sqle);
            log.error("[SearchHistoryManagerImpl] SQLError while fetching search history for user " + userId, sqle);
            throw new SQLException("[SearchHistoryManagerImpl] SQLError while fetching search history for user " + userId, sqle);
        }
        catch (Exception e) {
            sendExceptionMail(e);
            log.info("SearchHistoryManagerImpl in getting Connection: ",e);
            throw new Exception("SearchHistoryManagerImpl in getting Connection:" + e);
        }

    }

    private Map<String, List<HistoryItem>> removeDuplicates(Map<String, List<HistoryItem>> resultMap) {
        Map<String, List<HistoryItem>> updatedMap =  new LinkedHashMap<String, List<HistoryItem>>();
        for(Map.Entry<String, List<HistoryItem>> entry : resultMap.entrySet() ) {
            List<HistoryItem> itemList= entry.getValue();
            List<HistoryItem> tempList = new ArrayList<HistoryItem>();
            for (HistoryItem item : itemList) {
                String queryText = item.getQueryText();
                if(tempList.size() > 0) {
                    boolean isDuplicate = false;
                    for(HistoryItem tempItem : tempList) {
                        if (null!=tempItem.getQueryText() && tempItem.getQueryText().equals(queryText)) {
                            isDuplicate = true;
                            break;
                        }
                    }
                    if(!isDuplicate) tempList.add(item);
                } else {
                    tempList.add(item);
                }
            }
            updatedMap.put(entry.getKey(), tempList);
        }
        return updatedMap;
    }
    
     private void sendExceptionMail(Exception e)
    {
        StringWriter sw = new StringWriter();
        try
        {
            sendExceptionEmail(mailConfigProp.getValueForKey("toExceptionAddresse"), 
            mailConfigProp.getValueForKey("exceptionSubjectText"),
            mailConfigProp.getValueForKey("exceptionBodyText"), 
            mailConfigProp.getValueForKey("mailServer"), 
            mailConfigProp.getValueForKey("fromAddresse"),
            mailConfigProp.getValueForKey("fromAddressPersonals")); 
        }
        catch(Exception ex)
        {
            log.info("SearchHistoryManagerImpl in getting Connection: ",ex.getMessage());
        }
        finally{
            try{
                if (sw!=null)
                    sw.close();
            }
            catch(Exception eio){
                System.out.println("Error to close stringwriter ---"+eio.getMessage());
            }
        }
    }
    //Sends Exception mail
    private void sendExceptionEmail(String toAddress, String subject, String bodyText, String mailServer, String fromAddress, String fromAddressPersonal) throws Exception
    {
        try
        {
            Properties properties = new Properties();
            properties.put("mail.smtp.host", mailServer);
            Session session = Session.getDefaultInstance(properties, null);
            
            Message msg = new MimeMessage(session);
            InternetAddress addressFrom = new InternetAddress(fromAddress, fromAddressPersonal);
            msg.setFrom(addressFrom);
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toAddress));
            msg.setSubject(subject);
            msg.setContent(bodyText, "text/html");
            Transport.send(msg);
           
        }
        catch(Exception messagingexception)
        {
            
        }
    }
}