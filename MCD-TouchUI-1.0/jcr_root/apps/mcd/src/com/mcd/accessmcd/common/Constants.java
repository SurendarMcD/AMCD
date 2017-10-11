package com.mcd.accessmcd.common;

import com.mcd.accessmcd.common.helper.PropertyHelper;

/**
 * This class acts as an interface for accessing constant values 
 * from the properties file.It uses PropertyHelper to access the values.
 *
 * @author Shubhra
 * @version 1.0
 *
 */
public class Constants {

    // AccessMCD Properties file name
    final public static String GLOBAL_PROPERTIES_FILE = "common.properties"; 
   // Properties prop = PropertiesLoader.loadProperties(GLOBAL_PROPERTIES_FILE);
    
    // Entity name constants
    final public static String ENTITY_NAME_GLOBAL = PropertyHelper.getPropValue(GLOBAL_PROPERTIES_FILE,"Global_Name");
    final public static String ENTITY_NAME_UNITEDSTATES = PropertyHelper.getPropValue(GLOBAL_PROPERTIES_FILE,"US_Name");
    final public static String ENTITY_NAME_AUSTRALIA = PropertyHelper.getPropValue(GLOBAL_PROPERTIES_FILE,"Australia_Name");
    final public static String ENTITY_NAME_AUSTRAILIA = PropertyHelper.getPropValue(GLOBAL_PROPERTIES_FILE,"Australia_Name");
    final public static String ENTITY_NAME_JAPAN = PropertyHelper.getPropValue(GLOBAL_PROPERTIES_FILE,"Japan_Name");
    final public static String ENTITY_NAME_NEWZEALAND = PropertyHelper.getPropValue(GLOBAL_PROPERTIES_FILE,"NewZealand_Name");
        
    // Default Entity name constants
    final public static String DEFAULT_ENTITY_NAME = ENTITY_NAME_GLOBAL;
    
    // Entity handle constants
    final public static String ENTITY_HANDLE_GLOBAL = PropertyHelper.getPropValue(GLOBAL_PROPERTIES_FILE,"Global_Handle");
    final public static String ENTITY_HANDLE_UNITEDSTATES = PropertyHelper.getPropValue(GLOBAL_PROPERTIES_FILE,"US_Handle");
    final public static String ENTITY_HANDLE_AUSTRALIA = PropertyHelper.getPropValue(GLOBAL_PROPERTIES_FILE,"Australia_Handle");    
    final public static String ENTITY_HANDLE_JAPAN = PropertyHelper.getPropValue(GLOBAL_PROPERTIES_FILE,"Japan_Handle");
    final public static String ENTITY_HANDLE_NEWZEALAND = PropertyHelper.getPropValue(GLOBAL_PROPERTIES_FILE,"NewZealand_Handle");
    final public static String ENTITY_HANDLE_ETOOLKIT = PropertyHelper.getPropValue(GLOBAL_PROPERTIES_FILE,"Etoolkit_Handle");
    final public static String ENTITY_HANDLE_ERROR = PropertyHelper.getPropValue(GLOBAL_PROPERTIES_FILE,"Error_Handle");
    
    // Audience Type constants
    final public static String[] AUDIENCE_TYPE_LIST = {"CorpEmployees","McOpCoRestMgrs","Franchisees"
                                ,"FranchiseeRestMgrs","Crew","SupplierVendor","SupportPartners","Agency","FranchiseeOfficeStaff"};    

    // Session Attribute name for entity
    final public static String ENTITY_SESSION_ATTRIBUTE = "ENTITY_ATTRIBUTE";
    
    
}