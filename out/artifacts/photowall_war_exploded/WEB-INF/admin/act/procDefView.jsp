<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header_form.jsp"%>
<form class="layui-form layui-form-pane"  id="departmentForm" style="padding: 20px 30px 0 30px;font-size: 13px;">
    <div class="layui-form-item">
        <label class="layui-form-label">流程编号</label>
        <div class="layui-input-block">
            <input type="text" class="layui-input" id="id" name="id" readonly/>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">部署编号</label>
        <div class="layui-input-block">
            <input type="text" class="layui-input" id="deploymentId" name="deploymentId" readonly/>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">模型名称</label>
        <div class="layui-input-block">
            <input type="text" class="layui-input" id="name" name="name" readonly/>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">模型key</label>
        <div class="layui-input-block">
            <input type="text" class="layui-input" name="key" id="key" readonly/>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">版本号</label>
        <div class="layui-input-block">
            <input type="text" id="version" name="version" class="layui-input" readonly/>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">挂起状态</label>
        <div class="layui-input-block">
            <input type="text" id="suspended" name="suspended" class="layui-input" readonly/>
        </div>
    </div>
</form>
<script>
    layui.use(['form','layedit','laydate','tree'],function() {
        var form = layui.form
            , $ = layui.jquery;
        var id = "${id}";
        console.info(id);
        if(id === "")
            return;
        var dt = (new Date()).getTime();
        $.ajax({
            url:"${ctxPath}/activiti/api/procDef/"+id,
            dataType:"json",
            type:"get",
            data:{
                dt:dt
            },
            success:function(value){
                $("#id").val(value.data.id);
                $("#name").val(value.data.name);
                $("#key").val(value.data.key);
                $("#version").val(value.data.version);
                $("#deploymentId").val(value.data.deploymentId);

                if (value.data.suspended) {
                    $("#suspended").val("是");
                } else {
                    $("#suspended").val("否");
                }
            },
            error:function(){
                //获取用户失败
            }
        });

    });


</script>
<%@include file="../footer.jsp"%>