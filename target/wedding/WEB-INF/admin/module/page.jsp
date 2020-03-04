<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<link rel="stylesheet" href="${ctxPath}/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${ctxPath}/resources/js/jquery.js"></script>
<link rel="stylesheet" href="${ctxPath}/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.core.js"></script>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-xs12 layui-col-sm2 layui-col-md2">
            <div class="layui-card">
                <!-- tree -->
                <ul id="tree" class="ztree" style="min-height: 450px"></ul>
            </div>
        </div>
        <div class="layui-col-xs12 layui-col-sm10 layui-col-md10">
            <div class="layui-card">
                <form class="layui-form layui-card-header layuiadmin-card-header-auto">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">模块名称：</label>
                            <div class="layui-input-inline">
                                <input type="text" name="moduleName" autocomplete="off" placeholder="请输入模块名称"
                                       class="layui-input">
                                <input type="hidden" name="parentModuleId" id="parentModuleId">
                                <input type="hidden" id="parentModuleName">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <button class="layui-btn layuiadmin-btn-list" lay-submit lay-filter="LAY-app-search" id="LAY-app-search">
                                <i class="layui-icon layui-icon-search layuiadmin-button-btn"></i>
                            </button>
                            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                        </div>
                    </div>
                </form>
                <div class="layui-card-body">
                    <div style="padding-bottom: 10px;">
                        <button class="layui-btn layuiadmin-btn-list" lay-event="batchdel" data-type="batchdel">批量删除
                        </button>
                        <button class="layui-btn layuiadmin-btn-list" lay-event="add" data-type="add">添加</button>
                    </div>
                    <table id="moduleTable" lay-filter="moduleTable"></table>
                </div>
            </div>
        </div>
    </div>
</div>
<script>

    layui.config({
        base: '${ctxPath}/resources/layuiadmin/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['layer', 'form', 'table'], function () {
        var table = layui.table
            , form = layui.form;

        table.render({
            elem: '#moduleTable'
            , cols: [[
                {checkbox: true, fixed: true}
                , {field: 'moduleName', title: '模块名称', width: 120}
                , {field: 'moduleCode', title: '模块编码', width: 120}
                , {field: 'moduleAddr', title: '模块地址', width: 200}
                , {field: 'isVisible', title: '是否可见',  width: 100, templet: function(d){
                        if (1 == d.isVisible)
                            return '是';
                        else
                            return '否';
                    }}
                , {field: 'isPublic', title: '是否公开', width: 100,  templet: function(d){
                        if (1 == d.isPublic)
                            return '是';
                        else
                            return '否';
                    }}
                , {fixed: 'right', title: '操作', align: 'center', toolbar: '#barOption'}
            ]]
            , url: './layUIPage'
            , method: 'post'
            , page: true
            , request: {
                limitName: "size"
            }
            , limits: [30, 60, 90, 150, 300]
            , limit: 30
        });

        //监听搜索
        form.on('submit(LAY-app-search)', function (data) {
            var field = data.field;
            //执行重载
            table.reload('moduleTable', {
                where: field
            });
            return false;
        });

        //监听工具条
        table.on('tool(moduleTable)', function (obj) {
            var data = obj.data
                , layEvent = obj.event;
            if (layEvent == "detail") {
                detail(data);
            } else if (layEvent == "edit") {
                add(data);
            } else if (layEvent == "del") {
                del(data);
            }
        });

        var $ = layui.$, active = {
            batchdel: batchdel,
            add: add
        };

        $('.layui-btn.layuiadmin-btn-list').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });

        function add(data) {
            url = "${ctxPath}/module/edit?";
            if (data) {
                url += "&id=" + data.id;
                openSubmitLayer(url, "编辑模块", '700px', '500px');
            }else{
                if(!$("#parentModeluId").val()){
                    url += "&parentModuleId=" + $("#parentModuleId").val();
                }
                openSubmitLayer(url, "添加模块", '700px', '500px');
            }
        }

        function detail(data) {
            layer.open({
                type: 2,
                title: "查看模块",
                maxmin: true,
                area: ["750px", "600px"],
                content: "${ctxPath}/module/?method=view&id=" + data.id,
                btn: ['关闭']
            });
        }

        function del(data) {
            if(data.hasChild == null || data.hasChild == 0) {
                layer.confirm('确定删除吗？', function (index) {
                    $.ajax({
                        url: "./delete/" + data.id,
                        type: "post",
                        dataType: "json",
                        success: function (result) {
                            if (result.responseCode == 0) {
                                parent.layui.layer.msg("删除成功");
                                table.reload('moduleTable');
                                var node = zTreeObj.getNodesByParam("id", data.id);
                                zTreeObj.removeNode(node[0]);
                            } else {
                                parent.layui.layer.msg(result.msg);
                            }
                        }
                    });
                    layer.close(index);
                });
            }else{
                parent.layui.layer.msg("存在子模块无法删除");
            }
        }


        function batchdel() {
            var checkStatus = table.checkStatus('moduleTable'),
                checkData = checkStatus.data,//得到选中的数据
                hasChild = false;
            if (checkData.length === 0) {
                return layer.msg('请选择数据');
            }
            for(var i = 0; i < checkData.length;i++) {
                if (checkData[i].hasChild > 0) {
                    hasChild = true;//存在子部门
                }
            }
            if(!hasChild) {
                layer.confirm('确定删除吗？', function (index) {
                    var ids = "";
                    for (var i = 0; i < checkStatus.data.length; i++) {
                        ids = ids + checkStatus.data[i].id + ",";
                    }
                    $.ajax({
                        url: "./delete",
                        type: "post",
                        data: {"ids": ids},
                        dataType: 'json',
                        success: function (data) {
                            if (data.responseCode == 0) {
                                parent.layui.layer.msg("删除成功");
                                for (var i = 0; i < checkStatus.data.length; i++) {
                                    var node = zTreeObj.getNodesByParam("id", checkStatus.data[i].id);
                                    zTreeObj.removeNode(node[0]);
                                }
                                table.reload('moduleTable');
                            } else {
                                parent.layui.layer.msg(data.msg);
                            }
                        }
                    });
                    layer.close(index);
                });
            }else{
                parent.layui.layer.msg("存在子模块无法删除");
            }
        }

        var zTreeObj;
        // zTree 的参数配置，深入使用请参考 API 文档（setting 配置详解）
        var setting = {
            view: {
                dblClickExpand: false,
                showLine: true,
                showIcon: false
                //fontCss : {color: "#777","font-size":"16px"}
            },
            callback: {
                onClick:ztreeOnClick,
                onExpand: ztreeOnAsyncSuccess
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
        function ztreeOnClick(event, treeId, treeNode) {
            var treeObj = $.fn.zTree.getZTreeObj(treeId);
            var node = treeObj.getNodeByTId(treeNode.tId);
            $("#parentModuleId").val(node.id);
            $("#parentModuleName").val(node.moduleName);
            $("#LAY-app-search").click();
        }

        function ztreeOnAsyncSuccess(event, treeId, treeNode) {
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
                            var isParent=false;
                            for (var i = 0; i < length; i++) {
                                if(res[i].hasChild)
                                    isParent=res[i].hasChild>0?true:false;
                                arr.push({
                                    moduleName: res[i].moduleName,
                                    id: res[i].id,
                                    isParent:isParent
                                })
                                isParent=false;
                            }
                            zTreeObj.addNodes(treeNode, arr, true);
                            zTreeObj.expandNode(treeNode, true, false, false);// 将新获取的子节点展开
                        }
                    }
                });
            }

        };

        window.reloadTree = function(){
            var zNodes = [{
                moduleName: "模块树",
                id: "",
                isParent:true,
                open:true,
                children:[]
              }
            ];
            $.ajax({
                type: "post",
                url: "./list",
                dataType: "json",
                async: true,
                success: function (res) {
                    var arr = [];
                    if (res != null && res.length > 0) {
                        var length = res.length;
                        var isParent=false;
                        for (var i = 0; i < length; i++) {
                            if(res[i].hasChild)
                                isParent=res[i].hasChild>0?true:false;
                            arr.push({
                                moduleName: res[i].moduleName,
                                id: res[i].id,
                                isParent:isParent
                            })
                            isParent=false;
                        }
                    }
                    zNodes[0].children=arr;
                    zTreeObj = $.fn.zTree.init($("#tree"), setting, zNodes);
                }
            });
        }

        $(document).ready(function () {
            // zTree 的数据属性，深入使用请参考 API 文档（zTreeNode 节点数据详解）
            $("#tree").height($(document).height()-40)
            reloadTree();
        });
    })


</script>

<script type="text/html" id="barOption">
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="edit"><i
            class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del"><i
            class="layui-icon layui-icon-delete"></i>删除</a>
</script>
<%@include file="../footer.jsp" %>