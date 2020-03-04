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
<link rel="stylesheet" href="${ctxPath}/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${ctxPath}/resources/js/jquery.js"></script>
<link rel="stylesheet" href="${ctxPath}/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.excheck.js"></script>

<ul id="moduleTree" class="ztree"></ul>
<a class="layui-btn btn-default btn-add" id="btn-save" style="float: right">确认</a>

<script>
    layui.config({
        base: '${ctxPath}/resources/layuiadmin/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['layer'], function () {
        // zTree 的参数配置，深入使用请参考 API 文档（setting 配置详解）
        // function ztreeClick(event, treeId, treeNode){
        //     $("#parentModuleName",parent.document).val(treeNode.moduleName);
        //     $("#parentModuleId", parent.document).val(treeNode.id);
        //     var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
        //     parent.layer.close(index);
        // }
        window.moduleIds = [];
        $(document).ready(function () {
            var zNodes = [];
            var setting = {
                check: {
                    enable: true,
                    chkStyle: "checkbox",    //复选框
                    chkboxType: {
                        "Y": "ps",
                        "N": "ps"
                    }
                },
                view: {
                    dblClickExpand: false,
                    showLine: true,
                    showIcon: false
                },
                data: {
                    key: {
                        name: "text"
                    },
                    simpleData: {
                        enable: true,
                        idKey: "moduleId", // id编号命名
                        pIdKey: "pid", // 父id编号命名
                        rootPId: 0//根节点
                    }
                }
            };
            var string = '${treeNode}';
            var treeNode = eval('(' + string + ')');
            $.fn.zTree.init($("#moduleTree"), setting, treeNode);
        });
        $("#btn-save").on('click', function () {
            var zTree = $.fn.zTree.getZTreeObj("moduleTree");
            console.log(zTree)
            var nodes = zTree.getCheckedNodes(true);
            $(nodes).each(function (index, obj) {
                console.log(obj)
                window.moduleIds.push(obj.moduleId);
            });
            setModule();

        });

        function setModule() {
            $.ajax({
                type: "post",
                url: "${ctxPath}/role/saveModuleRole",
                data: {
                    moduleIds: window.moduleIds,
                    roleId: "${role.id}"
                },
                success: function (data) {
                    parent.layui.layer.msg("提交成功");
                    var index = parent.layer.getFrameIndex(window.name);
                    parent.layer.close(index);

                },
                error: function () {
                    parent.layui.layer.msg(data.msg);

                }
            });
        }
    })


</script>

<%@include file="../footer.jsp" %>