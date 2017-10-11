package com.mcd.stockticker.manager;

/****************************************************
 * Copyright (C) 2010 McDoanld's, Corp. All Rights Reserved.
 *
 * Interface: IMcdStockTicker.java
 *
 ****************************************************/


public interface IMcdStockTicker {

    public String getMcdStockInfo(String url, int theTimeout);
     
}
