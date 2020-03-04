<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<div class="layui-fluid">
    <div class="layui-card">
        <form class="layui-form layui-card-header layuiadmin-card-header-auto">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">流程定义key</label>
                    <div class="layui-input-inline">
                        <input type="text" id="processDefKey" name="processDefKey" autocomplete="off"
                               placeholder="请输入流程编号" class="layui-input">
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
            <table id="processTable" lay-filter="processTable"></table>
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
            , form = layui.form
            , laydate = layui.laydate
            , $ = layui.jquery;
        laydate.render({
            elem: '#createTimeBefore',
            type: 'datetime'
        });
        laydate.render({
            elem: '#createTimeAfter',
            type: 'datetime'
        });

        window.procTable = table.render({
            elem: '#processTable'
            , cols: [[
                {checkbox: true, fixed: true},
                {field: 'procInstanceId', title: '流程实例编号', width: 150,align:'center',sort:true},
                {field: 'procDefId', title: '流程定义编号', width: 180,align:'center',sort:true},
                {field: 'procDefName', title: '流程定义名称', width: 120,align:'center',sort:true},
                {field: 'createTime', title: '创建时间', width: 180,align:'center',sort:true},
                {field: 'state', title: '状态', width: 100,align:'center',sort:true},
                {
                    fixed: 'right', title: '操作', align: 'center', templet: function (d) {
                    var showhistory = "<a href='#' class='layui-btn layui-btn-normal layui-btn-xs' onclick=\"viewProc('" + d.id + "')\"><i\n" +
                        "            class=\"layui-icon layui-icon-about\"></i>详情</a>"+
                        "<a href='#' class='layui-btn layui-btn-normal layui-btn-xs' onclick=\"viewDiagram('" + d.id + "')\"><i class=\"layui-icon layui-icon-chart\"></i>流程图</a>";

                    if(d.state == "已结束"){
                        return showhistory + "<a href='#' class='layui-btn layui-btn-danger layui-btn-xs' onclick=\"delProcessInstance('" + d.id + "')\"><i\n" +
                            "            class=\"layui-icon layui-icon-delete\"></i>删除</a>";
                    }
                    if (d.suspend) {
                        return showhistory+" <a class='layui-btn layui-btn-danger layui-btn-xs' onclick=\"activateProcessInstance('" + d.id + "')\"><i\n" +
                            "                    class=\"layui-icon layui-icon-pause\"></i>激活</a>";
                    } else {
                        return showhistory+" <a class='layui-btn layui-btn-normal layui-btn-xs' onclick=\"suspendProcessInstance('" + d.id + "')\"><i\n" +
                            "                    class=\"layui-icon layui-icon-play\"></i>挂起</a>";
                    }
                    return showhistory;
                }
                }
            ]]
            , url: '${ctxPath}/activiti/api/procInstacne/hisProcInstanceList'
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
            table.reload('processTable', {
                where: field
            });
            return false;
        });


    });

    function viewProc(id) {
        layer.open({
            type: 2,
            title: "流程实例详情(编号："+id+")",
            maxmin: true,
            area: ["600px", "450px"],
            content: "${ctxPath}/activiti/api/procInstacne/toProcInstacneView/"+id
        });
    }

    function viewDiagram(procInstanceId) {
        layer.open({
            type: 2,
            title: "流程图(流程实例编号："+procInstanceId+")",
            maxmin: true,
            area: ["900px", "500px"],
            content: "${ctxPath}/activiti/api/procInstacne/diagram?procInstanceId="+procInstanceId
        });
    }
    function activateProcessInstance(procInstanceId) {
        parent.layui.layer.confirm("确定要激活该流程实例？", {icon: 3, title: '激活流程实例'}, function (index) {
            parent.layui.layer.close(index);
            parent.layui.layer.load(3, {time: 1000});
            var state = "activate";
            $.ajax({
                url:"${ctxPath}/activiti/api/procInstacne/" + procInstanceId,
                type: 'post',
                dataType: 'json',
                data:{
                    _method:"PUT",
                    action: state
                },
                async: false,
                success: function (data) {
                    if (data.code == 0) {
                        parent.layui.layer.msg("流程实例激活成功！");
                        procTable.reload('processTable');
                    } else {
                        parent.layui.layer.msg("流程实例激活出错" + data.msg);
                    }
                },
                error: function (data) {
                    parent.layui.layer.msg("error:" + data.msg);
                    procTable.reload('processTable');
                }
            });
        });

    }
    function suspendProcessInstance(procInstanceId){
        parent.layui.layer.confirm("确定要挂起该流程实例？", {icon: 3, title: '挂起流程实例'}, function (index) {
            parent.layui.layer.close(index);
            parent.layui.layer.load(3, {time: 1000});
            var state = "suspend";
            $.ajax({
                url:"${ctxPath}/activiti/api/procInstacne/" + procInstanceId,
                type: 'post',
                dataType: 'json',
                async: false,
                data:{
                    _method:"PUT",
                    action: state
                },
                success: function (data) {
                    if (data.code == 0) {
                        parent.layui.layer.msg("流程实例挂起成功！");
                        procTable.reload('processTable');
                    } else {
                        parent.layui.layer.msg("流程实例挂起出错" + data.msg);
                    }
                },
                error: function (data) {
                    parent.layui.layer.msg("error:" + data.msg);
                    procTable.reload('processTable');
                }

            });
        });

    }
    function delProcessInstance(procInstanceId) {
        parent.layui.layer.confirm("确定删除选中的流程实例？", {icon: 3, title: "提示"}, function (index) {
            parent.layui.layer.close(index);
            parent.layui.layer.load(3, {time: 1000});
            $.ajax({
                url: "${ctxPath}/activiti/api/procInstacne/delete?procInstanceId=" + procInstanceId,
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.code == 0) {
                        parent.layui.layer.msg("刪除流程实例成功");
                        procTable.reload('processTable');
                    }
                    else {
                        parent.layui.layer.msg("删除流程实例出错" + data.msg);
                    }
                },
                error: function (data) {
                    parent.layui.layer.msg("error:" + data.msg);
                    procTable.reload('processTable');
                }

            });
        });
    }

</script>
<script type="text/javascript" src="${ctxPath}/resources/js/jquery.js"></script>
<%@include file="../footer.jsp" %>