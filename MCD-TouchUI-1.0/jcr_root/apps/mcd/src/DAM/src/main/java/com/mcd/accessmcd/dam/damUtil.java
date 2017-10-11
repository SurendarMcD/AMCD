package com.mcd.accessmcd.dam;

import java.util.HashSet;
import java.util.Iterator;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import javax.jcr.Node;
import javax.jcr.Value;
import javax.jcr.RepositoryException;
import javax.jcr.ValueFormatException;
import com.day.cq.replication.PathNotFoundException;
import com.day.cq.wcm.commons.ReferenceSearch;


                  
public class damUtil
{
    public String dmclinkpattern= "/content/dam[^ \\\"]*";
    public Pattern p = Pattern.compile(dmclinkpattern);    
    public HashSet<String> assetLinks = new HashSet<String>(); 
    //String assetLinks = "";
    
    public String authname = "";
 
    // method to fetch asset references of a page  
    public HashSet<String> getReferredAssets(ResourceResolver resourceResolver,String pagePath) throws RepositoryException
    {
        String query="/jcr:root"+pagePath+"/jcr:content//*[jcr:contains(., '/content/dam')]";            
        Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
        //String separator = "";
        
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
                                assetLinks.add(matcher.group());                            
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
                            assetLinks.add(matcher.group()); 
                        }
                    }else if((resultNode.hasProperty("imageLink")))
                    {
                        String imageLink = resultNode.getProperty("imageLink").getString();
                        Matcher matcher = p.matcher(imageLink);
                        while (matcher.find()) 
                        {
                               assetLinks.add(matcher.group());
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
                            assetLinks.add(matcher.group()); 
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
                            assetLinks.add(matcher.group()); 
                        }
                    }
                }                    
            
            }   
            
        return assetLinks;
    }
    
    // method to fetch the owner of an asset  
    public String getAssetOwnerName(SlingHttpServletRequest slingRequest,String assetPath) throws RepositoryException,PathNotFoundException
    {
        authname = "";
        Node assetNode = slingRequest.getResourceResolver().getResource(assetPath+"/jcr:content/metadata").adaptTo(Node.class); 
        if(assetNode.hasProperty("authname"))
        {
            authname = assetNode.getProperty("authname").getString();        
                         
        }      
        return authname;     
    }

    // method to fetch page references of an asset    
    public HashSet getAssetReferences(SlingHttpServletRequest slingRequest,String assetPath) throws RepositoryException
    {
        HashSet<String> assetReferences = new HashSet<String>();
        ReferenceSearch referSearch = new ReferenceSearch();
        
        for (ReferenceSearch.Info info: referSearch.search(slingRequest.getResourceResolver(),assetPath).values()) 
        {
            for (String p: info.getProperties())
            {
                assetReferences.add(info.getPage().getPath());
            }
        }        
        return assetReferences;
    } 
              
    // method to fetch CUG of a page or an asset 
    public HashSet getCUG(SlingHttpServletRequest slingRequest,String nodePath) throws RepositoryException
    {
            String node = nodePath.trim();
            HashSet<String> nodeCUG = new HashSet<String>(); 
            
            Node rootNode = slingRequest.getResourceResolver().getResource(node+"/jcr:content").adaptTo(Node.class);         
            
            try
            {                        
                if(rootNode.hasProperty("cq:cugPrincipals"))
                {
                    Value[] cug = rootNode.getProperty("cq:cugPrincipals").getValues();
                    for(int i=0;i<cug.length;i++)
                    {
                        nodeCUG.add(cug[i].getString());
                    }
                    
                    
                }
            }
            catch(ValueFormatException valueE)
            {
                    try
                    {      
                        if(rootNode.hasProperty("cq:cugPrincipals"))
                        {                       
                            //nodeCUG.add(rootNode.getProperty("cq:cugPrincipals").getString());     
                        
                        }                                            
                    }
                    catch(Exception e)
                    {
                        nodeCUG = null;
                        e.printStackTrace();
                        
                    } 
            }
            

        return nodeCUG;             
    }
}       
   