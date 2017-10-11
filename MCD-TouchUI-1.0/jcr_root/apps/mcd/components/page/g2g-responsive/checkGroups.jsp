<%@include file="/apps/mcd/global/global.jsp"%>
<%@page import="java.util.HashMap,
                java.util.HashSet,
                java.util.Iterator,
                com.mcd.accessmcd.util.CommonUtil"%>
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
                 if(slingRequest.getResourceResolver().getResource(node+"/jcr:content") != null)
                 {    
                 assetJcrNode = slingRequest.getResourceResolver().getResource(node+"/jcr:content").adaptTo(Node.class);                                
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
                        //Node assetNode = slingRequest.getResourceResolver().getResource(node).adaptTo(Node.class);  
                        Node parentNode = assetJcrNode.getParent().getParent();
                        assetCUG = getCUG(slingRequest,parentNode.getPath());                       
                    } 
                   }  
                   else
                   {            
                     Node n = slingRequest.getResourceResolver().getResource(node).adaptTo(Node.class);
                     assetCUG = getCUG(slingRequest,n.getParent().getPath());
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
                 e.printStackTrace();
            }
            
            
        return assetCUG;             
    }
%>
<%
    response.setHeader("Cache-Control","no-cache");
    response.setHeader("Cache-Control","no-store");
    response.setDateHeader("Expires", 0);
    response.setHeader("Pragma","no-cache"); 
    boolean flag = true;
    String path = currentNode.getPath();
    String isDiff = "true";
    String pageUrl = "";
    HashSet<String> grpsOnPage = new HashSet<String>();           
    String grpsInDialog = "";  
    HashMap<String,String> audienceTypes; 
    audienceTypes = new HashMap<String,String>();
    audienceTypes = CommonUtil.getAudienceType(); 
    

    if(request.getParameter("pagURL")!=null)
    {
    
        pageUrl = request.getParameter("pagURL");
        if(pageUrl.indexOf("/content/accessmcd")>-1)
        {

            grpsOnPage = getCUG(slingRequest,pageUrl);            
            if (request.getParameter("groups")!=null)
            {
                grpsInDialog = request.getParameter("groups");
               
                if(grpsInDialog.indexOf(',')>-1)
                {
                    String allowedGrps[] = grpsInDialog.split(",");
                    Iterator<String> groups = grpsOnPage.iterator();
                    while(groups.hasNext())
                    {                    
                        String group = groups.next();                                    
                        for(int i=0;i<allowedGrps.length;i++)
                        {                    
                            String audienceType = (String)audienceTypes.get(allowedGrps[i]);
                            flag = audienceType.equals(group);
                            if(flag == false)
                            {
                                break;
                            }                     
                        }
                    
                    }
                }else
                {
                    Iterator<String> groups = grpsOnPage.iterator();
                    while(groups.hasNext())
                    {                    
                        String group = groups.next();                                                           
                        String audienceType = (String)audienceTypes.get(grpsInDialog);
                        flag = audienceType.equals(group);
                        if(flag == false)
                        {
                            break;
                        }                     
                        
                    
                    }                    
                }
            }            
        }
    }      
    
    if(flag == false) {
        isDiff = "false";
    } 
    
    
    
%>

[{"diff":"<%=isDiff%>"}] 