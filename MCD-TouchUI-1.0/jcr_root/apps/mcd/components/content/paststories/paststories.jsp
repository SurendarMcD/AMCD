<%--
 
  Everything component        
  
  Combines the text and the image component with various aligment and styling options

--%><%@ page import="com.day.cq.wcm.foundation.Image,
    com.day.cq.wcm.foundation.TextFormat, 
    com.day.cq.wcm.foundation.DiffInfo,
    com.day.cq.wcm.foundation.DiffService,
    org.apache.commons.lang.StringEscapeUtils,
    com.day.cq.wcm.api.components.DropTarget,
    com.day.cq.wcm.api.WCMMode,
    org.apache.sling.api.resource.ResourceUtil,
    org.apache.sling.api.resource.ValueMap,
    com.day.image.Layer,
    com.day.cq.wcm.foundation.Download,
    com.day.text.Text,
    java.util.Random,
    java.util.Iterator,java.text.DateFormat,
    java.text.SimpleDateFormat,
    java.util.Date,
    java.text.ParseException,
    java.util.Set, java.util.TreeMap,java.util.ArrayList,java.util.Calendar,java.util.Collections" %><%
%>
<%@include file="/apps/mcd/global/global.jsp"%>
  

<%        
    String pageTitle = "";
    String pageDescription = "";
    String featureDate = "";
    Image featureImage = null;
    int resultCount=0;  
    int tableCount=0;
    String pastStoriesLink = properties.get("pastStoriesLink","");
    int results = Integer.parseInt(properties.get("results","10"));
    int pageRow = 1;
    String hidePSImages = properties.get("hidePSImage","no");
    String hideTitleDate = properties.get("hideDateTitle","no");
    if(!"".equals(pastStoriesLink)){ 
        Page pastStories = pageManager.getPage(pastStoriesLink);
        if(pastStories!=null){            
            Date articleDate=new Date();
            DateFormat dateConvert=new SimpleDateFormat("MM/dd/yy");
            DateFormat dateConvert1=new SimpleDateFormat("yy/MM/dd");
            DateFormat titleDateFormat= new SimpleDateFormat("MM.dd.yyyy");
            DateFormat titleDateFormat1= new SimpleDateFormat("yyyy.MM.dd");
            DateFormat descDateFormat = new SimpleDateFormat("MM.dd.yy");
            ArrayList<Page> storyChild=new ArrayList<Page>();
            TreeMap<Date, ArrayList> storyMapChild=new TreeMap<Date, ArrayList>();
            Iterator<Page> pastStoriesChildren = pastStories.listChildren();             
          
           /*   For Page Implementation */
            ArrayList pagesList = new ArrayList();
         //   ArrayList pages = new ArrayList();  
            while(pastStoriesChildren.hasNext()) {
                Page child=pastStoriesChildren.next();
                featureDate=child.getProperties().get("featurePublishDate","");
                if(!"".equals(featureDate)){
                    String listValue = titleDateFormat1.format(dateConvert.parse(featureDate))+"|"+child.getPath();
                    pagesList.add(listValue);
                }
            }
              
            Collections.sort(pagesList);
            Collections.reverse(pagesList);
            
            
            if(pagesList.size()>0){
            //out.println("size "+storyChild.size());
            for(int j=resultCount;j<pagesList.size();j++){                                
                
                String pagePath = pagesList.get(j).toString().substring(pagesList.get(j).toString().indexOf("|")+1);
                Page storyPage = pageManager.getPage(pagePath);
                pageTitle = storyPage.getProperties().get("featureImageTitle","");
                pageDescription = storyPage.getProperties().get("featureImageText",""); 
                featureDate = storyPage.getProperties().get("featurePublishDate","");                
                try {
                    articleDate= (Date)dateConvert.parse(featureDate);
                }
                catch (ParseException e) {                
                    log.error("Error: "+e);
                } 
                
                String titleDateString= titleDateFormat.format(articleDate);
                String descDateString= descDateFormat.format(articleDate);  
                featureImage = new Image(storyPage.getContentResource(),"featureImage");//get the navigation image for child page
                if(featureImage.hasContent()){
                    featureImage.loadStyleData(currentStyle);
                    featureImage.setSelector(".img"); // use image script
                    
                    // add design information if not default (i.e. for reference paras)
                    if (!currentDesign.equals(resourceDesign)) {
                        featureImage.setSuffix(currentDesign.getId());
                    }
                    
                    //out.println("Image Href :: " + featureImage.getHref()+ "<br>");
                    
                }
            if((resultCount==0)||(resultCount%results==0)){
%>
            <table id="table_<%=tableCount%>" cellspacing="0" cellpadding="0" border="0" width="100%" valign="top">
                <tr>
                    <td width="100%">
                        <table cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr> 
<%                          
            }
            if(pageRow%2==0){              
%>                           
                                <td width="2%" valign="top"></td>   
<%
            }
%> 
                <td width="49%" valign="top">   
                    <!--pastfeaturedstorystart-->    
                    <table cellspacing="0" border="0" cellpadding="0" align="left" width="100%" valign="top">      
                        <tr>
<%
                            if("no".equals(hidePSImages)){  
%>                            
                            <td width="25%" valign="top">
                                <table height="72px" valign="top" border="0">              
                                    <tr height="72px">
                                        <td valign="top">
                                            <!--featuredstorythumbnailstart--> 
                                            <a style="text-decoration: none;padding-bottom:10px;" href="<%=storyPage.getPath()%>.html"><%if(featureImage.getHref() != null){%><img height="75px" border="0" width="75px" alt="Click to see full story." src="<%=featureImage.getHref()%>"><%}%></a>       
                                            <!--featuredstorythumbnailstop--> 
                                        </td>
                                    </tr>
                                </table>
                            </td> 
<%
                            }
%>                            
                            <td width="15%" valign="top">
                                <table valign="top" border="0">
                                    <tr>
                                        <td valign="top" class="FStext">
                                            <%=titleDateString%>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td width="60%" valign="top">
                                <table valign="top" border="0">
                                    <tr>
                                        <td valign="top">
<%
                                            if("no".equals(hideTitleDate)){  
%>                                        
                                            <a href="<%=storyPage.getPath()%>.html" style="text-decoration: none;"> 
                                                <font class="FStextRed"><%=descDateString%> - <%=pageTitle%></font>
                                            </a>
<%
                                            }
                                            else{
%>                                           
                                            <a href="<%=storyPage.getPath()%>.html" style="text-decoration: none;"> 
                                                <font class="FStextBlue"><%=pageTitle%></font>
                                            </a>  
<%
                                            }
%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top" class="FStext">
                                            <%=pageDescription%>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <!--pastfeaturedstorystop--> 
                </td>
<%                
                if(pageRow%2==0){
%>
                    </tr><tr>
<%
                }
                pageRow++;
                resultCount++;
                if(resultCount%results==0){                
%>
                </tr>
            <tr height="10">
                <td colspan="2"></td>
            </tr>
     </table>
     </td>
     </tr>
     </table>    
<%                
                tableCount++;
                }               
            }        
%>                                             
</tr>
        <tr height="10">
            <td colspan="2"></td>
        </tr>
 </table>
    </td>
    </tr>
    </table>
<%            
       } 
       else{
%>
       <b><%=langText.get("PAST_STORIES_NO_RESULT")%></b>
<%       
       }
   }   
%>
    <table id="btn" width="100%">
        <tr>
            <td colspan="1" align="left">
                <!-- Prev link for pagination -->        
                <input type="button" id="pre" style="display:none;" name="pre" class="FSbutton" value="< Previous Stories" />        
            </td>
            <td colspan="1" align="right">    
            <!-- Next link for pagination -->      
                <input type="button" style="display:none;" id="next" name="next" class="FSbutton" value="More Stories >" />                  
            </td> 
         </tr> 
    </table>
<%                     
    }
    else{
%>    
        <b><%=langText.get("CONFIGURE_COMPONENT_MSG","","Past Stories")%></b> 
<%        
    }
%>         
<script type="text/javascript">

var tableIdFlag=parseInt("0");
var traverseBack=parseInt("0");
var traverseNext=tableIdFlag+1;

$('[id^="table_"]').css('display','none');

$(document).ready(function(){
    $('[id^="table_"]').css('display','none');
    $('#table_0').css('display','block'); 
    if($("#table_1").attr('id')){
        $("#next").css('display','block');
    }   
    $("#pre").css('display','none');    
    
});

$("#next").click(function(){    
    pastStoriesNext(tableIdFlag, traverseNext, traverseBack);
    tableIdFlag++;      
    traverseNext++;
    traverseBack++;     
});
$("#pre").click(function(){
    pastStoriesPrev(tableIdFlag, traverseNext, traverseBack);
    traverseBack--;
    tableIdFlag--;
    traverseNext--;    
});
</script>
 