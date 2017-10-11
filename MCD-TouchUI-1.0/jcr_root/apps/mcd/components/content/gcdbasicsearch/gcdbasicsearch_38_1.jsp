<%--

  GCD Form component.

  css being referred for employee directory is us_g2g_red in designs(/etc/designs/mcd/accessmcd/g2g/us_g2g_red/static.css)
 
--%>
<%@include file="/apps/mcd/global/global.jsp"%>
<%@page session="false" %>
<%@ page import="com.day.cq.wcm.foundation.Image, 
    com.day.cq.wcm.foundation.TextFormat,
    com.day.cq.wcm.foundation.DiffInfo,
    com.day.cq.wcm.foundation.DiffService,
    org.apache.commons.lang.StringEscapeUtils,
    com.day.cq.wcm.api.components.DropTarget,
    com.day.cq.wcm.api.WCMMode,
    org.apache.sling.api.resource.ResourceUtil,
    org.apache.sling.api.resource.ValueMap,
    java.util.Iterator,
    com.day.cq.wcm.api.PageFilter,
    java.util.Random,
    com.mcd.accessmcd.gcd.facade.*,
    com.mcd.accessmcd.gcd.manager.*,
    com.mcd.accessmcd.gcd.constants.GCDConstants,
    com.mcd.accessmcd.gcd.bean.CountryDetails,
    com.mcd.accessmcd.util.CommonUtil,
    java.util.ArrayList,
    com.mcd.util.PropertiesLoader,java.util.Properties"%>
    
<%  
    ArrayList allCountryNames = null;
    try{
    IGCDFacade iGCDFacade= new GCDFacadeImpl();
    allCountryNames = iGCDFacade.getActiveCountries(sling);    
    }catch(Exception e){}
    
    String firstname=properties.get("firstname","First Name");
    String lastname=properties.get("lastname","Last Name");
    String country=properties.get("country","Country");
    Properties props = PropertiesLoader.loadProperties("common.properties");
    String gcd_search_url=props.getProperty("gcd_search_url");
    String gcd_page_path=props.getProperty("gcd_page_path");
    String compTitle = properties.get("comptitle","Global Contact Directory");
    
     CommonUtil commonUtil = new CommonUtil();  
    
%>

<div class="empDirBox"> 
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="empDirbrdr">
        <tr>
            <td valign="top">
                <div class="empDirboxHdBlack">
                    <div class="empTitle"><%=compTitle%></div>
                </div>

                <div class="innerCont">   
                    <div class="innerTxt">
                        <form id="formgcd" name="gcdbasicsearch" method="GET"   action="javascript:validateGCDForm();" >           
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                             <tr>
                                <td colspan="2"><input type="hidden" value="BASIC_SEARCH_FORM" name="FORMACTION">
                                    <input type="hidden" value="true" name="encoding">
                                </td>
                             </tr>  
                             <tr>
                                <td colspan="2" class="gcderrormessage"><b></b></td>
                             </tr>
                             <tr>
                                <td width="90"><label for="First_Name"><%=firstname%></label></td>
                                <td><input type="text" name="ADVANCED_SEARCH_FIRST_NAME" id="ADVANCED_SEARCH_FIRST_NAME" class="inp" /></td>
                             </tr>
                             <tr>
                                <td><label for="Last_Name"><%=lastname%></label></td>
                                <td><input type="text" name="ADVANCED_SEARCH_LAST_NAME" id="ADVANCED_SEARCH_LAST_NAME" class="inp" /></td>
                             </tr>
                             <tr>
                                    <td><label for="Country"><%=country%></label></td>

                                    <td>
                                
                                    <select name="<%= GCDConstants.SEARCH_COUNTRY %>" id="ADVANCE_SEARCH_COUNTRY">
                                    <option></option>
                                    <%  
                                       if(allCountryNames != null)
                                       { 
                                        for( int i=0; i<allCountryNames.size(); i++){
                                            CountryDetails countryDetails = new CountryDetails();
                                            countryDetails = (CountryDetails)allCountryNames.get(i);
                                           
                                            if( countryDetails.getCtryCd().equals(GCDConstants.COUNTRY_ALL)){
                                                continue;
                                            }
                                            
                                            if( countryDetails.getActiveFl().equals(GCDConstants.CONSTANT_TRUE)){
                                    %>
                                                <option <%= ( "US".equals(countryDetails.getCtryCd()) ? "selected='selected'" : "" )%> value="<%= countryDetails.getCtryCd() %>" ><%= countryDetails.getCtryCd() %>-<%= countryDetails.getCtryNm() %></option>
                                    <%
                                            }
                                        } 
                                       }
                                     
                                    %>
                                    </select>
                                    </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center" width="100%">
                                    <input type="submit" name="Submit" id="Submit" value="Submit">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center" width="100%">
                                    <div id="moreLink"> 
                                       <ul class="boldlinks" style="list-style-type:none;">
                                            <li class="moreLinksSwitcher" id ="switcher" style="cursor:pointer">
                                               <a href="javascript:void(0)"> 
                                                 <div id="moreText">
                                                   More
                                                   <img src="/images/downArrow.png"/> 
                                                 </div>
                                               </a>
                                               
                                               <ul id="moreLinksList">
                                                   <%
                                                       Page viewPage = pageManager.getPage(properties.get("startLinkPage",gcd_page_path));
                                                      
                                                    if(viewPage!=null){
                                                        Iterator<Page> myChildren = viewPage.listChildren(new PageFilter(request));  
                                                    
                                                       String subPages = "";
                                                       while(myChildren.hasNext())
                                                       {
                                                           Page child =  (Page) myChildren.next(); 
                                                           Node childNode = slingRequest.getResourceResolver().getResource(child.getPath()+"/jcr:content").adaptTo(Node.class);
                                                           subPages = child.getProperties().get("subPages",child.getPath()); 
                                                           subPages = subPages.startsWith("/content")? subPages.replaceAll("/content/","/") + ".html" : subPages;                          
                                                        %>
                                                            <li >
                                                              <a href="javascript:openLink('<%= commonUtil.getValidURL(subPages)%>')"><%=child.getTitle()%></a>
                                                            </li>
                                                          

                                                     <%
                                                         }
                                                         }
                                                     %>   
                                               </ul> 
                                            </li>   
                                       </ul>                                       
                                     </div> 
                                </td>
                            </tr>
                            
                        </table>
                            <input type="hidden" id="view" value="" name="view">
                         <br /><br /> 
                    </form>
                    
                                 
                </div> 
              </div> 
            </td> 
          </tr>
       </table> 
</div>

<script type="text/javascript">
function validateGCDForm()
{
   
   var submit=1;
    if(document.getElementById('ADVANCE_SEARCH_COUNTRY').value==''){
        alert('Please select the Country !!!');
        submit=0;
    }else 
    {
    
        if(jQuery.trim($('#ADVANCED_SEARCH_FIRST_NAME').val()) == '' && jQuery.trim($('#ADVANCED_SEARCH_LAST_NAME').val()) == '' ) {alert('Please enter the First Name or Last Name !!!');submit=0; }
    }

    if(submit==1){
        
        document.forms['formgcd'].action = "<%= props.getProperty("gcd_search_page") %>";
        document.forms['formgcd'].method = "get";
        document.forms['formgcd'].submit();
        window.open(formActionn,"_self");
    }
}

    //more links dropdown starts here
    $("#moreLinksList").hide(); 
    
    $('#moreLink ul li.moreLinksSwitcher').mouseenter(function() {
        $("#moreLinksList").show();
    }); 
    
    $('#moreLinksList').mouseleave(function() {
        $("#moreLinksList").hide();
    }); 
     
    
    $('#moreLinksList a').hover(function() {
        $(this).css("text-decoration","underline");
    },function() {
        $("#moreLinksList a").css("text-decoration","none");
    }); 
     
    //country dropdown starts here
    if(UserInfoObject!=null){
        $('#view').val(UserInfoObject.view);  
    }

    $('#ADVANCE_SEARCH_FIRST_NAME').text('');
    $('#ADVANCE_SEARCH_LAST_NAME').text(''); 
</script>     
