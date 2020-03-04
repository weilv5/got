<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<div class="caption">当前位置&nbsp;>&nbsp;<span>查看模块</span></div>

    <div class="col-lg-12">
        <div class="col-lg-12 form-panel">
                <form class="form-horizontal style-form" id="moduleForm" >
                    <input id="id" name="id" type="hidden" >
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">父模块：</label>
                        <div class="col-lg-8" style="padding-top: 7px;" id="parentModeluId"></div>
                    </div>
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">模块名称：</label>
                        <div class="col-lg-8" style="padding-top: 7px;" id="moduleName"></div>
                    </div>
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">模块编码：</label>
                        <div class="col-lg-8" style="padding-top: 7px;" id="moduleCode"></div>
                    </div>
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">模块地址：</label>
                        <div class="col-lg-8" style="padding-top: 7px;" id="moduleAddr"></div>
                    </div>
                        <div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">模块图标：</label>
                            <div class="col-lg-8" style="padding-top: 7px;" id="iconAddr"></div>
                        </div>
                        <div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">模块序号：</label>
                            <div class="col-lg-8" style="padding-top: 7px;" id="sortSq"></div>
                        </div>
                        <div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">是否可见：</label>
                            <div class="col-lg-8" style="padding-top: 7px;" id="isVisible"></div>
                        </div>
                        <div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">是否公开：</label>
                            <div class="col-lg-8" style="padding-top: 7px;" id="isPublic"></div>
                        </div>
                        <div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">目标：</label>
                            <div class="col-lg-8" style="padding-top: 7px;" id="target"></div>
                        </div>
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">是否严格校验URL：</label>
                        <div class="col-lg-8" id="stick" style="padding-top: 7px;"></div>
                    </div>

                        <%--<div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">图标:</label>
                            <div class="col-lg-8" style="padding-top: 7px;" id="iconAddr"></div>
                        </div>--%>
                    <div class="text-center col-lg-12">
                        <button type="button"  class="btn btn-danger" onclick="showConfirm()">删除</button>
                        <button type="button" class="btn btn-primary" onclick="modifymodule()">修改</button>
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
                <button type="button" class="btn btn-primary" onclick="removemodule()">确定</button>
            </div>
        </div>
    </div>
</div>
<%@include file="../footer.jsp"%>
<script>
    function backToList() {
        window.open("./?method=page", "_self");
    }

    function modifymodule(){
        var id = "${id}";
        window.open("./?method=edit&id=" + id, "_self");
    }
    function showConfirm() {
        $("#confirmDialog").modal("show");
        $("#confirmMsg").text("确定要删除模块");
    }
    function removemodule() {
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

    function viewmodule(){
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
                $("#moduleAddr").text(data.moduleAddr);
                if(data.sortSq)
                    $("#sortSq").text(data.sortSq);
                $("#createrUserId").text(data.createrUserId);
                if(data.isVisible==0)
                    $("#isVisible").text("否");
                else
                    $("#isVisible").text("是");
                if(data.parentModule)
                    $("#parentModeluId").text(data.parentModule.moduleName);
                if(data.isPublic==1)
                    $("#isPublic").text("是");
                else
                    $("#isPublic").text("否");
                if(data.stick==1)
                    $("#stick").text("是");
                else
                    $("#stick").text("否");
                if(data.iconAddr)
                    $("#iconAddr").html("<span class='glyphicon " + data.iconAddr + "'></span>");
                $("#updateUserId").text(data.updateUserId);
                if(data.target === "_self")
                    $("#target").text("本窗口");
                else
                    $("#target").text("新窗口");
                $("#moduleCode").text(data.moduleCode);
                $("#moduleName").text(data.moduleName);

                var length = data.roleList.length;
                for(var i = 0; i < length; i++){
                    var roleSpan = $("<div id='" + data.roleList[i].id + "'>" + data.roleList[i].roleName + "</div>");
                    $("#roleNames").append(roleSpan);
                }
            }
        });
    }
    $(document).ready(function(){
        viewmodule();
    });
</script>
