<%@ page import="com.mcd.accessmcd.common.helper.*,
 java.util.*, 
 com.mcd.accessmcd.common.Constants,
 com.mcd.accessmcd.util.CommonUtil"%>
  <%     
         //AudienceTypeJson aType=new AudienceTypeJson();
        //String  json=aType.getAudienceTypeJson(); 
 HashMap audienceTypes; 
        audienceTypes = new HashMap();
        audienceTypes= CommonUtil.getAudienceType();
        String json="[";
        String []at=Constants.AUDIENCE_TYPE_LIST;
        
        for(int k=0;k<at.length;k++)
          {
                if(k==0){json=json+"{'text':'"+audienceTypes.get(at[k])+"','value':'"+at[k]+"'}";}
                else
                {json=json+",{'text':'"+audienceTypes.get(at[k])+"','value':'"+at[k]+"'}";}
                
           }
            
           json=json+"]"; 

%>
<%=json%>