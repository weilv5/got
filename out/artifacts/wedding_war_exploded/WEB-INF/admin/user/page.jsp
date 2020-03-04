<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<link rel="stylesheet" href="${ctxPath}/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.core.js"></script>
<div class="layui-fluid">
    <div class="layui-row layui-col-space15">
        <div class="layui-col-xs12 layui-col-sm2 layui-col-md2">
            <div class="layui-card">
                <ul id="tree" class="ztree" style="min-height: 450px"></ul>
            </div>
        </div>
        <div class="layui-col-xs12 layui-col-sm10 layui-col-md10">
            <div class="layui-card">
                <form class="layui-form layui-card-header layuiadmin-card-header-auto">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">姓名</label>
                            <div class="layui-input-inline">
                                <input type="text" id="name" name="name" autocomplete="off"
                                       placeholder="请输入姓名" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <label class="layui-form-label">禁用用户</label>
                            <div class="layui-input-inline">
                                <select id="enable"
                                        name="enable"
                                        class="layui-select" style="width: 100px;">
                                    <option value="0">是</option>
                                    <option value="1" selected>否</option>
                                </select>
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
                    <table id="userTable" lay-filter="userTable"></table>
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
    }).use(['tree', 'index', 'form', 'table'], function () {
        var table = layui.table
            , tree = layui.tree
            , form = layui.form
            , $ = layui.jquery;
        var parentDeptId = "";
        window.loadUser = function () {
            var where = {};
            if ($("#name").val() != "") {
                where.name = $("#name").val();
            }
            if($("#enable").val()!=""){
                where.enable = $("#enable").val();
            }
            if (parentDeptId)
                where.deptId = parentDeptId;
            table.render({
                elem: '#userTable'
                , cols: [[
                    {checkbox: true, fixed: true}
                    , {field: 'name', title: '姓名'}
                    , {field: 'gender', title: '性别',templet: function(d){
                        if(d.gender){
                            var info = d.gender.split("|");
                            return info[info.length - 1];
                        }
                        else
                            return "";
                    }}
                    , {field: 'userId', title: '用户名'}
                    , {field: '操作', title: '操作', align: 'center', toolbar: '#barOption'}
                ]]
                , url: './layUIPage'
                , method: 'post'
                , page: true
                , request: {
                    limitName: "size"
                }
                , limit: 10
                , where: where
            });
        };
        loadUser();

        //监听搜索
        form.on('submit(LAY-app-search)', function (data) {
            var field = data.field;
            //执行重载
            table.reload('userTable', {
                where: field
            });
            return false;
        });

        //监听工具条
        table.on('tool(userTable)', function (obj) {
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
            url = "${ctxPath}/user/?method=edit";
            if (data) {
                url += "&id=" + data.id;
                openSubmitLayer(url, "编辑用户", '800px', '530px');
            }else {
                openSubmitLayer(url, "添加用户", '800px', '530px');
            }
        }

        function detail(data) {
            layer.open({
                type: 2,
                title: "查看用戶",
                maxmin: true,
                area: ["600px", "500px"],
                content: "${ctxPath}/user/?method=view&id=" + data.id
            });
        }

        function del(data) {
            if ('admin' == data.userId){
                layer.msg('系统管理员不能删除！')
                return;
            }
            layer.confirm('确定删除吗？', function (index) {
                $.ajax({
                    url: "./delete/" + data.id,
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.responseCode == 0) {
                            parent.layui.layer.msg("删除成功");
                            table.reload('userTable');
                        } else {
                            parent.layui.layer.msg(data.msg);
                        }
                    }
                });
                layer.close(index);
            });
        }

        function batchdel() {
            var checkStatus = table.checkStatus('userTable')
                , checkData = checkStatus.data; //得到选中的数据
            if (checkData.length === 0) {
                return layer.msg('请选择数据');
            }
            for(var i = 0;i<checkData.length;i++){
                if(checkData[i].userId == 'admin'){
                    return layer.msg('系统管理员不能删除！');
                }
            }
            layer.confirm('确定删除吗？', function (index) {
                var ids = "";
                for (var i = 0; i < checkStatus.data.length; i++) {
                    ids = ids + checkStatus.data[i].id + ","
                }
                $.ajax({
                    url: "./delete",
                    type: "post",
                    data: {"ids": ids},
                    dataType: 'json',
                    success: function (data) {
                        if (data.responseCode == 0) {
                            parent.layui.layer.msg("删除成功");
                            table.reload('userTable');
                        } else {
                            parent.layui.layer.msg(data.msg);
                        }
                    }
                });
                layer.close(index);
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
            loadUser();
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