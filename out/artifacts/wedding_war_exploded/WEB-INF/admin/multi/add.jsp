<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header_form.jsp" %>
<form class="layui-form" id="multiValueForm" lay-filter="multiValueForm" action="" style="padding: 20px 30px 0 30px;">
    <input id="id" name="id" type="hidden">
    <input id="content" name="content" type="hidden">
    <input id="CSRFToken" name="CSRFToken" type="hidden" value="${CSRFToken}">
    <div class="layui-fluid">
        <div class="layui-row">
            <div class="layui-col-xs12" style="margin-top: 30px">
                <div class="layui-form-item">
                    <label class="layui-form-label">代码名称：</label>
                    <div class="layui-input-block">
                        <input id="codeName"
                               name="codeName" type="text" class="layui-input" lay-verify="required|dicCode">
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-row">
            <div class="layui-col-xs12" align="center">
                <div class="layui-form-item layui-hide">
                    <input type="button" lay-submit lay-filter="layuiadmin-app-form-submit"
                           id="layuiadmin-app-form-submit" value="提交">
                </div>
            </div>
        </div>
    </div>
</form>


<script>

    layui.use(['layer', 'form'], function () {
        var layer = layui.layer
            , form = layui.form
            , $ = layui.jquery;

        //字段自定义验证
        form.verify({
            dicCode: [/^([\u4E00-\u9FA5A-Za-z0-9_]){0,20}$/, '必须是长度小于20的汉字、英文或下划线']

        });

        $(document).keydown(function (event) {
            if (event.keyCode == 13) {
                    <c:if test="${empty id}">var url = "./save";
                </c:if>

                $("#multiValueForm").ajaxSubmit({
                    type: "post",
                    url: url,
                    success: function (data) {
                        if (data.responseCode == 0) {
                            layer.msg("提交成功", {time: 3000}, function () {
                                var index = parent.layer.getFrameIndex(window.name);
                                parent.layer.close(index);
                                parent.layui.table.reload('multiCodeTable'); //重载表格
                            });
                        } else {
                            layer.msg(data.msg);
                        }
                    }
                });
                return false;

            }
        });


        form.on('submit(layuiadmin-app-form-submit)', function (e) {
                <c:if test="${empty id}">var url = "./save";
            </c:if>

            $("#multiValueForm").ajaxSubmit({
                type: "post",
                url: url,
                success: function (data) {
                    if (data.responseCode == 0) {
                        layer.msg("提交成功", {time: 3000}, function () {
                            var index = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(index);
                            parent.layui.table.reload('multiCodeTable'); //重载表格
                        });
                    } else {
                        layer.msg(data.msg);
                    }
                }
            });
            return false;
        });

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
                    $("#id").val(data.id);

                }
            });
        }

    });

</script>

<%@include file="../footer.jsp" %>

