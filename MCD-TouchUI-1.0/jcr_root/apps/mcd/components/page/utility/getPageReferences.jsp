<%@include file="/apps/mcd/global/global.jsp" %>
<%@page import="com.day.cq.wcm.commons.ReferenceSearch,
                com.day.cq.replication.Agent,   
                com.day.cq.replication.AgentManager,
                com.day.cq.replication.ReplicationActionType,
                com.day.cq.replication.ReplicationQueue,
                com.day.cq.replication.Replicator,
                java.util.ArrayList,
                java.util.HashSet,
                java.util.Iterator,
                javax.jcr.Session,java.util.*,
                org.apache.sling.scripting.core.ScriptHelper,
                org.apache.sling.api.resource.Resource,
                org.apache.sling.jcr.api.SlingRepository,
                org.apache.sling.api.scripting.SlingScriptHelper,
                com.day.cq.security.User,
                com.day.cq.security.profile.Profile,
                java.io.*"%>
                
<%@page import = "com.mcd.accessmcd.dam.damUtil"%>   
<%
       
        response.setHeader("Cache-Control","no-cache");
        response.setHeader("Cache-Control","no-store");
        response.setDateHeader("Expires", 0);
        response.setHeader("Pragma","no-cache");

%>                
                                     
<%!
    
    public HashSet getCUG(SlingHttpServletRequest slingRequest,String nodePath,Writer out) throws RepositoryException,IOException
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
                            //out.write(pageCUG[i].getString());
                            assetCUG.add(pageCUG[i].getString());
                        }                    
                    }
                    else
                    {
                     //out.write("22222");
                        //Node assetNode = slingRequest.getResourceResolver().getResource(node).adaptTo(Node.class);  
                        Node parentNode = assetJcrNode.getParent().getParent();
                        assetCUG = getCUG(slingRequest,parentNode.getPath(),out);
                        
                        
                    } 
                   }  
                   else
                   {
                    //out.write("NUll mil gya");
                     Node n = slingRequest.getResourceResolver().getResource(node).adaptTo(Node.class);
                     assetCUG = getCUG(slingRequest,n.getParent().getPath(),out);
                   } 
                               
               }              
            }
            catch(ValueFormatException e)
            {
                    try
                    {      
                        if(assetJcrNode.hasProperty("cq:cugPrincipals"))
                        {
                            //out.write(assetJcrNode.getProperty("cq:cugPrincipals").getString());
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
    
    public ArrayList pageName(SlingHttpServletRequest slingRequest,ArrayList pages)
    {
        ArrayList pageNames = new ArrayList();
        Iterator<String> pageItr = pages.iterator();
        
        while(pageItr.hasNext())
        {
            String page = pageItr.next();        
            Page rootPage = slingRequest.getResourceResolver().adaptTo(PageManager.class).getPage(page);
            pageNames.add(rootPage.getTitle());
        }
        
        return pageNames;
    }
    
%>     


<%
    String assetLink = request.getParameter("path"); 
    //out.println("AssetLink"+assetLink);
    HashSet<String> assetReferences = new HashSet<String>();
    HashSet<String> referredCUG = new HashSet<String>();
    HashSet<String> referredPageCUG = new HashSet<String>();
    HashSet<String> assetCUG = new HashSet<String>();
    String referredPage = "";    
    damUtil damUtilObject = new damUtil();
    boolean difference = true;
    
    final User user = slingRequest.getResourceResolver().adaptTo(User.class);    
    Profile userProfile = user.getProfile();
    String emailAddress = userProfile.getPrimaryMail();
    Node pageNode;
    Calendar cal = Calendar.getInstance();
    Date offTime,temp;
    offTime = null;

    if( (!(assetLink != null)) || (!(assetLink.length() > 0)) )
    {
        assetLink = "";
        
    }else  
    {    
    
        Node damNode = slingRequest.getResourceResolver().getResource(assetLink).adaptTo(Node.class);  
        Property primaryType = damNode.getProperty("jcr:primaryType");
        String assetType  = primaryType.getString(); 
        if(assetType.equals("dam:Asset"))
        {
            assetCUG = getCUG(slingRequest,assetLink,out);    
            
            //out.println("Asset CUG"+assetCUG);
                            
            assetReferences = damUtilObject.getAssetReferences(slingRequest,damNode.getPath());     
            
            //out.println("Asset References"+assetReferences);
            
            Iterator<String> referItrForOffTime = assetReferences.iterator();
            
            while(referItrForOffTime.hasNext())
            {
             referredPage = referItrForOffTime.next();
             
             //out.println("Page"+referredPage );
                  
             pageNode = slingRequest.getResourceResolver().getResource(referredPage  + "/jcr:content").adaptTo(Node.class);
             //out.println("Node Name--------->"+pageNode.getName());
             if( pageNode.hasProperty("offTime"))
              {
                   Property p = pageNode.getProperty("offTime");  
                   offTime  = p.getDate().getTime();  
                   //out.println("offTime-------->"+offTime);         
              }
             // if(offTime.compareTo(offTime))
            }        
               
            Iterator<String> referItr = assetReferences.iterator();    
               
            while(referItr.hasNext())
            {
                referredPage = referItr.next();                                                                    
                pageNode = slingRequest.getResourceResolver().getResource(referredPage  + "/jcr:content").adaptTo(Node.class);
                if(pageNode.hasProperty("cq:lastReplicationAction"))
                {
                        String pageStatus = pageNode.getProperty("cq:lastReplicationAction").getString();
                        if(pageStatus.equals("Activate"))
                        {                       
                            if( pageNode.hasProperty("offTime"))
                            {
                               Property p = pageNode.getProperty("offTime");  
                               temp= p.getDate().getTime();
                               if(temp.after(offTime))
                               {
                                    offTime = temp;
                               }      
                            }                                                           
                               
                            referredCUG = getCUG(slingRequest,referredPage,out);   
                                                        
                            if(referredCUG.size()>0)
                            {
                                Iterator<String> pageCUGItr = referredCUG.iterator();
                                while(pageCUGItr.hasNext())
                                {                    
                                    if(!assetCUG.contains(pageCUGItr.next()))
                                    {              
                                        difference = false;
                                        break;  
                                    }
                                }  
                            }   
                        }
                    }                  
            }    
            
            //out.println("Difference"+difference);
            
            if(offTime != null && difference == true)
            {
              pageNode = slingRequest.getResourceResolver().getResource(assetLink + "/jcr:content").adaptTo(Node.class);
              cal.setTime(offTime);
              pageNode.setProperty("offTime",cal);
              pageNode.save();
            }
        
      }      
    }  
%>  
[{"difference":"<%=difference%>","offTime":"<%=offTime %>"}]