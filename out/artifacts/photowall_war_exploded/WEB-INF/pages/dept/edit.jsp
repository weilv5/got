<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<link href="${ctxPath}/resources/css/bootstrap-treeview.min.css" rel="stylesheet">
<div class="caption">当前位置&nbsp;>&nbsp;<span><c:if test="${empty id}">添加</c:if><c:if test="${not empty id}">修改</c:if>部门</span></div>

                        <div class="col-lg-12">
                            <div class="form-panel col-lg-12">
                                <form class="form-horizontal style-form" id="departmentForm">
                                    <input id="id" name="id" type="hidden" >
                                    <input id="deptCode" name="deptCode" type="hidden" >
                                    <input name="CSRFToken" type="hidden" value="${CSRFToken}">
                                    <input id="parentDeptId" name="parentDeptId" type="hidden" >
                                    <div class="form-group col-lg-6" id="propertyDivdeptName">
                                        <label class="col-lg-4 control-label">部门名称:</label>
                                        <div class="col-lg-8">
                                            <input id="deptName"
                                                   name="deptName"
                                                   type="text"
                                                   class="form-control" >
                                        </div>
                                    </div>
                                    <div class="form-group col-lg-6">
                                        <label class="col-lg-4 control-label">上层部门名称:</label>
                                        <div class="col-lg-8">
                                            <input id="parentDeptName"
                                                   name="parentDeptName"
                                                   type="text"
                                                   readonly
                                                   onclick="showParentDept()"
                                                   class="form-control" >
                                        </div>
                                    </div>
                                    <div class="form-group col-lg-6" >
                                        <label class="col-lg-4 control-label">排序:</label>
                                        <div class="col-lg-8">
                                            <input id="sort"
                                                   name="sort"
                                                   type="text"
                                                   class="form-control" >
                                        </div>
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
    function savedepartment(){
        <c:if test="${empty id}">var url = "./save";</c:if>
        <c:if test="${not empty id}">var url = "./update";</c:if>
        var length = window.roleIdArr.length;
        for(var i = 0; i < length; i++){
            var roleIdInput = $("<input type='hidden' name='deptRoleList[" + i + "].id' value='" + window.roleIdArr[i] + "'>");
            $("#departmentForm").append(roleIdInput);
        }
        $("#departmentForm").ajaxSubmit({
            type:"post",
            url: url,
            beforeSubmit: function(arr) {
                var length = arr.length;
                for(var i = 0; i < length; i++){
                    if(arr[i].name === "parentDeptId" && arr[i].value === ""){
                        arr.splice(i, 1);
                        break;
                    }
                }
                return true;
            },
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
    
    function showParentDept() {
        $('#treeModal').modal("show");
        $("#treeDiv").deptTree({
            useChecked: true,
            onChecked: function(event, dept){
                if(dept.id === $("#id").val()){
                    $("#msg").text("上层部门不能与本部门一样");
                    $('#alertModal').modal("show");
                    dept.state.checked = false;
                }else{
                    $("#parentDeptId").val(dept.id);
                    $("#parentDeptName").val(dept.text);
                    $('#treeModal').modal("hide");
                }
            }
        });
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

    function viewdepartment(){
        var id = "${id}";
        if(id==="")
            return;
        var dt = (new Date()).getTime();
        $.ajax({
            url: "./get/" + id,
            dataType: "json",
            type: "get",
            data:{
                dt: dt
            },
            success: function(data){
                $("#id").val(data.id);
                $("#deptName").val(data.deptName);
                $("#parentDeptId").val(data.parentDeptId);
                $("#deptCode").val(data.deptCode);
                if(data.sort)
                    $("#sort").val(data.sort);
                if(data.parentDept)
                    $("#parentDeptName").val(data.parentDept.deptName);
                var length = data.deptRoleList.length;
                for(var i = 0; i < length; i++){
                    window.roleIdArr.push(data.deptRoleList[i].id);
                    var roleSpan = $("<div id='" + data.deptRoleList[i].id + "'>" + data.deptRoleList[i].roleName + "<a href='#' onclick='delRole(\"" + data.deptRoleList[i].id + "\")' class='glyphicon glyphicon-minus'></a></div>");
                    $("#roleNames").append(roleSpan);
                }
            }
        });

    }
    $(document).ready(function(){

        $("#departmentForm").bootstrapValidator({
            fields: {
                deptName: {
                    validators: {
                        notEmpty: {
                            message: '部门名称不能为空'
                        },
                        stringLength: {
                            max: 20,
                            message: '部门名称长度不能超过20位'
                        },
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
            savedepartment();
        });
        $("#departmentForm").on("submit", function(e){
            e.preventDefault();
        });

        window.roleIdArr = [];
        $('.date').datetimepicker({
            locale: 'zh-cn',
            format: "YYYY-MM-DD"
        });
        $('.datetime').datetimepicker({
            locale: 'zh-cn',
            format: "YYYY-MM-DD HH:mm:ss"
        });
        viewdepartment();

    });

    function backToList() {
        window.open("./?method=page", "_self");
    }
</script>
