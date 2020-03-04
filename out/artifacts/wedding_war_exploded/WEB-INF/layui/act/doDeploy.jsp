<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ include file="../header.jsp" %>
<div class="layui-container" style="padding:30px 5%;">
    <form class="layui-form layui-form-pane" id="deployForm">
        <div class="layui-form-item">
            <div class="layui-form-item">
            <input type="file" name="file" id="fileOfDef"/>
            </div>
            <div class="layui-form-item">
                <label style="color:red;">支持文件格式：&nbsp; .zip&nbsp; .bar&nbsp; .bpmn&nbsp; .bpmn20.xml</label>
            </div>
            <br/>
            <div class="layui-form-item" align="center">
                <button class="layui-btn " onclick="deploy();">提交</button>
                <button class="layui-btn layui-btn-primary" onclick="backToList()">返回</button>
            </div>
        </div>

    </form>

</div>
<script>
    layui.use(['table', 'form', 'layer'], function () {
        var form = layui.form,
            table = layui.table,
            layer = layui.layer,
            $ = layui.jquery;


    });

    function deploy() {

        $("#deployForm").ajaxSubmit({
            type: "post",
            url: "./deploy",
            async: false,
            success: function (data) {
                if (data.responseCode == 0) {
                    parent.layui.layer.msg("流程部署成功");
                    parent.getThisTabWindow().window.loadProcess();
                } else {
                    parent.layui.layer.msg(data.msg);
                }

            },
            error: function(data){
                alert(JSON.stringify(data));

            }
        });
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);

    }


    function backToList() {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    }

</script>
<%@ include file="../footer.jsp" %>