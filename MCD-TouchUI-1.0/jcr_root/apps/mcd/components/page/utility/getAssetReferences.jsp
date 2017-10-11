<%@include file="/apps/mcd/global/global.jsp" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>  
<%@page import = "java.util.regex.Pattern,
                  java.util.regex.Matcher,
                  java.util.Iterator,
                  java.util.HashSet,                  
                  java.util.StringTokenizer,
                  java.net.URLDecoder
                  "%>
                  
<%@page import = "com.mcd.accessmcd.dam.damUtil"%>                  
<%
       
        response.setHeader("Cache-Control","no-cache");
        response.setHeader("Cache-Control","no-store");
        response.setDateHeader("Expires", 0);
        response.setHeader("Pragma","no-cache");

%>                  
<%
  HashSet<String> damLinks = new HashSet<String>();
    HashSet<String> assetCUG = new HashSet<String>();
    String assetLinks = "";
    
%>

<%!

  
    public HashSet getCUG(SlingHttpServletRequest slingRequest,String nodePath) throws RepositoryException
    {
            String node = nodePath.trim(); 
            boolean temp = false;
            //out.write(nodePath);
               
            Node assetJcrNode = null;
            HashSet<String> assetCUG = new HashSet<String>();           
            
            try
            {          
              if(node.endsWith("/content/dam/accessmcd"))    
              {
                  //out.write("TESTddd");
                  //do nothing
              }  
              else
             {   
                 //out.write("11111");
                     
                 if(slingRequest.getResourceResolver().getResource(node+"/jcr:content") != null)
                 {    
                 assetJcrNode = slingRequest.getResourceResolver().getResource(node+"/jcr:content").adaptTo(Node.class);  
      //          HashSet<String> assetCUG = new HashSet<String>();
                              
                    if(assetJcrNode.hasProperty("cq:cugPrincipals"))
                    {
                        temp = true;
                        Value[] pageCUG = assetJcrNode.getProperty("cq:cugPrincipals").getValues();
                        for(int i=0;i<pageCUG.length;i++)
                        {
                            assetCUG.add(pageCUG[i].getString());
                        }                    
                    }
                    else
                    {
                     //out.write("22222");
                        //Node assetNode = slingRequest.getResourceResolver().getResource(node).adaptTo(Node.class);  
                        Node parentNode = assetJcrNode.getParent().getParent();
                        assetCUG = getCUG(slingRequest,parentNode.getPath());
                        
                        
                    } 
                   }  
                   else
                   {
                    //out.write("NUll mil gya");
                     Node n = slingRequest.getResourceResolver().getResource(node).adaptTo(Node.class);
                     assetCUG = getCUG(slingRequest,n.getParent().getPath());
                   } 
                               
               }              
            }
            catch(ValueFormatException e)
            {
                    try
                    {      
                        if(assetJcrNode.hasProperty("cq:cugPrincipals"))
                        {
                       
                            assetCUG.add(assetJcrNode.getProperty("cq:cugPrincipals").getString());        
                        
                        }                                            
                    }
                    catch(Exception ex)
                    {
                        e.printStackTrace();
                    } 
            }
            catch(Exception e)
            {
              //out.write("Null mila");
         
                 e.printStackTrace();
            }
            
            
        return assetCUG;             
    }
    
%>

<%
    String dmclinkpattern= "/content/dam[^ \\\"]*";
    Pattern p = Pattern.compile(dmclinkpattern);    
    HashSet<String> pageCUG = new HashSet<String>();
    String asset = "";
    String rootPath = (String)request.getParameter("path");
    boolean difference = true;
    assetLinks = "";
    damUtil damUtilObject = new damUtil();
    

    if( (!(rootPath != null)) || (!(rootPath.length() > 0)) )
    {
        rootPath = "";
    }   

    String query="/jcr:root"+rootPath+"/jcr:content//*[jcr:contains(., '/content/dam')]";    
    
    //out.println("Query"+query);
    
    try{
            Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
            
            String separator = "";
                            
            while(result.hasNext())
            {
                Resource r=(Resource)result.next();
                javax.jcr.Node resultNode = r.adaptTo(javax.jcr.Node.class);
                String path = resultNode.getPath();  


                if(path.endsWith("/accordion"))   
                {    
                    if((resultNode.hasProperty("accordiandata")))
                    {
                        Value[] acc_data = resultNode.getProperty("accordiandata").getValues();
                        for(int i=0; i<acc_data.length; i++)
                        {
                            Matcher matcher = p.matcher(acc_data[i].getString());
                            while (matcher.find()) 
                            {
                                assetLinks += separator;
                                //assetLinks += matcher.group()+",";
                                assetLinks += matcher.group();
                                separator = ",";
                            }
                        }
                    }
                }
                else if(path.endsWith("/everything"))
                {                   
                    if((resultNode.hasProperty("text")))
                    {
                        String text=resultNode.getProperty("text").getString();
                        Matcher matcher = p.matcher(text);
                        while (matcher.find()) 
                        {
                                assetLinks += separator;
                                //assetLinks += matcher.group()+",";
                                assetLinks += matcher.group();
                                separator = ",";
                        }
                    }else if((resultNode.hasProperty("imageLink")))
                    {
                        String imageLink = resultNode.getProperty("imageLink").getString();
                        Matcher matcher = p.matcher(imageLink);
                        while (matcher.find()) 
                        {
                                assetLinks += separator;
                                //assetLinks += matcher.group()+",";
                                assetLinks += matcher.group();
                                separator = ",";
                        }
                    }                                 
                }    
                else if(path.endsWith("/graphicalmenu"))
                {
                    if((resultNode.hasProperty("text")))
                    {
                        String text=resultNode.getProperty("text").getString();
                        Matcher matcher = p.matcher(text);
                        while (matcher.find()) 
                        {
                                assetLinks += separator;
                                //assetLinks += matcher.group()+",";
                                assetLinks += matcher.group();
                                separator = ",";
                        }
                    }
                }   
                else if(path.endsWith("/image"))
                {                    
                    if((resultNode.hasProperty("fileReference")))
                    {
                        String fileReference = resultNode.getProperty("fileReference").getString();
                        Matcher matcher = p.matcher(fileReference);
                        while (matcher.find()) 
                        {
                                assetLinks += separator;
                                //assetLinks += matcher.group()+",";
                                assetLinks += matcher.group();
                                separator = ",";
                        }
                    }
                }     
            
            }   
    }catch(Exception e)
    {
        e.printStackTrace();
        
    }                     
    
    //out.println("Asset Links"+assetLinks);
    StringTokenizer strToken = new StringTokenizer(assetLinks,",");
    while (strToken.hasMoreTokens()) 
    {
        damLinks.add(strToken.nextToken());
    }

    //out.println("DAM Links"+damLinks.size());

    pageCUG = getCUG(slingRequest,rootPath.trim());  
 
     //out.println("Page CUG"+pageCUG.size());
 
    if(pageCUG.size()>0)
    {  
               
        Iterator<String> assetLink = damLinks.iterator();
    
        //out.println("Size"+damLinks.size());
        while(assetLink.hasNext())
        {     
            asset = assetLink.next();
            
            //out.println("asset-->"+asset);
            String updatedLink = URLDecoder.decode(asset); 
                         
            assetCUG = getCUG(slingRequest,updatedLink);       
            
            //out.println("TEST"+updatedLink+assetCUG.size() );
            
            
            Iterator<String> pageItr = pageCUG.iterator();   
            //out.println("TEST VALUE"+pageItr.hasNext());
            while(pageItr.hasNext())
            {
                //out.println("TEST1111111111111"+updatedLink );
                if(!assetCUG.contains(pageItr.next()))
                {                
                    difference = false;     
                    break;
                }
            }
            
        }
        
     }   
%>

[{"difference":"<%=difference%>"}]    