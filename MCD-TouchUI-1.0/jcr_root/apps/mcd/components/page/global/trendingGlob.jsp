<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page import="com.day.cq.security.User,com.mcd.accessmcd.util.CommonUtil"%>
<cq:includeClientLib categories="trending"/>
<%
    response.setHeader("Cache-Control","no-cache");
    response.setHeader("Cache-Control","no-store");
    response.setDateHeader("Expires", 0);
    response.setHeader("Pragma","no-cache"); 
    
    CommonUtil commonUtil = new CommonUtil();
    int flag = 0;
    String trendingNodePath = "";
    String heading = "";
    String textColor = "";
    String hoverColor = ""; 
    String displayType = "horizontal";
    String currentPagePath = currentPage.getPath();
    
    
    final User user = slingRequest.getResourceResolver().adaptTo(User.class); 
    String mcdAudience = "CorpEmployees ";
    mcdAudience =(String)user.getProperty("rep:mcdAudience");
    if(mcdAudience == null || mcdAudience.equals("")){
        mcdAudience = "CorpEmployees" ; 
    }
    
    Node currentPageNode = resourceResolver.getResource(currentPagePath+"/jcr:content").adaptTo(Node.class); 
    
    NodeIterator nodeIterator = currentPageNode.getNodes(); 
    while(nodeIterator.hasNext()){
        Node childNode = nodeIterator.nextNode();
        if(childNode.hasNodes()){
            NodeIterator childNodeIterator = childNode.getNodes();
            while(childNodeIterator.hasNext()){
                Node subChildNode = childNodeIterator.nextNode();                
                if(subChildNode.getName().equals("trending") && (!subChildNode.getPath().equals(currentNode.getPath()))){            
                    flag = 1;                       
                    trendingNodePath = subChildNode.getPath();
                }
            }        
            if(flag == 1){
                break;
            }
        }        
    }
    
    
    Node trendingNode = resourceResolver.getResource(trendingNodePath).adaptTo(Node.class); 
    
    if(trendingNode.hasProperty("displayOption")){
        displayType = trendingNode.getProperty("displayOption").getString();
    }
    
    if(trendingNode.hasProperty("heading")){
        heading = trendingNode.getProperty("heading").getString();
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
                            <div class="tagHdBlack"><div class="tagHeading"><%= heading%></div></div>      
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
                                                    if(pageNode.hasProperty("cq:lastReplicationAction")){
                                                        String pageStatus = pageNode.getProperty("cq:lastReplicationAction").getString();
                                                        if(pageStatus.equals("Activate")){
%>                        
                                                            <li id="<%=hoverColor%>" class="tag<%=fontSize%>" title="<%=keyword%>">
                                                            <a href="<%=commonUtil.getValidURL(link)%>" target="<%=target%>" > 
<%                                
                                                            if(keyword.length()>19){
%>
                                                                <%=keyword.substring(0,16).trim()%>...
<%                            
                                                            }
                                                            else{
%>                        
                                                                <%=keyword%>                          
<%  
                                                            }                                 
%>                                                         
                                                            </a>
                                                            </li>                              
<%                             
                                                        }
                                                    }
                                                }
                                                else{
%>
                                                    <li id="<%=hoverColor%>" class="tag<%=fontSize%>" title="<%=keyword%>">
                                                        <a href="<%=commonUtil.getValidURL(link)%>" target="<%=target%>" >
                                                            <%=keyword%>   
                                                        </a>
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
                else if(displayType.equals("horizontal")){                              
                    if(heading.trim().equals("")){
                        heading = "TRENDING";
                    }         
%>    
                    <div class="trendingData">                      
                        <div class="float_left">
                            <ul class="<%=textColor%> list_item" id="flexiselDemo1">
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
                                                if(pageNode.hasProperty("cq:lastReplicationAction")){
                                                    String pageStatus = pageNode.getProperty("cq:lastReplicationAction").getString();
                                                    if(pageStatus.equals("Activate")){
%>                        
                                                        <li id="<%=hoverColor%>" class="tag<%=fontSize%>" title="<%=keyword%>">
                                                        <a href="<%=commonUtil.getValidURL(link)%>" target="<%=target%>" > 
<%                                
                                                        if(keyword.length()>19){
%>
                                                            <%=keyword.substring(0,16).trim()%>...
<%                            
                                                        }
                                                        else{
%>                        
                                                            <%=keyword%>                          
<%  
                                                        }                                 
%>                                                         
                                                        </a>
                                                        </li>                              
<%                             
                                                    }
                                                }
                                            }
                                            else{
%>
                                                <li id="<%=hoverColor%>" class="tag<%=fontSize%>" title="<%=keyword%>">
                                                    <a href="<%=commonUtil.getValidURL(link)%>" target="<%=target%>" >
                                                        <%=keyword%>   
                                                    </a>
                                                </li>                                                  
<%                                            
                                            
                                            }
                                        }
                                    }          
                                }
%>
                                    </ul>
                        </div>
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
                    <div class="tagHdBlack"><div class="tagHeading"><%= heading%></div></div>      
                <%
                }
                %>          
                    <ul class="<%=textColor%> tagcloud">
                <%
                    if(groups != null && !groups.equals("")){
                        if(groups.contains(mcdAudience)){
                            if(link.startsWith("/content/accessmcd")){
                                Node pageNode = slingRequest.getResourceResolver().getResource(link + "/jcr:content").adaptTo(Node.class);
                                if(pageNode.hasProperty("cq:lastReplicationAction")){
                                    String pageStatus = pageNode.getProperty("cq:lastReplicationAction").getString();
                                    if(pageStatus.equals("Activate")){
%>                        
                                        <li id="<%=hoverColor%>" class="tag<%=fontSize%>" title="<%=keyword%>">
                                        <a href="<%=commonUtil.getValidURL(link)%>" target="<%=target%>" > 
<%                                
                                        if(keyword.length()>19){
%>
                                            <%=keyword.substring(0,16).trim()%>...
<%                            
                                        }
                                        else{
%>                        
                                            <%=keyword%>                          
<%  
                                        }                                 
%>                                                         
                                        </a>
                                        </li>                              
<%                             
                                    }
                                }
                            }
                            else{
%>
                                <li id="<%=hoverColor%>" class="tag<%=fontSize%>" title="<%=keyword%>">
                                    <a href="<%=commonUtil.getValidURL(link)%>" target="<%=target%>" >
                                        <%=keyword%>   
                                    </a>
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
            else if(displayType.equals("horizontal")){                              
                if(heading.trim().equals("")){
                    heading = "TRENDING";
                }                     
                %>    
                <div class="trendingData">                
                <div class="float_left">
                <ul class="<%=textColor%> list_item" id="flexiselDemo1">
                <%
                if(groups != null && !groups.equals("")){
                if(groups.contains(mcdAudience)){
                    if(link.startsWith("/content/accessmcd")){
                        Node pageNode = slingRequest.getResourceResolver().getResource(link + "/jcr:content").adaptTo(Node.class);
                        if(pageNode.hasProperty("cq:lastReplicationAction")){
                            String pageStatus = pageNode.getProperty("cq:lastReplicationAction").getString();
                            if(pageStatus.equals("Activate")){
%>                        
                                <li id="<%=hoverColor%>" class="tag<%=fontSize%>" title="<%=keyword%>">
                                <a href="<%=commonUtil.getValidURL(link)%>" target="<%=target%>" > 
<%                                
                                if(keyword.length()>19){
%>
                                    <%=keyword.substring(0,16).trim()%>...
<%                            
                                }
                                else{
%>                        
                                    <%=keyword%>                          
<%  
                                }                                 
%>                                                         
                                </a>
                                </li>                              
<%                             
                            }
                        }
                    }
                    else{
%>
                        <li id="<%=hoverColor%>" class="tag<%=fontSize%>" title="<%=keyword%>">
                            <a href="<%=commonUtil.getValidURL(link)%>" target="<%=target%>" >
                                <%=keyword%>   
                            </a>
                        </li> 
<%                    
                    }
                }
            }
%>    
            </ul>
            </div>
            </div>
<%
            }  
        }
    }
%>