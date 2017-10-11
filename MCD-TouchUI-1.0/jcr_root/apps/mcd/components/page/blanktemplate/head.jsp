<%@include file="/apps/mcd/global/global.jsp" %> 
<head> 
<%

    String title = currentPage.getTitle();
    if (title==null  || title.equals("")){
       title = "No Title";
    } 
    
    String metaDescription = currentPage.getDescription();
    if ((metaDescription == null) || metaDescription.equals("") ) {
        metaDescription = title;
    }

    

//also added the following meta info

%>  
   
<meta name="description" content="<%= metaDescription %>" />
<meta name="keywords" content="<%= WCMUtils.getKeywords(currentPage) %>" />
 <% currentDesign.writeCssIncludes(pageContext); %>    
<cq:include script="/apps/mcd/global/init.jsp"/> 
<%-- Jquery Colorbox styles --%>  
        <link rel="stylesheet" type="text/css" media="screen" href="/css/jquery.mcdcolorbox.css" />
        
        <!--[if IE 7]>
            <link rel="stylesheet" type="text/css" media="screen" href="/css/mcdcolorbox_ie7.css" />  
        <![endif]-->  
    <%-- End of Jquery Colorbox styles --%>   
    
    <%-- Including OOB Scripts --%>   
    <script type="text/javascript" src="/scripts/jquery-1.3.2.min.js"></script> 
    <script type="text/javascript" src="/scripts/swfobject.js"></script>  
    
    <%-- Including Application Specific Scripts --%>
    <script type="text/javascript" src="/scripts/common.js"></script>    
    
    <script type="text/javascript" src="/scripts/sling.js"></script>

    <script type="text/javascript" src="/scripts/jquery.activetextinput.js"></script>
    <script type="text/javascript" src="/scripts/global_utils.js"></script>
    <script type="text/javascript" src="/scripts/jquery.colorbox-mod.js"></script>
    <script type="text/javascript" src="/scripts/jquery.mcdcolorbox.js"></script>
    <script type="text/javascript" src="/scripts/jquery-ui-1.7.2.custom.min.js"></script>
    <script type="text/javascript" src="/scripts/jquery.ifixpng.js"></script>  
    <script type="text/javascript" src="/scripts/grayout.js"></script> 
    <script type="text/javascript" src="/scripts/jquery.hoverIntent.js"></script>   
    <script type="text/javascript" src="/scripts/DD_roundies_0.0.2a-min.js" ></script>      
    <script type="text/javascript" src="/scripts/jquery.autocomplete.js" ></script>     
    <script type="text/javascript" src="/scripts/jquery.bgiframe.js" ></script>  
    
<title><%= currentPage.getTitle() == null ? currentPage.getName() : currentPage.getTitle() %></title>
</head> 
