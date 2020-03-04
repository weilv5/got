<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<div class="layui-fluid">
    <div class="layui-card">
        <div class="layui-card-body">
            <table id="taskTable" lay-filter="taskTable"></table>
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
            elem: '#taskTable'
            , cols: [[
                {checkbox: true, fixed: true},
                {field: 'id', title: '任务编号', align:'center',sort:true},
                {field: 'taskName', title: '任务名称', width:150,align:'center',sort:true},
                {field: 'procDefName', title: '流程定义名称',width:150, align:'center',sort:true},
                {field: 'procDefVersion', title: '流程定义版本', width:150,align:'center',sort:true},
                {field: 'createTime', title: '创建时间', width:180,align:'center',sort:true},
                {fixed: 'right', title: '操作', align: 'center', toolbar: '#barOption'}
            ]]
            , url: '${ctxPath}/activiti/api/task/ruTask'
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

        //监听工具条
        table.on('tool(taskTable)', function (obj) {
            var data = obj.data
                , layEvent = obj.event;
            if(layEvent == "edit"){
                if (data.procDefName == "简单示例流程") {
                    layer.open({
                        type: 2,
                        title: "简单示例流程-任务办理",
                        maxmin: true,
                        area: ["600px", "450px"],
                        content: "${ctxPath}/demo/handleTask?taskId=" + data.id
                    });
                }else if(data.procDefName == "资源申请流程"&&data.taskName=="部门经理审批"){
                    layer.open({
                        type: 2,
                        title: "资源申请流程-任务办理",
                        maxmin: true,
                        area: ["600px", "450px"],
                        content: "${ctxPath}/appres/handleTask?taskId=" + data.id
                    });
                }
            }else if(layEvent == "diagram"){
                layer.open({
                    type: 2,
                    title: "流程图(任务编号："+data.id+")",
                    maxmin: true,
                    area: ["900px", "500px"],
                    content: "${ctxPath}/activiti/api/task/pic?taskId="+data.id
                });
            }
        });
    })

</script>

<script type="text/html" id="barOption">
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>办理</a>
   <%-- <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="diagram"><i class="layui-icon layui-icon-chart"></i>流程图</a>--%>
</script>
<%@include file="../footer.jsp" %>