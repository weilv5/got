<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<link rel="stylesheet" href="${ctxPath}/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.excheck.js"></script>
<div class="layui-fluid">
    <ul id="tree" class="ztree"></ul>
    <a class="layui-btn btn-default btn-add" id="btn-save" style="float: right">确认</a>
</div>
<script>
    // layui方法
    layui.use(['tree', 'table', 'form', 'layer'], function () {
        var form = layui.form
            , table = layui.table
            , layer = layui.layer
            , tree = layui.tree
            , $ = layui.jquery;
        var zNodes = [];
        var tree = [];
        var roleId = parent.id;
        var parentRoleId = parent.parentRoleId;
        var parentModuleId = "";



        var zTreeObj;
        // zTree 的参数配置，深入使用请参考 API 文档（setting 配置详解）
        var setting = {
            check: {
                enable: true,
               chkboxType : { "Y" : "", "N" : "" }
            },
            view: {
                dblClickExpand: false,
                showLine: true,
                showIcon: true
                //fontCss : {color: "#777","font-size":"16px"}
            },
            callback: {
                onClick: ztreeOnAsyncSuccess,
                //onCheck:zTreeOnCheck
            },
            async: {
                enable: true,
                url: "${ctxPath}/module/list",
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

        var data = {};
        window.moduleIds = [];
        var dt = (new Date()).getTime();
        data.dt = dt;
        data.roleId = roleId;
        if(parentRoleId && parentRoleId!="null")
            data.parentRoleId = parentRoleId;
        //window.onlySetParent = false;
        $.ajax({
            url: "${ctxPath}/role/moduleTreeForRole",
            data: data,
            dataType: "json",
            type: "post",
            success: function(data){
                console.info("moduleTreeForRole");

                getSelectedModule(data.nodes);//获取相应角色模块数组

                zTreeObj = $.fn.zTree.init($("#tree"), setting);


            },
            error: function(){
                alert("获取模块失败");
            }
        });


        function getSelectedModule(nodes){
            if(!nodes)
                return;
            var length = nodes.length;
            for(var i = 0; i < length; i++){
                var node = nodes[i];
                if(node.state && node.state.checked) {
                    zNodes.push(node.moduleId);
                    /*zNodes.push({
                        moduleName: node.text,
                        id: node.moduleId,
                        checked: true
                    });*/
                }
                getSelectedModule(node.nodes);
            }
        }






        function ztreeOnAsyncSuccess(event, treeId, treeNode) {
            parentModuleId = treeNode.id;
            var treeObj = $.fn.zTree.getZTreeObj(treeId);
            var node = treeObj.getNodeByTId(treeNode.tId);
            if (node.children == null || node.children == "undefined") {
                $.ajax({
                    type: "post",
                    url: "${ctxPath}/module/list",
                    data: {
                        parentModuleId: treeNode.id
                    },
                    dataType: "json",
                    async: true,
                    success: function (res) {
                        var arr = [];
                        if (res != null && res.length > 0) {
                            var length = res.length;
                            console.info("res："+JSON.stringify(res));
                            console.info("zNodes："+JSON.stringify(zNodes));
                            for (var i = 0; i < length; i++) {
                                if($.inArray(res[i].id, zNodes)>=0 ) {
                                    arr.push({
                                        moduleName: res[i].moduleName,
                                        id: res[i].id,
                                        checked:true
                                    });
                                }else{
                                    arr.push({
                                        moduleName: res[i].moduleName,
                                        id: res[i].id
                                    });
                                }
                            }
                            zTreeObj.addNodes(treeNode, arr, true);

                            zTreeObj.expandNode(treeNode, true, false, false);// 将新获取的子节点展开
                        }
                    }
                });
            }

        };
        $("#btn-save").on('click', function () {
            var zTree = $.fn.zTree.getZTreeObj("tree");
            var nodes = zTree.getCheckedNodes(true);
            $(nodes).each(function(index, obj) {
                window.moduleIds.push(obj.id);
            });
            setModule();

        });

        function setModule() {
            $.ajax({
                type:"post",
                url: "${ctxPath}/role/saveModuleRole",
                data:{
                    moduleIds: window.moduleIds,
                    roleId: parent.id
                },
                success: function(data){
                    parent.layui.layer.msg("提交成功");
                    var index = parent.layer.getFrameIndex(window.name);
                    parent.layer.close(index);

                },
                error: function () {
                    parent.layui.layer.msg(data.msg);

                }
            });
        }


    });

    function getSelectedModule(nodes){
        if(!nodes)
            return;
        var length = nodes.length;
        for(var i = 0; i < length; i++){
            var node = nodes[i];
            if(node.state && node.state.checked)
                window.moduleIdArr.push(node.moduleId);
            getSelectedModule(node.nodes);
        }
    }




</script>

<%@include file="../footer.jsp"%>