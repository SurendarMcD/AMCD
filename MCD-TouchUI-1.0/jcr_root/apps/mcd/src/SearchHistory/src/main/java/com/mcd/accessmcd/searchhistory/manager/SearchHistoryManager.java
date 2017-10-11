package com.mcd.accessmcd.searchhistory.manager;

import org.apache.sling.api.scripting.SlingScriptHelper;

import java.util.Map;
import java.util.List;

import com.mcd.accessmcd.searchhistory.bean.HistoryItem;

public interface SearchHistoryManager {
    
    public Map<String, List<HistoryItem>> getUserSearchHistory(String userId, String noOfDays, String dateFormat, String displayOrder, SlingScriptHelper sling,String lang) throws Exception;
    
}