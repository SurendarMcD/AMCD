/*
 * Project: Nutrition Arabia
 *
 * @(#)FormConstants.java
 * Revisions:
 * Date            Programmer           Description
 * ------------------------------------------------------------------------------------
 * 26,July 2011    HCL                  This class contains the global constant 
 *                                      variables used in the form component.
 * ------------------------------------------------------------------------------------
 * Description:
 * This software is the confidential and proprietary information of
 * McDonald's Corp. ("Confidential Information").
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with McDonald's.
 *
 * Copyright (c) 2011 McDonald's Corp.
 * All Rights Reserved.
 * www.mcdonaldsarabia.com
 */
package com.mcd.gmt.product.constant;
/**
 * @author HCL
 * @version 1.0
 * @since 1.0
 */
public class ProductConstant 
{
    // Common variables
    public static final String BLANK = "";
    public static final String DATA_SOURCE_NAME = "datasource_name";
    public static final String CONTENT = "/content/";
    public static final String SLASH = "/";
    public static final String UNDERSCORE = "_";
    public static final String HYPHEN = "-";
    public static final String QUESTION_MARK = "?";
    public static final String EQUAL = "=";
    public static final String JCR_CONTENT = "jcr:content";
    public static final String RETURN_STATUS = "returnStatus";
    public static final String EXT_HTML = ".html";
    
    // Status Constants
    public static final String EXCEPTION = "0";
    public static final String ADDED_ACTIVATED = "1";
    public static final String ADDED_SAVED_AS_DRAFT = "2"; 
    public static final String UPDATED_ACTIVATED = "3";
    public static final String UPDATED_SAVED_AS_DRAFT = "4";
    public static final String UPDATED_ACTIVATED_ARCHIEVED = "5"; 
    public static final String UPDATED_SAVED_AS_DRAFT_ARCHIVED = "6";
    public static final String UPDATED_SAVED_AS_DRAFT_ACTIVATED = "7";
    
    //public static final String EXCEPTION = "1";
   // public static final String EXCEPTION = "0";
    public static final String ALREADY_EXISTS = "2";
    public static final String MANDATORY_FIELDS_NOT_FILLED = "3";
  

    public static final String SELECTOR_PRODUCTFORM = "productForm";  
    
    // ------------- Application Constants ---------//
    
    //public static final String NUTRITION_INFO_ATOM_NAME = "nutrition_info_xml";
    //public static final String BUILD_INFO_ATOM_NAME = "build_info_xml";
    public static final String MENU_ITEM_ID_ATOM_NAME = "menu_item_id";
    public static final String ACTIVATION_DATE_ATOM_NAME = "activation_date";
    public static final String TEMPLATE_PATH="mcd/templates/wwkb_product";
    //public static final String csdName="main";
    //public static final String pageHandle="/content/mcdonalds/wwmm/gmt_test_hcl/cheese";
    //public static final String ROOT_PAGE_HANDLE = "/content/mcdonalds/wwmm/gmt_test_hcl/cheese";
    //public static final String pageHandle="/content/mcdonalds/wwmm/products/";
    //public static final String ROOT_PAGE_HANDLE = "/content/mcdonalds/wwmm/products";
    public static final String pageHandle="/content/mcdonalds/homeoffice/menu/wwmm/products/";
    //public static final String rootpath = "/content/mcdonalds/homeoffice/menu/wwmm/products";
    public static final String rootpath = "rootpath";
    public static final String GMS_SCHEDULEDJOB = "GMSScheduledJob"; 
    
    //public static final String PUBLISH_URL="http://intlmcwebpub.int.accessmcd.com";
    public static final String PUBLISH_URL="https://houspub.int.accessmcd.com";
     
     
    public static final String ACTION_ADD="ADD";
    public static final String ACTION_EDIT="EDIT";
    public static final String ACTION_ERROR="ERROR";
    public static final String BUTTONSTRING_SUBMIT="SUBMIT";
    public static final String BUTTONSTRING_SAVEASDRAFT="SAVE AS DRAFT";

    public static final String FORM_ACTIONTYPE="actionType";
    
    public static final String ACTION_FORM_ADD="ADD_SUBMIT";
    public static final String ACTION_FORM_UPDATE="UPDATE_SUBMIT";
    public static final String ACTION_FORM_SAVE_AS_DRAFT="SAVE_AS_DRAFT";
    public static final String ACTION_FORM_UPDATE_SAVE_AS_DRAFT="UPDATE_SAVE_AS_DRAFT";
    public static final String ACTION_FORM_CANCEL="CANCEL"; 
    
    //ADDED BY HEMANT
    public static final String ACTION_FORM_ADD_CANCEL="CANCEL_ADD";
    public static final String ACTION_FORM_EDIT_CANCEL="CANCEL_EDIT";
    
    
    
    public static final String ROOT_PATH="rootpage";
    public static final String EDIT_PAGE_PATH = "editPagePath";
    public static final String PAGE_ACTIVATE="Published";
    public static final String PAGE_SAVEASDRAFT="Draft";
    public static final String PAGE_ARCHIVED="Archived";
    public static final String REPLICATION_TYPE_ACTIVATE="ActivatePage";
    public static final String NUTRITION_INFO_XSLT_PATH="/apps/starter_kit/docroot/wwmm/xslt/nutritionInfo.xslt";
    public static final String BUILD_INFO_XSLT_PATH="/apps/starter_kit/docroot/wwmm/xslt/buildinfo.xslt";
    public static final String GMS_TAGGING_PATH="CORP:gms/"; //added - 18-11-2011 GMS Tagging Path

    
    // ---------- Atoms Constants ---------------//
    public static final String ATOM_TEMPLATE="Template";
    public static final String Atom_MERLINInPMP  ="MERLINInPMP";
    public static final String Atom_MERLINInMenuItemSpecs ="MERLINInMenuItemSpecs";
    public static final String Atom_MERLINMenuItemID = "MERLINMenuItemID";
    public static final String Atom_MERLINProductSpecsEntered ="MERLINProductSpecsEntered";
    public static final String Atom_MERLINProductBuildXML = "MERLINProductBuildXML";
    public static final String Atom_MERLINNutritionInfoXML = "MERLINNutritionInfoXML";
    public static final String Atom_MERLINProductBuildXSLT = "MERLINProductBuildXSLT";
    public static final String Atom_MERLINNutritionInfoXSLT = "MERLINNutritionInfoXSLT";
    public static final String Atom_TitleText = "jcr:title";
    public static final String Atom_ProductDesc = "jcr:description";
    public static final String Atom_WWKBLaunchDate = "WWKBLaunchDate";
    public static final String Atom_WWKBDateOffMenu="WWKBDateOffMenu";
    public static final String Atom_WWKBZone="WWKBZone";
    public static final String Atom_WWKBCountry="WWKBCountry";
    public static final String Atom_WWKBMenuItemPrice="WWKBMenuItemPrice";
    public static final String Atom_WWKBMenuPriceChsBrg="WWKBMenuPriceChsBrg";
    public static final String Atom_WWKBMenuPriceBigMac="WWKBMenuPriceBigMac";
    public static final String Atom_WWKBSalesInfo="WWKBSalesInfo";
    public static final String Atom_WWKBProductDaypart="WWKBProductDaypart";
    public static final String Atom_WWKBTargetAudience="WWKBTargetAudience";
    public static final String Atom_WWKBProductType="WWKBProductType";
    public static final String Atom_WWKBMenuCategory="WWKBMenuCategory";
    public static final String Atom_WWKBConsumerObjective="WWKBConsumerObjective";
    public static final String Atom_WWKBBusinessObjective="WWKBBusinessObjective";
    public static final String Atom_WWKBKeyLearnings="WWKBKeyLearnings";
    public static final String Atom_Keywords="cq:tags";
    public static final String Atom_WWKBVersionsVariations="WWKBVersionsVariations";
    public static final String Atom_Author="authorName";
    public static final String Atom_ContactEmail="authorEmail";
    public static final String Atom_WWKBAdditionalComments="WWKBAdditionalComments";
    public static final String Atom_WWKBProductPhoto="productimage";
    public static final String Atom_WWKBMenuCategoryTxt="WWKBMenuCategoryOtherTxt";
    public static final String Atom_WWKBDateOffMenuOpt="WWKBIsDateOffMenu";
    public static final String Atom_WWKBCurrencyLabel="WWKBCurrencyLabel";
    public static final String Atom_WWKBArchievedFlag="WWKBArchievedFlag";
    public static final String Atom_WWKBTargetConsumerTxt="WWKBTargetConsumerOtherTxt"; 
    public static final String Atom_AudienceType="AudienceType";
    public static final String Atom_WWKBMenuItemRole="WWKBMenuItemRole";
    public static final String Atom_CurrencyVal = "Atom_CurrencyVal";
    
    //-------------- Product FORM contants --------------//
    
    public static final String FORM_PRODUCT_NAME="TR_Product_Name"; 
    public static final String FORM_PRODUCT_DESCRIPTION="TR_Product_Description";
    public static final String FORM_LAUNCH_DATE="TR_Launch_Date";
    //public static final String FORM_DATE_OFF_MENU_OPTION="Date_off_Menu";
    public static final String FORM_DATE_OFF_MENU_OPTION="TR_Product_still_on_menu?";
    //public static final String FORM_DATE_OFF_MENU_DATE="datepicker";
    public static final String FORM_DATE_OFF_MENU_DATE="TR_Date_Off_Menu";
    public static final String FORM_AREA_OF_WORLD="TR_Area_of_the_World";
    public static final String FORM_COUNTRY_NAME="TR_Country";
    public static final String FORM_MENU_ITEM_PRICE="TR_Menu_Item_Price";
    public static final String FORM_MENU_ITEM_PRICE_BIGMAC="TR_Menu_Price_of_a_Big_Mac";
    public static final String FORM_MENU_ITEM_PRICE_CHEESEBURGER="TR_Menu_Price_of_a_Cheeseburger";
    public static final String FORM_SALES_INFORMATION="TR_Sales_Information";
    public static final String FORM_PRODUCT_DAYPART="CHR_Product_Daypart";
    public static final String FORM_TARGET_CONSUMERS="CHR_Target_Consumer";
    public static final String FORM_MENU_ITEM_CATEGORY="CHR_Menu_Item_Category";
    public static final String FORM_OTHER_MENU_CATEGORY_TXT="TR_Other_Menu_Item_Category";
    public static final String FORM_MENU_ITEM_ROLE="CHR_Menu_Item_Role";
    public static final String FORM_CONSUMER_OBJECTIVE="Consumer_Objective";
    public static final String FORM_BUSINESS_OBJECTIVE="TR_Business_Objective";
    public static final String FORM_KEY_LEARNINGS="Key_Learnings";
    public static final String FORM_KEYWORDS="TR_Keywords";
    public static final String FORM_MULTILE_VERSIONS="Multiple_Versions_/ Variations";
    public static final String FORM_CONTACT_NAME="TR_Contact_Name"; 
    public static final String FORM_CONTACT_EMAIL="TR_Contact_Email"; 
    public static final String FORM_ADDITINAL_COMMENTS="Additional_Comments_and_Considerations"; 
    //public static final String FORM_PRODUCT_PHOTO="TR_Product_Photo";
    public static final String FORM_PRODUCT_PHOTO="TR_Product_Photo"; //updated to remove TR_ - for Required Fields
    public static final String FORM_ENTERED_IN_PMP="TR_Entered_in_PMP?";
    public static final String FORM_MENU_ITEM_SPEC="TR_Entered_in_Menu_Item_Specs?";
    public static final String FORM_MENU_ITEM_ID="TR_Menu_Item_ID";
    public static final String FORM_PRODUCT_SPEC="TR_Product_Specs_Entered?";
    public static final String FORM_ARCHIEVED_TYPE="Archieve_Item";
    public static final String FORM_ARCHIEVED_TYPE_DEFAULTVAL="no";
    public static final String FORM_ARCHIEVED_TYPE_CHECKEDVAL="yes";
    public static final String FORM_TARGET_CONSUMER_TXT="TR_Other_Target_Consumer";
    public static final String FORM_MERLINNutritionXML = "MERLINNutritionInfoXML";
    public static final String FORM_MERLINNutritionInfoXSLT = "MERLINNutritionInfoXSLT";
    public static final String FORM_MERLINBuildXML = "MERLINBuildXML";
    public static final String FORM_MERLINBuildInfoXSLT = "MERLINBuildInfoXSLT";
    public static final String FORM_CURRENCYVAL = "currencyVal";
    
}