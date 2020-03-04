<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header_form.jsp" %>
<link rel="stylesheet" href="${ctxPath}/resources/css/wangEditor.min.css">
<form class="layui-form layui-form-pane" id="udp_point_permissionForm" lay-filter="udp_point_permissionForm"
      style="padding: 20px 30px 0 30px;">
    <input id="id" name="id" type="hidden">
    <input name="CSRFToken" type="hidden" value="${CSRFToken}">
    <div class="layui-fluid">
        <div class="layui-row">
            <div class="layui-col-xs12" style="margin-top: 30px">
                <div class="layui-form-item">
                    <label class="layui-form-label">功能点名称</label>
                    <div class="layui-input-block">
                        <input id="pointName"
                               name="pointName"
                               type="text"
                               class="layui-input">
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-row">
            <div class="layui-col-xs12" style="margin-top: 30px">
                <div class="layui-form-item">
                    <label class="layui-form-label">表达式</label>
                    <div class="layui-input-block">
                        <input id="pointExpression"
                               name="pointExpression"
                               type="text"
                               class="layui-input">
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="layui-form-item layui-hide">
        <input type="button" lay-submit lay-filter="layuiadmin-app-form-submit" id="layuiadmin-app-form-submit"
               value="提交">
    </div>
</form>

<%@include file="../footer.jsp" %>
<script src="${ctxPath}/resources/js/ueditor.config.js"></script>
<script src="${ctxPath}/resources/js/ueditor.all.min.js"></script>
<script>
    layui.use(['form', 'layedit', 'laydate', 'tree', 'upload'], function () {
        var form = layui.form
            , layer = layui.layer
            , layedit = layui.layedit
            , laydate = layui.laydate
            , tree = layui.tree
            , upload = layui.upload
            , $ = layui.jquery;


        laydate.render({
            elem: '#createdDate',
            type: 'date'
        });

        laydate.render({
            elem: '#updatedDate',
            type: 'date'
        });


        form.verify({
            pointName: function (value) {
                if (value.length > 50)
                    return '功能点名称长度不能超过50位';

            },
            pointExpression: function (value) {
                if (value.length > 100)
                    return '功能点表达式长度不能超过100位';

            },

        });

        //监听提交
        form.on('submit(layuiadmin-app-form-submit)', function (e) {
            <c:if test = "${empty id}" >
            var url = "./save";
            </c:if>
            <c:if test = "${not empty id}" >
            var url = "./update";
            </c:if>

            $("#udp_point_permissionForm").ajaxSubmit({
                type: "post",
                url: url,
                datatype: "json",
                success: function (data) {
                    if (data.responseCode == 0) {
                        parent.layui.layer.msg("提交成功");
                        var index = parent.layer.getFrameIndex(window.name);
                        parent.layer.close(index);
                        parent.layui.table.reload('udp_point_permissionTable'); //重载表格
                        //刷新
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
                    $("#pointName").val(data.pointName);
                    $("#pointExpression").val(data.pointExpression);
                    form.render();


                }
            });
        }

    });

    function decodeHTML(str) {
        var s = "";
        if (!str || str.length == 0) return "";
        s = str.replace(/&amp;/g, "&");
        s = s.replace(/&lt;/g, "<");
        s = s.replace(/&gt;/g, ">");
        s = s.replace(/&nbsp;/g, " ");
        s = s.replace(/&#39;/g, "\'");
        s = s.replace(/&quot;/g, "\"");
        return s;
    }

</script>

