<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ include file="../header.jsp" %>
    <div id="taskTable" lay-filter="taskTable"></div>
<script>
    layui.use(['table', 'layer'], function () {
        var table = layui.table
            , layer = layui.layer
            , $ = layui.jquery;

        window.loadTaskList = function () {

            table.render({
                elem: '#taskTable'
                , height: 'full-70'
                , cols: [[
                    {checkbox: true, fixed: true},
                    {field: 'id', title: '任务编号', width: 100},
                    {field: 'name', title: '任务名称', width: 150},
                    {field: 'pdname', title: '流程名称', width: 150},
                    {field: 'pdversion', title: '版本', width: 100},
                    {
                        field: 'createTime', title: '创建时间', template: function (d) {
                        if (d.createTime == null) return;
                        var date = new Date(d.createTime.time);
                        var retStr = date.format("yyyy--MM-dd hh:mm:ss");
                        return retStr;

                    }
                    }, {fixed: 'right', title: '操作', width: 400, align: 'center', toolbar: '#barOption'}
                ]]
                , url: './task/todo/list'
                , method: 'get'
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
            });
        }
        loadTaskList();
        table.on('tool(taskTable)', function (obj) {
            var data = obj.data
                , layEvent = obj.event;
            if(layEvent == "edit"){
            if (data.pdname == "简单示例流程") {
                openLayer("${ctxPath}/demo/handleTask?taskId=" + data.id, "简单示例流程-任务办理", "800px", "510px");
            }else if(data.pdname == "资源申请流程"&&data.name=="部门经理审批"){
                openLayer("${ctxPath}/appres/handleTask?taskId=" + data.id,"资源申请流程-任务办理","800px","510px")
            }
            }

    });
    });

    //办理
    function getTask(taskId) {
        window.currTaskId = taskId;
        $.ajax({
            url:"${ctx}/activiti",
            data:{
                taskId:taskId
            },
            dataType:"json",
            type:"post",
            success:function (data) {
                if(data.responCode == 0){

                }
            }
        });

    }
</script>
<script type="text/html" id="barOption">
    <a class="layui-btn layui-btn-mini layui-btn-normal" lay-event="edit">办理</a>
</script>
<%@ include file="../footer.jsp" %>