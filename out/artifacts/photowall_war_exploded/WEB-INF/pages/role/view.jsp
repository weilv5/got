<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<div class="caption">当前位置&nbsp;>&nbsp;<span>查看角色</span></div>

    <div class="col-lg-12">
        <div class="col-lg-12 form-panel">

                <form class="form-horizontal style-form" id="roleForm" style="width: 96%;margin: 0px 2%;">
                    <input id="id" name="id" type="hidden" >

                        <div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">上层角色：</label>
                            <div class="col-lg-8" style="padding-top: 7px;" id="parentRoleName"></div>
                        </div>
                        <div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">角色名称：</label>
                            <div class="col-lg-8" style="padding-top: 7px;" id="roleName"></div>
                        </div>
                        <div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">排序：</label>
                            <div class="col-lg-8" style="padding-top: 7px;" id="sort"></div>
                        </div>
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">是否管理员：</label>
                        <div class="col-lg-8" style="padding-top: 7px;" id="admin">否</div>
                    </div>
                        <div class="form-group col-lg-12">
                            <label class="col-lg-2 control-label">备注：</label>
                            <div class="col-lg-10" style="padding-top: 7px;" id="backup"></div>
                        </div>
                    <div class="text-center col-lg-12">
                        <button type="button"  class="btn btn-danger" onclick="showConfirm()">删除</button>
                        <button type="button" class="btn btn-primary" onclick="modifyrole()">修改</button>
                        <button type="button" class="btn btn-default" onclick="backToList()">返回</button>
                    </div>
                </form>

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
<div id="confirmDialog" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">提示</h4>
            </div>
            <div class="modal-body" id="confirmMsg">

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" onclick="removerole()">确定</button>
            </div>
        </div>
    </div>
</div>
<%@include file="../footer.jsp"%>
<script>
    function backToList() {
        window.open("./?method=page", "_self");
    }

    function modifyrole(){
        var id = "${id}";
        window.open("./?method=edit&id=" + id, "_self");
    }
    function showConfirm() {
        $("#confirmDialog").modal("show");
        $("#confirmMsg").text("确定要删除角色");
    }
    function removerole() {
        var id = "${id}";
        $.ajax({
            url: "./delete/" + id,
            type: "post",
            dataType: "json",
            success: function (data) {
                $("#confirmDialog").modal("hide");
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
        })
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
                if(data.sort)
                    $("#sort").text(data.sort);
                if(data.parentRole)
                    $("#parentRoleName").text(data.parentRole.roleName);
                $("#backup").text(data.backup);
                $("#roleName").text(data.roleName);
                if(data.admin)
                    $("#admin").text("是");
            }
        });
    }
    $(document).ready(function(){
        viewrole();
        var number = $("#roleForm div").length%2==0? $("#roleForm div").length/2: ($("#roleForm div").length/2+1);
        $("#roleForm").height($($("#roleForm div")[0]).height()*(number+2));
    });
</script>
