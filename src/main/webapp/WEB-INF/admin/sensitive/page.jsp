<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<div class="layui-fluid">
    <div class="layui-card">
        <form class="layui-form layui-card-header layuiadmin-card-header-auto">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">敏感词</label>
                    <div class="layui-input-inline">
                        <input type="text" name="words" autocomplete="off" placeholder="请输入敏感词" class="layui-input">
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
                <button class="layui-btn layuiadmin-btn-list" lay-event="batchdel" data-type="batchdel">删除</button>
                <button class="layui-btn layuiadmin-btn-list" lay-event="add" data-type="add">添加</button>
                <button class="layui-btn layuiadmin-btn-list" lay-event="sync" data-type="add">同步</button>
                <button class="layui-btn layuiadmin-btn-list" lay-event="import" data-type="add">导入</button>
            </div>
            <table id="moduleTable" lay-filter="moduleTable"></table>
        </div>
        <script>

            layui.config({
                base: '${ctxPath}/resources/layuiadmin/' //静态资源所在路径
            }).extend({
                index: 'lib/index' //主入口模块
            }).use(['index', 'form', 'table'], function () {
                var table = layui.table
                    , form = layui.form;

                table.render({
                    elem: '#moduleTable'
                    , cols: [[
                        {checkbox: true, fixed: true}
                        , {field: 'words', title: '敏感词', align: 'center'}
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
                    }else if (layEvent == "import") {
                        importWords(data);
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
                    url = "${ctxPath}/sensitive/?method=edit";
                    if (data) {
                        url += "&id=" + data.id;
                    }

                    layer.open({
                        type: 2,
                        title: null == data ? "添加敏感词" : "编辑敏感词",
                        maxmin: true,
                        area: ["600px", "200px"],
                        content: url,
                        btn: ['确定', '取消']
                        , yes: function (index, layero) {
                            //点击确认触发 iframe 内容中的按钮提交
                            var submit = layero.find('iframe').contents().find("#layuiadmin-app-form-submit");
                            submit.click();
                        }
                    });
                }

                function detail(data) {
                    layer.open({
                        type: 2,
                        title: "查看敏感词",
                        maxmin: true,
                        area: ["600px", "200px"],
                        content: "${ctxPath}/module/?method=view&id=" + data.id,
                        btn: ['关闭']
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
                                    table.reload('moduleTable');
                                } else {
                                    parent.layui.layer.msg(data.msg);
                                }
                            }
                        })
                        layer.close(index);
                    });
                }

                function batchdel() {
                    var checkStatus = table.checkStatus('moduleTable')
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
                                    table.reload('moduleTable');
                                } else {
                                    parent.layui.layer.msg(data.msg);
                                }
                            }
                        })
                        layer.close(index);
                    });
                }
                function importWords() {
                    var loadindex = parent.layui.layer.load(3, {time: 100 * 1000});
                    $("#importForm").ajaxSubmit({
                        type: "post",
                        url: "./import",
                        success: function (data) {
                            parent.layui.layer.msg(data.msg);
                            parent.layui.layer.close(loadindex);
                        }
                    })
                }
            })

        </script>

        <script type="text/html" id="barOption">
            <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="edit"><i
                    class="layui-icon layui-icon-edit"></i>编辑</a>
            <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del"><i
                    class="layui-icon layui-icon-delete"></i>删除</a>
        </script>
<%@include file="../footer.jsp" %>