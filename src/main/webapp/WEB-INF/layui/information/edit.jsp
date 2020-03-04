<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<link rel="stylesheet" href="${ctxPath}/resources/css/wangEditor.min.css">
<form class="layui-form" id="moduleForm">
    <input id="id" name="id" type="hidden">
    <input name="CSRFToken" type="hidden" value="${CSRFToken}">
    <table class="layui-table" lay-skin="nob">
        <tr>
            <th width="10%" style="text-align: right">标题:</th>
            <th width="40%"><input id="title" name="title" class="layui-input"></th>
            <th width="10%" style="text-align: right">发布日期:</th>
            <th width="40%"><input id="releasedDate" name="releasedDate" class="layui-input"
                                   placeholder="yyyy-MM-dd HH:mm:ss"></th>
        </tr>
        <tr>
            <th width="10%" style="text-align: right">作者:</th>
            <th width="40%"><input id="author" name="author" author class="layui-input"></th>
            <th width="10%" style="text-align: right">信息类别:</th>
            <th width="40%">
                <select id="infoType"
                        name="infoType"
                        class="form-select-button"></select>
            </th>
        </tr>
        <tr>
            <th width="10%" style="text-align: right">内容:</th>
            <th width="90%" colspan="3">
                <input type="hidden" name="content" id="content">
                <div id="contentHtml" style="width: 100%;"></div>
            </th>
        </tr>
        <tr>
            <th width="10%" style="text-align: right">附件:</th>
            <th width="90%" colspan="3">
                <input id="attachment"
                       name="attachment"
                       type="file"
                       class="form-control">
            </th>
        </tr>
        <tr>
            <th colspan="4" style="text-align:center;" >
            <button class="layui-btn" lay-submit lay-filter="*">提交</button>
            </th>
        </tr>
    </table>
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

    })

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
        window.open("./?method=page", "_self");
    }

    function saveinformation_content() {
            <c:if test="${empty id}">var url = "./save";
        </c:if>
            <c:if test="${not empty id}">var url = "./update";
        </c:if>
        $("#content").val(window.contentHtmlUe.getContent());
        $("#information_contentForm").ajaxSubmit({
            type: "post",
            url: url,
            success: function (data) {
                $(".w-e-toolbar").css("z-index", 1);
                $(".w-e-menu").css("z-index", 1);
                if (data.responseCode == 0) {
                    $("#msg").text("提交成功");
                    $("#closeBtn").hide();
                    setTimeout(backToList, 1000)
                } else {
                    $("#msg").text(data.msg);
                    $("#closeBtn").show();
                }
                $('#alertModal').modal("show");
            }
        });
    }

    function viewinformation_content() {
        var id = "${id}";
        if (id === "")
            return;
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
                    $("#author").text(data.user.name);

                $("#releasedDate").val(data.releasedDate);
                $("#title").val(data.title);
                window.contentHtmlUe.ready(function () {
                    window.contentHtmlUe.setContent(decodeHTML(data.content));
                });

                var value = data.infoType.split("|")[2];
                $("#infoType ").val(value);

            }
        });

    }

    $(document).ready(function () {
        window.contentHtmlUe = UE.getEditor('contentHtml');
        $("#information_contentForm").bootstrapValidator({
            fields: {
                releasedDate: {
                    validators: {
                        notEmpty: {
                            message: '发布日期不能为空'
                        },
                        stringLength: {
                            max: 30,
                            message: '发布日期长度不能超过30位'
                        },
                        regexp: {
                            regexp: /^((\d{2}(([02468][048])|([13579][26]))[\-\/\s]?((((0?[13578])|(1[02]))[\-\/\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\-\/\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\-\/\s]?((0?[1-9])|([1-2][0-9])))))|(\d{2}(([02468][1235679])|([13579][01345789]))[\-\/\s]?((((0?[13578])|(1[02]))[\-\/\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\-\/\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\-\/\s]?((0?[1-9])|(1[0-9])|(2[0-8]))))))(\s((([0-1][0-9])|(2?[0-3]))\:([0-5]?[0-9])((\s)|(\:([0-5]?[0-9])))))?$/,
                            message: '发布日期是日期时间型'
                        }
                    }
                },
                title: {
                    validators: {
                        notEmpty: {
                            message: '标题不能为空'
                        },
                        stringLength: {
                            max: 50,
                            message: '标题长度不能超过50位'
                        },
                    }
                },
                infoType: {
                    validators: {
                        notEmpty: {
                            message: '信息类别不能为空'
                        },
                        stringLength: {
                            max: 30,
                            message: '信息类别长度不能超过30位'
                        }
                    }
                }
            }
        }).on('success.form.bv', function (e) {
            e.preventDefault();
            saveinformation_content();
        });
        $("#information_contentForm").on("submit", function (e) {
            e.preventDefault();
        });

        $('.date').datetimepicker({
            locale: 'zh-cn',
            format: "YYYY-MM-DD"
        });
        $('.datetime').datetimepicker({
            locale: 'zh-cn',
            format: "YYYY-MM-DD HH:mm:ss"
        });

        $('.date')
            .on('dp.change dp.show', function (e) {
                $('#information_contentForm').data('bootstrapValidator').revalidateField(e.target.id);
            });
        $('.datetime')
            .on('dp.change dp.show', function (e) {
                $('#information_contentForm').data('bootstrapValidator').revalidateField(e.target.id);
            });
        viewinformation_content();
        loadDictionary("select", "infoType", "DataDictionary", "info_type", "", "single");
    });

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
                    }
                }
            }
        });
    }

    function backToList() {
        window.open("./?method=page", "_self");
    }
</script>
