package com.mcd.stockticker.facade;
/****************************************************
 * Copyright (C) 2005 McDoanld's, Corp. All Rights Reserved.
 *
 * StockTicker facade implementation
 *
 ****************************************************/
import com.mcd.stockticker.manager.StockManager;
import com.mcd.stockticker.bean.StockDetails;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class StockTickerFacadeImpl implements IStockTickerFacade {
    
    private static final Logger log = LoggerFactory.getLogger(StockTickerFacadeImpl.class);
    
    public StockDetails getStockInfo(String url, int timeout){
         
         log.info("***** Stock URL *******" + url);       
         StockManager manager = new StockManager(url, timeout);
         StockDetails stockDetails = manager.getStockInfo();
         
         return stockDetails;
     
    }
}