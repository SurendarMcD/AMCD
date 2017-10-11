<%-- ################################################################################ 
 # DESCRIPTION: Used in awesome and navigation bar. 
 #              Retrieve values like user, audience type etc in form of JSON object.
 #  
 # Environment: 
 # 
 # UPDATE HISTORY       
 # 1.0  Deepali Goyal Initial Version
 #
 #####################################################################################--%>
 
<%@ page import="java.util.ArrayList,java.util.Iterator,com.day.cq.wcm.api.PageFilter"%> 
<%@ page import="com.day.cq.security.User,java.util.*,
                 com.mcd.accessmcd.calendar.util.DesEncrypter,
                 com.mcd.accessmcd.util.CommonUtil,
                 com.day.cq.wcm.api.WCMMode"%><%
%>

<%@include file="/apps/mcd/global/global.jsp"%> 
<% response.setHeader("Cache-Control","no-cache"); %><%     
%><%
final User user = slingRequest.getResourceResolver().adaptTo(User.class);//instantiate User object
CommonUtil commonUtil = new CommonUtil();

boolean foundCookie = false;

String view = "corp";
String path = "";
String views=prop.getProperty("views"); 
String allViews =prop.getProperty("allview");  
String [] cview = null;
 if(allViews.contains(","))
 {
  cview= allViews.split(",");
 }

String viewPagePath = currentPage.getPath();

path = commonUtil.getDefaultHomePage(user);   

view = prop.getProperty(currentPage.getPath()); 
Cookie[] cookies = request.getCookies(); 
    if(cookies != null) { 
        for(int i = 0; i < cookies.length; i++) { 
            Cookie cookie1 = cookies[i];
            if (cookie1.getName().equals("userview")) {
                view = cookie1.getValue();
               
                if(view == null || view.trim().equals(""))
                {
                  view = "corp"; 
                }else
                {
                  foundCookie = true; 
                }
            }
        }
    }    


if(view == null ) { 

   
    String [] pageViews = views.split(",");
    String [] pView=new String[2];  
    
    for(int k=0;k<pageViews.length;k++)
    { 
       pView=pageViews[k].split("\\|");
       if(viewPagePath.toLowerCase().startsWith(pView[0].toLowerCase()))
       {

             view = pView[1];
            
             break;
        }
       
    }  
   
      
     
}
String otherPath="";
if(view == null)
{
 view = "corp";
}    
 if (!foundCookie) {
        path = commonUtil.getDefaultHomePage(user);   
        //view = prop.getProperty(path); 
        if(WCMMode.fromRequest(request) == WCMMode.DESIGN || WCMMode.fromRequest(request) == WCMMode.EDIT || WCMMode.fromRequest(request) == WCMMode.PREVIEW ) {
           boolean homePage=false;
           if(cview != null)
           {
              for(int i =0 ; i < cview.length ; i++) 
             {
              if(prop.getProperty(cview[i]) != null)
              {
               if( viewPagePath.trim().equalsIgnoreCase(prop.getProperty(cview[i])) )
                {
                 homePage = true;
                 view = cview[i];
                 break;
                }
              }
             }
           }     
              
                        
                if(!homePage)
                {
                                                    
                     Resource res = slingRequest.getResourceResolver().getResource(viewPagePath);
                     if(null!=res) {
                         Node otherNode = res.adaptTo(Node.class);
                         if(otherNode.getParent()!=null)
                          {
                             Node potherNode=otherNode.getParent();
                             otherPath=potherNode.getPath();
                          }
                      }
                   if(cview != null)
                   {   
                    for(int i =0 ; i < cview.length ; i++) 
                    {
                     if(prop.getProperty(cview[i]) != null)
                     {
                      if( otherPath.trim().equalsIgnoreCase(prop.getProperty(cview[i])) )
                      {
                       view = cview[i];break;
                      }
                     }
                    }
                   }   
      
            } 
        }
        else{
            Cookie cookie1 = new Cookie("userview", view);
            cookie1.setPath("/");
            //cookie1.setMaxAge(24*60*60);
            response.addCookie(cookie1);
        }   
              
    }else{   
            boolean homePage=false;
            if(cview != null)
            {
             for(int i =0 ; i < cview.length ; i++) 
             {
              if(prop.getProperty(cview[i]) != null)
              {
               if( viewPagePath.trim().equalsIgnoreCase(prop.getProperty(cview[i])) )
                {
                 homePage = true;
                 view = cview[i];break;
                }
              }
             }
            }  
            
              if(!homePage)
                {
                                                    
                     Resource res = slingRequest.getResourceResolver().getResource(viewPagePath);
                     if(null!=res) {
                         Node otherNode = res.adaptTo(Node.class);
                         if(otherNode.getParent()!=null)
                          {
                             Node potherNode=otherNode.getParent();
                             otherPath=potherNode.getPath();
                          }
                       }
                     if(cview != null)
                     {   
                      for(int i =0 ; i < cview.length ; i++) 
                      {
                       if(prop.getProperty(cview[i]+"_nav") != null)
                       {
                        if( otherPath.trim().equalsIgnoreCase(prop.getProperty(cview[i]+"_nav")) )
                        {
                         view = cview[i];break;
                        }
                       }
                      }
                     }    
           
                }
                 
    
    }

             
%>

<%
// Added section for retrieving the USER DETAILS
String userID = user.getID();

String userName = "";//For storing user name
String userEmail = "";
String firstName = "";
String lastName = "";
String mcdAudience="CorpEmployees";
String alias="";
if(user != null) {

    //user email
    userEmail = user.getProperty("rep:e-mail"); 
    if(userEmail == null || "null".equals(userEmail)) 
        userEmail = ""; 
    
    //first name
    firstName = user.getProperty("givenName"); 
    if(firstName == null || "null".equals(firstName)) 
        firstName = "";
    
    //last name
    lastName = user.getProperty("familyName"); 
    if(lastName == null || "null".equals(lastName))
        lastName = "";
    
    mcdAudience = user.getProperty("rep:mcdAudience");
    if(mcdAudience == null || "null".equals(mcdAudience) || mcdAudience.equals("")) 
            mcdAudience = "CorpEmployees" ;   
                              

    // To Get Alias of Audience Type
     alias = commonUtil.getAlias(mcdAudience);
     if(alias == null || "null".equals(alias ) || alias.equals("")) 
       alias="CE";
      
    userName = firstName + " " + lastName;
    userName=(userName.trim().equals(""))?user.getName():userName;
    
}
%> 

<%         
DesEncrypter encrypter = new DesEncrypter();
String encryptedAudType=""; 
    
//code to encrypt the Audience type of the logged in user
encryptedAudType = encrypter.encrypt(mcdAudience).replace("/",""); 
%> 

<%
String viewPath = globalPath;

try {
    viewPath = prop.getProperty(view);    
} catch(Exception e) { 
    log.error("moreinfo.jsp Error " + e.getMessage());
}
%>
 
{
   "uid" : "<%=userID %>", 
   "uname" : "<%=userName %>",
   "mcdAudience" : "<%=mcdAudience %>",
   "mcdAudienceGlob" : "<%=encryptedAudType %>",
   "userEmail" : "<%=userEmail %>",  
   "view" : "<%=view %>",
   "viewPath" : '<%=viewPath.trim()%>',
   "alias" : "<%= alias %>"  
}   
 

    