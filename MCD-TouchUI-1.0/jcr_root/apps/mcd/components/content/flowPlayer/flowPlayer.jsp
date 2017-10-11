<%@ page import="com.day.cq.wcm.foundation.Download,javax.naming.Context,
        com.day.cq.wcm.api.components.DropTarget,javax.naming.NamingEnumeration,
        com.day.cq.wcm.api.WCMMode,javax.naming.directory.SearchResult,
        com.day.text.Text,javax.naming.directory.SearchControls,
        com.day.cq.wcm.foundation.Paragraph,javax.naming.directory.InitialDirContext,
        org.apache.commons.lang.StringEscapeUtils,javax.naming.directory.DirContext,
        com.day.cq.security.*,javax.naming.directory.Attributes,
        com.day.cq.wcm.api.components.Toolbar,javax.naming.directory.Attribute,
        java.util.*,com.day.cq.wcm.foundation.Image" %><%
%> 
<%@include file="/apps/mcd/global/global.jsp"%>

<cq:includeClientLib js="accessmcd.file" /> 
<style>
.player {
     background-color: #000000 !important; 
}

</style>
<%!
public String lookupUser( String eid){

        
        String personalTitle="";
        Hashtable<String, String> env = new Hashtable<String, String>();
         //PROD
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, "/content/accessmcd/na/mcweb/en/restaurant/food/Create_Your_Taste");
        env.put(Context.SECURITY_PRINCIPAL, "CN=svcAmcd,CN=Users,DC=narest,DC=pri"); 
        env.put(Context.SECURITY_CREDENTIALS, "SAM0410pwd!A");
        
        /*
        // STG
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, "ldap://66.111.145.9:3268/DC=pri");
        env.put(Context.SECURITY_PRINCIPAL, "CN=svcAmcd,OU=Service Accounts,OU=US,DC=labnarestmgmt,DC=pri");
        env.put(Context.SECURITY_CREDENTIALS, "P@svc2#1");
        */
        String principalname="";
        
        try
        {
            DirContext ctx = new InitialDirContext(env);
            String searchFilter = "(samAccountName=" + eid.trim() + "*)";
           
            SearchControls scon = new SearchControls();
           
            scon.setSearchScope(SearchControls.SUBTREE_SCOPE); // search object only
            NamingEnumeration answer = ctx.search("", searchFilter, scon);
            
            int count=0;
            while (answer.hasMore() && count<100)
            {
                SearchResult sr = (SearchResult) answer.next();

                if (sr == null)
                {
                    System.out.print("SearchResult is null...continuing ");
                    continue;
                }
                Attributes attrs = sr.getAttributes();
                if (attrs == null)
                {
                    System.out.print("SR attributes is null...continuing");
                    continue;
                }

                Attribute attr = attrs.get("personalTitle");
                if (attr != null)
                {
                    personalTitle= (String) attr.get(0);
                    
                    
                }

            }

        }
        catch (Exception ex)
        {
            System.out.print(" exception occured" + ex.getMessage());
        }
        
        
        return personalTitle;
        
  }
%>

<%

    //drop target css class = dd prefix + name of the drop target in the edit config
    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "flash";
    String videoHref = "";//To store path of video to be embedded
    String extUrl =  properties.get("externalUrl", "");
    String event="";      
    String eventName =  properties.get("event", "");
    if(eventName != null && eventName !="")
    {
        event = eventName;
    }else{
        event = currentPage.getTitle();
     }   
    Download videoObject = new Download(resource);//object of the file uploaded in the dialog
    String videoPath = properties.get("videoPath","");
    if (videoObject.hasContent()) {
        videoObject.addCssClass(ddClassName);
        videoHref = Text.escape(videoObject.getHref(), '%', true); //Get the path of video uploaded       
    }
    else if(!"".equals(videoPath))
    {
        videoHref = videoPath;//If external URL is given get the video from the externam URL
    }
    else if (WCMMode.fromRequest(request) == WCMMode.EDIT) {
        %><div class="cq-flash-placeholder <%= ddClassName %>" style="text-align: left;"></div><%
    } 
    String width = properties.get("width", "500");//Get the width enetered in the dialog
    String height = properties.get("height", "300");//Get the height enetered in the dialog
    String akamaiImg = properties.get("akamaiImg", "");
    String bottomPadding = properties.get("btmpadding","0");
    User loggedInUser = slingRequest.getResourceResolver().adaptTo(User.class);
    String loggedInUserID = loggedInUser.getID();
    String role = lookupUser(loggedInUserID);
    //out.print("Id---"+loggedInUserID+"role--"+role);
    if(!"".equals(bottomPadding))
    {
        bottomPadding = "padding-bottom: "+bottomPadding+"px;";
    }
     
    String altImageHref = "/images/play_large.png";//To store alternate image
   // String altImageHref = "";
    Image altImage = new Image(resource,"stillimage");
    if(altImage.hasContent())
    {
        altImage.setSelector(".img");
        altImageHref = altImage.getHref();//Get path of the external image uploaded
    }
    
    String shareLink = request.getScheme() + "://" + request.getServerName() + currentPage.getPath() + ".html";
    String backgroundColor =  properties.get("bgColor", "");  
     
    if(!"".equals(backgroundColor))
        backgroundColor = "background-color:#" + backgroundColor + ";" ;
    
if(!"".equals(videoHref))
{
   
    String showAsPopup = properties.get("showpopup", "no");
    if("no".equals(showAsPopup) )
    {
%> 
        <table cellspacing="0" cellpadding="0" width="100%">
          <tr height="100%">
            <td width="50%">    
              <table align="right" cellspacing="0" cellpadding="0" height="100%" width="100%">  
                <tr height="240px">
                    <td width="100%" valign="top" align="center">
                    <div id="videoplayer" class="<%=currentNode.getName()%>_video flowplayer">
                    </div>
                        <!--Code for rendering video--> 
                           <!-- the player -->
                    <script>
                       $(document).ready(function(){
                            //Flash setup
                            $f("a.<%=currentNode.getName()%>_player", {src:"/scripts/flowplayer-3.2.18.swf",wmode:"opaque"}, {
                                clip: {
                                    // this will be tracked under our Promo Video category
                                    eventCategory: "<%=event%>"
                                   
                                },
                                playlist: [
                                    {
                                         url: "<%=altImageHref%>",
                                         autoPlay: true,
                                         scaling: 'orig'
                                     },                                 
                                     {
                                         url: "<%=videoHref%>",
                                         autoPlay: false,
                                         autoBuffering: false
                                     }          
                                 ],
                                plugins:{
                                    gatracker: {
                                        url: "/scripts/flowplayer.analytics-3.2.9.swf",
                                        // track all possible events. By default only Start and Stop
                                        // are tracked with their corresponding playhead time.
                                        events: {
                                            all: true
                                        },
                                        debug: true,
                                        accountId: "UA-52631261-1" // your Google Analytics id here
                                    },
                                    controls: {
                                    play:true,
                                    
                                    url: '/scripts/flowplayer.controls-3.2.16.swf'
                                   }
                                }
                            });
                            
                            
                            
                        });
                        function isFlashEnabled()
                        {
                            var hasFlash = false;
                            try
                            {
                                var fo = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
                                if(fo) hasFlash = true;
                            }
                            catch(e)
                            {
                                if(navigator.mimeTypes ["application/x-shockwave-flash"] != undefined) hasFlash = true;
                            }
                            return hasFlash;
                        }
                        function checkPlay(){
                            var html5='';
                            html5+= '<video width=<%=width%> height=<%=height%> controls id="<%=currentNode.getName()%>_htmlplayer" class= "<%=currentNode.getName()%>_htmlplayer" poster="<%=altImageHref%>">';
                            html5+= '<source src="<%=videoHref%>" type="video/mp4"/>';
                            html5+= '</video>';
                            
                            var flash ='<a href="<%=altImageHref%>" style="display:block;width:<%=width%>px;height:<%=height%>px;" class="<%=currentNode.getName()%>_player" id="<%=currentNode.getName()%>_player"></a>';
                            //var flash ='<div class="player" href="<%=videoHref%>" style="background-image:url(<%=altImageHref%>)"></div>'
                            if (isFlashEnabled()) {
                                $("div.<%=currentNode.getName()%>_video").html(flash);
                                } else {
                                $("div.<%=currentNode.getName()%>_video").html(html5);
                                }
                            }
                         checkPlay();   
                            
                    </script>
                     
                    </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
<%
    }
    else {
      
        String title = properties.get("title", "");
        String linkText = properties.get("linktext", "");
        String description = properties.get("videodescription","");
        %>
        <div class="article_preview">
        <%
        Image thumbImage = new Image(resource,"thumbimage");
        String thumbImageHref = "";
        if(thumbImage.hasContent())
        {
            thumbImage.setSelector(".img");
%>
            <br>
            <a class="article_preview_image <%=currentNode.getName()%>_video" href="<%=currentPage.getPath()%>.embeddedflowplayervideo.html?path=<%=videoHref%>&event=<%=event%>&imagePath=<%=altImageHref%>&link=<%=currentPage.getPath()%>.html&width=<%=width%>&height=<%=height%>" id="player" title="<%=title%>"><% thumbImage.draw(out); %></a>
<%
                 
        }
%>
        <script>
            $(document).ready(function() { 
            $("a.<%=currentNode.getName()%>_video").mcdColorbox({ iframe: true, innerWidth: 550, innerHeight: 320});                    
            });
        </script>
        
            <h3><%=title%></h3>
            <p class="preview"><%=description%></p>
            <p>
                <a class="preview linkcolor <%=currentNode.getName()%>_video" href="<%=currentPage.getPath()%>.embeddedflowplayervideo.html?path=<%=videoHref%>&event=<%=event%>&imagePath=<%=altImageHref%>&link=<%=currentPage.getPath()%>.html&width=<%=width%>&height=<%=height%>" id="player" title="<%=title%>"><%=linkText%></a>
            </p>
        </div>
        <div class="clear"></div>    
<%
    }  
}
else if(!"".equals(extUrl))
{
    String title = properties.get("title", "");
    String linkText = properties.get("linktext", "");
    String description = properties.get("videodescription","");
    String anchorClass = "";
    if(!extUrl.startsWith("/content"))        
            if(!bumperEncryption.isBumperLink(extUrl)) 
                anchorClass = "external";
    %>
    <div class="article_preview">
    <%
    Image thumbImage = new Image(resource,"thumbimage");
    String thumbImageHref = "";
    if(thumbImage.hasContent())
    {
        thumbImage.setSelector(".img");
        %><a class="article_preview_image <%=anchorClass %>" target="_blank" href="<%=extUrl%>" ><% thumbImage.draw(out); %></a><%                   
    }
%>
    
    
        <h3><%=title%></h3>
        <p class="preview"><%=description%></p>
        <p>         
             <a class="preview linkcolor <%=anchorClass %>" target="_blank" href="<%=extUrl%>"><%=linkText%></a>
        </p>
    </div>
    <div class="clear"></div>    
<%

}
%> 
    <div class="module_spacing" style="<%=bottomPadding%>"></div>