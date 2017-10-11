<%--

  AccessMCD Survey component.
  Presents a survey modal at random to visitors of AccessMCD.
  
  Stephen Pfaff v1 - 7/25/2012

--%>

<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page import="com.day.cq.wcm.foundation.Image,
                 com.day.cq.wcm.api.WCMMode,
                 com.day.cq.wcm.foundation.DiffInfo,
                 com.day.cq.wcm.foundation.DiffService,
                 com.day.cq.wcm.foundation.TextFormat,
                 org.apache.sling.api.resource.ResourceUtil,
                 com.day.cq.wcm.foundation.Download,
                 com.day.image.Layer,
                 com.day.cq.wcm.foundation.TextFormat, 
                 org.apache.commons.lang.StringEscapeUtils,
                 com.day.cq.wcm.api.components.DropTarget,
                 org.apache.sling.api.resource.ValueMap,
                 com.mcd.cq.util.search.SearchGroup,
                 java.util.Map,
                 com.day.text.Text,
                 com.day.cq.security.User,
                 com.mcd.accessmcd.util.CommonUtil,
                 java.util.Arrays" %>
                 
                   
                 

<%!
    //Function used for rendering text
    public String renderText(String currentNodeName, boolean isRichText, String text, String imageAlignment, ValueMap properties)
    {
        String openDiv="";
        String closeDiv="";
        
        StringBuffer textContent = new StringBuffer(); 
        if (imageAlignment.contains("top"))//image is top aligned so text will come in the next table row     
            openDiv="<tr><td class='surveyCol' valign='top' >";
        if (imageAlignment.contains("bottom"))
            openDiv="<td class='surveyCol' valign='top' >";

       openDiv+="<div id='text"+currentNodeName+"' class='surveyText'>";
       textContent.append(openDiv);//rendering text
       if (!isRichText) {
           textContent.append(text);
       }
       else {//out of box code for text 
           TextFormat fmt = new TextFormat();
           fmt.setTagUlOpen("<ul>");
           fmt.setTagOlOpen("<ol start=\"%s\">");
           textContent.append(fmt.format(text));
       }
       
       closeDiv="</div></td>";
       if (imageAlignment.contains("bottom"))
           closeDiv+="</tr>";

       textContent.append(closeDiv);
       
       return textContent.toString();
       
    }
%>
    
<%
    //Retrieve user's audience type
    // Logged in user Details
    final User user = slingRequest.getResourceResolver().adaptTo(User.class);  //instantiate User object
    CommonUtil commonUtil  = new CommonUtil();
    WCMMode wcmMode= WCMMode.fromRequest(request);
    String mcdAudience = "";
    
    // Extract the Audience type from the user object
    if(user != null){ 
        mcdAudience = user.getProperty("rep:mcdAudience");
        if(mcdAudience == null || "null".equals(mcdAudience) || mcdAudience.equals("")) 
            mcdAudience = "CorpEmployees" ;    
    }
    String[] viewingAudience = properties.get("audience",String[].class);

    //Component property settings
    String templatePath = currentPage.getTemplate().getPath();
    String paraName = "";
    if(templatePath .indexOf("g2g-responsive") > 0){
        paraName = "homepagepara";
    }
    else{
        paraName = "leftcontentpara";
    }
    String currentPagePath = currentPage.getPath();
    String surveyPromptPath = currentPagePath + "/_jcr_content/"+paraName+"/survey.html";
    String enablePopup = properties.get("enablePopUp", "no");
    int randomNum = properties.get("randomNum", 1);
    //int randomNumber = (int) ((Math.random()*randomNum) + 1);
    String remindMe = properties.get("remindMe", "no");
    String noThanks = properties.get("noThanks", "no");
    int resPopupWidth = properties.get("resPopupWidth", 50);
    int popupWidth = properties.get("popupWidth", 410);
    int popupHeight = properties.get("popupHeight", 80);
    int innerWidth = popupWidth - 45;
    int innerHeight = popupHeight - 36;
    String surveyURL = properties.get("surveyURL", "");
    
    String surveyID = properties.get("surveyID", "");
    pageContext.setAttribute("surveyID", surveyID);
    
    String surveyText = properties.get("surveyText", "Click here to take the survey");
    String reminderText = properties.get("reminderText", "Remind Me Later");
    String nothanksText = properties.get("nothanksText", "No Thanks");
    
    //Advanced Image Configuration
    int leftPaddingImage =properties.get("paddingLeftImage",0);
    int rightPaddingImage =properties.get("paddingRightImage",0);
    int topPaddingImage =properties.get("paddingTopImage",0);
    int bottomPaddingImage =properties.get("paddingBottomImage",0);
    Boolean bottomShow=false;//To check whether image is to be bottom aligned or not
    String imageAlignment =properties.get("imagePosition", "");//To get the alignment of image
    String imgWidth = properties.get("imageSize","1.0");
    String width="auto";
    String imageLink = properties.get("imageLink","");
    String newWindow=properties.get("imageNewWindow","");
    String anchorClass="";
    String captionAlignment = properties.get("captionAlignment","");
    String imagePosition = "";
    boolean createThumbnail=properties.get("createThumbnail",false);
    String akamaiImagePath =properties.get("akamaiImage", "");
    String imagePath="";
    if(imageAlignment.toLowerCase().contains("left"))
        imagePosition="left";
    else if(imageAlignment.toLowerCase().contains("right"))
        imagePosition="right";
    else if(imageAlignment.toLowerCase().contains("top") || imageAlignment.toLowerCase().contains("bottom"))
        imagePosition="center";
    
    bottomShow = imageAlignment.contains("bottom");
    
    if(imageAlignment.equals(""))bottomShow=true; //added default for in-place editing of new paragraph

    String cssClass="";
    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "image";
    String ddClassNameFile = DropTarget.CSS_CLASS_PREFIX + "file";
    
    Image img = new Image(resource, "image");
    final DiffInfo diffInfo = resource.adaptTo(DiffInfo.class);
    final Image diffImg = (diffInfo == null || diffInfo.getContent() == null ? null : new Image(diffInfo.getContent(), "image"));
    final DiffService diffService = (diffInfo == null ? null : sling.getService(DiffService.class));
    
    //For attaching uploaded file with the image
    Download dld = new Download(resource);
    String fileLink = properties.get("file","");
    
    //Init variables for rich text.
    String text = "";
    boolean isRichText = false;
    
    String surveyLink = "";
    String remindLink = "";
    String nothanksLink = "";
    
    if (remindMe.equals("yes"))
        remindLink = "<a href='#' onclick='setPopupCookie('reminderMe'); return false;'>Remind Me Later</a>";
%>
<style>
    .mfp-iframe-holder .mfp-content {
        line-height: 0;
        width: <%=resPopupWidth%>%;
        max-width: 600x;
    }

    .mfp-iframe-scaler {
        width: <%=resPopupWidth%>%;
        height: 0px;
    }
    
   .mfp-iframe-scaler iframe {
     background: #fff;
    } 
    
   @media only screen and (max-width: 600px)
    {
    .evrimg { width:100%!important}
    .cq-dd-image { width:100%}
    mfp-content {height:50%}
    }  


</style>
<%
boolean viewable = false;
if (viewingAudience != null) {
for (int i=0; i < viewingAudience.length; i++) {
    if (viewingAudience[i].equals(mcdAudience)) {
        viewable = true;
    }
}
}

if (WCMMode.fromRequest(request) == WCMMode.EDIT) { %>
    <div style="display: block; background: #CCC; border-radius: 12px; border: 1px solid #999; padding: 5px; margin: 10px 0 10px 0;">
        <b>Survey modal disabled in Edit-Mode.</b><br/>
        <p>
        <br /><b>Survey Cookie:</b><br />
        
        <c:forEach items="${cookie}" var="currentCookie">
            <c:choose>
            <c:when test="${currentCookie.key==surveyID}">
                Cookie exists!  <i>Please clear the cookie from your browser if you want to preview the pop-up.</i><style>.noCookie{display:none;}</style>
            </c:when>
            </c:choose>
        </c:forEach>
        <div class="noCookie">No cookie found.</div>
        
        <br />
        Survey Unique ID - <%=surveyID%><br />
        Enabled? - <%=enablePopup%><br />
        Random Counter - <%=randomNum%><br />
        Survey Link - <%=surveyURL%><br />
        Remind Link - <%=remindMe%><br />
        No Thanks Link - <%=noThanks%><br />
        Modal Width X Height - <%=popupWidth%> X <%=popupHeight%><br />
        Is this Viewable - <%=viewable%>
        </p>
    </div>
    
<% } else if ((WCMMode.fromRequest(request) != WCMMode.EDIT) && (WCMMode.fromRequest(request) != WCMMode.DESIGN) && (viewable)) { %>

    <script>
    
    //Check if cookie exists.
    function getCookie(name) {
        var dc = document.cookie;
        var prefix = name + "=";
        var begin = dc.indexOf("; " + prefix);
        if (begin == -1) {
            begin = dc.indexOf(prefix);
            if (begin != 0) return null;
        }
        else
        {
            begin += 2;
            var end = document.cookie.indexOf(";", begin);
            if (end == -1) {
            end = dc.length;
            }
        }
        return unescape(dc.substring(begin + prefix.length, end));
    } 
    var myCookie = getCookie("<%=surveyID%>");
    
    //If cookie does NOT exist, load colorbox prompt
    
    $(document).ready(function(){
    
        var randomGen = Math.floor((Math.random() * <%=randomNum%>) + 1);
        if (myCookie == null) {
            var enablePopup = "<%=enablePopup%>";
            if(enablePopup == "yes"){
                if (randomGen == 1 && myCookie == null) {
                    
                    <%--
                    
                    $(".popup").mcdColorbox({ iframe: true, innerWidth: <%=popupWidth%>, innerHeight: <%=popupHeight%> });
                    $(".popup").trigger("click");
                    
                    --%>
                    
                   $(".popup").magnificPopup({ type: 'iframe',preloader: false,mainClass: '',fixedBgPos: 'false',fixedContentPos: 'fasle',});      
                                                
                   $(".popup").trigger("click");

                    
                }
            }
        }
    });
   
    

   
    function setPopupCookie(linkFlag) {
        //Set cookie expires 
        var now = new Date();
        if ("reminderMe" == linkFlag) {
            now.setTime(now.getTime() + 1 * 24 * 60 * 60 * 1000);
            document.cookie = "<%=surveyID%>=true;expires=" + now.toGMTString() + "; path=/";
            parent.$.magnificPopup.close();
            return;
        }
        now.setTime(now.getTime() + 90 * 24 * 60 * 60 * 1000);
        if ("takeSurvey" == linkFlag) {
            document.cookie = "<%=surveyID%>=true;expires=" + now.toGMTString()+ "; path=/";
            window.open("<%=surveyURL%>");
            parent.$.magnificPopup.close();
        }

        if ("noThanks" == linkFlag) {
            document.cookie = "<%=surveyID%>=true;expires=" + now.toGMTString() + "; path=/";
            parent.$.magnificPopup.close();
        }
    }
    </script>
    

    
   


    <a href="<%=surveyPromptPath%>" class="popup" style="display: none"></a>
    <div id="popupModal" style="font-family: Arial,Helvetica,sans-serif !important; line-height: 11pt; font-size: 10pt; background-color: #FFF; height: 90%; padding: 10px 10px 10px 20px; margin: 0;">
        
        <div class="surveytable">
        <table width="100%" cellspacing="0" cellpadding="0">
          <tr>
          <%
            if (properties.get("text", "").length() > 0) {
                text = properties.get("text", String.class);
                //text = bumperEncryption.getBumperRichLink(text);
                isRichText = properties.get("textIsRich", "false").equals("true");
                if ( diffInfo != null )
                {
                    final ValueMap map = ResourceUtil.getValueMap(diffInfo.getContent());
                    final String diffOutput = DiffInfo.getDiffOutput(diffService, diffInfo, text, isRichText, map.get("text", ""));
                    if ( diffOutput != null )
                    {
                        text = diffOutput;
                        isRichText = true;
                    }
                }
            }
          
            //If image is bottom Aligned
            if(bottomShow && !text.equals("")) {
                out.println(renderText(currentNode.getName(),isRichText,text,imageAlignment,properties));
            }
            //Out of box code for rendering image
            if (img.hasContent() || WCMMode.fromRequest(request) == WCMMode.EDIT ||!(akamaiImagePath.equals("")))
            {
                if(img.hasContent())
                {
                       //try/catch added 3/4/11 ECW
                       try{
                           Layer layer = img.getLayer(true,true,true);
                           if(layer!=null){
                               width= (layer.getWidth()*Double.parseDouble(imgWidth))+"px";
                               img.addAttribute("width",width.replace("px",""));
                           }
                       }catch(Exception e){
                           out.println(e.getMessage());
                       }
                }
                
                cssClass = "image evrimg";
                if(bottomPaddingImage==0)
                {
                cssClass = "evrimg";
                } 
                if ( diffInfo != null )
                {
                    if ( diffInfo.getType() == DiffInfo.TYPE.ADDED ) {
                        cssClass += "imageAdded ";
                    } else if ( diffInfo.getType() == DiffInfo.TYPE.REMOVED ) {
                        cssClass += "imageRemoved ";
                    } else {
                        final String path1 = (img.getResource() != null ? img.getHref() : "");
                        final String path2 = (diffImg != null && diffImg.getResource() != null ? diffImg.getHref() : "");
                        if ( !path1.equals(path2) ) {
                            if ( path1.length() == 0 ) {
                                img.addCssClass("imageRemoved");
                            } else if ( path2.length() == 0 ) {
                                img.addCssClass("imageAdded");
                            } else {
                                int pos = path2.indexOf("jcr:frozenNode/");
                                if ( pos == -1
                                     || !path1.endsWith(path2.substring(pos+14))
                                     || img.getLastModified().compareTo(diffImg.getLastModified()) != 0 ) {    
                                    img.addCssClass("imageChanged");
                                }
                            }
                        } else if ( img.getLastModified().compareTo(diffImg.getLastModified()) !=  0 ) {
                            img.addCssClass("imageChanged");                
                        }
                    }
                }
                if (bottomShow)
                {
                %>
                    <tr>
                <%
                }
                if(imageAlignment.equalsIgnoreCase("left") || imageAlignment.equalsIgnoreCase("right"))
                {
                %>
                    <td valign="top" class="surveyImage">
                    <div id="<%= cssClass %><%=currentNode.getName() %>" class="<%= cssClass %>" style="float:<%=imageAlignment %>">
                <%
                }//if it is left or right aligned the text should wrap
                else 
                {
                %>
                    <td align="<%=imagePosition%>" valign="top" style="text-align:<%=imagePosition%>; ">
                    <div style="width:100%;" align="<%=imagePosition%>">
                    <div id="<%= cssClass %><%=currentNode.getName() %>" class="<%= cssClass %>" style="width:<%=width %>">
                    
                <%
                }
                img.addAttribute("style","padding:"+topPaddingImage+"px "+rightPaddingImage+"px "+bottomPaddingImage+"px "+leftPaddingImage+"px ");
                img.loadStyleData(currentStyle);
                // add design information if not default (i.e. for reference paras)
                if (!currentDesign.equals(resourceDesign)) {
                    img.setSuffix(currentDesign.getId());
                } 
                img.addCssClass(ddClassName);
                img.setSelector(".parentsizedimg");
                //if no alt text is specified by user, CQ sets alt to img path
                if(img.getAlt().startsWith("/content/")){
                    img.setAlt(" ");  
                }else{
                    //set title to alt text, to get tooltip matching alt
                    img.setTitle(img.getAlt());
                }

                %><%
                if(akamaiImagePath.equals(""))
                {
                    imagePath=img.getResource() != null ? img.getHref() : "";
                }
                else
                {
                    imagePath=akamaiImagePath;
                }
                
                if (createThumbnail) {
                    %>
                        <a href="#" onClick="window.open('<%=imagePath %>', 'imagepopwin','height=300,width=600,scrollbars=yes,status=yes,toolbar=no,menubar=no,location=no,resizable=yes');return false">
                    <%
                } else if(!imageLink.equals("")) {
                    if (imageLink.startsWith("/"))
                        imageLink=imageLink.concat(".html");
                    if(newWindow.equals("")) {
                    %>
                        <a <%=anchorClass %> href="<%=imageLink %>">
                    <%  
                    }else{
                    %>
                        <a <%=anchorClass %> href="#" onClick="javascript:window.open('<%=imageLink%>');">     
                    <%
                    }
                } else if(dld.hasContent()) {
                    javax.jcr.Property propData = dld.getData();
                    String href = dld.getHref();
                    String metaGroups = getAllGroup(currentNode);    
                    String tmpGroup=SearchGroup.searchGroup(metaGroups);
                    if (tmpGroup!=null && tmpGroup.trim().length()>0 && href.indexOf("/content/dam")<0){
                        String orghref = dld.getHref();
                        int st = orghref.lastIndexOf(".");
                        String temphref = orghref.substring(0,st)+ "."+tmpGroup+"."+orghref.substring(st+1); 
                        href = Text.escape(temphref,'%',true);        
                    } else {
                        href = Text.escape(href, '%', true);
                    }
                    %>
                    <a href="<%=href%>" target="_new">
                    <%
                }
                
                if(akamaiImagePath.equals(""))
                    img.draw(out);
                else
                    out.println("<img src='"+akamaiImagePath+"' onload='changeSize(this,\""+imgWidth+"\")' />");
                 
                %></a><%   
                String desc =properties.get("captionText", String.class);
               /* if ( desc.length() > 0 ) {
                    desc = img.getDescription(true);
                } */
                
                if ( diffInfo != null ) {
                    final String other = (diffImg == null ? "" : diffImg.getDescription(true));
                    final String diffOutput = DiffInfo.getDiffOutput(diffService, diffInfo, desc, false, other);
                    if ( diffOutput != null ) {
                        desc = diffOutput;
                    }   
                }
                if(null!=desc)
                {
                if (desc.length() > 0) {            
                    %><div class="imagecaption" style="text-align:<%=captionAlignment %>"><%= desc.toString()%></div><%
                }}
                %>
                    </div>
                    
                <%
                if(!imageAlignment.equalsIgnoreCase("left") && !imageAlignment.equalsIgnoreCase("right"))
                {
                %>
                    </div></td>
                <%
                }//to accomadate wrapping in case of left or right alignment of image
                if (imageAlignment.contains("top"))
                {
                %>
                    </tr>
                <%
                }
                %>
            <%
            }
            //If image is not bottom Aligned
            if(!bottomShow && !text.equals("")) {
                out.println(renderText(currentNode.getName(),isRichText,text,imageAlignment,properties));
            } 
          %>
          </tr>
          
        </table>
        <br />
        <div class="surveyLinks" style="text-align: center;">
            <a href="#" onclick="setPopupCookie('takeSurvey'); return false;"><%=surveyText%></a>
            <br /><br />
            <%
            if (remindMe.equals("yes")) {
                %><a href="#" onclick="setPopupCookie('reminderMe'); return false;"><%=reminderText%></a><%
            }
            if (remindMe.equals("yes") && noThanks.equals("yes")) {
                %><br /><br /><%
            }
            if (noThanks.equals("yes")) {
                %><a href="#" onclick="setPopupCookie('noThanks'); return false;"><%=nothanksText%></a><%
            }
            
            %>
        </div>
    </div>
    </div>
<% } %>