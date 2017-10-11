<%--
   language_switcher component component.
   This is language_switcher component
 --%><%@include file="/apps/mcd/global/global.jsp"%><%
%><%@page session="false" %>
 
  <%@ page import="java.util.ArrayList,
           com.day.cq.wcm.api.WCMMode,
           com.day.cq.wcm.api.PageFilter,
           com.day.cq.wcm.api.WCMMode,
           com.day.cq.wcm.api.PageFilter,
           com.mcd.accessmcd.util.CommonUtil
           
          "%>
     
<cq:includeClientLib categories="ToggleButton" /> 
<style>
    .breadCrumb{
        float:left;
    }
</style>
<div>
<%
    int flag=0;     
    String URL=""; 
    String  labelText=properties.get("label",langText.get("Configure Label"));
    if(labelText.trim().equals("")){labelText=langText.get("Configure Label");}
    String alternateUrl="";
    String alternatePath="";
    String hoverText=properties.get("hoverText","");
    String rootPage="";

    String languageToggle_Path=prop.getProperty("languageToggle_Path"); //root path for whole site
    String currentmode=prop.getProperty("currentmode"); //either author or publish
    String getCurrentUrl = currentPage.getPath(); 
    
    if(languageToggle_Path.contains(",")){
        String [] basePath=languageToggle_Path.split(",");
        for(int i=0;i<basePath.length;i++){
            if(getCurrentUrl.indexOf(basePath[i])==0){
                rootPage=basePath[i];
                break;
            }
        }
    }
    else{
        rootPage=languageToggle_Path;
    }

    ArrayList a=new ArrayList();
    ArrayList b=new ArrayList();
    String lngPaths= prop.getProperty(rootPage+"_lng"); 
    int count=0; //set to singlelanguage
    if(lngPaths.contains(",")){
        String [] lngPath=lngPaths.split(",");
        for(int i=0;i<lngPath.length;i++){
            if(getCurrentUrl.indexOf(lngPath[i])!=0){
                a.add(lngPath[i]); 
                count++;
            } 
            else if(getCurrentUrl.indexOf(lngPath[i])==0){
                b.add(lngPath[i]); 
            }
        }
    }

    String currentPath="";
    String alternateLngPath="";
    String alternateView="";
    //if dual language set
    if(count==1){
        currentPath=b.get(0).toString();
        alternateLngPath=a.get(0).toString();
        if(prop.getProperty(alternateLngPath)!=null)
        {
            alternateView=prop.getProperty(alternateLngPath); 
        }
        if(slingRequest.getResourceResolver().getResource(alternateLngPath+"/jcr:content")!=null){
            Node pageNode = slingRequest.getResourceResolver().getResource(alternateLngPath+"/jcr:content").adaptTo(Node.class);
        } 
        
        alternateUrl=(getCurrentUrl.replace(currentPath,alternateLngPath))+".html"; 
        if (alternateUrl.startsWith("/content")){
            alternateUrl=(alternateUrl.replace("/content/","/"));
        }
        
        alternatePath=(getCurrentUrl.replace(currentPath,alternateLngPath));
        CommonUtil cutil=new CommonUtil();  
        flag=cutil.getPageStatus(alternatePath,slingRequest);

        if(currentmode.equals("author")){
%>   
            <div class="toggleButton" style="float:right;">  
<%      
                String user_alert=langText.get("The link will not appear on Publish as");
                String msg_doesnot_exist=langText.get("doesnot exist.") ; 
                String msg_not_active=langText.get("is not Active.") ; 
                if(flag==2){                
%>
                    <a  title="<%= hoverText %>" onclick="togglePage('<%=alternateUrl%>','<%=alternateView%>')" href="#"><span><%= labelText %></span></a> 
<%     
                }
                else if(flag==0){
%>
                    <a  onclick="checkToggleURL('<%=user_alert%>','<%=alternateUrl%>','<%=msg_doesnot_exist%>')" href="#"><span><%= labelText %></span></a> 
<%
                }          
                else if((flag==-2)||(flag==1)){ 
%>
                    <a  onclick="checkToggleURL('<%=user_alert%>','<%=alternateUrl%>','<%=msg_not_active%>')" href="#"><span><%= labelText %></span></a> 
<%
                }  
%>
            </div>
<%
        }
        else{
            if((pageManager.getPage(alternatePath))!= null){                
%>
                <div class="toggleButton" style="float:right;"> 
                    <a title="<%= hoverText %>" onclick="togglePage('<%=alternateUrl%>','<%=alternateView%>')" href="#"><span><%= labelText %></span></a> 
                </div>
<%         
            }
        }          
    }
%>
</div><br><br>


