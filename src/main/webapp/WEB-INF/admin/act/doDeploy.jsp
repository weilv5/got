<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ include file="../header_form.jsp" %>
    <form class="layui-form layui-form-pane" id="deployForm" style="padding: 20px 30px 0 30px;">
        <div class="layui-form-item">
            <div class="layui-inline">
            <input type="file" name="file" id="fileOfDef"/>
            </div>
            <div class="layui-inline">
                <label style="color:red;">支持文件格式：&nbsp; .zip&nbsp; .bar&nbsp; .bpmn&nbsp; .bpmn20.xml</label>
            </div>
            <br/>
           <div class="layui-form-item" align="center">
                <button class="layui-btn " onclick="deploy();">提交</button>
                <button class="layui-btn layui-btn-primary" onclick="backToList()">返回</button>
            </div>
        </div>

    </form>

<script>
    layui.config({
        base: '${ctxPath}/resources/layuiadmin/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['index', 'layer','form'], function () {
        var layer = layui.layer,
            form = layui.form,
            $ = layui.jquery;
    });


    function deploy() {
        $("#deployForm").ajaxSubmit({
            type: "put",
            url: "${ctxPath}/activiti/api/deployment/bpmn",
            async: false,
            success: function (data) {
                if (data.code == 0) {
                    parent.layui.layer.msg("流程文件部署成功");
                    parent.layui.table.reload('processTable');
                } else {
                    parent.layui.layer.msg(data.msg);
                }

            },
            error: function(data){
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