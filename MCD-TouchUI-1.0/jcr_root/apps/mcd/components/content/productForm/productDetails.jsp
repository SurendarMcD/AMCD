<%@include file="/apps/mcd/global/global.jsp"%>  
<%@ page import="java.util.*, java.io.*,
                com.mcd.gmt.product.constant.ProductConstant,
                com.mcd.gmt.product.bo.ProductDetail,
                com.mcd.gmt.product.bo.MerlinDetail,
                com.mcd.gmt.product.util.CommonUtil,
                com.mcd.gmt.product.cq.impl.ProductService,
                com.mcd.gmt.product.cq.IProductService,
                com.day.image.Layer,
                com.day.cq.wcm.foundation.Image,
                com.day.cq.wcm.api.components.DropTarget"%> 
 
<%  
    Properties valProp = PropertiesLoader.loadProperties("common.properties"); 
    String ProductName= properties.get("productName","");
    String ProductDesc= properties.get("productDescription",""); 
    String LaunchDate= properties.get("launchDate","");
    String inMenuLabel= properties.get("inMenu",""); 
    String MenuItemPrice= properties.get("menuItemPrice","");
    String CheeseBurgerRelativePrice= properties.get("cheeseBurgerPrice","");   
    String BigMacRelativePrice= properties.get("bigMacPrice",""); 
    String TargetCustomer=properties.get("targetConsumerLabel","");
    String AreaOfWorld= properties.get("aow","");
    String Country= properties.get("selectCountry","");
    String ProductDaypart= properties.get("productDayportLabel","");
    String MenuItemRole= properties.get("menuItemRoleLabel",""); 
    String MenuItemCategory= properties.get("menuItemCategory","");
    String ConsumerObjective= properties.get("consumerObjective",""); 
    String BusinessObjective=properties.get("businessObjective","");
    String SalesInformation= properties.get("salesInformation","");
    String KeyLearnings= properties.get("keyLearnings","");
    String Keywords= properties.get("keyWords","");
    String ContactName= properties.get("contactName",""); 
    String ContactEmail= properties.get("contactEmail","");  
    String AdditionalComment= properties.get("addnalcmmnts",""); 
    
    String enteredinpmp=properties.get("enteredinpmp","");
    String enteredinmenu=properties.get("enteredInMenu","");
    String productspecs=properties.get("productspecs","");
    String menuItemIdLabel=properties.get("MenuItemIdLabel","");
    String productPhoto=properties.get("productPhoto","");

    //fetching values from Property File
    String areaOfTheWorld=valProp.getProperty("areaOfTheWorld"); 
    String targetConsumer=valProp.getProperty("targetConsumer");
    String productDaypart=valProp.getProperty("productDaypart");
    String menuItemCategory=valProp.getProperty("menuItemCategory");
    menuItemCategory=new String(menuItemCategory.getBytes("8859_1"),"UTF-8"); 
    String menuItemRole=valProp.getProperty("menuItemRole");

    StringTokenizer st= null; 
    String errorMsg="";
    String photoSizeValidationMessage="";
    String mode = request.getParameter("mode"); 
    String editPagePath = null; 
    String rootPagePath = !(null == request.getParameter(ProductConstant.rootpath) )? request.getParameter(ProductConstant.rootpath):null;
    String countryDropDownHTML = ProductConstant.BLANK;

    Resource productPageContentResource = null;
    Image productImage = null;
    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "image";

    Page pageToEdit = null;
    ProductDetail productDetailBean = null; 

    String [] areaOfWorldValues = {};
    String [] countryValues = {};
    String currentAreaOfWorld=ProductConstant.BLANK;
    String currencyValues [] = {};


    if( !(null==mode) && (mode.equals(ProductConstant.ACTION_EDIT)) )
    {
        editPagePath = !(null == request.getParameter(ProductConstant.EDIT_PAGE_PATH) )? request.getParameter(ProductConstant.EDIT_PAGE_PATH): null;   
        log.error("The page path is **************************************************************************************** : " + editPagePath );
       
        pageManager = resourceResolver.adaptTo(PageManager.class);
        pageToEdit = pageManager.getPage(editPagePath);
        if( !(null == pageToEdit) ) {
            log.error("Inside if( !(null == pageToEdit) )!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );
            productDetailBean = getProductDetail(pageToEdit, request);
            
        } 
        else {
            //out.println("The page object was not found.............................");
        }
    }
    else
    {
        productDetailBean = new ProductDetail();
    }
%> 
 

<%! 
    public String checkEmpty(String str)
    {   
        if(null==str)
        str = "";
        return str;  
    } 
   
    public String getParameter(HttpServletRequest request,String name,String defValue)
    { 
        String parameterValue = request.getParameter(name);
        if(parameterValue==null)
        {
            parameterValue = defValue;
        }
        return parameterValue;
    }
    public String[] getParameterValues(HttpServletRequest request,String name,String[] defValue)
    { 
        String parameterValue[] = request.getParameterValues(name);
        String [] finalVal;
        if(parameterValue==null||parameterValue.equals(""))
        {
            return finalVal = defValue;
        }
        else
            finalVal = parameterValue;
        return finalVal;
    }
    public String getCommaSeparatedValues(String[] input)
    {
        String returnValue = "";
        if(input != null)
        {
            for(int i = 0; i<input.length; i++)
            {
                returnValue += input[i]+",";
            }
            if(input.length != 0)
            {
                returnValue = returnValue.substring(0, returnValue.length()-1);
            }
        }
        return returnValue;
    }

    //added - 18-11-2011    
    public static String getCommaSeparatedKeywords(String[] keyWords)
    {
        String commaSeperatedKeywords = "";
        String [] splitKeywords={};
        if(keyWords != null)
        {
            for(int keyWordCount = 0; keyWordCount< keyWords.length; keyWordCount++)
            {
                if(keyWords[keyWordCount].indexOf(ProductConstant.GMS_TAGGING_PATH) != -1){ 
                    splitKeywords = keyWords[keyWordCount].split("/");
                    for(int splitCount=0; splitCount< splitKeywords.length; splitCount++){
                        System.out.println("splitKeywords["+splitCount+"]: " + splitKeywords[splitCount]);
                        if(splitKeywords[splitCount].indexOf("CORP:gms") != -1){
                            continue;
                        }
                        commaSeperatedKeywords += splitKeywords[splitCount]+",";
                    }
                }
            }
            if(keyWords.length != 0)
            {
                commaSeperatedKeywords = commaSeperatedKeywords.substring(0, commaSeperatedKeywords.length()-1);
                //System.out.println("*************************************commaSeperatedKeywords :: " + commaSeperatedKeywords.length());
            }
        }else {
            //System.out.println("*************************************in keywords else    nulllllllllllllllllllll ");
        }
        return commaSeperatedKeywords;
    }

    public ProductDetail getProductDetail(Page productPage, HttpServletRequest request) throws Exception
    {        
        ProductDetail productDetailBean = new ProductDetail();
        MerlinDetail merlinDetailBean = new MerlinDetail();
        CommonUtil commonUtil = new CommonUtil();
        productDetailBean.setActionName(getParameter(request,ProductConstant.FORM_ACTIONTYPE,""));
        productDetailBean.setProductRootPath(getParameter(request,ProductConstant.rootpath,""));
        productDetailBean.setProductName(commonUtil.getPageProperty(ProductConstant.Atom_TitleText,productPage));
        productDetailBean.setProductDesc(commonUtil.getPageProperty(ProductConstant.Atom_ProductDesc,productPage));

        productDetailBean.setLaunchDate(commonUtil.getPageProperty(ProductConstant.Atom_WWKBLaunchDate, productPage));
        productDetailBean.setOffMenuDateOpt(commonUtil.getPageProperty(ProductConstant.Atom_WWKBDateOffMenuOpt, productPage));
        productDetailBean.setOffMenuDate(commonUtil.getPageProperty(ProductConstant.Atom_WWKBDateOffMenu, productPage));

        productDetailBean.setAreaOfWorld(commonUtil.getPageProperty(ProductConstant.Atom_WWKBZone, productPage));
        productDetailBean.setCountry(commonUtil.getPageProperty(ProductConstant.Atom_WWKBCountry, productPage));
        productDetailBean.setMenuItemPrice(commonUtil.getPageProperty(ProductConstant.Atom_WWKBMenuItemPrice, productPage));
        productDetailBean.setCheeseBurgerRelativePrice(commonUtil.getPageProperty(ProductConstant.Atom_WWKBMenuPriceChsBrg, productPage));
        productDetailBean.setBigMacRelativePrice(commonUtil.getPageProperty(ProductConstant.Atom_WWKBMenuPriceBigMac, productPage));
        
        productDetailBean.setMenuItemCategoryText(commonUtil.getPageProperty(ProductConstant.Atom_WWKBMenuCategory, productPage));
        productDetailBean.setTargetConsumerTxt(commonUtil.getPageProperty(ProductConstant.Atom_WWKBTargetConsumerTxt, productPage));

        productDetailBean.setMenuItemRole(commonUtil.getMultiValuePageProperty(ProductConstant.Atom_WWKBMenuItemRole, productPage));
        productDetailBean.setProductDaypart(commonUtil.getMultiValuePageProperty(ProductConstant.Atom_WWKBProductDaypart, productPage));
        productDetailBean.setTargetCustomer(commonUtil.getMultiValuePageProperty(ProductConstant.Atom_WWKBTargetAudience, productPage));
        productDetailBean.setMenuItemCategory(commonUtil.getMultiValuePageProperty(ProductConstant.Atom_WWKBMenuCategory, productPage));

        productDetailBean.setSalesInformation(commonUtil.getPageProperty(ProductConstant.Atom_WWKBSalesInfo, productPage));
        productDetailBean.setKeyLearnings(commonUtil.getPageProperty(ProductConstant.Atom_WWKBKeyLearnings, productPage));
        productDetailBean.setBusinessObjective(commonUtil.getPageProperty(ProductConstant.Atom_WWKBBusinessObjective, productPage));
        productDetailBean.setConsumerObjective(commonUtil.getPageProperty(ProductConstant.Atom_WWKBConsumerObjective, productPage));
        productDetailBean.setMultiVersion(commonUtil.getPageProperty(ProductConstant.Atom_WWKBVersionsVariations, productPage));

        productDetailBean.setKeywords(commonUtil.getMultiValuePageProperty(ProductConstant.Atom_Keywords, productPage));
        productDetailBean.setMultiVersion(commonUtil.getPageProperty(ProductConstant.Atom_WWKBVersionsVariations, productPage));
        productDetailBean.setContactName(commonUtil.getPageProperty(ProductConstant.Atom_Author, productPage));
        productDetailBean.setContactEmail(commonUtil.getPageProperty(ProductConstant.Atom_ContactEmail, productPage));
        productDetailBean.setAdditionalComment(commonUtil.getPageProperty(ProductConstant.Atom_WWKBAdditionalComments, productPage));
        productDetailBean.setIsArchieved(commonUtil.getPageProperty(ProductConstant.Atom_WWKBArchievedFlag, productPage));
        //added - 21-11-2011
        productDetailBean.setCurrencyValue(commonUtil.getPageProperty(ProductConstant.Atom_CurrencyVal, productPage));
    
        //String photoMimeType = ProductConstant.BLANK;
        //String photoName = ProductConstant.BLANK;
        //InputStream photoFileObj = null;
        /*  
        try {
                productPageContentResource = slingRequest.getResourceResolver().getResource(productPage.getPath());
                productImage = new Image(resource, "productimage");
        }
        catch(Exception slingException){
                //log.error("Error fetching Image resource***********************************************");
        }
        */
        merlinDetailBean.setEnteredInPMP(commonUtil.getPageProperty(ProductConstant.Atom_MERLINInPMP, productPage));
        merlinDetailBean.setEnteredInMenuItem(commonUtil.getPageProperty(ProductConstant.Atom_MERLINInMenuItemSpecs, productPage));
        merlinDetailBean.setMenuItemID(commonUtil.getPageProperty(ProductConstant.Atom_MERLINMenuItemID, productPage));
        merlinDetailBean.setProdSpecsEntered(commonUtil.getPageProperty(ProductConstant.Atom_MERLINProductSpecsEntered, productPage));

        productDetailBean.setMerlinDetail(merlinDetailBean);

        return productDetailBean;
    }
%>
  
<form method="POST" id="productForm" name="productForm"  enctype="multipart/form-data" action = "<%= resource.getPath()+".productForm.html"%>">
    <div id = "productFormDiv" >
        <!-- The div for header section of Product Form -->
        <div id = "productFormHeaderText" ><p><b>Global Menu Solutions Product Input Form &nbsp;</b></p><br></div>
        <!-- The div for header section of Product Form ends --> 
        <!-- The div for body section of Product Form -->
        <div id = "productFormBody"> 
        <p>
            <font size="2" face="Arial, Helvetica, sans-serif">
                <span class="asterisk">&nbsp;*</span>&nbsp;&nbsp;indicates a required field.<br><br>
            </font>
        </p>     
        <table class="wwkbc" width="100%"  border="0" cellspacing="1" cellpadding="2" >
            <tr valign="top">
                <td width="15%"><font size="2" face="Arial, Helvetica, sans-serif"> <%=ProductName%><span class="asterisk">*</span> </font></td>
                <td width="35%">
                    <font size="2" face="Arial, Helvetica, sans-serif">    
                        <!--<input type="hidden" name='<%= ProductConstant.FORM_PRODUCT_NAME %>' id='<%= ProductConstant.FORM_PRODUCT_NAME%>' value="">--> 
<%
                        boolean productNameDisable = false;
                        if( !(null==mode) && (mode.equals(ProductConstant.ACTION_EDIT)) )
                        {
                            if(!checkEmpty(productDetailBean.getProductName()).equals(""))
                            {
                                productNameDisable = true;
                            }
                        } 
%>
                        <input type="text" maxlength="200" name='<%= ProductConstant.FORM_PRODUCT_NAME %>' id='<%= ProductConstant.FORM_PRODUCT_NAME%>' value="<%=checkEmpty(productDetailBean.getProductName()) %>" <% if(productNameDisable == true){%> readonly <%} %>> 
                    </font>
                </td>
                <input type = "hidden" name = "<%=ProductConstant.rootpath%>" value = "<%=rootPagePath%>"/>
                <input type="hidden" name="<%=ProductConstant.EDIT_PAGE_PATH%>" id="<%=ProductConstant.EDIT_PAGE_PATH%>" value="<%=editPagePath%>"/>  

                <td width="15%" style="min-width: 130px;"><font size="2" face="Arial, Helvetica, sans-serif"><%=ProductDesc%><span class="asterisk">&nbsp;*</span></font></td>
                <td width="35%" colspan="4" style="padding-left:15px"><font size="2" face="Arial, Helvetica, sans-serif" >
                    <textarea name='<%= ProductConstant.FORM_PRODUCT_DESCRIPTION %>' id='<%= ProductConstant.FORM_PRODUCT_DESCRIPTION %>' rows="8" cols="35" onChange="javascript:checkMaxLngth(this, 1500);" ><%=checkEmpty(productDetailBean.getProductDesc()) %></textarea></font>
                </td>
            </tr>  
            <tr valign="top">
                <td><font size="2" face="Arial, Helvetica, sans-serif"> <%=LaunchDate%> <span class="asterisk">&nbsp;*</span></font><br/><span id="subnoteText">(dd/mm/yyyy)</span></td>
                <td><font size="2" face="Arial, Helvetica, sans-serif">
                <input type="text" readOnly="true" name='<%= ProductConstant.FORM_LAUNCH_DATE %>' id='<%= ProductConstant.FORM_LAUNCH_DATE %>' class="inputform px110" value='<%=checkEmpty(productDetailBean.getLaunchDate()) %>' >
                
                
                <A href="javascript:NewCal('<%= ProductConstant.FORM_LAUNCH_DATE %>','ddmmyyyy',false,24)"><IMG height=20 alt="Pick a date" src="/apps/mcd/docroot/images/cal.gif" width=20 border=0> </A>      
                </font></td>

                <td><font size="2" face="Arial, Helvetica, sans-serif"><%=inMenuLabel%><span class="asterisk">&nbsp;*</span></font></td>
                <td colspan="4" style="padding-left:15px"><font size="2" face="Arial, Helvetica, sans-serif">
                <div>

                <font size="2" face="Arial, Helvetica, sans-serif">
                <input type="radio" onClick="HideDatePicker(this);" name='<%= ProductConstant.FORM_DATE_OFF_MENU_OPTION %>' id='<%= ProductConstant.FORM_DATE_OFF_MENU_OPTION %>' value="yes" <% if( (!(null==mode) && (mode.equals(ProductConstant.ACTION_ADD))) || (checkEmpty(productDetailBean.getOffMenuDateOpt()).equals("yes")) ) { %> checked <% } %> />Yes
                <input type="radio" name='<%= ProductConstant.FORM_DATE_OFF_MENU_OPTION %>' onClick="ShowDatePicker(this);" id='<%= ProductConstant.FORM_DATE_OFF_MENU_OPTION %>' value="no" <% if(checkEmpty(productDetailBean.getOffMenuDateOpt()).equals("no")) { %> checked <% } %> />No  &nbsp;    </font> </div>
                
                <div id="date_txt" <% if(checkEmpty(productDetailBean.getOffMenuDateOpt()).equals("no")) { %> style="display:block" <%} else {%> style="display:none" <% } %> >
                <div id="offMenuTxtLabel"/><font size="2" face="Arial, Helvetica, sans-serif"> Off Menu<span class="asterisk">&nbsp;*&nbsp;</span></font><span id="subnoteText">(dd/mm/yyyy)</span></div>
                        <div id="offMenuCalTextDiv"><input  size ="20" type="text" readOnly="true" name='<%= ProductConstant.FORM_DATE_OFF_MENU_DATE %>' <% if(checkEmpty(productDetailBean.getOffMenuDateOpt()).equals("no")) { %> style="display:block" <%} else {%> style="display:none" <% } %>  id='<%= ProductConstant.FORM_DATE_OFF_MENU_DATE %>' value='<%=checkEmpty(productDetailBean.getOffMenuDate())%>' /></div>
                 <div id="offMenuaCalImageDiv" style="margin-left: 150px;margin-top: -21px;"><A href="javascript:NewCal('<%= ProductConstant.FORM_DATE_OFF_MENU_DATE %>','ddmmyyyy',false,24)"><IMG id="offMenuaDateCalImage" height=20 alt="Pick a date" src="/apps/mcd/docroot/images/cal.gif" width=20 border=0> </A></div>                   
                </div></td>
                  
                
        </tr>              
        <tr valign="top">
        <td height="43"><font size="2" face="Arial, Helvetica, sans-serif">Area of the World<span class="asterisk">&nbsp;*</span></font></td>
        <td><font size="2" face="Arial, Helvetica, sans-serif">
        <select name="<%= ProductConstant.FORM_AREA_OF_WORLD %>" onchange="check(this,'<%=areaOfTheWorld%>')" id="pscn" > 
        <option value="default">Select AOW</option>
        <% st = new StringTokenizer(areaOfTheWorld, "/");
            while(st.hasMoreTokens()) {
                String tmp = st.nextToken();                          
                String values[]= tmp.split(",");  
                %>
                <option value="<%=values[0]%>" <%=productDetailBean.getAreaOfWorld().equalsIgnoreCase(values[0]) ? "selected" : "" %>><%=values[0]%></option>
                <%
            }
        %>
        </select>  
      </font></td>
       
        
            <td><font size="2" face="Arial, Helvetica, sans-serif">Country<span class="asterisk">*</span></font></td>
            <td style=" padding-left: 15px;"> 
            <font size="2" face="Arial, Helvetica, sans-serif">
            <select id="<%= ProductConstant.FORM_COUNTRY_NAME %>" onchange="updateCurrencyLabel(this,'<%=areaOfTheWorld%>')" name="<%= ProductConstant.FORM_COUNTRY_NAME %>"> 
           
            <%
            String editAreaOfWorld=valProp.getProperty("areaOfTheWorld"); 
            if( !(null==mode) && (mode.equals(ProductConstant.ACTION_EDIT)) ){

                countryDropDownHTML = "<option value=\"default\">Select Country</option>";
           
                if( !(checkEmpty(productDetailBean.getAreaOfWorld()).equals("")) ){ //Area of World Field has a value
                  
                    String AOWvalue = checkEmpty(productDetailBean.getAreaOfWorld());
                    String [] data = editAreaOfWorld.split("/");
                    for(int i = 0; i < data.length; i++){
                        if(data[i].indexOf(AOWvalue) > -1 ){
                            String slashSplitString = data[i];
                            String [] commaSplitArray = slashSplitString.split(",");
                            String countryListString = commaSplitArray[1];
                         
                            String [] countryListArray = countryListString.split("\\|");
                            for(int j = 0; j < countryListArray.length; j++){
                                String currentCountry = countryListArray[j];
                                String [] currencyList=currentCountry.split("_");
                                if
                               ( !(checkEmpty(productDetailBean.getCountry()).equals("")) && productDetailBean.getCountry().equals(currencyList[0]) ){
                                countryDropDownHTML = countryDropDownHTML.concat("<option selected value=\'" + currencyList[0]+ "\'>"+currencyList[0] +"</option>");
                                }else {
                                countryDropDownHTML = countryDropDownHTML.concat("<option value=\'" + currencyList[0]+ "\'>"+currencyList[0] +"</option>");
                                }
                             }   
                        }
                    }
                   
                } else{ 
                    //log.error("***************************************************************** No value on Area of world populated on form is"  + checkEmpty(productDetailBean.getAreaOfWorld()) );
                }
            out.println(countryDropDownHTML);
            }
            
            else {
                //log.error("******************************************************************************** drawing the country field for ADD");
            %>
            <option value="default">Select Country</option>
            <% }
            %>
            </select>
            </font></td>  
            </tr>
 
       <tr valign="top" >
        <td colspan="4" height="45px">
            <table>
                <tr width=100%>
                    <td width="13%" valign="top" style="border-bottom:0px;"><font size="2" face="Arial, Helvetica, sans-serif"> <%=MenuItemPrice%><span class="asterisk">&nbsp;*</span></font></td>
                    <td width="18%" valign="top" style="border-bottom:0px;"><font size="2" face="Arial, Helvetica, sans-serif">
                    <input size="10" type="text" style="float:left;margin-right:2px;" name='<%= ProductConstant.FORM_MENU_ITEM_PRICE %>' id='<%= ProductConstant.FORM_MENU_ITEM_PRICE %>' value='<%=productDetailBean.getMenuItemPrice()%>'>
                    <div id="currLabelDiv">
                    <% 
                    if(!checkEmpty(productDetailBean.getCurrencyValue()).equals("")) { 
                    %> <label name="currencyLabel" id="currencyLabel" style="display:block"><%=productDetailBean.getCurrencyValue()%></label>
                      <% }
                        else {
                      %>
                        <label name="currencyLabel" id="currencyLabel"></label>
                      <% }
                      %>
                 
                    </div>
                    
                    </font></td>
                    <td width="17%" valign="top" nowrap style="border-bottom:0px;"><font size="2" face="Arial, Helvetica, sans-serif" ><%=CheeseBurgerRelativePrice%> <span class="asterisk">&nbsp;*</span></font></td>
                    <td width="18%" valign="top" style="border-bottom:0px;"><font size="2" face="Arial, Helvetica, sans-serif" >
                    <input size="10" type="text" style="float:left;margin-right:2px;" name='<%= ProductConstant.FORM_MENU_ITEM_PRICE_CHEESEBURGER %>' id='<%= ProductConstant.FORM_MENU_ITEM_PRICE_CHEESEBURGER %>' value='<%=productDetailBean.getCheeseBurgerRelativePrice()%>'  >
                    <div id="currLabelDiv">
                    <% 
                    if(!checkEmpty(productDetailBean.getCurrencyValue()).equals("")) { 
                    %> <label name="currencyLabel" id="currencyLabel" style="display:block"><%=productDetailBean.getCurrencyValue()%></label>
                    <% }
                        else {
                    %>
                        <label name="currencyLabel" id="currencyLabel"></label>
                    <% }
                    %>
                    </div> 
                    </font></td>
                    <td width="16%" valign="top" style="border-bottom:0px;"><font size="2" face="Arial, Helvetica, sans-serif" style="border-bottom:0px;"> <%=BigMacRelativePrice%> <span class="asterisk">&nbsp;*</span></font></td>
                    <td width="21%" valign="top" style="border-bottom:0px;"><font size="2" face="Arial, Helvetica, sans-serif" style="border-bottom:0px;">
                    <input size="10" type="text" style="float:left;margin-right:2px;" name='<%=ProductConstant.FORM_MENU_ITEM_PRICE_BIGMAC %>' id='<%=ProductConstant.FORM_MENU_ITEM_PRICE_BIGMAC %>' value='<%=productDetailBean.getBigMacRelativePrice()%>' >
                    <div id="currLabelDiv">
                    <%  log.error("currLabelDiv1111111111");
                    if(!checkEmpty(productDetailBean.getCurrencyValue()).equals("")) { 
                    %> <label name="currencyLabel" id="currencyLabel" style="display:block"><%=productDetailBean.getCurrencyValue()%></label>
                    <% }
                        else {
                    %>
                        <label name="currencyLabel" id="currencyLabel"></label>
                    <% }
                    %>
                    </div>  
                    </font></td> 
                    <% log.error("currLabelDiv22222222222222");
                     if(!checkEmpty(productDetailBean.getCurrencyValue()).equals("")) {%>
                       <input type="text" name='currencyVal' id='currencyVal' value='<%=productDetailBean.getCurrencyValue()%>' readonly="true" style="display:none">
                    <% } else{%>
                        <input type="text" name='currencyVal' id='currencyVal' value="" readonly="true" style="display:none">
                      <% }%>
                </tr>
            </table></td>
      </tr> 
        <tr valign="top">
        <td height="107">
            <font size="2" face="Arial, Helvetica, sans-serif"><%=MenuItemRole%><span class="asterisk">&nbsp;*</span></font><br/><span id="subnoteText">(Check all that apply)</span>
        </td>
        <td>
            <p><font size="2" face="Arial, Helvetica, sans-serif">
            <% st= new StringTokenizer(menuItemRole, "|");
                  while(st.hasMoreTokens())  
                        {
                                String tmp = st.nextToken();
                                String values[]= tmp.split(",");
                                  %>  
                                  <input type="checkbox" name='<%= ProductConstant.FORM_MENU_ITEM_ROLE %>' value="<%=values[1]%>" <%=getCommaSeparatedValues(productDetailBean.getMenuItemRole()).indexOf(values[1]) != -1?"checked":""%>/> <%=values[0]%> <br>
                    <%
                        }
                    %>
            </p>
        </td>
        <td><font size="2" face="Arial, Helvetica, sans-serif"><%=ProductDaypart%><span class="asterisk">&nbsp;*</span></font><br /><span id="subnoteText">(Check all that apply)</span></td>
        <td style="padding-left:15px"><p><font size="2" face="Arial, Helvetica, sans-serif">
                 <%st= new StringTokenizer(productDaypart, "|");
                  while(st.hasMoreTokens())  
                        {
                                String tmp = st.nextToken();
                                String values[]= tmp.split(",");
                               %>
                                    <input type="checkbox" name='<%= ProductConstant.FORM_PRODUCT_DAYPART %>' value="<%=values[1]%>" <%=getCommaSeparatedValues(productDetailBean.getProductDaypart()).indexOf(values[1]) != -1?"checked":""%>/> <%=values[0]%> <br>
                        <%
                        }
                        %>
        
        </td>
      </tr>
       <tr valign="top">
        <td height="239"><font size="2" face="Arial, Helvetica, sans-serif"><%=TargetCustomer%><span class="asterisk">&nbsp;*</span></font><br/><span id="subnoteText">(Check all that apply)</span></td>
        <td ><p><font size="2" face="Arial, Helvetica, sans-serif">
         
            <%    
            st= new StringTokenizer(targetConsumer, "|");
            while(st.hasMoreTokens())  
                { 
                    String tmp = st.nextToken();
                    String values[]= tmp.split(",");
            %>
                    <input type="checkbox" name='<%= ProductConstant.FORM_TARGET_CONSUMERS%>' onClick="javascript:toggleOtherMenuItem(this,'TR_Other_Target_Consumer')" value="<%=values[1]%>" <%=getCommaSeparatedValues(productDetailBean.getTargetCustomer()).indexOf(values[1]) != -1?"checked":""%>/> <%=values[0]%> <br>
            <% 
                }
            %> 
                   <% if(!checkEmpty(productDetailBean.getMenuItemCategoryText()).equals("")) {%>        
                  <input type="text" name='<%= ProductConstant.FORM_TARGET_CONSUMER_TXT %>' style="Display:none"   id='<%= ProductConstant.FORM_TARGET_CONSUMER_TXT %>' maxlength="50" value='<%=productDetailBean.getTargetConsumerTxt()%> '/></font>
                   <%}else {%>
                  <input type="text" name='<%= ProductConstant.FORM_TARGET_CONSUMER_TXT %>' style="Display:none"   id='<%= ProductConstant.FORM_TARGET_CONSUMER_TXT %>' maxlength="50" value=' '/></font>
          <%}%>
           
          </p>     
          </td>
          
          <td><font size="2" face="Arial, Helvetica, sans-serif"><%=MenuItemCategory%><span class="asterisk">&nbsp;*</span></font><br/><span id="subnoteText">(Check all that apply)</span></td>
          <td style="padding-left:15px"><p><font size="2" face="Arial, Helvetica, sans-serif">
      
          <%    
                 
                  st= new StringTokenizer(menuItemCategory, "|");
                  while(st.hasMoreTokens())   
                        { 
                                String tmp = st.nextToken();
                                String values[]= tmp.split(",");
                                //log.error("eeeeeeeeeeeeeennnnnnnnnccccccccccccDdddddddddddddddddddddddddddddd"+values[1]);  
                               // String encodedValue=values[1];
                                //encodedValue=new String(encodedValue.getBytes("8859_1"),"UTF-8");   
                               // log.error("eeeeeeeeeeeeeennnnnnnnnccccccccccccDdddddddddddddddddddddddddddddd"+encodedValue); 
                               %>  
                                 <input type="checkbox"   name='<%= ProductConstant.FORM_MENU_ITEM_CATEGORY %>'  onClick="javascript: toggleOtherMenuItem(this, 'TR_Other_Menu_Item_Category')"value="<%=values[1]%>" <%=getCommaSeparatedValues(productDetailBean.getMenuItemCategory()).indexOf(values[1]) != -1?"checked":""%>/> <%=values[0]%><br> 
       
                        <% 
                        } 
                        %> 
          <% if(!checkEmpty(productDetailBean.getMenuItemCategoryText()).equals("")) {%>              
          <input type="text" name='<%= ProductConstant.FORM_OTHER_MENU_CATEGORY_TXT %>' style="Display:none"   id='<%= ProductConstant.FORM_OTHER_MENU_CATEGORY_TXT %>' value='<%=productDetailBean.getMenuItemCategoryText()%>' maxlength="50"/></font></p></td>
          <%}else {%>
            <input type="text" name='<%= ProductConstant.FORM_OTHER_MENU_CATEGORY_TXT %>' style="Display:none" id='<%= ProductConstant.FORM_OTHER_MENU_CATEGORY_TXT %>' value="" maxlength="50"/></font></p></td>
          <%}%>
        </tr> 
    
      <tr valign="top">
        <td height="104" width="20%"  >
            <font size="2" face="Arial, Helvetica, sans-serif"><%=SalesInformation%><span class="asterisk">&nbsp;*</span></font><br><span id="subnoteText">(Include UPT 's' in sales results)</span></td>
        <td width="30%" >
            <font size="2" face="Arial, Helvetica, sans-serif">
            <textarea name='<%= ProductConstant.FORM_SALES_INFORMATION %>' id='<%= ProductConstant.FORM_SALES_INFORMATION %>' rows="6" cols="25" onChange="javascript:checkMaxLngth(this, 1500);"><%=productDetailBean.getSalesInformation()%></textarea>
                </font>
        </td> 
        <td width="20%" style="padding-left:15px"><font size="2" face="Arial, Helvetica, sans-serif">Key Learnings</font></td> 
        <td width="30%" style="padding-left:15px" ><font size="2" face="Arial, Helvetica, sans-serif">
          <textarea name='<%= ProductConstant.FORM_KEY_LEARNINGS %>' id='<%= ProductConstant.FORM_KEY_LEARNINGS %>' rows="6" cols="25" onChange="javascript:checkMaxLngth(this, 2000);"><%=productDetailBean.getKeyLearnings()%></textarea>
        </font></td>
                    
      </tr>
      <tr valign="top">
        <td height="90" width="15%"  ><font size="2" face="Arial, Helvetica, sans-serif"><%=BusinessObjective%><span class="asterisk">&nbsp;*</span></font></td>
        <td width="35%" ><font size="2" face="Arial, Helvetica, sans-serif">
          <textarea name='<%= ProductConstant.FORM_BUSINESS_OBJECTIVE %>' id='<%= ProductConstant.FORM_BUSINESS_OBJECTIVE %>' rows="6" cols="25" onChange="javascript:checkMaxLngth(this, 2000);"><%=productDetailBean.getBusinessObjective()%></textarea>
        </font></td>
        <td width="15%" style="padding-left:15px"><font size="2" face="Arial, Helvetica, sans-serif"><%=ConsumerObjective%> </font></td>
            <td width="35%" style="padding-left:15px" ><font size="2" face="Arial, Helvetica, sans-serif">
            <textarea name='<%= ProductConstant.FORM_CONSUMER_OBJECTIVE %>' id='<%= ProductConstant.FORM_CONSUMER_OBJECTIVE %>'  rows="6" cols="25" onChange="javascript:checkMaxLngth(this, 1500);"><%=productDetailBean.getConsumerObjective()%></textarea>
            </font></td>    
        
      </tr>  
       
      <tr valign="top">
        <td height="94"><font size="2" face="Arial, Helvetica, sans-serif"><%=Keywords%><span class="asterisk">&nbsp;*</span><br>(comma-separated)</font></td>
        <td  style="padding-right:15px"><font size="2" face="Arial, Helvetica, sans-serif">
          <textarea name='<%= ProductConstant.FORM_KEYWORDS %>' id='<%= ProductConstant.FORM_KEYWORDS %>' rows="6" cols="25" onChange="javascript:checkMaxLngth(this, 300);"><%=getCommaSeparatedKeywords(productDetailBean.getKeywords())%></textarea> 
        </font></td>
    
    <td  style="padding-left:15px;text-align:left"  ><font size="2" face="Arial, Helvetica, sans-serif">Multiple Versions / Other Variations?</font><br /><span id="subnoteText">(Describe any line extensions or other versions in test)</span></td>
        <td  style="padding-left:15px" ><font size="2" face="Arial, Helvetica, sans-serif">
          <textarea name='<%= ProductConstant.FORM_MULTILE_VERSIONS %>' id='<%= ProductConstant.FORM_MULTILE_VERSIONS %>' rows="6" cols="25" onChange="javascript:checkMaxLngth(this, 1000);"><%=productDetailBean.getMultiVersion()%></textarea>
        </font></td> 
      <tr valign="top">
        <td height="38"  ><font size="2" face="Arial, Helvetica, sans-serif"><%=ContactName%><span class="asterisk">&nbsp;*</span></font></td>
        <td ><font size="2" face="Arial, Helvetica, sans-serif">
          <input type="text" size="33" name='<%= ProductConstant.FORM_CONTACT_NAME %>' id='<%= ProductConstant.FORM_CONTACT_NAME %>' maxlength="200" value='<%=productDetailBean.getContactName()%>'>
        </font></td>
        
        <td height="38" style="padding-left:15px" ><font size="2" face="Arial, Helvetica, sans-serif"><%=ContactEmail%><span class="asterisk">&nbsp;*</span></font></td>
        <td style="padding-left: 15px;"><font size="2" face="Arial, Helvetica, sans-serif">
          <input type="text" size="33" name='<%= ProductConstant.FORM_CONTACT_EMAIL %>' id='<%= ProductConstant.FORM_CONTACT_EMAIL %>'  onChange='javascript: checkEmail(this)' maxlength="200" value='<%=productDetailBean.getContactEmail()%>'>
        </font></td>
            <td colspan="2"></td>
      </tr>
      
      <tr valign="top">
        <td height="87"  ><font size="2" face="Arial, Helvetica, sans-serif"><%=AdditionalComment%> </font><br/><span id="subnoteText">(Product Build info can be included here if it is not available in MERLIN)</span></td>
        <td  ><font size="2" face="Arial, Helvetica, sans-serif">
          <textarea name='<%= ProductConstant.FORM_ADDITINAL_COMMENTS %>' id='<%= ProductConstant.FORM_ADDITINAL_COMMENTS %>' rows="6" cols="25" onChange="javascript:checkMaxLngth(this, 1000);"><%=productDetailBean.getAdditionalComment()%></textarea>
        </font> </td>
         <td height="61" style="padding-left:15px" ><font size="2" face="Arial, Helvetica, sans-serif">Product Photo<span class="asterisk">&nbsp;*</span></font><br/><span id="subnoteText">(Photos attached cannot exceed 3 MB)</span>
        <% 
        if(!photoSizeValidationMessage.equals("")){ 
        %><div id="errorDiv"><%=photoSizeValidationMessage%></div>
        <%  } //end if 
        %></font></td>
        <td ><font size="2" face="Arial, Helvetica, sans-serif">
        <img id="myImage" src="" style="display:none;"><br>
        <input  name='TR_Product_Photo' id='TR_Product_Photo' width="200px"  style="margin-left: 12px; margin-bottom: 7px;"type="file" />
           
        </font>
         
 <%      
        try {
                    log.error("Inside try !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );
                    //productPageContentResource = slingRequest.getResourceResolver().getResource( (pageToEdit.getPath() + "/jcr:content"));
                    productPageContentResource = pageToEdit.getContentResource();
                    log.error("********************************************************************************************************* productPageContentResource.getPath() " + productPageContentResource.getPath());
                    if( null != productPageContentResource ){
                        log.error("if( null != productPageContentResource ) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );
                        productImage = new Image(productPageContentResource, ProductConstant.Atom_WWKBProductPhoto);
                        log.error("productImage has content ************************************************************************** " + productImage.hasContent());
                        if( (null!= productImage) && (productImage.hasContent()) ){
                            //log.error("********************************************************************* HREF FOR PRODUCT PHOTO IS: " + productImage.getHref());
                            //productImage.setSelector(".img");
                            //productImage.setDoctype(Doctype.fromRequest(request));
                        
     %>
                            <!-- div around image for additional formatting -->
                            <div id="Product_Photo_DIV" name="Product_Photo_DIV" class="Product_Photo_DIV" ><%
     %><%                   
                            productImage.setSelector(".img"); // use image script
                            productImage.addCssClass(ddClassName);
                            productImage.loadStyleData(currentStyle);
                            productImage.setAlt(productImage.getHref()); 
                            //productImage.PN_HTML_HEIGHT = "100px";
                            //productImage.PN_HTML_WIDTH = "100px"; 
                            productImage.draw(out); 
     %>
                            <br></div>
     <%
                        }
                    }
            }
            catch(Exception slingException){
                    log.error("Error fetching Image resource***********************************************");
            }
   %>     

        </td>
        </tr>
       
       <% if( !(null==mode) && (mode.equals(ProductConstant.ACTION_EDIT)) ){%>
        <tr valign="top">
        <td ><font size="2" face="Arial, Helvetica, sans-serif">Add to Archive</font></td>
        <td><font size="2" face="Arial, Helvetica, sans-serif">
        <input type="checkbox" name='<%= ProductConstant.FORM_ARCHIEVED_TYPE%>' id='<%= ProductConstant.FORM_ARCHIEVED_TYPE%>' value="<%=ProductConstant.FORM_ARCHIEVED_TYPE_CHECKEDVAL%>"<%if (checkEmpty(productDetailBean.getIsArchieved()).equalsIgnoreCase(ProductConstant.FORM_ARCHIEVED_TYPE_CHECKEDVAL)) { %> checked <% } %>  /> 
        </font> </td>
        <td>&nbsp;</td> 
        <td>&nbsp;</td>
        </tr>
      <% } 
      %>
       
    </table>
        <table width="100%"  border="0" cellspacing="0" cellpadding="2" > 
          <tr valign="top">
        <td colspan="3"><font size="2" face="Arial, Helvetica, sans-serif"><b>MERLIN</b></font></td>
        <td><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></td>
      </tr>
      <tr valign="top">
        <td><font size="2" face="Arial, Helvetica, sans-serif"><%=enteredinpmp%><span class="asterisk">&nbsp;*</span></font></td> 
        <td><font size="2" face="Arial, Helvetica, sans-serif">
          <input type="radio" name='<%= ProductConstant.FORM_ENTERED_IN_PMP %>' id='<%= ProductConstant.FORM_ENTERED_IN_PMP %>' value="yes" 
          <% if(productDetailBean.getMerlinDetail().getEnteredInPMP().equalsIgnoreCase("yes")) { %> checked <% } %>/>Yes &nbsp;&nbsp;
          <input type="radio" name='<%= ProductConstant.FORM_ENTERED_IN_PMP %>' id='<%= ProductConstant.FORM_ENTERED_IN_PMP %>' value="no"
          <% if( (!(null==mode) && (mode.equals(ProductConstant.ACTION_ADD))) || (productDetailBean.getMerlinDetail().getEnteredInPMP().equalsIgnoreCase("no")) ) { %> checked <% } %>/>No <br/>          
        </font></td> 
        <td><font size="2" face="Arial, Helvetica, sans-serif"><%=enteredinmenu%><span class="asterisk">&nbsp;*</span></font></td>
    
          <td><font size="2" face="Arial, Helvetica, sans-serif">
          <input type="radio" name='<%= ProductConstant.FORM_MENU_ITEM_SPEC %>' id='<%= ProductConstant.FORM_MENU_ITEM_SPEC %>' value="yes" onClick="showMenuID()"
          <% if(productDetailBean.getMerlinDetail().getEnteredInMenuItem().equalsIgnoreCase("yes")) { %> checked <% } %> />Yes &nbsp;&nbsp; 
          <input type="radio" name='<%= ProductConstant.FORM_MENU_ITEM_SPEC %>' id='<%= ProductConstant.FORM_MENU_ITEM_SPEC %>' value="no" onClick="hideMenuID()" 
          <% if( (!(null==mode) && (mode.equals(ProductConstant.ACTION_ADD))) || (productDetailBean.getMerlinDetail().getEnteredInMenuItem().equalsIgnoreCase("no")) ) { %> checked <% } %>/>No <br/>
            </font>
            </td> 
      </tr> 
   <tr valign="top">
        <td><font size="2" face="Arial, Helvetica, sans-serif"><%=menuItemIdLabel%> <span id="menuItemIdAsterisk" style="display:none"><span class="asterisk">&nbsp;*</span></span></font>
 
        </td>
         <td><font size="2" face="Arial, Helvetica, sans-serif">     
          <% if((!(null==mode) && (mode.equals(ProductConstant.ACTION_ADD)))||(productDetailBean.getMerlinDetail().getEnteredInMenuItem()).equals("no")) { %>
           <input type="text" disabled="true" name='<%= ProductConstant.FORM_MENU_ITEM_ID %>' id='<%= ProductConstant.FORM_MENU_ITEM_ID %>' value="NA"/>
          <%}else{%>
          <input type="text"  name='<%= ProductConstant.FORM_MENU_ITEM_ID %>' id='<%= ProductConstant.FORM_MENU_ITEM_ID %>' value='<%=productDetailBean.getMerlinDetail().getMenuItemID()%>'/>
          <% }%>  
        </font></td>  

        <td><font size="2" face="Arial, Helvetica, sans-serif"><%=productspecs%><span class="asterisk">&nbsp;*</span></font></td>
          <td><font size="2" face="Arial, Helvetica, sans-serif">
          <input type="radio" name='<%= ProductConstant.FORM_PRODUCT_SPEC %>' id='<%= ProductConstant.FORM_PRODUCT_SPEC %>' value="yes" 
          <% if(productDetailBean.getMerlinDetail().getProdSpecsEntered().equalsIgnoreCase("yes")) { %> checked <% } %> />Yes &nbsp;&nbsp; 
          <input type="radio" name='<%= ProductConstant.FORM_PRODUCT_SPEC %>' id='<%= ProductConstant.FORM_PRODUCT_SPEC %>' value="no"  
          <% if( (!(null==mode) && (mode.equals(ProductConstant.ACTION_ADD))) || (productDetailBean.getMerlinDetail().getProdSpecsEntered().equalsIgnoreCase("no")) ) { %> checked <% } %>/>No <br/>
           
          
        </font></td>
      </tr>
      <tr>
      <td colspan=4><div id="merlinErrorDiv" ></div></td> 
      </tr>
    </table> 
    </div>
    <!-- The div for body section of Product Form ends -->

    <!-- The div for submit section of product Input Form  -->
    <div id = "productFormSubmit">
    <table width="100%"  border="0" cellspacing="0" cellpadding="2" >
      <tr valign="top">
        <td colspan="4" style="border-bottom: dotted 1px #FFFFFF"><p align="center"><font size="2" face="Arial, Helvetica, sans-serif"></font><font size="2" face="Arial, Helvetica, sans-serif"></font><br>
        <input type="hidden" name="<%=ProductConstant.FORM_ACTIONTYPE%>" id="<%=ProductConstant.FORM_ACTIONTYPE%>" value="<%=ProductConstant.FORM_ACTIONTYPE%>">
        <input type="hidden" name='<%= ProductConstant.FORM_MERLINNutritionXML %>' id='<%= ProductConstant.FORM_MERLINNutritionXML%>' value="">
        <input type="hidden" name='<%= ProductConstant.FORM_MERLINNutritionInfoXSLT%>' id='<%= ProductConstant.FORM_MERLINNutritionInfoXSLT%>' value="">
    <input type="hidden" name='<%= ProductConstant.FORM_MERLINBuildXML%>' id='<%= ProductConstant.FORM_MERLINBuildXML%>' value="">
        <input type="hidden" name='<%= ProductConstant.FORM_MERLINBuildInfoXSLT%>' id='<%= ProductConstant.FORM_MERLINBuildInfoXSLT%>' value="">
    <%
        //log.error("Outside any condition ****************************************************************************************** the mode is: " + mode);  
        //if the action from Product Selection Form is ADD
        if( !(null == mode) && mode.equals(ProductConstant.ACTION_ADD) ){
        //log.error(" Inside condtion when ADD was clicked ****************************************************************************************** the mode is: " + mode);
     
    %> 
          <input type="button" id="<%=ProductConstant.ACTION_FORM_ADD%>" name="<%=ProductConstant.ACTION_FORM_ADD%>" value="<%=ProductConstant.BUTTONSTRING_SUBMIT%>" onClick="return validate(this);">
          <input type="button" id="<%=ProductConstant.ACTION_FORM_SAVE_AS_DRAFT%>" name="<%=ProductConstant.ACTION_FORM_SAVE_AS_DRAFT%>" value="<%=ProductConstant.BUTTONSTRING_SAVEASDRAFT%>" onClick="return saveAsDraftValidate(this);"> 
          <input type="button" id="<%=ProductConstant.ACTION_FORM_ADD_CANCEL%>" name="<%=ProductConstant.ACTION_FORM_ADD_CANCEL%>" value="<%=ProductConstant.ACTION_FORM_CANCEL%>" onClick="javascript:window.location=('<%=currentPage.getPath()%>'+'.html');" /> 
    <% 
        }    
        //if the action from Product Selection Form is EDIT
        else if( !(null == mode) && mode.equals(ProductConstant.ACTION_EDIT) ){ 
        //log.error("Inside condtion when EDIT was clicked ****************************************************************************************** the mode is: " + mode); 
    
    %> 
          <input type="button" id="<%=ProductConstant.ACTION_FORM_UPDATE%>" name="<%=ProductConstant.ACTION_FORM_UPDATE%>" value="<%=ProductConstant.BUTTONSTRING_SUBMIT%>" onClick="return validate(this);">
          <input type="button" id="<%=ProductConstant.ACTION_FORM_UPDATE_SAVE_AS_DRAFT%>" name="<%=ProductConstant.ACTION_FORM_UPDATE_SAVE_AS_DRAFT%>" value="<%=ProductConstant.BUTTONSTRING_SAVEASDRAFT%>" onClick="return saveAsDraftValidate(this);"> 
          <input type="button" id="<%=ProductConstant.ACTION_FORM_EDIT_CANCEL%>" name="<%=ProductConstant.ACTION_FORM_EDIT_CANCEL%>" value="<%=ProductConstant.ACTION_FORM_CANCEL%>"onClick="javascript:window.location=('<%=currentPage.getPath()%>'+'.html');"/> 
    <%
        }  
    %>  

        </p>
        </td> 
      </tr> 
    </table>
    </div>
    <!-- The div for submit section of product Input Form ends -->
    </form>
</div>
<!-- The outermost Div ends-->
</body>
</html> 
    