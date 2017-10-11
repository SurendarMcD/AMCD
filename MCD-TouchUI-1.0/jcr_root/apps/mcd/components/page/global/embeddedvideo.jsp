<%@include file="/apps/mcd/global/global.jsp"%>
<%
String path=request.getParameter("path");

if(path != null)
{ 
    String stillImage = request.getParameter("imagePath")!=null? request.getParameter("imagePath"):"";
    String shareLink = request.getParameter("link")!=null? request.getScheme() + "://" + request.getServerName() + request.getParameter("link"):"";
    String width=request.getParameter("width")!=null?request.getParameter("width"):"500";
    String height=request.getParameter("height")!=null?request.getParameter("height"):"300";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Untitled Page</title>

</head>
<body id="pout" bgcolor="black">
<object width="<%=width%>" height="<%=height%>">
    <param name="allowfullscreen" value="true">
    <param name="wmode" value="opaque">
    <param name="allowscriptaccess" value="always">
    <param name="movie" value="/scripts/McDVideoPlayer.swf">
    <param name="flashvars" value="videoPath=<%=path %>&amp;imagePath=<%=stillImage%>&amp;shareLink=<%=shareLink%>">
    <embed src="/swf/McDVideoPlayer.swf" 
        flashvars="videoPath=<%=path %>&amp;imagePath=<%=stillImage%>&amp;shareLink=<%=shareLink%>"
        type="application/x-shockwave-flash" 
        allowfullscreen="true" 
        scale="noscale"
        wmode="opaque" 
        allowscriptaccess="always" 
        width="<%=width%>" height="<%=height%>" /></object>
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
