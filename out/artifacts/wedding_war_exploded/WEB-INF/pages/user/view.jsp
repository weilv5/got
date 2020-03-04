<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<div class="caption">当前位置&nbsp;>&nbsp;<span>查看用户</span></div>

    <div class="col-lg-12">
        <div class="col-lg-12 form-panel">
                <form class="form-horizontal style-form" id="userForm" style="width: 96%;margin: 0px 2%;">
                    <input id="id" name="id" type="hidden" >
                        <div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">部门：</label>
                            <div class="col-lg-8" style="padding-top: 7px;" id="deptId"></div>
                        </div>
                        <div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">姓名：</label>
                            <div class="col-lg-8" style="padding-top: 7px;" id="name"></div>
                        </div>
                        <div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">用户名：</label>
                            <div class="col-lg-8" style="padding-top: 7px;" id="userId"></div>
                        </div>
                        <div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">性别：</label>
                            <div class="col-lg-8" style="padding-top: 7px;" id="gender"></div>
                        </div>
                        <div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">出生日期：</label>
                            <div class="col-lg-8" style="padding-top: 7px;" id="birthday"></div>
                        </div>
                        <div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">电子邮箱：</label>
                            <div class="col-lg-8" style="padding-top: 7px;" id="email"></div>
                        </div>
                        <div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">手机：</label>
                            <div class="col-lg-8" style="padding-top: 7px;" id="mobile"></div>
                        </div>
                        <div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">排序：</label>
                            <div class="col-lg-8" id="sort"></div>
                        </div>
                        <div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">关联部门：</label>
                            <div class="col-lg-8" id="deptNames"></div>
                        </div>
                        <div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">角色：</label>
                            <div class="col-lg-8" id="roleNames"></div>
                        </div>
                    <div class="text-center col-lg-12" id="btnDiv">
                        <button type="button"  class="btn btn-danger" onclick="showConfirm()">删除</button>
                        <button type="button" class="btn btn-primary" onclick="modifyuser()">修改</button>
                        <button type="button" class="btn btn-primary" onclick="initPassword()">初始化密码</button>
                        <button type="button" class="btn btn-primary" onclick="clearUserLock()">解除锁定</button>
                        <button type="button" class="btn btn-default" onclick="backToList()">返回</button>
                    </div>
                </form>
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
<div id="confirmDialog" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">提示</h4>
            </div>
            <div class="modal-body" id="confirmMsg">

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" onclick="removeuser()">确定</button>
            </div>
        </div>
    </div>
</div>
<%@include file="../footer.jsp"%>
<script>
    function backToList() {
        window.open("./?method=page", "_self");
    }

    function modifyuser(){
        var id = "${id}";
        window.open("./?method=edit&id=" + id, "_self");
    }
    function showConfirm() {
        $("#confirmDialog").modal("show");
        $("#confirmMsg").text("确定要删除用户");
    }
    function removeuser() {
        var id = "${id}";
        $.ajax({
            url: "./delete/" + id,
            type: "post",
            dataType: "json",
            success: function (data) {
                $("#confirmDialog").modal("hide");
                if(data.responseCode==0){
                    $("#msg").text("提交成功");
                    $("#closeBtn").hide();
                    setTimeout(backToList, 1000)
                }else{
                    $("#msg").text(data.msg);
                    $("#closeBtn").show();
                }
                $('#alertModal').modal("show");
            }
        })
    }
    
    function clearUserLock() {
        var id = "${id}";
        if(id==="")
            return;
        $.ajax({
            url: "./clearUserLock",
            dataType: "json",
            type: "post",
            data: {
                id: id
            },
            success: function(data){
                if(data.responseCode==0){
                    var msg = "解除锁定成功";
                }else{
                    var msg = "解除锁定失败，错误信息：" + data.msg;
                }
                $("#msg").text(msg);
                $('#alertModal').modal("show");
            }
        });
    }
    
    function initPassword() {
        var id = "${id}";
        if(id==="")
            return;
        $.ajax({
            url: "./initPassword",
            dataType: "json",
            type: "post",
            data: {
                id: id
            },
            success: function(data){
                if(data.responseCode==0){
                    var msg = "初始化密码成功";
                }else{
                    var msg = "初始化密码失败，错误信息：" + data.msg;
                }
                $("#msg").text(msg);
                $('#alertModal').modal("show");
            },
            error: function(){
                $("#msg").text("初始化密码失败");
                $('#alertModal').modal("show");
            }
        });
    }

    function viewuser(){
        var id = "${id}";
        if(id==="")
            return;
        var dt = (new Date()).getTime();
        $.ajax({
            url: "./get/" + id,
            dataType: "json",
            type: "get",
            data:{
                dt: dt
            },
            success: function(data){
                $("#id").val(data.id);
                if(data.birthday){
                    $("#birthday").text(data.birthday);
                }
                $("#email").text(data.email);
                $("#deptId").text(data.department.deptName);
                $("#name").text(data.name);
                var value = data.gender.split("|")[3];
                $("#gender").text(value);
                $("#userId").text(data.userId);
                $("#mobile").text(data.mobile);
                if(data.sort)
                    $("#sort").text(data.sort);
                var length = data.deptList.length;
                for(var i = 0; i < length; i++){
                    var deptSpan = $("<div id='" + data.deptList[i].id + "'>" + data.deptList[i].deptName + "</div>");
                    $("#deptNames").append(deptSpan);
                }

                length = data.roleList.length;
                for(var i = 0; i < length; i++){
                    var roleSpan = $("<div id='" + data.roleList[i].id + "'>" + data.roleList[i].roleName + "</div>");
                    $("#roleNames").append(roleSpan);
                }
                if(data.enable == 0){
                    $("#btnDiv").prepend($("<button type='button'  class='btn btn-primary' onclick='enableUser()'>激活</button>"));
                }else{
                    $("#btnDiv").prepend($("<button type='button'  class='btn btn-danger' onclick='disableUser()'>禁用</button>"));
                }
            },
            error: function(){
                $("#msg").text("获取用户失败");
                $('#alertModal').modal("show");
            }
        });
    }
    $(document).ready(function(){
        viewuser();
    });

    function enableUser(){
        var id = "${id}";
        var dt = (new Date()).getTime();
        $.ajax({
            url: "./enable/",
            type: "post",
            dataType: "json",
            data: {
                id: id,
                dt: dt
            },
            success: function (data) {
                $("#confirmDialog").modal("hide");
                if(data.responseCode==0){
                    $("#msg").text("激活成功");
                    $("#closeBtn").hide();
                    $("#btnDiv button:eq(0)").remove();
                    $("#btnDiv").prepend($("<button type='button'  class='btn btn-danger' onclick='disableUser()'>禁用</button>"));
                }else{
                    $("#msg").text(data.msg);
                    $("#closeBtn").show();
                }
                $('#alertModal').modal("show");
            }
        })
    }

    function disableUser(){
        var id = "${id}";
        var dt = (new Date()).getTime();
        $.ajax({
            url: "./disable/",
            type: "post",
            dataType: "json",
            data: {
                id: id,
                dt: dt
            },
            success: function (data) {
                $("#confirmDialog").modal("hide");
                if(data.responseCode==0){
                    $("#msg").text("禁用成功");
                    $("#closeBtn").hide();
                    $("#btnDiv button:eq(0)").remove();
                    $("#btnDiv").prepend($("<button type='button'  class='btn btn-primary' onclick='enableUser()'>激活</button>"));
                }else{
                    $("#msg").text(data.msg);
                    $("#closeBtn").show();
                }
                $('#alertModal').modal("show");
            }
        })
    }
</script>
