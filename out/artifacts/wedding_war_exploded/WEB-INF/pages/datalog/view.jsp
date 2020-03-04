<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<div class="caption">当前位置&nbsp;>&nbsp;<span>查看信息</span></div>

    <div class="col-lg-12">
        <div  class="col-lg-12 form-panel">
                <form class="form-horizontal style-form" id="information_contentForm" style="width: 96%;margin: 0px 2%;">
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">操作日期：</label>
                        <div class="col-lg-8" style="padding-top: 7px;" id="createdDate"></div>
                    </div>
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">操作者ID：</label>
                        <div class="col-lg-8" style="padding-top: 7px;" id="operarorId"></div>
                    </div>
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">操作类型：</label>
                        <div class="col-lg-8" style="padding-top: 7px;" id="changeType"></div>
                    </div>
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">操作者IP：</label>
                        <div class="col-lg-8" style="padding-top: 7px;" id="operatorIp"></div>
                    </div>
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">操作实体名：</label>
                        <div class="col-lg-8" style="padding-top: 7px;" id="entityName"></div>
                    </div>
                    <div class="form-group col-lg-6">
                        <label class="col-lg-4 control-label">操作实体类名：</label>
                        <div class="col-lg-8" style="padding-top: 7px;" id="className1"></div>
                    </div>
                    <div class="form-group col-lg-12">
                        <label class="col-lg-2 control-label">操作前数据：</label>
                        <div class="col-lg-10" style="padding-top: 7px;word-break:break-all;" id="beforeChange"></div>
                    </div>
                    <div class="form-group col-lg-12">
                        <label class="col-lg-2 control-label">操作后数据：</label>
                        <div class="col-lg-10" style="padding-top: 7px;word-break:break-all;" id="afterChange"></div>
                    </div>
                    <div class="text-center col-lg-12">
                        <button type="button" class="btn btn-default" onclick="backToList()">返回</button>
                    </div>
                </form>
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

    function backToList() {
        window.open("./?method=page", "_self");
    }


    function viewDatalog(){
        var id = "${id}";
        if(id==="")
            return;
        var dt = (new Date()).getTime();
        $.ajax({
            url: "./get/" + id,
            dataType: "json",
            type: "get",
            data: {
                dt: dt
            },
            success: function(log){
                $("#className1").text(log.className);
                $("#beforeChange").text(log.beforeChange);
                $("#createdDate").text(log.createdDate);
                $("#afterChange").text(log.afterChange);
                $("#operarorId").text(log.operatorId);
                $("#operatorIp").text(log.operatorIp);
                $("#entityName").text(log.entityName);
                var opType = "";
                switch (log.entityChangeType){
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
                    default:
                        opType = "未知";
                        break;
                }
                $("#changeType").text(opType);
            }
        });
    }
    $(document).ready(function(){
        viewDatalog();
    });
</script>
