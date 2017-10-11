package com.mcd.stockticker.facade;

/****************************************************
 * Copyright (C) 2010 McDoanld's, Corp. All Rights Reserved.
 *
 * StockTicker facade interface
 * 
 ****************************************************/
import com.mcd.stockticker.bean.*;

public interface IStockTickerFacade {
    
    //public String getStockInfo(String url, int timeout, StockTickerBean stockBean) throws Exception;
    public StockDetails getStockInfo(String url, int timeout) throws Exception;
} 
