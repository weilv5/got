<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
                    <div class="caption">当前位置&nbsp;>&nbsp;<span><c:if test="${empty id}">添加</c:if><c:if test="${not empty id}">修改</c:if>数据字典</span></div>

                        <div class="col-lg-12">
                            <div class="form-panel col-lg-12">
                                <form class="form-horizontal style-form" id="data_dictionaryForm">
                                    <input id="id" name="id" type="hidden" >
                                    <input id="CSRFToken" name="CSRFToken" type="hidden" value="${CSRFToken}">
                                    <div class="form-group" id="propertyDivdictionaryCode">
                                        <label class="col-sm-2 col-sm-2 control-label">分类：</label>
                                        <div class="col-sm-10">
                                            <input id="dictionaryCode"
                                                   name="dictionaryCode"
                                                   type="text"
                                                   class="form-control" >
                                        </div>
                                    </div>
                                    <div class="form-group" id="propertyDivcontent" style="display: none;">
                                        <label class="col-sm-2 col-sm-2 control-label">数据内容：</label>
                                        <div class="col-sm-10">
                                            <input id="content"
                                                   name="content"
                                                   type="text"
                                                   class="form-control" >
                                        </div>
                                    </div>
                                    <div class="text-center">
                                        <button type="submit" class="btn btn-primary " >提交</button>&nbsp;&nbsp;
                                        <button type="button" class="btn btn-default" onclick='backToList()'>返回</button>
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
<%@include file="../footer.jsp"%>
<script>
    function backToList() {
        window.open("./?method=page", "_self");
    }

    function savedata_dictionary(){
        <c:if test="${empty id}">var url = "./save";</c:if>
        <c:if test="${not empty id}">var url = "./update";</c:if>
        $("#data_dictionaryForm").ajaxSubmit({
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

    function viewdata_dictionary(){
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
                $("#dictionaryCode").val(data.dictionaryCode);
                $("#content").val(data.content);
            }
        });
    }
    $(document).ready(function(){
        $("#data_dictionaryForm").bootstrapValidator({
            fields: {
                dictionaryCode: {
                    validators: {
                        notEmpty: {
                            message: '分类不能为空'
                        },
                        stringLength: {
                            max: 30,
                            message: '分类长度不能超过30位'
                        },
                    }
                }
            }
        }).on('success.form.bv', function(e) {
            e.preventDefault();
            savedata_dictionary();
        });
        $("#data_dictionaryForm").on("submit", function(e){
            e.preventDefault();
        });
        viewdata_dictionary();
    });

    function backToList() {
        window.open("./?method=page", "_self");
    }
</script>
