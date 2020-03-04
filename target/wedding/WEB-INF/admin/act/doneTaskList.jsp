<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<div class="layui-fluid">
    <div class="layui-card">
        <form class="layui-form layui-card-header layuiadmin-card-header-auto">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">流程定义key</label>
                    <div class="layui-input-inline">
                        <input type="text" name="processDefKey" id="processDefKey" autocomplete="off" placeholder="请输入流程定义key" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label">时间范围</label>
                    <div class="layui-input-inline">
                        <input type="text" id="createTimeBefore" name="createTimeBefore" autocomplete="off"
                               class="layui-input" placeholder="选择开始时间">
                    </div>
                    <div class="layui-input-inline" style="width: 5px;">
                        -
                    </div>
                    <div class="layui-input-inline">
                        <input type="text" id="createTimeAfter" name="createTimeAfter" autocomplete="off"
                               class="layui-input" placeholder="选择结束时间">
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
            <table id="doneTaskTable" lay-filter="doneTaskTable"></table>
        </div>
    </div>
</div>
<script>

    layui.config({
        base: '${ctxPath}/resources/layuiadmin/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['index', 'form', 'table','laydate'], function () {
        var table = layui.table
            ,laydate=layui.laydate
            , form = layui.form;
        laydate.render({
            elem: '#createTimeBefore',
            type: 'datetime'
        });
        laydate.render({
            elem: '#createTimeAfter',
            type: 'datetime'
        });

        table.render({
            elem: '#doneTaskTable'
            , cols: [[
                {checkbox: true, fixed: true},
                {field: 'id', title: '任务编号', align:'center',width:100,sort:true},
                {field: 'taskName', title: '任务名称', align:'center',width:120,sort:true},
                {field: 'procDefName', title: '流程定义名称', align:'center',width:180,sort:true},
                {field:'businessKey',title:'流程定义key',align:'center',width:120,sort:true},
                {field:'startTime',title:'开始时间',align:'center',width:180,sort:true},
                {field:'endTime',title:'结束时间',align:'center',width:180,sort:true},
                {field:'deleteReason',title:'完结类别',align:'center',width:120,sort:true}
               /* {fixed: 'right', title: '操作', width: 100, align: 'center', toolbar: '#barOption'}*/
            ]]
            , url: '${ctxPath}/activiti/api/task/hiTask'
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
            table.reload('doneTaskTable', {
                where: field
            });
            return false;
        });

        //监听工具条
        table.on('tool(doneTaskTable)', function (obj) {
            var data = obj.data
                , layEvent = obj.event;
            if(layEvent == "LookupTask"){
                LookupTask(data.id);

            }
        });

        function LookupTask(taskId){
            alert(JSON.stringify(data));
            layer.open({
                type: 2,
                title: "已办详情",
                maxmin: true,
                area: ["600px", "500px"],
                content: "${ctxPath}/activiti/?method=view&id=" + taskId
            });
        }
    });

</script>

<script type="text/html" id="barOption">
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="LookupTask"><i
            class="layui-icon layui-icon-about"></i>查看</a>
</script>
<%@include file="../footer.jsp" %>