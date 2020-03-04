<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<link rel="stylesheet" href="${ctxPath}/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.excheck.js"></script>
<div class="layui-container">
    <ul id="tree" class="ztree"></ul>
    <a class="layui-btn btn-default btn-add" id="btn-save" style="float: right">确认</a>
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
            check: {
                enable: true,
                chkboxType : { "Y" : "", "N" : "" }
            },
            view: {
                dblClickExpand: false,
                showLine: true,
                showIcon:true,

            },
            callback: {
                onClick:ztreeOnAsyncSuccess
            },
            async: {
                enable: true,
                url: "${ctxPath}/role/list",
                autoParam:["parentRoleId"],
                contentType: "application/json",
                otherParam: {}
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
        function ztreeOnAsyncSuccess(event, treeId, treeNode,clickFlag){
           /* if ($.inArray(treeNode.id, parent.window.roleIdArr) >= 0) {
                parent.layui.layer.msg("选择角色重复！");
            } else {
                parent.window.roleIdArr.push(treeNode.id);
                var roleSpan = $("<div id='" + treeNode.id + "'>" + treeNode.roleName + "<a href='#' onclick='delRole(\""+treeNode.id+"\")' class='layui-icon' style=\"color: #33ABA0;\">&#x1006;</a></div>");
                $("#roleNames", parent.document).append(roleSpan);
            }*/
            var treeObj = $.fn.zTree.getZTreeObj(treeId);
            var node = treeObj.getNodeByTId(treeNode.tId);
            if(node.children == null || node.children == "undefined") {
                $.ajax({
                    type: "post",
                    url: "${ctxPath}/role/list",
                    data: {
                        parentRoleId: treeNode.id
                    },
                    dataType: "json",
                    async: true,
                    success: function (res) {
                        var arr = [];
                        if (res != null && res.length > 0) {
                            var length = res.length;
                            for (var i = 0; i < length; i++) {
                                arr.push({
                                    roleName: res[i].roleName,
                                    id: res[i].id
                                })
                            }
                            zTreeObj.addNodes(treeNode, arr, true);

                            zTreeObj.expandNode(treeNode, true, false, false);// 将新获取的子节点展开
                        }
                    }
                });
            }

        }
        // zTree 树形菜单
        var zNodes = [];
        zTreeObj = $.fn.zTree.init($("#tree"), setting, zNodes);

        $("#btn-save").on('click', function () {
            var zTree = $.fn.zTree.getZTreeObj("tree");
            var nodes = zTree.getCheckedNodes(true);


            $(nodes).each(function(index, obj) {
                if ($.inArray(obj.id, parent.window.roleIdArr) >= 0) {
                    parent.layui.layer.msg("选择角色重复！");
                } else {
                    parent.window.roleIdArr.push(obj.id);
                    var roleSpan = $("<div id='" + obj.id + "'>" + obj.roleName + "<a href='#' onclick='delRole(\""+obj.id+"\")' class='layui-icon' style=\"color: #33ABA0;\">&#x1006;</a></div>");
                    $("#roleNames", parent.document).append(roleSpan);
                }
            });

            var index = parent.layer.getFrameIndex(window.name);
            parent.layer.close(index);
        });
    });


</script>

<%@include file="../footer.jsp"%>