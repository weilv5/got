<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header_form.jsp" %>
<form class="layui-form" id="sensitiveWordsForm" lay-filter="sensitiveWordsForm" style="padding: 20px 30px 0 0;">
    <input id="id" name="id" type="hidden">
    <input id="CSRFToken" name="CSRFToken" type="hidden" value="${CSRFToken}">
    <div class="layui-form-item">
        <label class="layui-form-label">敏感词：</label>
        <div class="layui-input-inline">
            <input id="words" name="words" type="text" class="layui-input" lay-verify="words">
        </div>
    </div>
    <div class="layui-form-item layui-hide">
        <input type="button" lay-submit lay-filter="layuiadmin-app-form-submit" id="layuiadmin-app-form-submit" value="提交">
    </div>
</form>

<%@include file="../footer.jsp" %>
<script>
    layui.use(['layer', 'form'], function () {
        var layer = layui.layer
            , form = layui.form
            , $ = layui.jquery;

        //字段自定义验证
        form.verify({
            words: [/^[\u4E00-\u9FA5A-Za-z]+$/, '必须是字符']
        });

        form.on('submit(layuiadmin-app-form-submit)', function (data) {
                <c:if test="${empty id}">var url = "./save";
            </c:if>
                <c:if test="${not empty id}">var url = "./update";
            </c:if>
            var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
            $.ajax({
                type: "post",
                url: url,
                data:data.field,
                success: function (data) {
                    if (data.responseCode == 0) {
                        layer.msg("提交成功", {time: 1000},function(){
                            parent.layer.close(index);
                            parent.layui.table.reload('moduleTable'); //重载表格
                        });
                    } else {
                        layer.msg(data.msg);
                    }
                }
            })
        })

        var id = "${id}";
        if (id !== "") {
            var dt = (new Date()).getTime();
            $.ajax({
                url: "./get/" + id,
                dataType: "json",
                type: "get",
                data: {
                    dt: dt
                },
                success: function (data) {
                    form.val("sensitiveWordsForm", data);
                    form.render();
                }
            });
        }

    })

</script>
