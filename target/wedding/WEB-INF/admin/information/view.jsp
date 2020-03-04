<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header_form.jsp"%>
    <form class="layui-form layui-form-pane"  id="departmentForm" style="padding: 20px 30px 0 30px;">
        <input id="id" name="id" type="hidden" >
        <div class="layui-form-item">
            <label class="layui-form-label">标题</label>
            <div class="layui-input-block">
                <input class="layui-input" id="title" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">作者</label>
            <div class="layui-input-block">
                <input class="layui-input" id="author" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">发布日期</label>
            <div class="layui-input-block">
                <input class="layui-input" id="releasedDate" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">信息类别</label>
            <div class="layui-input-block">
                <input class="layui-input" id="infoType" readonly>
            </div>
        </div>
        <div class="layui-form-item layui-form-text">
            <label class="layui-form-label">内容</label>
            <div class="layui-input-block">
                <div id="content" class="layui-textarea"></div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">附件</label>
            <div class="layui-input-block">
                <div id="attachment" class="layui-input"></div>
            </div>
        </div>
        <div class="layui-form-item" align="center">
            <button type="button" class="layui-btn layui-btn-primary" onclick="backToList()">返回</button>
        </div>
    </form>
<script>
    layui.use(['form','layedit','laydate','tree'],function() {
        var form = layui.form
            , layer = layui.layer
            , layedit = layui.layedit
            , laydate = layui.laydate
            , tree = layui.tree
            , $ = layui.jquery;
        var id = "${id}";
        console.info(id);
        if(id === "")
            return;
        var dt = (new Date()).getTime();
        $.ajax({
            url:"./get/"+id,
            dataType:"json",
            type:"get",
            data:{
                dt:dt
            },
            success:function(data){
                $("#id").val(data.id);
                if(data.user)
                    $("#author").val(data.user.name);
                $("#releasedDate").val(data.releasedDate);
                $("#title").val(data.title);
                $("#content").html(decodeHTML(data.content));
                var value = data.infoType.split("|")[3];
                $("#infoType").val(value);
                if(data.attachment){
                    var download = $("<a href='./download/" + data.id + "/attachment' target='_blank'><i class=\"layui-icon layui-icon-download-circle\" style=\"font-size: 25px;\"></i> 下载附件</a>");
                    $("#attachment").append(download);
                }
            },
            error:function(){
                //获取用户失败
            }
        });

    });

    function backToList() {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    }
    function decodeHTML(str){
        var s = "";
        if(!str || str.length == 0) return "";
        s = str.replace(/&amp;/g,"&");
        s = s.replace(/&lt;/g,"<");
        s = s.replace(/&gt;/g,">");
        s = s.replace(/&nbsp;/g," ");
        s = s.replace(/&#39;/g,"\'");
        s = s.replace(/&quot;/g,"\"");
        return s;
    }



</script>
<%@include file="../footer.jsp"%>