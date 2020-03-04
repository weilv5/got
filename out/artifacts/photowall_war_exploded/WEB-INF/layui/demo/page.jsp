<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>


<div class="layui-row layui-col-space10">
    <div class="layui-col-xs12 layui-col-sm12 layui-col-md12">
        <fieldset class="layui-elem-field">
            <legend>demo示例</legend>
            <div class="layui-field-box">
                <form class="layui-form">
                    <div class="layui-inline"  style="margin-left: 15px; margin-bottom: 8px">
                        <a class="layui-btn btn-default btn-add" id="btn-add">简单示例</a>
                        <a class="layui-btn btn-default btn-add" id="app-add">资源申请</a>
                    </div>
                </form>
            </div>
        </fieldset>
        <!-- table -->
        <%--<div id="demoTable" lay-filter="demoTable"></div>--%>
    </div>
</div>

<script>
    // layui方法
    layui.use(['table', 'form', 'layer', 'laydate'], function () {
        var form = layui.form
                , table = layui.table
                , layer = layui.layer
                , laydate = layui.laydate
                , $ = layui.jquery;

        window.loaddemo = function () {
            var where = {};
            var tableIns = table.render({
                elem: '#demoTable'
                , height: 'full-70'
                , cols: [[
                    {checkbox: true, fixed: true}
                    ,{field:'username',title:'姓名',width:120}
                    ,{field:'applycontent',title:'事由',width:120}
                    ,{field:'userId',title:'用戶名',width:120}
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
        };

        loaddemo();

        table.on('tool(demoTable)', function (obj) {
            var data = obj.data
                , layEvent = obj.event;
            if (layEvent == "detail") {
                openLayer("${ctxPath}/demo/?method=view&id=" + data.id, "查看demo", "700px", "500px");
            } else if (layEvent == "edit") {
                openLayer("${ctxPath}/demo/?method=edit&id=" + data.id, "编辑demo", "700px", "500px");
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
                                loaddemo();
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
            var checkStatus = table.checkStatus('demoTable');
            if (checkStatus.data.length == 0) {
                parent.layui.layer.msg("请选择需要删除的数据");
            } else {
                layer.confirm("确定要删除选择的数据？", {icon: 3, title: '提示'}, function (index) {
                    var ids = "";
                    for (var i = 0; i < checkStatus.data.length; i++) {
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
                                loaddemo();
                            } else {
                                parent.layui.layer.msg(data.msg);
                            }
                        }
                    });
                    layer.close(index);
                })
            }
        });
        //简单示例-添加申请单
        $("#btn-add").on('click', function () {
            openLayer("${ctxPath}/demo/?method=edit", "简单示例-新增", "800px", "600px");
        });

        //资源申请-添加申请单
        $("#app-add").on('click', function () {
            openLayer("${ctxPath}/appres/edit", "资源申请-新增", "800px", "600px");
        });

        //查询
        $("#searchBtn").on('click', function () {
            loaddemo();
        });

    });



</script>
<script type="text/html" id="barOption">
    <a class="layui-btn layui-btn-mini" lay-event="detail">查看</a>
    <a class="layui-btn layui-btn-mini layui-btn-normal" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-mini layui-btn-danger" lay-event="del">删除</a>
</script>
<%@include file="../footer.jsp" %>