 <%-- 
 /* 
 * Apache Cache Invalidator 
 * Sends cache invalidation (flush) request to flush server
 *
 * 05/26/2009    Erik Wannebo    CQ4 version
 * 03/29/2011    Erik Wannebo    Ported to CQ5
 */ 
 --%>
 <%@page import="java.io.*,
               java.io.InputStream,
               java.net.URL,
               java.text.*,
               java.util.*" %>

<%@page import="com.mcd.accessmcd.webserver.util.*" %>
 <TITLE>Apache Cache Invalidator</TITLE>
<%
HttpServletRequest cqReq = (HttpServletRequest) request;
String pageFlush=cqReq.getParameter("page");
String pagesFlush=cqReq.getParameter("pagelist");
String[] pagelist=new String[1];

if(pageFlush!=null){
    pagelist[0]=pageFlush.trim();
}else{
    if(pagesFlush!=null){
        pagelist=pagesFlush.split("\n");
    }
}
String pageToFlush="";
for(int ix=0;ix<pagelist.length;ix++){
    pageToFlush="";
    if(pagelist[ix]!=null){
        pageToFlush=pagelist[ix].trim();
        String selectedServer=cqReq.getParameter("server");
        ApacheCacheInvalidator cacheInvalidator=new ApacheCacheInvalidator();
        String[] serverlist=new String[2];
        out.println("Flushing "+pageToFlush+" on "+selectedServer+"<br>");
        
        if(selectedServer.equals("www1")){
            serverlist[0]="66.111.151.240:19017";
            serverlist[1]="66.111.151.212:19017";
        }
        if(selectedServer.equals("accessmcd")){
            serverlist[0]="66.111.151.240:19023";
            serverlist[1]="66.111.151.212:19023";
        }
        if(selectedServer.equals("mcsource")){
            serverlist[0]="66.111.151.240:19018";
            serverlist[1]="66.111.151.212:19018";
        }
        if(selectedServer.equals("author")){
            serverlist[0]="66.111.151.240:19016";
            serverlist[1]="66.111.151.212:19016";
        }
        if(selectedServer.equals("stgpublish")){
            serverlist[0]="66.111.147.69:19013";
        }
       
        for(int servix=0;servix<serverlist.length;servix++){
                String server=serverlist[servix];
                String msg="apachecacheinvalidator:";
                if(server!=null && !server.equals("")){
                    if(!cacheInvalidator.invalidatePage(server, pageToFlush)){
                        msg+="Couldn't invalidate page in webserver cache. Server: "+server+" Page:" + pageToFlush;
                    }else{
                        msg+="Flushed: "+server+" Page:" + pageToFlush;
                    }
                }           
                //Render.logOut(1, msg);
                out.println(msg+"<br>");
        }
    }
}
    
%>
<h1>Apache Cache Invalidator</h1><br>
This form will flush a page (and any associated elements) from the Apache /htdocs.<br>
<b>It does not remove child pages.</b> However, all pages in a single directory can be removed with a /*<br><br>
<FORM action="" method="GET">
<b>Server:</b>
<select name="server">
<!-- STAGING
<option value="stgpublish">www1-int.accessmcd.com</option>
-->
<option value="author">author.accessmcd.com</option>
<option value="accessmcd" selected>www.accessmcd.com</option>
<option value="mcsource" selected>mcsource.mcdonalds.com.au</option>
</select>
<br><br>
<b>Page:</b><INPUT size=60 name="page" value="/accessmcd/corp">
<br>
<b>Page List:</b><br><TEXTAREA rows=10 cols=80 name="pagelist" value=""></TEXTAREA>
<br>
<br>
<INPUT type=submit value="FLUSH!">
</FORM> 
   