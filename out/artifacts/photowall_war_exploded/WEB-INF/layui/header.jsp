<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%
    String ctxPath = request.getContextPath();
    request.setAttribute("ctxPath", ctxPath);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>婚礼管理</title>
    <link rel="stylesheet" href="${ctxPath}/resources/layui/css/layui.css">
    <link rel="stylesheet" href="${ctxPath}/resources/layui/css/style.css">
    <script type="text/javascript" src="${ctxPath}/resources/js/jquery.js"></script>
    <script type="text/javascript" src="${ctxPath}/resources/js/jquery.form.min.js"></script>
    <script type="text/javascript" src="${ctxPath}/resources/layui/layui.js"></script>
    <script type="text/javascript" src="${ctxPath}/resources/layui/js/layui_comm.js?dt=12345"></script>
</head>
<body style="width: 100%; height: 100%;">