<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<div class="layui-fluid" style="padding: 3% 15%">
    <form class="layui-form layui-form-pane">
        <div class="layui-form-item">
            <label class="layui-form-label">操作日期：</label>
            <div class="layui-input-block">
                <input class="layui-input" id="createdDate" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">操作者ID：</label>
            <div class="layui-input-block">
                <input class="layui-input" id="operarorId" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">操作类型：</label>
            <div class="layui-input-block">
                <input class="layui-input" id="changeType" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">操作者IP：</label>
            <div class="layui-input-block">
                <input class="layui-input" id="operatorIp" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">操作实体名：</label>
            <div class="layui-input-block">
                <input class="layui-input" id="entityName" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">操作实体类名：</label>
            <div class="layui-input-block">
                <input class="layui-input" id="className1" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">操作前数据：</label>
            <div class="layui-input-block">
                <textarea rows="5" cols="50" class="layui-text" id="beforeChange" readonly ></textarea>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">操作后数据：</label>
            <div class="layui-input-block">
                <textarea rows="5" cols="50"  class="layui-text" id="afterChange" readonly ></textarea>
            </div>
        </div>
        <div class="layui-form-item" align="center">
            <button type="button" class="layui-btn layui-btn-primary" onclick="backToList()">返回</button>
        </div>
    </form>
</div>

<script>
    layui.use(['form', 'layer'], function () {
        var form = layui.form
            , layer = layui.layer
            , $ = layui.jquery;
        var id = "${id}";
        if (id === "")
            return;
        var dt = (new Date()).getTime();
        $.ajax({
            url: "./get/" + id,
            dataType: "json",
            type: "get",
            data: {
                dt: dt
            },
            success: function (log) {
                $("#className1").val(log.className);
                $("#beforeChange").val(log.beforeChange);
                $("#createdDate").val(log.createdDate);
                $("#afterChange").val(log.afterChange);
                $("#operarorId").val(log.operatorId);
                $("#operatorIp").val(log.operatorIp);
                $("#entityName").val(log.entityName);
                var opType = "";
                switch (log.entityChangeType){
                    case "CREATE":
                        opType = "新建";
                        break;
                    case "UPDATE":
                        opType = "更新";
                        break;
                    case "DELETE":
                        opType = "删除";
                        break;
                    case "READ":
                        opType = "读取";
                        break;
                    default:
                        opType = "未知";
                        break;
                }
                $("#changeType").val(opType);
            }
        });
    });

    function backToList() {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    }

</script>
<%@include file="../footer.jsp" %>

