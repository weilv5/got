<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
        </div>
<div id="passwordDialog" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">修改密码</h4>
            </div>
            <div class="modal-body" style="height: 180px">
                <div class="form-group col-lg-12">
                    <label class="col-lg-4 control-label">原密码:</label>
                    <div class="col-lg-8" style="padding-top: 7px;" >
                        <input id="oldPassword"
                               type="password"
                               class="form-control">
                    </div>
                </div>
                <div class="form-group col-lg-12">
                    <label class="col-lg-4 control-label">新密码:</label>
                    <div class="col-lg-8" style="padding-top: 7px;" >
                        <input id="newPassword"
                               type="password"
                               class="form-control">
                    </div>
                </div>
                <div class="form-group col-lg-12">
                    <label class="col-lg-4 control-label">确认密码:</label>
                    <div class="col-lg-8" style="padding-top: 7px;" >
                        <input id="confirmPassword"
                               type="password"
                               class="form-control">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" onclick="changePassword()">确定</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="ajaxLoginModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" >登录超时，请重新登录</h4>
            </div>
            <div class="modal-body">
                <form role="form" action="" method="post" class="form-horizontal style-form login-form">
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
                            <img id="captchaImg"  style="height: 100%; width: auto;" onclick="getNewCaptcha()">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer" >
                <button type="button" class="btn btn-primary" onclick="ajaxLogin()">登录</button>
                <button type="button"  class="btn btn-default" data-dismiss="modal">关闭</button>
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

<script src="${ctxPath}/resources/js/jquery.js"></script>
<script src="${ctxPath}/resources/js/bootstrap.min.js"></script>
<script src="${ctxPath}/resources/js/bootstrapValidator.min.js"></script>
<script src="${ctxPath}/resources/js/jquery.form.min.js"></script>
<script src="${ctxPath}/resources/js/pager.js"></script>
<script src="${ctxPath}/resources/js/moment.js"></script>
<script src="${ctxPath}/resources/js/bootstrap-datetimepicker.js"></script>
<script src="${ctxPath}/resources/js/strength.js"></script>
<script src="${ctxPath}/resources/js/ajaxLogin.js"></script>
<script src="${ctxPath}/resources/js/jsencrypt.js"></script>
<script>
    $(document).ready(function () {
        $.ajaxSetup({
            error: function (xhr, textStatus, errorThrown) {
                if( xhr.status === 401){
                    showAjaxLoginForm();
                }else{
                    $("#msg").text("请求失败");
                    $('#alertModal').modal("show");
                }
            }
        });
        window.baseUrl = "${ctxPath}";
        getModules();
        window.moduleId = "${moduleId}";
        if(window.moduleId && window.moduleId != ""){
            $.ajax({
                url: "${ctxPath}/getModule/" + window.moduleId,
                dataType: "json",
                type: "get",
                success: function (data) {
                    window.moduleCode = data.moduleCode;
                    if(data.parentModule){
                        if(data.parentModule.parentModule==null)
                            getChildModules(data.parentModuleId, data.parentModule.moduleName);
                        else
                            getChildModules(data.parentModule.parentModuleId, data.parentModule.parentModule.moduleName);
                    }
                }
            });
        }
        $("#firstNav li").mouseover(function(e){
            var id = ($(this).find("a").attr("id"));
            if(id){
                getChildModules(id, $(this).find("a").text());
            }
        });
        $('#newPassword').strength({
            strengthClass: 'strength',
            strengthMeterClass: 'strength_meter',
            strengthButtonClass: 'button_strength',
            strengthButtonText: '',
            strengthButtonTextToggle: ''
        });

    });

    function getModules() {
        var dt = (new Date()).getTime();
        $.ajax({
            url: "${ctxPath}/moduleList",
            type: "post",
            dataType: "json",
            data: {
                dt: dt
            },
            async: false,
            success: function (data) {
                for (var i = 0; i < data.length; i++) {
                    var  href = "###";
                    if(data[i].moduleAddr && data[i].moduleAddr != "") {
                        href = data[i].moduleAddr;
                        if(href.indexOf("?")!=-1){
                            href += "&moduleId=" + data[i].id;
                        }else{
                            href += "?moduleId=" + data[i].id;
                        }
                    }
                    if(href.indexOf("http://")==-1)
                        href = "${ctxPath}" + href;
                    var target = "_self";
                    if(data[i].target && data[i].target != "")
                        target = data[i].target;
                    $("#firstNav").append("<li><a id=\""+data[i].id+"\" target=\"" + target + "\" href=\"" + href + "\">" + data[i].moduleName + "</a></li>");
                }
            }
        })
    }

    function getChildModules(parentModuleId, parentModuleName) {
        var dt = (new Date()).getTime();
        $.ajax({
            url: "${ctxPath}/moduleList",
            type: "post",
            dataType: "json",
            data: {
                parentModuleId: parentModuleId,
                dt: dt
            },
            success: function (data) {
                if(data && data.length>0){
                    $(".system_left").show();
                    $('#secondNav').empty();
                    for (var i = 0; i < data.length; i++) {
                        var  href = "###";
                        if(data[i].moduleAddr && data[i].moduleAddr != "") {
                            href = data[i].moduleAddr;
                            if(href.indexOf("?")!=-1){
                                href += "&moduleId=" + data[i].id;
                            }else{
                                href += "?moduleId=" + data[i].id;
                            }
                        }
                        if(href.indexOf("http://")==-1)
                            href = "${ctxPath}" + href;

                        var target = "_self";
                        if(data[i].target && data[i].target != "")
                            target = data[i].target;
                        if(window.moduleCode && window.moduleCode.indexOf(data[i].moduleCode)!=-1)
                            getChildModules1(data[i].id, data[i].moduleName);
                        $("#secondNav").append("<li><a id ='" + data[i].id + "' href='" + href + "' target='" + target + "' ><span class='glyphicon " + data[i].iconAddr + "'></span>&nbsp;&nbsp;" + data[i].moduleName + "</a></li>");
                    }
                    $("#secondNav li").mouseover(function(e){
                        var id = ($(this).find("a").attr("id"));
                        if(id){
                            getChildModules1(id, $(this).find("a").text());
                        }
                    });
                    $("#mainPage").width($(window).width() - $(".system_left").width());
                    $("#mainPage").css("margin-left", $(".system_left").width());
                }
            }
        });
    }

    function getChildModules1(parentModuleId, parentModuleName) {
        var dt = (new Date()).getTime();
        $.ajax({
            url: "${ctxPath}/moduleList",
            type: "post",
            dataType: "json",
            data: {
                parentModuleId: parentModuleId,
                dt: dt
            },
            success: function (data) {
                if(data && data.length>0){
                    $(".navbar-default").show();
                    $('.navbar-nav').empty();
                }
                for (var i = 0; i < data.length; i++) {
                    var  href = "###";
                    if(data[i].moduleAddr && data[i].moduleAddr != "") {
                        href = data[i].moduleAddr;
                        if(href.indexOf("?")!=-1){
                            href += "&moduleId=" + data[i].id;
                        }else{
                            href += "?moduleId=" + data[i].id;
                        }
                    }
                    if(href.indexOf("http://")==-1)
                        href = "${ctxPath}" + href;

                    var target = "_self";
                    if(data[i].target && data[i].target != "")
                        target = data[i].target;
                    var clazz = "";
                    if(data[i].id === window.moduleId)
                        clazz = "class='active'";
                    $('.navbar-nav').append("<li " + clazz + "><a  href='" + href + "' target='" + target + "' ><span class='glyphicon " + data[i].iconAddr + "'></span>&nbsp;&nbsp;" + data[i].moduleName + "</a></li>");
                }
            }
        });
    }
    
    function showChangePassword() {
        $("#newPassword").val("");
        $("#oldPassword").val("");
        $("#confirmPassword").val("");
        $('#passwordDialog').modal("show");
    }

    function changePassword() {

        var id = "<shiro:principal property="id"/>";
        if(id==="")
            return;
        var newPassword = $("#newPassword").val();
        var oldPassword = $("#oldPassword").val();
        var confirmPassword = $("#confirmPassword").val();
        if(newPassword==="" || oldPassword ==="" || confirmPassword === ""){
            $("#msg").text("所有密码都必须输入");
            $('#alertModal').modal("show");
        }else if(confirmPassword != newPassword){
            $("#msg").text("两次密码不一致，请确认");
            $('#alertModal').modal("show");
        }else{
            if($("div [data-meter='newPassword']").attr("class")==="strong" || $("div [data-meter='newPassword']").attr("class")==="medium"){
                $.ajax({
                    url: "${ctxPath}/changePassword",
                    dataType: "json",
                    type: "post",
                    data: {
                        id: id,
                        oldPassword: oldPassword,
                        newPassword: newPassword
                    },
                    success: function(data){
                        if(data.responseCode==0){
                            var msg = "密码修改成功，注销后生效";
                            $("#newPassword").val("");
                            $("#oldPassword").val("");
                            $("#confirmPassword").val("");
                            $('#passwordDialog').modal("hide");
                        }else{
                            var msg = "密码修改失败，错误信息：" + data.msg;
                        }
                        $("#msg").text(msg);
                        $('#alertModal').modal("show");
                    }
                });
            }else{
                $("#msg").text("新密码太简单，必须包含数字、大写字母、小写字母或者特殊字符");
                $('#alertModal').modal("show");
            }
        }
    }
</script>
    </body>
</html>