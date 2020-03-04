<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header_form.jsp" %>
<form class="layui-form layui-form-pane" id="departmentForm" style="padding: 20px 30px 0 30px;">
    <input id="id" name="id" type="hidden">
    <input id="parentDeptId" name="parentDeptId" type="hidden">
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

<script>
layui.use(['form', 'layedit', 'laydate', 'tree'], function () {
    var form = layui.form
        , layer = layui.layer
        , layedit = layui.layedit
        , laydate = layui.laydate
        , tree = layui.tree
        , $ = layui.jquery;
    var id = "${id}";
    if (id === "")
        return;
    var dt = (new Date()).getTime();

    $.ajax({
        url: "./get/" + id,
        dataType: "json",
        type: "get",
        data: {
            dt: dt
        },
        success: function (data) {
            $("#id").val(data.id);
            $("#deptCode").val(data.deptCode);
            $("#deptName").val(data.deptName);
            $("#parentDeptId").val(data.parentDeptId);
            parentDeptId = data.parentDeptId;
            if (data.sort)
                $("#sort").val(data.sort);
            // if (data.parentDept)
            //     $("#parentDeptName").val(data.parentDept.deptName);

            $.ajax({
                url: "./parentDept/" + data.parentDeptId,
                dataType: "json",
                type: "get",
                data: {
                    dt: dt
                },
                success: function (data) {
                    var roleNames = "";
                    $("#parentDeptName").val(data.deptName);
                },
                error: function () {

                }
            });
            if (data.enable == 0) {
                $("#btnDiv").prepend($("<button type='button'  class='layui-btn' onclick='userEnable()'>激活</button>"));
            } else {
                $("#btnDiv").prepend($("<button type='button'  class='layui-btn' onclick='userDisable()'>禁用</button>"));
            }
        },
        error: function () {
            //获取用户失败
        }
    });

    //获取部门角色
    $.ajax({
        url: "./roles/" + id,
        dataType: "json",
        type: "get",
        data: {
            dt: dt
        },
        success: function (data) {
            var roleNames = "";
            $.each(data, function (i, item) {
                roleNames = roleNames + item.roleName + ",";
            })
            $("#roleNames").val(roleNames);
        },
        error: function () {

        }
    });
    var parentDeptId;
    //获取部门角色


});

function backToList() {
    var index = parent.layer.getFrameIndex(window.name);
    parent.layer.close(index);
}


</script>
<%@include file="../footer.jsp" %>
