<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<div class="layui-fluid">
    <div class="layui-card">
        <form class="layui-form layui-card-header layuiadmin-card-header-auto">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">模型名称</label>
                    <div class="layui-input-inline">
                        <input type="text" id="name" name="name" autocomplete="off"
                               placeholder="请输入模型名称" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">key</label>
                    <div class="layui-input-inline">
                        <input type="text" id="key" name="key" autocomplete="off"
                               placeholder="请输入标识" class="layui-input">
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
                        class="layui-icon layui-icon-add-1"></i>添加</button>
            </div>
            <table id="moduleTable" lay-filter="moduleTable"></table>
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
            , form = layui.form;

        table.render({
            elem: '#moduleTable'
            , cols: [[
                {checkbox: true, fixed: true},
                {field: 'id', title: '模型编号', width: 100,align:'center',sort:true},
                {field: 'name', title: '模型名称', width: 150,align:'center',sort:true},
                {field: 'key', title: '模型KEY', width: 120,align:'center',sort:true},
                {field: 'createTime', title: '创建时间', width: 200,align:'center',sort:true},
                {fixed: 'right', title: '操作', align: 'center', toolbar: '#barOption'}
            ]]
            , url: '${ctxPath}/activiti/api/model'
            , method: 'get'
            , page: true
            , request: {
                limitName: "size"
            }
            , response: {
                countName: "total",
                dataName: "dataList"
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
            if (layEvent == "deploy") {
                parent.layui.layer.confirm("确定部署模型？",{icon:3,title:'提示'},function (index) {
                    parent.layui.layer.close(index);
                    parent.layui.layer.load(3,{time:1000});
                    $.ajax({
                        url:"${ctxPath}/activiti/api/deployment/"+data.id,
                        type:"put",
                        dataType:'json',
                        async:false,
                        success: function (data) {
                            if (data.code == 0) {
                                parent.layui.layer.msg("模型部署成功");
                                table.reload('moduleTable');
                            } else {
                                parent.layui.layer.msg(data.msg);
                            }

                        },
                        error: function(data){
                            parent.layui.layer.msg(data.msg);
                        }
                    });
                });
            } else if (layEvent == "edit") {
                window.open("${ctxPath}/modeler.html?modelId=" + data.id);
            } else if (layEvent == "del") {
                del(data);
            } else if (layEvent == "exportModelXml"){
                exportModelXml(data.id);
            }
        });

        var $ = layui.$, active = {
            add: add
        };

        $('.layui-btn.layuiadmin-btn-list').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });

        function add() {
            layer.open({
                type: 2,
                title: "新建模型",
                maxmin: true,
                area: ["700px", "250px"],
                content: "${ctxPath}/activiti/api/model/edit",
                btn: ['确定', '取消']
                , yes: function (index, layero) {
                    //点击确认触发 iframe 内容中的按钮提交
                    var submit = layero.find('iframe').contents().find("#layuiadmin-app-form-submit");
                    submit.click();
                }
            });
        }


        function del(data) {
            layer.confirm('确定删除吗？', function (index) {
                $.ajax({
                    url: "${ctxPath}/activiti/api/model/" + data.id,
                    type: "delete",
                    dataType: "json",
                    success: function (data) {
                        if (data.code == 0) {
                            parent.layui.layer.msg("删除成功");
                            table.reload('moduleTable');
                        } else {
                            parent.layui.layer.msg(data.msg);
                        }
                    }
                });
                layer.close(index);
            });
        }

        function exportModelXml(id) {
            window.open("${ctxPath}/activiti/api/model/bpmn/"+id);
        }

    });

</script>

<script type="text/html" id="barOption">
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="edit"><i
            class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="exportModelXml"><i
            class="layui-icon layui-icon-download-circle"></i>导出XML</a>
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="deploy"><i
            class="layui-icon layui-icon-upload-drag"></i>部署</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del"><i
            class="layui-icon layui-icon-delete"></i>删除</a>
</script>
<%@include file="../footer.jsp" %>