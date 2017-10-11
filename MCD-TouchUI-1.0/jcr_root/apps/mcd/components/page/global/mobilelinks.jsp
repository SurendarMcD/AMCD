<%@ page import="java.util.ArrayList,
        java.util.Iterator,
        java.util.Date,
        com.day.cq.wcm.api.PageFilter,
        com.day.cq.security.User,
        com.mcd.accessmcd.util.CommonUtil,
        java.util.Iterator,javax.jcr.Value,
        java.util.Map,
        java.util.TreeMap,
        java.util.Set,
        java.text.ParseException,
        java.text.SimpleDateFormat,
        java.text.DateFormat,
        com.day.cq.wcm.api.designer.Designer"%>

<%@include file="/apps/mcd/global/global.jsp"%> 

<%  
    
    response.setHeader("Cache-Control","max-age=0");  
    Node mobileLinksNode = null;
    String moblileLinksHTML = "";
    if(slingRequest.getResourceResolver().getResource(currentPage.getPath()+"/jcr:content/navigationpara")!=null){
        mobileLinksNode = slingRequest.getResourceResolver().getResource(currentPage.getPath()+"/jcr:content/navigationpara").adaptTo(Node.class);
    }
    if(mobileLinksNode!=null){   
        if(mobileLinksNode.hasProperty("mobileLinks")){
            Property references = mobileLinksNode.getProperty("mobileLinks");  
            Value[] mobileMainItem = references.getValues();
            if(null != mobileMainItem && mobileMainItem.length > 0){
                moblileLinksHTML += "<ul>";
                for(Value val: mobileMainItem){
                    String[] mobileItem = val.getString().split("\\^");//split the item data^
                    String linkTitle = "";
                    String linkURL = "";
                    if(mobileItem.length>1 && (!"".equals(mobileItem[0]))){
                      linkTitle = mobileItem[0]; 
                    }
                    if(mobileItem.length>1 && (!"".equals(mobileItem[1]))){
                      linkURL = mobileItem[1]; 
                      if(linkURL.startsWith("/content")){
                          linkURL = linkURL + ".html";
                      }
                    }
                    moblileLinksHTML += "<li><a href='"+linkURL+"'>"+linkTitle+"</a></li>";
                }
                moblileLinksHTML += "</ul>";
            }
        }
    }
%>
{
   "moblileLinks" : "<%=moblileLinksHTML%>"
}
           