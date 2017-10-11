<%-- #############################################################################
# DESCRIPTION:  Search Results
# Author: HCL Technologies   
# Environment: 
#  
# INTERFACE    
# Controller:  
# Targets:   
# Inputs: 
#                    
# Outputs:      
#  
# UPDATE HISTORY       
# 1.0 HCL, 01-07-2011, Initial Version 
#  
# Copyright (c) 2008 HCL Technologies Ltd. All rights reserved. 
###################################################################################--%><%
%><%@include file="/apps/mcd/global/global.jsp"%><%
%><%@page session="false" %>
<%@ page import="java.util.Iterator,                 
                 java.util.Map,
                 java.util.*,
                 java.text.SimpleDateFormat,
                 javax.jcr.Session,
                 com.day.cq.wcm.api.Page,
                 com.day.cq.search.Query,
                 com.day.cq.search.PredicateGroup,
                 com.day.cq.search.result.SearchResult, 
                 com.day.cq.search.result.Hit,
                 javax.jcr.Node,
                 com.day.cq.search.QueryBuilder,
                 java.util.HashMap" %><%  
%> 

<%      
        //Retrieving values from query parameter        
        String text= request.getParameter("wwkbSearchText"); 
        String menuCategory=request.getParameter("searchProductType"); 
        String targetAudience=request.getParameter("searchTargetAudience"); 
        String dayPart=request.getParameter("searchDaypart"); 
        String menuItemRole=request.getParameter("searchMenuCategory");
        String area=request.getParameter("searchZone");
        String country=request.getParameter("searchCountry"); 
        String includeArchivedItems=request.getParameter("wwkbArchieved"); 
        Date formattedDateAdded;
        
        
        String[] showCategory=null;
        String[] showDayPart=null;
        String[] showTarget=null;
        String[] showRole=null;
        String showArchived=""; 
        String delim=",";
        
        //Root Path for searching     
        String rootPath = "/content/accessmcd/corp/services_support/gms/products";  
        Map<String,String> unsortedMap= new HashMap<String,String>();
        List<String> sortedArrayList=new ArrayList<String>();        
        List<String> pathArrayList=new ArrayList<String>();
        
        //Searching for search  except text search   
        // create query description as hash map (simplest way, same as form post)
        Map<String, String> map = new HashMap<String, String>();
        map.put("path",rootPath);     
       
        map.put("1_property","WWKBMenuCategory"); 
        map.put("1_property.value",menuCategory);  
        map.put("2_property","WWKBTargetAudience");
        map.put("2_property.value",targetAudience); 
        map.put("3_property","WWKBProductDaypart"); 
        map.put("3_property.value",dayPart); 
        map.put("4_property","WWKBMenuItemRole"); 
        map.put("4_property.value",menuItemRole);  
        map.put("5_property","WWKBZone"); 
        map.put("5_property.value",area); 
        map.put("6_property","WWKBCountry"); 
        map.put("6_property.value",country);       
        map.put("group.8_fulltext",text);  
        map.put("group.8_fulltext.relPath", "");  
         
        //initialising variables to build query 
        Session session = slingRequest.getResourceResolver().adaptTo(Session.class);
        QueryBuilder builder= slingRequest.getResourceResolver().adaptTo(QueryBuilder.class);
        
        // can be done in map or with Query methods               
        Query query = builder.createQuery(PredicateGroup.create(map), session);                
        query.setHitsPerPage(1000);
        SearchResult result = query.getResult(); 
        session.logout();
        session = null;
       %>  

<div id= "result">
        
       <%
        out.println( "<br><br>  Matches: " + result.getTotalMatches() + " <br><br>"); 
        //out.println("Hits per page: " + result.getHitsPerPage() + " <br><br>");  
        // out.print("Query Statement: " + result.getQueryStatement() + " <br><br>");  
        
        // iterating over the results 
        if(result.getTotalMatches()>0){  
            try {   
            log.error("HIIIIIIIIIIIIIIITTTTTTTTTTTTTTTSSSSSSSSS SSSSSSStttttttttaaaaaaaaaarrrrrrrrrrtttttttttttiiinnnnnnnnnggg" );      
                   for (Hit hit : result.getHits()) {     
                        String path = hit.getNode().getParent().getPath();
                        log.error("****************************************************************** " +path);
                        if ((null!=path && (!path.equals(rootPath)))){
                                Page resultPage = pageManager.getPage(path);
                                
                                if(null != resultPage) {
                                    log.error("***************************************** Resultpage available :: " + path); 
                                    String pageTitle = resultPage.getTitle();
                                    unsortedMap.put(pageTitle,path);
                                    sortedArrayList.add(pageTitle);                                                                                                                                                                     
                                } else{
                                    log.error("#################################### Resultpage is null :: " + path);  
                                }
                         } 
                   }  
                             Collections.sort(sortedArrayList);
                             
                                log.error("****************************************************************** " +sortedArrayList);

                             for(String s:sortedArrayList){
                                 pathArrayList.add(unsortedMap.get(s));
                             }                   
    %>
                             <table  width="100%" cellspacing="0" cellpadding="0" border="1" class=se>
                             <tr class="searchgms">
                                 <th >
                                 Product Description
                                 </th>
                                 <th>
                                 Characteristics
                                 </th>
                                 <th>
                                    AOW/Country
                                 </th>
                                 <th>
                                 Archived
                                 </th>
                                 <th>
                                 Date Added
                                 </th>                            
                             </tr>
    <%                       
                             for(String pathValue:pathArrayList){
                                 Page finalPage = pageManager.getPage(pathValue);
    %>
                                 <tr>
                                     <td class=searchgmsarchive>
                                         <a href="<%=pathValue%>.html"><%=finalPage.getTitle()%></a><br />&nbsp;
                                         <%=finalPage.getProperties().get("jcr:description","")%>
                                     </td>
                                     <td class=searchgmsarchive>
                                     <b>Item Category:</b>                                 
    <% 
                                showCategory=(finalPage.getProperties().get("WWKBMenuCategory",String[].class));
                                 if(showCategory!=null){
                                     for(int i=0;i<showCategory.length;i++){
                                     showCategory[i]=new String(showCategory[i].getBytes("8859_1"),"UTF-8"); 
                                         if(i==showCategory.length-1)
                                             delim="&nbsp";                             
        %>                                 
                                     <%=showCategory[i]%><%=delim%>     &nbsp;    
        <%                            
                                     }
                                     } 
                                 
    %>                                     
                                         <br/>
                                         <b>Item Role:</b>
    <%
                                 showRole=(finalPage.getProperties().get("WWKBMenuItemRole",String[].class));
                                     if(showRole!=null){
                                         delim=",";
                                         for(int i=0;i<showRole.length;i++){
                                             if(i==showRole.length-1)
                                                 delim="";     
    %>                                     
                                         <%=showRole[i]%><%=delim%>&nbsp;
    <%
                                         }
                                     }
                                     
    %>                             
                                 <br />
                                         <b>Day Part:</b>
    <%
                                 showDayPart=(finalPage.getProperties().get("WWKBProductDaypart",String[].class));
                                     if(showDayPart!=null){
                                     delim=",";
                                         for(int i=0;i<showDayPart.length;i++){
                                         if(i==showDayPart.length-1)
                                             delim="";     
    %>                                     
                                 <%=showDayPart[i]%><%=delim%>&nbsp;
    <%
                                         }
                                     }
    %>
                                 <br />
                                         <b>Target:</b>
    <%
                                 showTarget=(finalPage.getProperties().get("WWKBTargetAudience",String[].class));
                                     if(showTarget!=null){
                                         delim=",";
                                         for(int i=0;i<showTarget.length;i++){
                                             if(i==showTarget.length-1)
                                                 delim="";     
    %>                                     
                                 <%=showTarget[i]%><%=delim%>&nbsp;
    <%
                                         }
                                     }
    %>                                                          
                                     </td>
                                     <td class=searchgmsarchive> 
                                     <b>AOW:</b><%=finalPage.getProperties().get("WWKBZone","")%>&nbsp;
                                     <br />
                                     <b>Country</b><%=finalPage.getProperties().get("WWKBCountry","")%>&nbsp;
                                     </td>                                                           
                                     <td class=searchgmsarchive>&nbsp; 
    <%
                                     showArchived=finalPage.getProperties().get("WWKBArchievedFlag","no");
                                     if(!showArchived.equals("no")){
    %>                               
                                         <%=showArchived%> 
    <%
                                     }
    %>                                   
                                     </td>
                                       <td class=searchgmsarchive>
                                          <%
                                            String pattern = "MM/dd/yyyy"; 
                                            SimpleDateFormat format = new SimpleDateFormat(pattern); 
                                            try { 
                                            formattedDateAdded=finalPage.getProperties().get("jcr:created",Date.class);
                                            Date date = format.parse(format.format(formattedDateAdded));
                                            out.println(format.format(date));  
                                            }  
                                            catch (Exception e) { 
                                            e.printStackTrace();
                                            }
                                            %>  
                                     </td>      
                                 </tr>
    <%                   
                             }
    %>
                             </table>
    <%                                                          
              }                   
           catch(Exception e){
               log.error("**************************"+e);
           }
      } 
         
     %>    
            </div>           