<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<link rel="stylesheet" href="${ctxPath}/resources/css/wangEditor.min.css">

<div class="layui-container" style="padding: 20px 15%;">
    <form class="layui-form layui-form-pane" id="demoForm" lay-filter="demoForm">
        <input id="id" name="id" type="hidden">
        <input name="CSRFToken" type="hidden" value="${CSRFToken}">
            <div class="layui-form-item" id="propertyDivusername">
                <label class="layui-form-label">姓名</label>
                <div class="layui-input-block">
                        <input id="username"
                               name="username"
                               lay-verify="required|username"
                               type="text"
                               class="layui-input">
                </div>
            </div>
            <div class="layui-form-item" id="propertyDivapplycontent">
                <label class="layui-form-label">事由</label>
                <div class="layui-input-block">
                        <textarea id="applycontent"
                                  class="layui-textarea"
                                  rows="6"
                                  name="applycontent">
                                            </textarea>
                </div>
            </div>
        <div class="layui-form-item">
            <label class="layui-form-label">用戶名</label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" name="userId" id="userId" value="<shiro:principal property="userId"/>" readonly/>
            </div>
        </div>
           <%-- <div class="layui-form-item" id="propertyDivdeptId">
                <label class="layui-form-label">部门编码</label>
                <div class="layui-input-block">
                        <input id="deptId"
                               name="deptId"
                               lay-verify="required|deptId"
                               type="text"
                               class="layui-input">
                </div>
            </div>--%>
        <div class="layui-form-item" align="center">
            <button class="layui-btn" lay-submit lay-filter="*">提交</button>
            <button type="button" class="layui-btn layui-btn-primary" onclick="backToList()">返回</button>
        </div>
    </form>
</div>

<%@include file="../footer.jsp"%>
<script src="${ctxPath}/resources/js/ueditor.config.js"></script>
<script src="${ctxPath}/resources/js/ueditor.all.min.js"></script>
<script>
    layui.use(['form', 'layedit', 'laydate', 'tree','upload'], function () {
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
            username:function (value) {
                        if(value.length>30)
                            return '姓名长度不能超过30位';
                    else if(value == null)
                        return '姓名不能为空';

            },
            applycontent:function (value) {
                        if(value.length>30)
                            return '事由长度不能超过30位';
                    else if(value == null)
                        return '事由不能为空';

            },
            userId:function (value) {
                        if(value.length>30)
                            return '用户名长度不能超过30位';
                    else if(value == null)
                        return '用户名不能为空';

            },
            deptId:function (value) {
                        if(value.length>30)
                            return '部门编码长度不能超过30位';
                    else if(value == null)
                        return '部门编码不能为空';

            },

    });

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
                    parent.getThisTabWindow().loaddemo();
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
                            $("#username").val(data.username);
                            $("#applycontent").val(data.applycontent);
                            $("#userId").val(data.userId);
                            $("#deptId").val(data.deptId);
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

    function backToList() {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    }

</script>
<script>
    window.userId = "<shiro:principal property="id"></shiro:principal>";
</script>


