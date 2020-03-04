<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header_form.jsp" %>
<link rel="stylesheet" href="${ctxPath}/resources/css/wangEditor.min.css">
<form class="layui-form" id="moduleForm" style="padding: 20px 30px 0 30px;">
    <input id="id" name="id" type="hidden">
    <input name="CSRFToken" type="hidden" value="${CSRFToken}">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">标题<label style="color:red;">*</label></label>
            <div class="layui-input-inline">
                <input class="layui-input" type="text" name="title" id="title" lay-verify="required|title"/>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">信息类别<label style="color:red;">*</label></label>
            <div class="layui-input-inline">
                <select id="infoType" name="infoType" class="form-select-button" lay-verify="required"></select>
            </div>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">作者</label>
            <div class="layui-input-inline">
                <input class="layui-input" type="text" name="author" id="author" value="<shiro:principal property="name"></shiro:principal>" readonly/>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">发布日期<label style="color:red;">*</label></label>
            <div class="layui-input-inline">
                <input class="layui-input" type="text" name="releasedDate" id="releasedDate" lay-verify="required|releasedDate"/>
            </div>
        </div>

    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">内容<label style="color:red;">*</label></label>
        <div class="layui-input-block" style="width: 80%;z-index:1;position: relative;">
            <input type="hidden" name="content" id="content" lay-verify="content"/>
            <div id="contentHtml"></div>
        </div>
    </div>
   <%-- <div class="layui-form-item">
        <label class="layui-form-label">附件</label>
        <div class="layui-input-inline">
            <input type="file" name="attachment" id="attachment" lay-verify="file"><span id="checkattachment"></span>
        </div>
    </div>--%>
    <div class="layui-form-item">
        <label class="layui-form-label">附件</label>
        <div class="layui-input-block">
            <label for="attachment" class="layui-btn layui-btn-warm">
                选择文件
                <input type="file"  id="attachment" name="attachment" style="display: none;" onchange="removedown()">
            </label>
            <span id="text">未选中任何文件</span>
        </div>
    </div>
    <div class="layui-form-item layui-hide">
        <input type="button" lay-submit lay-filter="layuiadmin-app-form-submit" id="layuiadmin-app-form-submit" value="提交">
    </div>
</form>
<%@include file="../footer.jsp" %>
<script src="${ctxPath}/resources/js/ueditor.config.js"></script>
<script src="${ctxPath}/resources/js/ueditor.all.min.js"></script>
<script>
    layui.use(['layer', 'form', 'laydate'], function () {
        var layer = layui.layer
            , form = layui.form
            , laydate = layui.laydate
            , $ = layui.jquery;

        laydate.render({
            elem: '#releasedDate',
            type: 'datetime'
        });
        window.contentHtmlUe = UE.getEditor('contentHtml');
        loadDictionary("select", "infoType", "DataDictionary", "info_type", "", "single");
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
        //字段自定义验证
        form.verify({
            title: function (value) {
                if (value.length > 30) {
                    return '标题不能超过30位';
                }
            },
            file:function(value) {
                var index = value.lastIndexOf(".");
                var ext = value.substr(index+1);
                //var exec = (/[.]/.exec(value)) ? /[^.]+$/.exec(value.toLowerCase()) : "";
                var arr = ["png","jpg","gif","doc","docx","ppt","txt","pptx","xls","xlsx","jpeg","pdf","zip","rar"];
                if ($.inArray(ext,arr) < 0 ){
                    return '文件格式不对，请上传png,jpg,gif,doc,docx,ppt,txt,pptx,xls,xlsx,jpeg,pdf,zip,rar文件!';
                }
            },
            content:function(){
                if(window.contentHtmlUe.getContent().length == 0){
                    return '内容不能为空';
                }

            }


        });


        //监听提交
        form.on('submit(layuiadmin-app-form-submit)', function (e) {
                <c:if test="${empty id}">var url = "./save";
            </c:if>
                <c:if test="${not empty id}">var url = "./update";
            </c:if>
            $("#content").val(window.contentHtmlUe.getContent());
            $("#moduleForm").ajaxSubmit({
                type: "post",
                url: url,
                success: function (data) {
                    $(".w-e-toolbar").css("z-index", 1);
                    $(".w-e-menu").css("z-index", 1);
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
                    if (data.user)
                        $("#author").val(data.user.name);

                    $("#releasedDate").val(data.releasedDate);
                    $("#title").val(data.title);
                    window.contentHtmlUe.ready(function () {
                        window.contentHtmlUe.setContent(decodeHTML(data.content));
                    });

                    var value = data.infoType.split("|")[2];
                    $("#infoType ").val(value);
                    if(data.attachment){
                        $("#text").empty();
                        var download = $("<a href='./download/" + data.id + "/attachment' target='_blank'> 下载附件</a>");
                        $("#text").append(download);
                    }
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

    function removedown() {
        var filepath = $("#attachment").val();
        if(filepath != null)
        $("#text").html(filepath);
    }


</script>
