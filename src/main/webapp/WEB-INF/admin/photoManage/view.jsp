<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header_form.jsp"%>
    <form class="layui-form layui-form-pane" id="weddingPhotoForm" style="padding: 20px 30px 0 30px;">
        <input id="id" name="id" type="hidden">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">相册分类</label>
                <div class="layui-input-inline">
                    <input id="albumSort"
                           name="albumSort"
                           class="layui-input" readonly/>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">照片分类</label>
                <div class="layui-input-inline">
                    <input id="photoSort"
                           name="photoSort"
                           class="layui-input" readonly/>
                </div>
            </div>
        </div>
        <div class="layui-form-item">
                    <div class="layui-inline">
                        <label class="layui-form-label">照片</label>
                        <div class="layui-input-inline">
                            <img class="layui-upload-img" id="photo" width="100%">
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

        viewweddingPhoto();

        function viewweddingPhoto(){
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
                    $("#id").val(data.id);
                                $("#photoSort").val(data.photoSort);
                                $("#albumSort").val(data.albumSort);
                                // 结婚照
                                if(data.photo.length > 0)
                                {
                                    $('#photo').attr('src', data.photo);
                                }
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

