/****************************************************
 * Copyright (C) 2010 McDoanld's, Corp. All Rights Reserved.
 *
 * Bean class that contains the Current Stock Details
 *
 *
 *
 *  
 ****************************************************/
 

package com.mcd.stockticker.bean;
public class StockDetails {
    
    private String date;
    private String tradePrice;
    private String change; 
    private String bid; 
    private String bidSize; 
    private String high; 
    private String low; 
    private String volume; 
    private String open; 
    private String previousClose; 
    private String fiftyTwoWeekHigh; 
    private String fiftyTwoWeekLow; 
    private String peRatio;
    
    
    // get Trading date
    public String getDate() {
        return date;
    }
    // set Trading date
    public void setDate(String date) {
        this.date = date;
    }
    // get Bid price
    public String getBid() {
        return bid;
    }
    // set Bid Price
    public void setBid(String bid) {
        this.bid = bid;
    }
    
    public String getBidSize() {
        return bidSize;
    }
    // set the number of shares the buyer is looking to purchase
    public void setBidSize(String bidSize) {
        this.bidSize = bidSize;
    }
    
    // get Change in Trading Price
    public String getChange() {
        return change;
    }
    // set change in Trading Price
    public void setChange(String change) {
        this.change = change;
    }
    
    public String getFiftyTwoWeekHigh() {
        return fiftyTwoWeekHigh;
    }
    
    // set the highest price of the security within the previous 52 weeks.
    public void setFiftyTwoWeekHigh(String fiftyTwoWeekHigh) {
        this.fiftyTwoWeekHigh = fiftyTwoWeekHigh;
    }
    
    public String getFiftyTwoWeekLow() {
        return fiftyTwoWeekLow;
    }
    
    // set The lowesr price of the security within the previous 52 weeks.
    public void setFiftyTwoWeekLow(String fiftyTwoWeekLow) {
        this.fiftyTwoWeekLow = fiftyTwoWeekLow;
    }
    
    public String getHigh() {
        return high;
    }
    
    // set The highest price quote for a security during the session
    public void setHigh(String high) {
        this.high = high;
    }
    
    public String getLow() {
        return low;
    }
    // set The lowest price quote for a security during the session
    public void setLow(String low) {
        this.low = low;
    }
    
    public String getOpen() {
        return open;
    }
    // set the price of the security when the market opened 
    public void setOpen(String open) {
        this.open = open;
    }
    
    public String getPeRatio() {
        return peRatio;
    }
    
    // set Price-Earning Ratio
    public void setPeRatio(String peRatio) {
        this.peRatio = peRatio;
    }
    // get PreviousClose
    public String getPreviousClose() {
        return previousClose;
    }
    // set PreviousClose (The price of the stock at the end of the previous trading session.)
    public void setPreviousClose(String previousClose) {
        this.previousClose = previousClose;
    }
    
    //return current trading price
    public String getTradePrice() {
        return tradePrice;
    }
    
    //set current trading price
    public void setTradePrice(String trade) {
        this.tradePrice = trade;
    }
    
    //get volume size
    public String getVolume() {
        return volume;
    }
    // set volume (number of shares traded since the previous close)
    public void setVolume(String volume) {
        this.volume = volume;
    }
    
    
}