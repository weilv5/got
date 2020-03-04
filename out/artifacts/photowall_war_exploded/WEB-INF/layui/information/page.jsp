<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>

<!-- 工具集 -->
<div class="my-btn-box">
            <span class="fl">
                <a class="layui-btn layui-btn-danger" id="btn-delete-all">批量删除</a>
                <a class="layui-btn btn-default btn-add" id="btn-add">添加</a>
            </span>
    <span class="fr">
                <span class="layui-form-label">标题：</span>
                <div class="layui-input-inline">
                    <input type="text" id="title" autocomplete="off" placeholder="请输入标题" class="layui-input">
                </div>
                <button class="layui-btn mgl-20" id="searchBtn">查询</button>
            </span>
</div>
<!-- table -->
<div id="moduleTable" lay-filter="moduleTable"></div>


<script>
    // layui方法
    layui.use(['table', 'form', 'layer'], function () {
        // 操作对象
        var form = layui.form
            , table = layui.table
            , layer = layui.layer
            , $ = layui.jquery;

        function loadInfo(){
            var where = {};
            if($("#dictionaryCode").val()!=""){
                where.dictionaryCode = $("#dictionaryCode").val();
            }
            var tableIns = table.render({
                elem: '#moduleTable'
                ,height: 'full-65'
                , cols: [[
                    {checkbox: true,  fixed: true}
                    , {field: 'releasedDate', title: '分类', width: 250, align: 'center'}
                    , {field: 'title', title: '标题', width: 450, align: 'center'}
                    , {field: 'infoType', title: '信息类别', width: 150, align: 'center',templet: function(d){
                            return d.infoType.split("|")[3];
                        }}
                    , {field: 'name', title: '发布者', width: 150, align: 'center'}
                ]]
                , url: './page'
                , method: 'post'
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
                , where: where
            });
        }
        loadInfo();







        table.on('tool(moduleTable)', function(obj){
            var data = obj.data
                ,layEvent = obj.event;
            if(layEvent == "detail"){
                alert("detail");
            }else if(layEvent == "edit"){
                alert("edit");
            }else if(layEvent == "del"){
                alert("del");
            }
        });

        //批量删除
        $("#btn-delete-all").on('click', function () {
            var checkStatus = table.checkStatus('moduleTable');
            if(checkStatus.data.length==0){
                layer.msg("请选择需要删除的数据");
            }else{
                layer.confirm("确定要删除选择的数据？", {icon: 3, title:'提示'}, function(index){
                    //do something
                    alert("批量删除")
                    layer.close(index);
                })
            }
        });

        //添加
        $("#btn-add").on('click', function(){
            openLayer("${ctxPath}/information/?method=edit", "添加信息", "1000px", "600px");
        });

        //查询
        $("#searchBtn").on('click', function(){
            loadInfo();
        });
    });
</script>
<script type="text/html" id="barOption">
    <a class="layui-btn layui-btn-mini" lay-event="detail">查看字典数据</a>
</script>
<%@include file="../footer.jsp"%>