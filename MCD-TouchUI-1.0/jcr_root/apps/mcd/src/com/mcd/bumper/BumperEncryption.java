package com.mcd.bumper;
 
import com.mcd.util.PropertiesLoader;
import java.util.Properties; 
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;



/**
 * This class <code>BumperEncryption.java<code> is responsible for
 * creating appropriate link for bumper link.
 * 
 * @author Deepali Goyal
 * 
 * @version 1.0 Date: Feb 04, 2010
 *
 */
  
public class BumperEncryption {
    
    private static final Logger log = LoggerFactory.getLogger(BumperEncryption.class);
       
    public String getBumperRichLink(String bumperText) {
      
      try {         
        int linkStartIndex = bumperText.indexOf("href=");
        int linkEndIndex=0;
        while(linkStartIndex != -1) {
         
         linkEndIndex = bumperText.indexOf(">",linkStartIndex );
                
         String site = bumperText.substring(linkStartIndex+6, linkEndIndex-1);
         
        if(! ( site.startsWith("/content") || site.startsWith("mailto:") ) ) {
            if(!isBumperLink(site))
                 bumperText = bumperText.substring(0,linkEndIndex) + " class='external' "  + bumperText.substring(linkEndIndex,bumperText.length());
         }
          
         linkStartIndex = bumperText.indexOf("href=", linkEndIndex);
       }        
      }
      catch (Exception e){
          log.error(e.getMessage());
      }
      
      return(bumperText);
    }
    
          
    public boolean getBumperLink(String site) {
     if(isBumperLink(site))
         return false;
     else 
         return true;
   }         

    public Boolean isBumperLink(String site) 
    {       
      try
      { 
          site = site.replaceAll("http://","");
          site = site.replaceAll("https://","");
          
          Properties properties = PropertiesLoader.loadProperties("common.properties");
          String bumperlinks = properties.getProperty("bumper");  
          String[] links = bumperlinks.split(",");
            
          if(links != null){
              for (int i = 0; i < links.length; i++){
                    
                  if(wildCardMatch(site, links[i])){
                     return true;
                  }
              }
          }  
      }
      catch (Exception e){ 
          log.error(e.getMessage());
      }
      
      return false;
    } 
   
    public Boolean isInternalBumperLink(String site) 
    {       
        try
        { 
              Properties properties = PropertiesLoader.loadProperties("common.properties");
              String bumperlinks = properties.getProperty("includeAsBumper");  
              String[] links = bumperlinks.split(",");
              
              if(links != null){
                  
                  for (int i = 0; i < links.length; i++){                    
                      if(site.equals(links[i].trim()) || site.equals(links[i].trim()+".html")){
                         return true;
                      }
                  }
              }  
        }
        catch (Exception e){ 
            log.error(e.getMessage());
        }        
        return false;
    }
    
   public boolean wildCardMatch(String text, String pattern) {
        // Create the cards by splitting using a RegEx. If more speed 
        // is desired, a simpler character based splitting can be done.
        String [] cards = pattern.split("\\*");

        // Iterate over the cards.
        for (String card : cards)
        {
            int idx = text.indexOf(card);
            
            // Card not detected in the text.
            if(idx == -1)
            {
                return false;
            }
                   
            // Move ahead, towards the right of the text.
            text = text.substring(idx + card.length());
        }
        
        return true;
    }

}                               