<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<link href="${ctxPath}/resources/css/bootstrap-treeview.min.css" rel="stylesheet">
<div class="caption">当前位置&nbsp;>&nbsp;<span>部门管理</span></div>
<div class="row mt">
    <div class="col-lg-12">
        <div >
            <div id="treeDiv" style="width: 22%; overflow: auto;float: left;margin-left:1%;margin-right:1%;"></div>
            <div class="ptlist" style="width: 76%; overflow: auto;float: right;">

                    <div class="form-horizontal style-form">
                        <div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">部门名称:</label>
                            <div class="col-lg-8">
                                <input id="deptName"
                                       name="deptName"
                                       type="text"
                                       class="form-control" >
                            </div>
                        </div>
                        <div class="form-group col-lg-6">
                            <label class="col-lg-4 control-label">禁用部门：</label>
                            <div class="col-lg-8">
                                <select id="enable"
                                        name="enable"
                                        class="form-control">
                                    <option value="0">显示</option>
                                    <option value="1" selected>不显示</option>
                                </select>
                            </div>
                        </div>
                        <div class="text-center col-lg-12" style="margin-bottom: 20px;">
                            <button type="button" class="btn_icon1 " onclick="adddepartment();">添加</button>&nbsp;&nbsp;<button type="button" class="btn_icon2 " onclick="querydepartment(1, 10);">搜索</button>
                        </div>
                    </div>

                    <table class="table table-hover table-striped  table_style1 " style="width: 100%;">
                        <thead style="background:#f3f3f3;">
                        <tr>
                            <th>#</th>
                            <th>部门名称</th>
                            <th>部门编码</th>
                        </tr>
                        </thead>
                        <tbody id="departmentTable">
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
<script src="${ctxPath}/resources/js/bootstrap-treeview.min.js"></script>
<script src="${ctxPath}/resources/js/dept.js"></script>
<script>
    $(document).ready(function(){
        window.page = 1;
        window.size = 10;
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

        $("#treeDiv").deptTree({
            url: "${ctxPath}/deptList",
            onclick: getChildDept
        });
    });
    function getChildDept(node){
        if(node && node.id)
            window.selectedNodeId = node.id;
        querydepartment(1, 10);
    }
    function querydepartment(page, size){
        $(".progress").show();
        $("#departmentTable").empty();
        var data = {
            enable: $("#enable").val(),
            page: page-1,
            size: size
        };
        if($("#deptName").val()!="")
            data.deptName = $("#deptName").val();
        if(window.selectedNodeId && window.selectedNodeId != "root"){
            data.parentDeptId = window.selectedNodeId;
        }

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
                        loadData: querydepartment
                    });
                }
                if(length==0)
                    $("#nodata").show();
                else
                    $("#nodata").hide();
                for(var i = 0; i < length; i++){
                    var department = data.content[i];
                    var tr = $("<tr ></tr>");
                    var no = i + data.size * data.number + 1;
                    tr.append($("<td><a href='#' onclick='viewdepartment(\"" + department.id + "\")'> " + no + "</a></td>"));
                    var tddept_name = $("<td>" + department.deptName + "</td>");
                    tr.append(tddept_name);
                    var tddept_code = $("<td>" + department.deptCode + "</td>");
                    tr.append(tddept_code);
                    $("#departmentTable").append(tr);
                }
            }
        });
    }

    function viewdepartment(id){
        window.open("./?method=view&id=" + id, "_self");
    }

    function adddepartment(){
        window.open("./?method=edit", "_self");
    }

    function backToList() {
        window.open("./?method=page", "_self");
    }
</script>