<%-- ########################################### 
 # DESCRIPTION: Site Finder Component
 #  
 # Environment: 
 # Author: Subodh Kumar    
 # UPDATE HISTORY         
 #
 ##############################################--%> 
 <%@ page import="  com.day.cq.security.User,
    com.mcd.accessmcd.util.CommonUtil,com.day.cq.wcm.api.WCMMode,
    com.mcd.accessmcd.common.helper.PCIHelper,
    com.day.cq.security.profile.Profile,
    java.net.URLEncoder" %><%      
%><%@include file="/apps/mcd/global/global.jsp"%>

<link href="/css/sitesaz.css" rel="stylesheet" type="text/css" />
   
<%
   CommonUtil commonUtil = new CommonUtil(); 
  
        //Getting values from dialog 
        String helpLink=properties.get("helpLink","#");
        helpLink = commonUtil.getValidURL(helpLink);
        String feedbackLink=properties.get("feedbackLink","#");
        feedbackLink = commonUtil.getValidURL(feedbackLink);
        
        String sfTitle=properties.get("sfTitle","");
        String description=properties.get("description","");
        
        String titleRowHeight = "10";
       
       
      //   Retrieve user audience type
      final User user = slingRequest.getResourceResolver().adaptTo(User.class);  //instantiate User object
    
      //Default AudienceType
      String mcdAudience = "CorpEmployees ";
      String []audienceTypes =  properties.get("admittedGroups",String[].class);
      mcdAudience =(String) user.getProperty("rep:mcdAudience");
   

      if(mcdAudience == null || mcdAudience.equals("")) 
      mcdAudience = "CorpEmployees" ;     

      int allowUser=0;
    
String view="corp";




String feedbackViewType = "";
feedbackViewType = prop.getProperty(view + "FeedbackView");
   
String userID=user.getID();  
String userName = "";//For storing user name
String userEmail = "";
String firstName = "";
String lastName = ""; 
Profile userProfile=user.getProfile();

if(user != null) {

    //user email
    
    if((user.getProperty("rep:e-mail"))!=null){
    
        userEmail=user.getProperty("rep:e-mail");
    }
    else{
          userEmail = userProfile.getPrimaryMail();
          if(userEmail == null || "null".equals(userEmail)) 
                userEmail = ""; 
             
   }
   
    //first name
    firstName = user.getProperty("givenName"); 
    if(firstName == null || "null".equals(firstName)) 
        firstName = "";
    
    //last name
    lastName = user.getProperty("familyName"); 
    if(lastName == null || "null".equals(lastName))
        lastName = "";
    
    userName = firstName + " " + lastName;
    userName=(userName.trim().equals(""))?user.getName():userName;
    
}
      

if(audienceTypes !=null){
  for(int k=0;k<audienceTypes.length;k++)  {
       if(audienceTypes[k].equals(mcdAudience)){
                 allowUser=1;break;
        }
  }
}else{%>

<%if(WCMMode.fromRequest(request) == WCMMode.EDIT)
{%>
 <%out.println(langText.get("CONFIGURE_COMPONENT_MSG","",langText.get("Sites A-Z"))); %>

<%} 
}
    


 
  if(allowUser==1){
        if(mcdAudience.equals("SupplierVendor"))mcdAudience="SupplierVendors"; //fix for incorrect mcdAudience value 11/27/13 ECW
        
        PCIHelper pciHelper= new PCIHelper(); 
        //log.error("*******************PCI***************"+pciHelper);
        
        String htmlContent="";
        htmlContent=pciHelper.getSiteFinderContent(currentPage,properties,"",mcdAudience,sling);
        //log.error("*******************HTML***************"+htmlContent);
    
%> 

        <TABLE height="100%" cellSpacing="0" cellPadding="0" width="100%" border="0">
            <TBODY>
            <tr> 
                <td>&nbsp;
                </td>
            </tr>
            <TR height="1">
               <TD noWrap width="100%" height="12">
                <TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
                  <TBODY>
                    <TR height=<%=titleRowHeight%>>
                     <TD class="mcdSkinPortletTitleBackgroundYellowSF" vAlign="top" align="left" width="6">
                     <IMG src='<%= currentDesign.getPath()%>/images/left_roundcnrnew.gif' align="top" border="0" />
               </TD>
                     <TD class="mcdSkinPortletTitleLargeSF" vAlign="middle" noWrap align="left" width="100%">
                     <%=sfTitle%>
                     <IMG title="Skip portlet" alt="" src="<%= currentDesign.getPath()%>/images/dot.gif" border="0" />
                     <IMG height="12" alt="" src="<%= currentDesign.getPath()%>/images/title_minheight.gif" width="1" align="absMiddle" border="0" /> 
             </TD>
             <td class="mcdSkinPortletTitleIconBackgroundBlueSF">
    
             <a href="#" onClick="javascript:openLink('<%=helpLink%>');">  
               <img border="0" align="absmiddle" class="mcdSkinPortletTitleIconSF" src='<%= currentDesign.getPath()%>/images/mcd_help.gif' alt='Help' title='Help'>
             </a>
             </TD>
             <TD class="mcdSkinPortletTitleBackgroundYellowSF" style="WIDTH: 6px" vAlign="top" align="right">
             <IMG src= <%= currentDesign.getPath() + "/images/right_roundcnrnew.gif" %> align="top" border="0" /> 
             </TD>
            </TR>
           </TBODY>
         </TABLE>
                </TD>
           </TR>
               <TR>
           <TD class="mcdSkinPortletDropShadow1"> </TD>
           </TR> 
           <TR>
           <TD class="mcdSkinPortletDropShadow2"></TD>
           </TR>
           <TR>
           <TD class="mcdSkinPortletDropShadow3"></TD>
           </TR>
           <TR>
           <TD class="mcdSkinPortletDropShadow4"></TD>
           </TR>
           <TR>
           <TD class="mcdSkinPortletDropShadow5"></TD>
           </TR>
           <TR height="100%">
        <TD vAlign="top" width="100%">
         <TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
           <TBODY>
             <TR>
            <TD class="mcdSkinPortletBorderSF">
            <IMG height="1" src="/images/spacer.gif" width="15" />
            </TD>
            <TD class="mcdSkinPortletBorderSF" dir="ltr" style="PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px" vAlign="top" width="100%">
            <TABLE width="100%">
              <TBODY>
               <TR>
                <TD vAlign="top">
                <TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
                <TBODY>
                <TR>
                <TD width="7%">
                </TD>
                <TD style="FONT-WEIGHT: bold;color:#494647" align="center" width="86%"> 
                <% 
                   String separator = "?";
                   separator = feedbackLink.indexOf("?") != -1 ? "&" : "?"; 
                   
                   String fburl=feedbackLink+separator+"pre_q2_ftxt="+userID+"&pre_q1_ftxt="+userName.replaceAll(" ","%20")+"&pre_q3_ftxt="+userEmail+"&pre_q4_ftxt="+mcdAudience+"&pre_q5_ftxt=";
                   //log.error("********************ERROR********************"+fburl);
   
                   String feedbacklink="<a id='fd'  onclick='openfeedback(\""+fburl+"\")' href='javascript:void(0);'>feedback</a>"; 
                   String Feedbacklink="<a id='fd'  onclick='openfeedback(\""+fburl+"\")' href='javascript:void(0);'>Feedback</a>";  
                  
                   if(description.contains(" feedback"))  
                       description=description.replaceAll(" feedback",feedbacklink);
                   if(description.contains(" Feedback"))                   
                       description=description.replaceAll(" Feedback",Feedbacklink);
                %>
                       <%=description%>
                 
                </TD>
                <TD width="7%"></TD>
                    </TR>
                </TBODY>
                </TABLE>           
             <%=htmlContent %>
                 </TD>
                </TR>
               </TBODY>
              </TABLE>
             </TD>
            </TR>
           </TBODY>
          </TABLE>
        </TD>
           </TR>


        <TR>
         <TD>
          <TABLE cellSpacing="0" cellPadding="0" width="100%" border="0">
           <TBODY><TR>
             <TD style="WIDTH: 6px">
            
             </TD>
             <TD class="mcdSkinPortletBorderSF" width="100%">
             <IMG height="1" src="/images/spacer.gif" width="1" />
             </TD>
             <TD style="WIDTH: 6px">
             </TD>
           </TR>
        </TBODY>
           </TABLE>
          </TD>
         </TR>
        </TBODY>
       </TABLE>
     </TD>
    </TR>

       

 <%}%>  
  
<script>
function openfeedback(feedbacklink){
var feedbklink=feedbacklink;
var view=UserInfoObject.view;
var feedback=new Array();
feedback['corpFeedBack']="Global";
feedback['usFeedBack']="United States"; 
feedback['auFeedBack']="McSource";
feedback['nzFeedBack']="New Zealand";
//alert(view);
view=feedback[view+'FeedBack'];
feedbklink=feedbklink+view;
//alert(feedbklink);
window.open(feedbklink); 
 
}
</script>

  