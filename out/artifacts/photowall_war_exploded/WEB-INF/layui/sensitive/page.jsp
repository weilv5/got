<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>

<!-- 工具集 -->
<div class="my-btn-box">
    <form id="importForm">
        <input type="file" id="sensitiveWords" name="sensitiveWords" accept="text/plain" style="display:none"
               onchange="importWords()">
    </form>
    <span class="fl">
                <a class="layui-btn layui-btn-danger" id="btn-delete-all">批量删除</a>
                 <a class="layui-btn btn-default btn-add" id="btn-add">添加</a>
                   <a class="layui-btn btn-default btn-add" id="btn-sync">同步</a>
                   <a class="layui-btn btn-default btn-add" id="btn-import">导入</a>
            </span>
    <span class="fr">
                <span class="layui-form-label">敏感词：</span>
                <div class="layui-input-inline">
                    <input type="text" id="words" autocomplete="off" placeholder="请输入敏感词" class="layui-input">
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

        window.loadSensitive = function() {
            var where = {};
            if ($("#words").val() != "") {
                where.words = $("#words").val();
            }
            var tableIns = table.render({
                elem: '#moduleTable'
                , height: 'full-65'
                , cols: [[
                    {checkbox: true, fixed: true}
                    , {field: 'words', title: '敏感词', width: 930, align: 'center'}
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

        loadSensitive();

        table.on('tool(moduleTable)', function (obj) {
            var data = obj.data
                , layEvent = obj.event;
            if (layEvent == "detail") {
                alert("detail");
            } else if (layEvent == "edit") {
                alert("edit");
            } else if (layEvent == "del") {
                alert("del");
            }
        });

        //批量删除
        $("#btn-delete-all").on('click', function () {
            var checkStatus = table.checkStatus('moduleTable');
            if (checkStatus.data.length == 0) {
                layer.msg("请选择需要删除的数据");
            } else {
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
        $("#btn-add").on('click', function () {
            openLayer("${ctxPath}/sensitive/?method=edit", "添加敏感词", "600px", "200px");
        });

        //查询
        $("#searchBtn").on('click', function () {
            loadSensitive();
        });
        //导入
        $("#btn-import").on('click', function () {
            document.getElementById("sensitiveWords").click();
        });

        $("#btn-sync").on('click', function () {
            parent.layui.layer.confirm("确定同步数据？", {icon: 3, title: '提示'}, function (index) {
                var loadindex = parent.layui.layer.load(3, {time: 100 * 1000});
                $.ajax({
                    type: "post",
                    url: "./sync",
                    success: function (data) {
                        parent.layui.layer.msg(data.msg);
                        parent.layui.layer.close(loadindex);
                        parent.layui.layer.close(index);
                    }
                })

            });
        });

    })
    function importWords() {
        var loadindex = parent.layui.layer.load(3, {time: 100 * 1000});
        $("#importForm").ajaxSubmit({
            type: "post",
            url: "./import",
            success: function (data) {
                parent.layui.layer.msg(data.msg);
                parent.layui.layer.close(loadindex);
            }
        })
    }
</script>
<%@include file="../footer.jsp" %>