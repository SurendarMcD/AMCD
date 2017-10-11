<%-- ########################################### 
 # DESCRIPTION: This is News Tab Content Display Component 
 # Author: Subodh Kumar    
 # Environment: CQ 5.4
 # 
 # UPDATE HISORY        
 # 1.0  Subodh Kumar
 # 1.1  Stephen Pfaff
##############################################--%>
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page import="com.day.cq.wcm.foundation.Image,
                 com.day.cq.wcm.api.components.DropTarget,
                 com.mcd.accessmcd.pci.bo.PCIQuery,
                 com.mcd.accessmcd.pci.bo.PCIResult,
                 com.mcd.accessmcd.pci.facade.IPCIContentDeliveryFacade, 
                 com.mcd.accessmcd.pci.facade.impl.PCIContentDeliveryFacadeImpl,
                 com.day.cq.wcm.api.WCMMode,
                 org.apache.sling.api.resource.ValueMap,
                 com.day.cq.security.User,
                 com.mcd.accessmcd.util.CommonUtil,
                 com.mcd.accessmcd.common.helper.PCIHelper,
                 java.util.Calendar,java.util.Date,
                 java.lang.*,
                 com.day.cq.wcm.foundation.DiffInfo,
                 com.day.cq.wcm.foundation.DiffService,
                 org.apache.sling.api.resource.ResourceUtil,
                 com.day.cq.wcm.foundation.TextFormat" %>
                 
<%
//Date recent 6 month
Date pubDateTo=new Date(); 
Date pubDateFrom=new Date(); 
Calendar cal = Calendar.getInstance();   
cal.setTime(pubDateFrom);   
cal.set(Calendar.MONTH, (cal.get(Calendar.MONTH)-6));   
pubDateFrom=cal.getTime();


//Init PCI delivery and helper class, also locate XSLT file for rendering out PCI data. 
IPCIContentDeliveryFacade pciContentFacade = new PCIContentDeliveryFacadeImpl(sling);
PCIHelper pciHelper = new PCIHelper();
String pciXslt = properties.get("stylesheet", "/content/dam/accessmcd/newstab/news.xslt");

String manualDateFormat = "";
String manualURLFormat = "";

String imgCount = "";
//   Retrieve logged in user audience type
final User user = slingRequest.getResourceResolver().adaptTo(User.class); //instantiate User object
String mcdAudience = "";
mcdAudience = (String) user.getProperty("rep:mcdAudience");
boolean bAdmin=false;
if(WCMMode.fromRequest(request) == WCMMode.EDIT || WCMMode.fromRequest(request) == WCMMode.PREVIEW)
                {
                    bAdmin=true;
                }

if(bAdmin || mcdAudience == null || mcdAudience.equals("")) {
    mcdAudience = "CorpEmployees";//default
}
CommonUtil commonUtil = new CommonUtil();
String audienceAlias = commonUtil.getAlias(mcdAudience);

//Parameters retrieved from dialog from General Tab
String numTabs = properties.get("numTabs","0");
if (numTabs != "0") {
numTabs = numTabs.substring(numTabs.length() - 1);
}
int tabCount = Integer.parseInt(numTabs);


%>
<div class="yui3-skin-sam">
    <div id="newsTabLayout" class="yui3-tabview-loading">
        <ul>
<%
if (tabCount == 0) {%>
                <li><a href="#nocontent"><%= langText.get("No Content") %></a></li>
                </ul>
                <div>
                <div id="nocontent"><p><%= langText.get("No content was found. Please add content to the dialog menu.") %></p></div><%          
}else{
    int tabnum=0;
    for(int tab=1;tab<tabCount+1;tab++){
        boolean bShow=false;
        String[] tabGroups = properties.get("admittedGroups"+tab,String[].class);
        String defaultTab = properties.get("defaultTab"+tab,"");
        String tabTitle = properties.get("title"+tab,langText.get("Tab "+tab));
       if(!bAdmin && tabGroups!=null){
            for(int k=0; k<tabGroups.length; k++) {
                if(tabGroups[k].equals(mcdAudience)) {
                 
                    bShow=true;
                    break;
                }
            }
        }else{
            bShow=true;
        }
        if(bShow){
         tabnum++;
         if(defaultTab != ""){
           %><li class='yui3-tab-selected'><%
         }else{ 
           %><li><%
         }
        %><a href="#tab<%=tabnum %>" id="tab-title"><%=tabTitle%></a></li><%
        
        }
        
    }
    
 %>
    </ul>
<div>
 <%
    tabnum=0;
    for(int tab=1;tab<tabCount+1;tab++){
        boolean bShow=false;
        String[] tabGroups = properties.get("admittedGroups"+tab,String[].class);
        if(!bAdmin && tabGroups!=null){
            for(int k=0; k<tabGroups.length; k++) {
                if(tabGroups[k].equals(mcdAudience)) {
                    bShow=true;
                    break;
                }
            }
        }else{
            bShow=true;
        }
        if(!bShow)continue; //SKIP to next tab
        
        //SHOW TAB
        tabnum++;
        
        String tabImage = properties.get("image"+tab,"/libs/cq/ui/resources/0.gif");
        String tabViewAllLink = properties.get("viewAllLink"+tab,"");
        String tabViewAllLabel = properties.get("viewAllLabel"+tab,"View All");
        String tabViewTopicLink = properties.get("viewTopicLink"+tab,"");
        String tabViewTopicLabel = properties.get("viewTopicLabel"+tab,"View Topic");
        String tabEntity = properties.get("entity"+tab,"US");
        String tabType = properties.get("tabType"+tab,"manual");
        String[] tabManual = (properties.containsKey("manualNews"+tab))? properties.get("manualNews"+tab, String[].class) : null;
        String tabRegional = properties.get("pciRegional"+tab,"");
        String tabPciCategoryId = properties.get("pciId"+tab,"");
        String tabResultCount = properties.get("resultCount"+tab,"3");
        String tabSortType = properties.get("sortType"+tab,"rchrono");
        String tabTitle = properties.get("title"+tab,langText.get("Tab "+tab));
        
        if(!tabViewAllLink.equals("")){
            if(!tabViewAllLink.endsWith(".html")){
                tabViewAllLink+="."+audienceAlias+".html";
            }else{
                tabViewAllLink=tabViewAllLink.replaceAll(".html","."+audienceAlias+".html");
            }
        }
  
        if(!tabViewTopicLink.equals("")){
            if(!tabViewTopicLink.endsWith(".html")){
                tabViewTopicLink+="."+audienceAlias+".html";
            }else{
                tabViewTopicLink=tabViewTopicLink.replaceAll(".html","."+audienceAlias+".html");
            }
        }
        
        String tabContent="";
        boolean hasContent = false;
        
        /*************** MANUAL ***************/
        if(tabType.startsWith("manual")){
            if (tabManual != null) {
                tabContent +=  "<ul>";
                for (int m=0; m < tabManual.length; m++) {
                    String[] manualContent = tabManual[m].split("\\|");
                    manualDateFormat = manualContent[0].replace("-", ".");
                    manualURLFormat = manualContent[2];
                    if(manualURLFormat.startsWith("/content/"))manualURLFormat += ".html";
                    tabContent += "<li><div id='manualItem"+m+"' class='linkImgHide' ><img src='";
                    if ((manualContent.length > 3) && (!"".equals(manualContent[0]))) {
                         tabContent +=  manualContent[3];
                    } else {
                        tabContent +=  tabImage; 
                    }
                    tabContent += "' class='newsImg linkImg' style='max-width:120px;max-height:120px;width:20%;'><a href='" + manualURLFormat + "'><b>" + "<span id='newsDate'>" + manualDateFormat + "</span> "+ manualContent[1] + "</a></b></div></li>";
                }
                tabContent += "</ul>";
                hasContent = true;
           }
        /*************** PCI ***************/
        } else if (tabType.startsWith("pci")) {
            if (!tabRegional.startsWith("regional")) {
                String topStory = "";
                String viewType = "content";
            
                PCIQuery pciQuery = new PCIQuery();
                pciQuery.setAudience(mcdAudience);  
                pciQuery.setCategoryID(tabPciCategoryId);
                pciQuery.setResultCount(tabResultCount); 
                pciQuery.setSortType(tabSortType);
                pciQuery.setTopStoryCategoryID(topStory);
                pciQuery.setViewType(viewType);
                pciQuery.setEntityType(tabEntity);
                String tabKey=pciQuery.getOSCacheKey();
                if(WCMMode.fromRequest(request) == WCMMode.EDIT || WCMMode.fromRequest(request) == WCMMode.PREVIEW)
                {
                    tabKey="";
                }
                   
                PCIResult[] tabresults=pciContentFacade.getPCIContent(pciQuery);
        
                for(int y=0; y<tabresults.length; y++) {
                    PCIResult tabResult = tabresults[y];
                    String tabImg = tabResult.getThumbnailURI();
                    if(tabImg != null) {
                        tabImg=tabImg.replace("http://mcdeagsun107a:4212/content/accessmcd/resources/topstories/","/content/utility/utility.pciimage.");
                        tabResult.setThumbnailURI(tabImg);
                    } else {
                        tabResult.setThumbnailURI(tabImage);
                    }
                } 
                
 
                tabContent=pciHelper.getTabContent(tabresults,pciXslt,tabKey,properties,sling);
       
                hasContent = true;
              }
           }
           %>
           <div id="tab<%=tabnum %>" <%
           if(tabImage.equals("")){ 
               %>class="noImage"<%
               }
               %>>
               <div id="tabImage<%=tabnum %>" class="defaultImage" style="max-width:120px;max-height:120px;width:20%;">
                   <img src="<%=tabImage%>" class="newsImg" style="max-width:120px;max-height:120px;width:20%;"  />
               </div>
               <% if (!tabRegional.startsWith("regional")) { %>
                        <div id="tabContent" style="width:75%;">
                        <% if (!tabContent.trim().equals("") && hasContent) { %>
                            <%=tabContent%>
                        <% } else { %>
                            <%= langText.get("No content found for this tab.") %>
                        <% } %>
                        </div>
                   <% } else { %>
                             <cq:include script="regioncontent.jsp"/>
                   <% } %>        
                        <div id="tabViewLinks">
                        <%if(!tabViewAllLink.equals("") && tabViewAllLink.length() > 0) {%>
                            <a href="<%=tabViewAllLink%>"><%=tabViewAllLabel%></a>
                        <%}%>
                        
                        <%if(!tabViewTopicLink.equals("") && tabViewTopicLink.length() > 0) {%>
                            <a href="<%=tabViewTopicLink%>"><%=tabViewTopicLabel%></a>
                        <%}%>
                        </div>
                                
                        <div class="clear"></div>
                           
               </div>
               <%
               }
         }
         %>

           
        </div>
    </div>
</div>
<%
if(tabCount>-1){ 
%>
<script>
YUI().use('tabview', function(Y) {
    var tabview = new Y.TabView({srcNode:'#newsTabLayout'});
    tabview.render();
});
YUI().use('node', 'event-delegate', function(Y){
    Y.on('domready', function(){
       setupNewsTabHovers();
    })
       
function setupNewsTabHovers(){
    defaultImg = $('.newsImg').attr('src');

     $('#tabContent .newsImg').error(function() {
         $(this).attr('src','/images/spacer.gif');
         $(this).parents("li").attr('thumbnailuri','/images/spacer.gif');
         $('.defaultImage').removeClass('defaultHide'); 
     });


     for(var tab=0;tab<6;tab++){
       Y.delegate('mouseover', overNewsTabLink, '#tab'+tab+' #tabContent ul','li');
       Y.delegate('mouseout', outNewsTabLink, '#tab'+tab+' #tabContent ul','li');
     }
     

}

});

function overNewsTabLink(e){
 var thumb=e.currentTarget.getAttribute('thumbnailuri');
 if(thumb!='/images/spacer.gif'){
     e.currentTarget.addClass('linkImgShow');
     e.currentTarget.removeClass('linkImgHide');
     $('.defaultImage').addClass('defaultHide'); 
    // $( ".newsImg" ).aeImageResize({ height: 150, width: 150 });
  
 }
}

function outNewsTabLink(e){
    e.currentTarget.removeClass('linkImgShow');
    e.currentTarget.addClass('linkImgHide');
    $('.defaultImage').removeClass('defaultHide'); 
};

function populateRegionTab(xml){
    if(document.getElementById("div_regiondetail")!=null){
       document.getElementById("div_regiondetail").innerHTML = xml;
        
      $('#tabContent .newsImg').error(function() {
         $(this).attr('src','/images/spacer.gif');
         $(this).parents("li").attr('thumbnailuri','/images/spacer.gif');
         $('.defaultImage').removeClass('defaultHide'); 
      });

     
     YUI().use('node', 'event-delegate', function(Y){
        Y.on('domready', function(){
            Y.delegate('mouseover', overNewsTabLink, '#div_regiondetail #tabContent ul','li');
            Y.delegate('mouseout', outNewsTabLink, '#div_regiondetail #tabContent ul','li');
        });
        });
   
   }
}

    
</script>    
<%
}
%>   