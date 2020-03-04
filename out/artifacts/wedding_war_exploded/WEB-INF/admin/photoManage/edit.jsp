<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header_form.jsp"%>
<link rel="stylesheet" href="${ctxPath}/resources/css/wangEditor.min.css">
    <form class="layui-form layui-form-pane" id="weddingPhotoForm" lay-filter="weddingPhotoForm" style="padding: 20px 30px 0 30px;">
        <input id="id" name="id" type="hidden">
        <input id="photoHidden" name="photo" type="hidden" lay-verify="required">
        <input name="CSRFToken" type="hidden" value="${CSRFToken}">
        <div class="layui-form-item">
            <label class="layui-form-label">相册分类：</label>
            <div class="layui-input-inline">
                <select id="albumSort" name="albumSort" class="form-select-button" lay-verify="required"></select>
            </div>
            <label class="layui-form-label">照片分类：</label>
            <div class="layui-input-inline">
                <select id="photoSort" name="photoSort" class="form-select-button" lay-verify="required"></select>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">结婚照：</label>
            <c:if test = "${empty id}" >
                <button type="button" class="layui-btn" id="photoButn">多图片上传</button>
                <blockquote class="layui-elem-quote layui-quote-nm" style="margin-top: 10px;">
                    预览图：
                    <div class="layui-upload-list" id="photo"></div>
                </blockquote>
            </c:if>
            <c:if test = "${not empty id}" >
                <div class="layui-input-inline">
                    <button type="button" class="layui-btn" id="photoButn">上传结婚照</button>
                </div>
                <label class="layui-form-label">结婚照展示展示：</label>
                <div class="layui-input-inline">
                    <img class="layui-upload-img" id="photo" width="100%">
                    <p id="photoText"></p>
                </div>
            </c:if>
        </div>


     <div class="layui-form-item layui-hide">
                <input type="button" lay-submit lay-filter="layuiadmin-app-form-submit" id="layuiadmin-app-form-submit" value="提交">
      </div>
    </form>

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

        loadDictionary("select", "photoSort", "DataDictionary", "photoSort", "", "single");
        loadDictionary("select", "albumSort", "DataDictionary", "albumSort", "", "single");
        function loadDictionary(type, fieldName, table, field, text, isGroup) {
            var dt = (new Date()).getTime();
            $.ajax({
                url: "${ctxPath}/getDictionary",
                type: "post",
                dataType: "json",
                data: {
                    dictTable: table,
                    dictCode: field,
                    dictText: text,
                    dt: dt
                },
                success: function (dictionary) {
                    if (type === "select") {
                        var length = dictionary.length;
                        for (var i = 0; i < length; i++) {
                            $("#" + fieldName).append("<option value='" + dictionary[i].code + "'>" + dictionary[i].text + "</option>");
                            form.render();
                        }
                    }
                }
            });
        }

        <c:if test = "${empty id}" >
            //多图片上传
            upload.render({
                elem: '#photoButn'
                ,url: '${ctxPath}/file/upload' //改成您自己的上传接口
                ,multiple: true
                ,before: function(obj){
                    //预读本地文件示例，不支持ie8
                    obj.preview(function(index, file, result){
                        $('#photo').append('<img width="100px" src="'+ result +'" alt="'+ file.name +'" class="layui-upload-img">')
                    });
                }
                ,done: function(res){
                    //上传完毕
                    console.log(res);
                    var photo = $('#photoHidden').val();
                    $('#photoHidden').val(res.data.src + '|' + photo);
                }
            });
        </c:if>

        <c:if test = "${not empty id}" >
            //普通图片上传
            var uploadInst = upload.render({
                elem: '#photoButn'
                ,url: '${ctxPath}/file/upload'
                ,before: function(obj){
                    //预读本地文件示例，不支持ie8
                    obj.preview(function(index, file, result){
                        $('#photo').attr('src', result); //图片链接（base64）
                    });
                }
                ,done: function(res){
                    if(res.code != 0){
                        //如果上传失败
                        return layer.msg('上传失败');
                    } else{
                        //上传成功
                        $('#photoHidden').val(res.data.src);
                    }
                }
                ,error: function(){
                    //演示失败状态，并实现重传
                    var demoText = $('#photoText');
                    demoText.html('<span style="color: #FF5722;">上传失败</span> <a class="layui-btn layui-btn-xs photo-reload">重试</a>');
                    demoText.find('.photo-reload').on('click', function(){
                        uploadInst.upload();
                    });
                }
            });
        </c:if>

        form.verify({

    });

    //监听提交
    form.on('submit(layuiadmin-app-form-submit)', function (e) {
        <c:if test = "${empty id}" >
                var url = "./save";
        </c:if>
        <c:if test = "${not empty id}" >
                var url = "./update";
        </c:if>

        $("#weddingPhotoForm").ajaxSubmit({
            type: "post",
            url: url,
            datatype: "json",
            success: function (data) {
                if (data.responseCode == 0) {
                    parent.layui.layer.msg("提交成功");
                    var index = parent.layer.getFrameIndex(window.name);
                    parent.layer.close(index);
                    parent.layui.table.reload('weddingPhotoTable'); //重载表格
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
                    $("#id").val(data.id);
                    if(data.photoSort.length > 0) {
                        var photoSort = data.photoSort.split('|')[2];
                        console.log(photoSort)
                        $('option[value=' + photoSort + ']', '#photoSort').attr('selected', 'selected');
                    }
                    if(data.albumSort.length > 0) {
                        var albumSort = data.albumSort.split('|')[2];
                        console.log(albumSort)
                        $('option[value=' + albumSort + ']', '#albumSort').attr('selected', 'selected');
                    }
                    // 电子证书
                    if(data.photo.length > 0)
                    {
                        $('#photo').attr('src', data.photo);
                        $('#photoHidden').val(data.photo);
                    }
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

