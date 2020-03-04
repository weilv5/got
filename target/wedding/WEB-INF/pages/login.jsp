<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%
    String ctxPath = request.getContextPath();
    request.setAttribute("ctxPath", ctxPath);
%>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>婚礼管理</title>

    <!-- CSS -->
    <link rel="stylesheet" href="${ctxPath}/resources/css/bootstrap.css">
    <link rel="stylesheet" href="${ctxPath}/resources/css/form-elements.css">
    <link rel="stylesheet" href="${ctxPath}/resources/css/login.css">
</head>

<body>
<!-- Top content -->
<div class="top-content">
    <div class="inner-bg">
        <div class="container">
            <div class="row">
                <div class="col-sm-8 col-sm-offset-2 text">
                    <h1><strong>婚礼管理</strong></h1>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6 col-sm-offset-3 form-box">
                    <div class="form-top">
                        <div class="form-top-left">
                            <h3>请登录</h3>
                        </div>
                        <div class="form-top-right">
                            <i class="fa fa-key"></i>
                        </div>
                    </div>
                    <div class="form-bottom">
                        <form role="form" action="" method="post" class="login-form">
                            <div class="form-group">
                                <label class="sr-only" for="userId">用户名：</label>
                                <input type="text" id="userId" name="userId" placeholder="请输入用户名" class="form-username form-control" id="form-username">
                            </div>
                            <div class="form-group">
                                <label class="sr-only" for="password">密码：</label>
                                <input type="password" id="password" name="password" placeholder="请输入密码" class="form-password form-control" id="form-password">
                            </div>
                            <div class="form-group">
                                <div style="float: left; width: 70%;margin-bottom: 20px;">
                                    <label class="sr-only" for="captcha">验证码：</label>
                                    <input type="text" id="captcha" name="captcha" placeholder="请输入验证码" class="form-control form-captcha " id="form-captcha">
                                </div>
                                <div style="float: right; width: 30%;">
                                    <img id="captchaImg" src="${ctxPath}/captcha" style="height: 100%; width: auto;" onclick="getNewCaptcha()">
                                </div>
                            </div>
                            <button type="button" class="btn" onclick="doLogin()">登录</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>

<div class="modal fade" id="alertModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="title">提示</h4>
            </div>
            <div class="modal-body" id="msg"></div>
            <div class="modal-footer" id="closeBtn">
                <button type="button"  class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>
<!-- Javascript -->
<script src="${ctxPath}/resources/js/jquery.js"></script>
<script src="${ctxPath}/resources/js/bootstrap.min.js"></script>
<script src="${ctxPath}/resources/js/jquery.backstretch.min.js"></script>
<script src="${ctxPath}/resources/js/login.js"></script>
<script src="${ctxPath}/resources/js/jsencrypt.js"></script>

</body>

</html>