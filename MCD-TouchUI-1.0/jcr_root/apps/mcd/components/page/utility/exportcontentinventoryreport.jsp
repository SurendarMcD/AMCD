<%@ page contentType="application/vnd.ms-excel"%>
<%@ page import="java.util.Calendar,
        java.util.Locale,
        java.text.SimpleDateFormat,
        java.util.Iterator,
        com.day.cq.dam.api.*,
        org.apache.jackrabbit.util.Text,
        com.mcd.accessmcd.ace.manager.ACEManager,
        java.text.DecimalFormat,
        org.apache.sling.api.resource.ResourceResolver,
        com.mcd.accessmcd.ace.bo.ACEConfigDataBean"%>
                                
<%@include file="/apps/mcd/global/global.jsp" %>                          

<style type="text/css">
body{
    font-family: verdana,sans-serif,arial;
    font-size:14px;
}
h3{
    text-align:center;
    text-decoration:underline;
    font-size:20px;
    /*color: #005ACC;*/
}
input.formbutton
{  
   font-family:verdana,sans-serif;
   font-weight:bold;
   color:#FFFFFF;
   background-color:#0077BB;
}
table.pagetable {
    border-width: 1px 1px 1px 1px;
    border-spacing: 0px;
    border-style: solid solid solid solid;
    border-color: black black black black;
    border-collapse: collapse;
}

table.pagetable th {
    font-weight:bold;
    border-width: 1px 1px 1px 1px;
    padding: 5px 5px 5px 5px;
    border-style: solid solid solid solid;
    background-color: #EEEEEE;
    color: #802A2A;
    font-size: 12px;
}

table.pagetable td {
    font-size: 11px;
    border-width: 1px 1px 1px 1px;
    padding: 5px 5px 5px 5px;
    border-style: dotted dotted dotted dotted;
}
.nowrap{
    white-space:nowrap;
}
.rightAlign{
    text-align:right;
}
.error
{
 border:1px solid red;
}
</style>

<%!
int count;
Node metadataNode;
String[] restrictSites = {"/content/dam/accessmcd",
                          "/content/accessmcd"
                          };
   /* if(restrictSites[j].equals("/content/dam/accessmcd"))
                        
                    else if(restrictSites[j].equals("/content/accessmcd"))
*/
/** Manual Method **/  
/* This method is used to find the no of days between the given dates */  
public static long daysBetween_manaul(long dateEarly, long dateLater) {  
  return ( (dateLater/ (24 * 60 * 60 * 1000)) - (dateEarly/ (24 * 60 * 60 * 1000)) );  
}
  
/** Using Calendar - CURRENTLY NOT IN USE**/  
public static long daysBetween(Calendar startDate, Calendar endDate) {    
  /*
  Calendar dialogOfftime = Calendar.getInstance();
  dialogOfftime.setTimeInMillis(dialogOfftime_L);
  */    
  Calendar date = (Calendar) startDate.clone();  
  long daysBetween = 0;  
  while (date.before(endDate)) {  
    date.add(Calendar.DAY_OF_MONTH, 1);  
    daysBetween++;  
  }  
  return daysBetween;  
} 

/* Returns the Date String in requested Display Format */
public String displayDateAs(String displayFormat, long displayDate){        
    //Default Display Format
    if("".equals(displayFormat)){
        displayFormat = "dd/MM/yyyy HH:mm:ss";
    }    
    SimpleDateFormat sdf =new SimpleDateFormat(displayFormat,Locale.US);
    return sdf.format(displayDate);   
}

/* To render the Page Report Table */
public String drawChildTree (Page rootPage, long tm_cutdate, HttpServletRequest request){
    StringBuffer outBuffer = new StringBuffer("");
   
   
    if (rootPage != null) {
        // code to retirieve the child pages of the selected page in the itertor object
        Iterator<Page> children = rootPage.listChildren();       
        try {
            while (children.hasNext()) {
                Page child = children.next();   
                            
                String lastReplicationAction = child.getProperties().get("cq:lastReplicationAction",String.class);      
                String lastReplicated = child.getProperties().get("cq:lastReplicated",String.class);
                String contentAuthor = "";
                String contentAuthorEmail = "";
                String siteOwnerEmail = "";
                String siteOwner="";
                String pageURL ="";
                String pageTitle = child.getNavigationTitle();
                String tags="";
               //String cugs="";
                
                    contentAuthor = child.getProperties().get("authorName","");
                    contentAuthorEmail = child.getProperties().get("authorEmail","");
                    siteOwner = child.getProperties().get("siteOwnerName","");
                    siteOwnerEmail = child.getProperties().get("siteOwnerEmail","");
                    String[] tag = child.getProperties().get("cq:tags",String[].class);
                    String cugs = getCug(child);
                    if (pageTitle == null || pageTitle.equals("")) {
                        pageTitle = child.getPageTitle();
                    }
                    if (pageTitle == null || pageTitle.equals("")) {
                        pageTitle = child.getTitle();
                    }
                    if (pageTitle == null || pageTitle.equals("")) {
                        pageTitle = child.getName();
                    }
               
                         if(tag!=null && tag.length>0){
                            for(int i=0;i<tag.length;i++){
                                tags += tag[i]; 
                                if(tag.length!=i+1){
                                   tags += ",";
                                }
                            }
                         }
                        /*if(cug!=null && cug.length>0){
                            for(int i=0;i<cug.length;i++){
                                  cugs+=cug[i];
                                if(tag.length!=i+1){
                                   cugs +=","; 
                                }
                            }
                        }*/
                // To get the Domain Address and Date Format for the Page / Site
                ACEManager aceManager = new ACEManager();
                ACEConfigDataBean aceBean = aceManager.getACEConfigBean(aceManager.getACESitePageKey(child.getPath(),true));    
                String domainAdd = aceBean.getPubDomainAdd();
                String dateFormat = aceBean.getDateFormat();
                                
                long tm_lastReplicated = -1L;
                if(child.getProperties().get("cq:lastReplicated",Calendar.class)!=null){
                    Calendar cal_lastReplicated = child.getProperties().get("cq:lastReplicated",Calendar.class);
                    tm_lastReplicated = cal_lastReplicated.getTimeInMillis();
                    lastReplicated = displayDateAs(dateFormat,tm_lastReplicated);
                }
                if("Activate".equals(lastReplicationAction)){
                   
                                                                        
                    String pathtoinclude=child.getPath();                        
                    pathtoinclude = pathtoinclude.replace("/content/","/");
                    
                        outBuffer.append("<tr>");
                        outBuffer.append("<td>" + ++count +"</td>");
                        outBuffer.append("<td>"+ pageTitle +"</td>");
                        if(!("".equals(domainAdd))){
                            pageURL = domainAdd + pathtoinclude + ".html";
                            outBuffer.append("<td style=\"white-space:normal\"><a href='"+ pageURL +"'>"+ pageURL +"</a></td>");                            
                        }else{
                            outBuffer.append("<td style=\"white-space:normal\">"+ pathtoinclude +"</td>");
                        }
                        outBuffer.append("<td>"+ tags+"</td>");
                        outBuffer.append("<td>"+ cugs+"</td>");
                        outBuffer.append("<td>"+ contentAuthor+"</td>");
                        outBuffer.append("<td class='nowrap' width='10%'>"+contentAuthorEmail+ "</td>");
                        outBuffer.append("<td>"+ siteOwner+"</td>");
                        outBuffer.append("<td class='nowrap' width='10%'>"+siteOwnerEmail+ "</td>");
                        outBuffer.append("<td class='nowrap'>"+lastReplicated+ "</td>");                    
                        outBuffer.append("</tr>"); 
                  
                }
                
                outBuffer.append(drawChildTree(child,tm_cutdate,request));
            }
        } finally {         
             
        }
    }
    // return the html code as string //
    return outBuffer.toString();
}


public String getCug(Page rootPage)
{
String parentProps = "";
boolean pageResult = rootPage.getProperties().containsKey("cq:cugPrincipals");
if(pageResult)
{
       String[] parentProp= rootPage.getProperties().get("cq:cugPrincipals",String[].class);
       for(int i=0;i<parentProp.length;i++){
       
            parentProps+= parentProp[i];
            if(parentProp.length!=i+1){
                   parentProps += ",";
                   
                }
       }      
}else{

parentProps+=getCug(rootPage.getParent());}
return parentProps;
}

%>



 <%   
        
    String rootPath = (String) request.getParameter("rootPath");
    if( (!(rootPath != null)) || (!(rootPath.length() > 0)) ){
            rootPath = "";
    }
    
     String textValue = "";
    if(null != request.getParameter("textValue")){
        textValue = request.getParameter("textValue");
    }
    
    
                    
    count=0;
    Calendar cal_lastcutdate = Calendar.getInstance();
    long tm_lastcutdate = cal_lastcutdate.getTimeInMillis();
    String lastcutdate = displayDateAs("MM.dd.yyyy HH:mm:ss",tm_lastcutdate);
    if(textValue.startsWith("/content/accessmcd"))
    {
         Page rootPage = slingRequest.getResourceResolver().adaptTo(PageManager.class).getPage(textValue);
         response.setHeader("Content-Disposition", "attachment; filename=\"AccessMCD-ContentInventoryReport.xls\"");
          
         %>
         <table class="pagetable" width="100%" cellpadding="0" cellspacing="1" border="1">
            <tr>
       
               <th>S. No</th>
                <th>Page Title</th>
                <th>Page URL</th>
                <th>Tag/Keywords</th>
                <th>CUG</>
                <th>Author Name</th>
                <th>Author Name Email</th>
                <th>Site Owner Name</th>
                <th>Site Owner Email</th>             
                <th>Last Activated Date</th>
        
        <%
                
                out.println(drawChildTree(rootPage,tm_lastcutdate,request));
            }
        %>
            </tr>
        </table> 
