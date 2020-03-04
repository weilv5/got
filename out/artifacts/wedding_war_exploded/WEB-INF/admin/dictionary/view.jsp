<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>
<style type="text/css">
    th, td {
        font-size: 10px;
    }

    .error {
        font-size: 8pt;
        color: red;
        margin: 10pt 0pt;
    }
</style>


<form class="form-horizontal style-form" id="data_dictionaryForm">
    <input id="id" name="id" type="hidden">
    <input id="CSRFToken" name="CSRFToken" type="hidden" value="${CSRFToken}">
    <div class="layui-fluid">
        <div class="layui-row">
            <div class="layui-col-xs12" style="margin-top: 30px">
                <div class="layui-form-item">
                    <label class="layui-form-label">分类：</label>
                    <div class="layui-input-block">
                        <input id="dictionaryCode"  disabled="disabled"
                               name="dictionaryCode" type="text" class="layui-input">
                    </div>
                </div>
            </div>
        </div>
       <%-- <div class="layui-row">
            <div class="layui-col-xs12" align="center">
                <button class="layui-btn layui-btn-danger" onclick="showConfirm()">刪除</button>
                <button class="layui-btn" onclick="modifydata_dictionary()">修改</button>
            </div>
        </div>--%>
    </div>
    <section id="dictionary" style="margin-top: 20px;">
        <table class="layui-table" style="width: 96%; margin: 0px 2%;">
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
                    <input style="width: 120px;" type="text" class="layui-input"  v-model="field.key" />
                    <div class="error" role="alert" v-if="!$v.fields.$each[index].key.required"><a class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></a>编码不能为空</div>
                </td>
                <td>
                    <input style="width: 120px;" type="text" class="layui-input"  v-model="field.value" v-validate:field.value="{}"/>
                    <div class="error" role="alert" v-if="!$v.fields.$each[index].value.required"><a class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></a>显示值不能为空</div>
                </td>
            </tr>
            </tbody>
        </table>
        <div style="width: 96%; margin: 10px 4%;">
            <a v-on:click="createField" title="添加"><i class="layui-icon" style="font-size: 25px; color: #1E9FFF;">&#xe654;</i> </a>&nbsp;
            <a v-on:click="deleteField" title="删除"><i class="layui-icon" style="font-size: 25px; color: #1E9FFF;">&#xe640;</i> </a>&nbsp;
            <a v-on:click="saveValue" title="保存"><i class="layui-icon" style="font-size: 25px; color: #1E9FFF;">&#xe605;</i> </a>
        </div>
    </section>
</form>


<script src="${ctxPath}/resources/js/vue.js"></script>
<script src="${ctxPath}/resources/js/vuelidate.min.js"></script>
<script src="${ctxPath}/resources/js/validators.min.js"></script>
<script>
    Vue.use(window.vuelidate.default);
    var required = window.validators.required;
    // Vue.validator('checkChar',function (val) {
    //     return /^([\u4E00-\u9FA5A-Za-z0-9]){0,10}$/.test(val);
    // });


    function viewdata_dictionary() {
        var id = "${id}";
        if (id === "")
            return;
        var dt = (new Date()).getTime();
        $.ajax({
            url: "./get/" + id,
            dataType: "json",
            type: "get",
            data: {
                dt: dt
            },
            success: function (data) {
                $("#id").val(data.id);
                $("#dictionaryCode").val(data.dictionaryCode);
                var origDictionaries = eval(data.content);
                var length = origDictionaries.length;
                for (var i = 0; i < length; i++) {
                    window.dictionaries.push(origDictionaries[i]);
                }
            }
        });
    }

    $(document).ready(function () {
        window.dictionaries = [];
        viewdata_dictionary();
        window.dictionaryTable = new Vue({
            el: "#dictionary",
            data: {
                fields: window.dictionaries
            },
            validations: {
                fields: {
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
                createField: function () {
                    window.dictionaries.push({
                        key: "",
                        value: ""
                    });
                },
                deleteField: function () {
                    var length = $("input[name='checkbox']:checked").length;
                    if(length == 0){
                        parent.layui.layer.msg("未选中数据",{time:2000});
                    }
                    var indexes = [];
                    for (var i = 0; i < length; i++)
                        indexes.push($("input[name='checkbox']:checked")[i].value);
                    var newFields = $.grep(window.dictionaries, function (n, i) {
                        for (var k = 0; k < length; k++) {
                            if (i == indexes[k])
                                return false;
                        }
                        return true;
                    });
                    window.dictionaries.splice(0, window.dictionaries.length);
                    for (var i = 0; i < newFields.length; i++) {
                        window.dictionaries.push(newFields[i]);
                    }
                },
                checkAll: function () {
                    var length = $("input[name='checkbox']").length;
                    for (var i = 0; i < length; i++) {
                        $("input[name='checkbox']")[i].checked = $("#ckall")[0].checked;
                    }

                },
                saveValue: function () {
                    if (!this.$v.fields.$invalid) {
                        $.ajax({
                            type: "post",
                            url: "./update",
                            data: {
                                id: "${id}",
                                CSRFToken: $("#CSRFToken").val(),
                                dictionaryCode: $("#dictionaryCode").val(),
                                content: JSON.stringify(window.dictionaries)
                            },
                            dataType: "json",
                            success: function (data) {
                                if (data.responseCode == 0) {
                                    parent.layui.layer.msg("提交成功",{time:2000});
                                } else {
                                    parent.layui.layer.msg("提交成功",{time:2000});
                                }
                            }
                        })
                    } else {
                        layui.layer.msg("请确认输入是否正确",{time:2000});
                    }
                }
            }
        });
    });
</script>

<%@include file="../footer.jsp" %>
