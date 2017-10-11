<%-- ########################################### 
 # DESCRIPTION: Navigation Bar Component
#  
 # Environment:  
 #  
 # UPDATE HISTORY        
 # 1.0  Deepali Goyal Initial Version
#
##############################################--%> 


<%@include file="/apps/mcd/global/global.jsp"%> 
    
<%@ page import="com.mcd.accessmcd.util.CommonUtil,
                java.util.Iterator,
                java.util.Map,
                java.util.TreeMap,
                java.util.Set,
                java.util.Date,
                com.day.cq.wcm.api.PageFilter,
                java.text.ParseException,
                java.text.SimpleDateFormat,
                java.text.DateFormat,
                com.day.cq.security.*,
                org.apache.sling.jcr.api.SlingRepository"%>


 <script type="text/javascript" src="/scripts/slideshowSlider5.js"></script> 

    <script type="text/javascript">
     function stockurl() {
     var yql = "<%=currentPage.getPath()%>.stockURL.html";
     window.open(yql, '_blank');
     }
     </script>              

<%
    User user = slingRequest.getResourceResolver().adaptTo(User.class);//instantiate User object
    final UserManagerFactory userManagerFactory = sling.getService(UserManagerFactory.class);
    //debugging Digvijay 10/1/2014
    String sessionUserId = "";
    Session adminSession = null;
    try{
    if(user == null){
        Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);
        sessionUserId = jcrSession.getUserID();
        SlingRepository repository = sling.getService(SlingRepository.class);
        adminSession = repository.loginAdministrative(null);
        UserManager mgr= userManagerFactory.createUserManager(adminSession); 
        user = (User)mgr.get(sessionUserId);
        System.out.println("********* Have User From AdminSession ********* ");
    }
    }
    catch(Exception e){
        System.out.println("***** Exception in getting User Node Object ****** "+e.getMessage());
        System.out.println(e);
    }finally{
        if(adminSession!=null)adminSession.logout();
    }


    CommonUtil commonUtil = new CommonUtil();
    boolean foundCookie = false;
    String view = "corp";
    String path = "";
    String views=prop.getProperty("views"); 
    String allViews1 =prop.getProperty("allview");  
    String [] cview1 = null;
    if(allViews1.contains(",")){
        cview1 = allViews1.split(",");
    }
    String viewPagePath1 = currentPage.getPath();
    path = commonUtil.getDefaultHomePage(user);   
    view = prop.getProperty(currentPage.getPath()); 
    Cookie[] cookies = request.getCookies(); 
    if(cookies != null){ 
        for(int i = 0; i < cookies.length; i++) { 
            Cookie cookie1 = cookies[i];
            if (cookie1.getName().equals("userview")){
                view = cookie1.getValue();
                if(view == null || view.trim().equals("")){
                    view = "corp"; 
                }
            }
        }
    }    
    if(view == null ) { 
        String [] pageViews = views.split(",");
        String [] pView=new String[2];  
        for(int k=0;k<pageViews.length;k++){ 
            pView=pageViews[k].split("\\|");
            if(viewPagePath1.toLowerCase().startsWith(pView[0].toLowerCase())){
                view = pView[1];
                break;
            }
        }  
    }
    String otherPath="";
    if(view == null){
        view = "corp";
    }
    String currentPagePath = currentPage.getPath();
    String [] pageViewsRes = views.split(",");
    String [] pViewRes = new String[2];
    String currentPageView = view;  
    for(int k=0;k<pageViewsRes.length;k++){ 
        pViewRes=pageViewsRes[k].split("\\|");
        if(currentPagePath.toLowerCase().startsWith(pViewRes[0].toLowerCase())){
            currentPageView = pViewRes[1];
            break;
        }
    } 
    String viewHomePage = prop.getProperty(currentPageView);
    Page homePage = pageManager.getPage(viewHomePage);
    String navBarType = homePage.getProperties().get("awesomeBarType","responsive");   
    //out.println("navBarType  :" + navBarType  + "<br>");
    
    String rotateArticles=properties.get("rotateArticles","");  
    int playSpeed=Integer.parseInt(properties.get("playspeed","4000"));
    int transitionTime=(int)Integer.parseInt(properties.get("transitiontime","2000"));
    String showCircles=properties.get("showcircles","");
    String [] browse = properties.get("browse",String[].class);
    String headings=properties.get("headings","5");
    String displayType = "horizontal";
    int head= Integer.parseInt(headings);
    int singlebrowse=0;
    int singleheading=0;
    String title = currentPage.getTitle();
    String titleDYK=properties.get("titleDYK","");
    String type = null; 
    String linkDYK=properties.get("linkDYK","");  
    String stockLabel = prop.getProperty("stock_label");
    String stocklabelURL = prop.getProperty("stocklabel_URL");
    String listroot =currentPage.getPath();
    String browsepath="";
    String strClass="";
    String stockID="";
    String bgClass="bg_corp";
    Boolean isHomepage=false;
    type = properties.get("type","");
    if(browse!=null){    
        if(browse.length==1){
            singlebrowse=1; 
        }
        for(int k=0;k<browse.length;k++){
            browsepath=browse[k]+"@"+browsepath;
        }
    }
    if(headings!=null){
        if(headings.equals("1") &&  type.equals("automated")  ){
            singleheading=1;
        }
        else{
           singleheading=Integer.parseInt(headings); 
        }
    }

    String allViews =prop.getProperty("allview");
    
    String [] cview = null;
    if(allViews.contains(",")){
        cview= allViews.split(",");
    }
    strClass ="mainNavMenu";
    stockID="stocksDiv";
    bgClass="bg_corp";
    if(displayType.equals("horizontal") ){   
        if(navBarType.equals("normal")){
%>
        <div id="mainNavMenuContainer">
<%
            String stockRemoveLabel = "";
            if(currentPage.getPath().contains("na/mcweb/fr")){
                stockRemoveLabel = "canada_fr";
            }
            else if(currentPage.getPath().contains("na/mcweb/en")){
                stockRemoveLabel = "canada_en";
            } 
            if("canada_en".equals(stockRemoveLabel) || "canada_fr".equals(stockRemoveLabel)){
%>             
                <div id="<%=stockID%>" >
                    <span class='label'><a href="#" onclick="return stockurl();"><%= stockLabel %></a></span>                   
                    <span id="stockPrice" class="stockvalue textnormal">  </span>                  
                    <span id="stockChangePrice" class="textnormal"> </span>
                    <img class="stockImg" border="0" src="/images/spacer.gif" />
                </div>
<%
            }
%>
            <ul id="mainNavMenu" class="<%=strClass%>">
                <li>&nbsp;</li>
                <li>&nbsp;</li>
                <li>&nbsp;</li>                     
            </ul>
        </div>
<%
        }
    }
    else{
%>
<!--structure for navigation bar-->
  <div id="headerwrapper"> 

    <div class="contentwrapper" id="nav_bar"> 
            <div class="top-nav">
                <div class="nav-bg">
                    <img src="<%= currentDesign.getPath()%>/images/top_nav_bg.png" class="stretch" alt="" />
                </div>
                <div class="topnavigationitems">
                    <ul id="navrender"> 
                    <li>&nbsp;</li>
                    <li>&nbsp;</li>
                    <li>&nbsp;</li>
                    </ul>
                </div>
            <!--end of top-nav-->
            </div>

            <div class="pageheading">
             
              <%
                String viewPagePath = currentPage.getPath();
               
                String homeView="corp";
                isHomepage=false;
                if(viewPagePath.indexOf(".")>0)
                {
                    String [] pages= viewPagePath.split(".");
                    homeView=pages[0];
                    
                }else
                {
                 homeView=viewPagePath;
                } 
              
                           
               if(cview != null)
               {
                for(int i =0 ; i < cview.length ; i++) 
                {
                 if(prop.getProperty(cview[i]) != null)
                 {
                  if( homeView.trim().equalsIgnoreCase(prop.getProperty(cview[i])) )
                  {
                   isHomepage=true;
                   break;
                  }
                 }
                }
               }     
                    
               if(isHomepage)
               {
                 %> <div id='NoGlobaladtext'>                                
                    </div>    
                    
                    <div class="headingtext">
                        <div class="pagetitleheading" >
                            <span class="textbold"><%=title%>
                            </span>
                        <!--end of pagetitleheading-->
                        </div>
                                
                        <!--Stock Details-->
                        <div class="stocknewsbar">
                            <div class="ad"></div>
                                  <div class="stocknews">
                                        <div class="newstext">
                                                  <span class='label'><a href='<%=stocklabelURL%>' target="new"><%= stockLabel %></a></span>                   
                                                  <span id="stockPrice" class="stockvalue textnormal">  </span>                  
                                                  <span id="stockChangePrice" class="stockvalue textnormal"> </span>
                                                  <img class="stockImg" border="0" src="/images/spacer.gif" /> 
                                         </div>
                                  </div>
                         <!--end of stocknewsbar-->
                         </div>
                         <div class="clearboth"></div>
                      <!--end of headingtext-->
                      </div>                
              <%}
              else
              {%>
                     
                  <div id='globaladtext' style='visibility:hidden;' >                  
                  </div>
                  <div class="clearboth">
                  </div>
                  <div class="headingtextchildpages">
                         <!--Stock Details-->
                         <div class="stocknewsbarchildpages">
                              <div class="ad"></div>
                              <div class="stocknewschildpages">
                                    <div class="newstextchildpages">
                                              <span class='label'><a href='<%=stocklabelURL%>' target="new"><%= stockLabel %></a></span>                   
                                              <span id="stockPrice" class="stockvalue textnormal">  </span>                  
                                              <span id="stockChangePrice" class="stockvalue textnormal"> </span>
                                              <img class="stockImg" border="0" src="/images/spacer.gif" />
                                    <!--end of newstextchildpages-->
                                    </div>
                              </div>    
                         <!--end of stocknewsbarchildpages-->  
                         </div>                      
                         
                         <div class="pagetitleheadingchildpages" >  
                                <span class="textbold"></span>
                         </div>
                          
                         <div class="clearboth"></div>
                         <div class="clearboth"></div>
                         <div class="childpages">
                         
                         <!--end of childpages-->  
                         
                         </div>
                <!--end of headingtextchildpages-->
                </div>
            <%}%>

             <!-- Did You know Section Starts From Here -->
             <%if(isHomepage){%>
                       <div class="topRightnews">                 
                            <a href="#" class="newHd"><u id="dyklinktitle"><%=titleDYK%></u></a>
                            <div class="si_slider_box">
                                  <div style="POSITION: relative; WIDTH:270px;" id="loopedslider">
                                         <div class="slideContainer" id="slideContainer">
                                                 <div class="slides">
                                                 </div>
                                         </div>     
                                                                                        
                            </div>  
                                                           
                   </div>        
                             
               <!--end of topRightnews--> 
               </div>
               <%}%>
            <!-- Did You know Section Ends Here -->
         </div>
        <!--end of pageheading-->     
       </div>
      </div>
      <div class="clearboth" ></div>
           
    <!--end of contentwrapper-->
    </div>
<!--end of headerwrapper--> 
</div>

<div class="clearboth"></div>

<%}%>
<script type="text/javascript">  
    
    var nav=new TreeItem("AccessMCD","/navigation/global");
    var a;
    var displayType="<%=displayType%>";
    var content=new TreeItem("Content","/");
    var child_title = "<%= currentPage.getProperties().get("navTitle","").trim().equals("")? currentPage.getTitle():currentPage.getProperties().get("navTitle","") %>";

    var navTitle = "<%=title %>";
   
    var navBarType = "<%=navBarType%>";
    var currentPagePath = "<%=currentPage.getTemplate().getPath()%>";
    var viewHomePagePath = "<%=viewHomePage%>";
    if((navBarType == "normal" || navBarType == "responsive") && currentPagePath.indexOf("g2g-responsive") > 0){
        getResponsiveNavigationBar(escape(_utf8_encode(navTitle)) ,'<%= currentPage.getParent().getPath() %>' ,'<%=currentPage.getParent().getPath()%>' , '<%=currentPage.getPath()%>' , '<%= isHomepage %>' ,child_title , '<%=currentDesign.getPath()  %>', escape(_utf8_encode(displayType)));  
        $("#mainNavMenuContainer").hide();        
    }
    else if(navBarType == "responsive" && currentPagePath.indexOf("g2g") > 0){
        getResponsiveNavigationBar(escape(_utf8_encode(navTitle)) ,'<%= currentPage.getParent().getPath() %>' ,'<%=currentPage.getParent().getPath()%>' , '<%=currentPage.getPath()%>' , '<%= isHomepage %>' ,child_title , '<%=currentDesign.getPath()  %>', escape(_utf8_encode(displayType)));  
        $("#mainNavMenuContainer").hide();
    }
    else{
        getNavigationBar(escape(_utf8_encode(navTitle)) ,'<%= currentPage.getParent().getPath() %>' ,'<%=currentPage.getParent().getPath()%>' , '<%=currentPage.getPath()%>' , '<%= isHomepage %>' ,child_title , '<%=currentDesign.getPath()  %>', escape(_utf8_encode(displayType)));  
    }       
   
   
    function _utf8_encode(string) {
            string = string.replace(/\r\n/g,"\n");
            var utftext = "";
   
            for (var n = 0; n < string.length; n++) {
 
                  var c = string.charCodeAt(n);
 
                  if (c < 128) {
                        utftext += String.fromCharCode(c);
                  }
                  else if((c > 127) && (c < 2048)) {
                        utftext += String.fromCharCode((c >> 6) | 192);
                        utftext += String.fromCharCode((c & 63) | 128);
                  }
                  else {
                        utftext += String.fromCharCode((c >> 12) | 224);
                        utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                        utftext += String.fromCharCode((c & 63) | 128);
                  }
 
            }
 
            return utftext;
      }

        $("#headerwrapper").addClass("<%=bgClass%>");

</script> 
<script type="text/javascript">
    var artRotate='<%=rotateArticles%>';
    var showCir='<%=showCircles%>';
    var singlebrowsePath= '<%=singlebrowse%>';
    var singleheadingPath= '<%=singleheading%>';

   function startDYKRotation(){ 
   
   var addhppnbox= ((showCir!=("disable"))||(singlebrowsePath==1)|| (singleheadingPath==1));
    if(artRotate==("yes"))
    {
        $(function()
        { 
                $('#loopedslider').loopedSlider({ 
                           addhp_pnbox: addhppnbox,
                           autoStart: <%=playSpeed%>,
                           fadespeed: <%=transitionTime%>                
                }); 
        });   
      }
      else{
           
          $('#loopedslider').loopedSlider({ 
                   addhp_pnbox: addhppnbox               
          });
      }
   };          
</script>
    