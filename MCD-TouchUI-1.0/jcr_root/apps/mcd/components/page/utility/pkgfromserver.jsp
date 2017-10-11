<%--
  variation on /libs/packaging/components/manager/POST.jsp
  
  to copy package contents from server

  Erik Wannebo 5/11/2010
  
--%><%@page session="false"
            contentType="text/html"
            pageEncoding="utf-8"
            import="java.io.*,
                    javax.jcr.Node,
                    javax.jcr.Session,
                    javax.jcr.Repository,
                    javax.jcr.Property,
                    org.apache.jackrabbit.JcrConstants,
                    org.apache.commons.io.FileUtils,
                    org.apache.commons.io.IOUtils,
                    org.apache.sling.api.SlingHttpServletRequest,
                    org.apache.sling.api.request.RequestParameter,
                    org.apache.sling.api.servlets.HtmlResponse,
                    com.day.cq.commons.servlets.HtmlStatusResponseHelper,
                    com.day.jcr.vault.packaging.JcrPackage,

                    com.day.jcr.vault.packaging.JcrPackageManager" %><%
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><sling:defineObjects /><%

    String pkgname=request.getParameter("pkgname");
    if(pkgname==null || pkgname.equals("")){
        out.write("Please provide a package name.");
        return;
    }
    String serverfile=request.getParameter("serverfile");
    if(serverfile==null || serverfile.equals("")){
        out.write("Please provide a output server file name.");
        return;
    }
    String pkglocation="etc/packages/"+pkgname;
    
    String pkginfile=serverfile;
    Node node = slingRequest.getResource().adaptTo(Node.class);
    Session session=node.getSession();
    Node root=session.getRootNode();
    Node n = root.getNode(pkglocation);
    Node contentNode = n.getNode(JcrConstants.JCR_CONTENT);
    FileInputStream is = new FileInputStream(pkginfile);
    //InputStream is=p.getStream();
    //    IOUtils.copy(p.getStream(), outfile);
    contentNode.setProperty(JcrConstants.JCR_DATA,is);
    session.save();
    is.close();
    out.write(pkginfile+" <br>copied to<br> "+pkgname);
    %> 