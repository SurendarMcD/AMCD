<%-- ########################################### 
     # DESCRIPTION: returns XML document of all search suggestions from search suggestion components on page
     # used by Search Application to populate Quick Links on Search Results page
     # 
     # Author: Erik Wannebo
     # 
     # 
     # UPDATE HISTORY       
     # 1.0  Erik Wannebo, 08/15/2013,Initial version 
     # 
     ############################################## --%>
<%@ page language = "java" %><%@ page contentType = "xml" %>
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
    javax.xml.parsers.*,
    org.w3c.dom.*,
    java.io.StringWriter,
    javax.xml.transform.*,
    javax.xml.transform.dom.*,
    javax.xml.transform.stream.*,
    com.day.cq.wcm.api.*"%>
<%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects/>

<%



HttpServletRequest cqReq = (HttpServletRequest) request;

resource=slingRequest.getResourceResolver().getResource(resource.getPath()+"/maincontentpara") ;
int count=0;
ParagraphSystem parSys = new ParagraphSystem(resource);


DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

// root elements
Document document = docBuilder.newDocument();
Element root= document.createElement("root");
document.appendChild(root);
Element suggestionEl=null;
String xmlString="";
     

for (Paragraph par: parSys.paragraphs()) {
    
    String nodeName =   par.getPath().substring(par.getPath().lastIndexOf("/")+1);
    if(nodeName.startsWith("searchsuggestion")){
    
       javax.jcr.Node suggestNode = slingRequest.getResourceResolver().getResource(par.getPath()).adaptTo(javax.jcr.Node.class);
       
       if(!suggestNode.hasProperty("suggestion"))continue;
       
        if(suggestNode.hasProperty("audience")){
                try{
                    Value[] audience= suggestNode.getProperty("audience").getValues();
                    String strAudience="";
                    
                }catch(ValueFormatException vfe){
                    Value audience= suggestNode.getProperty("audience").getValue();
                    String strAudience="";

                }
        }

    
        String sitelink= "";
        String pipedKeywords="|";
        String pipedAudience="|";
        String sitelinkurl="";
        String summary="";
        String category="";
        boolean bFound=false;
        String suggestion= suggestNode.getProperty("suggestion").getValue().getString();
        
        
        if(suggestNode.hasProperty("sitelink"))
            sitelink=suggestNode.getProperty("sitelink").getValue().getString();
        
        if(!sitelink.equals("")){
            
            suggestionEl= document.createElement( "suggestion" );
            
            Element titleEl=document.createElement("title");
            titleEl.appendChild(document.createTextNode(suggestion));
            suggestionEl.appendChild(titleEl);
            sitelinkurl=sitelink;
            category="Sites";
            if(sitelinkurl.startsWith("/content")){
                sitelinkurl=sitelinkurl.substring(8);
                
            }
            if(sitelinkurl.startsWith("/accessmcd/")){
                sitelinkurl="https://www.accessmcd.com"+sitelinkurl;
                if(!sitelinkurl.endsWith(".html")){
                    sitelinkurl+=".html";
                }
            }
            
            
            Element urlEl=document.createElement("url");
            urlEl.appendChild(document.createTextNode(sitelinkurl));
            suggestionEl.appendChild(urlEl);
            
            if(suggestNode.hasProperty("keywords")){
                 Property propKeywords=suggestNode.getProperty("keywords");
                 if(propKeywords!=null){
                     try{
                        Value[] keywords= propKeywords.getValues();
                        if(keywords!=null){
                            for(int i=0;i<keywords.length;i++){
                                String keyword=keywords[i].getString().toLowerCase();
                                pipedKeywords+=keyword+"|";
                            }
                         }
                     }catch(ValueFormatException vfe){
                        Value keywords= propKeywords.getValue();
                        String keyword=keywords.getString().toLowerCase();
                        pipedKeywords+=keyword+"|";
                        
                     }
                 }
                 

                 Element keywordEl=document.createElement("keywords");
                 keywordEl.appendChild(document.createTextNode(pipedKeywords));
                 suggestionEl.appendChild(keywordEl);    
            }  
           
           if(suggestNode.hasProperty("audience")){
                 Property propAudience=suggestNode.getProperty("audience");
                 if(propAudience!=null){
                     try{
                        Value[] auds= propAudience.getValues();
                        if(auds!=null){
                            for(int i=0;i<auds.length;i++){
                                String aud=auds[i].getString();
                                pipedAudience+=aud+"|";
                            }
                         }
                     }catch(ValueFormatException vfe){
                        Value auds= propAudience.getValue();
                        String aud=auds.getString();
                        pipedAudience+=aud+"|";
                        
                     }
                 }
                 
                 Element audEl=document.createElement("audience");
                 audEl.appendChild(document.createTextNode(pipedAudience));
                 suggestionEl.appendChild(audEl); 
            }  
            
            if(suggestNode.hasProperty("summary")){
                summary=suggestNode.getProperty("summary").getValue().getString();
                summary=summary.replaceAll("<p>","").replaceAll("</p>","").replaceAll("\n","<br>");
                
            }
                

            Element summEl=document.createElement("summary");
            summEl.appendChild(document.createTextNode(summary));
            suggestionEl.appendChild(summEl); 
            
            
            if(suggestNode.hasProperty("newWindow") && suggestNode.getProperty("newWindow").getValue().getBoolean()){
               

               Element newWinEl=document.createElement("newWindow");
               newWinEl.appendChild(document.createTextNode("true"));
               suggestionEl.appendChild(newWinEl); 
            }
            
          
          root.appendChild( suggestionEl );
          //TransformerFactory instance is used to create Transformer objects. 
          TransformerFactory factory = TransformerFactory.newInstance();
          Transformer transformer = factory.newTransformer();
        
          transformer.setOutputProperty(OutputKeys.INDENT, "yes");
          transformer.setOutputProperty(OutputKeys.METHOD,"xml");
          // transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "3");
        
        
          // create string from xml tree
          StringWriter sw = new StringWriter();
          StreamResult result = new StreamResult(sw);
          DOMSource source = new DOMSource(document);
          transformer.transform(source, result);
        
          xmlString = sw.toString();
            
            
            

        }
        
        }
        }
     //out.println(new XMLOutputter().outputString(document));
     out.println(xmlString );


%>