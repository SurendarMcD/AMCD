<%-- ########################################### 
 # DESCRIPTION: This is the GCD component which include a specific jsp depending upon the functionality selected by  author
 # Author: Nitin Sharma
 # 
 # Copyright (c) 2008 HCL Technologies Ltd. All rights reserved.    
 ##############################################--%>    
                                 
<%@ include file="/apps/mcd/global/global.jsp" %>      
<%@ page session="false" %>         
                                                                                    
              
        <%
        String comp = properties.get("comp","");   
        if(comp.equals(""))
        {
         out.println(langText.get("Please configure the GCD component")); 
        }
        else if(comp.equals("comp1"))  // Basic Search
        {
          %>     
          <%@ include file="/apps/mcd/components/content/gcd/gcdbasicsearch.jsp" %>   
        <%
        }
        else if(comp.equals("comp2"))  // Advanced Search
        {
          %>     
          <%@ include file="/apps/mcd/components/content/gcd/gcdAdvanceSearch.jsp" %>   
        <%
        }
        else if(comp.equals("comp3"))   // Search Results
        { 
                
        %>
           <%@ include file="/apps/mcd/components/content/gcd/gcdSearchResults.jsp" %>
        <% 
        }   
        else if(comp.equals("comp4"))   // Search Results
        { 
        
        %>
          <%@ include file="/apps/mcd/components/content/gcd/gcdViewProfile.jsp" %> 
        <% 
        }     
        else if(comp.equals("comp5")) // Activate Country
        {
          %>     
          <%@ include file="/apps/mcd/components/content/gcd/gcdActivateCountry.jsp" %>   
        <%     
         }                 
        else if(comp.equals("comp6")) // View US buildings
        {           
          %>                  
           <%@ include file="/apps/mcd/components/content/gcd/gcdGetUsBuilding.jsp" %>
        <%
         }                  
        else if(comp.equals("comp7")) // Maintain US buildings
        {       
          %>     
          <%@ include file="/apps/mcd/components/content/gcd/gcdMaintainUSBuilding.jsp" %>   
        <%
         }   
        else if(comp.equals("comp8")) // Get International buildings
        {
          %>        
          <%@ include file="/apps/mcd/components/content/gcd/gcdGetINTLBuilding.jsp" %>   
        <%
         }   
        else if(comp.equals("comp9")) // Maintain International buildings
        {
          %>     
            <%@ include file="/apps/mcd/components/content/gcd/gcdmaintainINTLBuilding.jsp" %> 
        <% 
        }      
        %>                               
                                                                               