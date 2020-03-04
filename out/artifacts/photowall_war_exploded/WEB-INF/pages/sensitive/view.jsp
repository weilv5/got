<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<div class="caption">当前位置&nbsp;>&nbsp;<span>查看敏感词</span></div>

    <div class="col-lg-12">
        <div  class="col-lg-12 form-panel">

                <form class="form-horizontal style-form" id="sensitive_wordsForm" style="width: 96%;margin: 0px 2%;">
                    <input id="id" name="id" type="hidden" >
                        <div class="form-group col-lg-12">
                            <label class="col-lg-2 control-label">敏感词：</label>
                            <div class="col-lg-10" style="padding-top: 7px;" id="words"></div>
                        </div>
                    <div class="text-center col-lg-12">
                        <button type="button"  class="btn btn-danger" onclick="showConfirm()">删除</button>
                        <button type="button" class="btn btn-primary" onclick="modifysensitive_words()">修改</button>
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
                <button type="button" class="btn btn-primary" onclick="removesensitive_words()">确定</button>
            </div>
        </div>
    </div>
</div>
<%@include file="../footer.jsp"%>
<script>
    function backToList() {
        window.open("./?method=page", "_self");
    }

    function modifysensitive_words(){
        var id = "${id}";
        window.open("./?method=edit&id=" + id, "_self");
    }
    function showConfirm() {
        $("#confirmDialog").modal("show");
        $("#confirmMsg").text("确定要删除敏感词");
    }
    function removesensitive_words() {
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

    function viewsensitive_words(){
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
                    $("#words").text(data.words);
            }
        });
    }
    $(document).ready(function(){
        viewsensitive_words();
    });
</script>
