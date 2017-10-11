<%@include file="/apps/mcd/global/global.jsp"%>
<%@page session="false" %>
<%@page import="com.day.cq.security.User,
        java.util.Map, java.util.List,
        com.day.cq.wcm.api.WCMMode,
        com.mcd.accessmcd.searchhistory.bean.HistoryItem,
        com.mcd.accessmcd.searchhistory.manager.SearchHistoryManager,
        com.mcd.accessmcd.searchhistory.manager.impl.SearchHistoryManagerImpl"%>
        
<%   
        response.setHeader("Cache-Control","no-cache");
        response.setDateHeader("Expires", 0);
        response.setHeader("Pragma","no-cache");
%>


<script>   
 $(document).ready(function(){  
    var resource = "<%=currentPage.getPath()%>";
    var url = resource +".searchhistoryGlob.html"; 
    var expMsg = "Search History Not Available";       
    
    $.ajax({
        type: 'GET',
        data:'',
        cache:false,
        url: url, 
        error: function(e){
            alert(expMsg);        
        },        
        success: function(data){
          
        }
    });
 
    
   
});

</script>
