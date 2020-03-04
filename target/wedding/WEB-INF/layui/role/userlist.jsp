<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
    <div class="layui-fluid" style="padding: 20px;">
        <!-- table -->
        <div id="userTable" lay-filter="userTable"></div>
    </div>

<script>
    // layui方法
    layui.use(['tree', 'table', 'form', 'layer'], function () {
        var roleId = parent.id;
        var form = layui.form
            , table = layui.table
            , layer = layui.layer
            , tree = layui.tree
            , $ = layui.jquery;

        function loadUser(){
            var where = {};
                where['role.id'] = roleId;

            var tableIns = table.render({
                elem: '#userTable'
                ,height: 'full-70'
                , cols: [[
                    {field: 'name', title: '姓名', width: 120}
                    , {field: 'gender', title: '性别', width: 60,templet: function(d){
                        var info = d.gender.split("|");
                        return info[info.length - 1];
                    }},{field: 'userId', title: '用户名', width: 120},
                    {fixed: 'right', title: '操作', width: 120, align: 'center', toolbar: '#barOption'}
                ]]
                , url: '${ctxPath}/user/page'
                , method: 'post'
                , page: true
                , request: {
                    limitName: "size"
                }
                , response: {
                    countName: "totalElements",
                    dataName: "content"
                }
                , limits: [10, 20, 30, 60, 120]
                , limit: 10
                , where: where
            });
        }

        loadUser();
        table.on('tool(userTable)', function(obj){
            var data = obj.data
                ,layEvent = obj.event;
            if(layEvent == "detail"){
                openLayer("${ctxPath}/user/?method=view&id="+data.id,"查看详情","600px","400px")
            }
        });
    });
</script>
<script type="text/html" id="barOption">
    <a class="layui-btn layui-btn-mini" lay-event="detail">查看</a>
</script>
<%@include file="../footer.jsp"%>