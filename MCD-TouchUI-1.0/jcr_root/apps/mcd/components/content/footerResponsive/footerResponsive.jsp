<%-- ########################################### 
 # DESCRIPTION: Footer Componnet 
 # consists of footer & toolbar section
 # Author: Rajat Chawla 
 # 
 # 
 # UPDATE HISTORY       
 # 1.0  Rajat Chawla, 01/10/2009,Initial version  
 # 
 ##############################################--%>

<%@ page import="com.day.cq.wcm.foundation.Image,
                com.day.image.Layer,
                com.day.cq.wcm.api.components.DropTarget,
                java.util.Calendar,
                java.util.GregorianCalendar,
                java.util.Iterator,
                com.day.cq.wcm.api.PageFilter,
                java.util.Locale,
                java.util.Date,
                java.util.ArrayList,
                java.net.URLEncoder,
                java.text.ParseException,
                java.util.TimeZone,
                com.day.cq.wcm.api.WCMMode,
                java.text.SimpleDateFormat,
                com.mcd.accessmcd.util.CommonUtil,
                com.mcd.accessmcd.gcd.facade.*,
                com.mcd.accessmcd.gcd.manager.*,
                com.mcd.accessmcd.gcd.constants.GCDConstants,
                com.mcd.accessmcd.gcd.bean.CountryDetails,
                com.mcd.util.PropertiesLoader,java.util.Properties" %>
<%@include file="/apps/mcd/global/global.jsp"%>
<%!
    // method to convert the string to date object //    
    public static Date stringToDate(String date, String datePattern){
        SimpleDateFormat df = new SimpleDateFormat(datePattern);
        Date dayDate = null;
        try {
            dayDate = df.parse(date);
        } 
        catch (ParseException e) {
            e.printStackTrace();
        }
        return dayDate;
    }
    // code for footer //
    static final String COPYRIGHT_VAL="Copyright";
    static final String LMD_VAL="Last Modified";
    static final String EMAIL_VAL="Contact Email";
    static final String AUS_ZONE="aus";
    static final String AUS_TIMEZONE="Australia/Melbourne";
    static final String US_ZONE="us"; 
    static final String FR_CAN_ZONE="fr_CA"; 

%>    
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
    
    
    
    CommonUtil commonUtil = new CommonUtil();
    String currentPagePath = currentPage.getPath();
    String prefixMCD="";
    String showEmailLink = properties.get("emailLink","false");
    String emailLinkText = properties.get("textEmailLink","Email");
    String prefixAMCD = properties.get("textprefixAMCD","");
    
    String showGetLink = properties.get("getLink","false");
    String getLinkText = properties.get("textGetLink","GetLink");
    
    String showBookmarkLink = properties.get("bookMark","false");
    String bookmarkText = properties.get("textBookMark","Bookmark");
    
    String showPrintLink = properties.get("printLink","false");
    String printText = properties.get("textPrintLink","Print");
    
    String showFormLink = properties.get("formLink","false");
    String ideaFormText = properties.get("textIdeaFormLink","Submit an Idea form");
    String ideaFormLink = properties.get("ideaFormLink","#");
    if(ideaFormLink.startsWith("/content")){
        ideaFormLink = ideaFormLink + ".html";
    }
    
    String showSysMessageLink = properties.get("showSysMessageLink","false");
    String sysMessageText = properties.get("sysMessage","System Message Archive");
    String sysMessageLink = properties.get("sysMessageLink","#");
    if(sysMessageLink.startsWith("/content")){
        sysMessageLink = sysMessageLink + ".html";
    }
    
    String optionVal[] = properties.get("pageInfo",String[].class);
    String copyrightmsg = properties.get("copyMessage","");
    String timeZone = properties.get("timezone","us");
    
    String firstname = properties.get("firstname",langText.get("First Name"));
    String lastname = properties.get("lastname",langText.get("Last Name"));
    String country = properties.get("country",langText.get("Country"));
Properties props = PropertiesLoader.loadProperties("com/mcd/util/common.properties");
    String resultPage = properties.get("resultPage","");
    String gcd_search_url = props.getProperty("gcd_search_url");
    String gcd_page_path = props.getProperty("gcd_page_path");
    String compTitle = properties.get("comptitle",langText.get("Contact Directory"));
    
    String userLinksHeading = properties.get("userLinksHeading","");
    String[] userLinksData = (properties.containsKey("userLinks"))? properties.get("userLinks", String[].class) : null;
    if(null != userLinksData){
%>        
        <div class="container">
            <div class="row">
                <div class="col-md-4 col-sm-4">
                    <div class="footer-links">
                        <h3 class="text-uppercase"><%=userLinksHeading%></h3>
                        <ul>
<%
                        for(int i=0; i<userLinksData.length; i++){
                            String[] userLinksItem = userLinksData[i].split("\\^");//split the item data
                            String userText = userLinksItem[0];
                            String userLink = userLinksItem[1];
                            if(userLink.startsWith("/content")){
                                userLink = userLink+".html";
                            }
%>                        
                            <li><a href="<%=userLink%>"><%=userText%></a></li>                            
<%
                        }
%>                            
                        </ul>
                    </div>
                </div>
                <div class="col-md-4 col-sm-4">
                    <div class="footer-links">
                        <ul class="extra-links">
<%
                            if("true".equals(showSysMessageLink)){
%>                        
                                <li><a href="<%=sysMessageLink%>"><%=sysMessageText%></a></li>                            
<%
                            }
                            if("true".equals(showEmailLink)){
                                if(prefixAMCD.equals("")){
%>    
                                <li><a id="footerEmailAction" href="<%=prefixMCD%>" onclick="javascript:openEmailWin('<%= currentPagePath %>','','name');return false;"><%=emailLinkText%></a></li>
<%
                                }
                                else{
                                    prefixMCD = URLEncoder.encode(prefixAMCD);
%>
                                    <li><a id="footerEmailAction" href="javascript:void(0)"><%=emailLinkText%></a></li>
<%                                
                                }
%>
                                <script>
                                    $(document).ready(function() {
                                        $("#footerEmailAction").click(function(){                           
                                           openEmailWin('<%= currentPage.getPath() %>','<%=prefixMCD%>','name'); 
                                         });
                                    });
                                </script>
<%                                
                            }
                            if("true".equals(showBookmarkLink)){
%>    
                                <li><a id="footerBookmarksAction" href="<%= currentPagePath %>.addtobookmark.html"><%=bookmarkText%></a></li>
<%
                            }
                            if("true".equals(showPrintLink)){
%>
                                <li><a href="<%= currentPagePath %>.responsiveprint.html?wcmmode=disabled" onclick="NewPrintWindow(this.href,'name','970','600','yes','no');return false;"><%=printText%></a></li>
<%
                            }
                            if("true".equals(showGetLink)){
%>
                                <li><a href="<%= currentPagePath %>.getlinkfooter.html" id="footerGetLinkAction"><%=getLinkText%></a></li>
<%
                            }
                            if("true".equals(showFormLink)){
%>
                                <li><a id="ideaForm" href="<%=commonUtil.getValidURL(ideaFormLink)%>"><%=ideaFormText%></a></li>
<%
                            }
%>
                        </ul>
                    </div>
                </div>
<%
                if(!"".equals(resultPage.trim())){
%>                
                <div class="col-md-4 col-sm-4"><!--GCD SECTION START HERE-->
                    <div class="footer-form">
                        <h3 class="text-uppercase"><%=compTitle%></h3>
                        <form class="form-horizontal" id="formgcd" name="gcdbasicsearch" action="javascript:validateGCDForm();">
<%
                          if(temp1==0){
%>  
                            <input type="hidden" value="BASIC_SEARCH_FORM" name="FORMACTION">
                            <input type="hidden" value="true" name="encoding">
                            <div class="form-group">
                                <label for="fname" class="col-md-4 col-sm-5 control-label" style="font-size:13px;"><%=firstname%></label>
                                <div class="col-md-8 col-sm-7">
                                    <input type="text" name="BASIC_SEARCH_FIRST_NAME" id="BASIC_SEARCH_FIRST_NAME">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="lname" class="col-md-4 col-sm-5 control-label" style="font-size:13px;"><%=lastname%></label>
                                <div class="col-md-8 col-sm-7">
                                    <input type="text" name="BASIC_SEARCH_LAST_NAME" id="BASIC_SEARCH_LAST_NAME">
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-md-offset-4 col-md-4 col-sm-6 col-xs-6">
                                    <button type="submit" class="srch-btn text-uppercase">FIND</button>
                                    <div id="imgload" style="display:none;font-size:13px;color:red;"><%= GCDConstants.SEARCH_PROGRESS %></div>
                                </div>
                                <div class="col-md-4 col-sm-6 col-xs-6 text-right pos-relative">
                                    <a href="#" id="directory-more">More <span class="glyphicon glyphicon-triangle-top"></span></a>
                                    <div class="dir-more-section">
                                        <ul>
<%
                                            Page viewPage = pageManager.getPage(properties.get("startLinkPage",gcd_page_path));
                                            if(viewPage!=null){
                                                Iterator<Page> myChildren = viewPage.listChildren(new PageFilter(request));  
                                                String subPages = "";
                                                while(myChildren.hasNext()){
                                                    Page child =  (Page) myChildren.next(); 
                                                    Node childNode = slingRequest.getResourceResolver().getResource(child.getPath()+"/jcr:content").adaptTo(Node.class);
                                                    if(childNode.hasProperty("redirectTarget")){
                                                        subPages = childNode.getProperty("redirectTarget").getString(); 
                                                    }
                                                    else{
                                                        subPages = child.getPath();
                                                    }
                                                    subPages = subPages.startsWith("/content")? subPages.replaceAll("/content/","/") + ".html" : subPages;                          
%>
                                                    <li><a href="javascript:openLink('<%= commonUtil.getValidURL(subPages)%>')"><%=child.getTitle()%></a></li>
<%
                                                }
                                            }
%>        
                                        </ul>
                                    </div>
                                </div>
                            </div>
<%
                            }
                            else{
%>
                                <div class="errorMsg"><%= GCDConstants.ERROR_GCD_DATABASE_ERROR %></div>
<%  
                            }
%>    
                            <input type="hidden" id="view" value="" name="view">
                        </form>
                    </div>
                </div><!--GCD SECTION END HERE-->
<%
                }
%>                
            </div>
            <div class="row">
<% 
                // checking the array of the check box //
            if (optionVal!=null){
                for(int i=0;i<optionVal.length;i++){
                if(!optionVal[i].toString().equals(COPYRIGHT_VAL)){   
                    String optVal[]=optionVal[i].toString().split(",");
                    String disText=optVal[0];
                    String disVal=optVal[1];
                    if(disText.equals(LMD_VAL)){
                        Calendar cal = (Calendar)currentPage.getProperties().get(disVal);
                        if(AUS_ZONE.equals(timeZone)){                
                            Calendar sydney = new GregorianCalendar(TimeZone.getTimeZone(AUS_TIMEZONE));
                            sydney.setTime(cal.getTime());
                            String dSydney = (sydney.get(Calendar.MONTH) + 1) + "-" + sydney.get(Calendar.DATE) + "-" + sydney.get(Calendar.YEAR)+" "+sydney.get(Calendar.HOUR_OF_DAY)+":"+sydney.get(Calendar.MINUTE)+":"+sydney.get(Calendar.SECOND);
                            SimpleDateFormat sdf =new SimpleDateFormat ("EEE MMM d yyyy HH:mm:ss",Locale.US );
                            Date sydDate = stringToDate(dSydney, "MM-dd-yyyy HH:mm:ss");
                            String newDate = sdf.format(sydDate);               
%>
                            <div class="col-md-6 site-info"><strong><%=disText %>: <%=newDate %> CDT</strong></div>              
<%
                        }
                        else if(US_ZONE.equalsIgnoreCase(timeZone)){
                            SimpleDateFormat sdf =new SimpleDateFormat ( "EEE MMM d yyyy HH:mm:ss ",Locale.US );
                            String newDate = sdf.format(cal.getTime());  
%>
                            <div class="col-md-6 site-info"><strong><%=disText %>: <%=newDate %> CDT</strong></div>                  
<%
                        }
                        else if(FR_CAN_ZONE.equalsIgnoreCase(timeZone)){
                            Locale l=new Locale(pageLocale.getLanguage(),"fr");
                            SimpleDateFormat sdf =new SimpleDateFormat ( "EEE d MMM yyyy ",l );
                            String newDate = sdf.format(cal.getTime());
%>
                            <div class="col-md-6 site-info"><strong><%=disText %>: <%=newDate%> CDT</strong></div>
<%
                        }
                    }
                    else{
                        if(disText.equals(EMAIL_VAL)){
%>
                        <div class="col-md-6 site-info">
                            <strong><%=langText.get(disText) %> :
<%
                            if(!(null==currentPage.getProperties().get(disVal))){
%>
                                <a href="mailto:<%=currentPage.getProperties().get(disVal) %>" ><%=currentPage.getProperties().get(disVal) %></a>
<%
                            }
%>
                            </strong>
                        </div>
<%                            
                        }
                        else{               
%>
                        <div class="col-md-6 site-info" style="float:none;">
                            <strong><%=langText.get(disText) %> :
<%
                            if(!(null==currentPage.getProperties().get(disVal))){
%> 
                                <%=currentPage.getProperties().get(disVal)%>
<%
                            }
%>
                            </strong>
                        </div>
<%                            
                        }
                    } 
                }
                else{
%>
                <div class="col-md-6 site-info text-right"><strong><%= langText.get(copyrightmsg)%></strong></div>
<%
                } 
            }
        }
%>                   
            </div>
        </div>
<%
    }
    else{
%>
    <h3 class="text-uppercase">Please configure user data in dialog.</h3>
<%    
    }
%>    
<script type="text/javascript">

    function validateGCDForm(){
        var submit=1;    
        if(jQuery.trim($('#BASIC_SEARCH_FIRST_NAME').val()) == '' && jQuery.trim($('#BASIC_SEARCH_LAST_NAME').val()) == '' ){
            alert('Please enter the First Name or Last Name !!!');submit=0;
        }
        else if(jQuery.trim($('#BASIC_SEARCH_FIRST_NAME').val()).length <2 && jQuery.trim($('#BASIC_SEARCH_LAST_NAME').val()).length < 2 ){
            alert('Please enter at least 2 characters for First Name or Last Name');submit=0;
        }
        
        if(submit==1){
            $("#Submit").hide();
            $("#imgload").show();
            var add =  window.location.protocol + "//" + window.location.host + "<%= commonUtil.getValidURL(resultPage) %>?FORMACTION=BASIC_SEARCH_FORM&encoding=true&BASIC_SEARCH_FIRST_NAME=" + escape(jQuery.trim($('#BASIC_SEARCH_FIRST_NAME').val())) + "&BASIC_SEARCH_LAST_NAME=" + escape(jQuery.trim($('#BASIC_SEARCH_LAST_NAME').val())) +"&BASIC_SEARCH_COUNTRY=" + "US" + "&view=";
            document.forms["formgcd"].reset();
            window.open(add,"_self");
        }   
    
    }   

    $('#directory-more, #directory-more + .dir-more-section').on('click mouseover ', function(e) {
        //e.preventDefault();
        sectionShowHide($(this), 'dir-more-section', true);
    }).on('mouseout', function() {
        sectionShowHide($(this), 'dir-more-section', false);
    });        
    
    function sleep(ms){
        var dt = new Date();
        dt.setTime(dt.getTime() + ms);
        while (new Date().getTime() < dt.getTime());
    }

    //country dropdown starts here
    if(UserInfoObject!=null){
        $('#view').val(UserInfoObject.view);  
    }
    
    $('#ADVANCE_SEARCH_FIRST_NAME').text('');
    $('#ADVANCE_SEARCH_LAST_NAME').text(''); 
    
    $(document).ready(function(){
        $("#footerGetLinkAction").mcdColorbox({ iframe: true, innerWidth: 650, innerHeight: 250 });     
    });

</script>       