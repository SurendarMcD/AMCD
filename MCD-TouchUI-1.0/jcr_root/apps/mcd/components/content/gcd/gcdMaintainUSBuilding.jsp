<%@ page session="false" contentType="text/html" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.mcd.accessmcd.gcd.facade.*" %>
<%@ page import="com.mcd.accessmcd.gcd.bean.BuildingDetails" %>
<%@ page import="com.mcd.accessmcd.gcd.constants.GCDConstants" %>
<%@ page import="com.mcd.accessmcd.common.helper.PropertyHelper"%>
<%@ page import="com.mcd.accessmcd.util.CommonUtil"%>
<%@ page import="com.day.cq.i18n.I18n"%>

<script type="text/javascript">
function validate()
{

    var temp =0 ;
    if( formatBldgCode(document.frmmaintainusbuilding.<%= GCDConstants.LIST_BUILDING_CODE %>) == false )
    {
        $('#usbldcodealert').show();
        document.frmmaintainusbuilding.<%= GCDConstants.LIST_BUILDING_CODE %>.focus();
        temp =1;
    }
    else
    {
        $('#usbldcodealert').hide();
    }

    if( formatPhoneNumber(document.frmmaintainusbuilding.<%= GCDConstants.LIST_UPDATE_BUILDING_SITE_OFFC_PHNE %>) == false )
    {
        $('#usbldphonealert').show();
        document.frmmaintainusbuilding.<%= GCDConstants.LIST_UPDATE_BUILDING_SITE_OFFC_PHNE %>.focus();
        temp =1;
    }
    else
    {
        $('#usbldphonealert').hide();
    }

    if( formatBldgName(document.frmmaintainusbuilding.<%= GCDConstants.LIST_BUILDING_NAME %>) == false )
    {
         $('#usbldnamealert').show();
         document.frmmaintainusbuilding.<%= GCDConstants.LIST_BUILDING_NAME %>.focus();
         temp =1;

    }
    else
    {
        $('#usbldnamealert').hide();
    }
 
    if(temp ==1)
     return false;
    document.frmmaintainusbuilding.submit();
    return true;

}

 $(document).ready(function() {
   // put all your jQuery goodness in here.
   
   $('input[type="text"]').each(function(){
    $(this).attr('rel','')
});
 });
      
</script>
<%!
    //Declaring the variables
    String usreadOnly = null;
    String usborderType = null;
%>

<%

    //Declaring the common variables
    BuildingDetails usbuildingDetails=null;
    String usreadOnly = "readonly";
    String usborderType = "noborder";
    HttpSession session=null;
    CommonUtil commonUtil = new CommonUtil(); 
    String usformAction="";
    String infoText = "";
      
    //Fetching the dialog field values
    String deleteLinkURL=properties.get("usDeleteLink","");
    String cancelLinkURL=properties.get("usCancelLink",""); 
    String Helppath = properties.get("helpPath","");
    
    //Reading field labels from i18n nodes
    String usBuildCode=langText.get("Building Code");
    String usBuildName=langText.get("Building Name");
    String usBuildDescript=langText.get("Building Description");
    String usBuildAdd1=langText.get("Address 1");
    String usBuildAdd2=langText.get("Address 2");
    String usBuildCity=langText.get("City");
    String usBuildState=langText.get("State");
    String usBuildPCode=langText.get("Postal Code");
    String usBuildPhone=langText.get("Building Phone");
    String usSaveLinkLabel=langText.get("Save");
    String usDeleteLinkLabel=langText.get("Delete");
    String usCancelLinkLabel=langText.get("Cancel");
    
    try {
        
        // get GCDFacadeImpl Object     
        IGCDFacade usiGCDFacade= new GCDFacadeImpl();
        usformAction=request.getParameter(GCDConstants.FORMACTION);
        if(GCDConstants.UPDATE_BUILDING_SAVE_LINK.equals(usformAction))
            {
                usbuildingDetails=new BuildingDetails();
                usbuildingDetails.setBldgCd(new Integer(request.getParameter(GCDConstants.LIST_BUILDING_CODE)).intValue());
                usbuildingDetails.setBldgNa(request.getParameter(GCDConstants.LIST_BUILDING_NAME));
                usbuildingDetails.setSiteDs(request.getParameter(GCDConstants.LIST_BUILDING_SITE_DS));
                usbuildingDetails.setSiteL1Ad(request.getParameter(GCDConstants.LIST_BUILDING_SITE_AD_L1));
                usbuildingDetails.setSiteL2Ad(request.getParameter(GCDConstants.LIST_BUILDING_SITE_AD_L2));
                usbuildingDetails.setSiteCityAd(request.getParameter(GCDConstants.LIST_BUILDING_SITE_CITY_AD));
                usbuildingDetails.setSiteAbbrStAd(request.getParameter(GCDConstants.LIST_BUILDING_SITE_ABBR_ST_AD));
                usbuildingDetails.setSitePstlCd(request.getParameter(GCDConstants.LIST_BUILDING_SITE_PSTL_CD));
                usbuildingDetails.setSiteOffcPhne(request.getParameter(GCDConstants.LIST_UPDATE_BUILDING_SITE_OFFC_PHNE));
                int value= usiGCDFacade.maintainUSBuilding(usbuildingDetails,sling);
                usreadOnly = "readonly";
                usborderType = "noborder";  
                infoText =  GCDConstants.BUILDING_UPDATED_MESSAGE;   
            }
            else if(GCDConstants.UPDATE_BUILDING_DELETE_LINK.equals(usformAction))
            {
                try{    
                        int value= usiGCDFacade.deleteBuilding(new Integer(request.getParameter(GCDConstants.LIST_BUILDING_CODE)).intValue(),sling);
                        
                        usformAction=null;
                        usbuildingDetails=new BuildingDetails();
                        usreadOnly = "";
                        usborderType = "";
                        usbuildingDetails.setBldgCd(0);
                        usbuildingDetails.setBldgNa("");
                        usbuildingDetails.setSiteDs("");
                        usbuildingDetails.setSiteL1Ad("");
                        usbuildingDetails.setSiteL2Ad("");
                        usbuildingDetails.setSiteCityAd("");
                        usbuildingDetails.setSiteAbbrStAd("");
                        usbuildingDetails.setSitePstlCd("");
                        usbuildingDetails.setCtryCd("");
                        usbuildingDetails.setSiteOffcPhne("");
                        infoText =  GCDConstants.BUILDING_DELETED_MESSAGE;
                        if(!(deleteLinkURL.trim()).equals(""))
                        {
                        %>   
                         <script>
                         alert('<%= infoText %>');
                         window.location.href = '<%= commonUtil.getValidURL(deleteLinkURL) %>';
                         </script>
                        <%                        
                      //  response.sendRedirect(commonUtil.getValidURL(deleteLinkURL));
                        }
                        
                    }
                    catch(Exception e)
                    {
                    %>
                       <!-- // if the database is not available or connection is null then set the correct error message -->
                       <div class="errorMsg"><%= GCDConstants.ERROR_GCD_DATABASE_ERROR %></div>  
                    <%                  
                    }
            } 
            else
            {
                //If there is an addition of a new building 
                if( GCDConstants.UPDATE_BUILDING_DELETE_LINK.equals(usformAction) || request.getParameter( GCDConstants.BUILDING_RECORD_TXF ) == null )
                {
                        usbuildingDetails=new BuildingDetails();
                        usreadOnly = "";
                        usborderType = "";
                        usbuildingDetails.setBldgCd(0);
                        usbuildingDetails.setBldgNa("");
                        usbuildingDetails.setSiteDs("");
                        usbuildingDetails.setSiteL1Ad("");
                        usbuildingDetails.setSiteL2Ad("");
                        usbuildingDetails.setSiteCityAd("");
                        usbuildingDetails.setSiteAbbrStAd("");
                        usbuildingDetails.setSitePstlCd("");
                        usbuildingDetails.setCtryCd("");
                        usbuildingDetails.setSiteOffcPhne("");
                }
                else
                {   
                        ArrayList usbuildingList=usiGCDFacade.getBuildingNamesByBldgCode(new Integer((String)request.getParameter( GCDConstants.BUILDING_RECORD_TXF)).intValue(),sling);
                        if(usbuildingList!=null && usbuildingList.size()>=1)
                        {
                            usbuildingDetails=(BuildingDetails)usbuildingList.get(0);
                        }
                    
                        if(usbuildingDetails==null)
                        {
                            usbuildingDetails=new BuildingDetails();
                            usreadOnly = "";
                            usborderType = "";
                            usbuildingDetails.setBldgCd(0);
                            usbuildingDetails.setBldgNa("");
                            usbuildingDetails.setSiteDs("");
                            usbuildingDetails.setSiteL1Ad("");
                            usbuildingDetails.setSiteL2Ad("");
                            usbuildingDetails.setSiteCityAd("");
                            usbuildingDetails.setSiteAbbrStAd("");
                            usbuildingDetails.setSitePstlCd("");
                            usbuildingDetails.setCtryCd("");
                            usbuildingDetails.setSiteOffcPhne("");
                        }   
                }
    
        
            }
        
        usformAction=null;
     
        }
        catch(Exception e)
        {
         log.error("ERROR " + e.getMessage()); 
        %>
            <!-- // if the database is not available or connection is null then set the correct error message -->
            <div class="errorMsg"><%= GCDConstants.ERROR_GCD_DATABASE_ERROR %></div> 
        <%    
        }
%>    

<table height="100%" cellSpacing=5 cellPadding=0 width="100%">       
    <tr>
        <td>
            <table class="gcddata" height="100%" cellSpacing=0 cellPadding=0 width="100%">
                <tr height="100%">
                    <td class=gcdSkinBorder dir=ltr style="PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px" vAlign=top width="100%">
                        <form name="frmmaintainusbuilding" action="" method="get">
                            <table class="gcdcontentlnkhd" width="100%" cellpadding="0" cellspacing="1">
                                <tr>
                                    <td colspan="2">
                                        <input type="hidden" name="<%= GCDConstants.FORMACTION %>" value=""/>
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
                                        <%=usBuildCode%>
                                        <span class="errorMsg">*</span>
                                    </td>
                                    <td>                                  
                                        <input type="text" style="FONT-SIZE: 11px; COLOR: #000000;LINE-HEIGHT: 135%; FONT-FAMILY: Arial, Helvetica, sans-serif; TEXT-DECORATION: none;" class="<%= usborderType %>" size="10" maxlength="5" name="<%= GCDConstants.LIST_BUILDING_CODE %>" value="<%= usbuildingDetails.getBldgCd() %>" <%= usreadOnly %> />
                                    </td>
                                </tr>
              
                                <%-- Show Building Code Validation Message --%>
                                <tr>
                                    <td width="15%" class="contentlnk"></td>
                                    <td>
                                         <div id="usbldcodealert" align="left" style="color: rgb(153, 0, 0); margin-bottom:2px;display: none;">Building Code cannot be 0, blank or non-numeric. Enter a non-zero numeric value.</div>
                                    </td>    
                                </tr>
              
                                <%-- Building Name --%>                                
                                <tr>                                   
                                    <td class="contentlnk">
                                       <%=usBuildName%>
                                       <span class="errorMsg">*</span>
                                    </td>
                                    <td>
                                       <input type="text" class="gcdcontentlnkhd" size="50" maxlength="75" name="<%= GCDConstants.LIST_BUILDING_NAME %>" value="<%= usbuildingDetails.getBldgNa().toUpperCase() %>" />
                                    </td>
                                </tr>
        
                                <%-- Show Building Name Validation Message --%>
                                <tr>
                                    <td class="contentlnk"></td>
                                    <td>
                                        <div id="usbldnamealert" align="left" style="color: rgb(153, 0, 0); margin-bottom:2px;display: none;">You need to enter some valid name in Building Name.</div>
                                    </td>
                                 </tr>
                                        
                                <%-- Building Description --%>  
                                <tr>
                                    <td class="contentlnk">
                                        <%=usBuildDescript%>
                                    </td>
                                    <td>
                                        <input type="text" class="gcdcontentlnkhd" size="50" maxlength="50" name="<%= GCDConstants.LIST_BUILDING_SITE_DS %>" value="<%= usbuildingDetails.getSiteDs().toUpperCase() %>" />
                                    </td>
                                </tr>
        
                                <%-- Address 1 --%>
                                <tr>
                                    <td class="contentlnk">
                                        <%=usBuildAdd1%>
                                    </td>
                                    <td>
                                        <input type="text" class="gcdcontentlnkhd" size="50" maxlength="50" name="<%= GCDConstants.LIST_BUILDING_SITE_AD_L1 %>" value="<%= usbuildingDetails.getSiteL1Ad().toUpperCase() %>" />
                                    </td>
                                </tr>
        
                                <%-- Address 2 --%>
                                <tr>
                                    <td class="contentlnk">
                                        <%=usBuildAdd2%>
                                    </td>
                                    <td>
                                        <input type="text" class="gcdcontentlnkhd" size="50" maxlength="40" name="<%= GCDConstants.LIST_BUILDING_SITE_AD_L2 %>" value="<%= usbuildingDetails.getSiteL2Ad().toUpperCase() %>" />
                                    </td>
                                </tr>
        
                                <%-- City --%>                               
                                <tr>
                                    <td class="contentlnk">
                                        <%=usBuildCity%>
                                    </td>
                                    <td>
                                        <input type="text" class="gcdcontentlnkhd" size="25" maxlength="40" name="<%= GCDConstants.LIST_BUILDING_SITE_CITY_AD %>" value="<%= usbuildingDetails.getSiteCityAd().toUpperCase() %>" />
                                    </td>
                                </tr>
        
                                <%-- State --%> 
                                <tr>
                                    <td class="contentlnk">
                                        <%=usBuildState%>
                                    </td>
                                    <td>
                                        <input type="text" class="gcdcontentlnkhd" size="10" maxlength="2" name="<%= GCDConstants.LIST_BUILDING_SITE_ABBR_ST_AD %>" value="<%= usbuildingDetails.getSiteAbbrStAd().toUpperCase() %>" />
                                    </td>
                                </tr>
        
                                <%-- Building Postal Code --%>    
                                <tr>
                                    <td class="contentlnk">
                                        <%=usBuildPCode%>
                                    </td>
                                    <td>
                                        <input type="text" class="gcdcontentlnkhd" size="25" maxlength="10" name="<%= GCDConstants.LIST_BUILDING_SITE_PSTL_CD %>" value="<%= usbuildingDetails.getSitePstlCd().toUpperCase() %>" />
                                    </td>
                                </tr>

                                <%-- Building Phone --%>  
                                <tr>
                                    <td class="contentlnk">
                                        <%=usBuildPhone%>
                                    </td>
                                    <td>
                                        <input type="text" class="gcdcontentlnkhd" size="20" maxlength="15" name="<%= GCDConstants.LIST_UPDATE_BUILDING_SITE_OFFC_PHNE %>" value="<%= usbuildingDetails.getSiteOffcPhne().toUpperCase() %>" />
                                    </td>
                                </tr>
        
                                 <%-- Show Building Phone Validation Message --%>
                                 <tr>
                                    <td class="contentlnk"></td>
                                    <td>
                                        <div id="usbldphonealert" align="left" style="color: rgb(153, 0, 0); margin-bottom:2px;display: none;">Enter Building Phone as: (000) 000-0000.</div>
                                    </td>
                                 </tr>
         
                                 <tr>
                                 <td colspan="2">&nbsp;</td>
                                 </tr>

                            </table>

                            <%-- show page links --%>
                            <table   width="100%" align="center" cellpadding="0" cellspacing="0">

                                <%-- building save,delete and exit links --%>
                                <tr>
                                    <td align="left">                               
                                        <a href="#" class="contentlnk" onclick="document.frmmaintainusbuilding.<%= GCDConstants.FORMACTION %>.value='<%= GCDConstants.UPDATE_BUILDING_SAVE_LINK %>';return validate();"><%=usSaveLinkLabel%></a>  
                                        <%
                                        if( usreadOnly.equals("readonly") )
                                        {
                                        %>    
                                            &nbsp;&nbsp;&nbsp;      
                                            <a href="#" class="contentlnk" onclick="document.frmmaintainusbuilding.<%= GCDConstants.FORMACTION %>.value='<%= GCDConstants.UPDATE_BUILDING_DELETE_LINK %>'; frmmaintainusbuilding.submit();"><%=usDeleteLinkLabel%></a>
                                        <%
                                        }
                                        if(!(cancelLinkURL.trim()).equals(""))
                                        {                                            
                                        %>
                                                &nbsp;&nbsp;&nbsp;
                                                <a href="<%=commonUtil.getValidURL(cancelLinkURL)%>" class="contentlnk"><%=usCancelLinkLabel%></a>
                                        <%
                                        } 
                                        else
                                        {
                                        %>
                                                 &nbsp;&nbsp;&nbsp;
                                                 <a href="javascript:cancel()" class="contentlnk"><%=usCancelLinkLabel%></a>
                                        <%
                                        }
                                        if(!(Helppath.trim()).equals("")) 
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

