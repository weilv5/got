<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<div class="layui-fluid" style="padding: 20px;">
    <!-- table -->
    <div id="deptTable" lay-filter="deptTable"></div>
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

        function loadDept(){
            var where = {};
            where['role.id'] = roleId;

            var tableIns = table.render({
                elem: '#deptTable'
                ,height: 'full-70'
                , cols: [[
                    {field: 'deptName', title: '部门名称', width: 120}
                    , {field: 'deptCode', title: '部门编码', width: 100}
                    , {fixed: 'right', title: '操作', width: 120, align: 'center', toolbar: '#barOption'}
                ]]
                , url: '${ctxPath}/dept/page'
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

        loadDept();
        table.on('tool(deptTable)', function(obj){
            var data = obj.data
                ,layEvent = obj.event;
            if(layEvent == "detail"){
                openLayer("${ctxPath}/dept/?method=view&id="+data.id,"查看详情","600px","400px")
            }
        });
    });
</script>
<script type="text/html" id="barOption">
    <a class="layui-btn layui-btn-mini" lay-event="detail">查看</a>
</script>

<%@include file="../footer.jsp"%>