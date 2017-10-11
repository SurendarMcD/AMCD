<%--
  wei for updating pci old entries  
--%>
<%@include file="/apps/mcd/global/global.jsp"%>
<%@ page session="false" %>
<%@ page import="java.util.*, 
                java.net.*,
                java.io.*,
                java.lang.*,
                javax.jcr.Session, 
                java.util.Date,
                java.text.DateFormat,
                java.text.SimpleDateFormat"%>
<html>
<head> 
<title>Update PCI Entry</title>
</head>
<body >

<%!
    private int count = 0;
    private int updatedCount = 0;
      
    private String pciScan(String handle, Session jcrSession, String updateFlag, Writer output, StringBuffer sb) {
            
         try {
             javax.jcr.Node nd = jcrSession.getRootNode();
                        
             int last= handle.lastIndexOf("/");
             int first = handle.indexOf("/content/");
             String jcrPath=handle.substring(first+1,last)+"/jcr:content";
                 
             count++;
             sb.append(count + ". " + handle);
             //output.write(count + ". " + handle);   
                    
             //get pci path                 
             String pciPath=jcrPath+"/pci";
             
            // boolean hasPciNode = nd.hasNode(pciPath);
             if (nd.hasNode(pciPath)) {
                 Node pciNode = nd.getNode(pciPath);
              
                 //get pci nodes size
                 Iterator pci = pciNode.getNodes("entry*");
                 int entrySize = 0;
           
                 while (pci.hasNext()) {
                      Node entryNode = (Node) pci.next();
                      entrySize++;
                 }
                
                 //sb.append(" --- size=" + entrySize);
                     
                  //if only 1
                 if (entrySize == 1 && pciNode.hasNode("entry1")) {
                     //out.println("has only one entry...");
                  
                     Node entry1 = pciNode.getNode("entry1");
                 
                     if(!entry1.hasProperty("Category")) {
                         if (entry1.hasProperty("PublishDate") && entry1.hasProperty("DisplayType")) {
                       // out.println("publishDate=" + entry1.getProperty("PublishDate").getString());
                        //set property
                            if (updateFlag.equals("1")) {
                                entry1.setProperty("PublishDate", (Value)null);
                                entry1.setProperty("DisplayType", (Value)null);
                                entry1.save();
                            
                                sb.append(" --- <font color=red>updated</font><br>");
                                //output.write(" --- updated\n");
                            } else {
                                sb.append(" --- <font color=red>need update this</font><br>");
                                //output.write(" --- need update this\n");
                            }
                            updatedCount++;
                        }
                        else {
                            sb.append("<br>");
                            //output.write("\n");
                            //sb.append(" --- don't have publishDate/DisplayType (no action)<br>");
                        }
                     } else {
                          sb.append("<br>");
                          //output.write("\n");
                          //sb.append(" --- has category old data (no action)<br>");
                     }
                  } //end of size 1
                  else {
                     sb.append("<br>");
                     //output.write("\n");
                     //sb.append(" --- not entry1<br>");
                  }
               } else {
                     sb.append("<br>");
                    // output.write("\n");
                     //sb.append(" --- no pci node (no action)<br>");
               }
           
                  
            int first1 = handle.indexOf("/content/");
            String pgPath=handle.substring(first1+1);
      
            javax.jcr.Node pgNode = nd.getNode(pgPath);
           
           //if nd page has child...
            NodeIterator ndItor = pgNode.getNodes();
          
            if (ndItor!=null){
                while (ndItor.hasNext()) {
                    Node childNode = ndItor.nextNode();
                    String childPath = childNode.getPath();
                                   
                    if(childNode.hasNodes()) {
                        if(childNode != null&& childPath.indexOf(":")< 0) {
                            childPath = childPath + "/";
                           
                            pciScan(childPath, jcrSession, updateFlag, output, sb);
                        }
                  }
            
                }
            }
            
            String temp = "";
            if (updateFlag.equals("1")) {
                temp = "<br><b>Total pages scanned: " + count + ", updated pages: " + updatedCount + ".</b>";
            } else {
                temp = "<br><b>Total pages scanned: " + count + ", need to update: " + updatedCount + " pages.</b>";
            }
            temp = sb.toString() + temp;
            
            return temp;   
           
         }catch (Exception e) {    
             return e.getMessage();
         }
         
    }
    
    private void resetCount() {
        count = 0;
        updatedCount = 0;
    }
    
    private String replaceString (String target, String from, String to) {   
        // target is the original string
        // from   is the string to be replaced
        // to     is the string which will used to replace
        int start = target.indexOf (from);
        if (start==-1) return target;
        int lf = from.length();
        char [] targetChars = target.toCharArray();
        StringBuffer buffer = new StringBuffer();
        int copyFrom=0;
        while (start != -1) {
            buffer.append (targetChars, copyFrom, start-copyFrom);
            buffer.append (to);
            copyFrom=start+lf;
            start = target.indexOf (from, copyFrom);
        }   
        buffer.append (targetChars, copyFrom, targetChars.length-copyFrom);
        return buffer.toString();
    }
%>
   
<% 
        Writer output = null;
        StringBuffer sb = new StringBuffer();
        String temp = ""; 
        
        try {
      
        out.println("<b>start...</b><br>");
        
        String handle = slingRequest.getParameter("handle");
        String updateFlag = slingRequest.getParameter("updateFlag");
        
        if (handle == null || updateFlag == null) 
            out.println("Please input the root page handle and update flag<br>");
        else
            out.println("handle=" + handle + "<br>updateFlag=" + updateFlag + "<br>");
        //String handle = "/content/accessmcd/wtest/";
         // files made at the server to record the change 
                           
        Session jcrSession = slingRequest.getResourceResolver().adaptTo(Session.class);  
        String returnValue = pciScan(handle, jcrSession, updateFlag, output, sb);
        
        if (returnValue != null)         
            out.println(returnValue);
        
        resetCount();
        
        if (updateFlag.equals("1")) {
            String logpath = "/app/mcd/cms/fs04/wcm1_auth_prod/crx-quickstart/server/files/updatepcientrylogs/";
         
            DateFormat dateFormat = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");
            Date date = new Date();
            //out.println(dateFormat.format(date));
            //String fileName = "updatepcientries.log";
            String fileName = "updatepcientries_" + dateFormat.format(date) + ".log";
             
            File file = new File(logpath + fileName);
            output = new BufferedWriter(new FileWriter(file));
            //replace string
            
            temp = replaceString(returnValue, "<br>", "\n");
            temp = replaceString(temp, "<font color=red>", "");
            temp = replaceString(temp, "</font>", "");
            temp = replaceString(temp, "<b>", "");
            temp = replaceString(temp, "</b>", "");
            output.write(temp);
        }  
        
        }catch (Exception e) {
            out.println(e.getMessage());
            e.printStackTrace();
        } finally {
      
           try{
           if(output!=null)
               output.close();
           
           }catch(Exception e2){
           }
        }
%>
    
</body>
</html>
