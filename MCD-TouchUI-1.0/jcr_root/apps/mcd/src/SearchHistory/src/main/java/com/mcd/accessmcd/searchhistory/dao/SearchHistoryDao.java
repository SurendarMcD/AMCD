package com.mcd.accessmcd.searchhistory.dao;

import org.apache.sling.api.scripting.SlingScriptHelper;

import java.util.Date;
import java.util.List;

import com.mcd.accessmcd.searchhistory.bean.HistoryItem;

public interface SearchHistoryDao {

    public List<HistoryItem> getHistoryItems(String userId, Date fromDate, String displayOrder, SlingScriptHelper sling) throws Exception;

    //public boolean contains(List<HistoryItem[]> list, HistoryItem[] value);
}
