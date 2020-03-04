<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>

<form class="layui-form" id="dictionaryForm" lay-filter="dictionaryForm" action="">
    <input id="id" name="id" type="hidden" value="${id}">
    <input id="CSRFToken" name="CSRFToken" type="hidden" value="${CSRFToken}">
    <div class="layui-fluid">
        <div class="layui-row">
            <div class="layui-col-xs12" style="margin-top: 30px">
                <div class="layui-form-item">
                    <div class="layui-input-block">
                        <input name="dictionaryFile" type="file" accept=".xls,.xlsx">
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-row">
            <div class="layui-col-xs12" align="center">
                <div class="layui-form-item">
                    <i class="layui-icon" style="font-size: 20px; color: #1E9FFF;">&#xe702;</i>
                    <span>Excel文件包含两列，第一列为代码值，第二列为显示值。<span>
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

        form.on('submit(layuiadmin-app-form-submit)', function (e) {
            url = "./excelImport";
            $("#dictionaryForm").ajaxSubmit({
                type: "post",
                url: url,
                success: function (data) {
                    if (data.responseCode == 0) {
                        layer.msg("提交成功", {time: 3000}, function () {
                            var index = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(index);
                            parent.layui.table.reload('moduleTable'); //重载表格
                        });
                    } else {
                        layer.msg(data.msg);
                    }
                }
            });
            return false;
        });


    });


</script>

<%@include file="../footer.jsp" %>

