    package com.mcd.gmt.product.util;
    
    import java.util.ResourceBundle;
    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory; 

import com.day.cq.wcm.api.Page;

    import java.math.BigDecimal;
    import java.math.MathContext;
import java.util.StringTokenizer;
    
    
    public  class  CommonUtil {
        

       private static final Logger log = LoggerFactory.getLogger(CommonUtil.class);
        
         public  static String getValues(String key)
         {
             String value=null;      
             try
             {
                 ResourceBundle rb = ResourceBundle.getBundle("com.mcd.gmt.product.resources.nutrient");    
                 value = rb.getString(key); 
             }catch (Exception ex) {
                 log.error("Full name for "+key+" not found in mapping file. Exception :" + ex.getMessage());
            }
            if(value == null){
                // Added for new functionality //
                //value = key;
                value="";
            }
            return value;
         }  
    
    
    
    
        public static String roundToFourDigits(String num)
        {
    
            StringTokenizer numBef= new StringTokenizer(num,".");
            int len= numBef.nextToken().length();
            String roundStr="";
    
            MathContext mc = new MathContext(len+4);
            BigDecimal bigDec = new BigDecimal(num);
            roundStr=bigDec.round(mc).toString();
            // Added for New Functionality //
            if(roundStr.equals("0"))
            {
            roundStr="";            
            }
            
            return roundStr;
         }
        
        
        /** 
         * This method will be used to retrieve page atom data
         * @param Page page, String atomName
         * @return String atomValue.
         */
        public String getPageProperty(String propertyName, Page page) throws Exception{
            String propertyValue = "";
            if(page != null)
            {
                propertyValue = page.getProperties().get(propertyName, "");;
            }
            return propertyValue;
        }
        
        
        /** 
         * This method will be used to retrieve page atom data
         * @param Page page, String atomName
         * @return String atomValue.
         */
        public String[] getMultiValuePageProperty(String propertyName, Page page) throws Exception{
            String [] propertyValue = {};
            if(page != null)
            {
                propertyValue = page.getProperties().get(propertyName, String[].class);;
            }
            return propertyValue;
        }
    }
