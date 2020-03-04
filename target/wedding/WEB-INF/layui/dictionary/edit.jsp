<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>

<form class="layui-form" id="dictionaryForm" lay-filter="dictionaryForm" action="">
    <input id="id" name="id" type="hidden">
    <input id="content" name="content" type="hidden">
    <input id="CSRFToken" name="CSRFToken" type="hidden" value="${CSRFToken}">
    <div class="layui-fluid">
        <div class="layui-row">
            <div class="layui-col-xs12" style="margin-top: 30px">
                <div class="layui-form-item">
                    <label class="layui-form-label">分类：</label>
                    <div class="layui-input-block">
                        <input id="dictionaryCode"
                               name="dictionaryCode" type="text" class="layui-input" lay-verify="required|dicCode">
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


<script>

    layui.use(['layer', 'form'], function () {
        var layer = layui.layer
            , form = layui.form
            , $ = layui.jquery;

        //字段自定义验证
        form.verify({
            dicCode: function (value) {
                if (value.length > 20) {
                    return '分类长度不能超过20位';
                }
            }

        });

        form.on('submit(dictionaryForm)', function (e) {
                <c:if test="${empty id}">var url = "./save";
            </c:if>
                <c:if test="${not empty id}">var url = "./update";
            </c:if>
            $("#dictionaryForm").ajaxSubmit({
                type: "post",
                url: url,
                success: function (data) {
                    if (data.responseCode == 0) {
                        layer.msg("提交成功", {time: 3000}, function () {
                            var index = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(index);
                            parent.getThisTabWindow().loadDic();
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
                    $("#dictionaryCode").val(data.dictionaryCode);
                    $("#content").val(data.content);
                }
            });
        }


    })


    function backToList() {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    }

</script>

<%@include file="../footer.jsp" %>

