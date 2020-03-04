<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>

<div class="caption">当前位置&nbsp;>&nbsp;<span>数据操作日志</span></div>
<div class="row mt">
    <div class="col-lg-12">
        <div class="ptlist" style="margin-left:1%;">
            <div class="form-horizontal style-form">

                <div class="form-group col-lg-4">
                    <label class="col-lg-5 control-label">操作者：</label>
                    <div class="col-lg-7">
                        <input id="operatorId"
                               name="operatorId"
                               type="text"
                               class="form-control" >
                    </div>
                </div>
                <div class="form-group col-lg-4">
                    <label class="col-lg-5 control-label">操作类名：</label>
                    <div class="col-lg-7">
                        <input id="className"
                               name="className"
                               type="text"
                               class="form-control" >
                    </div>
                </div>
                <div class="form-group col-lg-4">
                    <label class="col-lg-5 control-label">操作类型：</label>
                    <div class="col-lg-7">
                        <select id="opType"
                                name="opType"
                                class="form-control">
                            <option value=""></option>
                            <option value="0">新建</option>
                            <option value="1">更新</option>
                            <option value="2">删除</option>
                            <option value="3">读取</option>
                        </select>

                    </div>
                </div>
                <div class="form-group col-lg-12">
                    <label class="col-lg-2 control-label">操作日期：</label>
                    <div class="col-lg-4">
                        <input id="createdDateStart"
                               name="createdDateStart"
                               type="text"
                               class="form-control datetime" >
                    </div>
                    <div class="col-lg-1 text-center" style="margin-top: 7px;">~</div>
                    <div class="col-lg-4">
                        <input id="createdDateEnd"
                               name="createdDateEnd"
                               type="text"
                               class="form-control datetime" ><br>
                    </div>
                </div>
                <div class="text-center col-lg-12" style="margin-bottom: 20px;">
                    <button type="button" class="btn_icon2 " onclick="queryDatalog(1, 10);">搜索</button>
                </div>
            </div>

            <table class="table table-hover table-striped table_style1" style="width: 100%;">
                <thead style="background:#f3f3f3;">
                <tr>
                    <th class="col-lg-1">#</th>
                    <th class="col-lg-2">操作日期</th>
                    <th class="col-lg-2">操作者ID</th>
                    <th class="col-lg-2">操作者IP</th>
                    <th class="col-lg-2">操作实体名</th>
                    <th class="col-lg-2">操作类名</th>
                    <th class="col-lg-1">操作类型</th>
                    <%--<th class="col-lg-3">操作前数据</th>
                    <th class="col-lg-3">操作后数据</th>--%>
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
        queryDatalog(1, 10);
    });

    function queryDatalog(page, size){
        $(".progress").show();
        $("#information_contentTable").empty();
        var data = {
            page: page-1,
            size: size
        };
        if($("#createdDateStart").val()!="")
            data.createdDateStart = $("#createdDateStart").val();
        if($("#createdDateEnd").val()!="")
            data.createdDateEnd = $("#createdDateEnd").val();
        if($("#className").val()!="")
            data.className = $("#className").val();
        if($("#opType").val()!="")
            data.opType = $("#opType").val();
        if($("#operatorId").val()!="")
            data.operatorId = $("#operatorId").val();
        data.dt = (new Date()).getTime();
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
                        loadData: queryDatalog
                    });
                }
                if(length==0)
                    $("#nodata").show();
                else
                    $("#nodata").hide();
                for(var i = 0; i < length; i++){
                    var datalog = data.content[i];
                    var tr = $("<tr ></tr>");
                    var no = i + data.size * data.number + 1;
                    tr.append($("<td> <a href='###' >" + no + "</a></td>"));
                    var tdcreated_date = $("<td>" + datalog.createdDate + "</td>");
                    tr.append(tdcreated_date);
                    var tdid = $("<td>" + datalog.operatorId + "</td>");
                    tr.append(tdid);
                    var tdip = $("<td>" + datalog.operatorIp + "</td>");
                    tr.append(tdip);
                    var tdentityName = $("<td>" + datalog.entityName + "</td>");
                    tr.append(tdentityName);
                    var tdclassName = $("<td>" + datalog.className + "</td>");
                    tr.append(tdclassName);
                    var opType = "";
                    switch (datalog.entityChangeType){
                        case "CREATE":
                            opType = "新建";
                            break;
                        case "UPDATE":
                            opType = "更新";
                            break;
                        case "DELETE":
                            opType = "删除";
                            break;
                        case "READ":
                            opType = "读取";
                            break;
                        case "LOGIC_DEL":
                            opType = "逻辑删除";
                            break;
                        default:
                            opType = "其他";
                            break;
                    }
                    var tdopType = $("<td>" + opType + "</td>");
                    tr.append(tdopType);
                    tr.on("click", "a", datalog.id, function(e){
                        var id = e.data;
                        window.open("./?method=view&id=" + id, "_self");
                    });

                    $("#information_contentTable").append(tr);
                }
            }
        });
    }
</script>