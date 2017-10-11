<%--

  GCD Form component.

  css being referred for employee directory is us_g2g_red in designs(/etc/designs/mcd/accessmcd/g2g/us_g2g_red/static.css)
 
--%>   
  
<%@page session="false" %>
<%@ page import="com.day.cq.i18n.I18n"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils,
    com.day.cq.wcm.api.WCMMode,
    java.util.Iterator,
    com.day.cq.wcm.api.PageFilter,
    com.mcd.accessmcd.gcd.facade.*,
    com.mcd.accessmcd.gcd.manager.*,
    com.mcd.accessmcd.gcd.constants.GCDConstants,
    com.mcd.accessmcd.gcd.bean.CountryDetails,
    com.mcd.accessmcd.util.CommonUtil,
    java.util.ArrayList,
    com.mcd.util.PropertiesLoader,java.util.Properties"%>
 
<style>
.form_button{
    background: url("/images/generic_buttons_2.png") no-repeat scroll 0 -54px transparent;
    color: #FFFFFF;
    cursor: pointer;
    float: left;
    font-family: Tahoma;
    font-size: 14px;
    font-weight: 900;
    height: 27px;
    line-height: 27px;
    margin: 0 0 0 80px;
    text-decoration: none;
    width: auto;
}

.form_button span {
    background: url("/images/generic_buttons_2.png") no-repeat scroll 100% 0 transparent;
    color: #FFFFFF;
    float: left;
    height: 27px;
    margin-left: 15px;
    padding-right: 15px;
    text-align: center;
}
.btnStyle{
background:url("/etc/designs/mcd/accessmcd/corelibs/images/btnBg.png") repeat-x; padding:5px 8px; border:none;color:#fff; font:bold 12px arial; cursor:pointer;
}
</style>

<%  
    ArrayList allCountryNames = null;
    int temp1=0;
    try{
    IGCDFacade iGCDFacade= new GCDFacadeImpl();
    allCountryNames = iGCDFacade.getActiveCountries(sling);    
    }
    catch(Exception e){
    temp1 = 1;
    log.error("********************Database Down***************************");
    }  
    
    String firstname=properties.get("firstname",langText.get("First Name"));
    String lastname=properties.get("lastname",langText.get("Last Name"));
    String country=properties.get("country",langText.get("Country"));
	/* After Upgrade Change Start */

	//Properties props = PropertiesLoader.loadProperties("common.properties");

	Properties props = PropertiesLoader.loadProperties("com/mcd/util/common.properties");

	/* After Upgrade Change End */

    String resultPage =properties.get("resultPage","");
    String gcd_search_url=props.getProperty("gcd_search_url");
    String gcd_page_path=props.getProperty("gcd_page_path");
    String compTitle = properties.get("comptitle",langText.get("Global Contact Directory"));
    
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
                        <form id="formgcd" name="gcdbasicsearch" action="javascript:validateGCDForm();" >  
                         <%
                          if(temp1==0)
                          {
                         %>         
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
                                <td><input type="text" name="BASIC_SEARCH_FIRST_NAME" id="BASIC_SEARCH_FIRST_NAME" class="inp" /></td>
                             </tr>
                             <tr>
                                <td><label for="Last_Name"><%=lastname%></label></td>
                                <td><input type="text" name="BASIC_SEARCH_LAST_NAME" id="BASIC_SEARCH_LAST_NAME" class="inp" /></td>
                             </tr>
        
                            <tr>
                                <td colspan="2" align="center" width="100%" id="submitDiv">
                                  <input type="submit" class="btnStyle"  name="Submit" id="Submit" value="FIND">
                                  <div id="imgload" style="display:none;font-size:13px;color:red;"><%= GCDConstants.SEARCH_PROGRESS %>
                                  </div>   
                                  
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
                                                   <img src="/etc/designs/mcd/accessmcd/corelibs/images/downArrow1.png"/> 
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
                                                           if(childNode.hasProperty("redirectTarget"))
                                                           {
                                                            subPages = childNode.getProperty("redirectTarget").getString(); 
                                                           }
                                                           else
                                                           {
                                                            subPages = child.getPath();
                                                           }
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
                     <%
                       }
                        else
                        {
                      %>
                        <div class="errorMsg"><%= GCDConstants.ERROR_GCD_DATABASE_ERROR %></div>
                      <%  
                        }
                      %>    
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


        if(jQuery.trim($('#BASIC_SEARCH_FIRST_NAME').val()) == '' && jQuery.trim($('#BASIC_SEARCH_LAST_NAME').val()) == '' ) 
        {
         alert('Please enter the First Name or Last Name !!!');submit=0;
        }
        else
        if(jQuery.trim($('#BASIC_SEARCH_FIRST_NAME').val()).length <2 && jQuery.trim($('#BASIC_SEARCH_LAST_NAME').val()).length < 2 ) 
        {
         alert('Please enter at least 2 characters for First Name or Last Name');submit=0;
        }
        


    if(submit==1){
       $("#Submit").hide();
       //$("#loading").show();
       $("#imgload").show();
       
   var add =  window.location.protocol + "//" + window.location.host + "<%= commonUtil.getValidURL(resultPage) %>?FORMACTION=BASIC_SEARCH_FORM&encoding=true&BASIC_SEARCH_FIRST_NAME=" + escape(jQuery.trim($('#BASIC_SEARCH_FIRST_NAME').val())) + "&BASIC_SEARCH_LAST_NAME=" + escape(jQuery.trim($('#BASIC_SEARCH_LAST_NAME').val())) +"&BASIC_SEARCH_COUNTRY=" + "US" + "&view=";

       
       document.forms["formgcd"].reset();
       window.open(add,"_self");
       
       
       /*document.forms['formgcd'].action = add;
       document.forms['formgcd'].method = "GET";    
       document.forms['formgcd'].submit();*/
       //window.open(add,"_self");  
        
//            window.location.href =window.location.protocol + "//" + window.location.host + "<%= commonUtil.getValidURL(resultPage) %>?FORMACTION=BASIC_SEARCH_FORM&encoding=true&BASIC_SEARCH_FIRST_NAME=" + jQuery.trim($('#BASIC_SEARCH_FIRST_NAME').val()) + "&BASIC_SEARCH_LAST_NAME=" + jQuery.trim($('#BASIC_SEARCH_LAST_NAME').val()) +"&BASIC_SEARCH_COUNTRY=" + jQuery.trim($('#ADVANCE_SEARCH_COUNTRY').val()) + "&view=";
     }   
       
}   
  
  function sleep(ms)
    {
        var dt = new Date();
        dt.setTime(dt.getTime() + ms);
        while (new Date().getTime() < dt.getTime());
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
            
    