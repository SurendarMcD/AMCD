    <%-- ########################################### 
     # DESCRIPTION: Footer Componnet 
     # consists of footer & toolbar section
     # Author: Rajat Chawla 
     # 
     # 
     # UPDATE HISTORY       
     # 1.0  Judy Zhang, 06/10/2010,Initial version 
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
    
    <% 
    String home = currentStyle.get("absParent","");//Text.getAbsoluteParent(currentPage.getPath(), (int) absParent);
    //judy added this
    Page thisPage = currentPage;
       
    // Read Root Node Level value from site level properties
    Node siteLevelNode = null;
    // changes done for retreiving the dynamic template name //
    String template=pageProperties.get("cq:template", "");
    template=template.substring(template.lastIndexOf("/")+1);
    Resource resourcePath=null;
    
    try{
        //this needs to be made less specific to base template - Erik 7/7/10
        //siteLevelNode=slingRequest.getResourceResolver().getResource(currentDesign.getPath()+"/jcr:content/base/sitefooter").adaptTo(Node.class);
        siteLevelNode=slingRequest.getResourceResolver().getResource(currentDesign.getPath()+"/jcr:content/"+template+"/sitefooter").adaptTo(Node.class);
        

    }catch(Exception e){}
    
    
    
    if(siteLevelNode==null)return;    
    %>




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
    
    
    %>
    
    <%
/*
    // retrieve the values from dialog //
    String prefixMCD="";
    Boolean emailLink=properties.get("emailLink",false);
    Boolean getLink=properties.get("getLink", false);
    Boolean bookmarkLink=properties.get("bookMark", false);
    Boolean printLink=properties.get("printLink", false);
    String timeZone = (String)properties.get("timezone","us");

    String emailText= properties.get("textEmailLink","Email");
    String getLinkText=properties.get("textGetLink","Get Link");
    String bookMarkText=properties.get("textBookMark","Bookmark");
    String printLinkText=properties.get("textPrintLink","Print");

    String prefixAMCD=properties.get("textprefixAMCD","");
    String optionVal[] = properties.get("pageInfo",String[].class);
    String copyrightmsg=properties.get("copyMessage","");
    Image image = new Image(resource,"image");
 
    String currentPagePath=currentPage.getPath();
*/       
    
    
    // Judy test site level 

    String prefixMCD="";
    Boolean emailLink=(siteLevelNode.hasProperty("emailLink"))?Boolean.valueOf(siteLevelNode.getProperty("emailLink").getValue().getString()):false;
    Boolean getLink=(siteLevelNode.hasProperty("getLink"))?Boolean.valueOf(siteLevelNode.getProperty("getLink").getValue().getString()):false;
    Boolean bookmarkLink=(siteLevelNode.hasProperty("bookMark"))?Boolean.valueOf(siteLevelNode.getProperty("bookMark").getValue().getString()):false;
    Boolean printLink=(siteLevelNode.hasProperty("printLink"))?Boolean.valueOf(siteLevelNode.getProperty("printLink").getValue().getString()):false;
    String timeZone = (siteLevelNode.hasProperty("timezone"))?(siteLevelNode.getProperty("timezone").getValue().getString()):"us";


    String emailText= (siteLevelNode.hasProperty("textEmailLink"))?(siteLevelNode.getProperty("textEmailLink").getValue().getString()):"Email";
    String getLinkText=(siteLevelNode.hasProperty("textGetLink"))?(siteLevelNode.getProperty("textGetLink").getValue().getString()):"GetLink";
    String bookMarkText=(siteLevelNode.hasProperty("textBookMark"))?(siteLevelNode.getProperty("textBookMark").getValue().getString()):"Bookmark";
    String printLinkText=(siteLevelNode.hasProperty("textPrintLink"))?(siteLevelNode.getProperty("textPrintLink").getValue().getString()):"Print";

    String prefixAMCD=(siteLevelNode.hasProperty("textprefixAMCD"))?(siteLevelNode.getProperty("textprefixAMCD").getValue().getString()):"";


    Value optionVal[] = null;
    try{
       optionVal = (siteLevelNode.hasProperty("pageInfo"))?(siteLevelNode.getProperty("pageInfo").getValues()):null;
    }catch(javax.jcr.ValueFormatException e){
       if(siteLevelNode.hasProperty("pageInfo")){
          optionVal= new Value[1];
          optionVal[0]= siteLevelNode.getProperty("pageInfo").getValue();
          }
    }   

    String copyrightmsg=(siteLevelNode.hasProperty("copyMessage"))?(siteLevelNode.getProperty("copyMessage").getValue().getString()):"2012 copyrights";

    //String imagepath = currentDesign.getPath()+"/jcr:content/base/sitefooter/image";
    //String imagepath = currentDesign.getPath()+"/jcr:content/g2g/sitefooter/image";
    // chnages done for retrieving the template name dynamically //
     String imagepath = currentDesign.getPath()+"/jcr:content/"+template+"/sitefooter/image"; 
    Image image = new Image(resource,imagepath);
    String imgWidth = (siteLevelNode.hasProperty("size"))?(siteLevelNode.getProperty("size").getValue().getString()):"1";
    String alt = (siteLevelNode.hasProperty("altText"))?(siteLevelNode.getProperty("altText").getValue().getString()):"";

    String currentPagePath=currentPage.getPath();

    %>
    
    <%-- Table for Toolbar  Links--%>
    <table border="0" align="center"  cellspacing="18" height="46px">
       <tr>
       <%if(emailLink){ %> 
        <td>
        <%if(prefixAMCD.equals("")) {%>
           <%--  <a href="javascript:void(0)" class="contentlinkbold" onclick="javascript:openEmailWin('<%= currentPagePath %>','','name');return false;"><div class="emailImg"></div></a> --%>
             <a id="footerEmailAction" href="javascript:void(0)" class="contentlinkbold" ><IMG src='<%= currentDesign.getPath()%>/images/action_send.gif' align="absMiddle" border=0>  <%=emailText%> </a>
        <%}else{ 
            prefixMCD=URLEncoder.encode(prefixAMCD);
        %>
            <%-- <a href="javascript:void(0)" class="contentlinkbold" onclick="javascript:openEmailWin('<%= currentPagePath %>','<%=prefixMCD%>','name');return false;"><div class="emailImg"></div></a> --%>
             <a id="footerEmailAction" href="javascript:void(0)" class="contentlinkbold" ><IMG src='<%= currentDesign.getPath()%>/images/action_send.gif' align="absMiddle" border=0>  <%=emailText%> </a>
        <%} %>
        </td>
        <script>
        
        $(document).ready(function() {
            $("#footerEmailAction").click(function(){
               openEmailWin('<%= currentPage.getPath() %>','<%=prefixMCD%>','name'); 
             });            
        });
        </script>
       <%} %>
       <%if(getLink){ %> 
        <td>
            <%-- <a href="javascript:DisplayAlert('AlertBox',100,500)" class="contentlinkbold" ><div class="getlinkImg"></div></a> --%>
            <a href="javascript:DisplayAlert('AlertBox',100,500)" class="contentlinkbold" > <IMG src='<%= currentDesign.getPath()%>/images/action_link.gif' align="absMiddle" border=0>  <%= getLinkText %></a> 
       </td>
        <%} %>
       <%if(bookmarkLink){ %> 
        <td>
        <%-- <a href="javascript:bookmark('<%=currentPage.getTitle()%>','<%=prefixAMCD %>')" class="contentlinkbold"><div class="bookmarkImg"></div></a> --%>
        <%--<div id="bookmarkDiv"> --%> 
               
        <a id="footerBookmarksAction" href="<%= currentPagePath %>.addtobookmark.html" class="contentlinkbold" > <IMG src='<%= currentDesign.getPath()%>/images/action_register.gif' align="absMiddle" border=0>  <%=bookMarkText %>
                
        <%--</div> --%> </a>
        </td>
        <%} %>
       <%if(printLink){ %> 
        <td>
           <%--  <a  href="<%= currentPagePath %>.print.html" class="contentlinkbold" onclick="NewPrintWindow(this.href,'name','945','600','yes','no');return false;"><div class="printImg"></div></a> --%>
            <%-- <div id="printDiv"> --%> <a  href="<%= currentPagePath %>.print.html" class="contentlinkbold" onclick="NewPrintWindow(this.href,'name','945','600','yes','no');return false;"> <IMG src='<%= currentDesign.getPath()%>/images/icon_message_print.gif' align="absMiddle" border=0>  <%=printLinkText %> <%--</div> --%> </a>
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
        <td style="background-color:#FFFFFF;"> 
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
            <a value='Copy Link' id='copy_link' style='display:none; cursor: pointer;font-weight:bold;font-size:8pt;color:#000000;text-decoration:none;' onclick='ClipBoard()'><img align='absMiddle' src='/images/copy_link.png'>&nbsp;Copy Link</a>
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
               <a style="cursor: pointer; font-weight:bold;text-decoration:none;font-size:8pt;color:#000000;" href="#" onClick="javascript:grayOut('AlertBox',false);" ><img align="absMiddle" src="/images/cancel.gif" />&nbsp;Close</a>
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
//                String imgWidth = properties.get("size","1.0");
  //              String alt = properties.get("altText","");
                

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
           <TD height=1></TD>
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
if (optionVal!=null) {
for(int i=0;i<optionVal.length;i++)
{
    if(!optionVal[i].getString().equals(COPYRIGHT_VAL))
    {   

// judy changed this
//            String optVal[]=optionVal[i].split(",");
            String optVal[]=optionVal[i].getString().split(",");
            String disText=optVal[0];
            String disVal=optVal[1];
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
            else
            {
                SimpleDateFormat sdf =new SimpleDateFormat ( "EEE MMM d yyyy HH:mm:ss ",Locale.US );
                String newDate = sdf.format(cal.getTime());
                
            %>
            
                      <TR>
                            <TD class=footer > <B> <%=disText %> :</B> <%=newDate %> CDT
                     </TR>                  
            <%}
                }
            
            else 
            {
                if(disText.equals(EMAIL_VAL))
            {%>
            
                      <TR>
                            <TD class=footer > <B> <%=disText %> :</B> 
                            <%if(!(null==currentPage.getProperties().get(disVal))){%>
                            <a href="mailto:<%=currentPage.getProperties().get(disVal) %>" ><%=currentPage.getProperties().get(disVal) %></a>
                            <%}%> 
                     </TR>                  
            <%}
                
            
            
            else
            {               
    %>
    <TR>
<TD class=footer > <B> <%=disText %> :</B> 
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


}else if (WCMMode.fromRequest(request) == WCMMode.EDIT) { 
%>
        <img src="/libs/cq/ui/resources/0.gif" class="cq-text-placeholder image " alt="">
<%}%>
   </TBODY></TABLE>