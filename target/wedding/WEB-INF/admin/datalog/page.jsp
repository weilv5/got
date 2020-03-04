<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<div class="layui-fluid">
    <div class="layui-card">
        <form class="layui-form layui-card-header layuiadmin-card-header-auto">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">操作者</label>
                    <div class="layui-input-inline">
                        <input type="text" id="operatorId" name="operatorId" autocomplete="off"
                               placeholder="请输入操作者ID" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">操作类名</label>
                    <div class="layui-input-inline">
                        <input type="text" id="className" name="className" autocomplete="off"
                               placeholder="请输入操作类名" class="layui-input">
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
            ,layer = layui.layer
            ,$ = layui.jquery
            , form = layui.form;

        table.render({
            elem: '#moduleTable'
            , cols: [[
                {checkbox: true, fixed: true}
                ,{field: 'createdDate', title: '操作日期', width: 170}
                ,{field: 'operatorId', title: '操作者ID', width: 150}
                ,{field: 'operatorIp', title: '操作者IP', width: 120}
                ,{field: 'entityName', title: '操作实体名', width: 150}
                ,{field: 'className', title: '操作类名', width: 220}
                ,{field: 'entityChangeType', toolbar: '#opertype', title: '操作类型', width: 130}
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
            }
        });

        function detail(data) {
            layer.open({
                type: 2,
                title: "查看操作日志",
                maxmin: true,
                area: ["700px", "550px"],
                content: "${ctxPath}/datalog/?method=view&id=" + data.id
            });
        }
    });

</script>

<script type="text/html" id="barOption">
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="detail"><i
            class="layui-icon layui-icon-about"></i>查看</a>
</script>
<%@include file="../footer.jsp" %>