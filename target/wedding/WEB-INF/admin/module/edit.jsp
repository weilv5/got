<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header_form.jsp" %>
<form class="layui-form" id="moduleForm" lay-filter="moduleForm" style="padding: 20px 30px 0 30px;">
    <input id="id" name="id" type="hidden">
    <input name="CSRFToken" type="hidden" value="${csrfToken}">
    <input id="moduleCode" name="moduleCode" type="hidden">
    <input id="parentModuleId" name="parentModuleId" value="${parentModule.id}" type="hidden">
    <input id="iconAddr" name="iconAddr" type="hidden">
    <div class="layui-form-item">
        <label class="layui-form-label">父模块：</label>
        <div class="layui-input-block">
            <input id="parentModuleName" name="parentModule.moduleName" value="${parentModule.moduleName}" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label"><span style="color:red">*</span>模块名称：</label>
        <div class="layui-input-block">
            <input id="moduleName" name="moduleName"  class="layui-input" lay-verify="required|moduleName">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">模块地址：</label>
        <div class="layui-input-block">
            <input id="moduleAddr" name="moduleAddr" class="layui-input">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label"><span style="color:red">*</span>模块序号：</label>
        <div class="layui-input-block">
            <input id="sortSq" name="sortSq" class="layui-input" lay-verify="required|sortSq">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">模块图标：</label>
        <div class="layui-input-block">
            <i id="icon" class="layui-icon" style="font-size: 25px; color: #1E9FFF;"
               onclick="pop();">&#xe607;</i>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label"><span style="color:red">*</span>是否可见：</label>
        <div class="layui-input-block">
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
        <label class="layui-form-label"><span style="color:red">*</span>是否公开：</label>
        <div class="layui-input-block">
            <select id="isPublic"
                    name="isPublic"
                    type="text"
                    class="form-select-button" lay-filter="isPublic">
                <option value="1">是</option>
                <option value="0">否</option>
            </select>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label"><span style="color:red">*</span>目标：</label>
        <div class="layui-input-block">
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
        <label class="layui-form-label"><span style="color:red">*</span>是否严格校验URL：</label>
        <div class="layui-input-block">
            <select id="stick"
                    name="stick"
                    type="text"
                    class="form-select-button">
                <option value="0">否</option>
                <option value="1">是</option>
            </select>
        </div>
    </div>
    <div class="layui-form-item layui-hide">
        <input type="button" lay-submit lay-filter="layuiadmin-app-form-submit" id="layuiadmin-app-form-submit" value="提交">
    </div>
</form>

<script>
    layui.use(['layer', 'form'], function () {
        var layer = layui.layer
            , form = layui.form
            , $ = layui.jquery;
        window.parentModuleId = "";
        window.parentModuleName = "";
        $("#parentModuleName").on('click', function () {
            layer.open({
                type: 2,
                title: '选择父模块',
                area: ['350px', '400px'],
                btn: '确认',
                content: '${ctxPath}/module/?method=moduleSelect',
                yes: function (index, layero) {
                    //确认按钮回调
                    if(window.parentModuleId === id){
                        parent.layui.layer.msg("父模块不能与当前模块重复！");
                    }else {
                        $("#parentModuleId").val(window.parentModuleId);
                        $("#parentModuleName").val(window.parentModuleName);
                        layer.close(index);
                    }
                },
                cancel: function (index, layero) {
                    layer.close(index);
                    return false;
                }
            });
        });

        //字段自定义验证
        form.verify({
            moduleName:[/^([\u4E00-\u9FA5A-Za-z0-9]){0,10}$/, '必须是长度小于10的字符'],
            sortSq:[/^(?:[1-9][0-9]?)$/, '模块序号只能是大于0小于100的正整数！']

        });

        form.on('submit(layuiadmin-app-form-submit)', function (data) {
                <c:if test="${empty module.id}">var url = "./save";
            </c:if>
                <c:if test="${not empty module.id}">var url = "./update";
            </c:if>

            var parentModuleName = $("#parentModuleName").val();
            if(parentModuleName.length === 0){
                $("#parentModuleId").val("");
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
                            parent.layui.table.reload('moduleTable'); //重载表格
                            parent.reloadTree();
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


        var id = "${module.id}";
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
                    form.val("moduleForm", data);
                    if (data.parentModule)
                        $("#parentModuleName").val(data.parentModule.moduleName);
                    form.render();
                }
            });
        }


    });


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
<script type="text/javascript" src="${ctxPath}/resources/js/jquery.js"></script>
<script type="text/javascript" src="${ctxPath}/resources/js/jquery.form.min.js"></script>
<%@include file="../footer.jsp" %>