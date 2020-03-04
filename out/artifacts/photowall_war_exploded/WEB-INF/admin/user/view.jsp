<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header_form.jsp" %>
    <form class="layui-form layui-form-pane" style="padding: 20px 30px 0 30px;">
        <input id="id" name="id" type="hidden">
        <div class="layui-form-item">
            <label class="layui-form-label">部门</label>
            <div class="layui-input-block">
                <input class="layui-input" id="deptName" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">姓名</label>
            <div class="layui-input-block">
                <input class="layui-input" id="name" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">用户名</label>
            <div class="layui-input-block">
                <input class="layui-input" id="userId" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">手机</label>
            <div class="layui-input-block">
                <input class="layui-input" id="mobile" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">出生日期</label>
            <div class="layui-input-block">
                <input class="layui-input" id="birthday" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">性别</label>
            <div class="layui-input-block">
                <input class="layui-input" id="gender" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">电子邮箱</label>
            <div class="layui-input-block">
                <input class="layui-input" id="email" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">排序</label>
            <div class="layui-input-block">
                <input class="layui-input" id="sort" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">关联部门</label>
            <div class="layui-input-block">
                <input class="layui-input" id="deptNames" readonly>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">角色</label>
            <div class="layui-input-block">
                <input class="layui-input" id="roleNames" readonly>
            </div>
        </div>
        <div class="layui-form-item" align="center" id="btnDiv">
            <button type="button" class="layui-btn" id="initPassword">初始化密码</button>
            <button type="button" class="layui-btn" id="clearUserLock">解除锁定</button>
            <button type="button" class="layui-btn layui-btn-primary" id="backToList">返回</button>
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
        console.info(id);
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
                if (data.userId != 'admin') {

                    if (data.enable == 0) {
                        $("#btnDiv").prepend($("<button type='button'  class='layui-btn' onclick='userEnable()'>激活</button>"));
                    } else {
                        $("#btnDiv").prepend($("<button type='button'  class='layui-btn' onclick='userDisable()'>禁用</button>"));
                    }
                }
                if (data.birthday) {
                    var birth = data.birthday.toString();
                    $("#birthday").attr("value", birth.substr(0, 10));
                }
                $("#email").val(data.email);
                if (data.department) {
                    $("#deptName").val(data.department.deptName);
                }
                $("#name").val(data.name);
                if (data.gender) {
                    var value = data.gender.split("|")[3];
                    $("#gender").val(value);
                }
                $("#userId").val(data.userId);
                $("#mobile").val(data.mobile);
                if (data.sort)
                    $("#sort").val(data.sort);




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
                var deptNames = "";
                var roleNames = "";
                var length = data.deptList.length;
                for (var i = 0; i < length; i++) {
                    deptNames = deptNames + data.deptList[i].deptName + ",";
                }
                $("#deptNames").val(deptNames);
                length = data.roleList.length;
                for (var i = 0; i < length; i++) {
                    roleNames = roleNames + data.roleList[i].roleName + ",";
                }
                $("#roleNames").val(roleNames);
            },
            error: function () {
                //获取用户失败
            }
        });


        //初始化密码监听
        $("#initPassword").on('click', function () {
            initPassword();
        });

        //解除锁定监听
        $("#clearUserLock").on('click', function () {
            clearUserLock();
        });


        //返回按钮监听
        $("#backToList").on('click', function () {
            backToList();
        });


        function backToList() {
            var index = parent.layer.getFrameIndex(window.name);
            parent.layer.close(index);
        }


        function clearUserLock() {

            var id = "${id}";
            if (id === "")
                return;
            $.ajax({
                url: "./clearUserLock",
                dataType: "json",
                type: "post",
                data: {
                    id: id
                },
                success: function (data) {
                    if (data.responseCode == 0) {
                        var msg = "解除锁定成功";
                    } else {
                        var msg = "解除锁定失败，错误信息：" + data.msg;
                    }
                    layui.layer.msg(msg);
                }
            });
        }

        function initPassword() {
            var id = "${id}";
            if (id === "")
                return;
            $.ajax({
                url: "./initPassword",
                dataType: "json",
                type: "post",
                data: {
                    id: id
                },
                success: function (data) {
                    if (data.responseCode == 0) {
                        var msg = "初始化密码成功";
                    } else {
                        var msg = "初始化密码失败，错误信息：" + data.msg;
                    }
                    layui.layer.msg(msg);
                },
                error: function () {
                    layui.layer.msg("初始化密码失败");
                }
            });
        }


    });

    function userEnable() {
        var id = "${id}";
        var dt = (new Date()).getTime();
        $.ajax({
            url: "./enable/",
            type: "post",
            dataType: "json",
            data: {
                id: id,
                dt: dt
            },
            success: function (data) {
                if (data.responseCode == 0) {
                    layui.layer.msg("激活成功");
                    $("#btnDiv button:eq(0)").remove();
                    $("#btnDiv").prepend($("<button type='button'  class='layui-btn' onclick='userDisable()'>禁用</button>"));
                } else {
                    layui.layer.msg(data.msg);
                }
            }
        })
    }

    function userDisable() {
        var id = "${id}";
        var dt = (new Date()).getTime();
        $.ajax({
            url: "./disable/",
            type: "post",
            dataType: "json",
            data: {
                id: id,
                dt: dt
            },
            success: function (data) {
                if (data.responseCode == 0) {
                    layui.layer.msg("禁用成功");
                    $("#btnDiv button:eq(0)").remove();
                    $("#btnDiv").prepend($("<button type='button'  class='layui-btn' onclick='userEnable()'>激活</button>"));
                } else {
                    layui.layer.msg("禁用失败");
                }
            }
        })
    }


</script>
<%@include file="../footer.jsp" %>