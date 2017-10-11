/*
   Service to hold CRX login information
   Used by com.mcd.cq.util.UserAdmin
    Erik Wannebo 10-8-10
    


*/
package com.mcd.cq.util;

import org.osgi.service.component.ComponentContext;  
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Properties;

@Component(immediate=true,metatype=false)
@Service(CRXInfoService.class)
@Properties({
    @Property( name="service.description",value="Used to connect to CRX when auto-creating users for Search Security requests."),
    @Property( name="service.vendor",value="MCD"),
    @Property( name = "ultraseekServer", value="Ultraseek Server"),
    @Property( name = "indexServer", value="CQ Publish Server server/port")
})

@SuppressWarnings("serial")   
 /** 
  * @scr.component immediate="true"  
  * @scr.service description="Used to connect to CRX when auto-creating users for Search Security requests." interface="CRXInfoService" 
  */  
 public class CRXInfoService{  
    
     @Property(label="CRX Port", value="DEFAULT_CRX_PORT")
     public static final String PROP_CRX_PORT = "com.mcd.cq.util.CRXPort";  

     public static final String DEFAULT_CRX_PORT = "4502";  


     @Property(label="CRX Admin Password", value="DEFAULT_CRX_ADMIN_PASSWORD")
     public static final String PROP_CRX_ADMIN_PASSWORD = "com.mcd.cq.util.CRXAdminPassword";  
   
     public static final String DEFAULT_CRX_ADMIN_PASSWORD = "";  
   
     private int crxport;   
     private String crxadminpassword;   
   
     public int getCRXPort() {  
         return this.crxport;  
     } 
     
     public String getCRXAdminPassword() {  
         return this.crxadminpassword;  
     }   
   
     protected void activate(ComponentContext context) {  
         Object crxport = context.getProperties().get(PROP_CRX_PORT );  
         if (crxport != null){  
             try{
                 this.crxport = Integer.parseInt(crxport.toString());  
             }catch(NumberFormatException nfe){
             }
         }
         Object crxadminpassword = context.getProperties().get(PROP_CRX_ADMIN_PASSWORD);  
         if (crxadminpassword != null)  
             this.crxadminpassword = crxadminpassword.toString();
     }  
 }   