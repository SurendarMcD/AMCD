<%-- ########################################### 
# DESCRIPTION: Printer Friendly Component
# Author: Shubhra Gupta 
# 
# 
# UPDATE HISTORY       
# 1.0  Shubhra Gupta, 01/10/2009,Initial version 
# 
##############################################--%>

<%@include file="/apps/mcd/global/global.jsp"%>
<%
    //retrieve the values of Printer Freindly Text //
    String printerfreindlytext=properties.get("pftext",langText.get("Printer-Friendly"));
%>

<div class="printFriendly">
 <table width="100%" border="0" cellspacing="0" cellpadding="0" > <tbody>
  <tr class="" align="center"> <td width="100%" valign="middle" nowrap="true">
    <table border="0" cellpadding="0" cellspacing="0"> <tbody> <tr>                  
      <td valign="middle">
        <div class="printFriendlyImg"></div>
      </td>    
      <td valign="middle">
        <div class="printFriendlyText">     
            <a href="<%=currentPage.getPath()%>.print.html" onclick="NewPrintWindow(this.href,'name','945','600','yes','no');return false;">
              <%=printerfreindlytext%>
            </a>
        </div>
       </td>    
       </tr> </tbody> </table>
      </td> </tr>
    </tbody></table>
</div>