<%--
 
  Welcome component

  Displays the welcome message to be displayed to the 
  current logged in user

--%><%@ page import="com.day.cq.wcm.foundation.Image,
    com.day.cq.wcm.api.components.DropTarget,
    com.day.cq.wcm.api.WCMMode,
    com.day.cq.security.User " %><%
%><%@include file="/apps/mcd/global/global.jsp"%>


<%
    String nameFormat = properties.get("nameFormat","first");
    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "image";
    //For storing welcome text entered in dialog
    String welcomeText = properties.get("welcomeText","Welcome back");
    //For setting unique ids for div 
    String currentNodeName=currentNode.getName();
    //for rendering image
    Image img = new Image(resource, "image");
%>
            <!--For rendering top round corners-->
            <div class="welcomeRoundCorner" >
                <b class="roundcorneryellow" >
                <b class="roundcorneryellow1" ><b></b></b>
                <b class="roundcorneryellow2" ><b></b></b>
                <b class="roundcorneryellow3" ></b>
                <b class="roundcorneryellow4" ></b>
                <b class="roundcorneryellow5" ></b></b>
            </div>
            <div class="welcomeContent" >
            <%
            //for rendering image
            if (img.hasContent() || WCMMode.fromRequest(request) == WCMMode.EDIT)
            {
            %>
                <div class="welcomeImage" >
            <%
                img.loadStyleData(currentStyle);
                // add design information if not default (i.e. for reference paras)
                if (!currentDesign.equals(resourceDesign)) {
                    img.setSuffix(currentDesign.getId());
                }
                img.addCssClass(ddClassName);
                img.setSelector(".img");
                
                %><% img.draw(out); %><br><%
                
                %></div>
            <%
            }
        %>
            <div class="welcomeText">
                <div class="welcomeMessage"><!--For displaying welcome message-->
                <%= welcomeText %>
                </div>
                <div id="welcomeUser<%=currentNodeName %>" class="welcomeUser"><!--For displaying user name to be rendered by ajax call-->
                
                </div>
            </div>
        
            </div>
            <!--For rendering bottom round corners-->
            <div class="welcomeRoundCorner" >
                <b class="roundcorneryellow" >
                <b class="roundcorneryellow5" ></b>
                <b class="roundcorneryellow4" ></b>
                <b class="roundcorneryellow3" ></b>
                <b class="roundcorneryellow2" ><b></b></b>
                <b class="roundcorneryellow1" ><b></b></b></b>
            </div>
        
<script>
$(function(){
//URL for testing
var nameFormat = '<%=nameFormat%>';
var currentPage = '<%=currentPage.getPath()%>';
var glob = "welcomeglob";
var url = currentPage+"."+glob+".html?nameFormat="+nameFormat;
var pars = '';
$.ajax({
    url: url,
    type: 'GET',    
    timeout: 120000,
    data: pars, 
    cache: false,   
    error: function(){
            alert("Error2:Loading XML Retrieve");   
    },
    success: function(xml){
            if(document.getElementById('welcomeUser<%=currentNodeName %>')!=null){
                document.getElementById('welcomeUser<%=currentNodeName %>').innerHTML = xml;
            }
        }
    });
});
</script>
