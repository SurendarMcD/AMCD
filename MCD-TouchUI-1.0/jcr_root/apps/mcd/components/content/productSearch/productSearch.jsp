<%--

  Product Search Component component.

  This component will search for the the values under the product pages

--%><%
%><%@include file="/apps/mcd/global/global.jsp"%><%
%><%@page session="false" %>
<%@page import="java.util.StringTokenizer"%>

<script type="text/javascript">
 
function getresults()
{ 
     var text = document.getElementById('wwkbSearchText').value;
     if(text=='<enter text>'){
         text = '';
          }
     url ='<%=resource.getPath()%>.html?searchProductType='+document.getElementById('searchProductType').value+'&searchTargetAudience='+document.getElementById('searchTargetAudience').value+'&searchDaypart='+document.getElementById('searchDaypart').value+'&searchMenuCategory='+document.getElementById('searchMenuCategory').value+'&searchZone='+document.getElementById('searchZone').value+'&searchCountry='+document.getElementById('searchCountry').value+'&wwkbSearchText='+text;
   
    ajaxObj = $.ajax({                          
        url: url, 
        type: 'POST',
        data: '',                                                                    
        cache: false,                                                                                                 
        error: function(){ 
            //alert("Error during AJAX call. Please try again");
        },
        success: function(xml){        
           
            var searchDiv = document.getElementById('search');
            var resultDiv = document.getElementById('result'); 
            $('#content_txt').html(xml);  
            searchDiv.style.display= "block";                  
        }   
    });       
}  

</script>
<%
// Retrieving values from dialog
String Title=properties.get("titleText","To begin browsing products, please select from the list below "); 
String menuCategoryLabel=properties.get("menuCategoryLabel","Menu Item Category"); 
String targetAudienceLabel=properties.get("targetAudienceLabel","Target Audience");
String productDaypartLabel=properties.get("productDayPartLabel","Product Daypart");
String menuItemRoleLabel=properties.get("menuItemRoleLabel","Menu Item Role");
String areaLabel=properties.get("areaLabel","Area Of The World");
String countryLabel=properties.get("countryLabel","Country");
String archiveItemsLabel=properties.get("archiveItemLabel","Include Archived Items");
String textSearchLabel=properties.get("textSearchLabel","Text Search");
 
 //fetching values from Property File
Properties valProp = PropertiesLoader.loadProperties("common.properties");
String areaOfTheWorld=valProp.getProperty("areaOfTheWorld"); 
String targetConsumer=valProp.getProperty("targetConsumer");
String productDaypart=valProp.getProperty("productDaypart");
String menuItemCategory=valProp.getProperty("menuItemCategory");
menuItemCategory=new String(menuItemCategory.getBytes("8859_1"),"UTF-8");  

String menuItemRole=valProp.getProperty("menuItemRole");
StringTokenizer st= null; 
 
%>
<div id= "result"></div>
<div id= "search"  style="width:30%;">
<table width="152" cellspacing="0" cellpadding="0" border="0" >
   <form id="wwkbSearchForm" method="POST" action="javascript:void(0);" onSubmit="javascript:getresults();" > 
        <tbody>
            <tr>
                <td>
                    <table class="wwkbSearchLeftNav">
                        <tbody>
                            <tr>
                                <td><b><%=Title%></b></td> 
                            </tr>
                            <tr>
                                <td>
                                <img height="2" width="1" border="0" src="/0.gif">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                <b><%=menuCategoryLabel%>:</b>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <select id="searchProductType" name="searchProductType">
                                      <option  selected=" " value="">(all)</option>
                                        <%  st= new StringTokenizer(menuItemCategory, "|");
                                        while(st.hasMoreTokens())  
                                        {
                                        String tmp = st.nextToken();
                                        String values[]= tmp.split(",");
                                        %> 
                                       <option value="<%=values[1]%>"><%=values[0]%> </option>  
                                       <% }
                                       %>  
                                    </select>
                                    
                                    <br>
                                </td>
                            </tr> 
                            <tr>
                                <td>
                                <img height="2" width="1" border="0" src="/0.gif">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                <b><%=targetAudienceLabel%>:</b>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <select id="searchTargetAudience" name="searchTargetAudience">
                                    <option  selected=" " value="">(all)</option>
                                     <%  st= new StringTokenizer(targetConsumer, "|");
                                        while(st.hasMoreTokens())  
                                        {
                                        String tmp = st.nextToken();
                                        String values[]= tmp.split(",");
                                        %>  
                                       <option value="<%=values[1]%>"><%=values[0]%> </option>  
                                       <% }
                                       %>  
                                    </select>
                                    <br>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <img height="2" width="1" border="0" src="/0.gif">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <b><%=productDaypartLabel%>:</b>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <select id="searchDaypart" name="searchDaypart">
                                        <option selected="" value="">(all)</option>
                                          <%  st= new StringTokenizer(productDaypart, "|");
                                        while(st.hasMoreTokens())  
                                        {
                                        String tmp = st.nextToken();
                                        String values[]= tmp.split(",");
                                        %>  
                                       <option value="<%=values[1]%>"><%=values[0]%> </option>  
                                       <% }
                                       %>  
                                    </select>
                                    
                                <br>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <img height="2" width="1" border="0" src="/0.gif">
                                </td>
                            </tr>
                            <tr>
                            <td>
                                <b><%=menuItemRoleLabel%>:</b>
                            </td>
                            </tr>
                            <tr>
                                <td>
                                    <select id="searchMenuCategory" name="searchMenuCategory">
                                        <option selected="" value="">(all)</option>
                                         <%  st= new StringTokenizer(menuItemRole, "|");
                                        while(st.hasMoreTokens())  
                                        {
                                        String tmp = st.nextToken();
                                        String values[]= tmp.split(",");
                                        %>  
                                       <option value="<%=values[1]%>"><%=values[0]%> </option>  
                                       <% } 
                                       %>  
                                    </select>
                                <br>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <img height="2" width="1" border="0" src="/0.gif">
                                </td>
                            </tr>
                            <tr>
                            <td>
                            <b><%=areaLabel%>:</b> 
                            </td>
                            </tr> 
                            <tr>
                                <td>
                                    <select id="searchZone" name="searchZone">
                                        <option selected="" value="">(all)</option>
                                        <%  st= new StringTokenizer(areaOfTheWorld, "\\/");
                                        while(st.hasMoreTokens())  
                                        {
                                        String tmp = st.nextToken();
                                        String values[]=tmp.split(",");
                                        String country[]=values[0].split("_"); 
                                        %>  
                                       <option value="<%=country[0]%>"><%=country[0]%> </option>  
                                       <% 
                                       } 
                                       %>     
                                    <br>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <img height="2" width="1" border="0" src="/0.gif">
                                </td>
                            </tr> 
                            <tr>
                                <td>
                                <b><%=countryLabel%>:</b>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <select  id="searchCountry" name="searchCountry">
                                       <option selected="" value="">(all)</option>
                                       <%       String [] aow = areaOfTheWorld.split ("/");
                                                if (aow != null && aow.length>0) {
                                                        for (int i = 0; i< aow.length; i++){
                                                            if (aow[i]!=null && aow[i].length() >0) {
                                                                String countries = aow[i].split(",")[1].trim();
                                                                if (countries!=null && countries.length() >0) {                     
                                                                    String [] cou_cur = countries.split("\\|");
                                                                    if (cou_cur !=null && cou_cur.length>0) {                           
                                                                        for (int j=0; j< cou_cur.length; j++) {
                                                                            if (cou_cur[j] !=null && cou_cur[j].length()>0) {
                                                                                String country = cou_cur[j].split ("_")[0];
                                                                            %>                                         
                                                                 <option value="<%=country%>"> <%=country%></option>            
                                                           <% }
                                                     }
                                                } 
                                            }
                                        }
                                    }
                                }%>         
                                    </select> 
                                <br> 
                                </td>
                            </tr> 
                            <tr>
                                <td>
                                    <img height="2" width="1" border="0" src="/0.gif">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <b><%=archiveItemsLabel%>:</b>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input type="checkbox" value="yes" name="wwkbArchieved">Yes 
                                </td>
                            </tr>
                            <tr>
                                <td>
                                <b><%=textSearchLabel%>:</b>
                                </td>
                            </tr>  
                            <tr>
                                <td>
                                    <input value="&lt;enter text&gt;"id="wwkbSearchText" name="wwkbSearchText">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <img height="2" width="1" border="0" src="/0.gif">
                                </td>
                            </tr>
                        </tbody>
                    </table>
               <center><input type="SUBMIT" value="FIND"></center>
               <br>
               </td> 
            </tr> 
            <tr>
                <td align="center">
                    <!--<A class=wwkbSearchText HREF="https://intl.mcdexchange.com/mcdonalds/wwmm/wwmm_home/for_help_using_page.html">Help</A>-->
                </td>
            </tr>                
        </tbody> 
    </form> 
</table>  
</div>  