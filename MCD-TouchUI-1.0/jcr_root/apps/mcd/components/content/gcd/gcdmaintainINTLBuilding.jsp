<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.mcd.accessmcd.gcd.facade.*" %>
<%@ page import="com.mcd.accessmcd.gcd.bean.BuildingDetails,com.mcd.accessmcd.gcd.bean.CountryDetails" %>
<%@ page import="com.mcd.accessmcd.gcd.constants.GCDConstants" %>
<%@ page import="com.day.cq.security.*,com.mcd.accessmcd.usermanagement.user.manager.UserMaintenanceManager" %>
<%@ page import="com.mcd.accessmcd.usermanagement.user.bo.GroupDataBean" %> 

<%!
    //Declaring the variables
    String readOnly = null;
    String borderType = null;
%>
  
<%
    String saveLinkLabel = properties.get("form_intlbldsavelabel","Save");
    String deleteLinkLabel = properties.get("form_intlblddeletelabel","Delete");
    String cancelLinkLabel = properties.get("form_intlbldcancellabel","Cancel");
    String cancelLinkURL = properties.get("form_intlbldcancelurl","");
    String Helppath = properties.get("helpPath","");
    if(!"".equals(cancelLinkURL.trim())){
        if(cancelLinkURL.startsWith("/content")){
            cancelLinkURL = cancelLinkURL.replaceAll("/content","")+".html";
        }
    }
    else{
  //      cancelLinkURL  = "http://www.accessmcd.com";
    }
    
    //Declaring the common variables
    BuildingDetails buildingDetails = null;
    readOnly = "readonly";
    borderType = "noborder";
    String infoText = "";
    ArrayList allActiveCountryNames = null;
    CommonUtil commonUtil = new CommonUtil(); 
    String formAction = "";
    
    try{
        
        // get GCDFacadeImpl Object     
        IGCDFacade iGCDFacade = new GCDFacadeImpl();
        allActiveCountryNames = iGCDFacade.getCountries(sling);
                        
        if(null != request.getParameter(GCDConstants.FORMACTION)){
            formAction = request.getParameter(GCDConstants.FORMACTION);
        }    
    
        
        if(GCDConstants.UPDATE_BUILDING_SAVE_LINK.equals(formAction)){
            buildingDetails = new BuildingDetails();
            buildingDetails.setBldgCd(new Integer(request.getParameter(GCDConstants.LIST_BUILDING_CODE)).intValue());
            buildingDetails.setBldgNa(request.getParameter(GCDConstants.LIST_BUILDING_NAME));
            buildingDetails.setSiteDs(request.getParameter(GCDConstants.LIST_BUILDING_SITE_DS));
            buildingDetails.setSiteL1Ad(request.getParameter(GCDConstants.LIST_BUILDING_SITE_AD_L1));
            buildingDetails.setSiteL2Ad(request.getParameter(GCDConstants.LIST_BUILDING_SITE_AD_L2));
            buildingDetails.setSiteL3Ad(request.getParameter(GCDConstants.LIST_BUILDING_SITE_AD_L3));
            buildingDetails.setSiteL4Ad(request.getParameter(GCDConstants.LIST_BUILDING_SITE_AD_L4));
            buildingDetails.setSiteL5Ad(request.getParameter(GCDConstants.LIST_BUILDING_SITE_AD_L5));
            buildingDetails.setSiteCourierCd(request.getParameter(GCDConstants.LIST_UPDATE_BUILDING_SITE_COURIER_CD));
            buildingDetails.setSiteCityAd(request.getParameter(GCDConstants.LIST_BUILDING_SITE_CITY_AD));
            buildingDetails.setSiteAbbrStAd(request.getParameter(GCDConstants.LIST_BUILDING_SITE_ABBR_ST_AD));
            buildingDetails.setSitePstlCd(request.getParameter(GCDConstants.LIST_BUILDING_SITE_PSTL_CD));
            buildingDetails.setSiteIntlPstlCd(request.getParameter(GCDConstants.LIST_UPDATE_BUILDING_SITE_INTL_PSTL_CD));
            buildingDetails.setCtryCd(request.getParameter(GCDConstants.SEARCH_COUNTRY));
            buildingDetails.setSiteOffcPhne(request.getParameter(GCDConstants.LIST_UPDATE_BUILDING_SITE_OFFC_PHNE));
            buildingDetails.setSitePhneNu(request.getParameter(GCDConstants.LIST_UPDATE_BUILDING_SITE_PHNE_NU));
            buildingDetails.setSiteFaxNu(request.getParameter(GCDConstants.LIST_UPDATE_BUILDING_SITE_FAX_NU));
            buildingDetails.setSiteOffcDs(request.getParameter(GCDConstants.LIST_UPDATE_BUILDING_SITE_OFFC_DS));
            
            String str="";
            if(null != request.getParameter(GCDConstants.SITE_ID_NUM)){
                str = request.getParameter(GCDConstants.SITE_ID_NUM).trim();
            }
            
            if(str.equals("")){
                buildingDetails.setSiteId(0);
                buildingDetails.setSiteIdStr(null);
            
            }
            else{       
                buildingDetails.setSiteId(new Integer(request.getParameter(GCDConstants.SITE_ID_NUM).trim()).intValue());
                buildingDetails.setSiteIdStr(request.getParameter(GCDConstants.SITE_ID_NUM).trim());
            }           
            
            int value = iGCDFacade.maintainIntlBuilding(buildingDetails,sling);
            readOnly = "readonly";
            borderType = "noborder";
            formAction = null;
            infoText =  GCDConstants.BUILDING_UPDATED_MESSAGE;
            
        }
        else if(GCDConstants.UPDATE_BUILDING_DELETE_LINK.equals(formAction)){
                    
            try{    
                int value = iGCDFacade.deleteBuilding(new Integer(request.getParameter(GCDConstants.LIST_BUILDING_CODE)).intValue(),sling);
                
                formAction = null;
                buildingDetails = new BuildingDetails();
                readOnly = "";
                borderType = "";
                buildingDetails.setBldgCd(0);
                buildingDetails.setBldgNa("");
                buildingDetails.setSiteDs("");
                buildingDetails.setSiteL1Ad("");
                buildingDetails.setSiteL2Ad("");
                buildingDetails.setSiteL3Ad("");
                buildingDetails.setSiteL4Ad("");
                buildingDetails.setSiteL5Ad("");
                buildingDetails.setSiteCourierCd("");
                buildingDetails.setSiteCityAd("");
                buildingDetails.setSiteAbbrStAd("");
                buildingDetails.setSitePstlCd("");
                buildingDetails.setSiteIntlPstlCd("");
                buildingDetails.setCtryCd("");
                buildingDetails.setSiteCtryNa("");
                buildingDetails.setSitePhneNu("");
                buildingDetails.setSiteOffcPhne("");
                buildingDetails.setSiteFaxNu("");
                buildingDetails.setSiteOffcDs("");
                buildingDetails.setSiteId(0);
                
                formAction = null;
                infoText =  GCDConstants.BUILDING_DELETED_MESSAGE;
                    
            }catch(Exception e){
                log.error("Error inside the delete intl building ++++++++++++++");
            }
        }
        else{
            //If there is an addition of a new building 
            if( GCDConstants.UPDATE_BUILDING_DELETE_LINK.equals(formAction) || request.getParameter( GCDConstants.BUILDING_RECORD_TXF ) == null ){
                buildingDetails = new BuildingDetails();
                readOnly = "";
                borderType = "";
                buildingDetails.setBldgCd(0);
                buildingDetails.setBldgNa("");
                buildingDetails.setSiteDs("");
                buildingDetails.setSiteL1Ad("");
                buildingDetails.setSiteL2Ad("");
                buildingDetails.setSiteL3Ad("");
                buildingDetails.setSiteL4Ad("");
                buildingDetails.setSiteL5Ad("");
                buildingDetails.setSiteCourierCd("");
                buildingDetails.setSiteCityAd("");
                buildingDetails.setSiteAbbrStAd("");
                buildingDetails.setSitePstlCd("");
                buildingDetails.setSiteIntlPstlCd("");
                buildingDetails.setCtryCd("");
                buildingDetails.setSiteCtryNa("");
                buildingDetails.setSitePhneNu("");
                buildingDetails.setSiteOffcPhne("");
                buildingDetails.setSiteFaxNu("");
                buildingDetails.setSiteOffcDs("");
                buildingDetails.setSiteId(0);
            }
            else{   
                ArrayList buildingList = iGCDFacade.getBuildingNamesByBldgCode(new Integer((String)request.getParameter(GCDConstants.BUILDING_RECORD_TXF)).intValue(),sling);
                if(buildingList != null && buildingList.size() >= 1){
                    buildingDetails = (BuildingDetails)buildingList.get(0);
                }
                if(buildingDetails == null){
                    buildingDetails = new BuildingDetails();
                    readOnly = "";
                    borderType = "";
                    buildingDetails.setBldgCd(0);
                    buildingDetails.setBldgNa("");
                    buildingDetails.setSiteDs("");
                    buildingDetails.setSiteL1Ad("");
                    buildingDetails.setSiteL2Ad("");
                    buildingDetails.setSiteL3Ad("");
                    buildingDetails.setSiteL4Ad("");
                    buildingDetails.setSiteL5Ad("");
                    buildingDetails.setSiteCourierCd("");
                    buildingDetails.setSiteCityAd("");
                    buildingDetails.setSiteAbbrStAd("");
                    buildingDetails.setSitePstlCd("");
                    buildingDetails.setSiteIntlPstlCd("");
                    buildingDetails.setCtryCd("");
                    buildingDetails.setSiteCtryNa("");
                    buildingDetails.setSitePhneNu("");
                    buildingDetails.setSiteOffcPhne("");
                    buildingDetails.setSiteFaxNu("");
                    buildingDetails.setSiteOffcDs("");
                    buildingDetails.setSiteId(0);
                }   
            }
        }
        formAction=null;    
%>
        <table height="100%" cellSpacing=5 cellPadding=0 width="100%">
            <tr>
                <td>
                    <table class="gcddata" height="100%" cellSpacing=0 cellPadding=0 width="100%">
                        <tr>
                            <td width="100%" height="12" nowrap>
                                <%-- insert the GCD header file and pass the help parameters obtained from the session earlier --%>
                            </td>
                        </tr>
        
                        <tr height="100%">
                            <td class=mcdSkinPortletBorder dir=ltr style="PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px" vAlign=top width="100%">
                                <form name="frmmaintainintlbuilding" action="" method="GET">
                                    <table class="gcdcontentlnkhd" width="100%" cellpadding="0" cellspacing="1">
                                        <tr>
                                            <td colspan="2" class="contentlnk">
                                                <input type="hidden" name="<%= GCDConstants.FORMACTION %>" value=""/>
                                            </td>
                                        </tr>
        
                                        <tr>
                                            <td colSpan=2>
                                                <B></B>
                                            </td>
                                        </tr>
        
                                        <tr>
                                            <td colspan="2" class="contentlnk">
                                                <b><%= infoText %></b>
                                            </td>
                                        </tr>
        
                                        <tr>
                                            <td colspan="2">&nbsp;</td>
                                        </tr>
        
                                        <%-- Building Code --%>
                                        <tr>
                                            <td width="15%" class="contentlnk">
                                                <%=langText.get("INTL Building Code")%><span class="errorMsg">*</span>
                                            </td>
                                            <td>
                                                <input type="text" style="FONT-SIZE: 11px; COLOR: #000000;LINE-HEIGHT: 135%; FONT-FAMILY: Arial, Helvetica, sans-serif; TEXT-DECORATION: none;" class="<%= borderType %>" size="10" maxlength="5" name="<%= GCDConstants.LIST_BUILDING_CODE %>" value="<%= buildingDetails.getBldgCd() %>" <%= readOnly %> />
                                            </td>
                                        </tr>
                                        <%-- Show Building Code Validation Message --%>
                                        <tr>
                                            <td width="15%" class="contentlnk"></td>
                                            <td>
                                                <div id="bldcodealert" align="left" style="color: rgb(153, 0, 0); margin-bottom:2px;display: none;"><%=langText.get("INTL Building Code Validation Message")%></div>
                                            </td>    
                                        </tr>
                                        
                                        <%-- Building Name --%>
                                        <tr>
                                            <td class="contentlnk">
                                                <%=langText.get("INTL Building Name")%><span class="errorMsg">*</span>
                                            </td>
                                            <td>
                                                <input type="text" class="gcdcontentlnkhd" size="50" maxlength="75" name="<%= GCDConstants.LIST_BUILDING_NAME %>" value="<%= buildingDetails.getBldgNa().toUpperCase() %>" />
                                            </td>
                                        </tr>
                                        <%-- Show Building Name Validation Message --%>
                                        <tr>
                                            <td class="contentlnk"></td>
                                            <td>
                                                <div id="bldnamealert" align="left" style="color: rgb(153, 0, 0); margin-bottom:2px;display: none;"><%=langText.get("INTL Building Name Validation Message")%></div>
                                            </td>
                                        </tr>
                                        
                                        <%-- Site ID Number --%>
                                        <tr>
                                            <td width="15%" class="contentlnk">
                                                <%=langText.get("INTL Site ID Number")%>
                                            </td>
                                            <td>
                                                <input type="text" class="gcdcontentlnkhd" size="50"  maxlength="7" name="<%= GCDConstants.SITE_ID_NUM %>" value="<%= buildingDetails.getSiteId() %>"  />
                                            </td>
                                        </tr>
                                        <%-- Show Site ID Number Validation Message --%>
                                        <tr>
                                            <td width="15%" class="contentlnk"></td>
                                            <td>
                                                <div id="bldsiteidalert" align="left" style="color: rgb(153, 0, 0); margin-bottom:2px;display: none;"><%=langText.get("INTL Site ID Number Validation Message")%></div>
                                            </td>
                                        </tr>
                                        
                                        <%-- Building Description --%>
                                        <tr>
                                            <td class="contentlnk">
                                                <%=langText.get("INTL Building Description")%>
                                            </td>
                                            <td>
                                                <input type="text" class="gcdcontentlnkhd" size="50" maxlength="50" name="<%= GCDConstants.LIST_BUILDING_SITE_DS %>" value="<%= buildingDetails.getSiteDs().toUpperCase() %>" />
                                            </td>
                                        </tr>
                                        
                                        <%-- Address 1 --%>
                                        <tr>
                                            <td class="contentlnk">
                                                <%=langText.get("INTL Address 1 Maintain")%>
                                            </td>
                                            <td>
                                                <input type="text" class="gcdcontentlnkhd" size="50" maxlength="50" name="<%= GCDConstants.LIST_BUILDING_SITE_AD_L1 %>" value="<%= buildingDetails.getSiteL1Ad().toUpperCase() %>" />
                                            </td>
                                        </tr>
        
                                        <%-- Address 2 --%>
                                        <tr>
                                            <td class="contentlnk">
                                                <%=langText.get("INTL Address 2 Maintain")%>
                                            </td>
                                            <td>
                                                <input type="text" class="gcdcontentlnkhd" size="50" maxlength="40" name="<%= GCDConstants.LIST_BUILDING_SITE_AD_L2 %>" value="<%= buildingDetails.getSiteL2Ad().toUpperCase() %>" />
                                            </td>
                                        </tr>
        
                                        <%-- Address 3 --%>
                                        <tr>
                                            <td class="contentlnk">
                                                <%=langText.get("INTL Address 3 Maintain")%>
                                            </td>
                                            <td>
                                                <input type="text" class="gcdcontentlnkhd" size="50" maxlength="50" name="<%= GCDConstants.LIST_BUILDING_SITE_AD_L3 %>" value="<%= buildingDetails.getSiteL3Ad().toUpperCase() %>" />
                                            </td>
                                        </tr>
                                        
                                        <%-- Address 4 --%>
                                        <tr>
                                            <td class="contentlnk">
                                                <%=langText.get("INTL Address 4 Maintain")%>
                                            </td>
                                            <td>
                                                <input type="text" class="gcdcontentlnkhd" size="50" maxlength="40" name="<%= GCDConstants.LIST_BUILDING_SITE_AD_L4 %>" value="<%= buildingDetails.getSiteL4Ad().toUpperCase() %>" />
                                            </td>
                                        </tr>
                                        
                                        <%-- Address 5 --%>
                                        <tr>
                                            <td class="contentlnk">
                                                <%=langText.get("INTL Address 5 Maintain")%>
                                            </td>
                                            <td>
                                                <input type="text" class="gcdcontentlnkhd" size="50" maxlength="40" name="<%= GCDConstants.LIST_BUILDING_SITE_AD_L5 %>" value="<%= buildingDetails.getSiteL5Ad().toUpperCase() %>" />
                                            </td>
                                        </tr>
        
                                        <%-- City --%>
                                        <tr>
                                            <td class="contentlnk">
                                                <%=langText.get("INTL City")%>
                                            </td>
                                            <td>
                                                <input type="text" class="gcdcontentlnkhd" size="25" maxlength="40" name="<%= GCDConstants.LIST_BUILDING_SITE_CITY_AD %>" value="<%= buildingDetails.getSiteCityAd().toUpperCase() %>" />
                                            </td>
                                        </tr>
        
                                        <%-- State --%>
                                        <tr>
                                            <td class="contentlnk">
                                                <%=langText.get("INTL State")%>
                                            </td>
                                            <td>
                                                <input type="text" class="gcdcontentlnkhd" size="10" maxlength="2" name="<%= GCDConstants.LIST_BUILDING_SITE_ABBR_ST_AD %>" value="<%= buildingDetails.getSiteAbbrStAd().toUpperCase() %>" />
                                            </td>
                                        </tr>
        
                                        <%-- Postal Code --%>
                                        <tr>
                                            <td class="contentlnk">
                                                <%=langText.get("INTL Postal Code Maintain")%>
                                            </td>
                                            <td>
                                                <input type="text" class="gcdcontentlnkhd" size="25" maxlength="10" name="<%= GCDConstants.LIST_BUILDING_SITE_PSTL_CD %>" value="<%= buildingDetails.getSitePstlCd().toUpperCase() %>" />
                                            </td>
                                        </tr>
        
                                        <%-- Intl Postal Code --%>
                                        <tr>
                                            <td class="contentlnk">
                                                <%=langText.get("INTL Postal Code Intl Maintain")%>
                                            </td>
                                            <td>
                                                <input type="text" class="gcdcontentlnkhd" size="25" maxlength="20" name="<%= GCDConstants.LIST_UPDATE_BUILDING_SITE_INTL_PSTL_CD %>" value="<%= buildingDetails.getSiteIntlPstlCd().toUpperCase() %>" />
                                            </td>
                                        </tr>
                                        
                                        <%-- Courier Code --%>
                                        <tr>
                                            <td class="contentlnk">
                                                <%=langText.get("INTL Courier Code")%>
                                            </td>
                                            <td>
                                                <input type="text" class="gcdcontentlnkhd" size="25" maxlength="10" name="<%= GCDConstants.LIST_UPDATE_BUILDING_SITE_COURIER_CD %>" value="<%= buildingDetails.getSiteCourierCd().toUpperCase() %>" />
                                            </td>
                                        </tr>
        
                                        <%-- Country Code --%>
                                        <tr>
                                            <td class="contentlnk">
                                                <%=langText.get("INTL Country Name")%>
                                            </td>
                                            <td>    
                                                <select name="<%= GCDConstants.SEARCH_COUNTRY %>" style="font-size:11px;font-family:Arial,Helvetica,sans-serif;">
<% 
                                                    // Iterating through all the countries
                                                    for( int i=0; i<allActiveCountryNames.size(); i++  ){
                                                        CountryDetails countryDetails = new CountryDetails();
                                                        countryDetails = (CountryDetails)allActiveCountryNames.get(i);
                                                    
                                                        if( countryDetails.getCtryCd().equals(GCDConstants.COUNTRY_ALL))
                                                            continue;
%>
                                                        <option class="gcdcontentlnkhd" value="<%= countryDetails.getCtryCd() %>"<%= ( buildingDetails.getCtryCd().equals(countryDetails.getCtryCd())? "selected='selected'" : ""   )%> ><%= countryDetails.getCtryCd() %>-<%= countryDetails.getCtryNm() %></option>
<%
                                                    } 
%>
                                                </select>
                                            </td>
                                        </tr>   
        
                                        <%-- Building Phone --%>
                                        <tr>
                                            <td class="contentlnk">
                                                <%=langText.get("INTL Building Phone")%>
                                            </td>
                                            <td>
                                                <input type="text" class="gcdcontentlnkhd" size="20" maxlength="15" name="<%= GCDConstants.LIST_UPDATE_BUILDING_SITE_OFFC_PHNE %>" value="<%= buildingDetails.getSiteOffcPhne().toUpperCase() %>" />
                                            </td>
                                        </tr>
                                        <%-- Show Building Phone Validation Message --%>
                                        <tr>
                                            <td class="contentlnk"></td>
                                            <td>
                                                <div id="bldphonealert" align="left" style="color: rgb(153, 0, 0); margin-bottom:2px;display: none;"><%=langText.get("INTL Building Phone Validation Message")%></div>
                                            </td>
                                        </tr>
                                        
                                        <%-- Intl Phone Number --%>
                                        <tr>
                                            <td class="contentlnk">
                                                <%=langText.get("INTL Phone Number")%>
                                            </td>
                                            <td class="contentlnk">
                                                <input type="text" class="gcdcontentlnkhd" size="20" maxlength="45" name="<%= GCDConstants.LIST_UPDATE_BUILDING_SITE_PHNE_NU %>" value="<%= buildingDetails.getSitePhneNu().toUpperCase() %>" />
                                            </td>
                                        </tr>
        
                                        <%-- Fax --%>
                                        <tr>
                                            <td class="contentlnk">
                                                <%=langText.get("INTL Fax")%>
                                            </td>
                                            <td>
                                                <input type="text" class="gcdcontentlnkhd" size="20" maxlength="45" name="<%= GCDConstants.LIST_UPDATE_BUILDING_SITE_FAX_NU %>" value="<%= buildingDetails.getSiteFaxNu().toUpperCase() %>" />
                                            </td>
                                        </tr>
        
                                        <%-- Office Description --%>
                                        <tr>
                                            <td class="contentlnk">
                                                <%=langText.get("INTL Office Desc")%>
                                            </td>
                                            <td class="contentlnk">
                                                <input type="text" class="gcdcontentlnkhd" size="20" maxlength="20" name="<%= GCDConstants.LIST_UPDATE_BUILDING_SITE_OFFC_DS %>" value="<%= buildingDetails.getSiteOffcDs().toUpperCase() %>" />
                                            </td>
                                        </tr>
        
                                        <tr>
                                            <td colspan="2">&nbsp;</td>
                                        </tr>
        
                                    </table>
        
                                    <%-- show page links --%>
                                    <table width="100%" align="center" cellpadding="0" cellspacing="0">
                                        <%-- building save, delete and exit links --%>
                                        <tr>
                                            <td align="left">
                                                <a href="#" class="contentlnk" onclick="document.frmmaintainintlbuilding.<%= GCDConstants.FORMACTION %>.value='<%= GCDConstants.UPDATE_BUILDING_SAVE_LINK %>';return validate();"><%=saveLinkLabel%></a>
<%
                                                if(readOnly.equals("readonly")){
%>          
                                                    &nbsp;&nbsp;&nbsp;<a href="#" class="contentlnk" onclick="document.frmmaintainintlbuilding.<%= GCDConstants.FORMACTION %>.value='<%= GCDConstants.UPDATE_BUILDING_DELETE_LINK %>'; frmmaintainintlbuilding.submit();"><%=deleteLinkLabel%></a>
<%
                                                }
                                                if(!cancelLinkURL.equals(""))
                                                {
%>
                                                &nbsp;&nbsp;&nbsp;
                                                <a href="<%=cancelLinkURL%>" class="contentlnk"><%=cancelLinkLabel%></a>
<%
                                                 }
                                                 else   
                                                 {
%>                                                 &nbsp;&nbsp;&nbsp;
                                                   <a href="javascript:cancel()" class="contentlnk"><%=cancelLinkLabel%></a>
                                                 
<%                                               }
                                                  if(!"".equals(Helppath.trim()))
                                                                    {
%>
                                                                    &nbsp;&nbsp;&nbsp;
                                                                    <a href="javascript:openWindow('<%= commonUtil.getValidURL(Helppath) %>','<%= properties.get("helpHeight","800")%>','<%= properties.get("helpWidth","1000")%>')" id = "help1" class="contentlnk"><%= properties.get("helpLabel",langText.get("Help"))%></a>
<%    
                                                                    }
%>
                                            </td>
                                        </tr>
                                    </table>
                                </form>
                            </td>
                        </tr>
                  </table>
                </td>
            </tr>
        </table>
<%
    }
    catch(Exception e){
        out.println("<h3 style='color:red;'>" + GCDConstants.ERROR_GCD_DATABASE_ERROR +"</h3>");
        log.error("",e);
    }
%>  
<script type="text/javascript">

    // regular expression representing valid building code(s)
    var validBldgCd1 = /^\d+$/; 

    // regular expressions representing valid phone numbers
    var validSiteid = /^\d+$/;
    var validPhone1 = /^\d\d\d\d\d\d\d\d\d\d$/; 
    var validPhone6 = /^\(\d\d\d\)\d\d\d-\d\d\d\d$/; 
    var validPhone7 = /^\d\d\d-\d\d\d-\d\d\d\d$/; 
    var validPhone8 = /^\(\d\d\d\) \d\d\d-\d\d\d\d$/; 

    // Functions to remove space from begining and end of the string.
    function LTrim( value ) {
        var re = /\s*((\S+\s*)*)/;
        return value.replace(re, "$1");
    }
    
    // Removes ending whitespaces
    function RTrim( value ) {
        var re = /((\s*\S+)*)\s*/;
        return value.replace(re, "$1");
    }

    // Removes leading and ending whitespaces
    function trim( value ) {
        return LTrim(RTrim(value));
    }

    // reformat site id
    function formatSiteId(fieldObject){
        var oldSiteId = fieldObject.value;
        // valid format is one or more digits
        if(oldSiteId==null || oldSiteId=="" || oldSiteId.length==0 || oldSiteId=="0" || validSiteid.test(oldSiteId)){
            fieldObject.value = oldSiteId;
            return true;
        }
        return false;
    }

    // reformat bldg codes
    function formatBldgCode(fieldObject){
        var oldBldgCd = fieldObject.value;
        if( oldBldgCd==null || oldBldgCd=="" || oldBldgCd.length==0 || oldBldgCd=="0" || oldBldgCd==0){
            return false;
        }

              // valid format is one or more digits
        if( validBldgCd1.test(oldBldgCd)){
            fieldObject.value = oldBldgCd;
            return true;
        }
        return false;    
    }

    //format bldg names
    function formatBldgName( fieldObject){
        var oldBldgName = fieldObject.value;
        if( oldBldgName==null || trim(oldBldgName)==""){
            return false;
        }
    }
    // reformat phone numbers
    function formatPhoneNumber( fieldObject ){
        var oldPhoneNumber = fieldObject.value;
        if( oldPhoneNumber==null || oldPhoneNumber=="" || oldPhoneNumber.length==0){
            return true;
        }

        // valid format is: 7777777777
        if(validPhone1.test(oldPhoneNumber)){
            // reformat the number for display
            fieldObject.value = "(" + oldPhoneNumber.substring(0,3) + ") " +
                                oldPhoneNumber.substring(3,6) + "-" +
                                oldPhoneNumber.substring(6,10);
            return true;
        }   
    
        // valid format is: (777)777-7777
        if(validPhone6.test(oldPhoneNumber)){
            // reformat the number for display
            fieldObject.value = "(" + oldPhoneNumber.substring(1,4) + ") " +
                                oldPhoneNumber.substring(5,8) + "-" +
                                oldPhoneNumber.substring(9,13);
            return true;
        }

        // valid format is: 777-777-7777
        if(validPhone7.test(oldPhoneNumber)){
            // reformat the number for display
            fieldObject.value = "(" + oldPhoneNumber.substring(0,3) + ") " +
                                oldPhoneNumber.substring(4,7) + "-" +
                                oldPhoneNumber.substring(8,12);
            return true;
        }       

        // valid format is: (777) 777-7777
        if(validPhone8.test(oldPhoneNumber)){
            return true;
        }
    
        return false;                   
    }      
         
         

    function validate(){
        
        var temp =0;
        
        if(formatBldgCode(document.frmmaintainintlbuilding.<%= GCDConstants.LIST_BUILDING_CODE %>) == false){
            $('#bldcodealert').show();
            document.frmmaintainintlbuilding.<%= GCDConstants.LIST_BUILDING_CODE %>.focus();
           temp =1;
        }
        else{
            $('#bldcodealert').hide();
        }
        
        if(formatSiteId(document.frmmaintainintlbuilding.<%= GCDConstants.SITE_ID_NUM %>) == false){
            $('#bldsiteidalert').show();
            document.frmmaintainintlbuilding.<%= GCDConstants.SITE_ID_NUM %>.value = "";
            document.frmmaintainintlbuilding.<%= GCDConstants.SITE_ID_NUM %>.focus();
           temp =1;
        }
        else{
            $('#bldsiteidalert').hide();
        }
        
        if(formatPhoneNumber(document.frmmaintainintlbuilding.<%= GCDConstants.LIST_UPDATE_BUILDING_SITE_OFFC_PHNE %>) == false){
            $('#bldphonealert').show();
            document.frmmaintainintlbuilding.<%= GCDConstants.LIST_UPDATE_BUILDING_SITE_OFFC_PHNE %>.focus();
           temp =1;
        }
        else{
            $('#bldphonealert').hide();
        }
    
        if(formatBldgName(document.frmmaintainintlbuilding.<%= GCDConstants.LIST_BUILDING_NAME %>) == false){
             $('#bldnamealert').show();
             document.frmmaintainintlbuilding.<%= GCDConstants.LIST_BUILDING_NAME %>.focus();
             temp =1;
        }
        else{
            $('#bldnamealert').hide();
        }
       if(temp ==1)
        return false;
       document.frmmaintainintlbuilding.submit();
       return true;
    }
    
     $(document).ready(function() {
   // put all your jQuery goodness in here.
   
   $('input[type="text"]').each(function(){
    $(this).attr('rel','')
    });
    });
        
</script>         