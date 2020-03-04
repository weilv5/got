<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<link rel="stylesheet" href="${ctxPath}/resources/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${ctxPath}/resources/ztree/js/jquery.ztree.core.js"></script>

<div class="layui-row layui-col-space10">
    <div class="layui-col-xs2 layui-col-sm2 layui-col-md2">
        <!-- tree -->
       <%-- <ul id="userTree" class="tree-table-tree-box" lay-filter="userTree"></ul>--%>
        <ul id="tree" class="ztree"></ul>
    </div>
    <div class="layui-col-xs10 layui-col-sm10 layui-col-md10">
        <!-- 工具集 -->
        <div class="my-btn-box">
            <span class="fl">
                <a class="layui-btn layui-btn-danger" id="btn-delete-all">批量删除</a>
                <a class="layui-btn btn-default btn-add" id="btn-add">添加</a>
            </span>
            <span class="fr">
                <span class="layui-form-label">姓名：</span>
                <div class="layui-input-inline">
                    <input type="text" id="name" autocomplete="off" placeholder="请输入姓名" class="layui-input">
                </div>
                <button class="layui-btn mgl-20" id="searchBtn">查询</button>
            </span>
            <span class="fr">
                 <span class="layui-form-label">禁用用户：</span>
                <div class="layui-input-inline">
                    <select id="enable"
                            name="enable"
                            class="layui-select" style="width: 100px;">
                                <option value="0">显示</option>
                                <option value="1" selected>不显示</option>
                            </select>
                </div>
            </span>
        </div>
        <!-- table -->
        <div id="userTable" lay-filter="userTable"></div>
    </div>
</div>

<script>
    // layui方法
    layui.use(['tree', 'table', 'form', 'layer'], function () {
        var parentDeptId = "";
        var form = layui.form
            , table = layui.table
            , layer = layui.layer
            , tree = layui.tree
            , $ = layui.jquery;



        window.loadUser = function(){
            var where = {};
            console.info($("#name").val());
            if($("#name").val()!=""){
                where.name = $("#name").val();
            }
            if($("#enable").val()!=""){
                where.enable = $("#enable").val();
            }

            if(parentDeptId)
                where.deptId = parentDeptId;

            var tableIns = table.render({
                elem: '#userTable'
                ,height: 'full-70'
                , cols: [[
                    {checkbox: true,  fixed: true}
                    , {field: 'name', title: '姓名', width: 120}
                    , {field: 'gender', title: '性别', width: 120,templet: function(d){
                        var info = d.gender.split("|");
                        return info[info.length - 1];
                    }}
                    , {field: 'userId', title: '用户名', width: 120}
                    , {fixed: 'right', title: '操作', width: 300, align: 'center', toolbar: '#barOption'}
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
        loadUser();

        table.on('tool(userTable)', function(obj){
            var data = obj.data
                ,layEvent = obj.event;
            if(layEvent == "detail"){
                openLayer("${ctxPath}/user/?method=view&id="+data.id,"查看详情","800px","600px")
            }else if(layEvent == "edit"){
                openLayer("${ctxPath}/user/?method=edit&id="+data.id,"编辑用户","800px","600px")
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
                                loadUser();
                            }else{
                                parent.layui.layer.msg(data.msg);
                            }
                        }
                    });

                });
            }
        });

        //批量删除
        $("#btn-delete-all").on('click',function () {
            var checkStatus = table.checkStatus('userTable');
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
                               loadUser();
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
            openLayer("${ctxPath}/user/?method=edit","新增用户",'800px','600px');
        });

        //查询
        $("#searchBtn").on('click', function(){
            loadUser();
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
                url: "${ctxPath}/deptList",
                autoParam:["parentDeptId"],
                contentType: "application/json",
                otherParam: {}
            },
            data: {
                key: {
                    name: "deptName"
                },
                simpleData: {
                    enable: true,
                    idKey: "id", // id编号命名
                    pIdKey: "parentDeptId", // 父id编号命名
                    rootPId: 0//根节点
                }
            },


        };
        function ztreeOnAsyncSuccess(event, treeId, treeNode){
            parentDeptId = treeNode.id;
            loadUser();
            var treeObj = $.fn.zTree.getZTreeObj(treeId);
            var node = treeObj.getNodeByTId(treeNode.tId);
            if(node.children == null || node.children == "undefined") {
                $.ajax({
                    type: "post",
                    url: "${ctxPath}/deptList",
                    data: {
                        parentDeptId: treeNode.id
                    },
                    dataType: "json",
                    async: true,
                    success: function (res) {
                        var arr = [];
                        if (res != null && res.length > 0) {
                            var length = res.length;
                            for (var i = 0; i < length; i++) {
                                arr.push({
                                    deptName: res[i].deptName,
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
            deptName: "组织结构"
        }];
        zTreeObj = $.fn.zTree.init($("#tree"), setting, zNodes);
        var rootNode = zTreeObj.getNodeByParam("deptName", "组织结构");
        $("#"+rootNode.tId+"_a").click();
    });
</script>
<script type="text/html" id="barOption">
    <a class="layui-btn layui-btn-mini" lay-event="detail">查看</a>
    <a class="layui-btn layui-btn-mini layui-btn-normal" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-mini layui-btn-danger" lay-event="del">删除</a>
</script>

<%@include file="../footer.jsp"%>