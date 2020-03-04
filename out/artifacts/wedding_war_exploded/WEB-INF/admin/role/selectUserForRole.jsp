<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%
    String ctxPath = request.getContextPath();
    request.setAttribute("ctxPath", ctxPath);
%>
<!DOCTYPE html>
<html lang="en" style="background-color: white;">
<head>
    <meta charset="utf-8">
    <title>婚礼管理</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <link rel="stylesheet" href="${ctxPath}/resources/layuiadmin/layui/css/layui.css" media="all">
    <link rel="stylesheet" href="${ctxPath}/resources/layuiadmin/style/admin.css" media="all">
    <script type="text/javascript" src="${ctxPath}/resources/js/jquery.js"></script>
    <script type="text/javascript" src="${ctxPath}/resources/js/jquery.form.min.js"></script>
    <script src="${ctxPath}/resources/layuiadmin/layui/layui.js"></script>
    <script src="${ctxPath}/resources/layuiadmin/addjs/layui_comm.js"></script>
    <script src="${ctxPath}/resources/js-xlsx/xlsx.full.min.js"></script>

</head>
<body>
<div class="layui-fluid" style="padding: 20px;">
    <div class="layui-inline">
        <button class="layui-btn" onclick="showAddUserForm()">
            <i class="layui-icon">&#xe608;</i> 添加
        </button>
    </div>
    <div class="layui-form layui-card-header layuiadmin-card-header-auto" id="addUserForm" style="display: none">
        <div class="layui-input-inline">
            <label>姓名:</label>
        </div>
        <div class="layui-inline" >
            <select id="name" name="name" lay-filter="selectUserForRole"  lay-verify="" lay-search>
            </select>
            <%--<input type="text" id="name" autocomplete="off" onchange="selectUserAjax()"--%>
            <%--placeholder="请输入姓名"  class="layui-input">--%>
        </div>
        <button class="layui-btn layui-btn-primary" id="addUserBtn">确认</button>
    </div>
    <!-- table -->
    <div id="userTable" lay-filter="userTable"></div>
</div>

<script>
    // layui方法
    layui.use(['tree', 'table', 'form', 'layer'], function () {
        var roleId = parent.id;
        var form = layui.form
            , table = layui.table
            , layer = layui.layer
            , tree = layui.tree
            , $ = layui.jquery;

        function loadUser() {
            var where = {};
            where['role.id'] = "${role.id}";

            var tableIns = table.render({
                elem: '#userTable'
                , cols: [[
                    {field: 'userId', title: '用户名', width: 120}
                    , {
                        field: 'department', title: '部门名称', width: 120, templet: function (d) {
                            var info = d.department.deptName;
                            return info;
                        }
                    },
                    {fixed: 'right', title: '操作', width: 120, align: 'center', toolbar: '#barOption'}

                ]]
                , url: '${ctxPath}/role/userForRolePage'
                , method: 'post'
                , page: true
                , request: {
                    limitName: "size"
                }
                , limits: [10, 20, 30, 60, 120]
                , limit: 10
                , where: where
            });
        }

        loadUser();
        initChooseUser("name",form,"${ctxPath}/user/list/");

        $("#addUserBtn").click(function () {
            parent.layui.layer.confirm('确定添加吗？', function (index) {
                $.ajax({
                    url: "${ctxPath}/role/addUser/",
                    type: "post",
                    dataType: "json",
                    data: {
                        "id": $("#name").val(),
                        "roleId": "${role.id}"
                    },
                    success: function (data) {
                        if (data.responseCode == 0) {
                            parent.layui.layer.msg("保存成功");
                            loadUser();
                        } else {
                            parent.layui.layer.msg(data.msg);
                        }
                    },

                });
                parent.layui.layer.close(index);
            });
        })
        table.on('tool(userTable)', function (obj) {
            var data = obj.data
                , layEvent = obj.event;
            if (layEvent == "del") {
                deleteUser(data.id);
            }
        });

        function deleteUser(userId) {
            parent.layui.layer.confirm('确定删除吗？', function (index) {
                $.ajax({
                    url: "${ctxPath}/role/deleteUser",
                    type: "post",
                    dataType: "json",
                    data: {
                        "id": userId,
                        "roleId": "${role.id}"
                    },
                    success: function (data) {
                        if (data.responseCode == 0) {
                            parent.layui.layer.msg("删除成功");
                            loadUser();
                        } else {
                            parent.layui.layer.msg(data.msg);
                        }
                    },

                });
                parent.layui.layer.close(index);
            });
        }

    });

    function showAddUserForm() {
        $("#addUserForm").toggle();
    }


</script>
<script type="text/html" id="barOption">
    <a class="layui-btn layui-btn-mini" lay-event="del">删除</a>
</script>
<%@include file="../footer.jsp" %>