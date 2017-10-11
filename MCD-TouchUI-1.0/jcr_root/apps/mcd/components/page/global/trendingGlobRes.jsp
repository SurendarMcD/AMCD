<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page import="com.day.cq.security.User,com.day.cq.wcm.api.WCMMode,com.mcd.accessmcd.util.CommonUtil,java.util.*"%>
<%@page import="javax.servlet.jsp.JspWriter"%>
<%@page import="org.slf4j.Logger"%>
<%@page import="org.slf4j.LoggerFactory"%>
<cq:includeClientLib categories="trendingRes"/>
<%
    response.setHeader("Cache-Control","no-cache");
    response.setHeader("Cache-Control","no-store");
    response.setDateHeader("Expires", 0);
    response.setHeader("Pragma","no-cache"); 
    
    CommonUtil commonUtil = new CommonUtil();
    int flag = 0;
    String trendingNodePath = "";
    String heading = "";
    String headingImage = "";
    String textColor = "";
    String hoverColor = ""; 
    String displayType = "horizontal";
    String currentPagePath = currentPage.getPath();
    ArrayList pathList = new ArrayList();
    ArrayList tempList = new ArrayList(); 
       
    final User user = slingRequest.getResourceResolver().adaptTo(User.class); 
    String mcdAudience = "CorpEmployees ";
    mcdAudience =(String)user.getProperty("rep:mcdAudience");
    if(mcdAudience == null || mcdAudience.equals("")){
        mcdAudience = "CorpEmployees" ; 
    }

    Node currentPageNode = resourceResolver.getResource(currentPagePath+"/jcr:content").adaptTo(Node.class); 
    pathList = getChildNode(currentPageNode,log,out,currentNode,tempList);
    if(pathList.size() > 0){
        trendingNodePath  = pathList.get(0).toString();
    }
    //out.println("Trending Node Path :: " + trendingNodePath + "<br>");
    
    Node trendingNode = resourceResolver.getResource(trendingNodePath).adaptTo(Node.class); 
    
    if(trendingNode.hasProperty("displayOption")){
        displayType = trendingNode.getProperty("displayOption").getString();
    }
    
    if(trendingNode.hasProperty("heading")){
        heading = trendingNode.getProperty("heading").getString();
    }
    if(trendingNode.hasProperty("headingImage")){
        headingImage = trendingNode.getProperty("headingImage").getString();
    }
    if(trendingNode.hasProperty("textColor")){
        textColor = trendingNode.getProperty("textColor").getString();
    }
    
    if(trendingNode.hasProperty("hoverColor")){   
        hoverColor = trendingNode.getProperty("hoverColor").getString();   
    }
    
    if(trendingNode.hasProperty("trendingItem")){
        Property trendingData = trendingNode.getProperty("trendingItem");
        try{
            Value[] value = trendingData.getValues();
            
            if(value.length>0){    
                if(displayType.equals("textcloud")){
%>
                    <div id="tagbox">
<%                
                        if(heading.trim().length() > 0){        
%>        
                            <div class="mid-section">
                                <div class="">
                                    <aside class="progress-section" style="margin-top:0px;">
                                        <h4 class="text-uppercase" style="background:transparent url('<%=headingImage%>') no-repeat 0 0"><%=heading%></h4>
                                    </aside>
                                </div>                
                            </div>      
<%
                        }
%>          
                                <ul class="<%=textColor%> tagcloud">
<%                                
                                    for(int i=0;i<value.length;i++){        
                                        String[] trendingItem = value[i].getString().split("\\|");
                                        String keyword = trendingItem[0];
                                        String fontSize = trendingItem[1];
                                        String link = trendingItem[2];
                                        String groups = trendingItem[3];
                                        String newWindow = trendingItem[4];
                                        String target = "_self";
                                    
                                        if(newWindow.equals("true")){
                                            target = "_blank";
                                        }
                                        else{
                                            target = "_self";
                                        }
                                        if(groups != null && !groups.equals("")){
                                            
                                            if(groups.contains(mcdAudience)){
                                                if(link.startsWith("/content/accessmcd")){
                                                    Node pageNode = slingRequest.getResourceResolver().getResource(link + "/jcr:content").adaptTo(Node.class);
                                                    if((WCMMode.fromRequest(request)==WCMMode.DISABLED)||pageNode.hasProperty("cq:lastReplicationAction")){
                                                        String pageStatus = pageNode.getProperty("cq:lastReplicationAction").getString();
                                                        if((WCMMode.fromRequest(request)==WCMMode.DISABLED )||pageStatus.equals("Activate")){
%>                        
                                                            <li id="<%=hoverColor%>" class="tag<%=fontSize%>" title="<%=keyword%>">
                                                            <a href="<%=commonUtil.getValidURL(link)%>" target="<%=target%>" ><%if(keyword.length()>19){%>
                                                                <%=keyword.substring(0,16).trim()%>...<%
                                                            }
                                                            else{%>                        
                                                                <%=keyword%><%  
                                                            }%>                                                         
                                                            </a>
                                                            </li>                              
<%                             
                                                        }
                                                    }
                                                }
                                                else{
%>
                                                    <li id="<%=hoverColor%>" class="tag<%=fontSize%>" title="<%=keyword%>">
                                                        <a href="<%=commonUtil.getValidURL(link)%>" target="<%=target%>" ><%=keyword%></a>
                                                    </li>                                                  
<%                                            
                                                }
                                            }
                                        }          
                                    }
%>
                                </ul>
                    </div>
<%
                }        
            }
        }
        catch(ValueFormatException e){
            String trending = trendingNode.getProperty("trendingItem").getString();
            String[] trendingItem = trending.split("\\|");
            String keyword = trendingItem[0];
            String fontSize = trendingItem[1];
            String link = trendingItem[2];
            String groups = trendingItem[3];
            String newWindow = trendingItem[4];
            String target = "_self";
            
            if(newWindow.equals("true")){
                target = "_blank";    
            }
            else{
                target = "_self";
            }
            
            if(displayType.equals("textcloud")){
                %>
                <div id="tagbox">
                <%                
                if(heading.trim().length() > 0){        
                %>        
                    <div class="mid-section">
                        <div class="">
                            <aside class="progress-section" style="margin-top:0px;">
                                <h4 class="text-uppercase" style="background:transparent url('<%=headingImage%>') no-repeat 0 0"><%=heading%></h4>
                            </aside>
                        </div>                
                    </div>`
                <%
                }
                %>          
                    <ul class="<%=textColor%> tagcloud">
                <%
                    if(groups != null && !groups.equals("")){
                        if(groups.contains(mcdAudience)){
                            if(link.startsWith("/content/accessmcd")){
                                Node pageNode = slingRequest.getResourceResolver().getResource(link + "/jcr:content").adaptTo(Node.class);
                                if((WCMMode.fromRequest(request)==WCMMode.DISABLED)||pageNode.hasProperty("cq:lastReplicationAction")){
                                    String pageStatus = pageNode.getProperty("cq:lastReplicationAction").getString();
                                    if((WCMMode.fromRequest(request)==WCMMode.DISABLED )||pageStatus.equals("Activate")){
%>                        
                                        <li id="<%=hoverColor%>" class="tag<%=fontSize%>" title="<%=keyword%>">
                                        <a href="<%=commonUtil.getValidURL(link)%>" target="<%=target%>" ><%if(keyword.length()>19){%>
                                            <%=keyword.substring(0,16).trim()%>...<%
                                        }
                                        else{%>                        
                                            <%=keyword%><%  
                                        }%>                                                         
                                        </a>
                                        </li>                              
<%                             
                                        }
                                    }
                                }
                                else{
%>
                                <li id="<%=hoverColor%>" class="tag<%=fontSize%>" title="<%=keyword%>">
                                    <a href="<%=commonUtil.getValidURL(link)%>" target="<%=target%>" ><%=keyword%></a>
                                </li>  
<%                            
                            }
                        }
                    }  
%>                    
                    </ul>
                    </div>
<%                                         
            }         
        }
    }
%>

<%!
    public ArrayList getChildNode(Node currentPageNode,Logger log,JspWriter out,Node currentNode,ArrayList tempList){
            try{
                NodeIterator chNodeItr = currentPageNode.getNodes();
                while(chNodeItr.hasNext()){
                    Node chNode = chNodeItr.nextNode();
                    if(chNode.getName().equals("trendingresponsive") && (!chNode.getPath().equals(currentNode.getPath()))){            
                        String trendingNodePath = chNode.getPath();
                        tempList.add(trendingNodePath);
                        log.error("***** Trending Path First ***** " + trendingNodePath );
                    }
                    if(chNode.hasNodes()){
                        getChildNode(chNode,log,out,currentNode,tempList); 
                    }
                    
                } 
             }catch(Exception ex){
                 log.error("Exception In Reverse Loop");
             }
             return tempList;
    }

    
%>