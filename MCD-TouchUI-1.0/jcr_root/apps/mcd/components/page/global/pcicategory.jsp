<%--
  
  Compiles a JSP-to populate list of the available pci categories to
  generate items in selection dropdown. 
  
  //wei - created on 09/08/2010    
  //wei - added reading pcicategory file using "Resource" on 09/23/2010
  //wei - added reading different pcicategory file from Design on 09/28/2010

--%><%
%><%@page import="java.io.*, java.util.*"%>
<%@page import="java.io.InputStream,java.io.InputStreamReader"%>
<%@include file="/apps/mcd/global/global.jsp"%>

[<%
     String pcicategoryPath="/apps/mcd/classes/pcicategories.html/jcr:content";
     ArrayList pciViews = new ArrayList();
     String temp = "";
     String[] tempArr; 
     
     //get selected views from Design
     String viewSelected = "";
     if(currentDesign!=null){
        Node sitelevelproperties = getSiteLevelPropertiesNode(slingRequest, pageProperties, currentDesign);
        
        if(sitelevelproperties!=null) {
            if(sitelevelproperties.hasProperty("view")) {
                if (sitelevelproperties.getProperty("view").getDefinition().isMultiple()) {
                            
                   //get checkbox values
                   Value[] v = sitelevelproperties.getProperty("view").getValues();
               
                   //add "ALL"
                   //pciViews.add("|ALL,");
               
                   for (int s=0; s<v.length; s++) {
                       temp = v[s].getString();
                       //temp = "|" + v[s].getString() + ",";
                       //ex: AU_NZ
                       if (temp.indexOf("_")!=-1) {
                         tempArr = temp.split("_");
                         for (int i=0; i<tempArr.length; i++) 
                             pciViews.add(tempArr[i]);  
                       } else {
                              pciViews.add(temp); 
                       }   
                   }    
                } else {
                    temp = sitelevelproperties.getProperty("view").getValue().getString();
                    //temp = "|" + sitelevelproperties.getProperty("view").getValue().getString() + ",";
                    //ex: AU_NZ
                    if (temp.indexOf("_")!=-1) {
                      tempArr = temp.split("_");
                      for (int i=0; i<tempArr.length; i++) 
                          pciViews.add(tempArr[i]);  
                    } else {
                              pciViews.add(temp); 
                    }   
                }     
            }
        }
     }
     
                  
     if (pciViews.size() == 0) {
     %>
            {"text":"Please define the category list from the Design view",
             "value":""}
         
     <% } else {
             
     //get the pci category list from resource
     Resource pcicategoryResource=null;
     pcicategoryResource=slingRequest.getResourceResolver().getResource(pcicategoryPath);
     String pcicategoryList = ""; 
     
     if(pcicategoryResource!=null){  
         InputStream is = pcicategoryResource.adaptTo(InputStream.class);
         InputStreamReader reader = null;
                 
         try {
             reader = new InputStreamReader(is);
             char[] buffer = new char[10240];
            
             while (reader.read(buffer) != -1) {
                 pcicategoryList += new String(buffer);
             }
             //log.error("pcicategoryList=" + pcicategoryList);
             reader.close();
        } catch (Exception e) {
             log.error("error=" + e.getMessage());
             try {
                if (reader != null) {
                    reader.close(); 
                 } 
            } catch (Exception e1)  { 
                e1.printStackTrace(); 
            } 
        }
    }
              
    //log.error(pcicategoryList);
    ArrayList pciAL = new ArrayList();
    String pciEntry = "";
    String view = "";
    String[] entry;
          
    String[] pcicategoryEntries = pcicategoryList.split("\n");   
    
    for (int i=0; i<pcicategoryEntries.length; i++) {
        //log.error(pcicategoryEntries[i] + "...");
        
        for (int v=0; v<pciViews.size(); v++) {
              view = (String) pciViews.get(v);
              if (pcicategoryEntries[i].indexOf(view)!=-1) {
                  pciEntry = pcicategoryEntries[i].replace(",","");
                  //log.error(pciEntry);
                  
                  pciAL.add(pciEntry);
                  pciEntry = "";
                  break;
              }
          } 
     }
     
    /*  
    String fileName = "/app/mcd/cms/cq5_3/wcm2_auth_dev_53/crx-quickstart/server/files/pcicategory.txt";
    BufferedReader in = null;
    String line = null;       
    ArrayList al = new ArrayList();
    String[] pciCategory = null;
    String pciCategoryEntry = null;
    
    String[] views = {"|ENT", "|US", "|AU", "|ALL"};
    
    try{
       File file = new File(fileName);
       in = new BufferedReader(new FileReader(file));
      
       while((line = in.readLine()) !=null) {
          //log.error("line=" + line);
          for (int v=0; v<views.length; v++) {
              if (line.indexOf(views[v])!=-1) {
                  al.add(line);
                  break;
              }
          } 
       }  
       in.close();
       */ 
       
       %>
            {"text":"",
             "value":""}
         
       <%
        
       String pciCategoryEntry = null; 
       String[] pciCategory = null;  
                     
       for (int j=0; j< pciAL.size(); j++) {
           
           pciCategoryEntry = (String) pciAL.get(j);
           pciCategory = pciCategoryEntry.split("\\|"); 

           if(pciCategory!=null && pciCategory.length>0) {
            
               //log.error("pciCatgory name=" + pciCategory[1]);
               //log.error("pciCategory value=" + pciCategory[0]);
                %>,{<%
                    %>"text":"<%=pciCategory[1]%>",<%
                    %>"value":"<%=pciCategory[0]%>"<%
                   
                %>}<%
               
            }
         }
      }//end of else
     /* 
    } catch (Exception e) {
        try {
            if (in != null) {
                in.close(); 
            } 
        } catch (IOException e1)  { 
            e1.printStackTrace(); 
        } 

        out.println("Exception in PCI Category jsp"+e);
    }*/
%>]

