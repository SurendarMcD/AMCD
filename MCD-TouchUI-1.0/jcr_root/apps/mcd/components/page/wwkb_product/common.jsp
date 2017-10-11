<%-- 
  
 Compiles a JSP-to populate list of the available checkboxes from property file in the dialog

--%><%
%>
<%@ page import="java.util.StringTokenizer, 
                 java.lang.StringBuffer"%>  
                 
                 
<%@include file="/apps/mcd/global/global.jsp"%>
[
<% 
    Properties CategoryPath = PropertiesLoader.loadProperties("common.properties");
    String seperator = "";
    String delimiter1="";
    String delimiter2="";
    String delimiter3="";
    String delimiter4="";
    String key = "";
    String value = "";
    String test=request.getParameter("country");
    String val[]=null;
    String[] temp=null;
    String list=request.getParameter("type");
    String aowValue = request.getParameter("aowValue")!=null? request.getParameter("aowValue") : "";
    String[] country = null;
    if(list.equals("areaOfTheWorld"))
    {
    delimiter1="/";
    delimiter2=",";
    delimiter3="\\|";
    delimiter4="_";
    }
    else{
    delimiter1="|";
    delimiter2=",";
    }
    
    try {
     
        //Get list from common.properties
        if(CategoryPath != null) {
        String CategoryText=CategoryPath.getProperty(list);
            StringTokenizer st= new StringTokenizer(CategoryText,delimiter1);
            while(st.hasMoreTokens()) {
                String tmp = st.nextToken();
                val=tmp.split(delimiter2);
                key = val[0]; 
                if(list.equals("areaOfTheWorld")){  
                    if(null != test && test.equals("true") && aowValue.equals(val[0])){
                        temp=val[1].split(delimiter3);
                        for(int i=0; i<temp.length; i++) {
                           country=temp[i].split(delimiter4);
                           %><%= seperator %><%
                           %>{<%
                           %>"text":"<%=country[0]%>",<%
                           %>"value":"<%=country[0]%>"<% 
                           %>}<%  
                           if ("".equals(seperator)) seperator = ",";
                        }
                        break;
                    } else if(null!=test && test.equals("true")) {
                        continue;                    
                    } else {
                        %><%= seperator %><%
                        %>{<%
                        %>"text":"<%=key%>",<%
                        %>"value":"<%=key%>"<% 
                        %>}<%  
                        if ("".equals(seperator)) seperator = ",";
                    }                                        
                } 
                else{ 
                    value = val[1];    
                    %><%= seperator %><%
                    %>{<%
                    %>"text":"<%=key%>",<%
                    %>"value":"<%=value%>"<% 
                    %>}<%  
                    if ("".equals(seperator)) seperator = ",";      
                }  
            }
        }
        else {
            log.error("List not found.");
        }
    }
    catch (Exception e) {
        log.error("Exception in List JSP"+e); 
    }
%>     
]  
 