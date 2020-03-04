<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<link rel="stylesheet" href="${ctxPath}/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.excheck.js"></script>
<div style="height: 400px; width: 100%;">
    <div class="layui-container">
        <ul id="tree" class="ztree" ></ul>

    </div>
    <div class="layui-layer-btn layui-layer-btn-" style="position: fixed;width:100%;bottom: 10px;">
        <a class="layui-layer-btn0" id="btn-save" style="float: right;margin-right: 30px;">确认</a>
    </div>
</div>
<script>
    // layui方法
    layui.use(['tree', 'table', 'form', 'layer'], function () {
        var parentDeptId = "";
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
                url: "${ctxPath}/deptList",
                autoParam:["parentDeptId"],
                contentType: "application/json",
                otherParam: {}
            },
            data: {
                key: {
                    name: "deptName"
                },
                simpleData: {
                    enable: true,
                    idKey: "id", // id编号命名
                    pIdKey: "parentDeptId", // 父id编号命名
                    rootPId: 0//根节点
                }
            },


        };
        function ztreeOnAsyncSuccess(event, treeId, treeNode,clickFlag){

            parentDeptId = treeNode.id;

            var treeObj = $.fn.zTree.getZTreeObj(treeId);
            var node = treeObj.getNodeByTId(treeNode.tId);
            if(node.children == null || node.children == "undefined") {
                $.ajax({
                    type: "post",
                    url: "${ctxPath}/deptList",
                    data: {
                        parentDeptId: treeNode.id
                    },
                    dataType: "json",
                    async: true,
                    success: function (res) {
                        var arr = [];
                        if (res != null && res.length > 0) {
                            var length = res.length;
                            for (var i = 0; i < length; i++) {
                                arr.push({
                                    deptName: res[i].deptName,
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

                var deptName = $("#deptName",parent.document).val();
                if(deptName == obj.deptName){
                    parent.layui.layer.msg("选择部门不能是用户所在部门！");
                } else if($.inArray(obj.id,parent.window.deptIdArr) > 0){
                    parent.layui.layer.msg("选择部门重复！");
                }else{
                    parent.window.deptIdArr.push(obj.id);
                    var deptSpan = $("<div id='" + obj.id + "'>" + obj.deptName + "<a href='#' onclick='deptDel(\""+obj.id+"\")' class='layui-icon' style=\"color: #33ABA0;\">&#x1006;</a></div>");
                    $("#deptNames",parent.document).append(deptSpan);
                }
            });

            var index = parent.layer.getFrameIndex(window.name);
            parent.layer.close(index);
        });
    });


</script>

<%@include file="../footer.jsp"%>