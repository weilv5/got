<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<link rel="stylesheet" href="${ctxPath}/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.core.js"></script>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-xs12 layui-col-sm2 layui-col-md2">
            <div class="layui-card" style="overflow:auto;">
                <ul id="tree" class="ztree" style="min-height: 450px"></ul>
            </div>
        </div>
        <div class="layui-col-xs12 layui-col-sm10 layui-col-md10">
            <div class="layui-card">
                <form class="layui-form layui-card-header layuiadmin-card-header-auto">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">部门名称</label>
                            <div class="layui-input-inline">
                                <input type="text" name="deptName" id="deptName" autocomplete="off"
                                       placeholder="请输入部门名称" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <button class="layui-btn layuiadmin-btn-list" lay-submit lay-filter="LAY-app-search">
                                <i class="layui-icon layui-icon-search layuiadmin-button-btn"></i>
                            </button>
                            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                        </div>
                    </div>
                </form>
                <div class="layui-card-body">
                    <div style="padding-bottom: 10px;">
                        <button class="layui-btn layuiadmin-btn-list" lay-event="add" data-type="add"><i
                                class="layui-icon layui-icon-add-1"></i>添加
                        </button>
                        <button class="layui-btn layuiadmin-btn-list" lay-event="batchdel" data-type="batchdel">批量删除
                        </button>
                    </div>
                    <table id="departmentTable" lay-filter="departmentTable"></table>
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
        var parentDeptId = "";
        window.loadDept = function () {
            var where = {};
            if ($("#deptName").val() != "") {
                where.deptName = $("#deptName").val();
            }
            if (parentDeptId)
                where.parentDeptId = parentDeptId;
            table.render({
                elem: '#departmentTable'
                , cols: [[
                    {checkbox: true, fixed: true}
                    , {field: 'deptName', title: '部门名称', width: 120}
                    , {field: 'deptCode', title: '部门编码', width: 120}
                    , {fixed: 'right', title: '操作', align: 'center', toolbar: '#barOption'}
                ]]
                , url: './layUIPages'
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
        loadDept();

        //监听搜索
        form.on('submit(LAY-app-search)', function (data) {
            var field = data.field;
            //执行重载
            table.reload('departmentTable', {
                where: field
            });
            return false;
        });

        //监听工具条
        table.on('tool(departmentTable)', function (obj) {
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

        var active = {
            batchdel: batchdel,
            add: add
        };

        $('.layui-btn.layuiadmin-btn-list').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });

        function add(data) {
            url = "${ctxPath}/dept/?method=edit";
            if (data) {
                url += "&id=" + data.id;
                openSubmitLayer(url, "编辑部门", '600px', '500px');
            } else {
                openSubmitLayer(url, "添加部门", '600px', '500px');
            }
        }

        function detail(data) {
            layer.open({
                type: 2,
                title: "查看部门",
                maxmin: true,
                area: ["600px", "500px"],
                content: "${ctxPath}/dept/?method=view&id=" + data.id
            });
        }

        function del(value) {
            $.ajax({
                url: "./checkHasChild",
                type: "post",
                data: {"ids": value.id},
                dataType: "json",
                success: function (data) {
                    if (data.responseCode == 0) {
                        layer.confirm('确定删除吗？', function (index) {
                            $.ajax({
                                url: "./delete/" + value.id,
                                type: "post",
                                dataType: "json",
                                success: function (d) {
                                    if (d.responseCode == 0) {
                                        parent.layui.layer.msg("删除成功");
                                        table.reload('departmentTable');
                                        var node = zTreeObj.getNodesByParam("id", value.id);
                                        zTreeObj.removeNode(node[0]);
                                    } else {
                                        parent.layui.layer.msg(d.msg);
                                    }
                                }
                            });
                            layer.close(index);
                        });
                    } else {
                        parent.layui.layer.msg("存在子部门，无法删除");
                    }
                }
            });
        }

        function batchdel() {
            var checkStatus = table.checkStatus('departmentTable')
                , checkData = checkStatus.data; //得到选中的数据
            if (checkData.length === 0) {
                return layer.msg('请选择数据');
            }
            var ids = "";
            for (var i = 0; i < checkStatus.data.length; i++) {
                ids = ids + checkStatus.data[i].id + ",";
            }
            $.ajax({
                url: "./checkHasChild",
                type: "post",
                data: {"ids": ids},
                dataType: 'json',
                success: function (data) {
                    if (data.responseCode == 0) {
                        layer.confirm('确定删除吗？', function (index) {
                            $.ajax({
                                url: "./delete",
                                type: "post",
                                data: {"ids": ids},
                                dataType: 'json',
                                success: function (value) {
                                    if (value.responseCode == 0) {
                                        for (var i = 0; i < checkStatus.data.length; i++) {
                                            var node = zTreeObj.getNodesByParam("id", checkStatus.data[i].id);
                                            zTreeObj.removeNode(node[0]);
                                        }
                                        table.reload('departmentTable');
                                    } else {
                                        parent.layui.layer.msg(value.msg);
                                    }
                                }
                            });

                            layer.close(index);
                        });
                    } else if (data.responseCode == 2) {
                        parent.layui.layer.msg("存在子部门，无法删除");
                    }
                }
            });
        }

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
                    pIdKey: "parentDeptId"// 父id编号命名
                }
            }
        };
        function ztreeOnClick(event,treeId,treeNode) {
            var treeObj = $.fn.zTree.getZTreeObj(treeId);
            var node = treeObj.getNodeByTId(treeNode.tId);
            parentDeptId = node.id;
            loadDept();
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
                    zTreeObj = $.fn.zTree.init($("#tree"), setting, arr);

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

<script type="text/html" id="barOption">
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="detail"><i
            class="layui-icon layui-icon-about"></i>查看</a>
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="edit"><i
            class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del"><i
            class="layui-icon layui-icon-delete"></i>删除</a>
</script>
<%@include file="../footer.jsp" %>
