<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ include file="../header.jsp" %>
<!-- 工具集 -->
<div class="my-btn-box">
    <span class="fl">
        <a class="layui-btn btn-default btn-add" id="btn-add">添加</a>
    </span>
</div>
<div id="modelTable" lay-filter="modelTable"></div>
<script>
    layui.use(['table', 'layer'], function () {
        var table = layui.table
            , layer = layui.layer
            , $ = layui.jquery;

        window.loadTaskList = function () {

            table.render({
                elem: '#modelTable'
                , height: 'full-70'
                , cols: [[
                    {checkbox: true, fixed: true},
                    {field: 'id', title: '模型编号', width: 100},
                    {field: 'name', title: '名称', width: 150},
                    {field: 'key', title: 'KEY', width: 120},
                    {field: 'metaInfo', title: '描述', width: 500},
                    {fixed: 'right', title: '操作', width: 150, align: 'center', toolbar: '#barOption'}
                ]]
                , url: './list'
                , method: 'get'
                , page: true
                , request: {
                  limitName: "size"
                }
                , response: {
                  countName: "totalElements",
                  dataName: "content"
                }
                , limits: [30, 60, 90, 150, 300]
                , limit: 30
            });
        }
        loadTaskList();
        table.on('tool(modelTable)', function (obj) {
            var data = obj.data
                , layEvent = obj.event;
            if (layEvent == "edit") {
              window.open("${ctxPath}/modeler.html?modelId=" + data.id);
                }
            else if(layEvent == "deploy"){
                parent.layui.layer.confirm("确定部署模型？",{icon:3,title:'提示'},function (index) {
                    parent.layui.layer.close(index);
                    parent.layui.layer.load(3,{time:1000});
                    $.ajax({
                        url:"./deploy/"+data.id,
                        type:"get",
                        dataType: 'json',
                        async:false,
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
                });
            }
            else if(layEvent == "del"){
                parent.layui.layer.confirm("确定要删除模型？",{icon:3,title:'提示'},function(index){
                    parent.layui.layer.close(index);
                    parent.layui.layer.load(3,{time:1000});
                    $.ajax({
                        url:"./delete/"+data.id,
                        type:"post",
                        dataType:"json",
                        success:function(data){
                            if(data.responseCode==0){
                                parent.layui.layer.msg("删除成功");
                                loadTaskList();
                            }else{
                                parent.layui.layer.msg(data.msg);
                            }
                        }
                    });

                });
            }
        });
        //添加
        $("#btn-add").on('click', function(){
            openLayer("${ctxPath}/activiti/model/edit", "新建模型", "700px", "400px");
        });
    });

    <%--//办理--%>
    <%--function getTask(taskId) {--%>
        <%--window.currTaskId = taskId;--%>
        <%--$.ajax({--%>
            <%--url:"${ctx}/activiti",--%>
            <%--data:{--%>
                <%--taskId:taskId--%>
            <%--},--%>
            <%--dataType:"json",--%>
            <%--type:"post",--%>
            <%--success:function (data) {--%>
                <%--if(data.responCode == 0){--%>

                <%--}--%>
            <%--}--%>
        <%--});--%>

    <%--}--%>
</script>
<script type="text/html" id="barOption">
    <a class="layui-btn layui-btn-mini layui-btn-normal" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-mini layui-btn-normal" lay-event="deploy">部署</a>
    <a class="layui-btn layui-btn-mini layui-btn-danger" lay-event="del">删除</a>
</script>
<%@ include file="../footer.jsp" %>