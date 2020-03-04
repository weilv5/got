<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<link rel="stylesheet" href="${ctxPath}/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.core.js"></script>

<div class="layui-fluid">
    <ul id="moduleTree" class="ztree"></ul>
</div>

<script>
    var zTreeObj;
    var parentModuleId = "";
    var zNodes = [];
    // zTree 的参数配置，深入使用请参考 API 文档（setting 配置详解）
    var setting = {
        view: {
            dblClickExpand: false,
            showLine: true,
            showIcon: true
            //fontCss : {color: "#777","font-size":"16px"}
        },
        callback: {
            onClick: ztreeOnAsyncSuccess,
            //onDblClick: ztreeDblClick
        },
        async: {
            enable: true,
            url: "./list",
            autoParam: ["parentModuleId"],
            contentType: "application/json",
            otherParam: {}
        },
        data: {
            key: {
                name: "moduleName"
            },
            simpleData: {
                enable: true,
                idKey: "id", // id编号命名
                pIdKey: "parentModuleId", // 父id编号命名
                rootPId: 0//根节点
            }
        },


    };

    function ztreeOnAsyncSuccess(event, treeId, treeNode) {
        parent.window.pModuleName = treeNode.moduleName;
        parent.window.parentModuleId = treeNode.id;
        parentModuleId = treeNode.id;
        var treeObj = $.fn.zTree.getZTreeObj(treeId);
        var node = treeObj.getNodeByTId(treeNode.tId);
        if (node.children == null || node.children == "undefined") {
            $.ajax({
                type: "post",
                url: "./list",
                data: {
                    parentModuleId: treeNode.id
                },
                dataType: "json",
                async: true,
                success: function (res) {
                    var arr = [];
                    if (res != null && res.length > 0) {
                        var length = res.length;
                        for (var i = 0; i < length; i++) {
                            arr.push({
                                moduleName: res[i].moduleName,
                                id: res[i].id
                            })
                        }
                        zTreeObj.addNodes(treeNode, arr, true);

                        zTreeObj.expandNode(treeNode, true, false, false);// 将新获取的子节点展开
                    }
                }
            });
        }

    };

    function ztreeDblClick(event, treeId, treeNode){
        $("#parentModuleName",parent.document).val(treeNode.moduleName);
        $("#parentModuleId", parent.document).val(treeNode.id);
        var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
        parent.layer.close(index);
    }

    $(document).ready(function () {
        zTreeObj = $.fn.zTree.init($("#moduleTree"), setting, zNodes);
    });


</script>

<%@include file="../footer.jsp" %>