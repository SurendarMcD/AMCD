<%@include file="/apps/mcd/global/global.jsp"%>  
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.day.cq.security.User,com.mcd.accessmcd.like.manager.impl.LikeManagerImpl"%>
<%
       
        response.setHeader("Cache-Control","no-cache");
        response.setHeader("Cache-Control","no-store");
        response.setDateHeader("Expires", 0);
        response.setHeader("Pragma","no-cache");

%> 
<%

int likeCount = 0;

LikeManagerImpl likeManagerImpl = new LikeManagerImpl();
likeCount = likeManagerImpl.likePage(slingRequest,sling);

%>

{"results":{"likeCount":"<%=likeCount%>"}}  