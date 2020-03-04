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
                    name: "deptName"
                },
                simpleData: {
                    enable: true,
                    idKey: "id", // id编号命名
                    pIdKey: "parentDeptId", // 父id编号命名
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
                url: "${ctxPath}/dept/deptTree",
                dataType: "json",
                async: true,
                success: function (res) {
                    if (res != null && res.length > 0) {
                        var length = res.length;
                        for (var i = 0; i < length; i++) {
                            zNodes.push({
                                deptName: res[i].deptName,
                                id: res[i].id,
                                deptCode:res[i].deptCode,
                                parentDeptId: res[i].parentDeptId
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
                var deptName = $("#deptName",parent.document).val();
                if(deptName == obj.deptName){
                    parent.layui.layer.msg("选择部门不能是用户所在部门！");
                } else if($.inArray(obj.id,parent.window.deptIdArr) != -1){
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