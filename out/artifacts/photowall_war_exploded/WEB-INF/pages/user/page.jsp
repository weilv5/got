<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<div class="caption">当前位置&nbsp;>&nbsp;<span>用户管理</span></div>
<div class="row mt">
    <div class="col-lg-12">
        <div id="treeDiv" style="width: 22%; overflow: auto;float: left;margin-left:1%;margin-right:1%;"></div>
        <div class="ptlist" style="width: 75%; overflow: auto;float: right;">

                <div class="form-horizontal style-form">

                    <div class="form-group col-lg-12">
                        <label class="col-lg-2 control-label">姓名：</label>
                        <div class="col-lg-4">
                            <input id="name"
                                   name="name"
                                   type="text"
                                   class="form-control">
                        </div>
                    </div>
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">性别：</label>
                        <div class="col-lg-8">
                            <select id="gender"
                                    name="gender"
                                    class="form-control">
                                <option value=""></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">禁用用户：</label>
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
                        <button type="button" class="btn_icon1" onclick="adduser();">添加</button>&nbsp;&nbsp;<button type="button" class="btn_icon2" onclick="queryuser(1, 10);">搜索</button>
                    </div>
                </div>

            <table class="table table-hover table-striped  table_style1 " style="width: 100%;">
                <thead style="background:#f3f3f3;">
                    <tr>
                        <th>#</th>
                        <th>姓名</th>
                        <th>性别</th>
                        <th>用户名</th>
                    </tr>
                </thead>
                <tbody id="userTable">
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
<script src="${ctxPath}/resources/js/bootstrap-treeview.min.js"></script>
<script src="${ctxPath}/resources/js/dept.js"></script>
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

        $("#treeDiv").deptTree({
            url: "${ctxPath}/deptList",
            onclick: getUser
        });

        loadDictionary("select", "gender", "DataDictionary", "gender", "");
    });

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

    function getUser(node){
        if(node && node.id)
            window.deptId = node.id;
        else
            window.deptId = null;
        queryuser(1, 10);
    }

    function queryuser(page, size){
        $(".progress").show();
        $("#userTable").empty();
        var data = {
            enable: $("#enable").val(),
            page: page-1,
            size: size
        };
        if(window.deptId && window.deptId != "root")
            data.deptId = window.deptId;
        if($("#name").val()!="")
            data.name = $("#name").val();
        if($("#gender").val()!="")
            data.gender = $("#gender").val();
        var dt = (new Date()).getTime();
        data.dt = dt;
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
                        loadData: queryuser
                    });
                }
                if(length==0)
                    $("#nodata").show();
                else
                    $("#nodata").hide();
                for(var i = 0; i < length; i++){
                    var user = data.content[i];
                    var tr = $("<tr ></tr>");
                    var no = i + data.size * data.number + 1;
                    tr.append($("<td><a href='#' onclick='viewuser(\"" + user.id + "\")'> " + no + "</a></td>"));
                    var tdname = $("<td>" + user.name + "</td>");
                    tr.append(tdname);
                    var value = user.gender.split("|")[3];
                    var tdgender = $("<td>" + value + "</td>");
                    tr.append(tdgender);
                    var tduser_id = $("<td>" + user.userId + "</td>");
                    tr.append(tduser_id);

                    $("#userTable").append(tr);
                }
            }
        });
    }

    function viewuser(id){
        window.open("./?method=view&id=" + id, "_self");
    }

    function adduser(){
        window.open("./?method=edit", "_self");
    }
</script>