<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<div class="layui-fluid">
    <div class="layui-card">
        <form class="layui-form layui-card-header layuiadmin-card-header-auto">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">功能点名称</label>
                    <div class="layui-input-inline">
                        <input id="pointName"
                               name="pointName"
                               type="text"
                               class="layui-input">
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
            <table id="udp_point_permissionTable" lay-filter="udp_point_permissionTable"></table>
        </div>
    </div>
</div>

<script>

    layui.config({
        base: '${ctxPath}/resources/layuiadmin/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['index', 'form', 'table'], function () {
        var table = layui.table
            , layer = layui.layer
            , laydate = layui.laydate
            , $ = layui.jquery
            , form = layui.form;


        table.render({
            elem: '#udp_point_permissionTable'
            , cols: [[
                {checkbox: true, fixed: true}
                , {
                    field: 'pointName',
                    title: '功能点名称',
                    width: 350
                }
                , {
                    field: 'pointExpression',
                    title: '功能点表达式',
                    width: 350
                }
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
            table.reload('udp_point_permissionTable', {
                where: field
            });
            return false;
        });

        //监听工具条
        table.on('tool(udp_point_permissionTable)', function (obj) {
            var data = obj.data
                , layEvent = obj.event;
            // if (layEvent == "detail") {
            //     detail(data);
            // } else
                if (layEvent == "edit") {
                add(data);
            } else if (layEvent == "del") {
                del(data);
            }else if (layEvent == "config") {
                config(data);
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

        function config(data){
            layer.open({
                type: 2,
                title: '配置功能点',
                area: ['400px', '500px'],
                content: '${ctxPath}/pointpermission/roleConfig?id='+ data.id,
                cancel: function (index, layero) {
                    layer.close(index);
                    return false;
                }
            });
        }

        function add(data) {
            url = "${ctxPath}/pointpermission/?method=edit";
            if (data) {
                url += "&id=" + data.id;
                openSubmitLayer(url, "编辑功能点权限", '700px', '400px');
            } else {
                openSubmitLayer(url, "添加功能点权限", '700px', '400px');
            }
        }

        function detail(data) {
            layer.open({
                type: 2,
                title: "查看功能点权限",
                maxmin: true,
                area: ["700px", "400px"],
                content: "${ctxPath}/pointpermission/?method=view&id=" + data.id
            });
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
                            table.reload('udp_point_permissionTable');
                        } else {
                            parent.layui.layer.msg(data.msg);
                        }
                    }
                })
                layer.close(index);
            });
        }

        function batchdel() {
            var checkStatus = table.checkStatus('udp_point_permissionTable')
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
                            table.reload('udp_point_permissionTable');
                        } else {
                            parent.layui.layer.msg(data.msg);
                        }
                    }
                })
                layer.close(index);
            });
        }

    });

</script>

<script type="text/html" id="barOption">
    <%--<a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="detail"><i--%>
            <%--class="layui-icon layui-icon-about"></i>查看</a>--%>
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="edit"><i
            class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="config"><i
            class="layui-icon layui-icon-util"></i>配置</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del"><i
            class="layui-icon layui-icon-delete"></i>删除</a>
</script>
<%@include file="../footer.jsp" %>