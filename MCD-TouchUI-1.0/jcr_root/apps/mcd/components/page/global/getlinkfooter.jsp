 <%@include file="/apps/mcd/global/global.jsp"%>
<%@ page import="com.day.cq.wcm.foundation.Image,
                 com.day.image.Layer,
                 com.day.cq.wcm.api.components.DropTarget,
                 java.util.Calendar,
                 java.util.GregorianCalendar,
                 java.util.Locale,
                 java.util.Date,
                 java.net.URLEncoder,
                 java.text.ParseException,
                 java.util.TimeZone,
                 com.day.cq.wcm.api.WCMMode,
                 java.text.SimpleDateFormat,
                 com.mcd.accessmcd.util.CommonUtil,
                 java.util.Enumeration" %> 
              
<% String prefixAMCD=properties.get("textprefixAMCD","");%> 
 <script type="text/javascript" src="/etc/designs/mcd/accessmcd/corelibs/core/js/jquery-1.7.1.min.js"></script>  
<script>
function clipBoard(){
     var copyText  = document.getElementById("copytext").textContent || document.getElementById("copytext").innerText;
     document.getElementById("holdtext").innerText = copyText;
     clipboardData.setData("Text", document.getElementById("holdtext").value);    
}
       
function closebox()
{
    window.parent.killColorBox();
}
</script>    
             
<div id="AlertBox" style="z-index:1000; background:white; scroll:none;" class="alert">
    <table border=0 width=500 cellpadding="4" style='table-layout:fixed;'>
     <col width=400>
     <col width=100>
    <tr>
        <td colspan="2" align="center">
          <B><%=currentPage.getTitle()%></B>
        </td>
    </tr>
    <tr>
        <td style="background-color:#FFFFFF;"> 
          <DIV ID="copytext" STYLE="word-wrap:break-word;">
            <script language="JavaScript">
               
               var theURL= this.location; 
               theURL=theURL.toString();
               if(theURL.indexOf('/accessmcd/apmea/au.')>-1)
               {
                   theURL=theURL.substring(0,theURL.indexOf('/accessmcd/apmea/au.'));
                   theURL=theURL+"/accessmcd/apmea/au.html";                    
                }

               if(theURL)
               {
                   theURL = "<%=prefixAMCD%>" + theURL;
                   theURL = theURL.replace("getlinkfooter.","");
                   document.getElementById('copytext').innerHTML=theURL;
               }

            </script>
          </DIV>
        </td> 
        <td align="center">
            <a value='Copy Link' type="button" id='copy_link' style='display:block; cursor: pointer;font-weight:bold;font-size:8pt;color:#000000;text-decoration:none;' onClick='clipBoard()'><img align='absMiddle' src='/images/copy_link.png'>&nbsp;<%=langText.get("Copy Link")%></a>
            <script language="JavaScript">
                var browser=navigator.appName;
                if (browser =="Microsoft Internet Explorer") {
                   document.getElementById('copy_link').style.display = "block";
                }
            </script>
        </td>
    </tr>
    <tr>
        <td colspan="2" align="center">
          <TEXTAREA ID="holdtext" STYLE="display:none;"> </TEXTAREA>
          <form style="text-align:center">
            <!--<input 
               type="button" 
               value="Close" 
               style="width:75px;" 
               onclick="grayOut('AlertBox',false);">-->
               <a class="loaded" style="cursor: pointer; font-weight:bold;text-decoration:none;font-size:8pt;color:#000000;" href="#" onClick="closebox()" ><img align="absMiddle" src="/images/cancel.gif" />&nbsp;<%=langText.get("Close")%></a>
          </form>
        </td>   
    </tr>
    </table>
</div>
