<%-- ########################################### 
 # DESCRIPTION: This is the Region Content Display Component
 # Author: Subodh Kumar
 # Environment: 
 # 
 # UPDATE HISTORY         
 # 1.0  Subodh Kumar 
 # 1.1  Stephen Pfaff
##############################################--%>
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page import="java.util.Iterator,
                 java.util.Hashtable,
                 java.util.HashMap,
                 java.util.List,
                 java.util.Set,
                 javax.servlet.http.HttpServletResponse,
                 javax.servlet.http.HttpServletRequest,
                 java.util.Calendar,java.util.Date,
                 com.mcd.accessmcd.util.CommonUtil,
                 com.mcd.accessmcd.common.helper.PCIHelper,
                 com.mcd.accessmcd.common.Constants,
                 com.mcd.accessmcd.common.helper.PropertyHelper,
                 com.mcd.accessmcd.pci.facade.IPCIContentDeliveryFacade,
                 com.mcd.accessmcd.pci.facade.impl.PCIContentDeliveryFacadeImpl,
                 com.mcd.accessmcd.pci.bo.PCIQuery,
                 com.mcd.accessmcd.pci.bo.PCIResult,
                 com.day.cq.security.User" %>
<%@ page session="false" %> 

<script type="text/javascript">
function ajaxRegionDetail(selId,audienceType,resultCount,sortType,mcdEntity,actionType,viewType,cqReq_Handle,cellId,viewAllMessage,selectStatus,audienceTypeglob)
{
    var pars = "regionCodeValue="+selId;
    pars = pars + "&" + "audienceType="+audienceType;   
    pars = pars + "&" + "resultCount="+resultCount; 
    pars = pars + "&" + "sortType="+sortType;   
    pars = pars + "&" + "mcdEntity="+mcdEntity; 
    pars = pars + "&" + "actionType="+actionType;   
    pars = pars + "&" + "viewType="+viewType;
    pars = pars + "&" + "cqReq_Handle="+cqReq_Handle;
    pars = pars + "&" + "cellId="+cellId;
    pars = pars + "&" + "viewAllMessage="+viewAllMessage;
   
    var url= '<%=resource.getPath()%>.regionalnews.'+audienceTypeglob+'.html';
    
    url = url.replace("/content","");
    url = url + "?" + pars;

    $.ajax({

        url: url,
        type: 'GET',    
        timeout: 3000,
        data: '',   
        cache: false,   
        error: function(){ 
                //alert("Error:Loading XML Retrieve");  
        },
        success: function(xml){
            //Added
            xml = xml.trim();
            
            var seperatorIndex = xml.indexOf('|');
            var currentRegionCode = "";
            
            if( seperatorIndex != -1) {         
                currentRegionCode=xml.substring(0,seperatorIndex);
                xml=xml.substring(seperatorIndex+1);
            }
            
            if(selectStatus && currentRegionCode!=""){          
                for(i=0;i<document.all('regionId').length;i++)
                {
                    if(document.all('regionId').options[i].value==currentRegionCode)
                    {
                        document.all('regionId').selectedIndex=i;
                    }
                }
            }
            //Ended  
            
            populateRegionTab(xml);
            }
        });
}
            

              
function set_Cookie(c_name,value,expiredays)
{
    var exdate=new Date();
    exdate.setDate(exdate.getDate()+expiredays);
    document.cookie=c_name+ "=" +escape(value)+
    ((expiredays==null) ? "" : ";expires="+exdate.toGMTString());
    $('.notice').fadeIn(2000);
    $('.notice').fadeOut(1500);
}
</script>


<%
String regionPciCategory1 = properties.get("pciId1","");
String regionPciCategory2 = properties.get("pciId2","");
String regionPciCategory3 = properties.get("pciId3","");
String regionPciCategory4 = properties.get("pciId4","");
String regionPciCategory5 = properties.get("pciId5","");
String regionPciCategory6 = properties.get("pciId6","");

//long start = System.currentTimeMillis();  
String viewAllMessage = "";
String name = "";
String val = "";
String maxAge = "";
String path = "";
String vPage = "";

String oPage = "no";
String submitFlag = "";
String[] rcName = null;
String[] rcCode = null;
String[] openType = null;
String[] viewPage = null;
String isCookie = "false";
String cookieName = "AMCDRegionCode";
String topCatId = "31";
String catId = "30";
String rcListName = "RCList";
String domainName ="";
String thumbnailURI = "";                                                               
String linkURI = "";                                    
String description = "";
String documentTitle = "";
String selected = "";
String launchType = "";
String typeCode = "";
String regionCodeValue = "";
String cacheCellRefresh = "0";
String helpTitle = "";
String audienceType="CorpEmployees"; 
String audienceTypeglob="ce";
PCIResult pciResult = null;
CommonUtil commonUtil=null;
Cookie[] cookies = null;
Cookie myCookie = null;
int valSize = 0;
int pciRsArrLen = 0;
int startCount = 1;
int rcCounter = 0;
boolean isAuthorized = false;
String[] strArray = new String[2];
String error = "";
HashMap regionMap = null;
String cellId = "";
String cacheKey = "";
String regionCodeDefault="";

//added for ajax feature
String resultCount = "";
String sortType = "";
String mcdEntity = "";
String actionType = "";
String viewType = "";

// Retrieve user audience type
final User user = slingRequest.getResourceResolver().adaptTo(User.class);  //instantiate User object

audienceType =(String) user.getProperty("rep:mcdAudience");

if(audienceType == null || audienceType.equals("")) 
    audienceType = "CorpEmployees" ;     
    resultCount = "5";
    sortType = "rchrono";
    mcdEntity ="US";
    actionType ="read";
    viewType ="content";
// end of addition for ajax 

commonUtil = new CommonUtil();
audienceTypeglob=commonUtil.getAlias(audienceType); 

//Check for regional tab, if found retrieve dialog values.
if (regionPciCategory1.equals("regional")) {
    resultCount = properties.get("resultCount1","3");
    sortType = properties.get("sortType1","rchrono");
    viewType="content";
    mcdEntity=properties.get("entity1","US");
    actionType="read";
    viewAllMessage="View All Messages";
} else if (regionPciCategory2.equals("regional")) {
    resultCount = properties.get("resultCount2","3");
    sortType = properties.get("sortType2","rchrono");
    viewType="content";
    mcdEntity=properties.get("entity2","US");
    actionType="read";
    viewAllMessage="View All Messages";
} else if (regionPciCategory3.equals("regional")) {
    resultCount = properties.get("resultCount3","3");
    sortType = properties.get("sortType3","rchrono");
    viewType="content";
    mcdEntity=properties.get("entity3","US");
    actionType="read";
    viewAllMessage="View All Messages";
} else if (regionPciCategory4.equals("regional")) {
    resultCount = properties.get("resultCount4","3");
    sortType = properties.get("sortType4","rchrono");
    viewType="content";
    mcdEntity=properties.get("entity4","US");
    actionType="read";
    viewAllMessage="View All Messages";
} else if (regionPciCategory5.equals("regional")) {
    resultCount = properties.get("resultCount5","3");
    sortType = properties.get("sortType5","rchrono");
    viewType="content";
    mcdEntity=properties.get("entity5","US");
    actionType="read";
    viewAllMessage="View All Messages";
} else if (regionPciCategory6.equals("regional")) {
    resultCount = properties.get("resultCount6","3");
    sortType = properties.get("sortType6","rchrono");
    viewType="content";
    mcdEntity=properties.get("entity6","US");
    actionType="read";
    viewAllMessage="View All Messages";
}
%>

<form name="frmRegionContent" id="frmRegionContent" method="post" action="">    
    <input type="hidden" name="rcname" value=''/>
    <input type="hidden" name="rcval" value=''/>
    <input type="hidden" name="rcmaxAge" value=''/>
    <input type="hidden" name="isCookie" value='' />
    <input type="hidden" name="regionCodeValue" id="regionCodeValue" value="<%=regionCodeValue%>" />
    <input type="hidden" name="audienceType" id="audienceType" value="<%=audienceType%>"/>
    <input type="hidden" name="audienceTypeglob" id="audienceTypeglob" value="<%=audienceTypeglob%>"/>
    <input type="hidden" name="resultCount" id="resultCount" value="<%=resultCount%>" />
    <input type="hidden" name="sortType" id="sortType" value="<%=sortType%>" />
    <input type="hidden" name="mcdEntity" id="mcdEntity" value="<%=mcdEntity%>" />
    <input type="hidden" name="actionType" id="actionType" value="<%=actionType%>" />
    <input type="hidden" name="viewType" id="viewType" value="<%=viewType%>" />
    <input type="hidden" name="cellId" id="cellId" value="<%=cellId%>" />
    <input type="hidden" name="viewAllMessage" id="viewAllMessage" value="<%=viewAllMessage%>" />
    
    <div id="div_regionContent">
        <%
        regionMap = commonUtil.getRegions();
        
        cookies = request.getCookies();
        if (cookies != null)
        {
            for (int i = 0; i < cookies.length; i++) 
            {
                if (cookies [i].getName().equals (cookieName))
                {
                    myCookie = cookies[i];
                    regionCodeValue = myCookie.getValue();
                    break;
                }
            }
        }           
    
        // val = commonUtil.getDefaultRegion(cqReq);
        val="001";
        if(regionCodeValue.equals("") && regionMap.containsValue(val))
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
        }
        %>    
    
        <div class="wpsPortletBody">
    
            <select name="regionId" id="regionId" class="RCText" onChange="ajaxRegionDetail(this.value,
                                                                                            '<%=audienceType %>',
                                                                                            '<%=resultCount%>',
                                                                                            '<%=sortType%>',
                                                                                            '<%=mcdEntity%>',
                                                                                            '<%=actionType%>',
                                                                                            '<%=viewType%>',
                                                                                            '',
                                                                                            '<%=cellId%>',
                                                                                            '<%=viewAllMessage%>',
                                                                                            false,
                                                                                            '<%=audienceTypeglob%>')" >
            <%
            if(regionMap!=null){
                Set regionKetSet=regionMap.keySet();
                Iterator regionItr=regionKetSet.iterator();
                String regionCD=null;
                while(regionItr.hasNext())
                {
                    regionCD=(String)regionItr.next();
                    if(regionCodeValue.equals(regionCD))
                    {
                        selected = "selected";
                        regionCodeDefault=regionCD;
                    }else{
                        selected = "";
                    }   
                    %>
                    <option id="reg<%=regionCD%>" value="<%=regionCD%>" ><%=(String)regionMap.get(regionCD)%></option>
                    <%
                }
            }
            %>  
            </select>
    
            <input type="button" name="saveLocation" value="<%=langText.get(" Save Location ")%>" class="RCbutton" onClick="set_Cookie('AMCDRegionCode',document.getElementById('regionId').value,'1')"/>               

            <div id="div_regiondetail">
                <div class="portalbody">
                    <div class="RCText">
                        <img width="8" height="5" border="0" alt="" src='/images/spacer.gif'/>
                    </div>
                </div>
                                                
                <div class="RCText"></div>
            </div>
        </div>
    </div>
</form>


<script>
function getCookie(c_name)
{
    if (document.cookie.length>0)
    {
        c_start=document.cookie.indexOf(c_name + "=");
        if (c_start!=-1)
        { 
            c_start=c_start + c_name.length+1; 
            c_end=document.cookie.indexOf(";",c_start);
            if (c_end==-1) 
                c_end=document.cookie.length;
            
            return unescape(document.cookie.substring(c_start,c_end));
        } 
    }
    
    return "";
}
    
String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g,"");
}
String.prototype.ltrim = function() {
    return this.replace(/^\s+/,"");
}
String.prototype.rtrim = function() {
    return this.replace(/\s+$/,"");
}

function onLoadAjaxRegionDetail()
{
    var regionCodeValue = getCookie("AMCDRegionCode");
    
    if(regionCodeValue=="")
    {
        regionCodeValue="<%=regionCodeDefault%>";
    }
    document.getElementById("reg"+regionCodeValue).selected="1";  
    
    var audienceType = document.getElementById("audienceType").value;
    var audienceTypeglob = document.getElementById("audienceTypeglob").value;
    var resultCount = document.getElementById("resultCount").value;
    var sortType = document.getElementById("sortType").value;
    var mcdEntity = document.getElementById("mcdEntity").value;
    var actionType = document.getElementById("actionType").value;
    var viewType = document.getElementById("viewType").value;
    var cqReq_Handle = "";
    var cellId  = document.getElementById("cellId").value;
    var viewAllMessage = "<%=viewAllMessage%>";   
    
    ajaxRegionDetail(regionCodeValue,audienceType,resultCount,sortType,mcdEntity,actionType,viewType,cqReq_Handle,cellId,viewAllMessage,false,audienceTypeglob);
} 

onLoadAjaxRegionDetail();
</script>  