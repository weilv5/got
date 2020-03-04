<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header_form.jsp" %>
<form class="layui-form layui-form-pane" action="" id="roleForm" lay-filter="roleForm" style="padding: 20px 30px 0 30px;">
    <input id="id" name="id" type="hidden" >
    <input name="CSRFToken" type="hidden" value="${CSRFToken}">
    <input id="parentRoleId" name="parentRoleId" type="hidden" >
    <div class="layui-form-item">
        <label class="layui-form-label">角色名称<label style="color:red;">*</label></label>
        <div class="layui-input-block">
            <input class="layui-input" type="text" name="roleName" id="roleName" lay-verify="required" placeholder="请输入角色名称"/>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">上层角色</label>
        <div class="layui-input-block">
            <input class="layui-input" type="text" autocomplete="off" name="parentRoleName" id="parentRoleName" placeholder="请选择上层角色"/>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">排序</label>
        <div class="layui-input-block">
            <input class="layui-input" type="text" name="sort" id="sort" placeholder="请输入" lay-verify="sort"/>
        </div>
    </div>
    <div class="layui-form-item" pane>
        <label class="layui-form-label">是否管理员</label>
        <div class="layui-input-block">
            <select id="admin"
                    name="admin"
                    class="layui-select-button"
                    lay-filter="admin"
                    type="text">
                <option value="false">否</option>
                <option value="true">是</option>
            </select>
        </div>
    </div>
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">备注</label>
        <div class="layui-input-block">
            <textarea placeholder="请输入内容" class="layui-textarea" id="backup" name="backup"></textarea>
        </div>
    </div>
    <div class="layui-form-item layui-hide">
        <input type="button" lay-submit lay-filter="layuiadmin-app-form-submit" id="layuiadmin-app-form-submit" value="提交">
    </div>

</form>
<script>
    layui.use(['form', 'layedit', 'laydate', 'tree'], function () {
        var form = layui.form
            , layer = layui.layer
            , layedit = layui.layedit
            , laydate = layui.laydate
            , tree = layui.tree
            , $ = layui.jquery;

        var id = "${id}";
        if (id !== "") {
            editrole();
        }

        //上层角色名称
        $("#parentRoleName").on('click', function () {
            layer.open({
                type: 2,
                title:'上层角色',
                btn: '确认',
                area: ['350px', '350px'],
                content: '${ctxPath}/role/?method=roleAdd',
                cancel: function (index, layero) {
                    layer.close(index);
                    return false;
                }
            });
        });

        //字段自定义验证
        form.verify({
            sort: function (value) {
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

            $("#roleForm").ajaxSubmit({
                type: "post",
                url: url,
                dataType: "json",
                beforeSubmit: function (arr) {
                    var length = arr.length;
                    for (var i = 0; i < length; i++) {
                        if (arr[i].name === "parentRoleId" && arr[i].value === "") {
                            arr.splice(i, 1);
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
                        parent.layui.table.reload('departmentTable'); //重载表格
                        parent.reloadTree();
                    } else {
                        layui.layer.msg(data.msg);
                    }

                },
                error: function () {
                    alert("error!");
                }
            });
            return false;
        });
        //根据id获取用户详情
        function editrole() {
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
                    $("#sort").val(data.sort);
                    if(data.parentRoleId)
                        $("#parentRoleId").val(data.parentRoleId);
                    $("#backup").val(data.backup);
                    $("#roleName").val(data.roleName);
                    if(data.parentRole)
                        $("#parentRoleName").val(data.parentRole.roleName);

                    $("#admin").val(data.admin+"");
                    form.render('select');
                    form.render();
                },
                error: function () {
                    //获取部门失败
                }
            });
        }



    });

</script>
<script type="text/javascript" src="${ctxPath}/resources/js/jquery.js"></script>
<script type="text/javascript" src="${ctxPath}/resources/js/jquery.form.min.js"></script>

<%@include file="../footer.jsp" %>
