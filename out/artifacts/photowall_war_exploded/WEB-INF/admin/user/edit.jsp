<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header_form.jsp" %>
    <form class="layui-form layui-form-pane" action="" id="userForm" lay-filter="userForm" style="padding: 20px 30px 0 30px;">
        <input id="id" name="id" type="hidden">
        <input name="CSRFToken" type="hidden" value="${CSRFToken}">
        <input id="deptId" name="deptId" type="hidden">
        <input id="deptIds" name="deptIds" type="hidden">
        <div class="layui-form-item">
            <label class="layui-form-label">部门名称<label style="color:red;">*</label></label>
            <div class="layui-input-block">
                <input class="layui-input" placeholder="请选择所在部门" type="text" name="deptName" id="deptName" lay-verify="required" readonly/>
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">姓名<label style="color:red;">*</label></label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" placeholder="请输入姓名" name="name" id="name" lay-verify="required|name"/>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">用户名<label style="color:red;">*</label></label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" name="userId" id="userId" placeholder="请输入用户名" lay-verify="required|userId"
                       <c:if test="${not empty id}">readonly</c:if>/>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">手机号<label style="color:red;">*</label></label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" name="mobile" id="mobile" lay-verify="phone"/>
            </div>
        </div>
        <div class="layui-form-item" pane>
            <label class="layui-form-label">出生日期</label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" name="birthday" id="birthday" placeholder="yyyy-MM-dd"/>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">性别</label>
            <div class="layui-input-block">
                <select id="gender"
                        name="gender"
                        class="layui-select-button"
                        lay-filter="gender"
                        type="text">
                    <option value=""></option>
                    <option value="0">男</option>
                    <option value="1">女</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">电子邮箱<label style="color:red;">*</label></label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" name="email" id="email" lay-verify="email"/>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">排序<label style="color:red;">*</label></label>
            <div class="layui-input-block">
                <input class="layui-input" type="text" name="sort" id="sort" lay-verify="sort"/>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">关联部门</label>
            <div class="layui-input-inline">
                <a class="layui-icon" style="font-size: 30px; color: #33ABA0;" id="depts">&#xe654;</a><br>
                <div id="deptNames"></div>
            </div>

            <label class="layui-form-label">角色</label>
            <div class="layui-input-inline">
                <a class="layui-icon" href="#" style="font-size: 30px; color: #33ABA0;" id="roles">&#xe654;</a><br>
                <div id="roleNames"></div>
            </div>

        </div>
        <div class="layui-form-item layui-hide">
            <input type="button" lay-submit lay-filter="layuiadmin-app-form-submit" id="layuiadmin-app-form-submit" value="提交">
        </div>
    </form>
<script>
    layui.use(['form', 'layedit', 'laydate','layer'], function () {
        var form = layui.form
            , layer = layui.layer
            , laydate = layui.laydate
            , $ = layui.jquery;

        window.deptIdArr = [];//全局变量
        window.roleIdArr = [];
        window.deptId = "";
        window.deptName = "";


        //日期
        laydate.render({
            elem: '#birthday',
            type: 'date'
        });

        //关联部门
        $("#depts").on('click', function () {
            //$("#deptNames").empty();
            //window.deptIdArr = [];
            layer.open({
                type: 2,
                title: '关联部门',
                area: ['350px', '400px'],
                content: '${ctxPath}/user/?method=deptRel',
                cancel: function (index, layero) {
                    layer.close(index);
                    return false;
                }
            });


        });

        //角色
        $("#roles").on('click', function () {
            //$("#roleNames").empty();
            //window.roleIdArr = [];
            layer.open({
                type: 2,
                title: '添加角色',
                area: ['350px', '400px'],
                content: '${ctxPath}/user/?method=roleAdd',
                cancel: function (index, layero) {
                    layer.close(index);
                    return false;
                }
            });
        });


        //所属部门
        $("#deptName").on('click', function () {
            layer.open({
                type: 2,
                title: '所属部门',
                btn: '确认',
                area: ['350px', '400px'],
                content: '${ctxPath}/user/?method=deptAdd',
                yes: function (index, layero) {
                    //确认按钮回调
                    if($.inArray(window.deptId,window.deptIdArr) != -1){
                        parent.layui.layer.msg("选择部门不能与关联部门重复！");
                    }else {
                        $("#deptId").val(window.deptId);
                        $("#deptName").val(window.deptName);
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
            sort: function (value) {
                if (value<1 || value >99) {
                    return '排序必须1到99位';
                }else if(isNaN(value)){
                    return '排序必须为整数';
                }
            },

            name: [/^([\u4E00-\u9FA5A-Za-z0-9]){0,10}$/, '必须是长度小于10的字符'],
            userId: [/^([\u4E00-\u9FA5A-Za-z0-9]){0,10}$/, '必须是长度小于10的字符'],
            mobile: [/^1[3|4|5|7|8]\d{9}$/, '手机必须11位，只能是数字！']


        });

        //新增、编辑

        //监听提交
        form.on('submit(layuiadmin-app-form-submit)', function (e) {
                <c:if test="${empty id}">var url = "./save";
            </c:if>
                <c:if test="${not empty id}">var url = "./update";
            </c:if>

            var length = window.deptIdArr.length;
            for (var i = 0; i < length; i++) {
                var deptIdInput = $("<input type='hidden' name='deptList[" + i + "].id' value='" + window.deptIdArr[i] + "'>");
                $("#userForm").append(deptIdInput);
            }

            length = window.roleIdArr.length;
            for (var i = 0; i < length; i++) {
                var roleIdInput = $("<input type='hidden' name='roleList[" + i + "].id' value='" + window.roleIdArr[i] + "'>");
                $("#userForm").append(roleIdInput);
            }
            $("#userForm").ajaxSubmit({
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
                        parent.layui.table.reload('userTable'); //重载表格
                        parent.reloadDeptTree();
                    } else {
                        layui.layer.msg(data.msg);

                    }

                },
                error: function () {
                    layui.layer.msg("用户添加失败");
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
                    if (data.birthday) {
                        var birth = data.birthday.toString();
                        $("#birthday").attr("value", birth.substr(0, 10));
                    }
                    $("#email").val(data.email);
                    $("#deptId").val(data.deptId);
                    if (data.department) {
                        $("#deptName").val(data.department.deptName);
                    }
                    $("#name").val(data.name);

                    if (data.gender) {
                        var value = data.gender.split("|")[2];
                        //$("#gender").attr("value", value);
                        $("#gender").val(value);
                    }
                    $("#userId").val(data.userId);
                    $("#mobile").val(data.mobile);
                    if (data.sort)
                        $("#sort").val(data.sort);

                    form.render();
                },
                error: function () {
                    //获取用户失败
                }
            });

            //获取用户关联部门和角色信息
            $.ajax({
                url: "./extension/" + id,
                dataType: "json",
                type: "get",
                data: {
                    dt: dt
                },
                success: function (data) {
                    var length = data.deptList.length;
                    for (var i = 0; i < length; i++) {
                        var deptSpan = $("<div id='" + data.deptList[i].id + "'>" + data.deptList[i].deptName + "<a href='#' onclick='deptDel(\"" + data.deptList[i].id + "\")' class='layui-icon' style=\"color: #33ABA0;\">&#x1006;</a></div>");
                        $("#deptNames").append(deptSpan);
                        window.deptIdArr.push(data.deptList[i].id);

                    }

                    length = data.roleList.length;
                    for (var i = 0; i < length; i++) {
                        var roleSpan = $("<div id='" + data.roleList[i].id + "'>" + data.roleList[i].roleName + "<a href='#' onclick='roleDel(\"" + data.roleList[i].id + "\")'  class='layui-icon' style=\"color: #33ABA0;\">&#x1006;</a></div>");
                        $("#roleNames").append(roleSpan);
                        window.roleIdArr.push(data.roleList[i].id);
                    }
                    form.render();
                },
                error: function () {
                    //获取用户失败
                }
            });
        }



    });

    function deptDel(deptId) {
        $("#" + deptId).remove();
        var length = window.deptIdArr.length;
        for (var i = 0; i < length; i++) {
            if (window.deptIdArr[i] === deptId) {
                window.deptIdArr.splice(i, 1);
                break;
            }
        }

    }

    function roleDel(roleId) {
        $("#" + roleId).remove();
        var length = window.roleIdArr.length;
        for (var i = 0; i < length; i++) {
            if (window.roleIdArr[i] === roleId) {
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
