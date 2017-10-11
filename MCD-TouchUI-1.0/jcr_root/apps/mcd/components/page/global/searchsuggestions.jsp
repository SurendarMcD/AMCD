<%-- ########################################### 
     # DESCRIPTION: returns search suggestions from search suggestion components on page
     # 
     # Author: Erik Wannebo
     # 
     # 
     # UPDATE HISTORY       
     # 1.0  Erik Wannebo, 08/15/2013,Initial version 
     # 
     ############################################## --%>
<%@ page language = "java" %><%@ page contentType = "application/json" %>
<%@page session="false" import="org.slf4j.Logger,
    com.day.cq.wcm.foundation.Paragraph,
    com.day.cq.wcm.foundation.ParagraphSystem,
    java.util.ArrayList,
    java.util.Iterator,
    com.day.cq.wcm.api.PageFilter,
    com.day.crx.*,
    javax.jcr.*,
    java.util.*,
    java.net.*,
    com.day.cq.wcm.api.*"%>
<%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects/>
[

<%

HttpServletRequest cqReq = (HttpServletRequest) request;
String localizedSearches="Searches";
String localizedSites="Sites";
String requestURI = cqReq.getRequestURI();
String suggestionGlobPart = requestURI.substring(requestURI.lastIndexOf("/")+1);
if(requestURI.indexOf("mcweb/fr")>-1){
    localizedSearches="Recherches";
    localizedSites="Sites";
}
String globs[] = suggestionGlobPart .split("\\.");
String search="";
String role="";
if(globs.length>2){
    search=globs[globs.length-2];
    role=globs[globs.length-3];
}
//log.error("search suggestions search:"+search);
search = URLDecoder.decode(search,"UTF-8");
//log.error("search suggestions decodedSearch :"+decodedSearch );
resource=slingRequest.getResourceResolver().getResource(resource.getPath()+"/maincontentpara") ;
int count=0;
ParagraphSystem parSys = new ParagraphSystem(resource);
TreeMap<String, String> searchlist=new TreeMap();

for (Paragraph par: parSys.paragraphs()) {
    
    String nodeName =   par.getPath().substring(par.getPath().lastIndexOf("/")+1);
    if(nodeName.startsWith("searchsuggestion")){
    
        Node suggestNode = slingRequest.getResourceResolver().getResource(par.getPath()).adaptTo(Node.class);
        
        if(!suggestNode.hasProperty("suggestion"))continue;
        
        boolean bMatchesRole=true;
        
        if(suggestNode.hasProperty("audience")){
                try{
                    Value[] audience= suggestNode.getProperty("audience").getValues();
                    String strAudience="";
                    
                    if(audience!=null){
                        for(int i=0;i<audience.length;i++){
                            String suggestionRole=audience[i].getString();
                            if(role.equals(suggestionRole)){
                                bMatchesRole=true;
                                break;
                            }    
                            bMatchesRole=false;
                        }
                    }
                }catch(ValueFormatException vfe){
                    Value audience= suggestNode.getProperty("audience").getValue();
                    String strAudience="";
                    
                    if(audience!=null){
                        String suggestionRole=audience.getString();
                        if(!role.equals(suggestionRole)){
                            bMatchesRole=false;
                        }    
                    }
                }
        }
        if(!bMatchesRole)continue;//skip to next suggestion
    
        String sitelink= "";
        String pipedKeywords="|";
        String sitelinkurl="";
        String category="";
        boolean bFound=false;
        String suggestion= suggestNode.getProperty("suggestion").getValue().getString();
        
        
        if(suggestNode.hasProperty("sitelink")){
            sitelink=suggestNode.getProperty("sitelink").getValue().getString();
            if(suggestNode.hasProperty("newWindow") && suggestNode.getProperty("newWindow").getValue().getBoolean()){
               sitelink="newwin"+sitelink;
            }
        }
        if(!sitelink.equals("")){
            /*********** SITE ************/
            sitelinkurl=sitelink;
            category=localizedSites;
            if(sitelink.startsWith("/content/")){
                if(!sitelink.endsWith(".html")){
                    sitelinkurl+=".html";
                }
            }
            
            bFound=false;
            if(suggestNode.hasProperty("keywords")){
                 Property propKeywords=suggestNode.getProperty("keywords");
                 if(propKeywords!=null){
                     try{
                        Value[] keywords= propKeywords.getValues();
                        if(keywords!=null){
                            for(int i=0;i<keywords.length;i++){
                                String keyword=keywords[i].getString().toLowerCase();
                                if(keyword.startsWith(search)){
                                    bFound=true;
                                    pipedKeywords+=keyword+"|";
                                    searchlist.put(keyword,"1");
                                }
                            }
                         }
                     }catch(ValueFormatException vfe){
                        Value keywords= propKeywords.getValue();
                        String keyword=keywords.getString().toLowerCase();
                        if(keyword.startsWith(search)){
                            bFound=true;
                            pipedKeywords+=keyword+"|";
                            searchlist.put(keyword,"1");
                        }
                     }
                 }
            }
            


            
            
        }else{
            /*********** SEARCH************/
            //category="Searches";
            //pipedKeywords+=suggestion+"|";
            searchlist.put(suggestion,"1");
        
        }
        
        
        if(bFound){
%>
<%=(count>0)?",":""%>{label: "<%=suggestion %>",value: "<%=sitelinkurl%>",keywords: "<%=pipedKeywords%>",category: "<%=category%>"}
<%
        count++;
        }
        
    }
}


for(Map.Entry<String, String> entry : searchlist.entrySet()){

%>
<%=(count>0)?",":""%>{label: "<%=entry.getKey() %>",keywords: "|<%=entry.getKey() %>|",category: "<%=localizedSearches %>"}
<%
}
%>
]