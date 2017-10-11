package com.mcd.stockticker.util;
import java.text.NumberFormat;

public class StockUtil{

       /**
     * @param current: current stock price
     * @param change: price change
     * @return: returns stock price change in % format.
     */
       
       public String formatPercentage(String current, String change){
            //System.out.println("Current price " + current + " change price " + change);
        String stockPercChange = "";
        double dcurrent = 0;
        double dprev = 0;
        double pricePerc = 0;
        
        try{
            dcurrent = Double.valueOf(current.trim()).doubleValue();
            dprev = Double.valueOf(change.trim()).doubleValue();
            pricePerc = dprev * 100/dcurrent;
            java.text.NumberFormat nf;
            nf = NumberFormat.getInstance();
            nf.setMinimumFractionDigits(2);
            nf.setMaximumFractionDigits(2);
            
            stockPercChange = nf.format(pricePerc) + "%";
            
        }catch(NumberFormatException e){
         System.out.println(e.getMessage());    
        }
       return stockPercChange;
    }
} 