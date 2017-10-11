<%@include file="/apps/mcd/global/global.jsp"%>  
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.day.cq.security.User,com.mcd.accessmcd.like.manager.impl.LikeManagerImpl"%>
<%

boolean hover = false;
int likeCountNum = 0;
final User user = slingRequest.getResourceResolver().adaptTo(User.class);//instantiate User object
String userId = user.getID();
String path = (request.getParameter("path")!= null) ? request.getParameter("path").toString().trim() : "";
LikeManagerImpl likeManagerImpl = new LikeManagerImpl();
hover = likeManagerImpl.getUser(userId,path,sling);
likeCountNum = likeManagerImpl.likeCount(sling,path); 
%>

{"results":{"hover":"<%=hover%>","likeCountNum":"<%=likeCountNum%>"}}  