<%@include file="/apps/mcd/global/global.jsp"%>
<%
    response.setHeader("Cache-Control","no-cache");
    response.setHeader("Cache-Control","no-store");
    response.setDateHeader("Expires", 0);
    response.setHeader("Pragma","no-cache"); 
    int flag = 0;
    String path = currentNode.getPath();
    String isDeleted = "false";
    if(path.indexOf("like_0")>-1) {
        flag = 1;                
    } else {    
        String nodeName = "";
        Node pageNode = resourceResolver.getResource(currentPage.getPath()+"/jcr:content").adaptTo(Node.class); 
        NodeIterator nodeIterator = pageNode.getNodes(); 
        while(nodeIterator.hasNext()){
            Node childNode = nodeIterator.nextNode();
            if(childNode.hasNodes()){
                NodeIterator childNodeIterator = childNode.getNodes();
                while(childNodeIterator.hasNext()){
                    Node subChildNode = childNodeIterator.nextNode();                
                    if(subChildNode.getName().equals("like") && (!subChildNode.getPath().equals(currentNode.getPath()))) {
                        flag = 1;
                        break;                        
                    }
                }
                
                if(flag == 1) {
                    break;
                }
            }        
        }
    }
    
    if(flag == 1) {
        Node parentNode = currentNode.getParent();
        currentNode.remove();
        parentNode.save();
        parentNode.refresh(true);
        isDeleted = "true";
    } 
%>

[{"deleted":"<%=isDeleted%>"}] 