<%@include file="/apps/mcd/global/global.jsp"%>

<%
    response.setContentType("application/json");
    response.setCharacterEncoding("utf-8");
    
    int depth = 0;
    depth = currentPage.getDepth();
    Page temp;
    Node currPage;
    String json = "{'authorizables':[";
    String grpdata [];
    String cug = "";
    for(int i =depth-2  ; i > 0; i--)
    {
     temp = currentPage.getAbsoluteParent(i);
     if(temp.getProperties().get("cq:cugPrincipals") != null)
     {
      grpdata = temp.getProperties().get("cq:cugPrincipals",String[].class);
      if(grpdata.length > 0) 
      {
       for(int k=0;k< grpdata.length;k++)
          {
                if(k==0){json=json+"{'type':'group','name':'"+grpdata[k]+"','id':'"+grpdata[k] +"','principal':'"+grpdata[k]+"'}";}
                else
                {json=json+",{'type':'group','name':'"+ grpdata[k] +"','id':'"+grpdata[k] +"','principal':'"+grpdata[k] +"'}";}
                
           }
            
        
           break;
      }
     }
 
    }  
        json=json+"]}";  
    out.println(json);
  
%>
  

   