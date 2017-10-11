    <%-- ########################################### 
     # DESCRIPTION: Footer Componnet 
     # consists of footer & toolbar section
     # Author: Rajat Chawla 
     # 
     # 
     # UPDATE HISTORY       
     # 1.0  Rajat Chawla, 01/10/2009,Initial version  
     # 
     ##############################################--%>
    
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
                     java.text.SimpleDateFormat" %>
    <%@include file="/apps/mcd/global/global.jsp"%>
    
    <%!
    
    // method to convert the string to date object //
    public static Date stringToDate(String date, String datePattern) {
        SimpleDateFormat df = new SimpleDateFormat(datePattern);
        Date dayDate = null;
        try {
            dayDate = df.parse(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return dayDate;
    }
    
    // code for footer //
    static final String COPYRIGHT_VAL="Copyright";
    static final String LMD_VAL="Last Modified";
    static final String EMAIL_VAL="Contact Email";
    static final String AUS_ZONE="aus";
    static final String AUS_TIMEZONE="Australia/Melbourne";
    static final String US_ZONE="us";
    static final String CAN_ZONE="fr"; 
    
    %>
    
    <%
    // retrieve the values from dialog //
    //String LMD_VAL=langText.get("Last Modified");
    String prefixMCD="";
    //String Email=langText.get("Email");
    //String GetLink=langText.get("GetLink");
    //String Bookmark=langText.get("Bookmark");
    //String Print=langText.get("Print");
    Boolean emailLink=properties.get("emailLink",false);
    Boolean getLink=properties.get("getLink", false);
    Boolean bookmarkLink=properties.get("bookMark", false);
    Boolean printLink=properties.get("printLink", false);
    String timeZone = (String)properties.get("timezone","us");
    String emailText= properties.get("textEmailLink",langText.get("Email"));
    String getLinkText=properties.get("textGetLink",langText.get("GetLink"));
    String bookMarkText=properties.get("textBookMark",langText.get("Bookmark"));
    String printLinkText=properties.get("textPrintLink",langText.get("Print"));
    String prefixAMCD=properties.get("textprefixAMCD","");
    String optionVal[] = properties.get("pageInfo",String[].class);
    String copyrightmsg=properties.get("copyMessage","");
    Image image = new Image(resource,"image");
 
    String currentPagePath=currentPage.getPath();
       
    
    %>
    
    <%-- Table for Toolbar Links--%>
    <table border="0" align="center"  cellspacing="18" height="46px">
       <tr>
       <%if(emailLink){ %> 
        <td>
        <%if(prefixAMCD.equals("")) {%>
             <a href="javascript:void(0)" class="contentlinkbold" onclick="javascript:openEmailWin('<%= currentPagePath %>','','name');return false;"><div class="emailImg"></div></a>
             <a href="javascript:void(0)" class="contentlinkbold" onclick="javascript:openEmailWin('<%= currentPagePath %>','','name');return false;"><%=emailText%> </a>
        <%}else{ 
            prefixMCD=URLEncoder.encode(prefixAMCD);
        %>
            <a href="javascript:void(0)" class="contentlinkbold" onclick="javascript:openEmailWin('<%= currentPagePath %>','<%=prefixMCD%>','name');return false;"><div class="emailImg"></div></a>
             <a href="javascript:void(0)" class="contentlinkbold" onclick="javascript:openEmailWin('<%= currentPagePath %>','<%=prefixMCD%>','name');return false;"><%=emailText%> </a>
        <%} %>
        </td>
       <%} %>
       <%if(getLink){ %> 
        <td>
            <a href="javascript:DisplayAlert('AlertBox',100,500)" class="contentlinkbold" ><div class="getlinkImg"></div></a>
            <a href="javascript:DisplayAlert('AlertBox',100,500)" class="contentlinkbold" ><%= getLinkText %></a> 
       </td>
        <%} %>
       <%if(bookmarkLink){ %> 
        <td>
        <a href="javascript:bookmark('<%=currentPage.getTitle()%>','<%=prefixAMCD %>')" class="contentlinkbold"><div class="bookmarkImg"></div></a>
        <div id="bookmarkDiv"><a href="javascript:bookmark('<%=currentPage.getTitle()%>','<%=prefixAMCD %>')" class="contentlinkbold"><%=bookMarkText %></div></a>
        </td>
        <%} %>
       <%if(printLink){ %> 
        <td>
            <a  href="<%= currentPagePath %>.print.html" class="contentlinkbold" onclick="NewPrintWindow(this.href,'name','945','600','yes','no');return false;"><div class="printImg"></div></a>
            <div id="printDiv"><a  href="<%= currentPagePath %>.print.html" class="contentlinkbold" onclick="NewPrintWindow(this.href,'name','945','600','yes','no');return false;"><%=printLinkText %></div></a>
        </a>
        </td>
         <%} %>
       </tr>
      
    </table>




<%-- Hidden Div for Get Link --%>
<div id="AlertBox" class="alert">
    <table border=0 width=500 cellpadding="4" style='table-layout:fixed;'>
     <col width=400>
     <col width=100>
    <tr>
        <td colspan="2" align="center">
          <B><%=currentPage.getTitle()%></B>
        </td>
    </tr>
    <tr>
        <td style="background-color:#FFFF99;">
          <SPAN ID="copytext" STYLE="word-wrap:break-word;">
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
               document.getElementById('copytext').innerHTML=theURL;
               }

            </script>
          </SPAN>
        </td>
        <td align="center">
            <script language="JavaScript">
                var browser=navigator.appName;
                if (browser =="Microsoft Internet Explorer") {
                   var txt ="<input type='button' value='Copy Link' style='width:75px' onclick='ClipBoard()'>";
                   document.write(txt);
                }
            </script> 
        </td>
    </tr>
    <tr>
        <td colspan="2" align="center">
          <TEXTAREA ID="holdtext" STYLE="display:none;"> </TEXTAREA>
          <form style="text-align:center">
            <input 
               type="button" 
               value="Close" 
               style="width:75px;" 
               onclick="document.getElementById('AlertBox').style.display='none'">
          </form>
        </td>
    </tr>
    </table>
</div>

<%-- Table for footer Image --%> 
        <TABLE cellSpacing=0 cellPadding=0 width="100%" align=center border=0>
        <TBODY>    
        <TR>
           <TD class=footer vAlign=top>
           <%    
            if(image.hasContent())
            {
                String imgWidth = properties.get("size","1.0");
                String alt = properties.get("altText","");
                // code to load the image styles//
                image.loadStyleData(currentStyle);
                image.setSelector(".img"); // use image script
                image.setAlt(alt);
                // add design information if not default (i.e. for reference paras)
                if (!currentDesign.equals(resourceDesign)) {
                     image.setSuffix(currentDesign.getId());
                }
                // code to get the image size.
                    Layer layer1 = image.getLayer(true,true,true);
                    int widthImg= (int)(layer1.getWidth()*Double.parseDouble(imgWidth));
                    
                    image.addAttribute("width",Integer.toString(widthImg));
                    image.draw(out);        
            }
           %>
           </TD>
        </TR>
        <TR>
           <TD class=footer></TD>
        </TR>
        <TR>
           <TD height=7></TD>
        </TR>
        </TBODY>
        </TABLE>

<%-- Author Footer --%>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" align=center 
  border=0>
    <TBODY>
    <TR>
      <TD class=footer>
    </TR>
<% 
// checking the array of the check box //
if (null!=optionVal) {
for(int i=0;i<optionVal.length;i++)
{
    if(!optionVal[i].equals(COPYRIGHT_VAL))
    {   
            String optVal[]=optionVal[i].split(",");
            String disText=optVal[0];
            String disVal=optVal[1]; 
            log.error("*****************disval**************"+disVal);
            if(disText.equals(LMD_VAL))
            {
                Calendar cal = (Calendar)currentPage.getProperties().get(disVal);
                if(AUS_ZONE.equals(timeZone))
                {
                    
                    Calendar sydney = new GregorianCalendar(TimeZone.getTimeZone(AUS_TIMEZONE));
                    sydney.setTime(cal.getTime());
                    String dSydney = (sydney.get(Calendar.MONTH) + 1) + "-" + sydney.get(Calendar.DATE) + "-" + sydney.get(Calendar.YEAR)+" "+sydney.get(Calendar.HOUR_OF_DAY)+":"+sydney.get(Calendar.MINUTE)+":"+sydney.get(Calendar.SECOND);
                    SimpleDateFormat sdf =new SimpleDateFormat ("EEE MMM d yyyy HH:mm:ss",Locale.US );
                    Date sydDate = stringToDate(dSydney, "MM-dd-yyyy HH:mm:ss");
                    String newDate = sdf.format(sydDate);
                    
            %>
            
                      <TR>
                            <TD class=footer > <B> <%=disText %> :</B> <%=newDate %> 
                     </TR>                  
            <%}
            else if(US_ZONE.equals(timeZone))
            {
                SimpleDateFormat sdf =new SimpleDateFormat ( "EEE MMM d yyyy HH:mm:ss ",Locale.US );
                String newDate = sdf.format(cal.getTime());
                
            %>
            
                      <TR>
                            <TD class=footer > <B> <%=langText.get(disText) %> :</B> <%=newDate %> CDT
                     </TR>                  
            <%}
            else
            {
                Locale l=new Locale("fr","fr");
                SimpleDateFormat sdf =new SimpleDateFormat ( "EEE MMM d yyyy HH:mm:ss ",l );
                String newDate = sdf.format(cal.getTime());
              
            %>
            
                      <TR>
                            <TD class=footer > <B> <%=langText.get(disText) %> :</B> <%=newDate %> 
                     </TR>                  
            <%}
                }
            
            else 
            {
                if(disText.equals(EMAIL_VAL))
            {%>
            
                      <TR>
                            <TD class=footer > <B> <%=langText.get(disText) %> :</B> 
                            <%if(!(null==currentPage.getProperties().get(disVal))){%>
                            <a href="mailto:<%=currentPage.getProperties().get(disVal) %>" ><%=currentPage.getProperties().get(disVal) %></a>
                            <%}%> 
                     </TR>                  
            <%}
            
            
            else
            {               
    %>
    <TR>
<TD class=footer > <B> <%=langText.get(disText) %> :</B> 
                        <%if(!(null==currentPage.getProperties().get(disVal))){%> 
                        <%=currentPage.getProperties().get(disVal) %> <%} %>
 </TR>

    <%}} }
    else
    {
%>
        <TR>
        <TD class=footer><%= copyrightmsg%> 
         </TR>
<%} }

}else   if (WCMMode.fromRequest(request) == WCMMode.EDIT) {
        %><img src="/libs/cq/ui/resources/0.gif" class="cq-text-placeholder image " alt=""><%
    }   

%>
   </TBODY></TABLE>
