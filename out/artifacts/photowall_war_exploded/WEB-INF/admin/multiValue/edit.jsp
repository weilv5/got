<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header_form.jsp" %>
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.core.js"></script>
<link rel="stylesheet" href="${ctxPath}/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<form class="layui-form layui-form-pane" action="" id="departmentForm" lay-filter="deptForm" style="padding: 20px 30px 0 30px;">
    <input id="id" name="id" type="hidden">
    <input name="CSRFToken" type="hidden" value="${CSRFToken}">
    <input id="codeId" name="codeId" type="hidden">

    <input id="parentItemId" name="parentItemId" type="hidden">
    <div class="layui-form-item">
        <label class="layui-form-label">显示值<label style="color:red;">*</label></label>
        <div class="layui-input-block">
            <input class="layui-input" type="text" name="codeName" id="codeName" lay-verify="required|codeName"/>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">代码项值<label style="color:red;">*</label></label>
        <div class="layui-input-block">
            <input class="layui-input" type="text" id="itemValue" name="itemValue" lay-verify="required|itemValue"/>
        </div>
    </div>

    <div class="layui-form-item">
        <label class="layui-form-label">排序</label>
        <div class="layui-input-block">
            <input class="layui-input" type="text" name="sortSq" id="sortSq" lay-verify="sortSq"/>
        </div>
    </div>

    <div class="layui-form-item layui-hide">
        <input type="button" lay-submit lay-filter="layuiadmin-app-form-submit" id="layuiadmin-app-form-submit" value="提交">
    </div>
</form>
<script>
    layui.config({
        base: '${ctxPath}/resources/layuiadmin/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['tree', 'index', 'form', 'table', 'layer'], function () {
        var table = layui.table
            , form = layui.form
            , $ = layui.jquery;

        var id = "${id}";
        var pId = "";

        if (id !== "") {
            editMultiValue();
        }

        //根据id获取用户详情
        function editMultiValue() {
            var dt = (new Date()).getTime();
            $.ajax({
                url: "${ctxPath}/multiValue/get/" + id,
                dataType: "json",
                type: "get",
                data: {
                    dt: dt
                },
                success: function (data) {

                    $("#id").val(data.id);
                    $("#codeId").val(data.codeId);
                    pId = data.codeId;
                    $("#itemValue").val(data.itemValue);
                    $("#codeName").val(data.codeName);
                    $("#parentItemId").val(data.parentItemId);

                    if(data.sortSq)
                        $("#sortSq").val(data.sortSq);

                    form.render();
                },
                error: function () {
                    //获取多维代码失败
                }
            });
        }

        //字段自定义验证
        form.verify({
            codeName:[/^([\u4E00-\u9FA5A-Za-z0-9]){0,10}$/, '必须是长度小于10的字符'],
            itemValue:[/^([\u4E00-\u9FA5A-Za-z0-9]){0,10}$/, '必须是长度小于10的字符'],
            sortSq: function (value) {
                if (value<1 || value >99) {
                    return '排序必须1到99位';
                }else if(isNaN(value)){
                    return '排序必须为整数';
                }
            }
        });

        //新增、编辑

        //监听提交
        form.on('submit(layuiadmin-app-form-submit)', function (e) {
                <c:if test="${empty id}">var url = "./save";
            </c:if>
                <c:if test="${not empty id}">var url = "./update";
            </c:if>

            $("#departmentForm").ajaxSubmit({
                type: "post",
                url: url,
                dataType: "json",
                beforeSubmit: function (arr) {
                    var length = arr.length;
                    for (var i = 0; i < length; i++) {
                        if (arr[i].name === "parentItemId" && arr[i].value === "") {
                            arr.splice(i, 1);//删除i位置元素
                            break;
                        }
                    }


                    return true;
                },
                success: function (data) {
                    if (data.responseCode == 0) {
                        //提交成功
                        parent.layui.layer.msg("提交成功");
                        var index = parent.layer.getFrameIndex(window.name);
                        parent.layer.close(index);
                        parent.layui.table.reload('multiValueTable'); //重载表格
                        parent.reloadMultiValueTree();

                    } else {
                        parent.layui.layer.msg(data.msg);

                    }

                },
                error: function () {
                    alert("error!");
                }
            });
            return false;
        });

    });


    function backToList() {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    }

</script>
<script type="text/javascript" src="${ctxPath}/resources/js/jquery.js"></script>
<script type="text/javascript" src="${ctxPath}/resources/js/jquery.form.min.js"></script>

<%@include file="../footer.jsp" %>
