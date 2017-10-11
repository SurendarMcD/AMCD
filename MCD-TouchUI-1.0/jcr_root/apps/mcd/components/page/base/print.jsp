
<%@include file="/apps/mcd/global/global.jsp" %> 
<%@page session="false"
            contentType="text/html; charset=utf-8"
            import="com.day.cq.commons.Doctype,
                    com.day.cq.wcm.api.WCMMode,
                    com.day.cq.wcm.foundation.ELEvaluator" %><%
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %><%
%><cq:defineObjects/><%

    // read the redirect target from the 'page properties' and perform the
    // redirect if WCM is disabled.
    String location = properties.get("redirectTarget", "");
    // resolve variables in path
    location = ELEvaluator.evaluate(location, slingRequest, pageContext);
    if (WCMMode.fromRequest(request) == WCMMode.DISABLED && location.length() > 0) {
        // check for recursion
        if (!location.equals(currentPage.getPath())) {
            response.sendRedirect(request.getContextPath() + location + ".html");
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
        return;
    }
    // set doctype
    Doctype.HTML_401_STRICT.toRequest(request);

%><%= Doctype.fromRequest(request).getDeclaration() %> 


<html>
    
    <cq:include script="head.jsp"/>
      <body>
            <cq:include script="additionalinfo.jsp" /> 
            <div align="center"><a href="javascript:printWindow()">Print This Page</a></div>
            
            <%
            
            String homePages[] = prop.getProperty("cacheContent").split(",");
            boolean isHomePage = false;
            
            for(int i=0; i<homePages.length ; i++) {
                if( homePages[i].equals(currentPage.getPath()) ) {
                    isHomePage = true;
                    break;
                } 
            }
 
            if ( WCMMode.fromRequest(request) == WCMMode.DESIGN || WCMMode.fromRequest(request) == WCMMode.EDIT || !isHomePage ) {  
   
            %>               
               
                    <cq:include script="contentbar.jsp" /> 
                        
            <% 
            } else { 
            %>
               <div id="printSection" > </div> 
            
               <script>
                   if(UserInfoObject == null){
                        var url = '<%=currentPage.getPath().replaceAll("/content/","/")%>.moreinfo.html?getdata=1';
                        $.ajax({
                            url: url,
                            type: 'GET',    
                            timeout: 120000,
                            data: '',  
                            cache: true,   
                            error: function(){
                                    alert("Error during AJAX call while loading the body. Please try again");   
                            },    
                            success: function(xml){                                   
                                    UserInfoObject = eval('(' + xml + ')');  
                                     
                                    //retrieve data from contentbar.jsp
                                    getPageContent('<%=currentPage.getPath().replaceAll("/content/","/")%>.contentbar.'+ UserInfoObject.mcdAudienceGlob +'.html', '#printSection', 'Error during AJAX call while loading the print section. Please try again') ;
                                }
                        });
                    } else {       
                                
                        //retrieve data from contentbar.jsp
                        getPageContent('<%=currentPage.getPath().replaceAll("/content/","/")%>.contentbar.'+ UserInfoObject.mcdAudienceGlob +'.html', '#printSection', 'Error during AJAX call while loading the print section. Please try again') ;                 
                    }                     
               
               </script>    
            <%
            } 
            %>   
      </body>
</html>