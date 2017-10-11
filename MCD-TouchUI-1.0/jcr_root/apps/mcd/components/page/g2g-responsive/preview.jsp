<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page import="com.mcd.accessmcd.util.CommonUtil"%>
<style> 
.tborder 

{ 

border-RIGHT: 1px solid #000000; 
border-TOP: 1px solid #000000; 
FONT-SIZE: small; 
border-LEFT: 1px solid #000000; 
COLOR: black; 
border-BOTTOM: 1px solid #000000; 
FONT-FAMILY:Arial 
} 
</style> 



<table   style="font-family:Arial,Helvetica,sans-serif;"
>

<tr style=" border :thin;">
<th align = "center"  class="tborder" style = "background:lightgrey;" height="50">
<b>
<%=langText.get("Audience Type")%>
  </b>
</th>
<th align = "center" class="tborder"  style = "background:lightgrey;">
<b>
<%=langText.get("Global Ad Text")%>
</b>
</th>
<th align = "center"  class="tborder" style = " background:lightgrey;">
<b>
<%=langText.get("Image")%>
</b>
</th>
</tr>
<%
String val = request.getParameter("data");
CommonUtil commonUtil = new CommonUtil();
if(!val.equals(""))
{
  String [] camps = val.split("\\$");
  String camp[];
  for(int i= 0 ; i < camps.length ; i++)
  {
   camp = camps[i].split("\\|");
   if(camp.length >3) 
   {
   
       camp[3] =  camp[3].replaceAll("," , "<br>");
     
%>
 <tr>
 <td   class="tborder" align = "center" width="300">
 <b><%= camp[3] %></b>
 <% 
 
   }
 %>
 </td>
 <td  align = "center"   class="tborder" width="300">
 <b><%= camp[2] %></b>
 </td>
 
   <td class="tborder" >
   <a href ="<%= commonUtil.getValidURL(camp[1]) %>"><img src="<%=camp[0]  %>" style= "border:none;" width = "250" height = "250"> </a>
   </td>
   </tr>
 <%
}
}
%>

</table>