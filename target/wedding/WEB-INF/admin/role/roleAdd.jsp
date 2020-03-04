<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<link rel="stylesheet" href="${ctxPath}/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.excheck.js"></script>
<div class="layui-fluid">
    <div class="layui-card">
        <ul id="ztree" class="ztree"></ul>
    </div>
</div>

<script>
    // layui方法
    layui.use(['tree', 'table', 'form', 'layer'], function () {
        var parentRoleId = "";
        var form = layui.form
            , table = layui.table
            , layer = layui.layer
            , tree = layui.tree
            , $ = layui.jquery;


        //树形菜单
        var zTreeObj;
        var setting = {
            view: {
                dblClickExpand: false,
                showLine: true,
                showIcon: false
            },
            callback: {
                onClick: ztreeClick
            },
            data: {
                key: {
                    name: "roleName"
                },
                simpleData: {
                    enable: true,
                    idKey: "id", // id编号命名
                    pIdKey: "parentRoleId", // 父id编号命名
                    rootPId: 0//根节点
                }
            },
        };

        function ztreeClick(event, treeId, treeNode) {
            $("#parentRoleName", parent.document).val(treeNode.roleName);
            $("#parentRoleId", parent.document).val(treeNode.id);
            var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
            parent.layer.close(index);
        }

        // zTree 树形菜单
        $(document).ready(function () {
            var index = layer.load(1);
            var zNodes = [];
            $.ajax({
                type: "post",
                url: "${ctxPath}/role/list",
                dataType: "json",
                success: function (res) {
                    if (res != null && res.length > 0) {
                        var length = res.length;
                        for (var i = 0; i < length; i++) {
                            zNodes.push({
                                roleName: res[i].roleName,
                                id: res[i].id,
                                parentRoleId: res[i].parentRoleId
                            })
                        }
                        $.fn.zTree.init($("#ztree"), setting, zNodes);
                        layer.close(index);
                    }
                },
                error: function () {
                    layer.close(index);
                    layer.alert('加载失败');
                }
            });
        });
    });


</script>

<%@include file="../footer.jsp" %>