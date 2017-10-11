<%-- ########################################### 
 # DESCRIPTION: This is the Maintain Country component which will keep the status of active Countries.
 # Author: Nitin Sharma
 # Environment: 
 # 
 ##############################################--%>
 
 <%-- Including the global header file --%> 


<%@ page session="false" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Arrays,com.day.cq.security.User" %>
<%@ page import="com.mcd.accessmcd.gcd.facade.*" %>
<%@ page import="com.mcd.accessmcd.gcd.bean.CountryDetails" %>
<%@ page import="com.mcd.accessmcd.gcd.constants.GCDConstants,com.mcd.accessmcd.util.CommonUtil" %>
<%@ page import="com.mcdexchange.nl.*"%>
<%@ page import="com.mcd.accessmcd.common.helper.PropertyHelper"%>
<%@ page import="com.day.cq.i18n.I18n"%>



<%-- refer to content of the current container in the components container list --%>           


<%
    IGCDFacade iGCDFacade= null;
    ArrayList allCountryNames=null;
    ArrayList saveCountryList=null;
    ArrayList oldActiveCountryList=null;
    CountryDetails countryDetails=null;
    int returnVal=0; 
    String infoText="";
    String helpLink="";
    String helpHeight="";
    String helpWidth="";
    String iframeBorder="";
    String iframeScroll="";
    HttpSession session=null;   
    String exitPageLinkURL=null;
    boolean australia_flag=false;
      
     CommonUtil commonUtil = new CommonUtil();  
      
    final User user = slingRequest.getResourceResolver().adaptTo(User.class);//instantiate User object 
    String eid = "";
    if(user != null) {      
        eid= user.getID();
         
    }  
    
    String Helppath = properties.get("helpPath","");
    
    int temp1 =0;
    try{
             
        exitPageLinkURL=  properties.get("ExitPageLinkURL",""); 
        
        iGCDFacade= new GCDFacadeImpl();
        
             
        if(request.getParameter(GCDConstants.MAINTAIN_COUNTRY_COUNTRY_TAG) != null)
        {
          String[] countries= request.getParameterValues(GCDConstants.MAINTAIN_COUNTRY_COUNTRY_TAG);
          ArrayList activeCountryList = new ArrayList(Arrays.asList(countries)); 
          oldActiveCountryList=iGCDFacade.getActiveCountries(sling);
          saveCountryList=new ArrayList();    
          for(int i=0; i<countries.length; i++){
            countryDetails=new CountryDetails();
            countryDetails.setCtryCd(countries[i]);
            countryDetails.setActiveFl(GCDConstants.CONSTANT_TRUE); 
            saveCountryList.add(countryDetails);
      
           }
           oldActiveCountryList.remove(saveCountryList);
           
          Iterator itr=oldActiveCountryList.iterator();
       
          while(itr.hasNext()){
           countryDetails=(CountryDetails)itr.next();
           if(!activeCountryList.contains(countryDetails.getCtryCd()))
           {
            countryDetails.setActiveFl(GCDConstants.CONSTANT_FALSE);
           }
           saveCountryList.add(countryDetails);
          }
            
          returnVal=iGCDFacade.updateCountriesStatus(saveCountryList,eid,sling);
          allCountryNames=iGCDFacade.getCountries(sling);   
          infoText = GCDConstants.COUNTRY_UPDATED_MESSAGE;
        }
            
        else
        {
            // Added by Rajat Chawla //
         if(request.getParameter(GCDConstants.MAINTAIN_COUNTRY_SAVE_VAL)!=null)
         { 
          allCountryNames=iGCDFacade.getCountries(sling);
          saveCountryList=new ArrayList();
          if(allCountryNames != null)
          {
           for(int i=0; i<allCountryNames.size(); i++){
            countryDetails=new CountryDetails();
            countryDetails=(CountryDetails)allCountryNames.get(i);
            countryDetails.setActiveFl(GCDConstants.CONSTANT_FALSE);    
            saveCountryList.add(countryDetails); 
           }
          }  
          returnVal=iGCDFacade.updateCountriesFlag(sling);
          allCountryNames=iGCDFacade.getCountries(sling);          
         }
         else
         {
          allCountryNames=iGCDFacade.getCountries(sling);
         }
        }
            
        
                     
   }
   catch(Exception e)
   {
     temp1 =1;
     log.error("ERROR IN ACTIVATE COUNTRY : " + e.getMessage());
   }
   if(temp1==0)
   {  
%>

            <table width="100%" height="100%" cellpadding="0" cellspacing="5">
            <tr>
            <td>
                <table width="100%" height="100%" cellpadding="0" cellspacing="0">
                
                    <tr>
                      <td width="100%" height="12" nowrap>
                        <%-- insert the GCD header file and pass the help parameters obtained from the session earlier --%>
                         
                      </td>
                    </tr>
                    
                   <tr height="100%">
                     <td width="100%" valign="top" class="gcdSkinBorder" style="padding:5px;" dir="ltr" >
                      
                       <form name="frmMaintainCountry" action="" method="get">
                       
                        <table class="gcddata" width="100%" cellpadding="0" cellspacing="0" >
                        
                          <tr>
                           <td><input type="hidden" name="<%= GCDConstants.FORMACTION %>" value=""/></td>
                          </tr>
                        
                          <tr>
                           <td colspan="2"><b></b></td>
                          </tr>
                         
                          <tr>
                           <td colspan="2"class="gcdcontentlnkhd"><b><%= infoText %></b></td>
                          </tr>
                         
                          <tr>
                           <td colspan="2" class="gcdcontentlnkhd"><b><%= properties.get("PageMessage",GCDConstants.MAINTAIN_COUNTRY_INSTRUCTIONS) %></b></td>
                          </tr>
                         
                          <tr>
                           <td width="4%">&nbsp;</td>
                           <td>&nbsp;</td>
                          </tr>
                         
                          <tr>
                           <td colspan="2">
                             <%-- show page links --%>
                             <a href="#" class="contentlnk" onclick="javascript:frmSubmit()">
                               <%= properties.get("SaveLinkName",langText.get("Save")) %> </a>
                                &nbsp;&nbsp;&nbsp; 
                                                          
                               <%
                                if(exitPageLinkURL.equals(""))
                                {
                               %>   
                                 <a href="javascript:cancel()" class="contentlnk"><%= properties.get("ExitPageLinkName",langText.get("Cancel")) %></a>
                               <%
                                }
                               else
                                {
                               %>
                                 <a href="<%= commonUtil.getValidURL(exitPageLinkURL) %>" class="contentlnk"><%= properties.get("ExitPageLinkName",langText.get("Cancel")) %></a>
                               <%
                                }
                               %>
                               <%
                                if(!Helppath.trim().equals(""))
                                {
                               %>
                               &nbsp;&nbsp;&nbsp 
                               <a href="javascript:openWindow('<%= commonUtil.getValidURL(Helppath) %>','<%= properties.get("helpHeight","800")%>','<%= properties.get("helpWidth","1000")%>')" id = "help2" class="contentlnk"><%= properties.get("helpLabel",langText.get("Help"))%></a>
                             <%
                              }   
                             %> 
                           </td>
                          </tr>
                            
                          <tr>
                           <td>&nbsp;</td>
                           <td>&nbsp;</td>
                          </tr>
                             
                          <tr>
                           <td>&nbsp;</td>
                           <td class="gcdcontentlnkhd"><b><%= properties.get("CountryText",langText.get("Country"))%></b></td>
                          </tr>
              
                            <%  
                              if(allCountryNames != null)
                              {
                               for (int i = 0; i < allCountryNames.size(); i++) 
                               {
                                countryDetails = (CountryDetails) allCountryNames.get(i);
                            %>
                       
                          <tr>
                           <td><input type="checkbox" name="<%= GCDConstants.MAINTAIN_COUNTRY_COUNTRY_TAG %>" value="<%= countryDetails.getCtryCd() %>" <%= countryDetails.getActiveFl().equals(GCDConstants.CONSTANT_TRUE)? "checked" : "" %> /></td>
                           <td class="gcdcontentlnkhd"><%=countryDetails.getCtryNm()%>&nbsp;(<%= countryDetails.getCtryCd() %>)</td>
                          </tr>
                
                            <%
                               }
                              } 
                              else
                              {
                              log.error(" No Data from Databse");
                              }
                            %>
                        
                          <tr>
                           <td width="4%">&nbsp;</td>
                           <td>&nbsp;</td>
                          </tr>       
                         
                          <tr>
                           <td colspan="2">
            
                            <%-- show page links --%>
                            <a href="#" class="contentlnk" onclick="javascript:frmSubmit()">
                             <%= properties.get("SaveLinkName","Save") %> </a>
                             &nbsp;&nbsp;&nbsp; 
                            <a href="javascript:cancel()" class="contentlnk">
                             <%= properties.get("ExitPageLinkName","Cancel") %></a>
                             <%
                             if(!Helppath.trim().equals(""))
                              {
                             %>
                               &nbsp;&nbsp;&nbsp 
                               <a href="javascript:openWindow('<%= commonUtil.getValidURL(Helppath) %>','<%= properties.get("helpHeight","800")%>','<%= properties.get("helpWidth","1000")%>')" id = "help2" class="contentlnk"><%= properties.get("helpLabel",langText.get("Help"))%></a>
                             <%
                              }   
                             %>  
                           </td>
                          </tr>
                       
                        </table>
                    
                      </form>
                  
                    </td>
                  </tr>
                </table>     
              </td> 
             </tr>
            </table>
 <%
  }
  else
  {
 %>
   <div class="errorMsg"><%= GCDConstants.ERROR_GCD_DATABASE_ERROR %></div>
  <%  
  }
  %>   

<script>
    
    function frmSubmit()
    {
     document.frmMaintainCountry.action="<%= currentPage.getPath()%>.html?<%= GCDConstants.MAINTAIN_COUNTRY_SAVE_VAL %>=save";
     document.frmMaintainCountry.submit();
    }
    
</script>    


       