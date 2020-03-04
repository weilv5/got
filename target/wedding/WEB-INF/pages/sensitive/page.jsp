<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>

<div class="caption">当前位置&nbsp;>&nbsp;<span>敏感词列表</span></div>
<div class="row mt">
    <div class="col-lg-12">
        <div class="ptlist" style="margin-left:1%;">
            <div class="form-horizontal style-form">
            <div class="form-group col-lg-12">
                <label class="col-lg-2 control-label">敏感词：</label>
                <div class="col-lg-10">
                    <input id="words"
                                   name="words"
                                   type="text"
                                   class="form-control" >
                </div>
            </div>
                <div class="text-center col-lg-12" style="margin-bottom: 20px;">
                    <form id="importForm">
                        <input type="file" id="sensitiveWords" name="sensitiveWords" accept="text/plain" style="display:none" onchange="importWords()">
                    </form>
                    <button type="button" class="btn_icon1 " onclick="syncWords();">同步</button>&nbsp;&nbsp;<button type="button" class="btn_icon1 " onclick="selectSensitiveWordsFile();">导入</button>&nbsp;&nbsp;<button type="button" class="btn_icon1 " onclick="addsensitive_words();">添加</button>&nbsp;&nbsp;<button type="button" class="btn_icon2 " onclick="querysensitive_words(1, 10);">搜索</button>
                </div>
            </div>

            <table class="table table-hover table-striped table_style1" style="width: 100%;">
                <thead style="background:#f3f3f3;">
                    <tr>
                        <th>#</th>
                        <th>敏感词</th>
                    </tr>
                </thead>
                <tbody id="sensitive_wordsTable">
                </tbody>
            </table>
            <div class="text-center" id="nodata" style="display: none;">
                没有数据
            </div>
            <div class=" progress" style="position: relative;width: 80%;left: 10%;margin: 10px 0px;">
                <div  class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">
                </div>
            </div>
            <div class="text-center" id="pager" style="display: none;">
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
<script>
    $(document).ready(function(){
        $('.date').datetimepicker({
            locale: 'zh-cn',
            format: "YYYY-MM-DD"
        });
        $('.datetime').datetimepicker({
            locale: 'zh-cn',
            format: "YYYY-MM-DD HH:mm:ss"
        });
        window.currProcess = 0;
        window.intervalId = setInterval(function(){
            window.currProcess += 5;
            $(".progress-bar").width(window.currProcess+"%");
            $(".progress-bar").attr("aria-valuenow", window.currProcess);
            if(window.currProcess==100)
                window.currProcess = 0;
        }, 1000);
        querysensitive_words(1, 10);

    });

    function selectSensitiveWordsFile(){
        document.getElementById("sensitiveWords").click();
    }
    function importWords() {
        $("#closeBtn").hide();
        $("#msg").text("正在导入敏感词，请稍后");
        $('#alertModal').modal("show");
        $("#importForm").ajaxSubmit({
            type: "post",
            url: "./import",
            success: function (data) {
                $("#msg").text(data.msg);
                if(data.responseCode==0){
                    $("#closeBtn").hide();
                    setTimeout(backToList, 1000)
                }else{
                    $("#closeBtn").show();
                }
                $('#alertModal').modal("show");
            }
        });
    }
    function syncWords() {
        $("#closeBtn").hide();
        $("#msg").text("正在同步敏感词，请稍后");
        $('#alertModal').modal("show");
        $.ajax({
            type: "post",
            url: "./sync",
            success: function (data) {
                $("#msg").text(data.msg);
                if(data.responseCode==0){
                    $("#closeBtn").hide();
                    setTimeout(backToList, 1000)
                }else{
                    $("#closeBtn").show();
                }
                $('#alertModal').modal("show");
            }
        });
    }
    function querysensitive_words(page, size){
        $(".progress").show();
        $("#sensitive_wordsTable").empty();
        var data = {
            page: page-1,
            size: size
        };
        if($("#words").val()!="")
            data.words = $("#words").val();
        $.ajax({
            url: "./page",
            dataType: "json",
            data: data,
            type: "post",
            success: function(data){
                $(".progress").hide();
                var length = data.content.length;
                if(data.totalPages==1)
                    $("#pager").hide();
                else {
                    $("#pager").show();
                    $("#pager").pagination({
                        totalRecords: data.totalElements,
                        size: data.size,
                        currPage: data.number+1,
                        totalPages: data.totalPages,
                        loadData: querysensitive_words
                    });
                }
                if(length==0)
                    $("#nodata").show();
                else
                    $("#nodata").hide();
                for(var i = 0; i < length; i++){
                    var sensitive_words = data.content[i];
                    var tr = $("<tr ></tr>");
                    var no = i + data.size * data.number + 1;
                    tr.append($("<td><a href='#' onclick='viewsensitive_words(\"" + sensitive_words.id + "\")'> " + no + "</a></td>"));

                    var tdwords = $("<td>" + sensitive_words.words + "</td>");
                    tr.append(tdwords);

                    $("#sensitive_wordsTable").append(tr);
                }
            }
        });
    }

    function viewsensitive_words(id){
        window.open("./?method=view&id=" + id, "_self");
    }

    function addsensitive_words(){
        window.open("./?method=edit", "_self");
    }

    function backToList() {
        window.open("./?method=page", "_self");
    }
</script>