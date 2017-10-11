<%@include file="/apps/mcd/global/global.jsp"%>
<%@page session="false" %>
<%@page import="com.day.cq.security.User"%>

<%
        String formAction = resource.getPath() + ".likeServlet.html";
        String likeMsg = langText.get("Be the first to like this");  
        String defualtText = properties.get("defaulttext",likeMsg);
        String displayMsg = properties.get("message","");
        String exceptionMsg = langText.get("System error . Please try later");
        String pagePath = currentPage.getPath();
%>

<script>   
 $(document).ready(function(){  
    var path="<%=pagePath%>";
    var resource = "<%=resource.getPath()%>";
    var url = resource +".getHover.html?path="+path; 
    var expMsg = "<%=exceptionMsg%>";       
    
    $.ajax({
        type: 'GET',
        data:'',
        cache:false,
        url: url, 
        error: function(e){
            alert(expMsg);        
        },        
        success: function(data){
           
            var hover= data.results.hover;
            var likeCountNum = parseInt(data.results.likeCountNum);
            var matchStr= "na/mcweb/fr";
        if(path.indexOf(matchStr) != -1){
            $('#likeform a').removeClass("likeCount").addClass("likeCount_fr");
            }
            if(likeCountNum == 0 )
            {
                 $('#likeForm span').html('<%=defualtText%>');
                 $('#likeForm span').css('color','#333300');
            }else
            {   
                $('#likeform span').addClass("likePage");
                $('#likeForm span').html(likeCountNum + " <%=displayMsg%>");
                $('#likeForm span').css('color','#333300');
             } 
            if(hover=='true'){
                $('#likeForm').css('opacity','1');
            }else {
                
                $('#likeForm').bind("mouseenter", function() {
                    $('#likeForm').css('opacity','1');
                });
                $('#likeForm').bind("mouseleave", function() {
                    $('#likeForm').css('opacity','0.5');
                });
            } 
                
        }
    });
 
    
   
});

</script>


 
        

<div id="likeform">  
    <a  id="likeForm" class="likeCount"  href="javascript:submitLikeForm('<%=formAction%>');" style="text-decoration:none;">  
       <span></span>
    </a>
</div>

<script>


function submitLikeForm(formAction)
{    
    var pagePath = "<%=pagePath%>";
    var expMessage = "<%=exceptionMsg%>";
    $.ajax({
        url: formAction,
        type: 'GET',    
        cache:false, 
        data: "", 
           
        error: function(e)
        {
           alert(expMessage);    
        },    
        success: function(data)
        {                
        var exists = data.results.likeCount;       
        $('#likeform span').addClass("likePage");
        $('#likeForm span').html(exists +" <%=displayMsg%>");
        $('#likeForm span').css('color','#333300');
        $('#likeForm').css('opacity','1');
        $('#likeForm').unbind("mouseenter mouseleave");

        }
    });   
}
</script>