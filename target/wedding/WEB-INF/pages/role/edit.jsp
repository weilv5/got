<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<div class="caption">当前位置&nbsp;>&nbsp;<span><c:if test="${empty id}">添加</c:if><c:if test="${not empty id}">修改</c:if>角色</span></div>
<div class="col-lg-12">
    <div class="form-panel col-lg-12">
        <form class="form-horizontal style-form " id="roleForm">
            <input id="id" name="id" type="hidden" >
            <input name="CSRFToken" type="hidden" value="${CSRFToken}">
            <input id="parentRoleId" name="parentRoleId" type="hidden" >
            <div class="form-group col-lg-6" id="propertyDivparentRoleId">
                <label class="col-lg-4 control-label">上层角色：</label>
                <div class="col-lg-8">
                    <input id="parentRoleName"
                           name="parentRoleName"
                           type="text"
                           readonly
                           onclick="showParentRole()"
                           class="form-control" >
                </div>
            </div>
            <div class="form-group col-lg-6" id="propertyDivroleName">
                <label class="col-lg-4 control-label">角色名称：</label>
                <div class="col-lg-8">
                    <input id="roleName"
                           name="roleName"
                           type="text"
                           class="form-control" >
                </div>
            </div>
            <div class="form-group col-lg-6" id="propertyDivsort">
                <label class="col-lg-4 control-label">排序：</label>
                <div class="col-lg-8">
                    <input id="sort"
                           name="sort"
                           type="text"
                           class="form-control" >
                </div>
            </div>
            <div class="form-group col-lg-6" id="propertyAdmin">
                <label class="col-lg-4 control-label">是否管理员：</label>
                <div class="col-lg-8">
                    <select id="admin"
                            name="admin"
                            class="form-control" >
                        <option value="false">否</option>

                    </select>
                </div>
            </div>
            <div class="form-group col-lg-12" id="propertyDivbackup">
                <label class="col-lg-2 control-label">备注：</label>
                <div class="col-lg-10">
                                                                                    <textarea id="backup"
                                                                                              class="form-control"
                                                                                              rows="6"
                                                                                              name="backup"></textarea>
                </div>
            </div>

            <div class="text-center col-lg-12">
                <button type="submit" class="btn btn-primary ">提交</button>&nbsp;&nbsp;
                <button type="button" class="btn btn-default" onclick='backToList()'>返回</button>
            </div>
        </form>

    </div>
</div>

<div class="modal fade" id="treeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" >请选择上层角色</h4>
            </div>
            <div class="modal-body" id="treeDiv"></div>
            <div class="modal-footer" >
                <button type="button"  class="btn btn-default" data-dismiss="modal">关闭</button>
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
<script src="${ctxPath}/resources/js/role.js"></script>
<script>
    function backToList() {
        window.open("./?method=page", "_self");
    }

    function showParentRole() {
        $('#treeModal').modal("show");
        $("#treeDiv").roleTree({
            useChecked: true,
            onChecked: function(event, role){
                if(role.id === $("#id").val()){
                    $("#msg").text("上层角色不能与本角色一样");
                    $('#alertModal').modal("show");
                    dept.state.checked = false;
                }else{
                    $("#parentRoleId").val(role.id);
                    $("#parentRoleName").val(role.text);
                    $('#treeModal').modal("hide");
                }
            }
        });
    }

    function saverole(){
            <c:if test="${empty id}">var url = "./save";</c:if>
            <c:if test="${not empty id}">var url = "./update";</c:if>
        $("#roleForm").ajaxSubmit({
            type:"post",
            url: url,
            beforeSubmit: function(arr) {
                var length = arr.length;
                for(var i = 0; i < length; i++){
                    if(arr[i].name === "parentRoleId" && arr[i].value === ""){
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

    function viewrole(){
        var id = "${id}";
        if(id==="")
            return;
        var dt = (new Date()).getTime();
        $.ajax({
            url: "./get/" + id,
            dataType: "json",
            type: "get",
            data: {
                dt: dt
            },
            success: function(data){
                $("#id").val(data.id);
                $("#sort").val(data.sort);
                if(data.parentRoleId)
                    $("#parentRoleId").val(data.parentRoleId);
                $("#backup").val(data.backup);
                $("#roleName").val(data.roleName);
                if(data.parentRole)
                    $("#parentRoleName").val(data.parentRole.roleName);
                $("#admin [value='" + data.admin + "']").attr("selected", true);
            }
        });

    }
    $(document).ready(function(){
        var isAdmin = <shiro:principal property='admin'/>;
        if(isAdmin){
            $("#admin").append($("<option value='true'>是</option>"));
        }
        $("#roleForm").bootstrapValidator({
            fields: {
                backup: {
                    validators: {
                        stringLength: {
                            max: 30,
                            message: '备注长度不能超过30位'
                        },
                    }
                },
                roleName: {
                    validators: {
                        notEmpty: {
                            message: '角色名称不能为空'
                        },
                        stringLength: {
                            max: 20,
                            message: '角色名称长度不能超过20位'
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
            saverole();
        });
        $("#roleForm").on("submit", function(e){
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
        viewrole();
    });


    function backToList() {
        window.open("./?method=page", "_self");
    }
</script>
