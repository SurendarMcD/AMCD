<%/*
Test anonymous access
Erik Wannebo 01/30/2014    
*/
%>
<%@ page import="java.util.Calendar,
        java.text.*,
        java.util.*,
        java.io.*,
        javax.jcr.*,
        com.day.cq.search.*,
        com.day.cq.search.result.*,
        com.day.cq.search.facets.*,
        com.day.cq.search.writer.*,
        org.apache.jackrabbit.util.Text,
        com.day.cq.wcm.foundation.*,
        org.apache.sling.api.resource.*,
        java.sql.*,
        java.net.*,
        javax.sql.DataSource,
        com.day.commons.datasource.poolservice.DataSourcePool,
        org.apache.jackrabbit.commons.JcrUtils,
        org.apache.commons.lang.StringEscapeUtils
        
        "%>
<%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects />
<%!

 public String getSoapResponse(org.apache.sling.jcr.api.SlingRepository repository,String document){
        StringBuffer SOAPMsg=new StringBuffer();
        String newTitle="";
        String newDescription="";
        

        String url=getUrl(document);
        String pagepath=getPath(url);
        
        String abbrevCUGGroup="";
        Session session = null;
        try{
            
            session = repository.loginAdministrative(null);
            String cugGroups=getCUGGroups(pagepath,session); 
            //abbrevCUGGroup=SearchGroup.searchGroup(cugGroups);
            abbrevCUGGroup=cugGroups;
            if(pagepath.startsWith("/content/dam/")){
                newTitle=getDAMField(pagepath,session,"dc:title");
                newDescription=getDAMField(pagepath,session,"dc:description");
                //newTitle="DAM File";
            }
            
           newTitle = StringEscapeUtils.escapeXml(newTitle);  
           newDescription = StringEscapeUtils.escapeXml(newDescription);
             
        }catch(Exception e){
        }finally{
                  session.logout();
                }

        SOAPMsg.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        SOAPMsg.append("<SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:xsi=\"http://www.w3.org/1999/XMLSchema-instance\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd3=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsd=\"http://www.w3.org/1999/XMLSchema\">");
        SOAPMsg.append("<SOAP-ENV:Body>");
        SOAPMsg.append("<ns1:GetHdrDescResp xmlns:ns1=\"http://ultraseek.com/contentassist.wsdl\" SOAP-ENC:root=\"1\">");
        
        SOAPMsg.append("<IndexAsstDesc>");
        
        //SOAPMsg.append("<ArrayOfDocItem SOAP-ENC:arrayType=\"xsd:SOAPStruct[1]\" xsi:type=\"SOAP-ENC:Array\">");
        
        if(!newTitle.equals("")){
            SOAPMsg.append("<title xsi:type=\"xsd:string\">"+newTitle+"</title>");
            SOAPMsg.append("<description xsi:type=\"xsd:string\">"+newDescription+"</description>");
            SOAPMsg.append("<ArrayOfDocItem SOAP-ENC:arrayType=\"xsd:SOAPStruct[3]\" xsi:type=\"SOAP-ENC:Array\">");
            SOAPMsg.append("<xsd:item>");
            SOAPMsg.append("<field xsi:type=\"xsd:string\">title</field>"); 
            SOAPMsg.append("<text xsi:type=\"xsd:string\">"+newTitle+"</text>");  
            SOAPMsg.append("</xsd:item>");
            SOAPMsg.append("<xsd:item>");
            SOAPMsg.append("<field xsi:type=\"xsd:string\">description</field>"); 
            SOAPMsg.append("<text xsi:type=\"xsd:string\">"+newDescription+"</text>");  
            SOAPMsg.append("</xsd:item>");

        }else{
            SOAPMsg.append("<ArrayOfDocItem SOAP-ENC:arrayType=\"xsd:SOAPStruct[1]\" xsi:type=\"SOAP-ENC:Array\">");
        }
        SOAPMsg.append("<xsd:item>");
        SOAPMsg.append("<field xsi:type=\"xsd:string\">groupsType</field>"); 
        SOAPMsg.append("<text xsi:type=\"xsd:string\">"+abbrevCUGGroup+"</text>");  
        SOAPMsg.append("</xsd:item>");
        
        SOAPMsg.append("</ArrayOfDocItem>");
        SOAPMsg.append("</IndexAsstDesc>");
        SOAPMsg.append("</ns1:GetHdrDescResp>");
        SOAPMsg.append("</SOAP-ENV:Body>");
        SOAPMsg.append("</SOAP-ENV:Envelope>");
        return SOAPMsg.toString();
    }
    
    protected String getPath(String url){
        String path="";
        int start=url.indexOf("/accessmcd/");
        if(url.indexOf("/dam/accessmcd")>-1)
            start=url.indexOf("/dam/accessmcd/");
        if(start>-1){
            path="/content"+url.substring(start);
            if(path.indexOf(".html")>-1){
                path=path.substring(0,path.indexOf(".html"));
            }
        }
        return path;
    }
    
    protected String getTitle(String document){
        String startTag = "<title xsi:type=\"xsd:string\">";
        String endTag = "</title>";
        int start = document.indexOf(startTag) + startTag.length();
        int end = document.indexOf(endTag);
        String result = document.substring(start, end);
        return result;
    }
    
    
    protected String getUrl(String document){
        String startTag = "<url xsi:type=\"xsd3:anyURI\">";
        String endTag = "</url>";
        int start = document.indexOf(startTag) + startTag.length();
        int end = document.indexOf(endTag);
        String result = document.substring(start, end);
        return result;
    }
    
    
    
    
    private String getCUGGroups(String pagepath, Session session){
        Node temp;
        String cug = "";
        
        try{            
            Node currPage= session.getNode(pagepath);
            int depth=currPage.getDepth();
            //cug="depth:"+depth+" ";
            Value[] grpdata;
            
            for(int i =depth-2  ; i > 0; i--)
            {
             //cug+="i:"+i+" ";
             temp = currPage.getParent();
             Node jcrContent=currPage.getNode("jcr:content");
             if(jcrContent!=null){
                 cug+=" jcrContent not null";
                 if(jcrContent.hasProperty("cq:cugEnabled") && jcrContent.getProperty("cq:cugEnabled").getValue().getString().equals("true")){
                     if(jcrContent.hasProperty("cq:cugPrincipals") )
                     {
                         cug+=" has cq:cugPrincipals ";
                         try {
                                Value[] multi=jcrContent.getProperty("cq:cugPrincipals").getValues();
                                for (int j=0; j<multi.length; j++) {
                                    cug+= "["+(multi[j]).getString() +"]";         
                                }
                                
                            }catch (ValueFormatException e){
                        
                              cug= "["+ jcrContent.getProperty("cq:cugPrincipals").getValue().getString() +"]"; 
                              
                           }
                           
                     
                     }
                   break;
                  }
                 
              }
              
             currPage=temp;
             }
         }catch(Exception e){
         }
         
         return cug;
 
    }
    
    private String getDAMField(String pagepath, Session session, String field){
        Node temp;
        String ret= "";
        Value[] grpdata;
        try{            
            Node metadata= session.getNode(pagepath+"/jcr:content/metadata");

             if(metadata!=null){
                 if(metadata.hasProperty(field) )
                 {
                 try {
                        Value[] multi=metadata.getProperty(field).getValues();
                        for (int i=0; i<multi.length; i++) {
                            ret+= multi[i].getString();         
                        }
                        
                    }catch (ValueFormatException e){
                
                      ret= metadata.getProperty(field).getValue().getString();
                      
                   }
                 }
              }

         }catch(Exception e){
         }
         
         return ret;
 
    }
    
%>

<HTML>
<TITLE>test</TITLE>
<head>
<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
</head>
<body>
Test anon access
<%
org.apache.sling.jcr.api.SlingRepository repository = sling.getService(org.apache.sling.jcr.api.SlingRepository.class); 
String resp=getSoapResponse(repository,"<url xsi:type=\"xsd3:anyURI\">/content/dam/accessmcd/na/us/National Department/CQ5 Training/Test/test2.docx</url>");
%>
<%=resp%>
</body>
</html>