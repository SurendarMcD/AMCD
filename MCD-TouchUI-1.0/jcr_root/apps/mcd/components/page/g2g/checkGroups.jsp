<%@include file="/apps/mcd/global/global.jsp"%>
<%@page import="java.util.HashSet,
                java.util.Iterator "%>
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
    response.setHeader("Cache-Control","no-cache");
    response.setHeader("Cache-Control","no-store");
    response.setDateHeader("Expires", 0);
    response.setHeader("Pragma","no-cache"); 
    boolean flag = true;
    String path = currentNode.getPath();
    String isDiff = "false";
    String pageUrl = "";
    HashSet<String> grpsOnPage = new HashSet<String>();           
    String grpsInDialog = "";   


    if(request.getParameter("pagURL")!=null)
    {
    
        pageUrl = request.getParameter("pagURL");
        if(pageUrl.indexOf("/content/accessmcd")>-1)
        {
            //pageUrl = pageUrl.replaceFirst("https://www.accessmcd.com","");
            pageUrl = pageUrl.substring(pageUrl.indexOf("/content/accessmcd"),pageUrl.lastIndexOf(".html"));                               
            grpsOnPage = getCUG(slingRequest,pageUrl);            
            if (request.getParameter("groups")!=null)
            {
                grpsInDialog = request.getParameter("groups");
                
                String allowedGrps[] = grpsInDialog.split(",");
                Iterator<String> groups = grpsOnPage.iterator();
                while(groups.hasNext())
                {
                    for(int i=0;i<allowedGrps.length;i++)
                    {
                        flag = allowedGrps[i].equals(groups.next());
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
        isDiff = "true";
    } 
    
    
    
%>

[{"diff":"<%=isDiff%>"}] 