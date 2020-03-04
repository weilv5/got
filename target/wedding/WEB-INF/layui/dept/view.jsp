<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<div class="layui-fluid" style="padding: 20px 5%;">
<form class="layui-form layui-form-pane"  id="departmentForm">
    <input id="id" name="id" type="hidden" >
    <div class="layui-form-item">
        <label class="layui-form-label">部门名称</label>
        <div class="layui-input-block">
            <input class="layui-input" id="deptName" readonly>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">部门编码</label>
        <div class="layui-input-block">
            <input class="layui-input" id="deptCode" readonly>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">上层部门</label>
        <div class="layui-input-block">
            <input class="layui-input" id="parentDeptName" readonly>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">排序</label>
        <div class="layui-input-block">
            <input class="layui-input" id="sort" readonly>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">角色</label>
        <div class="layui-input-block">
            <input class="layui-input" id="roleNames" readonly>
        </div>
    </div>
    <div class="layui-form-item" align="center">
        <button type="button" class="layui-btn layui-btn-primary" onclick="backToList()">返回</button>
    </div>
</form>
</div>

<script>
    layui.use(['form','layedit','laydate','tree'],function() {
        var form = layui.form
            , layer = layui.layer
            , layedit = layui.layedit
            , laydate = layui.laydate
            , tree = layui.tree
            , $ = layui.jquery;
        var id = "${id}";
        console.info(id);
        if(id === "")
            return;
        var dt = (new Date()).getTime();
        $.ajax({
            url:"./get/"+id,
            dataType:"json",
            type:"get",
            data:{
                dt:dt
            },
            success:function(data){
                $("#id").val(data.id);
                $("#deptCode").val(data.deptCode);
                $("#deptName").val(data.deptName);
                $("#parentDeptId").val(data.parentDeptId);
                if(data.sort)
                    $("#sort").val(data.sort);
                if(data.parentDept)
                    $("#parentDeptName").val(data.parentDept.deptName);

                var length = data.deptRoleList.length;
                var roleNames = "";
                for (var i = 0; i < length; i++) {
                    roleNames = roleNames + data.deptRoleList[i].roleName+",";
                }
                $("#roleNames").val(roleNames);

                if (data.enable == 0) {
                    $("#btnDiv").prepend($("<button type='button'  class='layui-btn' onclick='userEnable()'>激活</button>"));
                } else {
                    $("#btnDiv").prepend($("<button type='button'  class='layui-btn' onclick='userDisable()'>禁用</button>"));
                }
            },
            error:function(){
                //获取用户失败
            }
        });

    });

    function userEnable() {
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
                if (data.responseCode == 0) {
                    parent.layui.layer.msg("激活成功");
                    $("#btnDiv button:eq(0)").remove();
                    $("#btnDiv").prepend($("<button type='button'  class='layui-btn' onclick='userDisable()'>禁用</button>"));
                } else {
                    parent.layui.layer.msg(data.msg);
                }
            }
        })
    }

    function userDisable() {
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
                if (data.responseCode == 0) {
                    parent.layui.layer.msg("禁用成功");
                    $("#btnDiv button:eq(0)").remove();
                    $("#btnDiv").prepend($("<button type='button'  class='layui-btn' onclick='userEnable()'>激活</button>"));
                } else {
                    parent.layui.layer.msg("禁用失败");
                }
            }
        })
    }

    function backToList() {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    }



</script>
<%@include file="../footer.jsp"%>