<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp"%>
<style type="text/css">
    th, td{
        font-size: 10px;
    }
    .error{
        font-size: 8pt;
        color: red;
        margin: 10pt 0pt;
    }
</style>
<div class="caption">当前位置&nbsp;>&nbsp;<span>查看数据字典</span></div>

    <div class="col-lg-12">
        <div class="form-panel col-lg-12">

                <form class="form-horizontal style-form" id="data_dictionaryForm">
                    <input id="id" name="id" type="hidden" >
                    <input id="CSRFToken" name="CSRFToken" type="hidden" value="${CSRFToken}">
                        <div class="form-group">
                            <label class="col-lg-2 control-label">分类：</label>
                            <div class="col-lg-10" id="dictionaryCode" style="margin-top: 7px;"></div>
                        </div>
                    <div class="text-center">
                        <button type="button"  class="btn btn-danger" onclick="showConfirm()">删除</button>
                        <button type="button" class="btn btn-primary" onclick="modifydata_dictionary()">修改</button>
                        <button type="button" class="btn btn-default" onclick="backToList()">返回</button>
                    </div>
                </form>

            <section id="dictionary" style="margin-top: 20px;">
                <table class="table table-bordered" style="width: 96%; margin: 0px 2%;">
                    <thead>
                    <tr>
                        <th><input style="width: 30px;" type="checkbox" id="ckall" v-on:click="checkAll" ></th>
                        <th>编码</th>
                        <th>显示值</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr v-for="(field, index) in fields">
                        <td><input style="width: 30px;" type="checkbox" v-bind:value="index" name="checkbox"></td>
                        <td>
                            <input style="width: 120px;" type="text" class="form-control"  v-model="field.key" />
                            <div class="error" role="alert" v-if="!$v.fields.$each[index].key.required"><a class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></a>编码不能为空</div>
                        </td>
                        <td>
                            <input style="width: 120px;" type="text" class="form-control"  v-model="field.value" />
                            <div class="error" role="alert" v-if="!$v.fields.$each[index].value.required"><a class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></a>显示值不能为空</div>
                        </td>
                    </tr>
                    </tbody>
                </table>
                <div style="width: 96%; margin: 10px 4%;">
                    <a v-on:click="createField" title="添加"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></a>&nbsp;
                    <a v-on:click="deleteField" title="删除"><span class="glyphicon glyphicon-minus" aria-hidden="true"></span></a>&nbsp;
                    <a v-on:click="saveValue" title="保存"><span class="glyphicon glyphicon-ok" aria-hidden="true"></span></a>
                </div>
            </section>
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
<div id="confirmDialog" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">提示</h4>
            </div>
            <div class="modal-body" id="confirmMsg">

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" onclick="removedata_dictionary()">确定</button>
            </div>
        </div>
    </div>
</div>

<%@include file="../footer.jsp"%>
<script src="${ctxPath}/resources/js/vue.js"></script>
<script src="${ctxPath}/resources/js/vuelidate.min.js"></script>
<script src="${ctxPath}/resources/js/validators.min.js"></script>
<script>
    Vue.use(window.vuelidate.default);
    var required = window.validators.required;
    function backToList() {
        window.open("./?method=page", "_self");
    }

    function modifydata_dictionary(){
        var id = "${id}";
        window.open("./?method=edit&id=" + id, "_self");
    }
    function showConfirm() {
        $("#confirmDialog").modal("show");
        $("#confirmMsg").text("确定要删除数据字典");
    }
    function removedata_dictionary() {
        var id = "${id}";
        $.ajax({
            url: "./delete/" + id,
            type: "post",
            dataType: "json",
            success: function (data) {
                $("#confirmDialog").modal("hide");
                if(data.responseCode==0){
                    $("#msg").text("提交成功");
                    $("#closeBtn").hide();
                    setTimeout(backToList, 1000)
                }else{
                    $("#msg").text(data.msg);
                    $("#closeBtn").show();
                }
                $('#alertModal').modal("show");
            }
        })
    }

    function viewdata_dictionary(){
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
            success: function(data){
                $("#id").val(data.id);
                $("#dictionaryCode").text(data.dictionaryCode);
                var origDictionaries = eval(data.content);
                var length = origDictionaries.length;
                for(var i = 0; i < length; i++){
                    window.dictionaries.push(origDictionaries[i]);
                }
            }
        });
    }
    $(document).ready(function(){
        window.dictionaries = [];
        viewdata_dictionary();
        window.dictionaryTable = new Vue({
            el: "#dictionary",
            data: {
                fields: window.dictionaries
            },
            validations: {
                fields : {
                    $each: {
                        key: {
                            required: required
                        },
                        value: {
                            required: required
                        }
                    }
                }
            },
            methods: {
                createField: function() {
                    window.dictionaries.push({
                        key: "",
                        value: ""
                    });
                },
                deleteField: function() {
                    var length = $("input[name='checkbox']:checked").length;
                    var indexes = [];
                    for(var i = 0; i < length; i++)
                        indexes.push($("input[name='checkbox']:checked")[i].value);
                    var newFields = $.grep(window.dictionaries, function(n, i){
                        for(var k = 0; k < length; k++){
                            if(i==indexes[k])
                                return false;
                        }
                        return true;
                    });
                    window.dictionaries.splice(0, window.dictionaries.length);
                    for(var i = 0; i < newFields.length; i++){
                        window.dictionaries.push(newFields[i]);
                    }
                },
                checkAll: function () {
                    var length = $("input[name='checkbox']").length;
                    for(var i = 0; i < length; i++){
                        $("input[name='checkbox']")[i].checked = $("#ckall")[0].checked;
                    }

                },
                saveValue: function () {
                    if(!this.$v.fields.$invalid){
                        $.ajax({
                            type:"post",
                            url: "./update",
                            data: {
                                id: "${id}",
                                CSRFToken: $("#CSRFToken").val(),
                                dictionaryCode: $("#dictionaryCode").text(),
                                content: JSON.stringify(window.dictionaries)
                            },
                            dataType: "json",
                            success: function(data){
                                if(data.responseCode==0){
                                    $("#msg").text("提交成功");
                                    $("#closeBtn").show();
                                }else{
                                    $("#msg").text(data.msg);
                                    $("#closeBtn").show();
                                }
                                $('#alertModal').modal("show");
                            }
                        })
                    }else{
                        $("#msg").text("请确认输入是否正确");
                        $("#closeBtn").show();
                        $('#alertModal').modal("show");
                    }
                }
            }
        });
    });
</script>
