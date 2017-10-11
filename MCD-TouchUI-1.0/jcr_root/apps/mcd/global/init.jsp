<%--
  Copyright 1997-2008 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Default init script.

  Draws the WCM initialization code. This is usually called by the head.jsp
  of the page. If the WCM is disabled, no output is written.

  ==============================================================================

--%><%@include file="/apps/mcd/global/global.jsp" %><%
%><%@page import="com.day.cq.wcm.api.WCMMode,
    com.day.cq.widget.HtmlLibraryManager" %><%
if (WCMMode.fromRequest(request) != WCMMode.DISABLED) {
    HtmlLibraryManager htmlMgr = sling.getService(HtmlLibraryManager.class);
    if (htmlMgr != null) {
        htmlMgr.writeCssInclude(slingRequest, out, "cq.wcm.edit");
        htmlMgr.writeJsInclude(slingRequest, out, "cq.wcm.edit","mcd.widgets");
    }
    String dlgPath = null;
    if (editContext != null && editContext.getComponent() != null) {
        dlgPath = editContext.getComponent().getDialogPath();
    }
    %>
    <script type="text/javascript" >
        var fct = function() {
            CQ.WCM.launchSidekick("<%= currentPage.getPath() %>", {
                propsDialog: "<%= dlgPath == null ? "" : dlgPath %>",
                locked: <%= currentPage.isLocked() %>
            });
        };
        window.setTimeout(fct, 1);
    </script><%
}
%>
