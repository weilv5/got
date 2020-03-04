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
        var id = "${id}";


        var setting = {
            view: {
                dblClickExpand: false,
                showLine: true,
                showIcon: false
            },
            callback: {
                onClick: ztreeOnClick
            },
            data: {
                key: {
                    name: "codeName"
                },
                simpleData: {
                    enable: true,
                    idKey: "id", // id编号命名
                    pIdKey: "parentItemId", // 父id编号命名
                    rootPId: "${id}"//根节点
                }
            },
        };

        function ztreeOnClick(event, treeId, treeNode) {
                parent.window.parentItemId = treeNode.id;
                parent.window.pcodeName = treeNode.codeName;

        }


        window.reloadMultiValueTree = function(){
            var zNodes = [{
                codeName: "${codeName}",
                id: "${id}",
                isParent:true,
                open:true,
            }];

            var parentId = "${id}";

            $.ajax({
                type: "post",
                url: "${ctxPath}/multiValue/list/?codeId=${id}",
                dataType: "json",
                async: true,
                success: function (res) {
                    if (res != null && res.length > 0) {
                        var length = res.length;
                        for (var i = 0; i < length; i++) {
                            if (parentId==res[i].codeId){
                                if(res[i].parentItemId==null||res[i].parentItemId==""){
                                    parentItemId = res[i].codeId;

                                    if(res[i].childNum>0) {

                                        zNodes.push({
                                            codeName: res[i].codeName,
                                            id: res[i].id,
                                            parentItemId:parentItemId,
                                            isParent:true
                                        });
                                    }else{
                                        zNodes.push({
                                            codeName: res[i].codeName,
                                            id: res[i].id,
                                            parentItemId:parentItemId,
                                            isParent:false
                                        });
                                    }
                                }
                                else{
                                    parentItemId = res[i].parentItemId;
                                    if(res[i].childNum>0){
                                        zNodes.push({
                                            codeName: res[i].codeName,
                                            id: res[i].id,
                                            parentItemId:parentItemId,
                                            isParent:true
                                        });
                                    }else{
                                        zNodes.push({
                                            codeName: res[i].codeName,
                                            id: res[i].id,
                                            parentItemId:parentItemId,
                                            isParent:false
                                        });
                                    }

                                }

                            }




                        }
                    }

                    zTreeObj = $.fn.zTree.init($("#tree"), setting, zNodes);

                },
                error:function(){
                    layer.close(index);
                    layer.alert('加载失败');
                }
            });

        };
        $(document).ready(function () {
            $("#tree").height($(document).height() - 40);
            reloadMultiValueTree();
        });
    });


</script>

<%@include file="../footer.jsp"%>