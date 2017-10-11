<%-- ########################################### 
 # DESCRIPTION: This is the regional content detail page
 # Author: Subodh Kumar 
 # Environment: CQ 5.4    
 # 
 # UPDATE HISORY         
 # 1.0  Subodh Kumar 
 # 1.1  Stephen Pfaff
##############################################--%>
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page import="java.util.Iterator,
                 java.util.Hashtable,
                 java.util.HashMap,
                 java.util.List,
                 java.util.Set,
                 java.util.Calendar,
                 java.util.Date,
                 com.mcd.accessmcd.util.CommonUtil,
                 com.mcd.accessmcd.common.Constants,
                 com.mcd.accessmcd.common.helper.PropertyHelper,
                 com.day.cq.wcm.foundation.Image,
                 com.mcd.accessmcd.pci.bo.PCIQuery,
                 com.mcd.accessmcd.pci.bo.PCIResult,
                 com.mcd.accessmcd.pci.facade.IPCIContentDeliveryFacade, 
                 com.mcd.accessmcd.pci.facade.impl.PCIContentDeliveryFacadeImpl,
                 com.day.cq.wcm.foundation.TextFormat,
                 com.day.cq.wcm.foundation.DiffInfo,
                 com.day.cq.wcm.foundation.DiffService,
                 org.apache.commons.lang.StringEscapeUtils,
                 com.day.cq.wcm.api.components.DropTarget,
                 com.day.cq.wcm.api.WCMMode,
                 org.apache.sling.api.resource.ResourceUtil,
                 org.apache.sling.api.resource.ValueMap,
                 com.day.cq.security.User,
                 com.mcd.accessmcd.common.helper.PCIHelper" %>
                 
<%
String oPage = "no";
String viewAllMessage = "";
String vPage = "";
String name = "";
String val = "";
String maxAge = "";
String path = ""; 

String topCatId = "31";
String catId = "30";
String thumbnailURI = "";                                                               
String linkURI = "";                                    
String description = "";
String documentTitle = "";
String selected = "";
String launchType = "";
String typeCode = "";
String regionCodeValue = "";
String cacheCellRefresh = "0";
String domainName ="";

PCIResult pciResult = null;
CommonUtil commonUtil=new CommonUtil();
int valSize = 0;
int pciRsArrLen = 0;
int startCount = 1;
int rcCounter = 0;

String cellId = "";

String audienceType = "";
String resultCount = "";
String sortType = "";
String mcdEntity = "";
String actionType = "";
String viewType = "";
String cqReq_Handle = "";
HashMap regionMap = null;
Cookie[] cookies = null;
Cookie myCookie = null;
String isCookie = "false";
String cookieName = "AMCDRegionCode";

//Retrieve user audience type
final User user = slingRequest.getResourceResolver().adaptTo(User.class);  

audienceType =(String) user.getProperty("rep:mcdAudience");

if(audienceType == null || audienceType.equals("")) 
audienceType = "CorpEmployees" ;

if(request.getParameter("audienceType")!=null)  
audienceType = request.getParameter("audienceType");        
if(request.getParameter("resultCount")!=null)   
resultCount = request.getParameter("resultCount");      
if(request.getParameter("sortType")!=null)  
sortType = request.getParameter("sortType");        
if(request.getParameter("mcdEntity")!=null) 
mcdEntity = request.getParameter("mcdEntity");      
if(request.getParameter("actionType")!=null)    
actionType = request.getParameter("actionType");        
if(request.getParameter("viewType")!=null)  
viewType = request.getParameter("viewType");        
if(request.getParameter("regionCodeValue")!=null)   
regionCodeValue = request.getParameter("regionCodeValue");
if(request.getParameter("cqReq_Handle")!=null)  
cqReq_Handle = request.getParameter("cqReq_Handle");
if(request.getParameter("cellId")!=null)    
cellId = request.getParameter("cellId");
if(request.getParameter("viewAllMessage")!=null)    
viewAllMessage = request.getParameter("viewAllMessage");

if (viewAllMessage.equals("")) {
    viewAllMessage = "View Site";
}

if(regionCodeValue.equals("")){
    
    // getting the reference of CookieHelper class.
    regionMap = commonUtil.getRegions();
    val = "001";
    
    if(regionMap.containsValue(val))
    {
        Set keySet=regionMap.keySet();
        Iterator itr=keySet.iterator();
        String regionCode=null;
        
        while(itr.hasNext())
        {
            regionCode=(String)itr.next();
            if((regionMap.get(regionCode)).equals(val))
            {
                regionCodeValue=regionCode;                     
                break;
            }
        }
    }
    
    if("".equals(regionCodeValue))
    {
        regionCodeValue = "100";
        topCatId = topCatId + regionCodeValue;
        catId = catId + regionCodeValue;
        // added by shubhra for opening Oak brook view all page in same location 
        oPage = "no";
        //out.println("<br> in if of 100 : opage = "+oPage);
    } else {
        topCatId = topCatId + regionCodeValue;
        catId = catId + regionCodeValue;    
    }

} else{
    topCatId = topCatId + regionCodeValue;
    catId = catId + regionCodeValue;
}

//Added below line to return regionCodeValue to ajax function
//This has been done to substitute the ajax call for changing the selected value in region drop down
out.println(regionCodeValue+"|");

vPage = PropertyHelper.getPropValue("regionwebsites",regionCodeValue);

if("100".equals(regionCodeValue))
{
    CommonUtil commonUtilObject = new CommonUtil();
    oPage = "no";   
    
    vPage = vPage +"."+commonUtilObject.getAlias(audienceType)  +".html";    
}
%>


<%  
int x =Integer.parseInt(resultCount);
resultCount=""+x+""; 

PCIHelper pciHelper = new PCIHelper();
PCIQuery pciQry = new PCIQuery();

pciQry.setAudience(audienceType);
pciQry.setCategoryID(catId);
pciQry.setResultCount(resultCount);
pciQry.setSortType(sortType);
pciQry.setEntityType(mcdEntity);
pciQry.setViewType(viewType);

IPCIContentDeliveryFacade ipcicdf = new PCIContentDeliveryFacadeImpl(sling); 
PCIResult[] pciRsArr = ipcicdf.getPCIContent(pciQry);
if(pciRsArr != null){
    pciRsArrLen = pciRsArr.length;      
}
%>

<%
if(pciRsArr!=null)                                                                                                         
{
    for (int ix=0;ix<pciRsArr.length;ix++) 
    { 
        PCIResult result=pciRsArr[ix];
        String img=result.getThumbnailURI();
        if(img!=null){
            //Replace URL with 'https://www.accessmcd.com/accessmcd/resources/topstories/'.
            img=img.replace("http://mcdeagsun107a.mcd.com:4212/accessmcd/resources/topstories/","/content/utility/utility.pciimage.");
            img=img.replace(".AMCDImage.gif",".html/thumbnail.gif");    
            img=img.replace("DEFAULTIMG","/images/spacer.gif"); 
        } else {
            img="/images/spacer.gif";
            
        }
        result.setThumbnailURI(img);
     }   
%>
        <div id="regionalImg">
            <img style="display: none;" src="" />
        </div>
    <%
}
%> 

<% 
String regionalNewsContent="";
String reg_stylesheet_path=properties.get("stylesheet", "/content/dam/accessmcd/newstab/news.xslt");
String regkey=pciQry.getOSCacheKey();
if(WCMMode.fromRequest(request) == WCMMode.EDIT || WCMMode.fromRequest(request) == WCMMode.PREVIEW)
{
    regkey="";
}
regionalNewsContent=pciHelper.getTabContent(pciRsArr,reg_stylesheet_path,regkey,properties,sling); 

%>

<% if(pciRsArr.length<=0 && WCMMode.fromRequest(request) == WCMMode.EDIT){%>
    <div id="tabContent">
     <%= langText.get("No content found for this tab.") %>
    </div> 
<% }else{%> 
    <div id="tabContent">
        <%if(regionalNewsContent.trim().equals("") && WCMMode.fromRequest(request) == WCMMode.EDIT) {%>
             <%= langText.get("No content found for this tab.") %>
        <%}else{%> 
            <%=regionalNewsContent%> 
        <%}%>
        
        <% if(!vPage.equals("")){ %>
        <div id="viewAllLink">
            <a href="#" onclick="openLink('<%=vPage%>')"><%=viewAllMessage%></a>
        </div>
        <% } %>
        <%--
    </div>
    <div class="clear"></div>
    --%>
<%}%> 