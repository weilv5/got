<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../../header.jsp" %>
<div class="layui-fluid">
    <div class="layui-card">
        <form class="layui-form layui-card-header layuiadmin-card-header-auto">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">分类</label>
                    <div class="layui-input-inline">
                        <select id="photoSort" name="photoSort" class="form-select-button"></select>
                    </div>
                </div>
                <div class="layui-inline">
                    <button class="layui-btn layuiadmin-btn-list" lay-submit lay-filter="LAY-app-search">
                        <i class="layui-icon layui-icon-search layuiadmin-button-btn"></i>
                    </button>
                    <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                </div>
            </div>
        </form>
        <div class="layui-card-body">
            <div style="padding-bottom: 10px;">
                <button class="layui-btn layuiadmin-btn-list" lay-event="add" data-type="add"><i
                        class="layui-icon layui-icon-add-1"></i>添加
                </button>
                <button class="layui-btn layuiadmin-btn-list" lay-event="batchdel" data-type="batchdel">批量删除
                </button>
            </div>
            <table id="weddingPhotoTable" lay-filter="weddingPhotoTable"></table>
        </div>
    </div>
</div>

<script>

    layui.config({
        base: '${ctxPath}/resources/layuiadmin/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['index', 'form', 'table','laydate'], function () {
        var table = layui.table
                ,layer = layui.layer
                ,laydate = layui.laydate
                ,$ = layui.jquery
                , form = layui.form;

        loadDictionary("select", "photoSort", "DataDictionary", "photoSort", "", "single");
        function loadDictionary(type, fieldName, table, field, text, isGroup) {
            var dt = (new Date()).getTime();
            $.ajax({
                url: "${ctxPath}/getDictionary",
                type: "post",
                dataType: "json",
                data: {
                    dictTable: table,
                    dictCode: field,
                    dictText: text,
                    dt: dt
                },
                success: function (dictionary) {
                    if (type === "select") {
                        var length = dictionary.length;
                        $("#" + fieldName).append("<option value=''>全部</option>");
                        for (var i = 0; i < length; i++) {
                            $("#" + fieldName).append("<option value='" + dictionary[i].code + "'>" + dictionary[i].text + "</option>");
                            form.render();
                        }
                    }
                }
            });
        }

        table.render({
            elem: '#weddingPhotoTable'
            , cols: [[
                {checkbox: true, fixed: true}
                    , {
                        field: 'photo',
                        title: '结婚照',
                        width: 150,
                        templet: function(d) {
                            return '<img class="layui-upload-img" src="' + d.photo + '" width="100%">';
                        }
                    }
                    , {
                        field: 'photoSort',
                        title: '分类',
                        width: 150,
                        templet: function(d){
                            return d.photoSort.split("|")[3];
                    }}
                , {fixed: 'right', title: '操作', align: 'center', toolbar: '#barOption'}
            ]]
            , url: './layUIPage'
            , method: 'post'
            , page: true
            , request: {
                limitName: "size"
            }
            , limits: [30, 60, 90, 150, 300]
            , limit: 30
        });


        //监听搜索
        form.on('submit(LAY-app-search)', function (data) {
            var field = data.field;
            //执行重载
            table.reload('weddingPhotoTable', {
                where: field
            });
            return false;
        });

        //监听工具条
        table.on('tool(weddingPhotoTable)', function (obj) {
            var data = obj.data
                    , layEvent = obj.event;
            if (layEvent == "detail") {
                detail(data);
            } else if (layEvent == "edit") {
                add(data);
            } else if (layEvent == "del") {
                del(data);
            }
        });

        var $ = layui.$, active = {
            batchdel: batchdel,
            add: add
        };

        $('.layui-btn.layuiadmin-btn-list').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });

        function add(data) {
            url = "${ctxPath}/wedding/photo/edit";
            if (data) {
                url += "?id=" + data.id;
                openSubmitLayer(url, "编辑结婚照", '800px', '500px');
            }else {
                openSubmitLayer(url, "添加结婚照", '800px', '500px');
            }
        }

        function detail(data) {
            layer.open({
                type: 2,
                title: "查看树订单",
                maxmin: true,
                area: ["800px", "500px"],
                content: "${ctxPath}/wedding/photo/view?id=" + data.id
            });
        }

        function del(data) {
            layer.confirm('确定删除吗？', function (index) {
                $.ajax({
                    url: "./delete/" + data.id,
                    type: "post",
                    dataType: "json",
                    success: function (data) {
                        if (data.responseCode == 0) {
                            parent.layui.layer.msg("删除成功");
                            table.reload('weddingPhotoTable');
                        } else {
                            parent.layui.layer.msg(data.msg);
                        }
                    }
                })
                layer.close(index);
            });
        }

        function batchdel() {
            var checkStatus = table.checkStatus('weddingPhotoTable')
                    , checkData = checkStatus.data; //得到选中的数据
            if (checkData.length === 0) {
                return layer.msg('请选择数据');
            }
            layer.confirm('确定删除吗？', function (index) {
                var ids = "";
                for (var i = 0; i < checkStatus.data.length; i++) {
                    ids = ids + checkStatus.data[i].id + ","
                }
                $.ajax({
                    url: "./delete",
                    type: "post",
                    data: {"ids": ids},
                    dataType: 'json',
                    success: function (data) {
                        if (data.responseCode == 0) {
                            parent.layui.layer.msg("删除成功");
                            table.reload('weddingPhotoTable');
                        } else {
                            parent.layui.layer.msg(data.msg);
                        }
                    }
                })
                layer.close(index);
            });
        }

    });

</script>

<script type="text/html" id="barOption">
<%--    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="detail"><i--%>
<%--            class="layui-icon layui-icon-about"></i>查看</a>--%>
    <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="edit"><i
            class="layui-icon layui-icon-edit"></i>编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del"><i
            class="layui-icon layui-icon-delete"></i>删除</a>
</script>
<%@include file="../../footer.jsp" %>