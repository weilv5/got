<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@include file="header.jsp" %>
<div class="layui-anim layui-anim-scale">
    <div class="layui-container bg-changepwd">

        <form class="layui-form layui-form-pane" id="passwordForm" lay-filter="passForm">
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
            <div class="layui-form-item" align="center">
                <button class="layui-btn" lay-submit lay-filter="*">提交</button>
                <button type="button" onclick="closeLayer(window.passwordLayer)"
                        class="layui-btn layui-btn-primary">关闭
                </button>
            </div>
        </form>
    </div>
</div>
<script src="${ctxPath}/resources/js/jquery.backstretch.min.js"></script>
<script type="text/javascript">
    window.contextPath = "${ctxPath}";
    window.userId = "<shiro:principal property="id"></shiro:principal>";
    window.username = "<shiro:principal property="userId"></shiro:principal>";
    jQuery(document).ready(function () {
        $.backstretch("resources/img/login_bg.jpg");
    });
</script>
<script type="text/javascript" src="${ctxPath}/resources/layui/js/changePwd.js"></script>
<script type="text/javascript" src="${ctxPath}/resources/layui/js/layui_comm.js"></script>
<%@include file="footer.jsp" %>