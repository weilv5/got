<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header_form.jsp"%>

    <form class="layui-form layui-form-pane" style="padding: 20px 30px 0 30px;">
        <div class="layui-form-item">
            <label class="layui-form-label">敏感词：</label>
            <div class="layui-input-block">
                <input class="layui-input" id="words" readonly>
            </div>
        </div>
    </form>
<script>
    layui.use(['form','layer'], function () {
        var form = layui.form
            ,layer = layui.layer
            , $ = layui.jquery;
        var id = "${id}";
        if(id==="")
            return;
        var dt = (new Date()).getTime();
        $.ajax({
            url: "./get/" + id,
            dataType: "json",
            type: "get",
            data: {
                dt: dt
            },
            success: function(data){
                $("#words").val(data.words);
            }
        });
    });
</script>
<%@include file="../footer.jsp"%>