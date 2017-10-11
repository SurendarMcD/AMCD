<%--
  
  Compiles a JSP-to populate list of the available theme colors to
  generate items in selection dropdown. 

--%><%
%><%@include file="/apps/mcd/global/global.jsp"%>
 
[<%
    try{
        Resource resourcePath=slingRequest.getResourceResolver().getResource(currentDesign.getPath()+"/jcr:content/base/sitelevelproperties");
        Node sourceNode=resourcePath.adaptTo(Node.class);
        Value[] sizeValue = null;
        Value singleSize = null;
        String[] split = null;
        int sizeLength = 0;
        String size = "";
        if(sourceNode.hasProperty("size")){
            try{
                sizeValue= sourceNode.getProperty("size").getValues();
            }
            catch(Exception e){
                if(sizeValue==null){
                    singleSize = sourceNode.getProperty("size").getValue();
                    if(singleSize!=null){
                        sizeValue = new Value[1];
                        sizeValue[0] =  singleSize;      
                    }
                }    
            }       
            sizeLength = sizeValue.length;
        }                  
        if(sizeLength>0){
            //To generate a No Size value
            %>
            {"text":"Select Size",
              "value":""}
            <%
            for(int i=0;i<sizeLength;i++){
                size = sizeValue[i].getString();
                split = size.split("\\|");              
                if(split!=null && split.length>0)
                {
                %>,{<%
                    %>"text":"<%=split[0] %>",<%
                    %>"value":"<%=split[1]%>"<%
                %>}<%
                }
            }
        }
    } catch (Exception e) {
        //out.println("Exception in Graphical Menu Size jsp"+e);
        log.error("Exception in Graphical Menu Size jsp"+e);
    }
%>
]
