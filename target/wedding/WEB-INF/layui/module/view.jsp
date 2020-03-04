<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<div class="layui-fluid" style="padding: 3% 15%">
    <form class="layui-form layui-form-pane">
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 180px">父模块：</label>
            <div class="layui-input-block" style="margin-left: 180px">
                <input class="layui-input" id="parentModeluId" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 180px">模块名称：</label>
            <div class="layui-input-block" style="margin-left: 180px">
                <input class="layui-input" id="moduleName" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 180px">模块编码：</label>
            <div class="layui-input-block" style="margin-left: 180px">
                <input class="layui-input" id="moduleCode" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 180px">模块地址：</label>
            <div class="layui-input-block" style="margin-left: 180px">
                <input class="layui-input" id="moduleAddr" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 180px">模块图标：</label>
            <div class="layui-input-block" style="margin-left: 180px">
                <div id="iconAddr" class="layui-input-inline"></div>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 180px">模块序号：</label>
            <div class="layui-input-block" style="margin-left: 180px">
                <input class="layui-input" id="sortSq" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 180px">是否可见：</label>
            <div class="layui-input-block" style="margin-left: 180px">
                <input class="layui-input" id="isVisible" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 180px">是否公开：</label>
            <div class="layui-input-block" style="margin-left: 180px">
                <input class="layui-input" id="isPublic" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 180px">目标：</label>
            <div class="layui-input-block" style="margin-left: 180px">
                <input class="layui-input" id="target" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 180px">是否严格校验URL：</label>
            <div class="layui-input-block" style="margin-left: 180px">
                <input class="layui-input" id="stick" readonly>
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
            success: function (data) {
                $("#id").val(data.id);
                $("#moduleAddr").val(data.moduleAddr);
                if (data.sortSq)
                    $("#sortSq").val(data.sortSq);
                $("#createrUserId").val(data.createrUserId);
                if (data.isVisible == 0)
                    $("#isVisible").val("否");
                else
                    $("#isVisible").val("是");
                if (data.parentModule)
                    $("#parentModeluId").val(data.parentModule.moduleName);
                if (data.isPublic == 1)
                    $("#isPublic").val("是");
                else
                    $("#isPublic").val("否");
                if (data.stick == 1)
                    $("#stick").val("是");
                else
                    $("#stick").val("否");
                if (data.iconAddr)
                    $("#iconAddr").html("<i class=\"layui-icon\" style=\"font-size: 25px; color: #1E9FFF; margin-left: 8px\">" + data.iconAddr + "</i>");
                $("#updateUserId").val(data.updateUserId);
                if (data.target === "_self")
                    $("#target").val("本窗口");
                else
                    $("#target").val("新窗口");
                $("#moduleCode").val(data.moduleCode);
                $("#moduleName").val(data.moduleName);

                var length = data.roleList.length;
                for (var i = 0; i < length; i++) {
                    var roleSpan = $("<div id='" + data.roleList[i].id + "'>" + data.roleList[i].roleName + "</div>");
                    $("#roleNames").append(roleSpan);
                }
            }
        });
    });

    function backToList() {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    }
</script>
<%@include file="../footer.jsp" %>