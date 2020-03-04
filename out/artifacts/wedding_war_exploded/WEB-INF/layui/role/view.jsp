<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<div class="layui-fluid" style="padding: 20px 5%;">
<form class="layui-form layui-form-pane" action="" id="roleForm">
    <input id="id" name="id" type="hidden" >
    <div class="layui-form-item">
        <label class="layui-form-label">角色名称</label>
        <div class="layui-input-block">
            <input class="layui-input" id="roleName" readonly>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">上层角色</label>
        <div class="layui-input-block">
            <input class="layui-input" id="parentRoleName" readonly>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">排序</label>
        <div class="layui-input-block">
            <input class="layui-input" id="sort" readonly>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">是否管理员</label>
        <div class="layui-input-block">
            <input class="layui-input" id="admin" readonly>
        </div>
    </div>
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">备注</label>
        <div class="layui-input-block">
            <textarea placeholder="请输入内容" class="layui-textarea" id="backup" name="backup"></textarea>
        </div>
    </div>
    <div class="layui-form-item" align="center">
        <button type="button" class="layui-btn" id="viewUser">查看用户</button>
        <button type="button" class="layui-btn" id="viewDept">查看部门</button>
        <button type="button" class="layui-btn" id="viewModule">模块配置</button>
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
        window.id = "${id}";
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
                if(data.sort)
                    $("#sort").val(data.sort);
                if(data.parentRole)
                    $("#parentRoleName").val(data.parentRole.roleName);
                $("#backup").val(data.backup);
                $("#roleName").val(data.roleName);
                if(data.admin)
                    $("#admin").val("是");
                else
                    $("#admin").val("否");

                window.parentRoleId = data.parentRoleId;
            },
            error:function(){
                //获取用户失败
            }
        });



        //查看用户
        $("#viewUser").on('click', function(){
            //openLayer("${ctxPath}/role/?method=userlist?id="+id,"用户列表","800px","470px");
            layer.open({
                type: 2,
                title:'用户列表',
                area: ['500px', '300px'],
                content: '${ctxPath}/role/?method=userlist',
                cancel: function (index, layero) {
                    layer.close(index);
                    return false;
                }
            });
        });
        //查看部门
        $("#viewDept").on('click', function(){
            layer.open({
                type: 2,
                title:'部门列表',
                area: ['500px', '300px'],
                content: '${ctxPath}/role/?method=deptlist',
                cancel: function (index, layero) {
                    layer.close(index);
                    return false;
                }
            });
        });
        //查看模块
        $("#viewModule").on('click', function(){
            layer.open({
                type: 2,
                title:'模块',
                area: ['350px', '400px'],
                content: '${ctxPath}/role/?method=modulelist',
                cancel: function (index, layero) {
                    layer.close(index);
                    return false;
                }
            });
        });

    });

    function backToList() {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    }




</script>
<%@include file="../footer.jsp"%>