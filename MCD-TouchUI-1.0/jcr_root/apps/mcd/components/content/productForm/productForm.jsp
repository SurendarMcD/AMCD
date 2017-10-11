<%-- 

  Global Menu Solutions component. 

  This is Global Menu Solutions Component
  
--%>

<%@include file="/apps/mcd/global/global.jsp"%><%
%><%@ page import="java.util.ArrayList,java.net.URLDecoder,java.util.Calendar,java.net.URL"%> 
<%@ page import="java.util.Collections,java.util.List,java.lang.String,com.day.cq.wcm.api.Page"%>
<%@page import="java.util.StringTokenizer, java.util.Iterator,com.day.cq.wcm.api.PageFilter"%> 
<%@ page import="java.util.*,java.text.DateFormat,com.mcd.gmt.product.bo.ProductDetail,com.mcd.gmt.product.constant.ProductConstant, org.slf4j.Logger,org.slf4j.LoggerFactory"%>

<script type="text/javascript" src="/scripts/datePickergms.js"></script>  
<script type="text/javascript" src="/scripts/gms.js"></script>   
<script type="text/javascript">
<%  
String rootPagePath= properties.get(ProductConstant.rootpath,""); 
String addLabel = properties.get("addLabel","");
String editLabel = properties.get("editLabel","");
String isreplicated=""; 
String displayMsg="";
String pageStatus = ""; 
Calendar lastReplicatedDate;
Calendar lastModifiedDate;
long lastReplicatedTime = 0L; 
long lastModifiedTime = 0L; 
int i=0; 

//getting message for statusdiv from propertyfile
Properties valPropFrm = PropertiesLoader.loadProperties("common.properties");
String status = ""; 
String domain=valPropFrm.getProperty("gmsdomain");
%> 
 
function getresponseaction(r)
{  
    url ='<%=resource.getPath()%>.productDetails.html?mode=' + r + '&<%=ProductConstant.rootpath%>=<%=rootPagePath%>';
    //alert(url); 
    if(r == '<%=ProductConstant.ACTION_EDIT%>'){
        url = url + '&<%=ProductConstant.EDIT_PAGE_PATH%>=' + escape(document.getElementById('<%=ProductConstant.EDIT_PAGE_PATH%>').value);     
    } 
    //alert(url);     
    if(document.getElementById('statusdiv')) {
        document.getElementById('statusdiv').innerHTML = "";
    }
    ajaxObj = $.ajax({                         
        url: url, 
        type: 'GET', 
        data: '',                                                                    
        cache: false,                                                                                                 
        error: function(){
            //alert("Error during AJAX call. Please try again");
        },
        success: function(xml){         
            var formDiv = document.getElementById('form');
            var productformDiv = document.getElementById('productform'); 
            productformDiv .innerHTML = xml;
            formDiv.style.display= "none";     
            //hideMenuID();             
        }   
    });         
}  
</script> 

<%
String returnMessage="";
returnMessage=request.getParameter("returnStatus"); 
try{
returnMessage=URLDecoder.decode(returnMessage,"UTF-8"); 
}
catch(Exception e)
{
log.error("error in returnMessage"+e);
}
String[] pageName = null;
String lbl="";
 
String createdPage="";
String state="";
ProductDetail productDetailBean = new ProductDetail();

if((returnMessage!=null) ){
    
    pageName = returnMessage.split("\\|");
    if(pageName !=null && pageName.length > 2) {
           
            createdPage = pageName[0];
            log.error("******************************************************************** Inside Product Form ******** : " + createdPage);
            state = pageName[1];
            log.error("******************************************************************** Inside Product Form ******** : " + state);
            lbl = pageName[2];
            log.error("******************************************************************** Inside Product Form ******** : " + lbl);
            
            status = valPropFrm.getProperty("gmstatus_" + state);
            if (state.equals("0")) {
            status = valPropFrm.getProperty("gmstatus_0");          
            } else {
                if(status.contains("<domain>")){
                log.error("the status after fetching status statement from property file is: " + status );
                status = status.replaceAll("<domain>",domain + "/" + lbl+ ".html");
                }   
                if(status.contains("<page>")){
                log.error("the status replacing <domain> in status statement from property file is: " + status );
                status = status.replace("<page>",createdPage);
                log.error("the final status replacing <page> in status statement from property file is: " + status );  
                %> 
                <div id="statusdiv"><%=status %></div>
                <%
                 }
            }
        
        }
        
        }
  
%>  
<div id = "productform"></div>

<div align="center">
    <form style="text-align:left; padding-top:40px;  width:250px" name = "frm" action="javascript:getresponseaction();" method="POST"> 
        <div id= "form">
            <table border='1'width="379px" > 
                <tr>
                    <td> 
                    
                    <label for="ADD"> <font size="2" face="Arial, Helvetica, sans-serif"> <b> &nbsp; <%=addLabel%>&nbsp;&nbsp;&nbsp;</b> </font></label>
                    <input type="button" name="<%=ProductConstant.ACTION_ADD%>" value="<%=ProductConstant.ACTION_ADD%>" id="<%=ProductConstant.ACTION_ADD%>" onclick='getresponseaction("<%=ProductConstant.ACTION_ADD%>")'/> 
                    </td>
                </tr>
            
                <tr>
                    <td> 
                        <label for="EDIT"> <font size="2" face="Arial, Helvetica, sans-serif">  <b> &nbsp; Edit product page :<br> </b> </font></label>
                        <select name="<%=ProductConstant.EDIT_PAGE_PATH%>" id="<%=ProductConstant.EDIT_PAGE_PATH%>" style="width:379px"> 
                    <%

                            ArrayList archivedList= new ArrayList();
                            ArrayList draftList= new ArrayList(); 
                            ArrayList publishedList= new ArrayList();
                            if(rootPagePath.equals(""))
                            {
                                %><option>Please enter the rootPath in dialog box</option><%
                            }
                            else
                            { 
                                Page rootPage = pageManager.getPage(rootPagePath);//get the rootpage object
                                String pagePath = null;
                                String pageTitle = null;
                                if(rootPage != null)
                                {
                                    Iterator<Page> pageIter = rootPage.listChildren();//get the iterator for root page children
                                    
                                    //repeat till any children is left                                    
                                    while(pageIter.hasNext())
                                    { 
                                        displayMsg=ProductConstant.PAGE_SAVEASDRAFT; 
                                        Page childPage = pageIter.next();
                                        if( !(null==childPage) ){ 
                                            if((childPage.getProperties().get("WWKBArchievedFlag","")).equals("yes")){
                                                //log.error("Status of ***************************** " + childPage.getTitle() + " is " + childPage.getProperties().get("WWKBArchievedFlag","NO"));
                                                displayMsg=ProductConstant.PAGE_ARCHIVED;
                                                archivedList.add(childPage.getTitle()+"~"+ childPage.getPath()); 
                                            }
                                            else{ 
                                                isreplicated=childPage.getProperties().get("cq:lastReplicationAction","");
                                                lastModifiedDate=childPage.getProperties().get("cq:lastModified",Calendar.class);
                                                lastReplicatedDate= childPage.getProperties().get("cq:lastReplicated",Calendar.class);
                                                if(!"".equals(isreplicated)) {
                                                    lastReplicatedTime = lastReplicatedDate!=null ? lastReplicatedDate.getTimeInMillis() : 0L;
                                                    lastModifiedTime= lastModifiedDate!= null ? lastModifiedDate.getTimeInMillis() : 0L;
                                                    if((lastReplicatedTime != 0L) && (lastModifiedTime != 0L)) {  
                                                        if((lastModifiedTime < lastReplicatedTime))
                                                        {                                                
                                                            displayMsg=ProductConstant.PAGE_ACTIVATE;
                                                        }
                                                    }                                                    
                                                }
                                                if(displayMsg.equals(ProductConstant.PAGE_ACTIVATE))
                                                {    
                                                    publishedList.add(childPage.getTitle()+"~"+ childPage.getPath());
                                                    //out.print("active :: " + childPage.getPath() + " :: " + childPage.getTitle() + "<br>");
                                                }                                                    
                                                else
                                                {
                                                    draftList.add(childPage.getTitle()+"~"+ childPage.getPath()); 
                                                    //out.print(childPage.getPath() + " :: " + childPage.getTitle() + "<br>"); 
                                                }  
                                            } 
                                        }        
                                    }
                                    
                                     
                                    //log.error("The list of ARCHIVED PAGES IS *****************************: " + archivedList );
                                    //log.error("The list of SsD PAGES IS *****************************: " + draftList );
                                    //log.error("The list of Pub_d PAGES IS *****************************: " + publishedList );
                                    Collections.sort(publishedList);   
                                    Collections.sort(draftList);    
                                    Collections.sort(archivedList);
                                    for(i=0;i<draftList.size();i++)
                                    {
                                        StringTokenizer dataValue= new StringTokenizer(draftList.get(i).toString(),"~");
                                        pageTitle=dataValue.nextToken();
                                        pagePath = dataValue.nextToken();
                                        pageStatus=ProductConstant.PAGE_SAVEASDRAFT;
                                        
                                        %>     
                                        <option value="<%= pagePath %>"><%=pageTitle %> (<%= pageStatus %>) </option>              
                                        <%    
                                    } 
                                    for(i=0;i<publishedList.size();i++)
                                    {
                                        StringTokenizer dataValue= new StringTokenizer(publishedList.get(i).toString(),"~");
                                        pageTitle=dataValue.nextToken();
                                        pagePath = dataValue.nextToken();
                                        pageStatus=ProductConstant.PAGE_ACTIVATE;
                                        
                                        %>     
                                        <option value="<%= pagePath %>"><%=pageTitle %> (<%= pageStatus %>) </option>              
                                        <%                                          
                                    }
                                    for(i=0;i<archivedList.size();i++)
                                    {
                                        StringTokenizer dataValue= new StringTokenizer(archivedList.get(i).toString(),"~");
                                        pageTitle=dataValue.nextToken();
                                        pagePath =dataValue.nextToken();
                                        pageStatus=ProductConstant.PAGE_ARCHIVED;
                                        %>      
                                        <option value="<%= pagePath %>"><%=pageTitle %> (<%= pageStatus %>) </option>   
                                        <%
                                    }                   
                                                                  
                                } 
                            } 
                        %> 
                        </select>
                        <br>          
                        <label for="EDIT"> <font size="2" face="Arial, Helvetica, sans-serif">  <b> &nbsp; <%=editLabel%> &nbsp;&nbsp;&nbsp; </b> </font></label>          
                        <input type="button" name="<%=ProductConstant.ACTION_EDIT%>" value="<%=ProductConstant.ACTION_EDIT%>" onclick='getresponseaction("<%=ProductConstant.ACTION_EDIT%>")' />
                        
                    </td>  
                </tr> 
            </table>   
        </div>
    </form>  
</div> 