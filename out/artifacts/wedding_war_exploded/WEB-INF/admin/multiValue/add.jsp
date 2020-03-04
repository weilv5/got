<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header_form.jsp" %>
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.core.js"></script>
<link rel="stylesheet" href="${ctxPath}/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<form class="layui-form layui-form-pane" action="" id="multiValueForm" lay-filter="deptForm" style="padding: 20px 30px 0 30px;">
    <input id="id" name="id" type="hidden">
    <input name="CSRFToken" type="hidden" value="${CSRFToken}">
    <input id="codeId" name="codeId" type="hidden">

    <input id="parentItemId" name="parentItemId" type="hidden">
    <div class="layui-form-item">
        <label class="layui-form-label">显示值<label style="color:red;">*</label></label>
        <div class="layui-input-block">
            <input class="layui-input" type="text" name="codeName" id="codeName" lay-verify="required|codeName" placeholder="请输入显示值"/>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">代码项值<label style="color:red;">*</label></label>
        <div class="layui-input-block">
            <input class="layui-input" type="text" id="itemValue" name="itemValue" lay-verify="required|itemValue" placeholder="请输入代码项值"/>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">上层代码</label>
        <div class="layui-input-block">
            <input class="layui-input" type="text" name="pcodeName" id="pcodeName" placeholder="请选择上层代码"/>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">排序</label>
        <div class="layui-input-block">
            <input class="layui-input" type="text" name="sortSq" id="sortSq" lay-verify="sortSq" placeholder="请输入排序"/>
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

        window.parentItemId = null;
        window.pcodeName = "";

        var id = "${id}";
        var codeName = "${codeName}";
        var pId = "";

        if (codeName !== "") {
            showParValue();
        }
        function showParValue(){
            pId = id;
            $("#codeId").val(pId);
            $("#parentItemId").val(parent.window.parentItemIdFromView);
            $("#pcodeName").val(parent.window.pcodeNameFromView);

            form.render();
        }

        //上层节点名称
        $("#pcodeName").on('click', function () {

            var url = "${ctxPath}/multiValue/edit?method=multiValueAdd"+"&id="+pId+"&codeName="+codeName;

            layer.open({
                type: 2,
                title:'上层代码',
                area: ['350px', '300px'],
                btn: '确认',
                content: url,
                yes: function (index, layero) {

                    //确认按钮回调
                    if(window.pcodeName !== codeName){
                        $("#parentItemId").val(window.parentItemId);
                    }else{
                        $("#parentItemId").val("");
                    }

                    $("#pcodeName").val(window.pcodeName);

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
                var url = "./save";

            $("#multiValueForm").ajaxSubmit({
                type: "post",
                url: url,
                dataType: "json",
                beforeSubmit: function (arr) {
                    var length = arr.length;
                    return true;
                },
                success: function (data) {
                    if (data.responseCode == 0) {
                        //提交成功
                        parent.layui.layer.msg("提交成功");
                        var index = parent.layer.getFrameIndex(window.name);
                        parent.layer.close(index);
                        parent.layui.table.reload('multiValueTable'); //重载表格
                        parent.reloadCodeTree();

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


</script>
<script type="text/javascript" src="${ctxPath}/resources/js/jquery.js"></script>
<script type="text/javascript" src="${ctxPath}/resources/js/jquery.form.min.js"></script>

<%@include file="../footer.jsp" %>
