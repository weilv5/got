<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<div class="layui-fluid" style="padding: 20px 5%;">
    <form class="layui-form layui-form-pane" id="taskDetailForm" style="font-size: 13px;">
        <div class="layui-form-item">
            <label class="layui-form-label" >流程实例编号</label>
            <div class="layui-input-block">
                <input class="layui-input" id="procInstanceId" name="procInstanceId" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">流程定义名称</label>
            <div class="layui-input-block">
                <input class="layui-input" id="procDefName" name="procDefName" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">流程定义id</label>
            <div class="layui-input-block">
                <input class="layui-input" id="procDefId" name="procDefId" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">创建时间</label>
            <div class="layui-input-block">
                <input class="layui-input" id="createTime" name="createTime" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">状态</label>
            <div class="layui-input-block">
                <input class="layui-input" id="state" name="state" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">是否挂起</label>
            <div class="layui-input-block">
                <input class="layui-input" id="isSuspend" name="isSuspend" readonly>
            </div>
        </div>

    </form>
</div>


<%@include file="../footer.jsp"%>
<script>
    layui.use(['form', 'layedit', 'laydate', 'tree'], function () {
        var form = layui.form
            , layer = layui.layer
            , layedit = layui.layedit
            , laydate = layui.laydate
            , tree = layui.tree
            , $ = layui.jquery;

        viewTaskDetail();

        function viewTaskDetail(){
            var id = "${id}";
            if (id === "")
                return;
            var dt = (new Date()).getTime();
            $.ajax({
                url:"${ctxPath}/activiti/api/procInstacne/"+id,
                dataType: "json",
                data: {
                    dt: dt
                },
                type: "get",
                success: function (value) {
                    console.log(JSON.stringify(value));
                    $("#procInstanceId").val(value.data.procInstanceId);
                   /* $("#procInstanceName").val(value.data.procInstanceName);*/
                    $("#procDefName").val(value.data.procDefName);
                    $("#procDefId").val(value.data.procDefId);
                    $("#createTime").val(value.data.createTime);
                    $("#state").val(value.data.state);
                    if(value.data.suspend)
                    $("#isSuspend").val("是");
                    else{
                        $("#isSuspend").val("否");
                    }
                }
            });
        }

    });

</script>

