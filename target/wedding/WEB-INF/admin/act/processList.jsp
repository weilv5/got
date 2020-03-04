<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<div class="layui-fluid">
    <div class="layui-card">
       <form class="layui-form layui-card-header layuiadmin-card-header-auto">
            <div class="layui-form-item">
                <div class="layui-inline">
                    <label class="layui-form-label">流程定义key</label>
                    <div class="layui-input-inline">
                        <input type="text" id="keyLike" name="keyLike" autocomplete="off"
                               placeholder="请输入流程编号" class="layui-input">
                    </div>
                </div>
                <div class="layui-inline">
                    <label class="layui-form-label" style="width: 100px;">流程定义名称</label>
                    <div class="layui-input-inline">
                        <input type="text" id="nameLike" name="nameLike" autocomplete="off"
                               placeholder="请输入流程名称" class="layui-input">
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
                <button class="layui-btn layuiadmin-btn-list" lay-event="doDeploy" data-type="doDeploy">部署流程</button>
                <%--<button class="layui-btn layuiadmin-btn-list" lay-event="batchdel" data-type="batchdel">批量删除</button>--%>
            </div>
            <table id="processTable" lay-filter="processTable"></table>
        </div>
    </div>
</div>
<script>

    layui.config({
        base: '${ctxPath}/resources/layuiadmin/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['index', 'form', 'table'], function () {
        var table = layui.table
            , form = layui.form
            , $ = layui.jquery;

            window.taskTable = table.render({
                elem: '#processTable'
                , cols: [[
                    {checkbox: true, fixed: true},
                    {field: 'id', title: '流程定义编号', width: 180,sort:true,align:'center'},
                    {field: 'deploymentId', title: '部署编号', width: 120,sort:true,align:'center'},
                    {field: 'name', title: '流程定义名称', width: 150,sort:true,align:'center'},
                    {field: 'key', title: '流程定义key', width: 150,sort:true,align:'center'},
                    /*{field: 'version', title: '版本号', width: 100,sort:true,align:'center'},*/
                    {
                        field: 'isSuspended', title: '挂起状态', width: 100,align:'center', templet: function (d) {
                        if (d.suspended) {
                            return "是";
                        } else {
                            return "否";
                        }
                    }
                    },
                    {
                        fixed: 'right', title: '操作', align: 'center', templet: function (d) {
                        var restr = "<a class='layui-btn layui-btn-normal layui-btn-xs' onclick=\"view('" + d.id + "')\"><i\n" +
                            "            class=\"layui-icon layui-icon-about\"></i>查看</a>"+"<a class='layui-btn layui-btn-normal layui-btn-xs' onclick=\"convert('" + d.id + "')\"><i\n" +
                            "                    class=\"layui-icon layui-icon-play\"></i>转成模型</a>" +
                            "&nbsp;<a class='layui-btn layui-btn-danger layui-btn-xs' onclick=\"delProcess('" + d.deploymentId + "')\"><i\n" +
                            "                    class=\"layui-icon layui-icon-delete\"></i>删除</a>";
                        if (d.suspended) {
                            return "<a class='layui-btn layui-btn-danger layui-btn-xs' onclick=\"activateProcessDefinition('" + d.id + "')\"><i\n" +
                                "class=\"layui-icon layui-icon-pause\"></i>激活</a>" +restr;
                        } else {
                            return "<a class='layui-btn layui-btn-normal layui-btn-xs' onclick=\"suspendProcessDefinition('" + d.id + "')\"><i\n" +
                                "class=\"layui-icon layui-icon-play\"></i>挂起</a>" +restr;
                        }
                    }
                    }
                ]]
                , url: '${ctxPath}/activiti/api/procDef'
                , method: 'get'
                , page: true
                , request: {
                    limitName: "size"
                }
                , response: {
                    countName: "total",
                    dataName: "dataList"
                }
                , limits: [30, 60, 90, 150, 300]
                , limit: 30
            });

        var active = {
            doDeploy: doDeploy,
            batchdel: batchdel
        };
        //监听搜索
        form.on('submit(LAY-app-search)', function (data) {
            var field = data.field;
            //执行重载
            table.reload('processTable', {
                where: field
            });
            return false;
        });

        $('.layui-btn.layuiadmin-btn-list').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });

        function doDeploy() {
            layer.open({
                type: 2,
                title: "部署流程",
                maxmin: true,
                area: ["540px", "250px"],
                content: "${ctxPath}/activiti/api/procDef/doDeploy"
            });
        }


        function batchdel() {
            var checkStatus = table.checkStatus('processTable')
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
                        if (data.code == 0) {
                            parent.layui.layer.msg("删除成功");
                            table.reload('processTable');
                        } else {
                            parent.layui.layer.msg(data.msg);
                        }
                    }
                });
                layer.close(index);
            });
        }
    })

</script>

<script>
    function view(id){
        layer.open({
            type: 2,
            title: "流程定义详情(编号："+id+")",
            maxmin: true,
            area: ["600px", "450px"],
            content: "${ctxPath}/activiti/api/procDef/toProcDefView/"+id
        });

    }
    //转成模型
    function convert(id){
        $.ajax({
            //url: "./processdefinition/update/" + state + "/" + id,
            url:"${ctxPath}/activiti/api/procDef/convert/" + id,
            type: 'post',
            dataType: 'json',
            async: false,
            success: function (data) {
                if (data.code == 0) {
                    parent.layui.layer.msg("流程定义转换为模型成功！");
                    taskTable.reload('processTable');
                } else {
                    parent.layui.layer.msg("流程定义转换为模型出错" + data.msg);
                }
            },
            error: function (data) {
                parent.layui.layer.msg("error:" + data.msg);
                taskTable.reload('processTable');
            }
        });
    }
    //激活
    function activateProcessDefinition(id) {
        parent.layui.layer.confirm("确定要激活该流程定义？", {icon: 3, title: '激活流程定义'}, function (index) {
            parent.layui.layer.close(index);
            parent.layui.layer.load(3, {time: 1000});
            var state = "activate";
            $.ajax({
                //url: "./processdefinition/update/" + state + "/" + id,
                url:"${ctxPath}/activiti/api/procDef/" + id,
                type: 'post',
                dataType: 'json',
                data:{
                    _method:"PUT",
                    action: state,
                    isIncludeProcIns:false
                },
                async: false,
                success: function (data) {
                    if (data.code == 0) {
                        parent.layui.layer.msg("流程定义激活成功！");
                        taskTable.reload('processTable');
                    } else {
                        parent.layui.layer.msg("流程定义激活出错" + data.msg);
                    }
                },
                error: function (data) {
                    parent.layui.layer.msg("error:" + data.msg);
                    taskTable.reload('processTable');
                }
            });
        });


    }

    //挂起
    function suspendProcessDefinition(id) {
        parent.layui.layer.confirm("确定要挂起该流程（挂起后这个流程定义不能再创建流程实例）？", {icon: 3, title: '挂起流程定义'}, function (index) {
            parent.layui.layer.close(index);
            parent.layui.layer.load(3, {time: 1000});
            var state = "suspend";
            $.ajax({
                url:"${ctxPath}/activiti/api/procDef/" + id,
                type: 'post',
                dataType: 'json',
                async: false,
                data:{
                    _method:"PUT",
                    action: state,
                    isIncludeProcIns:false
                },
                success: function (data) {
                    if (data.code == 0) {
                        parent.layui.layer.msg("流程定义挂起成功！");
                        taskTable.reload('processTable');
                    } else {
                        parent.layui.layer.msg("流程定义挂起出错" + data.msg);
                    }
                },
                error: function (data) {
                    parent.layui.layer.msg("error:" + data.msg);
                    taskTable.reload('processTable');
                }

            });
        });

    }

    function delProcess(id) {
        parent.layui.layer.confirm("确定删除选中的流程定义？", {icon: 3, title: "提示"}, function (index) {
            parent.layui.layer.close(index);
            parent.layui.layer.load(3, {time: 1000});
            $.ajax({
                url: "${ctxPath}/activiti/api/procDef/delete?deploymentId=" + id,
                type: "post",
                dataType: "json",
                success: function (data) {
                    if (data.code == 0) {
                        parent.layui.layer.msg("刪除流程定义成功");
                        taskTable.reload('processTable');
                    }
                    else {
                        parent.layui.layer.msg("删除流程定义出错" + data.msg);
                    }
                },
                error: function (data) {
                    parent.layui.layer.msg("error:" + data.msg);
                    taskTable.reload('processTable');
                }

            });
        });
    }


</script>
<script type="text/javascript" src="${ctxPath}/resources/js/jquery.js"></script>
<%@include file="../footer.jsp" %>