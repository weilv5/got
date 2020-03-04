<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>

<div class="layui-fluid" style="padding: 20px 15%;">
    <form class="layui-form layui-form-pane" id="moduleForm" lay-filter="moduleForm">
        <input id="id" name="id" type="hidden">
        <input name="CSRFToken" type="hidden" value="${CSRFToken}">
        <input id="moduleCode" name="moduleCode" type="hidden">
        <input id="parentModuleId" name="parentModuleId" type="hidden">
        <input id="iconAddr" name="iconAddr" type="hidden">
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 180px">父模块：</label>
            <div class="layui-input-block" style="margin-left: 180px">
                <input id="parentModuleName" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 180px"><span style="color:red">*</span>模块名称：</label>
            <div class="layui-input-block" style="margin-left: 180px">
                <input id="moduleName" name="moduleName" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 180px">模块地址：</label>
            <div class="layui-input-block" style="margin-left: 180px">
                <input id="moduleAddr" name="moduleAddr" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 180px"><span style="color:red">*</span>模块序号：</label>
            <div class="layui-input-block" style="margin-left: 180px">
                <input id="sortSq" name="sortSq" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 180px">模块图标：</label>
            <div class="layui-input-block" style="margin-left: 180px">
                <i id="icon" class="layui-icon" style="font-size: 25px; color: #1E9FFF;"
                   onclick="pop();">&#xe607;</i>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 180px"><span style="color:red">*</span>是否可见：</label>
            <div class="layui-input-block" style="margin-left: 180px">
                <select id="isVisible"
                        name="isVisible"
                        type="text"
                        class="layui-select">
                    <option value="1">是</option>
                    <option value="0">否</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 180px"><span style="color:red">*</span>是否公开：</label>
            <div class="layui-input-block" style="margin-left: 180px">
                <select id="isPublic"
                        name="isPublic"
                        type="text"
                        class="form-select-button" lay-filter="isPublic">
                    <option value="0">否</option>
                    <option value="1">是</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 180px"><span style="color:red">*</span>目标：</label>
            <div class="layui-input-block" style="margin-left: 180px">
                <select id="target"
                        name="target"
                        type="text"
                        class="form-select-button">
                    <option value="_self">本窗口</option>
                    <option value="_blank">新窗口</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label" style="width: 180px"><span style="color:red">*</span>是否严格校验URL：</label>
            <div class="layui-input-block" style="margin-left: 180px">
                <select id="stick"
                        name="stick"
                        type="text"
                        class="form-select-button">
                    <option value="0">否</option>
                    <option value="1">是</option>
                </select>
            </div>
        </div>


        <div class="layui-form-item" align="center">
            <button class="layui-btn" lay-submit lay-filter="*">提交</button>
            <button type="button" class="layui-btn layui-btn-primary" onclick="backToList()">返回</button>
        </div>
    </form>
</div>

<script>

    var pModuleName;

    layui.use(['layer', 'form'], function () {
        var layer = layui.layer
            , form = layui.form
            , $ = layui.jquery;
        $("#parentModuleName").on('click', function () {
            layer.open({
                type: 2,
                title: '选择父模块',
                area: ['350px', '450px'],
                btn: '确认',
                content: '${ctxPath}/module/?method=moduleSelect',
                yes: function (index, layero) {
                    //确认按钮回调
                    $("#parentModuleId").val(window.parentModuleId);
                    $("#parentModuleName").val(window.pModuleName);
                    layer.close(index);
                },
                cancel: function (index, layero) {
                    layer.close(index);
                    return false;
                }
            });
        });

        //字段自定义验证
        form.verify({
            sort: function (value) {
                if (value.length <= 0 || value.length >= 100) {
                    return '排序必须大于0，小于100';
                }
            }

        });

        form.on('submit(moduleForm)', function (e) {
                <c:if test="${empty id}">var url = "./save";
            </c:if>
                <c:if test="${not empty id}">var url = "./update";
            </c:if>

            var length = window.roleIdArr.length;
            for (var i = 0; i < length; i++) {
                var roleIdInput = $("<input type='hidden' name='roleList[" + i + "].id' value='" + window.roleIdArr[i] + "'>");
                $("#moduleForm").append(roleIdInput);
            }

            $("#moduleForm").ajaxSubmit({
                type: "post",
                url: url,
                dataType: "json",
                beforeSubmit: function (arr) {
                    var length = arr.length;
                    for (var i = 0; i < length; i++) {
                        if (arr[i].name === "parentModuleId" && arr[i].value === "") {
                            arr.splice(i, 1);
                            break;
                        }
                    }
                    return true;
                },
                success: function (data) {
                    if (data.responseCode == 0) {
                        layer.msg("提交成功", {time: 2000}, function () {
                            var index = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(index);
                            parent.getThisTabWindow().loadModule();

                        });
                    } else {
                        layer.msg(data.msg);
                    }
                },
                error: function () {
                    alert("error!");
                }
            });
            return false;
        });


        var id = "${id}";
        if (id != "") {
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
                    $("#sortSq").val(data.sortSq)
                    $("#moduleCode").val(data.moduleCode);
                    $("#moduleName").val(data.moduleName);
                    if (data.parentModule)
                        $("#parentModuleName").val(data.parentModule.moduleName);
                    $("#parentModuleId").val(data.parentModuleId);
                    $("#createrUserId").text(data.createrUserId);
                    $("#isVisible").val(data.isVisible);
                    $("#isPublic").val(data.isPublic);
                    $("#target").val(data.target);
                    $("#stick").val(data.stick);
                    if (data.parentModule)
                        $("#parentModeluId").text(data.parentModule.moduleName);
                    if (data.iconAddr) {
                        $("#iconAddr").val(data.iconAddr);
                        $("#icon").text(data.iconAddr);
                    }
                    $("#updateUserId").text(data.updateUserId);
                    form.render();


                }
            });
        }


    });

    window.roleIdArr = [];

    function pop() {

        layer.open({
            type: 2,
            title: '图标',
            maxmin: true,
            area: ['550px', '400px'],
            content: '${ctxPath}/resources/icons.html',
            zIndex: layui.layer.zIndex,
            success: function (index, layero) {
                console.log(index);
            }
        });


    }

    function backToList() {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    }

</script>
<%@include file="../footer.jsp" %>