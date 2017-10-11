
<%-- 
  ==============================================================================
  Content Map
  A treemap visualization of the CQ5 content tree
  Erik Wannebo 6/13/2011
  ==============================================================================
--%>
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page session="false" %>
<%@ page import="java.util.*, 
                java.net.*,
                java.io.*,
                javax.jcr.*,
                javax.jcr.security.*,
                java.security.Principal,
                com.day.cq.security.util.CqActions,
                org.apache.sling.api.*,
                org.apache.jackrabbit.api.*,
                org.apache.jackrabbit.api.security.*,
                org.apache.jackrabbit.api.security.user.*,
                com.day.cq.wcm.foundation.Paragraph,
                com.day.cq.wcm.foundation.ParagraphSystem
                "%>

<%!
   public String toK(long filesize){
       long fileinK=Math.round(filesize/1000);
       return fileinK+"K";
   }
    public long calcPageSize(Node node){

     long ret=0L;
 
     try{ 
     PropertyIterator props=node.getProperties();
     while (props.hasNext()) {
         Property prop=props.nextProperty();
         ret+=prop.getLength(); 
         //System.out.println(prop.getName()+ " Length:"+prop.getLength());                                      
     
     }
     }catch(RepositoryException re){
         //System.out.println("Repository Exception 1:"+re.getMessage());
     } 
     
     try{
     NodeIterator childnodes=node.getNodes();      
     while (childnodes.hasNext()) {
         Node childnode=childnodes.nextNode();
         ret+=calcPageSize(childnode);
     }
     
     }catch(RepositoryException re){
         //System.out.println("Repository Exception 2:"+re.getMessage());
     } 
     
     return ret;
}

       public long calcTreeSize(Node node, int currentDepth){
        long treesize=0;
        if(currentDepth>30)return 0;
        try{
        
        Node contentnode=node.getNode("jcr:content");
        long pagesize=calcPageSize(contentnode);
        //System.out.println(node.getPath()+" Page size:"+pagesize);
        
        treesize+=pagesize;
        NodeIterator niter=node.getNodes();
        while(niter.hasNext()){
            Node child=niter.nextNode();
            if(!child.getName().equals("jcr:content"))
                  treesize+=calcTreeSize(child,currentDepth+1);
        }

        }catch(Exception e){
            
        }
        return treesize;
        
    }
    
   public String queryHierarchy(JspWriter out, Node node, int level,int maxlevel,String color){;
        try{
         
            
           //Node contentnode=node.getNode("jcr:content");
           String[] colors={"red","blue","purple","green"};
           String strComma="";
           String strNodeName="";
           
           if(node.hasNode("jcr:content")){
               Node contentnode=node.getNode("jcr:content");
               if(contentnode!=null && contentnode.hasProperty("jcr:title"))
                 strNodeName=contentnode.getProperty("jcr:title").getString();
           }
           if(strNodeName=="")strNodeName=node.getName();
           
                 
           String newcolor=colors[(int)(Math.random()*colors.length)];
           out.println("{");
           out.println("\"children\" : ["); 
           
           if(level<maxlevel){
               NodeIterator niter=node.getNodes();
                while(niter.hasNext()){
                    Node child=niter.nextNode();
                    if(!child.getName().equals("jcr:content") && !child.getName().equals("rep:policy")){
                         out.println(strComma);
                         strComma=",";
                         queryHierarchy(out,child,level+1,maxlevel,newcolor);
                    }
                }
            }
           //
            

            out.println("],");
            out.println("\"data\" : {");
            long treesize=0;
            long treesizeK=0;
            double treesizeM=0;
            if(level==maxlevel){
                 treesize=calcTreeSize(node,1);
                 treesizeK=((int)(treesize/1000));
                 if(treesizeK<1)treesizeK=1;
                 //System.out.println(node.getPath()+" page treesize: "+treesize);
                 treesizeM=Math.round(treesize/100000)/10.0;
                 
                 newcolor=color;
                 //treesize=10;
            }
            out.println("\"$area\" : "+treesizeK +"," );
            out.println("\"$color\" : \""+newcolor+"\"," );
            
            out.println("\"description\" : "+treesizeM );
            out.println("},");
            out.println("\"id\" : \""+node.getPath()+"\",");
            out.println("\"name\" : \""+strNodeName+"\"");
            out.println("}");

        }catch(Exception e){
            try{
                out.println(e.getMessage());
               }catch(Exception ex){
               }
        }
        return "";
     }
     
%>
<%
//JackrabbitSession session=request.getNode().getSession();
Session session = slingRequest.getResourceResolver().adaptTo(Session.class);
if(session==null){
    out.write("null session");
    return;
}
Node root=session.getRootNode();
//ACLManager aclmgr=session.getACLManager();
//out.write("root:"+root.getName());

String path=request.getParameter("path");

Node contentNode=null;
if(path==null || path.equals("")){
    path="content/accessmcd";    
}
contentNode=root.getNode(path);

int depth = 3;
String pDepth=request.getParameter("depth");
if(pDepth!=null)
    depth=Integer.parseInt(pDepth);

%>
<html>
<title>Content Map</title>
<head>
<link type="text/css" href="/scripts/jit/base.css" rel="stylesheet" />
<link type="text/css" href="/scripts/jit/Treemap.css" rel="stylesheet" />

<!--[if IE]><script language="javascript" type="text/javascript" src="/scripts/jit/excanvas.js"></script><![endif]-->

<!-- JIT Library File -->
<script language="javascript" type="text/javascript" src="/scripts/jit/jit.js"></script>

<script language=Javascript>

var contentTree=<%= queryHierarchy(out,contentNode,1,depth,"black") %>;

var labelType, useGradients, nativeTextSupport, animate;

(function() {
  var ua = navigator.userAgent,
      iStuff = ua.match(/iPhone/i) || ua.match(/iPad/i),
      typeOfCanvas = typeof HTMLCanvasElement,
      nativeCanvasSupport = (typeOfCanvas == 'object' || typeOfCanvas == 'function'),
      textSupport = nativeCanvasSupport 
        && (typeof document.createElement('canvas').getContext('2d').fillText == 'function');
  //I'm setting this based on the fact that ExCanvas provides text support for IE
  //and that as of today iPhone/iPad current text support is lame
  labelType = (!nativeCanvasSupport || (textSupport && !iStuff))? 'Native' : 'HTML';
  nativeTextSupport = labelType == 'Native';
  useGradients = nativeCanvasSupport;
  animate = !(iStuff || !nativeCanvasSupport);
})();

function getContentTree(){
    var retTree={}
    retTree.data={};
    retTree.id="root";
    retTree.name="CQ5 Content";
    retTree.children=[];
    
    for(var i=0;i<5;i++){
        var child={};
        child.children=[];
        child.data={};
        child.data.$area=1*i;
        child.data.$color="#123456";
        child.data.description="Test "+i;
        child.id=i;
        child.name=i;
        retTree.children.push(child);
    }
    //update parent areas
    //updateAreas(retTree);
    return retTree;
}

function updateAreas(treenode){
    var totarea=0;
    if(treenode.children.length>0){
    for(var i=0;i<treenode.children.length;i++){
        totarea+=updateAreas(treenode.children[i]);
    }
    treenode.data.$area=totarea;
        var sizeM=Math.round((1*treenode.data.$area)/100)/10; 
        treenode.data.description=sizeM;
    }else{
    totarea=treenode.data.$area;
    }
    return totarea;
    
}

function init(){

  //init TreeMap
  var tm = new $jit.TM.Squarified({
    //where to inject the visualization
    injectInto: 'infovis',
    titleHeight: 15,
    animate: animate,
    offset: 1,
    //Attach left and right click events
    Events: {
      enable: true,
      onClick: function(node) {
        if(node) tm.enter(node);
      },
      onRightClick: function() {
        tm.out();
      }
    },
    duration: 1000,
    //Enable tips
    Tips: {
      enable: true,
      //add positioning offsets
      offsetX: 20,
      offsetY: 20,
      //implement the onShow method to
      //add content to the tooltip when a node
      //is hovered
      onShow: function(tip, node, isLeaf, domElement) {
        var html = "<div class=\"tip-title\">" + node.name 
          + "</div><div class=\"tip-text\">";
        var data = node.data;
        html += "<br>"+node.id+"";
        if(data.description){ 
          //html += "<br><i>"+data.description+" M</i>";
          if(data.description>1000){
              var dataG=Math.round(data.description/100)/10
              html += "<br><i>"+dataG+" G</i>";
          }else{
              html += "<br><i>"+data.description+" M</i>";
          }
          
          }
        if(data.image) 
          html += "<img src=\""+ data.image +"\" class=\"album\" />";
        tip.innerHTML =  html; 
      }  
    },
    //Add the name of the node in the correponding label
    //This method is called once, on label creation.
    onCreateLabel: function(domElement, node){
        domElement.innerHTML = node.name;
        var style = domElement.style;
        style.display = '';
        style.border = '1px solid transparent';
        domElement.onmouseover = function() {
          style.border = '1px solid #9FD4FF';
        };
        domElement.onmouseout = function() {
          style.border = '1px solid transparent';
        };
    }
  });
  //var ContentTree=getContentTree();
//  var ContentTree =getContentTree();
  updateAreas(contentTree);
  tm.loadJSON(contentTree);
  tm.refresh();
  }
   
</script>

</head>

<body onload="init();" >

<div id="center-container">
    <div id="infovis"></div>    
</div>

</body>
</html> 
