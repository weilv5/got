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
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>婚礼管理</title>
    <link rel="stylesheet" href="${ctxPath}/resources/layui/css/layui.css">
    <link rel="stylesheet" href="${ctxPath}/resources/layui/css/style.css?dt=111">
</head>
<body>

<!-- layout admin -->
<div class="layui-layout layui-layout-admin">
    <!-- header -->
    <div class="layui-header my-header">

            <a href="${ctxPath}/home">
                <div class="my-header-logo">婚礼管理</div>
            </a>


            <div class="my-header-btn">
                <a class="btn-nav"><i class="layui-icon">&#xe66b;</i></a>
            </div>

            <!-- 顶部左侧添加选项卡监听 -->
            <ul class="layui-nav my-nav" lay-filter="side-top-left">

            </ul>

            <ul class="layui-nav my-header-user-nav" lay-filter="side-top-right">
                <li class="layui-nav-item">
                    <a class="name" href="javascript:;"><i class="layui-icon">&#xe629;</i>主题</a>
                    <dl class="layui-nav-child">
                        <dd data-skin="0"><a href="javascript:;">默认</a></dd>
                        <dd data-skin="1"><a href="javascript:;">纯白</a></dd>
                        <dd data-skin="2"><a href="javascript:;">蓝白</a></dd>
                    </dl>
                </li>
                <li class="layui-nav-item">
                    <a class="name" href="javascript:;">&nbsp;&nbsp;&nbsp;&nbsp;<i class="layui-icon">&#xe612;</i>
                        <shiro:principal property="userId"/> </a>
                    <dl class="layui-nav-child">
                        <dd data="changePassword"><a href="javascript:;"><i class="layui-icon">&#xe621;</i>修改密码</a></dd>
                        <dd><a href="${ctxPath}/logout"><i class="layui-icon">&#x1006;</i>退出</a></dd>
                    </dl>
                </li>
            </ul>
    </div>
    <!-- side -->
    <div class="layui-side my-side">
        <div class="layui-side-scroll">

            <!-- 左侧主菜单添加选项卡监听 -->
            <ul class="layui-nav layui-nav-tree" lay-filter="side-main">
            </ul>
        </div>
    </div>
    <!-- body -->
    <div class="layui-body my-body">

        <div class="layui-tab layui-tab-card my-tab" lay-filter="card" lay-allowClose="true">
            <ul class="layui-tab-title">
                <li class="layui-this" lay-id="1"><span><i class="layui-icon">&#xe68e;</i>首页</span></li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show">
                        <iframe id="iframe" src="${ctxPath}/welcome" frameborder="0"></iframe>
                </div>
            </div>
        </div>
    </div>
    <!-- footer -->
    <div class="layui-footer my-footer">
        <p><a href="###">婚礼管理</a></p>
        <p>2020 © copyright 只供个人使用</p>
    </div>
</div>


<!-- 右键菜单 -->
<div class="my-dblclick-box none">
    <table class="layui-tab dblclick-tab">
        <tr class="card-refresh">
            <td><i class="layui-icon">&#x1002;</i>刷新当前标签</td>
        </tr>
        <tr class="card-close">
            <td><i class="layui-icon">&#x1006;</i>关闭当前标签</td>
        </tr>
        <tr class="card-close-all">
            <td><i class="layui-icon">&#x1006;</i>关闭所有标签</td>
        </tr>
    </table>
</div>

<div id="changePassDiv" style="display: none">
    <div class="larry-personal-body clearfix ">
        <form class="layui-form layui-form-pane" id="passwordForm" lay-filter="passwordForm">
            <div class="layui-form-item">
                <label class="layui-form-label">旧密码</label>
                <div class="layui-input-block">
                    <input type="password" id="oldPassword" name="oldPassword" lay-verify="required|password|"
                           class="layui-input" value="" placeholder="请输入旧密码">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">新密码</label>
                <div class="layui-input-block">
                    <input type="password" id="newPassword" name="newPassword"
                           lay-verify="required|password|passwordComplex" class="layui-input" value=""
                           placeholder="请输入新密码">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">确认密码</label>
                <div class="layui-input-block">
                    <input type="password" id="confirmPassword" name="confirmPassword"
                           lay-verify="required|password|passwordComplex|confirmPassword" class="layui-input" value=""
                           placeholder="请输入确认新密码">
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn" lay-submit lay-filter="*">提交</button>
                    <button type="button" onclick="closeLayer(window.passwordLayer)"
                            class="layui-btn layui-btn-primary">关闭
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<script type="text/javascript" src="${ctxPath}/resources/layui/layui.js"></script>
<script type="text/javascript">
    $ = layui.jquery;
    window.menuAddr = "${ctxPath}/moduleList";
    window.contextPath = "${ctxPath}/";
    window.userId = "<shiro:principal property="id"></shiro:principal>";
    window.username = "<shiro:principal property="userId"></shiro:principal>";
    localStorage.log = 0;
</script>
<script type="text/javascript" src="${ctxPath}/resources/layui/js/layui_home.js"></script>
<script type="text/javascript" src="${ctxPath}/resources/layui/js/layui_comm.js"></script>
</body>
</html>