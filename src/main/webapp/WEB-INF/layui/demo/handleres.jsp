<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<link rel="stylesheet" href="${ctxPath}/resources/css/wangEditor.min.css">

<div class="layui-container" style="padding: 20px 15%;">
    <form class="layui-form layui-form-pane" id="demoForm" lay-filter="demoForm">
        <input id="id" name="id" type="hidden">
        <div class="layui-form-item" id="propertyDivusername">
            <label class="layui-form-label">申请人</label>
            <div class="layui-input-block">
                <input id="username"
                       name="username"
                       type="text"
                       value="${demo.username}"
                       class="layui-input" readonly>
            </div>
        </div>
        <div class="layui-form-item" id="propertyDivapplycontent">
            <label class="layui-form-label">申请事由</label>
            <div class="layui-input-block">
                <input id="applycontent"
                       name="applycontent"
                       type="text"
                       value="${demo.applycontent}"
                       class="layui-input" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">审批意见</label>
            <div class="layui-input-block">
                        <textarea id="comment"
                                  class="layui-textarea"
                                  rows="6"
                                  name="comment">
                                            </textarea>
            </div>
        </div>
        <div class="layui-form-item" align="center">
            <%--<button class="layui-btn" lay-submit lay-filter="*">同意</button>
            <button type="button" class="layui-btn layui-btn-primary">不同意</button>--%>
                    <c:forEach items="${requestScope.outcomeList}" var="keyword" varStatus="id">
                        <a class="layui-btn" id="submitBtn" onclick="submitBtn('${keyword}')">${keyword}</a>
                    </c:forEach>

        </div>
    </form>
</div>

<%@include file="../footer.jsp" %>
<script>
    layui.use(['form', 'layedit', 'laydate', 'tree', 'upload'], function () {
        var form = layui.form
            , layer = layui.layer
            , $ = layui.jquery;


        var outcomeList = "${requestScope.outcomeList}";
    });

    function submitBtn(outcome) {
        var comment = $.trim($("#comment").val());
        var taskId = "${requestScope.taskId}";

            $.ajax({
                url: "${ctxPath}/appres/submitTask",
                type: 'get',
                dataType: 'json',
                async: false,
                data: {
                    comment:comment,
                    outcome:outcome,
                    taskId:taskId

                },
                error: function () {
                    console.info("error");

                },
                success: function (data) {
                    console.info("success");
                    parent.layui.layer.msg("审批成功！");
                    var index = parent.layer.getFrameIndex(window.name);
                    parent.layer.close(index);
                    parent.getThisTabWindow().loadTaskList();
                }
            });


    }


</script>

