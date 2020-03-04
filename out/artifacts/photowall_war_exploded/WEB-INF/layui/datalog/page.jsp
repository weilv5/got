<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>

<!-- 工具集 -->
<div class="my-btn-box">
            <span class="fl">
                <a class="layui-btn layui-btn-danger" id="btn-delete-all">批量删除</a>
            </span>
    <span class="fr">
                <button class="layui-btn mgl-20" id="searchBtn">查询</button>
            </span>
    <span class="fr">
                <span class="layui-form-label">操作者：</span>
                <div class="layui-input-inline">
                    <input type="text" id="operatorId" autocomplete="off" placeholder="请输入操作者ID" class="layui-input">
                </div>
            </span>
    <span class="fr">
                <span class="layui-form-label">操作类名：</span>
                <div class="layui-input-inline">
                    <input type="text" id="className" autocomplete="off" placeholder="请输入操作类名" class="layui-input">
                </div>
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

        function loadDatalog(){
            var where = {};
            if($("#operatorId").val()!=""){
                where.operatorId = $("#operatorId").val();
            }
            if($("#className").val()!=""){
                where.className = $("#className").val();
            }
            var tableIns = table.render({
                elem: '#moduleTable'
                ,height: 'full-65'
                , cols: [[
                    {checkbox: true,  fixed: true}
                    ,{field: 'createdDate', title: '操作日期', width: 170}
                    ,{field: 'operatorId', title: '操作者ID', width: 150}
                    ,{field: 'operatorIp', title: '操作者IP', width: 120}
                    ,{field: 'entityName', title: '操作实体名', width: 150}
                    ,{field: 'className', title: '操作类名', width: 220}
                    ,{field: 'entityChangeType', toolbar: '#opertype', title: '操作类型', width: 130}
                    , {fixed: 'right', title: '操作', width: 120, align: 'center', toolbar: '#barOption'}
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
        loadDatalog();







        table.on('tool(moduleTable)', function(obj){
            var data = obj.data
                ,layEvent = obj.event;
            if(layEvent == "detail"){
                openLayer("${ctxPath}/datalog/?method=view&id=" + data.id, "查看操作日志", "700px", "600px");
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
                                loadDatalog();
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
            alert("添加")
        });

        //查询
        $("#searchBtn").on('click', function(){
            loadDatalog();
        });
    });
</script>
<script type="text/html" id="opertype">
    {{#  if(d.entityChangeType == "CREATE" ){ }}
    新建
    {{#  } else if(d.entityChangeType == "UPDATE" ){ }}
    更新
    {{#  } else if(d.entityChangeType == "DELETE" ){ }}
    删除
    {{#  } else if(d.entityChangeType == "READ" ){ }}
    读取
    {{#  } else if(d.entityChangeType == "LOGIC_DEL" ){ }}
    逻辑删除
    {{#  } else { }}
    其他
    {{#  } }}
</script>
<script type="text/html" id="barOption">
    <a class="layui-btn layui-btn-mini" lay-event="detail">查看</a>
</script>
<%@include file="../footer.jsp"%>