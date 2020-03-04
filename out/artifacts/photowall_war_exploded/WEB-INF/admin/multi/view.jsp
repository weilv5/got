<%--
  Created by IntelliJ IDEA.
  User: pgj1993
  Date: 2018/11/28
  Time: 15:12
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<link rel="stylesheet" href="${ctxPath}/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.core.js"></script>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-xs12 layui-col-sm2 layui-col-md2" >
            <div class="layui-card" style="overflow:auto;">
                <ul id="tree" class="ztree" style="min-height: 450px"></ul>
            </div>
        </div>
        <div class="layui-col-xs12 layui-col-sm10 layui-col-md10">
            <div class="layui-card">

                <div class="layui-card-body">
                    <div style="padding-bottom: 10px;">
                        <button class="layui-btn layuiadmin-btn-list" lay-event="add" data-type="add"><i
                                class="layui-icon layui-icon-add-1"></i>添加
                        </button>
                        <button class="layui-btn layuiadmin-btn-list" lay-event="batchdel" data-type="batchdel">批量删除
                        </button>
                    </div>
                    <table id="multiValueTable" lay-filter="multiValueTable"></table>
                </div>
            </div>
        </div>

    </div>
</div>
<script>
    var zTreeObj;
    layui.config({
        base: '${ctxPath}/resources/layuiadmin/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['tree', 'index', 'form', 'table', 'layer'], function () {
        var table = layui.table
            , form = layui.form
            , $ = layui.jquery;

        var codeId = "${id}";

        var parentItemId = null;

        window.parentItemIdFromView = null;
        window.pcodeNameFromView = "";

        window.loadCode = function () {
            var where = {};
            if ($("#codeName").val() != "") {
                where.codeName = $("#codeName").val();
            }
            if (codeId)
                where.codeId = codeId;
            if(parentItemId){
                where.parentItemId = parentItemId;
            }
            if(codeId==parentItemId){
                where.parentItemId = null;
            }
            table.render({
                elem: '#multiValueTable'
                , cols: [[
                    {checkbox: true, fixed: true}
                    , {field: 'codeName', title: '代码项显示值', width: 120}
                    , {field: 'itemValue', title: '代码项值', width: 120}
                    , {fixed: 'right', title: '操作', align: 'center', toolbar: '#barOption'}
                ]]
                , url: '${ctxPath}/multiValue/layUIPage'
                , method: 'post'
                , page: true
                , request: {
                    limitName: "size"
                }
                , limits: [30, 60, 90, 150, 300]
                , limit: 30
                , where: where
            });
        };

        loadCode();

        //监听工具条
        table.on('tool(multiValueTable)', function (obj) {
            var data = obj.data
                , layEvent = obj.event;
            if (layEvent == "edit") {
                add(data);
            } else if (layEvent == "del") {
                del(data);
            }
        });

        var active = {
            batchdel: batchdel,
            add: add
        };

        $('.layui-btn.layuiadmin-btn-list').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });


        function add(data) {
           // url = "${ctxPath}/multiValue/?method=edit";
            if (data) {
                url = "${ctxPath}/multiValue/edit?method=edit" + "&id=" + data.id;
                openSubmitLayer(url, "编辑多维代码", '500px', '300px');
            } else {
                url ="${ctxPath}/multiValue/edit?method=add" + "&id=${id}&codeName=${codeName}";
                openSubmitLayer(url, "添加多维代码", '500px', '450px');


            }

            reloadCodeTree();
        }

        function del(value) {

            $.ajax({
                url: "${ctxPath}/multiValue/checkHasChild",
                type: "post",
                data: {"ids": value.id},
                dataType: "json",
                success: function (data) {
                    if (data.responseCode == 0) {
                        layer.confirm('确定删除吗？', function (index) {
                            $.ajax({
                                url: "${ctxPath}/multiValue/delete/" + value.id,
                                type: "post",
                                dataType: "json",
                                success: function (d) {
                                    if (d.responseCode == 0) {
                                        parent.layui.layer.msg("删除成功");
                                        table.reload('multiValueTable');
                                        // var node = zTreeObj.getNodesByParam("id", value.id);
                                        // zTreeObj.removeNode(node[0]);
                                        reloadCodeTree();
                                    } else {
                                        parent.layui.layer.msg(d.msg);
                                    }
                                }
                            });
                            layer.close(index);
                        });
                    } else {
                        parent.layui.layer.msg("存在子节点，无法删除");
                    }
                }
            });
        }

        function batchdel() {
            var checkStatus = table.checkStatus('multiValueTable')
                , checkData = checkStatus.data; //得到选中的数据
            if (checkData.length === 0) {
                return layer.msg('请选择数据');
            }
            var ids = "";
            for (var i = 0; i < checkStatus.data.length; i++) {
                ids = ids + checkStatus.data[i].id + ",";
            }
            $.ajax({
                url: "${ctxPath}/multiValue/checkHasChild",
                type: "post",
                data: {"ids": ids},
                dataType: 'json',
                success: function (data) {
                    if (data.responseCode == 0) {
                        layer.confirm('确定删除吗？', function (index) {
                            $.ajax({
                                url: "${ctxPath}/multiValue/delete",
                                type: "post",
                                data: {"ids": ids},
                                dataType: 'json',
                                success: function (value) {
                                    if (value.responseCode == 0) {
                                        parent.layui.layer.msg("批量删除成功");
                                        table.reload('multiValueTable');
                                        reloadCodeTree();
                                    } else {
                                        parent.layui.layer.msg(value.msg);
                                    }
                                }
                            });

                            layer.close(index);
                        });
                    } else if (data.responseCode == 2) {
                        parent.layui.layer.msg("存在子节点，无法删除");
                    }
                }
            });
        }

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

        function ztreeOnClick(event,treeId,treeNode) {
            var treeObj = $.fn.zTree.getZTreeObj(treeId);
            var node = treeObj.getNodeByTId(treeNode.tId);
            parentItemId = node.id;
            window.parentItemIdFromView = parentItemId;
            window.pcodeNameFromView = node.codeName;
            loadCode();
        }

        window.reloadCodeTree = function(){
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
            reloadCodeTree();
        });

    });

</script>

<script type="text/html" id="barOption">
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="edit"><i
            class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del"><i
            class="layui-icon layui-icon-delete"></i>删除</a>
</script>
<%@include file="../footer.jsp" %>