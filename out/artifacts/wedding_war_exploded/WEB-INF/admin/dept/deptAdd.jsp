<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<link rel="stylesheet" href="${ctxPath}/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.excheck.js"></script>
<div class="layui-container">
    <ul id="tree" class="ztree"></ul>
</div>

<script>
    layui.config({
        base: '${ctxPath}/resources/layuiadmin/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['layer'], function () {
        //树形菜单
        var setting = {
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
                }
            }
        };

        function ztreeOnClick(event, treeId, treeNode) {
            if(treeNode.deptName == "组织结构"){
                parent.layui.layer.msg("请选择部门！");
            }else{
                parent.window.parentDeptId = treeNode.id;
                parent.window.parentDeptName = treeNode.deptName;
            }

        }
        window.reloadDeptTree = function(){
            var zNodes = {
                deptName: "组织结构",
                id:"",
                isParent:true,
                open:true
            };
            $.ajax({
                type: "post",
                url: "${ctxPath}/dept/deptTree",
                dataType: "json",
                async: true,
                success: function (res) {
                    var arr = [];
                    var parentDeptId;
                    if (res != null && res.length > 0) {
                        var length = res.length;
                        for (var i = 0; i < length; i++) {
                            if (!res[i].parentDeptId)
                                parentDeptId = "";
                            else
                                parentDeptId = res[i].parentDeptId;
                            arr.push({
                                deptName: res[i].deptName,
                                id: res[i].id,
                                parentDeptId:parentDeptId
                            })
                        }
                    }
                    arr.push(zNodes);
                    $.fn.zTree.init($("#tree"), setting, arr);

                },
                error:function(){
                    layer.close(index);
                    layer.alert('加载失败');
                }
            });
        };
        $(document).ready(function () {
            $("#tree").height($(document).height() - 40);
            reloadDeptTree();
        });
    });


</script>

<%@include file="../footer.jsp"%>