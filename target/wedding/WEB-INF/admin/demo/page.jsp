<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>


<div class="layui-fluid">
    <div class="layui-card">
            <div class="layui-card-body">
                    <div style="padding-bottom: 10px;">
                        <button class="layui-btn layuiadmin-btn-list" lay-event="exa" data-type="exa">简单示例</button>
                        <button class="layui-btn layuiadmin-btn-list" lay-event="res" data-type="res">资源申请</button>
                    </div>
            </div>
    </div>
</div>

<script>
    layui.config({
        base: '${ctxPath}/resources/layuiadmin/' //静态资源所在路径
    }).extend({
        index: 'lib/index' //主入口模块
    }).use(['index', 'form', 'table'], function () {
        var $ = layui.$, active = {
            exa: exa,
            res: res
        };

        $('.layui-btn.layuiadmin-btn-list').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });

        function exa(){
            layer.open({
                type: 2,
                title: "简单示例-新增",
                maxmin: true,
                area: ["600px", "400px"],
                content: "${ctxPath}/demo/?method=edit"
            });

        }
        function res(){
            layer.open({
                type: 2,
                title: "资源申请-新增",
                maxmin: true,
                area: ["600px", "400px"],
                content: "${ctxPath}/appres/edit"
            });
        }
    });
</script>
<%@include file="../footer.jsp" %>