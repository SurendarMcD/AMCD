package com.mcd.accessmcd.searchhistory.bean;

import java.util.Date;

public class HistoryItem {
    
    private String queryText;
    private String language;
    private String market;
    private Date date;
    
    public HistoryItem(String queryText, String language, String market, Date date) {
        this.queryText = queryText;
        this.language = language;
        this.market = market;
        this.date = date;
    }
    
    public String getQueryText() {
        return queryText;
    }
    
    public void setQueryText(String queryText) {
        this.queryText = queryText;
    }
    
    public String getLanguage() {
        return language;
    }
    
    public void setLanguage(String language) {
        this.language = language;
    }
    
    public String getMarket() {
        return market;
    }
    
    public void setMarket(String market) {
        this.market = market;
    }
    
    public Date getDate() {
        return date;
    }
    
    public void setDate(Date date) {
        this.date = date;
    }
}