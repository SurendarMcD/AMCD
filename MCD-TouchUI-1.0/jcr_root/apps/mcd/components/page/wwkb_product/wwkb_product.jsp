<%@ include file="/apps/mcd/global/global.jsp" %><%
%><%@ page import="java.util.StringTokenizer" %><% 
%><%@ page import="java.text.DecimalFormat" %><%
%><%@ page import="java.text.DateFormat, java.text.SimpleDateFormat, java.util.Date, java.util.Calendar" %><%
%><%@ page import="com.day.image.Layer" %><%
%><%@ page import="com.day.cq.util.*" %><%
%><%@ page import="java.util.*" %><%
%><%@ page import="com.day.cq.util.streams.*" %><%
%><%@ page import="java.io.*" %><%  
%><%@ page import="com.mcd.gmt.product.constant.ProductConstant,com.mcd.gmt.product.manager.ProductManager,com.mcd.gmt.cq.*" %><%
%><%@ page import="com.mcd.gmt.product.bo.ProductDetail "%><%
%><%@ page import="org.slf4j.Logger, org.slf4j.LoggerFactory.*,com.day.cq.wcm.foundation.Image, com.day.cq.wcm.api.components.DropTarget" %><%
%>
  
<html>
<head>
<script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script> 
</head>
<body>
 


<%!

public String checkEmpty(String str){   
       if(str==null)
        str = "";
       return str;  
    }


public String getFormattedDate(String dateString, String dateFormat){

    Date formattedDate = null;
    try {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(dateFormat);
        formattedDate = (Date) simpleDateFormat.parse(dateString);
        simpleDateFormat.applyPattern("MMMM d, yyyy");
        return simpleDateFormat.format(formattedDate);
    } 
    catch (Exception e) {
        //log.error("Exception in getFormattedDate(String dateString, String dateFormat): " + e);
        e.printStackTrace();
        return "";
    }
        
}

public int getLengthOfTimeonMenu(String launchDate, String offMenuDate, String dateFormat){
        
        
        int lengthOfTimeOnMenuInDays;
        int lengthOfTimeOnMenuInMonths;
        int lengthOfTimeOnMenuInYears;
        
        SimpleDateFormat df = new SimpleDateFormat(dateFormat);
        Date firstDate  = null;
        Date lastDate  = null;
        try  {
            firstDate = df.parse(launchDate); 
            lastDate = df.parse(offMenuDate); 
        }
        catch (Exception pe)
        {
            pe.printStackTrace();
        }
            Calendar cal1 = Calendar.getInstance(); 
            Calendar cal2 = Calendar.getInstance(); 
        
            cal1.setTime(firstDate);          
            long firstDateInMilliseconds = firstDate.getTime();
        
            cal2.setTime(lastDate);
            long secondDateInMilliseconds = lastDate.getTime();
        
             // Use integer calculation, truncate the decimals
            int firstDateInHours   = (int)(firstDateInMilliseconds/3600000); //60*60*1000
            int lastDateinHours   = (int)(secondDateInMilliseconds/3600000);

            int days1 = (int)firstDateInHours/24;
            int days2 = (int)lastDateinHours/24;
            lengthOfTimeOnMenuInDays  = days2 - days1;
        
            lengthOfTimeOnMenuInYears = cal2.get(Calendar.YEAR) - cal1.get(Calendar.YEAR); 
            lengthOfTimeOnMenuInMonths = lengthOfTimeOnMenuInYears * 12 + cal2.get(Calendar.MONTH) - cal1.get(Calendar.MONTH);
        
        //log.error("The Length of Time on Menu in Days is : " + lengthOfTimeOnMenuInDays);
        
        if(lengthOfTimeOnMenuInDays < 0){ // When the Off Menu Date is earlier than Launch Date
            return -1;
        }
        
        if((lengthOfTimeOnMenuInDays % 30) > 15 ){ // if Launch Date is same or earlier than Off Menu Date
            //log.error("*****************" + lengthOfTimeOnMenuInDays);
            lengthOfTimeOnMenuInMonths = lengthOfTimeOnMenuInMonths + 1;
            }
            return lengthOfTimeOnMenuInMonths;

    }


 
%>

<cq:include script="/apps/mcd/global/init.jsp"/> 
    <div id="left-widgets-column">
        <%-- Draws parsys for Left Section --%>
        <cq:include path="leftcontentpara" resourceType="foundation/components/iparsys" />
    </div>

<%currentDesign.writeCssIncludes(pageContext);%>  
 
<% 
String EmptyString= ""; 
String dateFormat="dd/MM/yyyy";
String productName = properties.get(ProductConstant.Atom_TitleText,EmptyString); 
productName =new String(productName.getBytes("8859_1"),"UTF-8"); 
String[] menuItemCategory= properties.get(ProductConstant.Atom_WWKBMenuCategory,String[].class);
for(int i=0;i<menuItemCategory.length;i++){
menuItemCategory[i]=new String(menuItemCategory[i].getBytes("8859_1"),"UTF-8"); 
}
String[] menuItemRole = properties.get(ProductConstant.Atom_WWKBMenuItemRole,String[].class);
String[] targetConsumer = properties.get(ProductConstant.Atom_WWKBTargetAudience,String[].class);
String[] dayPart =properties.get(ProductConstant.Atom_WWKBProductDaypart,String[].class);
String areaOfWorld =properties.get(ProductConstant.Atom_WWKBZone,EmptyString);
String countryName = properties.get(ProductConstant.Atom_WWKBCountry,EmptyString);
String currencyvalue=properties.get(ProductConstant.Atom_CurrencyVal,EmptyString); 
String menuItemCategoryOtherTxt= properties.get(ProductConstant.Atom_WWKBMenuCategoryTxt,"");
String targetConsumerOtherTxt= properties.get(ProductConstant.Atom_WWKBTargetConsumerTxt,"");

 
//Product Description
String productDescription =properties.get(ProductConstant.Atom_ProductDesc,EmptyString); 

// Item menu price
String currencyLebleVal="";
String itemMenuPrice= properties.get(ProductConstant.Atom_WWKBMenuItemPrice,"")+currencyLebleVal; 


//Product Launch Date
String launchDate = properties.get(ProductConstant.Atom_WWKBLaunchDate,"");
String formattedLaunchDate = "";  


if(!launchDate.equals("")){
formattedLaunchDate = getFormattedDate(launchDate,dateFormat); 
}

//Calculate Length off Time on Menu
String lengthofTime =properties.get(ProductConstant.Atom_WWKBDateOffMenu,"");
int lengthOfTimeOnMenu;
String offMenuDateOpt =properties.get(ProductConstant.Atom_WWKBDateOffMenuOpt,"");

if(offMenuDateOpt.equals("no")) {
    if(!lengthofTime.equals("")){
    lengthofTime = getFormattedDate(lengthofTime,dateFormat); 
    }
}


String menuprice = properties.get(ProductConstant.Atom_WWKBMenuItemPrice,"");
String menupriceBigMac = properties.get(ProductConstant.Atom_WWKBMenuPriceBigMac,"");
String menupriceCheeseBurger =properties.get(ProductConstant.Atom_WWKBMenuPriceChsBrg,"");



if(currencyLebleVal.equalsIgnoreCase("EUR")){
    

/*  Steps to process menu item price and relative prices for EURO currency
    1. Retain the index of the comma symbol
    2. Replace all the decimal points with the comma symbol
    3. Replace the comma at index retained in step#1 by a decimal symbol
*/
    menuprice = menuprice.replace(".","");
    menuprice = menuprice.replace(",",".");
    log.error("The menuprice after all processing inside if is: ************************: " + menuprice);
    
    menupriceBigMac = menupriceBigMac.replace(".","");
    menupriceBigMac = menupriceBigMac.replace(",",".");
    log.error("The menupriceBigMac after all processing inside if is: ************************: " + menupriceBigMac);
    
    menupriceCheeseBurger = menupriceCheeseBurger.replace(".","");
    menupriceCheeseBurger = menupriceCheeseBurger.replace(",",".");
    log.error("The menupriceCheeseBurger after all processing inside if is: ************************: " + menupriceCheeseBurger);
    
 } 
/*
    Steps to apply for all the currency formats:
    3. Remove all the comma symbols to form the final value string

*/
    log.error("menuprice before replace ************************: " + menuprice);
    menuprice = menuprice.replace(",","");
    log.error("menuprice after replace ************************: " + menuprice);

    menupriceBigMac = menupriceBigMac.replace(",","");
    log.error("menupriceBigMac after replace ************************: " + menupriceBigMac);

    menupriceCheeseBurger = menupriceCheeseBurger.replace(",","");
    log.error("menupriceCheeseBurger after replace ************************: " + menupriceCheeseBurger);
    

 
double menuPrice;
double menuPriceBigMac;
double menuPriceCheeseBurger;
double priceRelativeToBicMac;
double priceRelativeToCheese;

String menuPriceRELBigmac = "";
String menuPriceRELCheeseBurger = "";

if( !(menuprice.equals("") || menupriceBigMac.equals("") || menupriceCheeseBurger.equals("")) ) {
    menuPrice = Double.parseDouble(menuprice);

    menuPriceBigMac = Double.parseDouble(menupriceBigMac);

    menuPriceCheeseBurger = Double.parseDouble(menupriceCheeseBurger);

    priceRelativeToBicMac = ((menuPrice-menuPriceBigMac)/menuPrice) * 100;
    priceRelativeToCheese = ((menuPrice-menuPriceCheeseBurger)/menuPrice) * 100;
    
    
    DecimalFormat priceFormatter = new DecimalFormat();
    priceFormatter.setMaximumFractionDigits(2);
    if(priceRelativeToBicMac > 0) {
        
        menuPriceRELBigmac = priceFormatter.format(priceRelativeToBicMac) + " % more";
    } else {
        menuPriceRELBigmac = "" + priceFormatter.format(priceRelativeToBicMac).replace("-","") + " % less";
    }

    if(priceRelativeToCheese > 0) {
        
        menuPriceRELCheeseBurger = priceFormatter.format(priceRelativeToCheese) + " % more";
    } else {
        menuPriceRELCheeseBurger = "" + priceFormatter.format(priceRelativeToCheese).replace("-","") + " % less";
    }

} 

 

String contactName = properties.get(ProductConstant.Atom_Author,EmptyString);
String contactEmail = properties.get(ProductConstant.Atom_ContactEmail,EmptyString);
String consumerObjective = properties.get(ProductConstant.Atom_WWKBConsumerObjective,EmptyString);
String bussinessObjective = properties.get(ProductConstant.Atom_WWKBBusinessObjective,EmptyString);
String salesInformation =properties.get(ProductConstant.Atom_WWKBSalesInfo,EmptyString);
String keyLearning = properties.get(ProductConstant.Atom_WWKBKeyLearnings,EmptyString);
String additonalComments = properties.get(ProductConstant.Atom_WWKBAdditionalComments,EmptyString);
String multipleVersions = properties.get(ProductConstant. Atom_WWKBVersionsVariations,EmptyString);
String productBuildInfo = properties.get(ProductConstant.Atom_MERLINProductBuildXSLT,EmptyString);
productBuildInfo=new String(productBuildInfo.getBytes("8859_1"),"UTF-8");
String nutritionBuildInfo=properties.get(ProductConstant.Atom_MERLINNutritionInfoXSLT,EmptyString); 
nutritionBuildInfo=new String(nutritionBuildInfo.getBytes("8859_1"),"UTF-8");
String ddClassName = DropTarget.CSS_CLASS_PREFIX + "image";

Image image = new Image(resource, "productimage"); 

 

/* 
    Steps to display the Product Photo
    1. Get the Atom of Product Photo - pageObject.getAtom()
    2. Get the java.io.InputStream Stream of the Atom
    3. Spool the Image on the Page

*/

String ext = "jpg";
 

%>
<div id="content_txt" style="float:right; width:76%; padding: 0 0 0 30px;">
<table class="wwkb" style="" width="95%" cellspacing="0" cellpadding="0" border="0" >
   
   <tr valign="top">
        <td><img src="/0.gif" border="0" width="1" height="10" /></td>
    </tr>

    <tr valign="top"> <td><img src="/0.gif" border="0" width="1" height="10" /></td>
        <td>
            <table width=100% bgcolor=FFFFFF>
            <tr width=100%>
                <td><IMG HEIGHT=1 WIDTH=1 SRC="/0.gif"></td>
            </tr>
         </table>    
        
        <!-- Begin Edit Row table -->
        <table width="95%" cellspacing="0" cellpadding="0" border="0"> 
  
            <tr width="95%">
                <td valign="top" width="93%"></td>
                </tr>
                <tr width="100%">
                <td valign="top" width="100%"></td>
            </tr>
            </tr>

        </table>

        <!-- End edit row table --> <!--BEGIN OUTSIDE TABLE-->
        <table width="94.5%" cellspacing="0" cellpadding="0" border="0">
            <tr>
                <td><!-- Begin New Column Table -->
                <table width="95%" cellspacing="0" cellpadding="0" border="0">
                    <tr width="95%">

                        <!-- Begin New Column Row -->
                        <td width="95%" valign="top" colspan="2"></td>
                    </tr>
                    <!-- End New Column Row -->
                    <tr width="95%">



                        <td width="100%" valign="top">

                        <table width="94%" border="0" bgcolor="FFFFFF"
                            bordercolor="#FFFFFF" cellpadding="0" cellspacing="0">
                            <td>
                            <table width="94%" cellpadding="0" cellspacing"0" border="0">
                                <tr>
                                    <td colspan="2" align="" class="siteTitle"><%= productName%></td>
                                </tr>
                                <tr>
                                    <td height="7"></td>
                                </tr>
                                <td colspan="2" class="text" align="top"><font color=""></font>
                                </td>
                            </table>
                            </td>
                            </tr>
                        </table>
                    <table border="0" width="100%" cellspacing="0" cellpadding="0" bordercolor=" #000000">
                            <tr>
                                <td>
                                <table width="94%" border="1" bordercolor=" #000000"
                                    cellpadding="0" cellspacing="0">

                                    <tr>

                                        <th class="tableText" 
                                            width="14%" height="16" align="left" valign="middle"
                                            rowspan="1" colspan="1"><b>Menu Item Name</b></th>

                                        <th class="tableText" 
                                            width="14%" height="16" align="left" valign="middle"
                                            rowspan="1" colspan="1"><b>Daypart</b></th>

                                        <th class="tableText" 
                                            width="14%" height="16" align="left" valign="middle"
                                            rowspan="1" colspan="1"><b>Target Consumer</b></th>

                                        <th class="tableText"
                                            width="14%" height="16" align="left" valign="middle"
                                            rowspan="1" colspan="1"><b>Menu Item Category</b></th>

                                        <th class="tableText" 
                                            width="14%" height="16" align="left" valign="middle"
                                            rowspan="1" colspan="1"><b>Menu Item Role</b></th>

                                        <th class="tableText"  
                                            width="14%" height="16" align="left" valign="middle"
                                            rowspan="1" colspan="1"><b>AOW</b></th>

                                        <th class="tableText" 
                                            width="14%" height="16" align="left" valign="middle"
                                            rowspan="1" colspan="1"><b>Country</b></th>

                                    </tr>
   
                                    <tr>

                                        <td class="tableText" style="" width="14%" height="32"
                                            align="" valign="top" rowspan="1" colspan="1"><%= productName %><div></div></td>

                                        <td class="tableText" style="" width="14%" height="32"
                                            align="" valign="top" rowspan="1" colspan="1"><div></div>
                                                <% if(null !=dayPart){
                                                        for(int i=0;i<dayPart.length;i++) {
                                                        out.println(dayPart[i]);
                                                        out.println("<br>");
                                                        } 
                                                    }%>     
                                                </td> 


                                        <td class="tableText" style="" width="14%" height="32"
                                            align="" valign="top" rowspan="1" colspan="1"><div></div>
                                            <% if(null !=targetConsumer ){
                                                        for (int i=0;i<targetConsumer.length;i++) {
                                                            if("other".equals(targetConsumer[i])) { 
                                                                out.println("Other: " + targetConsumerOtherTxt);     
                                                            } else {   
                                                                out.println(targetConsumer[i]); 
                                                            }
                                                        out.println("<br>");
                                                        
                                                        } 
                                                    }
                                                    %>
                                            </td>

                                        <td class="tableText" style="" width="14%" height="32"
                                            align="" valign="top" rowspan="1" colspan="1"><div></div>
                                               <% if(null !=menuItemCategory){
                                                        for (int i=0;i<menuItemCategory.length;i++) {
                                                            if(menuItemCategory[i].equals("other")) {
                                                                    if(null !=menuItemCategoryOtherTxt){
                                                                        out.println("Other: " + menuItemCategoryOtherTxt);
                                                                    } 
                                                                }
                                                               else {
                                                            out.println(menuItemCategory[i]);
                                                        
                                                            }
                                                            out.println("<br>");
                                                        }
                                                    }
                                                    %>

                                            </td>

                                        <td class="tableText" style="" width="14%" height="32"
                                            align="" valign="top" rowspan="1" colspan="1"><div></div>
                                                   <% if(null !=menuItemRole){
                                                        for (int j=0;j<menuItemRole.length;j++) {
                                                        out.println(menuItemRole[j]);
                                                        out.println("<br>");
                                                        }
                                                     } %>

                                            </td> 

                                        <td class="tableText" style="" width="14%" height="32"
                                            align="" valign="top" rowspan="1" colspan="1">&nbsp;<%=areaOfWorld %></td>

                                        <td class="tableText" style="" width="14%" height="32"
                                            align="" valign="top" rowspan="1" colspan="1">&nbsp;<%=countryName %></td>

                                    </tr>
                                </table>
                                </td>
                            </tr>
                           <tr>
                                <td colspan="2" height="8">
                                   </td>
                            </tr>
                        </table>
                        </td>

                    </tr>
                </table>
                <table width=100% bgcolor=FFFFFF>
                    <tr width=100%>
                        <td><IMG HEIGHT=1 WIDTH=1 SRC="/0.gif"></td>
                    </tr>
                </table>
                <!-- Begin Edit Row table -->
                <table width="100%" cellspacing="0" cellpadding="0" border="0">
                    <tr width="100%">
                        <td width="100%"></td>
                    </tr>

                    <tr width="100%">
                        <td valign="top" width="100%"></td>
                    </tr>

                </table>

                <!-- End edit row table --> 
 
                <!--BEGIN OUTSIDE TABLE-->
                <table width="100%" cellspacing="0" cellpadding="0" border="0">
                    <tr>
                        <td><!-- Begin New Column Table -->
                        <table width="100%" cellspacing="0" cellpadding="0" border="0">
                            <tr width="100%">

                                <!-- Begin New Column Row -->
                                <td width="100%" valign="top" colspan="6"></td>
                            </tr>
                            <!-- End New Column Row -->
                            <tr width="100%">



                                <td width="30.0%"  max-width="320px" valign="top">

                                <table width=100% bgcolor=FFFFFF>
                                    <tr width=100%>
                                        <td><IMG HEIGHT=1 WIDTH=1 SRC="/0.gif"></td>
                                    </tr>
                                </table>



                                <table width="100%" border="0" bgcolor="FFFFFF"
                                    bordercolor="#FFFFFF" cellpadding="0" cellspacing="0">



                                    <td> 

                                    <table width="100%" cellpadding="0" cellspacing"0" border="0">

                                                          
                                        <tr>
                                            <td width="250.0" valign="top"  class="text"> 
                                               <div>       
                                                    <%                                          
                                                            if(image.hasContent()){
                                                    %>          
                                                            <%   
                                                    
                                                                        /**********************************Rendering Image*********************************/                 
                                                                        image.setSelector(".img"); // use image script
                                                                        image.addCssClass(ddClassName);
                                                                        //image.addCssClass("img");
                                                                        image.loadStyleData(currentStyle);
                                                                        
                                                                        image.setAlt(image.getHref()); 
                                                                        %>                             
                                                                        <%
                                                                        if (!currentDesign.equals(resourceDesign)) {
                                                                        image.setSuffix(currentDesign.getId());
                                                                        }  
                                                                        image.draw(out);
                                                                        
                                                                        /******************************End Image*********************************/
                                        
                                                             %>                                                
                                                            <%                                          
                                                            }
                                                            %>                                         
                                              </div>
                                            <div class="text" align="">
                                            </td>
                                            <td class="text" valign="top" align="top"><font color=""></font></td>
                                        </tr>




                                    </table>
                                    </td>
                                    </tr>
                                </table>
                            </td>
  
                                <td width="40.0%" valign="top">

                                <table width=100% bgcolor=FFFFFF>
                                    <tr width=100%>
                                        <td><IMG HEIGHT=1 WIDTH=1 SRC="/0.gif"></td>
                                    </tr>
                                </table>
                                <table width="100%" border="0" bgcolor="FFFFFF"
                                    bordercolor="#FFFFFF" cellpadding="0" cellspacing="0">
                                <td>

                                    <table width="100%" cellpadding="0" cellspacing"0" border="0">


                                        <td colspan="2" class="text" align="top"><font color=""><b><u>Product
                                        Description</u>
                                        </b><br>
                                        <%= productDescription %>
                                        <br> 
                                        <br>
                                        <b><u>Date Launched</u></b><br>
                                        <%= formattedLaunchDate%><br>
                                        <br>
                                        <%if(!lengthofTime.equals("")){ %>
                                        <b><u>Date Removed from Menu</u></b><br>
                                        <%= lengthofTime %><br>
                                        <%} %>
                                        
                                        
                                        
                                        <br> 
                                        <b><u>Item Menu Price</u></b><br>
                                        <%=itemMenuPrice%>&nbsp;<%=currencyvalue%>&nbsp;<br>  

                                        
                                                                                    
                                        <br>
                                        <b><u>Menu Price Relative to Big Mac</u></b><br>
                                        
                                        <%=menuPriceRELBigmac %>&nbsp;<br>
                                        <br>
                                        <b><u>Menu Price Relative to Cheeseburger</u></b><br>
                                        <%=menuPriceRELCheeseBurger %>&nbsp;&nbsp;<br> 
                                        <br>
                                        </font></td>
                                    </table>
                                    </td>
                                    </tr> 
                                </table>

                                </td>
                                
                                <td width="30.0%" valign="top">
                                    <table width=100% bgcolor=FFFFFF>
                                    <tr width=100%>
                                        <td><IMG HEIGHT=1 WIDTH=1 SRC="/0.gif"></td>
                                    </tr>
                                </table>
 

                                <table width="100%" border="0" bgcolor="FFFFFF"
                                    bordercolor="#FFFFFF" cellpadding="0" cellspacing="0">
                                <td>

                                    <table width="100%" cellpadding="0" cellspacing"0" border="0">


                                        <td colspan="2" class="text" align="top"><font color=""><b><u>Key
                                        Contact</u></b><br>
                                    
                                        <%=contactName %><br>
                                        
                                        <a href="mailto:<%=contactEmail %> "><%= contactEmail %></a><br>
                                        <br>
                                        </td>

                                    </table>
                                    </td>
                                    </tr>
                                </table>

                                </td>

                            </tr>
                        </table>


                      
                        <table width="100%" cellspacing="0" cellpadding="0" border="0">
                            <tr>
                                <td><!-- Begin New Column Table -->
                                <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                    <tr width="100%">

                                        <!-- Begin New Column Row -->
                                        <td width="100%" valign="top" colspan="4">
                                        </td>
                                    </tr>
                                    <!-- End New Column Row -->
                                    <tr width="100%">
                                        <td width="auto" valign="top">
                                      
                                        <table width="100%" border="0" bgcolor="FFFFFF"
                                            bordercolor="#FFFFFF" cellpadding="0" cellspacing="0">
                                            <td>


                                            <table width="100%" cellpadding="0" cellspacing"0" border="0">
                                                <tr>
                                                     <td colspan="2" class="titleWithBlackBoldBorder"  >
                                                    <font color="#FFFFFF"> Product Build </font</td>
                                                </tr>
                                            
                                            </table>
                                        
                                            </td>
                                            </tr>
                                        </table>
                                        <table border="0" width="100%" cellspacing="0" cellpadding="0" >



    <tr width="100%">
        <td>    
        
        <% if(!productBuildInfo.equals("")) { %>
        
        <%=productBuildInfo %>
        
    
        <% } else {  %>
         
        
        <table width="100%" border="1"  bordercolor="#000000" cellpadding="0" cellspacing="0">
    
            <tr>

                <th class="tableText" style="font-weight:bold;" width="36%" height="13"  align="left"  valign="middle" rowspan="1" colspan="1">Product / Menu Item</th>
                <th class="tableText" style="font-weight:bold;" width="12%" height="13"  align="left"  valign="middle" rowspan="1" colspan="1">Quantity</th>
                <th class="tableText" style="font-weight:bold;" width="25%" height="13"  align="left"  valign="middle" rowspan="1" colspan="1">Comments</th>
            
            </tr> 
        
            <tr>

                <td class="tableText" style="" width="36%" height="13" align="" valign="middle" rowspan="1" colspan="1"> &nbsp;</td>
                <td class="tableText" style="" width="12%" height="13" align="" valign="middle" rowspan="1" colspan="1">&nbsp;</td>
                <td class="tableText" style="" width="12%" height="13" align="" valign="middle" rowspan="1" colspan="1">&nbsp;</td>
                            
                            
            </tr>
    
        </table>
        <% }%>
    
    

        </td>
    </tr>

   <tr><td colspan="2" height="8"></td></tr> 
    
    
</table>


                                        <table width="100%" border="0" bgcolor="FFFFFF"
                                            bordercolor="#FFFFFF" cellpadding="0" cellspacing="0">



                                            <td>
                                        
                                            <table width="100%" cellpadding="0" cellspacing"0" border="0" >



                                                <tr>
                                                    <td colspan="2" color="#FFFFFF" class="titleWithBlackBoldBorder" >
                                                    <font color="#FFFFFF"> Nutrition Information </font></td>
                                                </tr>



                                                <td colspan="2" class="text" align="top"><font color=""></font></td>



                                            </table>
                                            </td>
                                            </tr>

                                        </table>
                                        
                                        
<% if(!nutritionBuildInfo.equals("")) { %>                                      

<%=nutritionBuildInfo %>

<% } else { %>

<table border="0" width="100%" cellspacing="0" cellpadding="0">


    <tr>
        <td>

        <table width="100%" border="1" bordercolor="#000000"
            cellpadding="0" cellspacing="0">

            <tr>

                <th class="tableText" 
                    style="font-weight: bold; " width="23%"
                    height="13" align="left" valign="middle" rowspan="1"
                    colspan="1">Nutrient</th>

                <th class="tableText" 
                    style="font-weight: bold;  width="15%"
                    height="13" align="left" valign="middle" rowspan="1"
                    colspan="1">Per 100g</th>

                <th class="tableText" 
                    style="font-weight: bold;  width="15%"
                    height="13" align="left" valign="middle" rowspan="1"
                    colspan="1">Comments</th>

            </tr>

            <tr>

                <td class="tableText" style="" width="23%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">Calories</td>

                <td class="tableText" style="" width="15%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">&nbsp;</td>

                <td class="tableText" style="" width="15%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">&nbsp;</td>

            </tr>
            
            
                <tr>

                <td class="tableText" style="" width="23%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">Total Fat</td>

                <td class="tableText" style="" width="15%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">&nbsp;</td>

                <td class="tableText" style="" width="15%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">&nbsp;</td>

            </tr>
            
                <tr>

                <td class="tableText" style="" width="23%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">Saturated Fat</td>

                <td class="tableText" style="" width="15%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">&nbsp; </td>

                <td class="tableText" style="" width="15%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">&nbsp;</td>

             </tr>
            
                <tr>

                <td class="tableText" style="" width="23%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">Trans Fat</td>

                <td class="tableText" style="" width="15%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">&nbsp;</td>

                <td class="tableText" style="" width="15%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">&nbsp;</td>

             </tr>
            
                <tr>

                <td class="tableText" style="" width="23%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">Cholesterol</td>

                <td class="tableText" style="" width="15%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">&nbsp;</td>

                <td class="tableText" style="" width="15%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">&nbsp;</td>

            </tr>
            
                <tr>

                <td class="tableText" style="" width="23%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">Total Carbs</td>

                <td class="tableText" style="" width="15%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">&nbsp;</td>

                <td class="tableText" style="" width="15%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">&nbsp;</td>

            </tr>
                <tr>

                <td class="tableText" style="" width="23%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">Fiber</td>

                <td class="tableText" style="" width="15%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">&nbsp;</td>

                <td class="tableText" style="" width="15%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">&nbsp;</td>

            </tr>
                <tr>

                <td class="tableText" style="" width="23%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">Sugar</td>

                <td class="tableText" style="" width="15%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">&nbsp;</td>

                <td class="tableText" style="" width="15%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">&nbsp;</td>

            </tr>
                <tr>

                <td class="tableText" style="" width="23%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">Protein</td>

                <td class="tableText" style="" width="15%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">&nbsp; </td>

                <td class="tableText" style="" width="15%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">&nbsp;</td>

            </tr>
                <tr>

                <td class="tableText" style="" width="23%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">Sodium</td>

                <td class="tableText" style="" width="15%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">&nbsp;</td>

                <td class="tableText" style="" width="15%" height="13"
                    align="" valign="middle" rowspan="1" colspan="1">&nbsp;</td>

            </tr>

</table>
<% }%>                                                  

                                                </td>
                                            </tr>
                                          <tr>
                                                <td colspan="2" height="8">
                                                    </td>
                                            </tr>

                                        </table>
                                </td>
                                         <td width="2%"><img src="" height="1"
                                            width="20"></td>


                                        <td width="40%" valign="top">
                                        <table width=100% bgcolor=FFFFFF>
                                     
                                        </table>
                                        <table width="94%" border="0" bgcolor="FFFFFF"
                                            bordercolor="#25699A" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td class="titleWithBlackBoldBorder" ><font color="FFFFFF">&nbsp;Sales
                                                Information</font></td>
                                            </tr>
                                            <tr>
                                                <td>

                                                <table width="94%" cellpadding="0"
                                                    cellspacing"0" border="0">


                                                    <td colspan="2" class="text" align="top"><%= salesInformation %><br /><br /></td>



                                                </table>
                                                </td>
                                            </tr>
                                        </table>




                                        <table width="94%" border="0" bgcolor="FFFFFF"
                                            bordercolor="#25699A" cellpadding="0" cellspacing="0">



                                            <tr>
                                                <td class="titleWithBlackBoldBorder">
                                                <font color="FFFFFF">&nbsp;Consumer
                                                Objective</font></td>
                                            </tr>
                                            <tr>



                                                <td>

                                                <table width="94%" cellpadding="0"
                                                    cellspacing"0" border="0">


                                                    <td colspan="2" class="text" align="top"><%= consumerObjective %><br /><br /></td>



                                                </table>
                                                </td>
                                            </tr>
                                        </table>



                                        <table width="94%" border="0" bgcolor="FFFFFF"
                                            bordercolor="#25699A" cellpadding="0" cellspacing="0">



                                            <tr>
                                                <td class="titleWithBlackBoldBorder" ><font color="FFFFFF">&nbsp;Business
                                                Objective</font></td>
                                            </tr>
                                            <tr>



                                                <td>

                                                <table width="94%" cellpadding="0"
                                                    cellspacing"0" border="0">


                                                    <td colspan="2" class="text" align="top"><%= bussinessObjective %><br /><br /></td>



                                                </table>
                                                </td>
                                            </tr>
                                        </table>



                                        <table width="94%" border="0" bgcolor="FFFFFF"
                                            bordercolor="#25699A" cellpadding="0" cellspacing="0">



                                            <tr>
                                                <td class="titleWithBlackBoldBorder" ><font color="FFFFFF">&nbsp;Key
                                                Learnings</font></td>
                                            </tr>
                                            <tr>



                                                <td>

                                                <table width="94%" cellpadding="0"
                                                    cellspacing"0" border="0">


                                                    <td colspan="2" class="text" align="top"><%= keyLearning %><br /><br /></td>



                                                </table>
                                                </td>
                                            </tr>
                                        </table>


                                        <table width="94%" border="0" bgcolor="FFFFFF"
                                            bordercolor="#25699A" cellpadding="0" cellspacing="0">



                                            <tr>
                                                <td class="titleWithBlackBoldBorder"> 
                                                <font color="FFFFFF">&nbsp;Additional Information</font></td>
                                            </tr>
                                            <tr>



                                                <td>

                                                <table width="94%" cellpadding="0"
                                                    cellspacing"0" border="0">


                                                    <td colspan="2" class="text" align="top"><font
                                                        color="">
                                                        <%
                                                        //Display Multiple versions Sub Heading, only if a value for it was authored
                                                        if(!multipleVersions.equals("")){
                                                        %>
                                                            <B>Multiple Versions / Other Variations.</B>
                                                            <br>
                                                            <%= multipleVersions %>
                                                            <%
                                                        }
                                                        %> 
                                                        <br><br>
                                                        <%
                                                        //Display Multiple versions Sub Heading, only if a value for it was authored
                                                        if(!additonalComments.equals("")){
                                                        %>
                                                            <B>Additional Comments &amp; Considerations.</B>
                                                            <br>
                                                            <%= additonalComments %>
                                                            <%
                                                        }
                                                        %>

                                                    <br>
                                                    </font></td>
                                                </table>
                                                </td>
                                            </tr>
                                        </table>
                                        </td>
 
                                    </tr>
                                </table>
                                <!--BEGIN INNER TABLE-->
                                <table width="94%" cellspacing="0" cellpadding="0" border="0"> 
                                    
                                    <tr width="94%">
                                        <td width="94%"></td>
                                    </tr>
                                </table>
                                <!--END INNER TABLE--></td>

                            </tr>
                        </table>
                        <!--END OUTER TABLE--> <!-- /PAGE CONTENT -->
</div>
</body>
</html>