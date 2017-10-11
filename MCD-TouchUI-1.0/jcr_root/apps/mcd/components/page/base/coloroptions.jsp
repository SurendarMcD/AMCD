<%--
  
  Compiles a JSP-to populate list of the available theme colors to
  generate items in selection dropdown. 

--%><%
%><%@include file="/apps/mcd/global/global.jsp"%>
[<%
    try{
        //To get the node of the theme folder
        NodeIterator themeNode = slingRequest.getResourceResolver().getResource(currentDesign.getPath()+"/theme").adaptTo(Node.class).getNodes();
        String seperator = "";//Seperator to be used to store values
        //To iterate through sub nodes of the parent node
        while (themeNode.hasNext()) {
            Node themeNodes = themeNode.nextNode();//To get an object of child node
            String nodeName = themeNodes.getName();//To get the name of the child node
            if(nodeName.equalsIgnoreCase("rep:accessControl"))//If rep:accessControl default node is found skip the current iteration
                continue;
            %><%= seperator %><%
            %>{<%
                %>"text":"<%=nodeName %>",<%
                %>"value":"<%=nodeName.replaceAll(" ","") %>"<%
            %>}<%
            //To seperate the values in selection dropdown by a comma
            if ("".equals(seperator)) seperator = ",";
        }
        //To generate a No Color value
        %>
        ,{"text":"No Color",
        "value":"No Color"}
        <%
    } catch (Exception e) {
        log.error("Exception in ColorOption JSP"+e);
    }
%>
    ]
