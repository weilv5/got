<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@include file="header.jsp" %>
<div class="layui-fluid" style="margin-top: 100px;width:70%;background-color: white;">
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
        <button type="reset" class="layui-btn layui-btn-primary">重置</button>
    </div>
</form>
</div>
<script type="text/javascript">
    window.contextPath = "${ctxPath}";
    window.userId = "<shiro:principal property="id"></shiro:principal>";
    window.username = "<shiro:principal property="userId"></shiro:principal>";
</script>
<script type="text/javascript">
    layui.use(['layer', 'form'], function () {
        var $ = layui.jquery
            , layer = layui.layer
            , form = layui.form;

        form.verify({
            password: function (value) {
                if (value.length < 8) {
                    return '密码至少8个字符';
                }
            },
            passwordComplex: function (value) {

                if (validateInput(value)) {
                    return "新密码太简单，必须包含数字、大写字母、小写字母或特殊字符";
                }
                else if (validateKey(value)) {
                    return "密码不得包含键盘上任意连续的四个字符或shift转换字符";
                }
                else if (validateContainsName(window.username, value)) {
                    return "密码中不能包含用户名或大小写变形";
                }
                else if (validateReplace(window.username, value)) {
                    return "密码中不能包含用户名的形似变形";
                } else if (value == $("#oldPassword").val()) {
                    return "新密码与旧密码相同，请重新输入"
                }
            },
            confirmPassword: function (value) {
                if (value != $("#newPassword").val()) {
                    return "两次密码不一致，请确认";
                }
            }
        });

        //监听提交
        form.on('submit(passForm)', function (data) {
            changePassword();
            return false;
        });

        function changePassword() {
            if (window.userId === "")
                return;
            var newPassword = $("#newPassword").val();
            var oldPassword = $("#oldPassword").val();
            console.info(window.contextPath);
            $.post(window.contextPath + "/changePassword", {
                id: window.userId,
                oldPassword: oldPassword,
                newPassword: newPassword
            }, function (data) {
                if (data.responseCode == 0) {
                    layer.msg("密码修改成功", {time: 3000}, function () {

                        window.open(window.contextPath + "/home","_parent");
                    });

                } else {
                    var msg = "密码修改失败，错误信息：" + data.msg;
                    parent.layui.layer.msg(msg);
                }

            });
        }
    });

    //密码不得包含用户名或者大小写变形
    function validateContainsName(name, password) {
        var pwdTemp = password.toLowerCase();
        var nameTemp = name.toLowerCase();
        if (pwdTemp.indexOf(nameTemp) != -1) {
            return true
        }
        return false
    }

    //密码不得包含键盘上任意连续的四个字符
    function validateKey(password) {

        //横向穷举
        var zxsz = "qwertyuiop[]|@asdfghjkl;'@zxcvbnm,./@`1234567890-=@";
        //纵向穷举
        var dxsz = "1qaz@2wsx@3edc@4rfv@5tgb@6yhn@7ujm@8ik,@9ol.@0p;/@";
        if (validateKeyXh(zxsz, password)) {
            return true;
        }
        if (validateKeyXh(dxsz, password)) {
            return true;
        }
        return false;
    }

    function validateKeyXh(keysz, password) {
        var zxlen = keysz.length - 1;
        for (var i = 0; i < zxlen; i++) {
            var a = (keysz.charAt(i) + keysz.charAt(i + 1) + keysz.charAt(i + 2) + keysz.charAt(i + 3)).toLowerCase();
            var b = (keysz.charAt(zxlen - i) + keysz.charAt(zxlen - 1 - i) + keysz.charAt(zxlen - 2 - i) + keysz.charAt(zxlen - 3 - i)).toLowerCase();
            var c = password.toLowerCase();
            var wReplace = c.replace(/~/g, '`').replace(/!/g, '1').replace(/@/g, '2').replace(/#/g, '3').replace(/\$/g, '4')
                .replace(/%/g, '5').replace(/\^/g, '6').replace(/&/g, '7').replace(/\*/g, '8').replace(/\(/g, '9')
                .replace(/\)/g, '0').replace(/\_/g, '-').replace(/\+/g, '=').replace(/{/g, '[').replace(/}/g, ']')
                .replace(/\\/g, '|').replace(/:/g, ';').replace(/"/g, '\'').replace(/</g, ',').replace(/>/g, '.')
                .replace(/\?/g, '/')
            if (a.indexOf("@") == -1) {
                if (wReplace.indexOf(a) != -1) {
                    return true;
                }
            }
            if (b.indexOf("@") == -1) {
                if (wReplace.indexOf(b) != -1) {
                    return true;
                }
            }
        }
        return false;

    }

    //密码中不得包含用户名的形似形变
    function validateReplace(name, password) {
        var reName = name.replace(/0/g, 'Q').replace(/o/g, 'Q').replace(/O/g, 'Q')
            .replace(/1/g, 'l').replace(/!/g, 'l').replace(/i/g, 'l')
            .replace(/6/g, 'b').replace(/d/g, 'b')
            .replace(/2/g, 'z').replace(/Z/g, 'z')
            .replace(/g/g, 'y').replace(/9/g, 'y')
            .replace(/C/g, '(').replace(/c/g, '(')
            .replace(/S/g, '$').replace(/s/g, '$')
            .replace(/p/g, 'q').replace(/P/g, 'R').replace(/f/g, 't').replace(/a/g, '@')
            .replace(/J/g, 'L').replace(/m/g, 'n').replace(/U/g, 'V');
        var rePwd = password.replace(/0/g, 'Q').replace(/o/g, 'Q').replace(/O/g, 'Q')
            .replace(/1/g, 'l').replace(/!/g, 'l').replace(/i/g, 'l')
            .replace(/6/g, 'b').replace(/d/g, 'b')
            .replace(/2/g, 'z').replace(/Z/g, 'z')
            .replace(/g/g, 'y').replace(/9/g, 'y')
            .replace(/C/g, '(').replace(/c/g, '(')
            .replace(/S/g, '$').replace(/s/g, '$')
            .replace(/p/g, 'q').replace(/P/g, 'R').replace(/f/g, 't').replace(/a/g, '@')
            .replace(/J/g, 'L').replace(/m/g, 'n').replace(/U/g, 'V');
        if (rePwd.indexOf(reName) != -1) {
            return true
        }
        return false
    }

    //验证组合代码
    function validateInput(password) {
        var regUpper = /[A-Z]/;
        var regLower = /[a-z]/;
        var regStr = /[0-9]/;
        var regEn = /[`~!@#$%^&*()_+<>?:"{},.\/;'[\]]/im,
            regCn = /[·！#￥（——）：；“”‘、，|《。》？、【】[\]]/im;
        var flag = 0;
        if (regUpper.test(password)) {
            flag++;
        }
        if (regLower.test(password)) {
            flag++;
        }
        if (regStr.test(password)) {
            flag++;
        }
        if (regEn.test(password)) {
            flag++;
        }
        return flag < 3;
    }
</script>
<%@include file="footer.jsp" %>