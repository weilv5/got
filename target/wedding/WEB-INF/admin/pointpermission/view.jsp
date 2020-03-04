<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header_form.jsp"%>
    <form class="layui-form layui-form-pane" id="udp_point_permissionForm" style="padding: 20px 30px 0 30px;">
        <input id="id" name="id" type="hidden">
        <div class="layui-form-item">
        </div>
        <div class="layui-form-item">
        </div>
        <div class="layui-form-item">
        </div>
        <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">功能点名称</label>
                        <div class="layui-input-inline">
                                <input id="pointName"
                                       name="pointName"
                                       class="layui-input" readonly/>
                        </div>
                    </div>

                    <div class="layui-inline">
                        <label class="layui-form-label">功能点表达式</label>
                        <div class="layui-input-inline">
                                <input id="pointExpression"
                                       name="pointExpression"
                                       class="layui-input" readonly/>
                        </div>
                    </div>

        </div>
        <div class="layui-form-item" align="center">
            <button type="button" class="layui-btn layui-btn-primary" onclick="backToList()">返回</button>
        </div>
    </form>


<%@include file="../footer.jsp"%>
<script>
    layui.use(['form', 'layedit', 'laydate', 'tree'], function () {
        var form = layui.form
                , layer = layui.layer
                , layedit = layui.layedit
                , laydate = layui.laydate
                , tree = layui.tree
                , $ = layui.jquery;

        viewudp_point_permission();

        function viewudp_point_permission(){
            var id = "${id}";
            if (id === "")
                return;
            var dt = (new Date()).getTime();
            $.ajax({
                url: "./get/" + id,
                dataType: "json",
                data: {
                    dt: dt
                },
                type: "get",
                success: function (data) {
                    console.log(JSON.stringify(data));
                    $("#id").val(data.id);
                                $("#pointName").val(data.pointName);
                                $("#pointExpression").val(data.pointExpression);
                }
            });
        }

    });

    function backToList() {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    }

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

