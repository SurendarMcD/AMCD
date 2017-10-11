<%@include file="/apps/mcd/global/global.jsp"%>
<%
String path=request.getParameter("path");

if(path != null)
{ 
    String stillImage = request.getParameter("imagePath")!=null? request.getParameter("imagePath"):"";
    String event = request.getParameter("event")!=null? request.getParameter("event"):"";
    String shareLink = request.getParameter("link")!=null? request.getScheme() + "://" + request.getServerName() + request.getParameter("link"):"";
    String width=request.getParameter("width")!=null?request.getParameter("width"):"500";
    String height=request.getParameter("height")!=null?request.getParameter("height"):"300";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Untitled Page</title>
 
<cq:includeClientLib js="accessmcd.file" /> 
<script>
 $(document).ready(function() {
        $f("a.player", "/scripts/flowplayer-3.2.18.swf", {
            clip: {
                // this will be tracked under our Promo Video category
                eventCategory: "<%=event%>"
            },
            playlist: [
                    {
                         url: "<%=stillImage%>",
                         autoPlay: true,
                         scaling: 'orig'
                     },                                 
                     {
                         url: "<%=path%>",
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
    
    
</script>    
</head>
<body id="pout" bgcolor="black">
<!-- Google Tag Manager -->
<noscript><iframe src="//www.googletagmanager.com/ns.html?id=GTM-PG56BV"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-PG56BV');</script>
<!-- End Google Tag Manager -->

<a href="<%=stillImage%>"
    style="display:block;width:<%=width%>px;height:<%=height%>px;"
    id="player" class="player">
    
</a>
   
</body>
</html>      
    <%
}
else {
%>
    No video is available
<%    
}
%>
