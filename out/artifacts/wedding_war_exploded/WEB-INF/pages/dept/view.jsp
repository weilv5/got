<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<div class="caption">当前位置&nbsp;>&nbsp;<span>查看部门</span></div>

    <div class="col-lg-12">
        <div class="form-panel col-lg-12">

                <form class="form-horizontal style-form" id="departmentForm" style="width: 96%;margin: 0px 2%;">
                    <input id="id" name="id" type="hidden" >
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">部门名称：</label>
                        <div class="col-lg-8" style="padding-top: 7px;" id="deptName"></div>
                    </div>
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">部门编码：</label>
                        <div class="col-lg-8" style="padding-top: 7px;" id="deptCode"></div>
                    </div>
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">上层部门：</label>
                        <div class="col-lg-8" style="padding-top: 7px;" id="parentDeptName"></div>
                    </div>
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">排序：</label>
                        <div class="col-lg-8" style="padding-top: 7px;" id="sort"></div>
                    </div>
                    <div class="form-group col-lg-12">
                        <label class="col-lg-2 control-label">角色：</label>
                        <div class="col-lg-4" id="roleNames"></div>
                    </div>
                    <div class="text-center col-lg-12" id="btnDiv">
                        <button type="button"  class="btn btn-danger" onclick="showConfirm()">删除</button>
                        <button type="button" class="btn btn-primary" onclick="modifydepartment()">修改</button>
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
                <button type="button" class="btn btn-primary" onclick="removedepartment()">确定</button>
            </div>
        </div>
    </div>
</div>
<%@include file="../footer.jsp"%>
<script>
    function backToList() {
        window.open("./?method=page", "_self");
    }

    function modifydepartment(){
        var id = "${id}";
        window.open("./?method=edit&id=" + id, "_self");
    }
    function showConfirm() {
        $("#confirmDialog").modal("show");
        $("#confirmMsg").text("确定要删除部门，该操作会删除其下属部门");
    }
    function removedepartment() {
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

    function viewdepartment(){
        var id = "${id}";
        if(id==="")
            return;
        var dt = (new Date()).getTime();
        $.ajax({
            url: "./get/" + id,
            dataType: "json",
            type: "get",
            data: {
                dt: dt
            },
            success: function(data){
                $("#id").val(data.id);
                    $("#deptCode").text(data.deptCode);
                    $("#deptName").text(data.deptName);
                    $("#parentDeptId").text(data.parentDeptId);
                    if(data.sort)
                        $("#sort").text(data.sort);
                    if(data.parentDept)
                        $("#parentDeptName").text(data.parentDept.deptName);
                    var length = data.deptRoleList.length;
                    for(var i = 0; i < length; i++){
                        var roleSpan = $("<div id='" + data.deptRoleList[i].id + "'>" + data.deptRoleList[i].roleName + "</div>");
                        $("#roleNames").append(roleSpan);
                    }
                    if(data.enable == 0){
                        $("#btnDiv").prepend($("<button type='button'  class='btn btn-primary' onclick='enableDept()'>激活</button>"));
                    }else{
                        $("#btnDiv").prepend($("<button type='button'  class='btn btn-danger' onclick='disableDept()'>禁用</button>"));
                    }
            }
        });
    }
    $(document).ready(function(){
        viewdepartment();
    });

    function enableDept(){
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
                    $("#btnDiv").prepend($("<button type='button'  class='btn btn-danger' onclick='disableDept()'>禁用</button>"));
                }else{
                    $("#msg").text(data.msg);
                    $("#closeBtn").show();
                }
                $('#alertModal').modal("show");
            }
        })
    }

    function disableDept(){
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
                    $("#btnDiv").prepend($("<button type='button'  class='btn btn-primary' onclick='enableDept()'>激活</button>"));
                }else{
                    $("#msg").text(data.msg);
                    $("#closeBtn").show();
                }
                $('#alertModal').modal("show");
            }
        })
    }
</script>
