<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<link rel="stylesheet" href="${ctxPath}/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.core.js"></script>
<div class="layui-row layui-col-space10">
    <div class="layui-col-xs12 layui-col-sm2 layui-col-md2">
        <!-- tree -->
       <%-- <ul id="roleTree" class="tree-table-tree-box" lay-filter="roleTree"></ul>--%>
        <ul id="tree" class="ztree"></ul>
    </div>
    <div class="layui-col-xs12 layui-col-sm10 layui-col-md10">
        <!-- 工具集 -->
        <div class="my-btn-box">
            <span class="fl">
                <a class="layui-btn layui-btn-danger" id="btn-delete-all">批量删除</a>
                <a class="layui-btn btn-default btn-add" id="btn-add">添加</a>
            </span>
            <span class="fr">
                <span class="layui-form-label">角色名：</span>
                <div class="layui-input-inline">
                    <input type="text" id="roleName" name="roleName" autocomplete="off" placeholder="请输入角色名" class="layui-input">
                </div>
                <button class="layui-btn mgl-20" id="searchBtn">查询</button>
            </span>
        </div>
        <!-- table -->
        <div id="roleTable" lay-filter="roleTable"></div>
    </div>
</div>

<script>
    // layui方法
    layui.use(['tree', 'table', 'form', 'layer'], function () {
        var parentRoleId = "";
        var form = layui.form
            , table = layui.table
            , layer = layui.layer
            , tree = layui.tree
            , $ = layui.jquery;

        window.loadRole = function(){
            var where = {};
            if($("#roleName").val()!=""){
                where.roleName = $("#roleName").val();
            }
            if(parentRoleId)
                where.parentRoleId = parentRoleId;

            var tableIns = table.render({
                elem: '#roleTable'
                ,height: 'full-70'
                , cols: [[
                    {checkbox: true,  fixed: true}
                    , {field: 'roleName', title: '角色名称', width: 120}
                    , {field: 'backup', title: '备注', width: 120}
                    , {fixed: 'right', title: '操作', width: 400, align: 'center', toolbar: '#barOption'}
                ]]
                , url: './page'
                , method: 'post'
                , page: true
                , request: {
                    limitName: "size"
                }
                , response: {
                    countName: "totalElements",
                    dataName: "content"
                }
                , limits: [30, 60, 90, 150, 300]
                , limit: 30
                , where: where
            });
        }

        loadRole();




        table.on('tool(roleTable)', function(obj){
            var data = obj.data
                ,layEvent = obj.event;
            if(layEvent == "detail"){
                openLayer("${ctxPath}/role/?method=view&id="+data.id,"查看角色","800px","510px");
            }else if(layEvent == "edit"){
                openLayer("${ctxPath}/role/?method=edit&id="+data.id,"编辑角色","800px","510px");
            }else if(layEvent == "del"){
                parent.layui.layer.confirm("确定要删除选择的数据？",{icon:3,title:'提示'},function(index){
                    parent.layui.layer.close(index);
                    parent.layui.layer.load(3,{time:1000});
                    $.ajax({
                        url:"./delete/"+data.id,
                        type:"post",
                        dataType:"json",
                        success:function(data){
                            if(data.responseCode==0){
                                parent.layui.layer.msg("删除成功");
                                loadRole();
                            }else{
                                parent.layui.layer.msg(data.msg);
                            }
                        }
                    });
                });

            }else if(layEvent == "userrole"){
                parent.layui.layer.open({
                    type: 2,
                    title:'用户',
                    area: ['500px', '300px'],
                    content: '${ctxPath}/role/?method=userlist',
                    zIndex: parent.layui.layer.zIndex,
                    cancel: function (index, layero) {
                        parent.layer.close(index);
                        return false;
                    }
                });
            }else if(layEvent == "modulerole"){
                parent.layui.layer.open({
                    type: 2,
                    title:'模块',
                    area: ['350px', '400px'],
                    content: '${ctxPath}/role/?method=modulelist',
                    zIndex: parent.layui.layer.zIndex,
                    cancel: function (index, layero) {
                        parent.layer.close(index);
                        return false;
                    }
                });
            }else if(layEvent == "deptrole"){
                parent.layui.layer.open({
                    type: 2,
                    title:'部门',
                    area: ['500px', '300px'],
                    content: '${ctxPath}/role/?method=deptlist',
                    zIndex: parent.layui.layer.zIndex,
                    cancel: function (index, layero) {
                        parent.layer.close(index);
                        return false;
                    }
                });
            }
        });

        //批量删除
        $("#btn-delete-all").on('click', function () {
            var checkStatus = table.checkStatus('roleTable');
            if(checkStatus.data.length==0){
                parent.layui.layer.msg("请选择需要删除的数据");
            }else{
                layer.confirm("确定要删除选择的数据？",{icon:3,title:'提示'},function(index){
                    var ids = "";
                    for (var i = 0; i < checkStatus.data.length; i++) {
                        ids = ids + checkStatus.data[i].id + ","
                    }
                    console.log(JSON.stringify(ids))
                    $.ajax({
                        url: "./delete",
                        type: "post",
                        data: {"ids": ids},
                        dataType: 'json',
                        success: function (data) {
                            if (data.responseCode == 0) {
                                parent.layui.layer.msg("删除成功");
                                loadRole();
                            } else {
                                parent.layui.layer.msg(data.msg);
                            }
                        }
                    })
                    layer.close(index);
                });

            }
        });

        //添加
        $("#btn-add").on('click', function(){
            openLayer("${ctxPath}/role/?method=edit","新增角色","800px","510px");
        });

        //查询
        $("#searchBtn").on('click', function(){
            loadRole();
        });

        //树形菜单
        var zTreeObj;
        var setting = {
            view: {
                dblClickExpand: false,
                showLine: true,
                showIcon:true
            },
            callback: {
                onClick:ztreeOnAsyncSuccess
            },
            async: {
                enable: true,
                url: "${ctxPath}/role/list",
                autoParam:["parentRoleId"],
                contentType: "application/json",
                otherParam: {}
            },
            data: {
                key: {
                    name: "roleName"
                },
                simpleData: {
                    enable: true,
                    idKey: "id", // id编号命名
                    pIdKey: "parentRoleId", // 父id编号命名
                    rootPId: 0//根节点
                }
            },


        };
        function ztreeOnAsyncSuccess(event, treeId, treeNode){
            parentRoleId = treeNode.id;
            loadRole();
            var treeObj = $.fn.zTree.getZTreeObj(treeId);
            var node = treeObj.getNodeByTId(treeNode.tId);
            if(node.children == null || node.children == "undefined") {
                $.ajax({
                    type: "post",
                    url: "${ctxPath}/role/list",
                    data: {
                        parentRoleId: treeNode.id
                    },
                    dataType: "json",
                    async: true,
                    success: function (res) {
                        var arr = [];
                        if (res != null && res.length > 0) {
                            var length = res.length;
                            for (var i = 0; i < length; i++) {
                                arr.push({
                                    roleName: res[i].roleName,
                                    id: res[i].id
                                })
                            }
                            zTreeObj.addNodes(treeNode, arr, true);

                            zTreeObj.expandNode(treeNode, true, false, false);// 将新获取的子节点展开
                        }
                    }
                });
            }

        }
        // zTree 树形菜单
        var zNodes = [{
            roleName: "系统角色"
        }];
        zTreeObj = $.fn.zTree.init($("#tree"), setting, zNodes);
        var rootNode = zTreeObj.getNodeByParam("roleName", "系统角色");
        $("#"+rootNode.tId+"_a").click();
    });
</script>
<script type="text/html" id="barOption">
    <a class="layui-btn layui-btn-mini" lay-event="detail">配置</a>
    <a class="layui-btn layui-btn-mini layui-btn-normal" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-mini layui-btn-danger" lay-event="del">删除</a>
    <%--<a class="layui-btn layui-btn-mini" lay-event="userrole">用户</a>--%>
    <%--<a class="layui-btn layui-btn-mini" lay-event="modulerole">模块</a>--%>
    <%--<a class="layui-btn layui-btn-mini" lay-event="deptrole">部门</a>--%>
</script>

<%@include file="../footer.jsp"%>