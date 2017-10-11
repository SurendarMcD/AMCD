package com.mcd.accessmcd.searchhistory.util;

import java.util.Date;
import java.util.Calendar;
import java.text.SimpleDateFormat;
import java.util.Locale;

public class SearchHistoryUtil {
    
    /**
     * Get date from current date minus the difference
     * @param noOfDays - difference from current date
     */
    public static Date getFromDate(String noOfDays) {
        Calendar currentCal = Calendar.getInstance();
        currentCal.add(Calendar.DATE, Integer.parseInt("-"+noOfDays)); 
        return currentCal.getTime();
    }
    
    /**
     * Get formatted date according to the format passed
     * @param date - input date
     * @param dateFormat - required date format
     */
    public static String getFormattedDate(Date date, String dateFormat, String lang) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date currentDate = new Date();
        String dateType = sdf.format(currentDate);
        SimpleDateFormat dateFormatter=null;
        String  dateStrToday="";
        if(lang.equals("fr")){
            dateFormatter = new SimpleDateFormat(dateFormat,Locale.FRENCH);          
            dateStrToday="aujourd'hui";
            
        } 
        else{
            dateFormatter = new SimpleDateFormat(dateFormat);
            dateStrToday="Today";
        }
       
        String  dateStr = dateFormatter.format(date);
        if(date.toString().equals(dateType)){
            int index = dateStr.indexOf(",");
            dateStr = dateStr.replaceFirst(dateStr.substring(0, index),dateStrToday);
                   
        }
             
      if(lang.equals("fr")){
      dateStr="le " + dateStr;
      }
                  
                  
        return (dateStr);
    }
    
}