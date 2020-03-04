<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<div class="layui-container" style="padding: 20px 5%;">
    <form class="layui-form layui-form-pane"  id="DemoForm" lay-filter="DemoForm">
        <input id="id" name="id" type="hidden">
        <input name="CSRFToken" type="hidden" value="${CSRFToken}">
<%--        <input id="deptId" name="deptId" type="hidden">--%>

        <div class="layui-form-item">
            <label class="layui-form-label">姓名<label style="color:red;">*</label></label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" placeholder="请输入姓名" name="username" id="name" lay-verify="required|name"/>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">请假事由<label style="color:red;">*</label></label>
            <div class="layui-input-block">
                <textarea name="applyContent" placeholder="请输入请假事由" class="layui-textarea"></textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">用戶名</label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" name="userId" id="userId" value="${window.userId}" readonly/>
            </div>
        </div>
        <div class="layui-form-item" align="center">
            <button class="layui-btn" lay-submit lay-filter="*">提交</button>
            <button type="button" class="layui-btn layui-btn-primary" onclick="backToList()">返回</button>
        </div>
    </form>
</div>
<script>
    layui.use(['form', 'layedit', 'laydate', 'tree'], function () {
        var form = layui.form
            , layer = layui.layer
            , layedit = layui.layedit
            , laydate = layui.laydate
            , tree = layui.tree
            , $ = layui.jquery;

        $("#userId").val(window.userId);

        //新增、编辑

        //监听提交
        form.on('submit(DemoForm)', function (e) {
                <c:if test="${empty id}">var url = "./save";
            </c:if>
                <c:if test="${not empty id}">var url = "./update";
            </c:if>
            $("#DemoForm").ajaxSubmit({
                type: "post",
                url: url,
                dataType: "json",
                success: function (data) {
                    if (data.responseCode == 0) {
                        //提交成功
                        parent.layui.layer.msg("提交成功");
                        var index = parent.layer.getFrameIndex(window.name);
                        parent.layer.close(index);
                        parent.getThisTabWindow().loadUser()


                    } else {
                        layui.layer.msg(data.msg);

                    }

                },
                error: function () {
                    layui.layer.msg("申请失败");
                }
            });
            return false;
        });



    });


    function backToList() {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    }

</script>
<script type="text/javascript" src="${ctxPath}/resources/js/jquery.js"></script>
<script type="text/javascript" src="${ctxPath}/resources/js/jquery.form.min.js"></script>
<script>
    window.userId = "<shiro:principal property="id"></shiro:principal>";
</script>

<%@include file="../footer.jsp" %>
