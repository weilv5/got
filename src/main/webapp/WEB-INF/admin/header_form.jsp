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
    <meta charset="utf-8">
    <title>婚礼管理</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <link rel="stylesheet" href="${ctxPath}/resources/layuiadmin/layui/css/layui.css" media="all">
    <script type="text/javascript" src="${ctxPath}/resources/js/jquery.js"></script>
    <script type="text/javascript" src="${ctxPath}/resources/js/jquery.form.min.js"></script>
    <script src="${ctxPath}/resources/layuiadmin/layui/layui.js"></script>
</head>
<body layadmin-themealias="ocean">