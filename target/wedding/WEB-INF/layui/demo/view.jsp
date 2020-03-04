<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<div class="layui-container" style="padding: 20px 5%;">
    <form class="layui-form layui-form-pane" id="demoForm">
        <input id="id" name="id" type="hidden">
        <div class="layui-form-item">
            <label class="layui-form-label">姓名</label>
            <div class="layui-input-block">
                <input id="username"
                       name="username"
                       type="text"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
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
            <label class="layui-form-label">用户名</label>
            <div class="layui-input-block">
                <input id="userId"
                       name="userId"
                       type="text"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">部门编码</label>
            <div class="layui-input-block">
                <input id="deptId"
                       name="deptId"
                       type="text"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-form-item" align="center">
            <button type="button" class="layui-btn layui-btn-primary" onclick="backToList()">返回</button>
        </div>
    </form>
</div>


<%@include file="../footer.jsp"%>
<script>
    layui.use(['form','layedit','laydate','tree'],function() {
        var form = layui.form
                , layer = layui.layer
                , layedit = layui.layedit
                , laydate = layui.laydate
                , tree = layui.tree
                , $ = layui.jquery;

        viewdemo();

        function viewdemo(){
            var id = "${id}";
            if(id==="")
                return;
            var dt = (new Date()).getTime();
            $.ajax({
                url: "./get/" + id,
                dataType: "json",
                data:{
                    dt: dt
                },
                type: "get",
                success: function(data){
                    console.log(JSON.stringify(data));
                    $("#id").val(data.id);
                                $("#username").val(data.username);
                                $("#applycontent").val(data.applycontent);
                                $("#userId").val(data.userId);
                                $("#deptId").val(data.deptId);
                }
            });
        }

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

