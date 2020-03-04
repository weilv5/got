<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
                    <div class="caption">当前位置&nbsp;>&nbsp;<span><c:if test="${empty id}">添加</c:if><c:if test="${not empty id}">修改</c:if>敏感词</span></div>

                        <div class="col-lg-12">
                            <div class="col-lg-12 form-panel" >
                                <form class="form-horizontal style-form" id="sensitive_wordsForm">
                                    <input id="id" name="id" type="hidden" >
                                    <input name="CSRFToken" type="hidden" value="${CSRFToken}">
                                    <div class="form-group col-lg-12" id="propertyDivwords">
                                        <label class="col-lg-2 control-label">敏感词：</label>
                                        <div class="col-lg-10">
                                            <input id="words"
                                                   name="words"
                                                   type="text"
                                                   class="form-control" >
                                        </div>
                                    </div>
                                    <div class="text-center col-lg-12">
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

    function savesensitive_words(){
        <c:if test="${empty id}">var url = "./save";</c:if>
        <c:if test="${not empty id}">var url = "./update";</c:if>
        $("#sensitive_wordsForm").ajaxSubmit({
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
                $("#words").val(data.words);
            }
        });

    }
    $(document).ready(function(){
        $("#sensitive_wordsForm").bootstrapValidator({
            fields: {
                words: {
                    validators: {
                        notEmpty: {
                            message: '敏感词不能为空'
                        },
                        stringLength: {
                            max: 20,
                            message: '敏感词长度不能超过20位'
                        }
                    }
                }
            }
        }).on('success.form.bv', function(e) {
            e.preventDefault();
            savesensitive_words();
        });
        $("#sensitive_wordsForm").on("submit", function(e){
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
        viewsensitive_words();

    });


    function backToList() {
        window.open("./?method=page", "_self");
    }
</script>
