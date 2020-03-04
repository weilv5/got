<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>

<form class="layui-form" id="modelForm" lay-filter="modelForm" action="">
    <input id="id" name="id" type="hidden">
    <input id="content" name="content" type="hidden">
    <input id="CSRFToken" name="CSRFToken" type="hidden" value="${CSRFToken}">
    <div class="layui-container">
        <div class="layui-row">
            <div class="layui-col-xs12" style="margin-top: 30px">
                <div class="layui-form-item">
                    <label class="layui-form-label">名称：</label>
                    <div class="layui-input-block">
                        <input id="name" name="name" type="text" class="layui-input">
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-row">
            <div class="layui-col-xs12" style="margin-top: 30px">
                <div class="layui-form-item">
                    <label class="layui-form-label">Key：</label>
                    <div class="layui-input-block">
                        <input id="key" name="key" type="text" class="layui-input">
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-row">
            <div class="layui-col-xs12" style="margin-top: 30px">
                <div class="layui-form-item">
                    <label class="layui-form-label">描述：</label>
                    <div class="layui-input-block">
                        <input id="metaInfo" name="metaInfo" type="text" class="layui-input">
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-row">
            <div class="layui-col-xs12" align="center">
                <button class="layui-btn" lay-submit lay-filter="*">提交</button>
            </div>
        </div>
    </div>
</form>


<script>

    layui.use(['layer', 'form'], function () {
        var layer = layui.layer
            , form = layui.form
            , $ = layui.jquery;

        var id = "${id}";

        form.on('submit(modelForm)', function (e) {
                <c:if test="${empty id}">var url = "./save";
            </c:if>
                <c:if test="${not empty id}">var url = "./update";
            </c:if>
            $("#modelForm").ajaxSubmit({
                type: "post",
                url: url,
                success: function (data) {
                    if (data.responseCode == 0) {
                        layer.msg("提交成功", {time: 3000}, function () {
                            var index = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(index);
                            parent.getThisTabWindow().loadTaskList();
                        });
                    } else {
                        layer.msg(data.msg);
                    }
                }
            });
            return false;
        });
    })


</script>

<%@include file="../footer.jsp" %>

