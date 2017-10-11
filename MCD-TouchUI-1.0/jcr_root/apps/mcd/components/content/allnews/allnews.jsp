<%--

  completeNews component.

  

--%><%
%><%@include file="/apps/mcd/global/global.jsp"%><%
%><%@page import="com.mcd.accessmcd.pci.bo.PCIQuery,
                  com.mcd.accessmcd.pci.bo.PCIResult,
                  com.mcd.accessmcd.pci.facade.IPCIContentDeliveryFacade, 
                  com.mcd.accessmcd.pci.facade.impl.PCIContentDeliveryFacadeImpl,
                  com.day.cq.wcm.api.WCMMode,
                  com.mcd.accessmcd.common.helper.PCIHelper,
                  com.day.cq.security.User" %><%   
%>
<script type="text/javascript" src="/scripts/sortable.js"></script>
<style type="text/css">
a.sortheader,a#glbLink{
color:#4678A7;
font-family:Arial,Helvetica,sans-serif;
font-size:11px;
line-height:135%;
text-decoration:none;
} 
a.sortheader:hover,a#glbLink:hover{
color:#4678A7;
font-family:Arial,Helvetica,sans-serif;
font-size:11px;
line-height:135%;
text-decoration:underline;
} 
/*#heading{
color:#3366CF;
font-family:Arial,Helvetica,sans-serif;
font-size:11px;
font-weight:bold;
line-height:135%;
text-decoration:underline;
} */
</style>
<%    
        String mcdAudience = "CorpEmployees";        
        String catId = "";
        String sortType = "";        
        String title = "";
        String viewType = "content";
        String stylesheet_path = "";
        String entityType = ""; 
        String resultCount="1000";                               
        
        //   Retrieve logged in user audience type
        final User user = slingRequest.getResourceResolver().adaptTo(User.class);  //instantiate User object  
        
        //Initialize variable for content fetched from PCI
        String content="";
        String selector="";
        mcdAudience =(String) user.getProperty("rep:mcdAudience");
                 
            
        //Set default audience type.
        if(mcdAudience == null || mcdAudience.equals("")) 
        mcdAudience = "CorpEmployees" ;  
      
 
        String  audienceType=mcdAudience; 
         
        String[] currentSelectors = slingRequest.getRequestPathInfo().getSelectors();
        if(currentSelectors.length>0){            
            selector=currentSelectors[0];
        }   
        if(!selector.equals("newsTab1") && !selector.equals("newsTab2") && !selector.equals("newsTab3") && !selector.equals("newsTab4") ){   
            selector="newsTab1";
        }              
        if(selector.equals("newsTab1")){        
            //Parameter retrieved from request object for News                 
            catId = properties.get("globalCatId","");
            sortType = properties.get("globalSortType","rchrono");
            title=properties.get("globalTitle","");           
            viewType=properties.get("globalViewType","content");
            stylesheet_path=properties.get("globalNewsStyleSheet","");
            entityType=properties.get("globalEntityType","US");  
        }        
        else if(selector.equals("newsTab2")){        
            //Parameter retrieved from request object for News         
            catId = properties.get("mcdCatId","");
            sortType = properties.get("mcdSortType","rchrono");
            title=properties.get("mcdTitle","");          
            viewType=properties.get("mcdViewType","content");
            entityType=properties.get("mcdEntityType","US");   
            stylesheet_path=properties.get("mcdNewsStyleSheet","");
        }
        else if(selector.equals("newsTab3")){
            //Parameter retrieved from request object for News         
            catId = properties.get("usCatId","");
            sortType = properties.get("usSortType","rchrono");
            title=properties.get("usTitle","");  
            viewType=properties.get("usViewType","content");
            entityType=properties.get("usEntityType","");   
            stylesheet_path=properties.get("usNewsStyleSheet","");            
        }         
        else if(selector.equals("newsTab4")){
            //Parameter retrieved from request object for News         
            catId = properties.get("regionalCatId","");
            sortType = properties.get("regionalSortType","rchrono");
            title=properties.get("regionTitle","");  
            viewType=properties.get("regionalViewType","content");
            entityType=properties.get("regionalEntityType","");   
            stylesheet_path=properties.get("regionalNewsStyleSheet",""); 
        }
        if(!title.equals("")){
%>
            <table id="allNewsTitle"><tr><td width="54px"></td><td><b><u><%=title%></u></b></td></tr></table>
<%      }  
        
        IPCIContentDeliveryFacade pciContentFacade = new PCIContentDeliveryFacadeImpl(sling);

        //News Query   
        PCIQuery pciQuery = new PCIQuery();        
        pciQuery.setAudience(audienceType);  
        pciQuery.setCategoryID(catId);
        pciQuery.setSortType(sortType);
        pciQuery.setViewType(viewType);
        pciQuery.setEntityType(entityType);
        pciQuery.setResultCount(resultCount);
        
        String key=pciQuery.getOSCacheKey();
        if(WCMMode.fromRequest(request) == WCMMode.EDIT || WCMMode.fromRequest(request) == WCMMode.PREVIEW)
        {
            key="";
        }
        
        PCIResult[] results=pciContentFacade.getPCIContent(pciQuery);
        try{
        PCIHelper pciHelper= new PCIHelper(); 
        content=pciHelper.getTabContent(results,stylesheet_path,key,properties,sling);
        }
        catch(Exception e){
        log.error("Complete News Error "+e);
        }
        if(!content.trim().equals("")){
%>
        <%=content%>
<% 
        }
        else{
%>      
        <%=langText.get("COMPLETE_NEWS_NO_RESULT")%> 
<%
        }
%>       
