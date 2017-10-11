<%@include file="/libs/wcm/global.jsp"%><%
%><%@ page import="org.apache.sling.jcr.api.SlingRepository"%><%
%><%@ page import="com.mcd.ldap.McdService"%><%
%><%@ page import="java.util.*"%><%
%><%McdService service = sling.getService(McdService.class);%><%
%><html>

<head>
<title>McDonald's CQ5 - Load Users Page</title>

</head>


<body>
   <form action="<%=currentPage.getPath()%>.html">
        <input type="hidden" name="hidAction" value="dsd"/><% 
           String hidAction = (String) request.getParameter("hidAction");
	       if(hidAction != null){
	    	   if(hidAction.equals("LoadEID")){
	    		   String id = (String) request.getParameter("id");
	    		   out.println(service.loadUserById(id));
	    	   } else if(hidAction.equals("LoadEIDs")){
	               String ids = (String) request.getParameter("ids");
	               
	               List<String> idList = new ArrayList();

	               // parse comma-separated IDs into a List
	               StringTokenizer tok = new StringTokenizer(ids, ",");
	               while (tok.hasMoreTokens()) {
	            	   String id = tok.nextToken();
	            	   if (id != null && id.trim().length() > 0) {
	            		   idList.add("uid=" + id);     
	            	   }
	               }
	               out.println(service.loadUsersByIds(idList));
	    	   } else if(hidAction.equals("LoadEIDByFilter")){
	    		   String filter = (String) request.getParameter("searchFilter");
	    		   out.println(service.loadUsersBySearchFilter(filter));
	    	   }
	       } 
	    %>
	    
	    <h3>Load Users Page</h3><br>
	    Enter the EID of the user that will be loaded:<br>
	    <input type="text" name="id"></input>&nbsp;
	    <input type="submit" onclick="this.form.hidAction.value='LoadEID';" value="LoadEID" />
	    <br><br><br>
	    
	    Enter the EIDs (comma-delimited) of the users that will be loaded:<br>
	    <textarea name="ids" rows="10" cols="50"></textarea>&nbsp;
	    <input type="submit" onclick="this.form.hidAction.value='LoadEIDs';" value="Load EIDs" />
	    <br><br><br>
	    
	    Enter the ldap searchFilter of the users that will be loaded:<br>
	    Example: (uid=eswp0001)<br>
	    <input type="text" size="200" name="searchFilter"></input>&nbsp;
	    <input type="submit" onclick="this.form.hidAction.value='LoadEIDByFilter';" value="Load EID By LDAP Filter" />
	    
    </form>
</body>
</html>
<%--=service.executeService()--%>