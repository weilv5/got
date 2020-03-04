<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ include file="../header.jsp"%>
<%--工具集--%>
<div class="my-btn-box">
<span class="fl">
        <a class="layui-btn btn-default btn-add" id="doDeploy">部署流程</a>
    </span>
         <span class="fr">
          <button class="layui-btn mgl-20" id="searchBtn">查询</button>
      </span>
       <span class="fr">
           <span class="layui-form-label">流程编号：</span>
           <div class="layui-input-inline">
           <input type="text" id="processDefKey" autocomplete="off" placeholder="请输入流程编号" class="layui-input">
           </div>
       </span>
       <span class="fr">
          <span class="layui-form-label">流程名称：</span>
          <div class="layui-input-inline">
          <input type="text" id="processDefName" autocomplete="off" placeholder="请输入流程名称" class="layui-input">
          </div>
      </span>
</div>
<%--table--%>
<div id="processTable" lay-filter="processTable"></div>
<script>
    layui.use(['table', 'form', 'layer'], function () {
        var form = layui.form,
            onclick
        table = layui.table,
            layer = layui.layer,
            $ = layui.jquery;

        window.loadProcess = function () {
            var where = {};
            if ($("#processDefKey").val() != "") {
                where.processDefKey = $("#processDefKey").val();
            }
            if ($("#processDefName").val() != "") {
                where.processDefName = $("#processDefName").val();
            }
            var tableIns = table.render({
                elem: '#processTable'
                , height: 'full-70'
                , cols: [[
                    {checkbox: true, fixed: true},
                    {field: 'deploymentId', title: '部署编号', width: 120},
                    {field: 'key', title: '流程编号', width: 120},
                      {field: 'name', title: '流程名称', width: 120},
                      /*{
                          field: 'deploymentTime', title: '发布时间', width: 120, templet: function (d) {
                              console.info(d.deploymentTime);
                          if (d.deploymentTime == null) return;
                          var date = new Date(d.deploymentTime.time);
                          var retStr = date.format("yyyy-MM-dd hh:mm:ss");
                          return retStr;
                      }
                      },*/
                      {field: 'version', title: '版本号', width: 100},
                      {field: 'resourceName', title: '资源文件名称', width: 180},
                   /*   {field:'diagramResourceName',title:'图片资源文件名称',width:180},*/
                      {
                          field: 'isSuspended', title: '挂起状态', width: 100, templet: function (d) {
                          if (d.isSuspended) {
                              return "是";
                          } else {
                              return "否";
                          }
                      }
                      },
                      {
                          fixed: 'right', title: '操作', aligh: 'center', templet: function (d) {
                          var restr = "";
                          if (d.isSuspended) {
                              restr = "<a class='layui-btn layui-btn-mini layui-btn-danger' onclick=\"activateProcessDefinition('"+d.id+"')\">激活<b></b></a>"+
                                  "&nbsp;<a class='layui-btn layui-btn-mini layui-btn-danger' onclick=\"delProcess('"+d.deploymentId+"')\">删除</a>";
                          } else {
                              restr = "<a class='layui-btn layui-btn-mini layui-btn-normal' onclick=\"suspendProcessDefinition('"+d.id+"')\">挂起<b></b></a>" +
                                      "&nbsp;<a class='layui-btn layui-btn-mini layui-btn-danger' onclick=\"delProcess('"+d.deploymentId+"')\">删除</a>";
                          }
                          return restr;
                      }
                      }
                ]]
                , url: './processDefinitionPage'
                , method: 'post'
                , page: true
                , request: {
                    limitName: "size"
                }
                , response: {
                    countName: "totalElements",//数据总数字段名称totalElements
                    dataName: "content"//数据列表的字段名称content
                }
                , limits: [30, 60, 90, 150, 300]
                , limit: 30
                , where: where
            });
        };

        loadProcess();


        //部署流程按钮监听
        $("#doDeploy").on('click',function(){
          openLayer("${ctxPath}/activiti/doDeploy","部署流程",'540px','250px');
        });
    });

</script>

<script>
    //激活
    function activateProcessDefinition(id) {
        parent.layui.layer.confirm("确定要激活该流程？",{icon:3,title:'激活流程'},function(index){
            parent.layui.layer.close(index);
            parent.layui.layer.load(3,{time:1000});
            var state = "suspend";
            $.ajax({
                url:"./processdefinition/update/"+state+"/"+id,
                type:'get',
                dataType:'json',
                async:false,
                success:function(data){
                    alert(data.responseCode);
                    if(data.responseCode == 0){
                        parent.layui.layer.msg(data.msg);
                        loadProcess();
                    }else{
                        parent.layui.layer.msg("流程激活出错"+data.msg);
                    }
                },
                error:function(data){
                   parent.layui.layer.msg("error:"+data.msg);
                   loadProcess();
                }
            });
        });


    }

    //挂起
    function suspendProcessDefinition(id) {
        parent.layui.layer.confirm("确定要挂起该流程（挂起后这个流程定义不能再创建流程实例）？",{icon:3,title:'挂起流程'},function(index){
          parent.layui.layer.close(index);
          parent.layui.layer.load(3,{time:1000});
          var state = "active";
          $.ajax({
              url:"./processdefinition/update/"+state+"/"+id,
              type:'get',
              dataType:'json',
              async:false,
              success:function(data){
                  if(data.responseCode==0){
                      parent.layui.layer.msg(data.msg);
                      loadProcess();
                  }else{
                      parent.layui.layer.msg("流程挂起出错"+data.msg);
                  }
              },
              error:function(data){
                  parent.layui.layer.msg("error:"+data.msg);
                  loadProcess();
              }

          });
        });

    }

    function delProcess(id){
        parent.layui.layer.confirm("确定删除选中的流程定义？",{icon:3,title:"提示"},function(index){
            parent.layui.layer.close(index);
            parent.layui.layer.load(3,{time:1000});
            $.ajax({
                url:"./process/delete?deploymentId="+id,
                type:"post",
                dataType:"json",
                success:function(data){
                    if(data.responseCode == 0){
                        parent.layui.layer.msg("刪除流程成功");
                        loadProcess();
                    }
                    else{
                        parent.layui.layer.msg("删除流程出错"+data.msg);
                    }
                },
                error:function(data){
                    parent.layui.layer.msg("error:"+data.msg);
                    loadProcess();
                }

            });
        });
    }

    //启动
    function startProcessInstance(id) {

    }

    //转换为model
    function convertToModel(id) {

    }


</script>
<%@ include file="../footer.jsp" %>