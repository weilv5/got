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
    layui.config({
        base: '${ctxPath}/resources/layuiadmin/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['layer'], function () {
        var $ = layui.jquery;
        //树形菜单
        var setting = {
            check: {
                enable: true,
                chkboxType : { "Y" : "", "N" : "" }
            },
            view: {
                dblClickExpand: false,
                showLine: true,
                showIcon: false
            },
            callback: {
                onClick: ztreeOnClick
                //onExpand:ztreeOnAsyncSuccess
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
            }
        };

        function ztreeOnClick(event, treeId, treeNode) {
        }
        $(document).ready(function () {
            var index = layer.load(1);
            var zNodes = [];
            $.ajax({
                type: "post",
                url: "${ctxPath}/role/list",
                dataType: "json",
                async: true,
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
                        $.fn.zTree.init($("#tree"), setting, zNodes);
                        layer.close(index);
                    }
                },
                error: function () {
                    layer.close(index);
                    layer.alert('加载失败');
                }
            });
        });

        $("#btn-save").on('click', function () {
            var zTree = $.fn.zTree.getZTreeObj("tree");
            var nodes = zTree.getCheckedNodes(true);


            $(nodes).each(function(index, obj) {
                if($.inArray(obj.id,parent.window.roleIdArr) != -1){
                    parent.layui.layer.msg("选择部门重复！");
                }else{
                    parent.window.roleIdArr.push(obj.id);
                    var roleSpan = $("<div id='" + obj.id + "'>" + obj.roleName + "<a href='#' onclick='delRole(\""+obj.id+"\")' class='layui-icon' style=\"color: #33ABA0;\">&#x1006;</a></div>");
                    $("#roleNames",parent.document).append(roleSpan);
                }
            });

            var index = parent.layer.getFrameIndex(window.name);
            parent.layer.close(index);
        });
    });


</script>

<%@include file="../footer.jsp"%>