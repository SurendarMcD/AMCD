<%@include file="/apps/mcd/global/global.jsp" %>
<%@page import=" javax.jcr.Session,java.util.*,
                org.apache.sling.scripting.core.ScriptHelper,
                org.apache.sling.api.resource.Resource,
                org.apache.sling.jcr.api.SlingRepository,
                org.apache.sling.api.scripting.SlingScriptHelper"%>
                
<%@page import = "com.mcd.accessmcd.dam.damUtil"%>      

<%
       
        response.setHeader("Cache-Control","no-cache");
        response.setHeader("Cache-Control","no-store");
        response.setDateHeader("Expires", 0);
        response.setHeader("Pragma","no-cache");

%>  

<%
    String assetLink = request.getParameter("path");   
    String callProperty = request.getParameter("callProp");   
    
   
       
    Node assetNode,pageNode,jcrNode;
    Boolean temp =false;
   
    if(callProperty.equals("dialog"))
    {
       String cugGrp = request.getParameter("cugGrp"); 
       String cugEnable=request.getParameter("cugEnable"); 
       String cugLogin=request.getParameter("cugLogin");
       String[] splits = cugGrp.split(",");
       
       assetNode = slingRequest.getResourceResolver().getResource(assetLink).adaptTo(Node.class);
       String assetType = assetNode.getProperty("jcr:primaryType").getString();
       
        if(assetType.equals("dam:Asset"))
        {
            jcrNode = slingRequest.getResourceResolver().getResource(assetLink + "/jcr:content").adaptTo(Node.class);
            pageNode = slingRequest.getResourceResolver().getResource(assetLink+"/jcr:content/metadata").adaptTo(Node.class);
                               
            if(pageNode!=null)
            {
                try
                {  
                    if(cugEnable!=null && cugEnable.trim().length()>0 && !cugEnable.equals(""))
                    {
                      pageNode.setProperty("cq:cugEnabled",cugEnable) ;
                    }else
                     {
                        if(pageNode.hasProperty("cq:cugEnabled"))
                        {
                           pageNode.setProperty("cq:cugEnabled", (String)null);
                        }
                     }
                    if(cugLogin!=null && cugLogin.trim().length()>0 && !cugLogin.equals(""))
                    {
                       pageNode.setProperty("cq:cugLoginPage",cugLogin) ; 
                    }else
                     {
                        if(pageNode.hasProperty("cq:cugLoginPage"))
                        {
                         pageNode.setProperty("cq:cugLoginPage",  (String)null);
                        }
                     }
                    
                       if(splits!=null && splits.length>0)
                        {
                           // out.println("1");
                            if(pageNode.hasProperty("cq:cugPrincipals"))
                            {
                                  
                                  //  out.print("111111111111");
                                   //out.print("*****"+ jcrNode.getProperty("cq:cugPrincipals").getDefinition().isMultiple()  +"----");
                                    if(pageNode.getProperty("cq:cugPrincipals").getDefinition().isMultiple() )
                                    {
                                        pageNode.setProperty("cq:cugPrincipals",(String[])null); 
                                    }else
                                     {
                                        pageNode.setProperty("cq:cugPrincipals",(String)null);
                                     }
                                       //jcrNode.setProperty("cq:cugPrincipals",(String[])null);
                                      //  out.print("2222222222222222");
                                        pageNode.save();
                                      //  out.print("333333333333333333333");
                                    if(splits.length == 1)
                                    {
                                        pageNode.setProperty("cq:cugPrincipals", splits[0]); 
                                    }else if(splits.length>1)
                                    {
                                        pageNode.setProperty("cq:cugPrincipals", splits); 
                                    }
                                    
                                                           
                            //out.print("4444444444444444444");
                           } else {
                       // out.print("ESLE");
                              pageNode.setProperty("cq:cugPrincipals",splits);                         
                            }
                      }  else {
                              if(pageNode.getProperty("cq:cugPrincipals").getDefinition().isMultiple() )
                                    {
                                        pageNode.setProperty("cq:cugPrincipals",(String[])null); 
                                    }else
                                     {
                                        pageNode.setProperty("cq:cugPrincipals",(String)null);
                                     }
                         }
                       pageNode.save();
                       temp = true;  
                }catch(Exception e){
                    e.printStackTrace();
                   // out.print(e.getMessage());
                 }  
            }
       }
      
    }else if(callProperty.equals("assetEditor"))
    {
    
        pageNode = slingRequest.getResourceResolver().getResource(assetLink + "/jcr:content/metadata").adaptTo(Node.class);
        jcrNode = slingRequest.getResourceResolver().getResource(assetLink + "/jcr:content").adaptTo(Node.class);
       // out.print(pageNode.hasProperty("cq:cugLoginPage"));
        if(pageNode != null && jcrNode !=null)
        {    
        
             try{
                 if(pageNode.hasProperty("cq:cugEnabled"))
                    { 
                        jcrNode.setProperty("cq:cugEnabled", pageNode.getProperty("cq:cugEnabled").getString());
                        
                    }else{
                        if(jcrNode.hasProperty("cq:cugEnabled"))
                        {
                            jcrNode.setProperty("cq:cugEnabled",  (String)null);
                         }
                     }
                    if(pageNode.hasProperty("cq:cugLoginPage"))
                    {  
                        jcrNode.setProperty("cq:cugLoginPage", pageNode.getProperty("cq:cugLoginPage").getString().trim());
                          
                    }else{
                        if(jcrNode.hasProperty("cq:cugLoginPage"))
                        {
                            jcrNode.setProperty("cq:cugLoginPage",  (String)null);
                        }
                     }
                     
                     if(pageNode.hasProperty("cq:cugPrincipals"))
                    {   
                       // out.println("HAS PROPERTY");
                        if(jcrNode.hasProperty("cq:cugPrincipals")){
                           // out.print("111111111111");
                           //out.print("*****"+ jcrNode.getProperty("cq:cugPrincipals").getDefinition().isMultiple()  +"----");
                            if(jcrNode.getProperty("cq:cugPrincipals").getDefinition().isMultiple() ){
                                jcrNode.setProperty("cq:cugPrincipals",(String[])null); 
                            }else{
                                jcrNode.setProperty("cq:cugPrincipals",(String)null);
                             }
                            
                                //jcrNode.setProperty("cq:cugPrincipals",(String[])null);
                              //  out.print("2222222222222222");
                                jcrNode.save();
                              //  out.print("333333333333333333333");
                            if(pageNode.getProperty("cq:cugPrincipals").getDefinition().isMultiple() ){
                                 //out.println("MULti"+pageNode.getProperty("cq:cugPrincipals").getDefinition().isMultiple());
                                 jcrNode.setProperty("cq:cugPrincipals", pageNode.getProperty("cq:cugPrincipals").getValues()); 
                            }else{
                                 //out.println("MULti second"+pageNode.getProperty("cq:cugPrincipals").getDefinition().isMultiple());
                                 jcrNode.setProperty("cq:cugPrincipals", pageNode.getProperty("cq:cugPrincipals").getString());
                             }
                                   //out.print("4444444444444444444");
                         } else {
                               jcrNode.setProperty("cq:cugPrincipals", pageNode.getProperty("cq:cugPrincipals").getValues());
                           } 
                    }else {
                             if(jcrNode.getProperty("cq:cugPrincipals").getDefinition().isMultiple() )
                                    {
                                        jcrNode.setProperty("cq:cugPrincipals",(String[])null); 
                                    }else
                                     {
                                        jcrNode.setProperty("cq:cugPrincipals",(String)null);
                                     }
                         }
                    
                    jcrNode.save();
                    temp = true;
                    
                    
                }catch(ValueFormatException e)
                 {
                            try
                            {      
                                if(pageNode.hasProperty("cq:cugPrincipals"))
                                {                       
                                    jcrNode.setProperty("cq:cugPrincipals", pageNode.getProperty("cq:cugPrincipals").getString());
                                    jcrNode.save();
                                    temp = true;                                 
                                }                                            
                            }
                            catch(Exception ex)
                            {
                                ex.printStackTrace();
                            } 
                } 
            }    
    }
  
%>  
[{"save":"<%= temp %>","callFrom":"<%=callProperty%>"}]
