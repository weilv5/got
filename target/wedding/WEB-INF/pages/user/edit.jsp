<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
                    <div class="caption">当前位置&nbsp;>&nbsp;<span><c:if test="${empty id}">添加</c:if><c:if test="${not empty id}">修改</c:if>用户</span></div>

                        <div class="col-lg-12">
                            <div class="col-lg-12 form-panel">
                                <form class="form-horizontal style-form" id="userForm">
                                    <input id="id" name="id" type="hidden" >
                                    <input name="CSRFToken" type="hidden" value="${CSRFToken}">
                                    <input id="deptId" name="deptId" type="hidden" >
                                    <input id="deptIds" name="deptIds" type="hidden">
                                    <div class="form-group col-lg-6" id="propertyDivdeptId">
                                        <label class="col-lg-4 control-label">部门：</label>
                                        <div class="col-lg-8">
                                            <input id="deptName"
                                                   name="deptName"
                                                   type="text"
                                                   readonly
                                                   onclick="window.isMainDept=true;showDept();"
                                                   class="form-control">
                                        </div>
                                    </div>
                                    <div class="form-group col-lg-6" id="propertyDivname">
                                        <label class="col-lg-4 control-label">姓名：</label>
                                        <div class="col-lg-8">
                                            <input id="name"
                                                   name="name"
                                                   type="text"
                                                   class="form-control">
                                        </div>
                                    </div>
                                    <div class="form-group col-lg-6" id="propertyDivuserId">
                                        <label class="col-lg-4 control-label">用户名：</label>
                                        <div class="col-lg-8">
                                            <input id="userId"
                                                   name="userId"
                                                    <c:if test="${not empty id}">readonly</c:if>
                                                   type="text"
                                                   class="form-control">
                                        </div>
                                    </div>
                                    <div class="form-group col-lg-6" id="propertyDivmobile">
                                        <label class="col-lg-4 control-label">手机：</label>
                                        <div class="col-lg-8">
                                            <input id="mobile"
                                                   name="mobile"
                                                   type="text"
                                                   class="form-control">
                                        </div>
                                    </div>
                                    <div class="form-group col-lg-6" id="propertyDivbirthday">
                                        <label class="col-lg-4 control-label">出生日期：</label>
                                        <div class="col-lg-8">
                                            <input id="birthday"
                                                   name="birthday"
                                                   type="text"
                                                   class="form-control date">
                                        </div>
                                    </div>
                                    <div class="form-group col-lg-6" id="propertyDivgender">
                                        <label class="col-lg-4 control-label">性别：</label>
                                        <div class="col-lg-8">
                                            <select id="gender"
                                                    name="gender"
                                                    class="form-control"></select>

                                        </div>
                                    </div>
                                    <div class="form-group col-lg-6" id="propertyDivemail">
                                        <label class="col-lg-4 control-label">电子邮箱：</label>
                                        <div class="col-lg-8">
                                            <input id="email"
                                                   name="email"
                                                   type="text"
                                                   class="form-control">
                                        </div>
                                    </div>
                                    <div class="form-group col-lg-6" >
                                        <label class="col-lg-4 control-label">排序：</label>
                                        <div class="col-lg-8">
                                            <input id="sort"
                                                   name="sort"
                                                   type="text"
                                                   class="form-control" >
                                        </div>
                                    </div>
                                    <div class="form-group col-lg-6">
                                        <label class="col-lg-4 control-label">关联部门：<a href="#" class="btn" onclick="window.isMainDept=false;showDept();"><span class="glyphicon glyphicon-plus"></span></a></label>
                                        <div class="col-lg-8" id="deptNames"></div>

                                    </div>
                                    <div class="form-group col-lg-6">
                                        <label class="col-lg-4 control-label">角色：<a href="#" class="btn" onclick="showRole();"><span class="glyphicon glyphicon-plus"></span></a></label>
                                        <div class="col-lg-8" id="roleNames"></div>

                                    </div>
                                    <div class="text-center col-lg-12">
                                        <button type="submit" class="btn btn-primary " >提交</button>&nbsp;&nbsp;
                                        <button type="button" class="btn btn-default" onclick='backToList()'>返回</button>
                                    </div>
                                </form>
                            </div>
                        </div>


                    <div class="modal fade" id="treeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h4 class="modal-title" >请选择上层部门</h4>
                                </div>
                                <div class="modal-body" id="treeDiv"></div>
                                <div class="modal-footer" >
                                    <button type="button"  class="btn btn-default" data-dismiss="modal">关闭</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal fade" id="roleTreeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h4 class="modal-title" >请选择角色</h4>
                                </div>
                                <div class="modal-body" id="RoleTree"></div>
                                <div class="modal-footer" >
                                    <button type="button"  class="btn btn-default" data-dismiss="modal">确定</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal fade" id="alertModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h4 class="modal-title" id="title">提示</h4>
                                </div>
                                <div class="modal-body" id="msg"></div>
                                <div class="modal-footer" id="closeBtn">
                                    <button type="button"  class="btn btn-default" data-dismiss="modal">关闭</button>
                                </div>
                            </div>
                        </div>
                    </div>
<%@include file="../footer.jsp"%>
<script src="${ctxPath}/resources/js/bootstrap-treeview.min.js"></script>
<script src="${ctxPath}/resources/js/dept.js"></script>
<script src="${ctxPath}/resources/js/role.js"></script>
<script>
    function backToList() {
        window.open("./?method=page", "_self");
    }
    function saveuser(){
        <c:if test="${empty id}">var url = "./save";</c:if>
        <c:if test="${not empty id}">var url = "./update";</c:if>
        var length = window.deptIdArr.length;
        for(var i = 0; i < length; i++){
            var deptIdInput = $("<input type='hidden' name='deptList[" + i + "].id' value='" + window.deptIdArr[i] + "'>");
            $("#userForm").append(deptIdInput);
        }

        length = window.roleIdArr.length;
        for(var i = 0; i < length; i++){
            var roleIdInput = $("<input type='hidden' name='roleList[" + i + "].id' value='" + window.roleIdArr[i] + "'>");
            $("#userForm").append(roleIdInput);
        }

        $("#userForm").ajaxSubmit({
            type:"post",
            url: url,
            success: function(data){
                if(data.responseCode==0){
                    $("#msg").text("提交成功");
                    $("#closeBtn").hide();
                    setTimeout(backToList, 1000)
                }else{
                    $("#msg").text(data.msg);
                    $("#closeBtn").show();
                }
                $('#alertModal').modal("show");
            }
        });
    }

    function viewuser(){
        var id = "${id}";
        if(id==="")
            return;
        $.ajax({
            url: "./get/" + id,
            dataType: "json",
            type: "get",
            success: function(data){
                $("#id").val(data.id);
                $("#birthday").val(data.birthday);
                $("#email").val(data.email);
                $("#deptName").val(data.department.deptName);
                $("#deptId").val(data.deptId);
                $("#name").val(data.name);
                if(data.sort)
                    $("#sort").val(data.sort);
                var value = data.gender.split("|")[2];
                $("#gender").val(value);
                $("#userId").val(data.userId);
                $("#mobile").val(data.mobile);
                var length = data.deptList.length;
                for(var i = 0; i < length; i++){
                    window.deptIdArr.push(data.deptList[i].id);
                    var deptSpan = $("<div id='" + data.deptList[i].id + "'>" + data.deptList[i].deptName + "<a href='#' onclick='delDept(\"" + data.deptList[i].id + "\")' class='glyphicon glyphicon-minus'></a></div>");
                    $("#deptNames").append(deptSpan);
                }

                length = data.roleList.length;
                for(var i = 0; i < length; i++){
                    window.roleIdArr.push(data.roleList[i].id);
                    var roleSpan = $("<div id='" + data.roleList[i].id + "'>" + data.roleList[i].roleName + "<a href='#' onclick='delRole(\"" + data.roleList[i].id + "\")' class='glyphicon glyphicon-minus'></a></div>");
                    $("#roleNames").append(roleSpan);
                }
            }
        });

    }
    $(document).ready(function(){

        $("#userForm").bootstrapValidator({
            fields: {
                mobile: {
                    validators:{
                        regexp: {
                            regexp: /^1[3|5|7|8|][0-9]{9}/,
                            message: '手机号码不合法'
                        }
                    }
                },
                email:{
                    validators:{
                        regexp: {
                            regexp: /^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$/,
                            message: '电子邮箱地址不合法'
                        }
                    }
                },
                name: {
                    validators: {
                        notEmpty: {
                            message: '姓名不能为空'
                        },
                        stringLength: {
                            max: 30,
                            message: '姓名长度不能超过30位'
                        }
                    }
                },
                userId: {
                    validators: {
                        notEmpty: {
                            message: '用户名不能为空'
                        },
                        stringLength: {
                            max: 30,
                            min: 6,
                            message: '用户名长度为6-30个字符'
                        }
                    }
                },
                deptName: {
                    validators: {
                        notEmpty: {
                            message: '部门不能为空'
                        }
                    }
                },
                sort: {
                    validators: {
                        lessThan: {
                            value: 99,
                            inclusive: true,
                            message: '排序需要小于100'
                        },
                        greaterThan: {
                            value: -1,
                            inclusive: false,
                            message: '排序需要大于0'
                        }
                    }
                }
            }
        }).on('success.form.bv', function(e) {
            e.preventDefault();
            saveuser();
        });
        $("#userForm").on("submit", function(e){
            e.preventDefault();
        });

        $('.date').datetimepicker({
            locale: 'zh-cn',
            format: "YYYY-MM-DD"
        });
        $('.datetime').datetimepicker({
            locale: 'zh-cn',
            format: "YYYY-MM-DD HH:mm:ss"
        });
        window.deptIdArr = [];
        window.roleIdArr = [];
        viewuser();
        loadDictionary("select", "gender", "DataDictionary", "gender", "", "single");
    });

    function showDept() {
        $('#treeModal').modal("show");
        $("#treeDiv").deptTree({
            useChecked: true,
            onChecked: function(event, dept){
                if(window.isMainDept){
                    $("#deptId").val(dept.id);
                    $("#deptName").val(dept.text);
                    $('#treeModal').modal("hide");
                }else{
                    if($("#deptId").val()===dept.id){
                        $("#msg").text("关联部门不能是用户所在部门");
                        $('#alertModal').modal("show");
                    }else{
                        if(!window.deptIdArr)
                            window.deptIdArr = [];
                        window.deptIdArr.push(dept.id);
                        var deptSpan = $("<div id='" + dept.id + "'>" + dept.text + "<a href='#' onclick='delDept(\"" + dept.id + "\")' class='glyphicon glyphicon-minus'></a></div>");
                        $("#deptNames").append(deptSpan);
                        $('#treeModal').modal("hide");
                    }
                }
                $('#userForm').data('bootstrapValidator').revalidateField('deptName');
            }
        });
    }

    function delDept(deptId){
        $("#" + deptId).remove();
        var length = window.deptIdArr.length;
        for(var i = 0; i < length; i++){
            if(window.deptIdArr[i] === deptId){
                window.deptIdArr.splice(i, 1);
                break;
            }
        }
    }

    function showRole() {
        $('#roleTreeModal').modal("show");
        $("#RoleTree").roleTree({
            useChecked: true,
            onChecked: function(event, role){
                window.roleIdArr.push(role.id);
                var roleSpan = $("<div id='" + role.id + "'>" + role.text + "<a href='#' onclick='delRole(\"" + role.id + "\")' class='glyphicon glyphicon-minus'></a></div>");
                $("#roleNames").append(roleSpan);

            },
            onUnChecked: function(event, role){
                delRole(role.id);
            }
        });
    }

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

    function loadDictionary(type, fieldName, table, field, text, isGroup){
        var dt = (new Date()).getTime();
        $.ajax({
            url: "${ctxPath}/getDictionary",
            type: "post",
            dataType: "json",
            data: {
                dictTable: table,
                dictCode: field,
                dictText: text,
                dt: dt
            },
            success: function(dictionary){
                if(type === "select"){
                    var length = dictionary.length;
                    for(var i = 0; i< length; i++){
                        $("#" + fieldName).append("<option value='" + dictionary[i].code + "'>" + dictionary[i].text + "</option>");
                    }
                }
            }
        });
    }

    function backToList() {
        window.open("./?method=page", "_self");
    }
</script>
