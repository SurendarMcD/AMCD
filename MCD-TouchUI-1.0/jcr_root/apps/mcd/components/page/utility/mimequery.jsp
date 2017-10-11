<%/*
Lists recently updated files
Erik Wannebo 11/22/2010
*/
%>
<%@ page import="java.util.Calendar,
        java.text.SimpleDateFormat,
        java.util.*,
        java.io.*,
        javax.jcr.*,
        com.day.cq.search.*,
        com.day.cq.search.result.*,
        com.day.cq.search.facets.*,
        com.day.cq.search.writer.*,
        org.apache.jackrabbit.util.Text,
        com.day.cq.wcm.foundation.*,
        org.apache.sling.api.resource.*,
        com.mcd.accessmcd.ace.manager.ACEManager,
        com.mcd.accessmcd.ace.bo.ACEConfigDataBean,
        com.day.cq.security.* "%>
<%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects />
<HTML>
<head>
<script language='javascript'>
function openInCRXDE(path){
window.open("/crxde/#/crx.default/jcr%3aroot"+path);
}
</script>
</head>
<body style="font-family:arial">
<h2>Content Query</h2>
 
<%!
 
public static void getMimeTypes(JspWriter out,QueryBuilder builder,ResourceResolver resourceResolver){

try{ 
    String query="/jcr:root/content//*[ @jcr:mimeType!='' ]";
    Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
    out.write(query+"<br>");
    out.write("<table>");
    out.write("<thead style='border-bottom:1px solid black'><td><b>File</b></td><td><b>mimeType</b></td></thead>");
    int count=0; 
    while(result.hasNext()) { 
            if(count>10000000)break;
            count++;
            Resource r=(Resource)result.next();
            javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
            if (n != null) {
                String path = n.getPath();
                String outpath=""; 
                
                outpath+="<a target=_new href=\""+path+"\">"+path+"</a>";

                String mimeType=n.getProperty("jcr:mimeType").getString();
                
                out.write("<tr>");
                String cellstyle="";
                
               
                out.write("<td"+cellstyle+">"+outpath+"</td>");
                out.write("<td"+cellstyle+">"+mimeType+"</td>");
                out.write("</tr>");
                
            }
    }
  }catch(Exception e){
      try{
          out.println(e.getMessage());
      }catch(Exception ex){
      }
  }
    
}   

public static void getMimeCount(JspWriter out,QueryBuilder builder,ResourceResolver resourceResolver){

try{ 
    HashMap mimeMap=new HashMap();
    String query="/jcr:root/content//*[ @jcr:mimeType!='' ]";
    Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
    out.write(query+"<br>");
    int count=0; 
    while(result.hasNext()) { 
            if(count>10000000)break;
            count++;
            Resource r=(Resource)result.next();
            javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
            if (n != null) {
                String path = n.getPath();
                String outpath=""; 
                
                outpath+="<a target=_new href=\""+path+"\">"+path+"</a>";
                
                String mimeType=n.getProperty("jcr:mimeType").getString();
                if(mimeMap.containsKey(mimeType)){
                    mimeMap.put(mimeType,(((Integer)mimeMap.get(mimeType)).intValue())+1);
                }else{
                    mimeMap.put(mimeType,1);
                }

                
            }
    }
    
    //output results
    out.write("<table>");
    out.write("<thead style='border-bottom:1px solid black'><td><b>mimeType</b></td><td><b>count</b></td></thead>");
    Iterator iterMimes=mimeMap.keySet().iterator();
    while(iterMimes.hasNext()){
        String key=(String)iterMimes.next();
        String cellstyle="";
        out.write("<tr>");
        out.write("<td"+cellstyle+">"+key+"</td>");
        out.write("<td"+cellstyle+">"+mimeMap.get(key)+"</td>");
        out.write("</tr>");
    }
    out.write("</table>");

  }catch(Exception e){
      try{
          out.println(e.getMessage());
      }catch(Exception ex){
      }
  }
    
}   

public static void getFlexiBgColor(JspWriter out,QueryBuilder builder,ResourceResolver resourceResolver){

try{ 
    TreeMap colorPages=new TreeMap();
    String query="/jcr:root/content//*[ @backgroundColumnctrl!='' ]";
    Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
    out.write(query+"<br>");
    out.write("<table>");
    out.write("<thead style='border-bottom:1px solid black'>");
    out.write("<td><b>Page</b></td>");
    out.write("<td><b>Author</b></td>");
    out.write("<td><b>Publish</b></td>");
    out.write("<td><b>Column Colors</b></td>");
    out.write("</thead>");
    int count=0; 
    String lastparent="";
    while(result.hasNext()) { 
            if(count>1000)break; 
            count++;
            Resource r=(Resource)result.next();
            javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
            int colcount=0;
            String colorlist="";
            if (n != null) {
                String path = n.getPath();
                javax.jcr.Node parnode=n.getParent();
                boolean bShow=false;
                if(!parnode.getPath().equals(lastparent)){
                    //out.println(parnode.getPath()+"<br>");
                    NodeIterator iternodes=parnode.getNodes();
                    colcount=1;
                    
                    String flexibgcolor="";
                    
                    String[] colors=null;
                    while(iternodes.hasNext() && !bShow){
                       javax.jcr.Node child=iternodes.nextNode();
                       String restype="";
                       if(child.getPath().contains("ptw"))out.println(child.getPath()+"<br>");
                       try{
                           try{
                               restype=child.getProperty("sling:resourceType").getString();
                           }catch(Exception e){}
                           if(restype.equals("mcd/components/content/parsys/colctrl")){
                               try{
                                   flexibgcolor=n.getProperty("backgroundColumnctrl").getString();
                                   colors=flexibgcolor.split(":");
                               }catch(Exception e){}
                               String controltype="";
                               try{
                                   controltype=child.getProperty("controlType").getString();
                               }catch(Exception e){}
                               if(controltype.equals("break")){
                                   
                                   colcount++;
                                   if(colors.length>=colcount){
                                       if(!colors[colcount-1].equals(colors[colcount-2])){
                                           bShow=true;
                                           out.println("<br>changed color "+child.getPath()+" col:"+colcount+" "+flexibgcolor); 
                                       }
                                   }
                               }
                               if(controltype.equals("end")){
                                   colcount=1;
                               }                 
                           }
                           }catch(Exception e){
                           out.println("Exception:"+e.getMessage());
                           }
                    }
                
                    String url=path.substring(0,path.indexOf("/jcr:content"))+".html";
                    String outpath=""; 
                    
                    outpath+="<a target=_new href=\""+url+"\">"+path+"</a>";
    
                    if(((!path.contains("/train/") && !path.contains("/test/")) && bShow)){
                            if(colorPages.containsKey(url)){
                                colorPages.put(url,(((String)colorPages.get(url)))+"<br>"+colorlist);
                            }else{
                                colorPages.put(url,colorlist);
                            }
                    } 
                }
                lastparent=parnode.getPath();
            }
    }
    
    //output

    Iterator iterPages=colorPages.keySet().iterator();
    count=0;
    while(iterPages.hasNext()){
        String key=(String)iterPages.next();
        String cellstyle="";
        out.write("<tr>");
        String authlink="<a target=_new href=\"https://author.accessmcd.com"+key+"\">Author</a>";
        String publink="<a target=_new href=\"https://www.accessmcd.com"+key+"\">Publish</a>"; 
        out.write("<td"+cellstyle+">"+key+"</td>");
        out.write("<td"+cellstyle+">"+authlink+"</td>");
        out.write("<td"+cellstyle+">"+publink+"</td>");
        out.write("<td"+cellstyle+">"+colorPages.get(key)+"</td>");
        out.write("</tr>");
        count++;
    }
    out.write("</table>");
    out.write("<br>count:"+count);
  }catch(Exception e){
      try{
          out.println(e.getMessage());
      }catch(Exception ex){
      }
  }
    
}   


public static void getFlexiBgColor2(JspWriter out,QueryBuilder builder,ResourceResolver resourceResolver){

try{ 
    TreeMap colorPages=new TreeMap();
    String query="/jcr:root/content//*[ @backgroundColumnctrl!='' ]";
    Iterator<Resource> result = resourceResolver.findResources(query,javax.jcr.query.Query.XPATH);
    out.write(query+"<br>");
    out.write("<table>");
    out.write("<thead style='border-bottom:1px solid black'>");
    out.write("<td><b>Page</b></td>");
    out.write("<td><b>Author</b></td>");
    out.write("<td><b>Publish</b></td>");
    out.write("<td><b>Column Colors</b></td>");
    out.write("</thead>");
    int count=0; 
    String lastparent="";
    while(result.hasNext()) { 
            if(count>1000000)break; 
            count++;
            Resource r=(Resource)result.next();
            javax.jcr.Node n = r.adaptTo(javax.jcr.Node.class);
            
            int colcount=0;
            String colorlist="";
            if (n != null) {
                String path = n.getPath();
               
                boolean bShow=false;
                String flexibgcolor="";
                String layout="";    
                String[] colors=null;
                try{
                       flexibgcolor=n.getProperty("backgroundColumnctrl").getString();
                       layout=n.getProperty("layout").getString();
                       colors=flexibgcolor.split(":");
                       if(colors.length>1 && colors[0].equals(""))colors[0]=colors[1];
                       if(colors.length>1 && colors[1].equals(""))colors[1]=colors[0];
                       if(colors.length>2 && colors[2].equals(""))colors[2]=colors[1];
                       
                           if(layout.startsWith("1") && !flexibgcolor.startsWith("sitecolor2")){
                               bShow=true;
                           }
                           if(layout.startsWith("2") && (colors.length>1 && !colors[1].equals(colors[0]))){
                               bShow=true;
                           }
                           if(layout.startsWith("3") && (colors.length>2 && !colors[2].equals(colors[1]))){
                               bShow=true;
                           }
                           
                   }catch(Exception e){}
                                               
                    String url=path.substring(0,path.indexOf("/jcr:content"))+".html";
                    String outpath=""; 
                    
                    outpath+="<a target=_new href=\""+url+"\">"+path+"</a>";
    
                    if(((!path.contains("/train/") && !path.contains("/test/")) && bShow)){
                            if(colorPages.containsKey(url)){
                                colorPages.put(url,(((String)colorPages.get(url)))+"<br>"+flexibgcolor);
                            }else{
                                colorPages.put(url,flexibgcolor);
                            }
                    } 
                    }

            }
    
    //output

    Iterator iterPages=colorPages.keySet().iterator();
    count=0;
    while(iterPages.hasNext()){
        String key=(String)iterPages.next();
        String cellstyle="";
        out.write("<tr>");
        String authlink="<a target=_new href=\"https://author.accessmcd.com"+key+"\">Author</a>";
        String publink="<a target=_new href=\"https://www.accessmcd.com"+key+"\">Publish</a>"; 
        out.write("<td"+cellstyle+">"+key+"</td>");
        out.write("<td"+cellstyle+">"+authlink+"</td>");
        out.write("<td"+cellstyle+">"+publink+"</td>");
        out.write("<td"+cellstyle+">"+colorPages.get(key)+"</td>");
        out.write("</tr>");
        count++;
    }
    out.write("</table>");
    out.write("<br>count:"+count);
  }catch(Exception e){
      try{
          out.println(e.getMessage());
      }catch(Exception ex){
      }
  }
    
}  


%>
<%
long starttime=System.currentTimeMillis();
QueryBuilder builder = resourceResolver.adaptTo(QueryBuilder.class);
Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);

//getMimeCount(out,builder,resourceResolver);
getFlexiBgColor2(out,builder,resourceResolver);
out.write("elapsed: "+(System.currentTimeMillis()-starttime)/1000.0+"s.");
 
%>
</body>
</html>