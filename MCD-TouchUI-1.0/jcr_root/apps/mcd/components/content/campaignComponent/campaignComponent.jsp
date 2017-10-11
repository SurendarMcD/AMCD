<%--

  Campaign component component.

  Author : Nitin Sharma
 
--%>   
<%@include file="/apps/mcd/global/global.jsp"%>
<%@page session="false" %>
<%@ page import="
    com.day.cq.security.User,
    com.mcd.accessmcd.util.CommonUtil,
    com.day.cq.wcm.api.WCMMode,
    java.util.Date"%> 
    
<% 

        // Logged in user Details
        final User user = slingRequest.getResourceResolver().adaptTo(User.class);  //instantiate User object
        CommonUtil commonUtil  = new CommonUtil();
        WCMMode wcmMode= WCMMode.fromRequest(request);
        String mcdAudience = "";
        // Extract the Audience type from the user object

         if(user != null){ 
                   mcdAudience = user.getProperty("rep:mcdAudience");
                   if(mcdAudience == null || "null".equals(mcdAudience) || mcdAudience.equals("")) mcdAudience = "CorpEmployees" ;    
                   
         }      
   
         String[] campdata = (properties.containsKey("campdata"))? properties.get("campdata", String[].class) : null;
         Date curr =  new java.util.Date();
         Date d1,d2;

 %>    
   
  <div>

 <%
  
        if(null != campdata){
                       // if campaigns are configured
                      int allow =0;int temp=0;
                     for(int i =0 ; i < campdata.length ; i++)
                       {
                             allow=0;
                             String[] campaign = campdata[i].split("\\|");   //   Extract the Campaign Data
                             if(campaign[3].indexOf(mcdAudience)>= 0)
                             {
                                       allow = 1;  //Set  visibility based on logged in user.
                             }
                             
                             d1=new Date(campaign[4]);
                             d2=new Date(campaign[5]);
                             if(allow == 1 || (WCMMode.fromRequest(request) == WCMMode.EDIT))
                              {
                                temp=1;
                                // check whether the campaign is alive or not 
                                if(d1.compareTo(curr) <= 0  && curr.compareTo(d2) <=0)
                                 {
                                  if(campaign[0].equals("") && (wcmMode == WCMMode.EDIT))
                                   {
                                    out.println(langText.get("CAMPAIGN_IMAGE_NOT_SELECTED"));
                                   }   
                                  else
                                   {
 %>
                                                    <div id = "campaign"  style="text-align:center;">   
                                                     <a href = "<%= commonUtil.getValidURL(campaign[1]) %>"  target="_blank" ><img src="<%= campaign[0] %>" align="center" class="campaignImg" /></a>
                                                     </div>
                                <%
                                    }
                                  }
                                  else
                                  {
                                   if (wcmMode == WCMMode.EDIT)
                                    {
                                     out.println(langText.get("CAMPAIGN_NOT_LIVE"));
                                    }
                                   } 
                                 }
                       }
                       if (temp ==0 && wcmMode == WCMMode.EDIT)
                       {
                        out.println(langText.get("CONFIGURE_COMPONENT_MSG","",langText.get("Campaign component")));      
                       }
        }
        else
         {
          if (wcmMode == WCMMode.EDIT)
          {
            
            out.println(langText.get("CONFIGURE_COMPONENT_MSG","",langText.get("Campaign component")));
          } 
         }  
%>       

 </div>            
              