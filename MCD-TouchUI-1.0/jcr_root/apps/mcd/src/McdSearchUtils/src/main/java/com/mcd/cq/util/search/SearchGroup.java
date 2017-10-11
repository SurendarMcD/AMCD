/*
* Utility class to encode a list of groups
* These coded groups are used in page header META tags, attachment links
* The groups are also used as a Secured Search Filter
*
* Erik Wannebo 10-5-2010
*/
 
package com.mcd.cq.util.search;

import java.io.*;             // For reading the input file


import java.util.*;
import java.text.*;

import org.slf4j.Logger;    
import org.slf4j.LoggerFactory;

public class SearchGroup {


/**
 * default constructor
 */
    public SearchGroup() {}

    private static final Logger log = LoggerFactory.getLogger(SearchGroup.class);

    //Changed to TreeMap to provide consistent ordering 8/21/08 ECW
    public static Map groupCodes=new TreeMap();
    static{ 
        groupCodes.put("[DEFAULT-Employee]","[S1]");
        groupCodes.put("[DEFAULT-Crew]","[S2]");
        groupCodes.put("[DEFAULT-Owner_Operator]","[S3]");
        groupCodes.put("[DEFAULT-Suppliers_Vendors]","[S4]");
        groupCodes.put("[DEFAULT-McOpCo_Restaurant_Manager]","[S5]");
        groupCodes.put("[DEFAULT-Franchisee_Restaurant_Manager]","[S6]");
        //add two new groups, Judy, 09/05/2012
        groupCodes.put("[default-agency]","[S7]");
        groupCodes.put("[default-franchisee_office_staff]","[S8]");
        
    }
  
    public static String searchGroup(String metaGroups){
    
        if ((metaGroups == null) || metaGroups.equals("")) {
            metaGroups = "[No Groups Listed]";
        }
        else{
 
            //replace all groups with coded values
            Iterator iterKeys=groupCodes.keySet().iterator();
            while(iterKeys.hasNext()){
                String key=(String)iterKeys.next();
                String code=(String)groupCodes.get(key);
                metaGroups=metaGroups.replace(key,code);
            }   
            
            // groups without codes remain unchanged
            // remove special characters (dash, space, underscore)
            // from other groups which cause field indexing problems in Ultraseek
             
            metaGroups=metaGroups.replace("-","");
            metaGroups=metaGroups.replace("_","");
            metaGroups=metaGroups.replace(" ","");            
        }   
    
        return(metaGroups);
    } 

}   