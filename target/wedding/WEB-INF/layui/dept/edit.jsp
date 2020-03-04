<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<div class="layui-fluid"  style="padding: 20px;">
<form class="layui-form layui-form-pane" action="" id="departmentForm" lay-filter="deptForm">
    <input id="id" name="id" type="hidden">
    <input name="CSRFToken" type="hidden" value="${CSRFToken}">
    <input id="deptCode" name="deptCode" type="hidden">
    <input id="parentDeptId" name="parentDeptId" type="hidden">
    <div class="layui-form-item">
        <label class="layui-form-label">部门名称<label style="color:red;">*</label></label>
        <div class="layui-input-block">
            <input class="layui-input" type="text" name="deptName" id="deptName" lay-verify="required|deptName" placeholder="请输入部门名称"/>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">上层部门</label>
        <div class="layui-input-block">
            <input class="layui-input" type="text" name="parentDeptName" id="parentDeptName" placeholder="请选择上层部门"/>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">排序</label>
        <div class="layui-input-block">
            <input class="layui-input" type="text" name="sort" id="sort" lay-verify="sort" placeholder="请输入"/>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">角色</label>
        <div class="layui-input-block">
            <a class="layui-icon" href="#" style="font-size: 30px; color: #33ABA0;" id="roles">&#xe654;</a><br>
            <div id="roleNames"></div>
        </div>
    </div>
    <div class="layui-form-item" align="center">
        <button class="layui-btn" lay-submit lay-filter="*">提交</button>
        <button type="button" class="layui-btn layui-btn-primary" onclick="backToList()">返回</button>
    </div>
</form>
</div>
<script>
    layui.use(['form', 'layedit', 'laydate', 'tree'], function () {
        var form = layui.form
            , layer = layui.layer
            , layedit = layui.layedit
            , laydate = layui.laydate
            , tree = layui.tree
            , $ = layui.jquery;

        window.roleIdArr = [];
        var id = "${id}";
        console.info(id);
        if (id !== "") {
            editdept();
        }
        //根据id获取用户详情
        function editdept() {
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
                    $("#deptCode").val(data.deptCode);
                    $("#deptName").val(data.deptName);
                    $("#parentDeptId").val(data.parentDeptId);
                    if(data.sort)
                        $("#sort").val(data.sort);
                    if(data.parentDept)
                        $("#parentDeptName").val(data.parentDept.deptName);

                    var length = data.deptRoleList.length;
                    for(var i = 0; i < length; i++){
                        var roleSpan = $("<div id='" + data.deptRoleList[i].id + "'>" + data.deptRoleList[i].roleName + "<a href='#' onclick='delRole(\""+data.deptRoleList[i].id+"\")' class='layui-icon' style=\"color:#33ABA0\">&#x1006;</a></div>");
                        $("#roleNames").append(roleSpan);
                        window.roleIdArr.push(data.deptRoleList[i].id);
                    }

                    if(data.enable == 0){
                        $("#btnDiv").prepend($("<button type='button'  class='btn btn-primary' onclick='enableDept()'>激活</button>"));
                    }else{
                        $("#btnDiv").prepend($("<button type='button'  class='btn btn-danger' onclick='disableDept()'>禁用</button>"));
                    }

                    form.render();
                },
                error: function () {
                    //获取部门失败
                }
            });
        }


        //角色
        $("#roles").on('click', function () {
            layer.open({
                type: 2,
                title: '添加角色',
                area: ['350px', '300px'],
                content: '${ctxPath}/dept/?method=roleAdd',
                cancel: function (index, layero) {
                    layer.close(index);
                    return false;
                }
            });
        });




        //上层部门名称
        $("#parentDeptName").on('click', function () {
            //useropenLayer("${ctxPath}/dept/?method=deptAdd","添加上层部门","300px","400px");
            layer.open({
                type: 2,
                title:'上层部门',
                area: ['350px', '300px'],
                btn: '确认',
                content: '${ctxPath}/dept/?method=deptAdd',
                yes: function (index, layero) {
                    //确认按钮回调
                    $("#parentDeptId").val(window.parentDeptId);
                    $("#parentDeptName").val(window.parentDeptName);
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
            deptName: function (value) {
                if (value.length > 20) {
                    return '部门名称长度不能超过20位';
                }
            },
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
        form.on('submit(deptForm)', function (e) {
                <c:if test="${empty id}">var url = "./save";
            </c:if>
                <c:if test="${not empty id}">var url = "./update";
            </c:if>

            var length = window.roleIdArr.length;
            for(var i = 0; i < length; i++){
                var roleIdInput = $("<input type='hidden' name='deptRoleList[" + i + "].id' value='" + window.roleIdArr[i] + "'>");
                $("#departmentForm").append(roleIdInput);
            }
            $("#departmentForm").ajaxSubmit({
                type: "post",
                url: url,
                dataType: "json",
                beforeSubmit: function (arr) {
                    var length = arr.length;
                    for (var i = 0; i < length; i++) {
                        if (arr[i].name === "parentDeptId" && arr[i].value === "") {
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
                        parent.getThisTabWindow().loadDept();

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

    function delRole(roleId){
        $("#" + roleId).remove();
        var length = window.roleIdArr.length;
        for(var i = 0; i < length; i++){
            if(window.roleIdArr[i] === roleId){
                window.roleIdArr.splice(i, 1);
                break;
            }
        }

    }

    function backToList() {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    }

</script>
<script type="text/javascript" src="${ctxPath}/resources/js/jquery.js"></script>
<script type="text/javascript" src="${ctxPath}/resources/js/jquery.form.min.js"></script>

<%@include file="../footer.jsp" %>
