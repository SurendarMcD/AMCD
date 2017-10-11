 <%@include file="/apps/mcd/global/global.jsp"%>  
 <%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList,
        java.util.Iterator, com.day.cq.security.privileges.*,
        javax.jcr.Node,javax.jcr.Session,org.apache.sling.jcr.api.SlingRepository,
        org.apache.sling.api.scripting.SlingScriptHelper,
        com.day.cq.security.User,org.apache.sling.api.resource.ResourceResolver,
        org.apache.sling.api.resource.Resource,
        java.util.ListIterator"%>                      
<%

final User user = slingRequest.getResourceResolver().adaptTo(User.class);//instantiate User object
String userId = user.getID();
String path= (request.getParameter("path")!= null) ? request.getParameter("path").toString().trim() : "";
String hover = request.getParameter("hover")!= null ? request.getParameter("hover") : "";
String count = request.getParameter("likeCount")!= null ? request.getParameter("likeCount") : "";

if(count.equals("")){count="0";}

int likeCount = Integer.parseInt(count);

boolean value = false;
String pauth = "";
Node pageNode = resourceResolver.getResource(path).adaptTo(Node.class); 


if( path.length() > 0 && (likeCount == 0 || likeCount > 0) && hover.equals(""))
{

         if(pageNode.hasProperty("likeIdentifierList"))
          {     
          
         
              pauth = pageNode.getProperty("likeIdentifierList").getString(); 
          
             if(pauth.contains(","))
                   {
                      
                       String [] allauth=pauth.split(",");
                       for(String gp:allauth)                            
                       { 
                          if(userId.trim().equalsIgnoreCase(gp))
                                 {
                                  //do nothing
                                  pageNode.setProperty("likeCount",likeCount);
                                  value=true;
                                    break;
                                 }                            
                       }
                       
                       if(!value){
                                   
                                    pauth=pauth+","+userId.trim();
                                    pageNode.setProperty("likeIdentifierList",pauth);
                                    likeCount=likeCount+1;
                                    pageNode.setProperty("likeCount",likeCount);
                                  }  
                   } 
              else{
                      if(pauth.trim().equalsIgnoreCase(userId))
                      {
                      // do nothing
                          value=true;
                         pageNode.setProperty("likeCount",likeCount);
                      }
                      else
                      {
                           
                           pauth=pauth+","+userId.trim();
                           pageNode.setProperty("likeIdentifierList",pauth);
                          likeCount=likeCount+1;
                          pageNode.setProperty("likeCount",likeCount); 
                           value=false;
                      }     
                  }
       }
    else 
    { 
      
        value=false;
        pageNode.setProperty("likeIdentifierList",userId.trim());
        likeCount=likeCount+1;
        pageNode.setProperty("likeCount",likeCount);
    }
        pageNode.save();        
     
  }      
%>
{"results":{"likeCount":"<%=likeCount%>","value":"<%=value%>"}}  