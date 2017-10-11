package com.mcd.stockticker.constants;
/****************************************************
 * Copyright (C) 2010 McDoanld's, Corp. All Rights Reserved.
 *
 * A class lists the StockTicker Contstants variables
 *
 *  
 ****************************************************/


public final class StockTickerConstants {
     
     
    //public static final String url  = "http://apps.shareholder.com/irxml/irxml.aspx?COMPANYID=MCD&PIN=6c0180e831cb55c470c431f76ba714d6&FUNCTION=StockQuote&output=js2&TICKER=mcd";
    public static final String url  = "http://xml.corporate-ir.net/irxmlclient.asp?compid=97876&reqtype=quotes&symb=mcd";
    //public static final String url  = "http://xml.corporate-ir.net/irxmlclient.asp?compid=132066&reqtype=quotes";
     
                                           
    public static final int timeout  = 12000; //12 sec
    
    private StockTickerConstants(){};
    
}
 