<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>

<div class="caption">当前位置&nbsp;>&nbsp;<span>信息列表</span></div>
<div class="row mt">
    <div class="col-lg-12">
        <div class="ptlist" style="margin-left:1%;">
            <div class="form-horizontal style-form">
            <div class="form-group col-lg-12">
                <label class="col-lg-2 control-label">发布日期：</label>
                <div class="col-lg-4">
                    <input id="releasedDateStart"
                                   name="releasedDateStart"
                                   type="text"
                                   class="form-control datetime" >
                </div>
                <div class="col-lg-1 text-center" style="margin-top: 7px;">~</div>
                <div class="col-lg-4">
                    <input id="releasedDateEnd"
                                   name="releasedDateEnd"
                                   type="text"
                                   class="form-control datetime" ><br>
                </div>
            </div>
            <div class="form-group col-lg-6">
                <label class="col-lg-4 control-label">标题：</label>
                <div class="col-lg-8">
                    <input id="title"
                                   name="title"
                                   type="text"
                                   class="form-control" >
                </div>
            </div>
            <div class="form-group col-lg-6">
                <label class="col-lg-4 control-label">信息类别：</label>
                <div class="col-lg-8">
                    <select id="infoType"
                                    name="infoType"
                                    class="form-control">
                        <option value=""></option>
                    </select>

                </div>
            </div>
                <div class="text-center col-lg-12" style="margin-bottom: 20px;">
                        <button type="button" class="btn_icon1 " onclick="addinformation_content();">添加</button>&nbsp;&nbsp;<button type="button" class="btn_icon2 " onclick="queryinformation_content(1, 10);">搜索</button>
                </div>
            </div>

            <table class="table table-hover table-striped table_style1" style="width: 100%;">
                <thead style="background:#f3f3f3;">
                    <tr>
                        <th>#</th>
                        <th>发布日期</th>
                        <th>标题</th>
                        <th>信息类别</th>
                        <th>发布者</th>
                    </tr>
                </thead>
                <tbody id="information_contentTable">
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
                <h4 class="modal-title" >提示</h4>
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
        queryinformation_content(1, 10);

    loadDictionary("select", "infoType", "DataDictionary", "info_type", "", "single");
    });

    function queryinformation_content(page, size){
        $(".progress").show();
        $("#information_contentTable").empty();
        var data = {
            page: page-1,
            size: size
        };
        if($("#releasedDateStart").val()!="")
            data.releasedDateStart = $("#releasedDateStart").val();
        if($("#releasedDateEnd").val()!="")
            data.releasedDateEnd = $("#releasedDateEnd").val();
        if($("#title").val()!="")
            data.title = $("#title").val();
        if($("#infoType").val()!="")
            data.infoType = $("#infoType").val();
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
                        loadData: queryinformation_content
                    });
                }
                if(length==0)
                    $("#nodata").show();
                else
                    $("#nodata").hide();
                for(var i = 0; i < length; i++){
                    var information_content = data.content[i];
                    var tr = $("<tr ></tr>");
                    var no = i + data.size * data.number + 1;
                    tr.append($("<td><a href='#' onclick='viewinformation_content(\"" + information_content.id + "\")'> " + no + "</a></td>"));
                    var tdreleased_date = $("<td>" + information_content.releasedDate + "</td>");
                    tr.append(tdreleased_date);
                    var tdtitle = $("<td>" + information_content.title + "</td>");
                    tr.append(tdtitle);
                    var value = information_content.infoType.split("|")[3];
                    var tdinfo_type = $("<td>" + value + "</td>");
                    tr.append(tdinfo_type);
                    if(information_content.name)
                        var tdid = $("<td>" + information_content.name + "</td>");
                    else
                        var tdid = $("<td></td>");
                    tr.append(tdid);

                    $("#information_contentTable").append(tr);
                }
            }
        });
    }

    function viewinformation_content(id){
        window.open("./?method=view&id=" + id, "_self");
    }

    function addinformation_content(){
        window.open("./?method=edit", "_self");
    }

    function backToList() {
        window.open("./?method=page", "_self");
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
</script>