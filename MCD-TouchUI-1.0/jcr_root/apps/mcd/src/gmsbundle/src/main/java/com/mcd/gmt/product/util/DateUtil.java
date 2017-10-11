package com.mcd.gmt.product.util;

import java.util.Calendar;
import java.text.SimpleDateFormat;


public class DateUtil {

    public static String creationDateTime() {
        Calendar cal = Calendar.getInstance();
        String DATE_FORMAT_NOW = "ddMMyy_HHmmss";
        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT_NOW);
        return sdf.format(cal.getTime());
      }
    
    
} 
 