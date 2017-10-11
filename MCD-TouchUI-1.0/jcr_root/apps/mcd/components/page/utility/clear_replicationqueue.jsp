<%@page session="false"
        contentType="text/html"
        pageEncoding="utf-8"
        import="com.day.cq.commons.TidyJSONWriter,
            com.day.cq.replication.ReplicationAction,
            com.day.cq.replication.ReplicationQueue,
            com.day.cq.replication.Agent,
            com.day.cq.replication.AgentManager,
            java.util.HashSet" %><%
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %><%
%><cq:defineObjects /><%

    String agentId = currentPage.getName();
    agentId="www_accessmcd_flush118";
    agentId=request.getParameter("agentid");
    String filter=request.getParameter("filter");
    String delete=request.getParameter("delete");
    boolean bDelete=false;
    if(filter==null)filter="";
    if(delete!=null && delete.equals("yes"))bDelete=true;
    if(agentId==null){
%>
<head><title>Replication Agent Pending Queue</title></head>
<font color=red>Enter an agentid</FONT>
<%
        agentId="";
    }
%>
<FORM action="" method=GET>
Agent ID:<INPUT size=80 name=agentid value=<%=agentId%>><br>
Path Contains:<INPUT size=80 name=filter value=<%=filter%>><br>
Delete?:<INPUT size=3 name=delete value=><br>
<INPUT type=submit>
</FORM><BR>
Queue:<br>
<%
    AgentManager agentMgr = sling.getService(AgentManager.class);
    Agent agent = agentId == null ? null : agentMgr.getAgents().get(agentId);
    ReplicationQueue queue = agent == null ? null : agent.getQueue();
    ReplicationQueue.Status status = queue == null ? null : queue.getStatus();
    /*
    TidyJSONWriter w = new TidyJSONWriter(out);
    w.setTidy(true);
    w.object();
    w.key("metaData").object();
        w.key("root").value("queue");
        w.key("queueStatus").object();
            if (agent != null && agent.getConfiguration().getName() != null) {
                w.key("agentName").value(agent.getConfiguration().getName());
            }http://mcdeagsun105b.mcd.com:4211/crx/de/index.jsp#
            w.key("agentId").value(agentId);
            if (status != null) {
                w.key("isBlocked").value(status.getNextRetryTime() > 0);
                w.key("isPaused").value(queue.isPaused());
                w.key("time").value(status.getStatusTime());
                w.key("processingSince").value(status.getProcessingSince());
                w.key("lastProcessTime").value(status.getLastProcessTime());
                w.key("nextRetryPeriod").value(status.getNextRetryTime() - status.getStatusTime());
            }
        w.endObject();
        w.key("fields").array();
            w.value("id");
            w.value("path");
            w.value("time");
            w.value("userid");
            w.value("type");
            w.value("lastProcessed");
            w.value("numProcessed");
        w.endArray();
    w.endObject();
    w.key("queue").array();
    */
    if (queue != null) {
        // limit to 50 entries
        HashSet setDelete=new HashSet();
        int maxSize = 5000;
        int intToDelete=0;
        for (ReplicationQueue.Entry entry: queue.entries()) {
            //w.object();
            ReplicationAction action = entry.getAction();
            int intQP=entry.getQueuePosition();
            String idREP=entry.getId();
            /*
            long lastProcessed = entry.getLastProcessTime() == null ? 0 : entry.getLastProcessTime().getTimeInMillis();
            
            w.key("id").value(entry.getId());
            w.key("path").value(action.getPath());
            w.key("time").value(action.getTime());
            w.key("userid").value(action.getUserId());
            w.key("type").value(action.getType().getName());
            w.key("lastProcessed").value(lastProcessed);
            w.key("numProcessed").value(entry.getNumProcessed());
            w.endObject();
            */
           if(action.getPath().contains(filter)){
                out.println("<font color=red>DELETE ID"+idREP+"</font>");
                setDelete.add(idREP);
                intToDelete++;
            }
             out.println(intQP+","+action.getType().getName()+","+action.getPath()); 
            
            out.println("<br>");
            if (--maxSize == 0) {
                break;
            }
        }
        if(bDelete){
            out.println("CLEARING:"+setDelete.size()); 
            queue.clear(setDelete);
            out.println("<br>CLEARED."+setDelete.size()); 
        }else{
            out.println("TO BE DELETED: "+setDelete.size()); 
        }
        
    }
    //w.endArray();
    //w.endObject();
%>