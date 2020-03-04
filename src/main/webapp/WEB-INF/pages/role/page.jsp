<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>

<div class="caption">当前位置&nbsp;>&nbsp;<span>角色管理</span></div>
<div class="row mt">
    <div class="col-lg-12">
        <div id="treeDiv" style="width: 22%; overflow: auto;float: left;margin-left:1%;margin-right:1%;"></div>
        <div class="ptlist" style="width: 76%; overflow: auto;float: right;">

            <div class="form-horizontal style-form" style="width: 100%;">
                <div class="form-group col-lg-12">
                    <label class="col-lg-2 control-label">角色名称：</label>
                    <div class="col-lg-10">
                        <input id="roleName"
                                   name="roleName"
                                   type="text"
                                   class="form-control" >
                    </div>
                </div>

                <div class="text-center col-lg-12" style="margin-bottom: 20px;">
                    <button type="button" class="btn_icon1" onclick="addrole();">添加</button>&nbsp;&nbsp;<button type="button" class="btn_icon2 " onclick="queryrole(1, 10);">搜索</button>
                </div>
            </div>

            <table class="table table-hover table-striped  table_style1 " style="width: 100%;">
                <thead style="background:#f3f3f3;">
                    <tr>
                        <th>#</th>
                        <th>角色名称</th>
                        <th>备注</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody id="roleTable">
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


<div class="modal fade" id="userModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">用户列表</h4>
            </div>
            <div class="modal-body" >
                <section>
                    <table class="table table-hover table-striped  table_style1" style="width: 96%;margin: 0 2%;">
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
                </section>
                <div class="text-center" id="user_nodata" style="display: none;">
                    没有数据
                </div>
                <div class=" progress" id="user_progress" style="position: relative;width: 80%;left: 10%;margin: 10px 0px;">
                    <div  class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">

                    </div>
                </div>
                <div class="text-center" id="user_pager" style="display: none;">
                </div>
            </div>
            <div class="modal-footer" >
                <button type="button"  class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="deptModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">部门列表</h4>
            </div>
            <div class="modal-body" >
                <section>
                    <table class="table table-hover table-striped  table_style1" style="width: 96%;margin: 0 2%;">
                        <thead style="background:#f3f3f3;">
                        <tr>
                            <th>#</th>
                            <th>部门名称</th>
                            <th>部门编码</th>
                        </tr>
                        </thead>
                        <tbody id="deptTable">
                        </tbody>
                    </table>
                </section>
                <div class="text-center" id="dept_nodata" style="display: none;">
                    没有数据
                </div>
                <div class=" progress" id="dept_progress" style="position: relative;width: 80%;left: 10%;margin: 10px 0px;">
                    <div  class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">

                    </div>
                </div>
                <div class="text-center" id="dept_pager" style="display: none;">
                </div>
            </div>
            <div class="modal-footer" >
                <button type="button"  class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="moduleModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">模块</h4>
            </div>
            <div class="modal-body" >
                <section>
                    <div id="moduleTree"></div>
                </section>
            </div>
            <div class="modal-footer" >
                <button type="button"  class="btn btn-primary" onclick="setModule()">确认</button>
                <button type="button"  class="btn btn-default" data-dismiss="modal">关闭</button>
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
<script src="${ctxPath}/resources/js/role.js"></script>
<script>
    $(document).ready(function(){
        window.currProcess = 0;
        window.intervalId = setInterval(function(){
            window.currProcess += 5;
            $(".progress-bar").width(window.currProcess+"%");
            $(".progress-bar").attr("aria-valuenow", window.currProcess);
            if(window.currProcess==100)
                window.currProcess = 0;
        }, 1000);
        $("#treeDiv").roleTree({
            url: "${ctxPath}/role/list",
            onclick: getChildRole
        });

    });
    function getChildRole(node){
        if(node && node.id )
            window.selectedNodeId = node.id;
        queryrole(1, 10);
    }
    function queryrole(page, size){
        $(".progress").show();
        $("#roleTable").empty();
        var data = {
            page: page-1,
            size: size
        };

        if(window.selectedNodeId && window.selectedNodeId != "root")
            data.parentRoleId = window.selectedNodeId;
        if($("#roleName").val()!="")
            data.roleName = $("#roleName").val();

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
                        loadData: queryrole
                    });
                }
                if(length==0)
                    $("#nodata").show();
                else
                    $("#nodata").hide();
                for(var i = 0; i < length; i++){
                    var role = data.content[i];
                    var tr = $("<tr ></tr>");
                    var no = i + data.size * data.number + 1;
                    tr.append($("<td><a href='#' onclick='viewrole(\"" + role.id + "\")'> " + no + "</a></td>"));

                    var tdrole_name = $("<td>" + role.roleName + "</td>");
                    tr.append(tdrole_name);
                    var tdbackup = $("<td>" + role.backup + "</td>");
                    tr.append(tdbackup);

                    var user = $("<td><a href='#' class='btn btn-primary small' onclick='viewUser(\"" + role.id + "\")'><span class='glyphicon glyphicon-eye-open'></span> 查看用户</a>&nbsp;&nbsp;<a href='#' class='btn btn-primary small' onclick='viewDept(\"" + role.id + "\")'><span class='glyphicon glyphicon-eye-open'></span> 查看部门</a>&nbsp;&nbsp;<a href='#' class='btn btn-primary small' onclick='viewModule(\"" + role.id + "\",\"" + role.parentRoleId + "\")'><span class='glyphicon glyphicon-eye-open'></span> 查看模块</a></td>");
                    tr.append(user);
                    $("#roleTable").append(tr);
                }
            }
        });
    }

    function viewUser(id){
        window.roleId = id;
        $("#userModal").modal("show");
        queryuser(1, 10);
    }

    function queryuser(page, size){
        $("#user_progress").show();
        $("#userTable").empty();
        var data = {
            page: page-1,
            size: size
        };
        if(window.roleId)
            data["role.id"] = window.roleId;

        var dt = (new Date()).getTime();
        data.dt = dt;
        $.ajax({
            url: "${ctxPath}/user/page",
            dataType: "json",
            data: data,
            type: "post",
            success: function(data){
                $("#user_progress").hide();
                var length = data.content.length;
                if(data.totalPages==1)
                    $("#user_pager").hide();
                else {
                    $("#user_pager").show();
                    $("#user_pager").pagination({
                        size: data.size,
                        currPage: data.number+1,
                        totalPages: data.totalPages,
                        loadData: queryuser
                    });
                }
                if(length==0)
                    $("#user_nodata").show();
                else
                    $("#user_nodata").hide();
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
            },
            error: function(){
                $("#msg").text("获取用户失败");
                $('#alertModal').modal("show");
            }
        });
    }

    function viewuser(id){
        window.open("${ctxPath}/user/?method=view&id=" + id, "_blank");
    }

    function viewDept(id){
        window.roleId = id;
        $("#deptModal").modal("show");
        querydept(1, 10);
    }

    function querydept(page, size){
        $("#dept_progress").show();
        $("#deptTable").empty();
        var data = {
            page: page-1,
            size: size
        };
        if(window.roleId)
            data["role.id"] = window.roleId;
        var dt = (new Date()).getTime();
        data.dt = dt;
        $.ajax({
            url: "${ctxPath}/dept/page",
            dataType: "json",
            data: data,
            type: "post",
            success: function(data){
                $("#dept_progress").hide();
                var length = data.content.length;
                if(data.totalPages==1)
                    $("#dept_pager").hide();
                else {
                    $("#dept_pager").show();
                    $("#dept_pager").pagination({
                        size: data.size,
                        currPage: data.number+1,
                        totalPages: data.totalPages,
                        loadData: querydept
                    });
                }
                if(length==0)
                    $("#dept_nodata").show();
                else
                    $("#dept_nodata").hide();
                for(var i = 0; i < length; i++){
                    var department = data.content[i];
                    var tr = $("<tr ></tr>");
                    var no = i + data.size * data.number + 1;
                    tr.append($("<td><a href='#' onclick='viewdepartment(\"" + department.id + "\")'> " + no + "</a></td>"));
                    var tddept_name = $("<td>" + department.deptName + "</td>");
                    tr.append(tddept_name);
                    var tddept_code = $("<td>" + department.deptCode + "</td>");
                    tr.append(tddept_code);
                    $("#deptTable").append(tr);
                }
            },
            error: function(){
                $("#msg").text("获取用户失败");
                $('#alertModal').modal("show");
            }
        });
    }

    function viewdepartment(id){
        window.open("${ctxPath}/dept/?method=view&id=" + id, "_blank");
    }

    function viewModule(id, parentRoleId){
        $('#moduleTree').empty();
        window.roleId = id;
        $("#roleId").val("id");
        var data = {};
        window.moduleIdArr = [];
        var dt = (new Date()).getTime();
        data.dt = dt;
        data.roleId = id;
        if(parentRoleId && parentRoleId!="null")
            data.parentRoleId = parentRoleId;
        $("#moduleModal").modal("show");
        window.onlySetParent = false;
        $.ajax({
            url: "${ctxPath}/role/moduleTreeForRole",
            data: data,
            dataType: "json",
            type: "post",
            success: function(data){
                var tree = [];
                tree.push(data);
                getSelectedModule(data.nodes);
                $('#moduleTree').treeview({
                    data: tree,
                    showCheckbox: true,
                    onNodeChecked: function(event, node){
                        if(node.moduleId)
                            window.moduleIdArr.push(node.moduleId);
                        if(window.onlySetParent){
                            window.onlySetParent = false;
                            return;
                        }

                        $('#moduleTree').treeview('expandNode', [ node.nodeId]);
                        if(node.nodes){
                            var length = node.nodes.length;
                            for(var i = 0; i < length; i++)
                                $('#moduleTree').treeview('checkNode', node.nodes[i].nodeId);

                        }
                        var parentNode = $('#moduleTree').treeview('getParent', node);

                        if(parentNode){
                            window.onlySetParent = true;
                            $('#moduleTree').treeview('checkNode', parentNode.nodeId);
                        }
                    },
                    onNodeUnchecked: function(event, node){
                        if(node.moduleId){
                            var length = window.moduleIdArr.length;
                            for(var i = 0; i < length; i++){
                                if(window.moduleIdArr[i] === node.moduleId){
                                    window.moduleIdArr.splice(i, 1);
                                    break;
                                }
                            }
                        }
                        if(node.nodes){
                            var length = node.nodes.length;
                            for(var i = 0; i < length; i++)
                                $('#moduleTree').treeview('uncheckNode', node.nodes[i].nodeId);

                        }
                    }
                });
            },error: function(){
                $("#msg").text("获取模块失败");
                $('#alertModal').modal("show");
            }
        });
    }

    function getSelectedModule(nodes){
        if(!nodes)
            return;
        var length = nodes.length;
        for(var i = 0; i < length; i++){
            var node = nodes[i];
            if(node.state && node.state.checked)
                window.moduleIdArr.push(node.moduleId);
            getSelectedModule(node.nodes);
        }
    }

    function setModule() {
        $.ajax({
            type:"post",
            url: "${ctxPath}/role/saveModuleRole",
            data:{
                moduleIds: moduleIdArr,
                roleId: window.roleId
            },
            success: function(data){
                $("#moduleRoleForm").empty();
                if(data.responseCode==0){
                    $("#moduleModal").modal("hide");
                    $("#msg").text("提交成功");
                }else{
                    $("#msg").text(data.msg);
                    $("#closeBtn").show();
                }
                $('#alertModal').modal("show");
            },
            error: function () {
                $("#moduleRoleForm").empty();
                $("#msg").text("提交失败");
                $('#alertModal').modal("show");
            }
        });
    }

    function viewrole(id){
        window.open("./?method=view&id=" + id, "_self");
    }

    function addrole(){
        window.open("./?method=edit", "_self");
    }
</script>