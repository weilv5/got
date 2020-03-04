<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<div class="caption">当前位置&nbsp;>&nbsp;<span>查看信息</span></div>

    <div class="col-lg-12">
        <div  class="col-lg-12 form-panel">
                <form class="form-horizontal style-form" id="information_contentForm" style="width: 96%;margin: 0px 2%;">
                    <input id="id" name="id" type="hidden" >
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">标题：</label>
                        <div class="col-lg-8" style="padding-top: 7px;" id="title"></div>
                    </div>
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">作者：</label>
                        <div class="col-lg-8" style="padding-top: 7px;" id="author"></div>
                    </div>
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">发布日期：</label>
                        <div class="col-lg-8" style="padding-top: 7px;" id="releasedDate"></div>
                    </div>
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">信息类别：</label>
                        <div class="col-lg-8" style="padding-top: 7px;" id="infoType"></div>
                    </div>
                        <div class="form-group col-lg-12">
                            <label class="col-lg-2 control-label">内容：</label>
                            <div class="col-lg-10" style="padding-top: 7px;" id="content"></div>
                        </div>

                        <div class="form-group col-lg-12">
                            <label class="col-lg-2 control-label">附件：</label>
                            <div class="col-lg-10" style="padding-top: 7px;" id="attachment"></div>
                        </div>
                    <div class="text-center col-lg-12">
                        <button type="button"  class="btn btn-danger" onclick="showConfirm()">删除</button>
                        <button type="button" class="btn btn-primary" onclick="modifyinformation_content()">修改</button>
                        <button type="button" class="btn btn-default" onclick="backToList()">返回</button>
                    </div>
                </form>
        </div>
    </div>

<div class="modal fade" id="alertModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" >提示</h4>
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
                <button type="button" class="btn btn-primary" onclick="removeinformation_content()">确定</button>
            </div>
        </div>
    </div>
</div>
<%@include file="../footer.jsp"%>
<script>
    function decodeHTML(str){
        var s = "";
        if(!str || str.length == 0) return "";
        s = str.replace(/&amp;/g,"&");
        s = s.replace(/&lt;/g,"<");
        s = s.replace(/&gt;/g,">");
        s = s.replace(/&nbsp;/g," ");
        s = s.replace(/&#39;/g,"\'");
        s = s.replace(/&quot;/g,"\"");
        return s;
     }
    function backToList() {
        window.open("./?method=page", "_self");
    }

    function modifyinformation_content(){
        var id = "${id}";
        window.open("./?method=edit&id=" + id, "_self");
    }
    function showConfirm() {
        $("#confirmDialog").modal("show");
        $("#confirmMsg").text("确定要删除信息");
    }
    function removeinformation_content() {
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

    function viewinformation_content(){
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
                if(data.user)
                    $("#author").text(data.user.name);
                $("#releasedDate").text(data.releasedDate);
                $("#title").text(data.title);
                $("#content").html(decodeHTML(data.content));
                var value = data.infoType.split("|")[3];
                $("#infoType").text(value);
                if(data.attachment){
                    var download = $("<a href='./download/" + data.id + "/attachment' target='_blank'>下载附件</a>");
                    $("#attachment").append(download);
                }

            }
        });
    }
    $(document).ready(function(){
        viewinformation_content();
    });
</script>
