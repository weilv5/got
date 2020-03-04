<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<link rel="stylesheet" href="${ctxPath}/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.core.js"></script>


<div class="layui-row layui-col-space10">
    <div class="layui-col-xs12 layui-col-sm2 layui-col-md2">
        <!-- tree -->
        <%--<ul id="moduleTree" class="tree-table-tree-box" lay-filter="moduleTree"></ul>--%>
        <ul id="tree" class="ztree"></ul>
    </div>
    <div class="layui-col-xs12 layui-col-sm10 layui-col-md10">
        <!-- 工具集 -->
        <div class="my-btn-box">
            <span class="fl">
                <a class="layui-btn layui-btn-danger" id="btn-delete-all">批量删除</a>
                <a class="layui-btn btn-default btn-add" id="btn-add">添加</a>
            </span>
            <span class="fr">
                <span class="layui-form-label">模块名称：</span>
                <div class="layui-input-inline">
                    <input type="text" id="moduleName" autocomplete="off" placeholder="请输入模块名称" class="layui-input">
                </div>
                <button class="layui-btn mgl-20" id="searchBtn">查询</button>
            </span>
        </div>
        <!-- table -->
        <div id="moduleTable" lay-filter="moduleTable"></div>
    </div>
</div>

<script>
    // layui方法
    layui.use(['tree', 'table', 'form', 'layer'], function () {
        var parentModuleId = "";
        var form = layui.form
            , table = layui.table
            , layer = layui.layer
            , tree = layui.tree
            , $ = layui.jquery;

        window.loadModule = function () {
            var where = {};
            if ($("#moduleName").val() != "") {
                where.moduleName = $("#moduleName").val();
            }
            if (parentModuleId)
                where.parentModuleId = parentModuleId;
            var tableIns = table.render({
                elem: '#moduleTable'
                , height: 'full-70'
                , cols: [[
                    {checkbox: true, fixed: true}
                    , {field: 'moduleName', title: '模块名称', width: 120}
                    , {field: 'moduleCode', title: '模块编码', width: 120}
                    , {field: 'moduleAddr', title: '模块地址', width: 200}
                    , {field: 'isVisible', title: '是否可见', toolbar: '#visible', width: 100}
                    , {field: 'isPublic', title: '是否公开', toolbar: '#public', width: 100}
                    , {fixed: 'right', title: '操作', width: 150, align: 'center', toolbar: '#barOption'}
                ]]
                , url: './page'
                , method: 'post'
                , page: true
                , request: {
                    limitName: "size"
                }
                , response: {
                    countName: "totalElements",
                    dataName: "content"
                }
                , limits: [30, 60, 90, 150, 300]
                , limit: 30
                , where: where
            });
        }

        loadModule();

        table.on('tool(moduleTable)', function (obj) {
            var data = obj.data
                , layEvent = obj.event;
            if (layEvent == "detail") {
                openLayer("${ctxPath}/module/?method=view&id=" + data.id, "查看模块", "700px", "500px");
            } else if (layEvent == "edit") {
                openLayer("${ctxPath}/module/?method=edit&id=" + data.id, "编辑模块", "700px", "500px");
            } else if (layEvent == "del") {
                parent.layui.layer.confirm("确定要删除选择的数据？", {icon: 3, title: '提示'}, function (index) {
                    parent.layui.layer.close(index);
                    parent.layui.layer.load(3, {time: 1000});
                    $.ajax({
                        url: "./delete/" + data.id,
                        type: "post",
                        dataType: "json",
                        success: function (data) {
                            if (data.responseCode == 0) {
                                parent.layui.layer.msg("删除成功");
                                loadModule();
                            } else {
                                parent.layui.layer.msg(data.msg);
                            }
                        }
                    })

                });
            }
        });

        //批量删除
        $("#btn-delete-all").on('click', function () {
            var checkStatus = table.checkStatus('moduleTable');
            if (checkStatus.data.length == 0) {
                parent.layui.layer.msg("请选择需要删除的数据");
            } else {
                layer.confirm("确定要删除选择的数据？", {icon: 3, title: '提示'}, function (index) {
                    var ids = "";
                    for (var i = 0; i < checkStatus.data.length; i++) {
                        //ids.push(checkStatus.data[i].id);
                        ids = ids + checkStatus.data[i].id + ","
                    }
                    console.log(JSON.stringify(ids))
                    $.ajax({
                        url: "./delete",
                        type: "post",
                        data: {"ids": ids},
                        dataType: 'json',
                        success: function (data) {
                            if (data.responseCode == 0) {
                                parent.layui.layer.msg("删除成功");
                                loadModule();
                            } else {
                                parent.layui.layer.msg(data.msg);
                            }
                        }
                    })
                    layer.close(index);
                })
            }
        });

        //添加
        $("#btn-add").on('click', function () {
            openLayer("${ctxPath}/module/?method=edit", "新增模块", "800px", "600px");
        });

        //查询
        $("#searchBtn").on('click', function () {
            loadModule();
        });

        var zTreeObj;
        // zTree 的参数配置，深入使用请参考 API 文档（setting 配置详解）
        var setting = {
            view: {
                dblClickExpand: false,
                showLine: true,
                showIcon: true
                //fontCss : {color: "#777","font-size":"16px"}
            },
            callback: {
                onClick: ztreeOnAsyncSuccess
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
            parentModuleId = treeNode.id;
            loadModule();
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
        // zTree 的数据属性，深入使用请参考 API 文档（zTreeNode 节点数据详解）
        var zNodes = [{
            moduleName: "系统模块"
        }];


        $(document).ready(function () {
            zTreeObj = $.fn.zTree.init($("#tree"), setting, zNodes);
            var rootNode = zTreeObj.getNodeByParam("moduleName", "系统模块");
            $("#"+rootNode.tId+"_a").click();
        });
    });

</script>
<script type="text/html" id="barOption">
    <a class="layui-btn layui-btn-mini" lay-event="detail">查看</a>
    <a class="layui-btn layui-btn-mini layui-btn-normal" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-mini layui-btn-danger" lay-event="del">删除</a>
</script>
<script type="text/html" id="visible">
    {{#  if(d.isVisible == 0 ){ }}
    否
    {{#  } else { }}
    是
    {{#  } }}
</script>
<script type="text/html" id="public">
    {{#  if(d.isPublic == 0 ){ }}
    否
    {{#  } else { }}
    是
    {{#  } }}
</script>
<%@include file="../footer.jsp" %>