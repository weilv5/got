<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>

        <!-- 工具集 -->
        <div class="my-btn-box">
            <span class="fl">
                <a class="layui-btn layui-btn-danger" id="btn-delete-all">批量删除</a>
                <a class="layui-btn btn-default btn-add" id="btn-add">添加</a>
            </span>
            <span class="fr">
                <span class="layui-form-label">分类：</span>
                <div class="layui-input-inline">
                    <input type="text" id="dictionaryCode" autocomplete="off" placeholder="请输入分类代码" class="layui-input">
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

        window.loadDic = function(){
            var where = {};
            if($("#dictionaryCode").val()!=""){
                where.dictionaryCode = $("#dictionaryCode").val();
            }
            var tableIns = table.render({
                elem: '#moduleTable'
                ,height: 'full-65'
                , cols: [[
                    {checkbox: true,  fixed: true}
                    , {field: 'dictionaryCode', title: '分类', width: 530, align: 'center'}
                    , {fixed: 'right', title: '操作', width: 500, align: 'center', toolbar: '#barOption'}
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
        loadDic();







        table.on('tool(moduleTable)', function(obj){
            var data = obj.data
                ,layEvent = obj.event;
            if(layEvent == "detail"){
                openLayer("${ctxPath}/dictionary/?method=view&id=" + data.id, "查看数据字典", "800px", "500px");
            }else if(layEvent == "edit"){
                openLayer("${ctxPath}/dictionary/?method=edit&id=" + data.id, "编辑数据字典", "700px", "500px");
            }else if(layEvent == "del"){
                parent.layui.layer.confirm("确定要删除选择的数据？", {icon: 3, title:'提示'}, function(index){
                    parent.layui.layer.close(index);
                    parent.layui.layer.load(3, {time: 1000});
                    $.ajax({
                        url: "./delete/" + data.id,
                        type: "post",
                        dataType: "json",
                        success: function (data) {
                            if(data.responseCode==0){
                                parent.layui.layer.msg("删除成功");
                                parent.getThisTabWindow().loadDic();
                            }else{
                                parent.layui.layer.msg(data.msg);
                            }
                        }
                    })

                });
            }
        });

        //批量删除
        $("#btn-delete-all").on('click', function () {
            var checkStatus = table.checkStatus('moduleTable');
            if(checkStatus.data.length==0){
                layer.msg("请选择需要删除的数据");
            }else{
                layer.confirm("确定要删除选择的数据？", {icon: 3, title: '提示'}, function (index) {
                    var ids = "";
                    for(var i=0; i<checkStatus.data.length; i++){
                        //ids.push(checkStatus.data[i].id);
                        ids = ids + checkStatus.data[i].id + ","
                    }
                    console.log(JSON.stringify(ids))
                    $.ajax({
                        url: "./delete",
                        type: "post",
                        data: {"ids" : ids},
                        dataType : 'json',
                        success: function (data) {
                            if (data.responseCode == 0) {
                                parent.layui.layer.msg("删除成功");
                                loadSensitive();
                            } else {
                                parent.layui.layer.msg(data.msg);
                            }
                        }
                    })
                    layer.close(index);
                })
            }
        });

        //添加
        $("#btn-add").on('click', function(){
            openLayer("${ctxPath}/dictionary/?method=edit", "添加数据字典", "600px", "400px");
        });

        //查询
        $("#searchBtn").on('click', function(){
            loadDic();
        });
    });
</script>
<script type="text/html" id="barOption">
    <a class="layui-btn layui-btn-mini" lay-event="detail">查看字典数据</a>
    <a class="layui-btn layui-btn-mini layui-btn-normal" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-mini layui-btn-danger" lay-event="del">删除</a>
</script>
<%@include file="../footer.jsp"%>