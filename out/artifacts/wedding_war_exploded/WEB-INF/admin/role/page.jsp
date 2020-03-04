<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<link rel="stylesheet" href="${ctxPath}/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${ctxPath}/resources/js/jquery.js"></script>
<link rel="stylesheet" href="${ctxPath}/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.core.js"></script>
<div class="layui-fluid">
    <div class="layui-row layui-col-space10">
        <div class="layui-col-md2">
            <div class="layui-card">
                <ul id="tree" class="ztree" lay-filter="tree"></ul>
            </div>
        </div>
        <div class="layui-col-md10" id="roleCard">
            <div class="layui-card">
                <form class="layui-form layui-card-header layuiadmin-card-header-auto">
                    <div class="layui-form-item">
                        <div class="layui-inline">
                            <label class="layui-form-label">角色名称</label>
                            <div class="layui-input-inline">
                                <input type="text" name="roleName" id="roleName" autocomplete="off"
                                       placeholder="请输入角色名称" class="layui-input">
                                <input type="hidden" id="parentRoleId" name="parentRoleId">
                            </div>
                        </div>
                        <div class="layui-inline">
                            <button class="layui-btn layuiadmin-btn-list" lay-submit lay-filter="LAY-app-search"
                                    id="LAY-app-search">
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
                    <table id="roleTable" lay-filter="roleTable"></table>
                </div>
            </div>
        </div>
        <div id="configCard" style="display: none">
            <div class="layui-card">
                <div class="layui-card-header"></div>
                <span class="layui-layer-setwin"><a class="layui-layer-ico layui-layer-close layui-layer-close1" onclick="hideConfig();" href="javascript:;"></a></span>
                <div class="layui-card-body">
                    <iframe style="width: 100%;height: 100%;border: none"></iframe>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    var table ;
    layui.config({
        base: '${ctxPath}/resources/layuiadmin/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['tree', 'index', 'form', 'table'], function () {
       table = layui.table
            , form = layui.form
            , $ = layui.jquery;
        table.render({
            elem: '#roleTable'
            , cols: [[
                {checkbox: true, fixed: true}
                , {field: 'roleName', title: '角色名称'}
                , {field: 'backup', title: '备注'}
                , {fixed: 'right', title: '操作', align: 'center', toolbar: '#barOption'}
            ]]
            , url: './layUIPage'
            , method: 'post'
            , page: true
            , request: {
                limitName: "size"
            }
            ,id: 'roleTable'
            , limits: [30, 60, 90, 150, 300]
            , limit: 30
        });

        //监听搜索
        form.on('submit(LAY-app-search)', function (data) {
            var field = data.field;
            //执行重载
            table.reload('roleTable', {
                where: field
            });
            return false;
        });

        //监听工具条
        table.on('tool(roleTable)', function (obj) {
                var data = obj.data
                    , layEvent = obj.event;
                if (layEvent == "detail") {
                    detail(data);
                } else if (layEvent == "edit") {
                    add(data);
                } else if (layEvent == "del") {
                    del(data);
                } else if (layEvent == "setModule") {
                    setModule(data);
                } else if (layEvent == "setUser") {
                    setUser(data);
                } else if (layEvent == "setDept") {
                    setDept(data);
                }
            }
        );


        var active = {
            batchdel: batchdel,
            add: add
        };

        $('.layui-btn.layuiadmin-btn-list').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });

        $('body').on('mouseenter', '.btips', function () {
            tip_index =layer.tips($(this).attr('data-content'), $(this), {
                tips: [3, '#999'],
                time: 3000,
                skin: 'table-tips'
            });
        }).on('mouseleave', '.btips', function () {
            layer.close(tip_index);
        });

        function setModule(data) {
            showConfig();
            $("#configCard .layui-card-header").html("配置模块");
            $("#configCard iframe").attr("src",'${ctxPath}/role/selectModuleForRole?id=' + data.id);
        }
        function setUser(data) {
            showConfig();
            $("#configCard .layui-card-header").html("配置用户");
            $("#configCard iframe").attr("src",'${ctxPath}/role/selectUserForRole?id=' + data.id);
        }

        function setDept(data) {
            showConfig();
            $("#configCard .layui-card-header").html("配置部门");
            $("#configCard iframe").attr("src",'${ctxPath}/role/selectDeptForRole?id=' + data.id);
        }


        function add(data) {
            url = "${ctxPath}/role/?method=edit";
            if (data) {
                url += "&id=" + data.id;
                openSubmitLayer(url, "编辑角色", '600px', '550px');
            } else {
                openSubmitLayer(url, "添加角色", '600px', '550px');
            }
        }

        function detail(data) {
            var settings = {
                btn: ['查看用户', '查看部门', '关闭'],
                btn1: function (index, layero) {
                    var btn = layero.find('iframe').contents().find("#viewUser");
                    btn.click();
                    return false;
                }, btn2: function (index, layero) {
                    var btn2 = layero.find('iframe').contents().find("#viewDept");
                    btn2.click();
                    return false;
                }
            }
            openExtendLayer("${ctxPath}/role/?method=view&id=" + data.id, "查看角色", '600px', '500px', settings);
        }

        function del(data) {
            layer.confirm('确定删除吗？', function (index) {
                $.ajax({
                    url: "./delete/" + data.id,
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.responseCode == 0) {
                            parent.layui.layer.msg("删除成功");
                            table.reload('roleTable');
                            var node = zTreeObj.getNodesByParam("id", data.id);
                            zTreeObj.removeNode(node[0]);

                        } else {
                            parent.layui.layer.msg(data.msg);
                        }
                    }
                });
                layer.close(index);
            });
        }

        function batchdel() {
            var checkStatus = table.checkStatus('roleTable')
                , checkData = checkStatus.data; //得到选中的数据
            if (checkData.length === 0) {
                return layer.msg('请选择数据');
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
                            for (var i = 0; i < checkStatus.data.length; i++) {
                                var node = zTreeObj.getNodesByParam("id", checkStatus.data[i].id);
                                zTreeObj.removeNode(node[0]);
                            }
                            table.reload('roleTable');
                        } else {
                            parent.layui.layer.msg(data.msg);
                        }
                    }
                })
                layer.close(index);
            });
        }

        //树形菜单
        var zTreeObj;

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
                    name: "roleName"
                },
                simpleData: {
                    enable: true,
                    idKey: "id", // id编号命名
                    pIdKey: "parentRoleId", // 父id编号命名
                }
            },
        };

        function ztreeOnClick(event, treeId, treeNode) {
            var parentRoleId = treeNode.id;
            $("#parentRoleId").val(parentRoleId);
            $("#LAY-app-search").click();
        }

        // zTree 树形菜单
        window.reloadTree = function () {
            var zNodes = {
                roleName: "角色树",
                id: "",
                isParent: true,
                open: true,
            };
            $.ajax({
                type: "post",
                url: "./list",
                dataType: "json",
                async: true,
                success: function (res) {
                    var arr = [];
                    if (res != null && res.length > 0) {
                        var length = res.length;
                        for (var i = 0; i < length; i++) {
                            if (!res[i].parentRoleId)
                                parentRoleId = "";
                            else
                                parentRoleId = res[i].parentRoleId;
                            arr.push({
                                roleName: res[i].roleName,
                                id: res[i].id,
                                parentRoleId: parentRoleId
                            })
                        }
                    }
                    arr.push(zNodes)
                    $.fn.zTree.init($("#tree"), setting, arr);
                }
            });
        }
        $(document).ready(function () {
            // zTree 的数据属性，深入使用请参考 API 文档（zTreeNode 节点数据详解）
            $("#tree").height($(document).height() - 40);
            $("#configCard iframe").height($(document).height() - 80);
            $("")
            reloadTree();
        });
    });

    function showConfig(){
        $("#configCard").addClass("layui-col-md4");
        $("#roleCard").removeClass("layui-col-md10").addClass("layui-col-md6");
        $("#configCard").show();
        table.reload('roleTable');
    }
    function hideConfig(){
        $("#configCard").removeClass("layui-col-md4");
        $("#roleCard").addClass("layui-col-md10").removeClass("layui-col-md6");
        $("#configCard").hide();
        table.reload('roleTable');
    }

</script>

<script type="text/html" id="barOption">
    <a class="layui-btn layui-btn-normal layui-btn-xs btips" lay-event="setModule" data-content="配置模块"><i
            class="layui-icon layui-icon-app"></i></a>
    <a class="layui-btn layui-btn-normal layui-btn-xs btips" lay-event="setUser" data-content="配置用户"><i
            class="layui-icon layui-icon-user"></i></a>
    <%--<a class="layui-btn layui-btn-normal layui-btn-xs btips" lay-event="setDept" data-content="配置部门"><i--%>
            <%--class="layui-icon layui-icon-tree"></i></a>--%>
    <a class="layui-btn layui-btn-normal layui-btn-xs btips" lay-event="edit" data-content="编辑"><i
            class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs btips" lay-event="del" data-content="删除"><i
            class="layui-icon layui-icon-delete"></i>删除</a>

</script>
<%@include file="../footer.jsp" %>