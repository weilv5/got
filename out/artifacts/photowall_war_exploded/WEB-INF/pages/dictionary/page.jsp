<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<div class="caption">当前位置&nbsp;>&nbsp;<span>数据字典管理</span></div>
<div class="row mt">
    <div class="col-lg-12">
        <div class="ptlist" style="margin-left:1%;">
            <%--<h4><i class="fa fa-angle-right"></i> 数据字典列表</h4>--%>
            <section>
            <div class="caption2"><i class="fa fa-angle-right"></i> 数据分类列表</div>
                <div class="form-horizontal style-form" >
                <div class="form-group col-lg-12">

                        <label class="col-lg-2 control-label">分类:</label>
                        <div class="col-lg-10">
                            <input id="dictionaryCode"
                                   name="dictionaryCode"
                                   type="text"
                                   class="form-control" >
                        </div>
                </div>
                    <div class="text-center" style="margin-bottom: 20px;">
                        <button type="button" class="btn_icon1" onclick="adddata_dictionary();">添加</button>&nbsp;&nbsp;<button type="button" class="btn_icon2" onclick="querydata_dictionary(1, 10);">搜索</button>
                    </div>
                </div>
            </section>
            <section>
                <table class="table table-hover table-striped table_style1" style="width: 100%;">
                    <thead style="background:#f3f3f3;">
                    <tr>
                        <th>#</th>
                        <th>分类</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody id="data_dictionaryTable">
                    </tbody>
                </table>
            </section>
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
            format: "yyyy-MM-dd"
        });
        $('.datetime').datetimepicker({
            locale: 'zh-cn',
            format: "yyyy-MM-dd HH:mm:ss"
        });
        window.currProcess = 0;
        window.intervalId = setInterval(function(){
            window.currProcess += 5;
            $(".progress-bar").width(window.currProcess+"%");
            $(".progress-bar").attr("aria-valuenow", window.currProcess);
            if(window.currProcess==100)
                window.currProcess = 0;
        }, 1000);
        querydata_dictionary(1, 10);
    });

    function querydata_dictionary(page, size){
        $(".progress").show();
        $("#data_dictionaryTable").empty();
        var data = {
            page: page-1,
            size: size
        };
        if($("#dictionaryCode").val()!="")
            data.dictionaryCode = $("#dictionaryCode").val();
        if($("#content").val()!="")
            data.content = $("#content").val();
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
                        loadData: querydata_dictionary
                    });
                }
                if(length==0)
                    $("#nodata").show();
                else
                    $("#nodata").hide();
                for(var i = 0; i < length; i++){
                    var data_dictionary = data.content[i];
                    var tr = $("<tr ></tr>");
                    var no = i + data.size * data.number + 1;
                    tr.append($("<td>" + no + "</td>"));
                    var tddictionary_code = $("<td>" + data_dictionary.dictionaryCode + "</td>");
                    tr.append(tddictionary_code);
                    var tddictionary_code = $("<td><a href='#' class='btn btn-default' onclick='viewdata_dictionary(\"" + data_dictionary.id + "\")'>查看字典数据</a></td>");
                    tr.append(tddictionary_code);
                    $("#data_dictionaryTable").append(tr);
                }
            }
        });
    }

    function viewdata_dictionary(id){
        window.open("./?method=view&id=" + id, "_self");
    }

    function adddata_dictionary(){
        window.open("./?method=edit", "_self");
    }

    function backToList() {
        window.open("./?method=page", "_self");
    }
</script>