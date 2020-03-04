<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header_form.jsp" %>
<form class="layui-form layui-form-pane" id="modelForm" lay-filter="modelForm" action="" style="padding: 20px 30px 0 30px;">
    <input id="id" name="id" type="hidden">
    <input id="content" name="content" type="hidden">
    <input id="CSRFToken" name="CSRFToken" type="hidden" value="${CSRFToken}">
    <div class="layui-form-item">
        <label class="layui-form-label">模型名称<label style="color:red;">*</label></label>
        <div class="layui-input-block">
            <input class="layui-input" type="text" name="name" id="name" placeholder="请输入模型名称"/>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">模型key<label style="color:red;">*</label></label>
        <div class="layui-input-block">
            <input class="layui-input" type="text" name="key" id="key"  placeholder="请输入模型key"/>
        </div>
    </div>
    <%--<div class="layui-form-item">
        <label class="layui-form-label">模型描述</label>
        <div class="layui-input-block">
            <input class="layui-input" type="text" name="metaInfo" id="metaInfo" placeholder="请输入模型描述"/>
        </div>
    </div>--%>
    <div class="layui-form-item layui-hide">
        <input type="button" lay-submit lay-filter="layuiadmin-app-form-submit" id="layuiadmin-app-form-submit" value="提交">
    </div>
    </div>
</form>


<script>

    layui.use(['layer', 'form'], function () {
        var layer = layui.layer
            , form = layui.form
            , $ = layui.jquery;

        form.on('submit(layuiadmin-app-form-submit)', function (data) {
                <c:if test="${empty id}">var url = "${ctxPath}/activiti/api/model";
            </c:if>
            var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
            $.ajax({
                type: "post",
                url: url,
                data:{_method:"PUT",name:$("#name").val(),key:$("#key").val()},
                success: function (data) {
                    if (data.code == 0) {
                        layer.msg("提交成功", {time: 1000},function(){
                            parent.layer.close(index);
                            parent.layui.table.reload('moduleTable'); //重载表格
                        });
                    } else {
                        layer.msg(data.msg);
                    }
                }
            });
        });

    });
</script>

<%@include file="../footer.jsp" %>

