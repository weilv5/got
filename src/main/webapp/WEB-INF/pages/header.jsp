<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%
String ctxPath = request.getContextPath();
request.setAttribute("ctxPath", ctxPath);
%>
<!doctype html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="renderer" content="webkit">
        <title>婚礼管理</title>
        <link href="${ctxPath}/resources/css/bootstrap.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${ctxPath}/resources/css/bootstrapValidator.min.css">
        <link href="${ctxPath}/resources/css/style.css" rel="stylesheet">
        <link href="${ctxPath}/resources/css/style-responsive.css" rel="stylesheet">
        <link href="${ctxPath}/resources/css/bootstrap-datetimepicker.css" rel="stylesheet">
        <link href="${ctxPath}/resources/css/core.css" rel="stylesheet">
        <link href="${ctxPath}/resources/css/strength.css" rel="stylesheet">
    </head>
    <body>
        <div class="system_top">
            <div class="system_logo"></div>
            <div class="system_nav">
                <ul id="firstNav">
                    <li><a href="${ctxPath}/home">首页</a></li>
                </ul>
            </div>
            <div class="header">
                <span><shiro:principal property="userId"/></span>
                <div class="header_popup">
                    <ul>
                        <li><a href="###" onclick="showChangePassword()">修改密码</a></li>
                        <li><a href="${ctxPath}/logout">注销</a></li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="system_left">
            <div class="nav_side">
                <ul id="secondNav">
                </ul>
            </div>
        </div>
        <div id="mainPage" style="position: absolute; top: 64px;width: 100%;">
            <nav class="navbar navbar-default" style="display: none;border-radius: 0px; border: 0px;">
                <div class="navbar-collapse collapse">
                    <ul class="nav navbar-nav"></ul>
                </div>
            </nav>
