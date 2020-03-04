<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<form class="layui-form" id="sensitiveWordsForm" lay-filter="sensitiveWordsForm">
    <input id="id" name="id" type="hidden">
    <input id="CSRFToken" name="CSRFToken" type="hidden" value="${CSRFToken}">
    <div class="layui-fluid">
        <div class="layui-row">
            <div class="layui-col-xs12" style="margin-top: 30px">
                <div class="layui-form-item">
                    <label class="layui-form-label">敏感词：</label>
                    <div class="layui-input-block">
                        <input id="words"
                               name="words" type="text" class="layui-input">
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-row">
            <div class="layui-col-xs12" align="center">
                <button class="layui-btn" lay-submit lay-filter="*">提交</button>
                <button type="button" class="layui-btn layui-btn-primary" onclick="backToList()">返回</button>
            </div>
        </div>
    </div>
</form>

<%@include file="../footer.jsp" %>
<script>
    layui.use(['layer', 'form'], function () {
        var layer = layui.layer
            , form = layui.form
            , $ = layui.jquery;

        form.on('submit(sensitiveWordsForm)', function (e) {
                <c:if test="${empty id}">var url = "./save";
            </c:if>
                <c:if test="${not empty id}">var url = "./update";
            </c:if>
            $("#sensitiveWordsForm").ajaxSubmit({
                type: "post",
                url: url,
                success: function (data) {
                    if (data.responseCode == 0) {
                        layer.msg("提交成功", {time: 3000}, function () {
                            var index = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(index);
                            parent.getThisTabWindow().loadSensitive();
                        });
                    } else {
                        layer.msg(data.msg);
                    }
                }
            });
            return false;
        })

    })

    function backToList() {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    }
</script>
