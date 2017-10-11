<%--

  homepage component.

  Lets Talk Section
  Author : Nitin Sharma

--%>
<%@ page import="com.day.cq.wcm.foundation.Image,
    com.day.cq.wcm.foundation.TextFormat,
    com.day.cq.wcm.foundation.DiffInfo,
    com.day.cq.wcm.foundation.DiffService,
    org.apache.sling.api.SlingHttpServletRequest,
    org.apache.commons.lang.StringEscapeUtils,
    com.day.cq.wcm.api.components.DropTarget,
    com.day.cq.wcm.api.WCMMode,
    com.mcd.accessmcd.util.CommonUtil,
    java.util.Date,java.text.DateFormat, 
    java.text.SimpleDateFormat,
    com.day.cq.security.User,
    java.util.List,
    java.lang.*,
    com.mcd.accessmcd.comments.util.NodeUtility,
    com.mcd.accessmcd.comments.constants.CommentsConstants,
    com.mcd.accessmcd.comments.util.UserDetails" %>
 
<%@include file="/apps/mcd/global/global.jsp"%>
<%@page session="false" %>

<style>
.commentImg 
{
    color:#004276 !important; 
    font-family: Arial,Helvetica,sans-serif !important;
    font-size: 10px;
    font-weight: bold;
    text-decoration: underline;
}
.commentImgIconLT{
    background-image:url('<%=currentDesign.getPath()%>/images/commentCount.png');
    background-repeat:no-repeat;
    float:left;
    padding-right: 10px;
    margin-top: 2px;
    width:11px !important;
}
.commentImgIconLTThumb{
    background-image:url('<%=currentDesign.getPath()%>/images/commentCount.png');
    background-repeat:no-repeat;
    float:left;
    margin-left:-2px !important;
    margin-top: 2px;
    width:11px !important;
} 
</style>
<% 
   // Get user Details
   final User user = slingRequest.getResourceResolver().adaptTo(User.class);  //instantiate User object

   CommonUtil commonUtil = new CommonUtil(); 
   
   //Fetch dialog Properties
   String mcdAudience = "";
   String title = properties.get("title","");
   String headline =  properties.get("headline",""); 
   String desc =  properties.get("description","");
   String dates = properties.get("date","");
   if(!dates.trim().equals("")){
     Date date =  new Date(properties.get("date",""));
     DateFormat formatter;
     formatter = new SimpleDateFormat("MMM  dd , yyyy");
     dates = formatter.format(date);
   }
   String linktext =  properties.get("linktext","");
   String link =  properties.get("link","");
   String showCommentCountLetsTalk =  properties.get("showcommentcount","false");      
   
   String []groups =  properties.get("groupsdata",String[].class);
   String rc =properties.get("corners", "false");   
  String letsTalkBoxClass = "";
 
   link = commonUtil.getValidURL(link); 
  
   String userGroup = " ";
   int temp = 0;   
   int length =0;    
   if(groups != null) {
       length = groups.length;
   }

   // Extracting the Audience Type
   if(user != null){ 
          mcdAudience = user.getProperty("rep:mcdAudience");
             if(mcdAudience == null || mcdAudience.equals("")) 
                     mcdAudience = "CorpEmployees" ;           
    }      
    
   for(int j = 0 ; j <length ;j++){
             if(groups[j].equals(mcdAudience)){
                      temp = 1;
                      break;
             }
   } 
 
  // Matching the Audience type with Allowed One
  if(temp == 1 || (WCMMode.fromRequest(request) == WCMMode.EDIT))  
  { %>
  
            <!-- Lets Talk Box Starts From Here -->
            <div class="letsTalkBox" id="letsTalkBox" rc="<%=rc%>">
              <div class="boxHdBlack"><div class="talkTitle"><%= title  %></div></div>
                  <table class="letsTalkContent" border="0" cellpadding="0" cellspacing="0">
                        <tr> 
                            <td>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td>
                                          <div class="date"><%= dates %></div>
                                          <div class="txtHd"><%= headline %></div>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td>
                                         <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                               <tr>
                                                    <td valign="top">
                                                        <div class="innerTxtLT"> <%= desc %><br />
                                                            <a href="<%= link %>"><%= linktext %></a>
                                                            
                                                        </div>
                                                     </td>
                                                     <td class="txtImg"> 
                                                     <% String ddClassN = DropTarget.CSS_CLASS_PREFIX + "image";
                                                       Image image1 = new Image(resource,"image"); 
                                                       if(image1.hasContent())
                                                         {   
                                                             image1.addCssClass(ddClassN);  
                                                             image1.loadStyleData(currentStyle); 
                                                             image1.setSelector(".img"); // use image script
                                                             // add design information if not default (i.e. for reference paras)
                                                             if (!currentDesign.equals(resourceDesign))
                                                             {
                                                                    image1.setSuffix(currentDesign.getId());
                                                             } 
                                                       %>
                                                             <% image1.draw(out);%>  
                                                       <% } %>
                                                      </td>
                                                 </tr>
                                           </table>
                                         </td>
                                     </tr>
                                      <tr>
                                          <td>
                                              <div class="commCountLetsTalk"></div>
                                          </td>
                                      </tr>
                              </table>
                        </td>
                   </tr> 
             </table>
            <div id="lthtml" style="display:none;"></div>        
            <div style="clear:both;"></div>
        </div>
        
<script type="text/javascript">
    $( document ).ready(function() {
    
        var rc = '<%=rc%>';
        if(rc == 'true')
        {
            $('#letsTalkBox').css('border-radius','12px');
        }else
        {
            $('#letsTalkBox').css('border-radius','0px');
          
        }
        
    
        var showCommentCountLetsTalk = "<%=showCommentCountLetsTalk%>";
        if(showCommentCountLetsTalk == "true"){
            String.prototype.startsWith = function(prefix) {
                return this.indexOf(prefix) === 0;
            } 
            
            var commentCountVal;
            var commentDiv; 
            var imagelink="<%=link%>";
            
            if(imagelink.startsWith("/content")){
                var resultStringX =  $.ajax({
                    url: '<%=link%>',
                    type: 'GET',    
                    timeout: 10000, 
                    cache: true, 
                    dataType: "html",  
                    error: function(){
                        //window.location.reload();    
                    },     
                    success: function(data){
                        var startIndex = data.indexOf("<!--pagecommentingstart-->");
                        var endIndex = data.indexOf("<!--pagecommentingend-->"); 
                        var lt1Html = data.substring(startIndex,endIndex);
                        document.getElementById("lthtml").innerHTML = lt1Html;
                        commentDiv = $("#lthtml").find(".commentdiv").html();
                        commentCountVal = $("#lthtml").find(".commentCountNumber").html();
                        if(commentDiv==null || commentDiv==undefined){}
                        else
                        {
                            if(commentCountVal==null || commentCountVal==undefined){
                                var spanText = "<%=langText.get("Add a Comment")%>";
                                var slideInfoHTML = "<div id='putCount'><div class='commentImgIconLT'>&nbsp</div><a style='font-size:10px;color:#004276;' href='<%=link%>#formDiv' target='_blank' class='commentImg'>"+spanText+"</a></div>";
                                //var slideImageHTML = "<div id='putCount' style='margin-top:-5px;'><div class='commentImgIconLTThumb'>&nbsp</div><a style='font-size:10px;color:#004276;' href='<%=link%>#formDiv' target='_blank' class='commentImg'>"+spanText+"</a></div>";
                                $(".commCountLetsTalk").html(slideInfoHTML);    
                            }
                            else{
                                var spanText;
                                if(commentCountVal > '1')
                                spanText= commentCountVal  + " "+"<%=langText.get("comments")%>";
                                else
                                spanText= commentCountVal  + " "+"<%=langText.get("comment")%>";
                                var slideInfoHTML = "<div id='putCount'><div class='commentImgIconLT'>&nbsp</div><a style='font-size:10px;color:#004276;' href='<%=link%>#commentSecDiv' target='_blank' class='commentImg'>"+spanText+"</a></div>";
                                //var slideImageHTML = "<div id='putCount' style='margin-top:-5px;'><div class='commentImgIconLTThumb'>&nbsp</div><a style='font-size:10px;color:#004276;' href='<%=link%>#commentSecDiv' target='_blank' class='commentImg'>"+spanText+"</a></div>";
                                $(".commCountLetsTalk").html(slideInfoHTML);    
                            } 
                        }   
                        document.getElementById("lthtml").innerHTML = "";
                    }
                });
            } 
        }          
    }); 
</script>
<%  }
else{ 

      if(WCMMode.fromRequest(request) == WCMMode.EDIT)
      {
                    out.println(langText.get("CONFIGURE_COMPONENT_MSG","","Let's Talk"));
      }
    }
    
    
%>   