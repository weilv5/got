<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header_form.jsp"%>
    <form class="layui-form layui-form-pane" id="demoForm" lay-filter="demoForm" style="padding: 20px 30px 0 30px;font-size: 13px;">
        <input id="id" name="id" type="hidden">
        <input name="CSRFToken" type="hidden" value="${CSRFToken}">
            <div class="layui-form-item">
                <label class="layui-form-label">姓名</label>
                <div class="layui-input-block">
                        <input id="username"
                               name="username"
                               lay-verify="required|username"
                               type="text"
                               class="layui-input">
                </div>
            </div>
        <div class="layui-form-item layui-form-text">
            <label class="layui-form-label">请假事由</label>
            <div class="layui-input-block">
                <textarea placeholder="请输入内容" class="layui-textarea" id="applycontent" name="applycontent"></textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">用戶名</label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" name="userId" id="userId" value="<shiro:principal property="userId"/>" />
            </div>
        </div>
        <div class="layui-form-item" align="center">
            <button class="layui-btn" lay-submit lay-filter="*">提交</button>
            <button type="button" class="layui-btn layui-btn-primary" onclick="backToList()">返回</button>
        </div>
    </form>

<%@include file="../footer.jsp"%>
<script src="${ctxPath}/resources/js/ueditor.config.js"></script>
<script src="${ctxPath}/resources/js/ueditor.all.min.js"></script>
<script>
    layui.use(['form', 'layedit', 'laydate', 'tree','upload'], function () {
        var form = layui.form
                , layer = layui.layer
                , $ = layui.jquery;

    //监听提交
    form.on('submit(demoForm)', function (e) {
        <c:if test = "${empty id}" >
                var url = "./save";
        </c:if>
        <c:if test = "${not empty id}" >
                var url = "./update";
        </c:if>

        $("#demoForm").ajaxSubmit({
            type: "post",
            url: url,
            datatype: "json",
            success: function (data) {
                if (data.responseCode == 0) {
                    parent.layui.layer.msg("提交成功");
                    var index = parent.layer.getFrameIndex(window.name);
                    parent.layer.close(index);
                } else {
                    parent.layui.layer.msg(data.msg);
                }
            }

        });
        return false;
    });


        var id = "${id}";
        if (id != "") {
            var dt = (new Date()).getTime();
            $.ajax({
                url: "./get/" + id,
                dataType: "json",
                type: "get",
                data: {
                    dt: dt
                },
                success: function (data) {
                    console.log(JSON.stringify(data));
                    $("#id").val(data.id);
                            $("#username").val(data.username);
                            $("#applycontent").val(data.applycontent);
                            $("#userId").val(data.userId);
                            $("#deptId").val(data.deptId);
                    form.render();


                }
            });
        }

    });

    function backToList() {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    }

</script>
<script>
    window.userId = "<shiro:principal property="id"></shiro:principal>";
</script>


