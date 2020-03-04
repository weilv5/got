<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="header.jsp"%>
<div class="row mt">
    <div class="col-lg-6" id="leftPanel">
        <div class="col-lg-12 panel-group" role="tablist" id="changeLogDiv" aria-multiselectable="true">
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" >
                    <h4 class="panel-title">
                        <a role="button" data-toggle="collapse" data-parent="#accordion" href="#changeList" aria-expanded="true" aria-controls="changeList">
                            <i class="fa fa-angle-right"></i> 婚礼管理更新说明
                        </a>
                    </h4>
                </div>
                <div id="changeList" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                    <div class="panel-body" id="changeLog">
                        <div class="wiki">
                            <p>婚礼管理基于Spring、Springmvc、JPA（Hibernate）、MyBatis等开源技术，在旧版本功能的基础上进行了重构，与旧版本的主要区别如下：</p>
                            <blockquote style="font-size: 10pt;">
                                <ol>
                                    <li>使用Maven构建项目工程；</li>
                                    <li>基于Maven，将底层框架与通用业务分开两个module，底层框架以独立的组件发布在自建的Maven仓库中，如果不需要平台的通用业务功能也可直接使用；</li>
                                    <li>使用Springmvc替换Struts2；</li>
                                    <li>数据库连接池使用Druid替换DBCP；</li>
                                    <li>加强对缓存的使用，提供基于EHcache和Redis的缓存方案；</li>
                                    <li>增加数据监控日志，可查看指定实体的数据变更；</li>
                                    <li>引入代码静态检查工具，并严格遵守制定的规范；</li>
                                </ol>
                            </blockquote>
                            目前婚礼管理底层框架封装了MyBatis，但通用业务功能只实现了JPA+Hibernate，MyBatis的通用业务功能在下一版本发布。<br>
                            婚礼管理与旧版本之间不能兼容，推荐新项目使用，旧版本技术中心会持续维护。<br>
                            婚礼管理文档请参阅：<br>
                            <a href="http://10.1.159.16/udp/unified_development_platform/blob/master/doc/婚礼管理--framework.docx" target="_blank">婚礼管理--framework.docx</a><br>
                            <a href="http://10.1.159.16/udp/unified_development_platform/blob/master/doc/婚礼管理开发手册.docx" target="_blank">婚礼管理开发手册.docx</a><br>
                            <a href="http://10.1.159.16/udp/udp_generator/blob/master/doc/婚礼管理%20代码生成工具使用手册.docx" target="_blank">婚礼管理 代码生成工具使用手册.docx</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-12 panel-group" role="tablist" aria-multiselectable="true" id="infoDiv">
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" >
                    <h4 class="panel-title">
                        <a role="button" data-toggle="collapse" data-parent="#accordion" href="#basicFunc" aria-expanded="true" aria-controls="basicFunc">
                            <i class="fa fa-angle-right"></i> 基本功能
                        </a>
                    </h4>
                </div>
                <div id="basicFunc" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                    <div class="panel-body">
                        <button class="btn btn-default" style="margin: 10px;" type="button" onclick="window.open('/role/?method=page&moduleId=4028cf815c3ecc41015c3ecf7d5c0003')"><span class="glyphicon glyphicon-flag"></span> 角色管理</button>
                        <button class="btn btn-default" style="margin: 10px;" type="button" onclick="window.open('/dept/?method=page&moduleId=4028cf815c3ecc41015c3eceada30002')"><span class="glyphicon glyphicon-align-left"></span> 部门管理</button>
                        <button class="btn btn-default" style="margin: 10px;" type="button" onclick="window.open('/user/?method=page&moduleId=4028cf815c3ecc41015c3eceada30002')"><span class="glyphicon glyphicon-user"></span> 用户管理</button>
                        <button class="btn btn-default" style="margin: 10px;" type="button" onclick="window.open('/module/?method=page&moduleId=4028cf815c3ecc41015c3eceada30002')"><span class="glyphicon glyphicon-tasks"></span> 模块管理</button>
                        <button class="btn btn-default" style="margin: 10px;" type="button" onclick="window.open('/dictionary/?method=page&moduleId=4028cf815c3ecc41015c3eceada30002')"><span class="glyphicon glyphicon-book"></span> 数据字典</button>
                        <button class="btn btn-default" style="margin: 10px;" type="button" onclick="window.open('/datalog/?method=page&moduleId=4028cf815c3ecc41015c3eceada30002')"><span class="glyphicon glyphicon-eye-open"></span> 数据监控</button>
                        <button class="btn btn-default" style="margin: 10px;" type="button" onclick="window.open('/information/?method=page&moduleId=4028cf815c3ecc41015c3eceada30002')"><span class="glyphicon glyphicon-th-list"></span> 信息管理</button>
                        <button class="btn btn-default" style="margin: 10px;" type="button" onclick="window.open('/sensitive/?method=page&moduleId=4028cf815c3ecc41015c3eceada30002')"><span class="glyphicon glyphicon-warning-sign"></span> 敏感词</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-6">
        <div class="col-lg-12 panel-group" role="tablist" aria-multiselectable="true" id="performanceStatDiv">
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" >
                    <h4 class="panel-title">
                        <a role="button" data-toggle="collapse" data-parent="#accordion" href="#performanceStat" aria-expanded="true" aria-controls="performanceStat">
                            <i class="fa fa-angle-right"></i> 性能统计
                        </a>
                    </h4>
                </div>
                <div id="performanceStat" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                    <div class="panel-body" id="performance" style="width:100%;min-height: 200px;">
                        <!-- 性能统计 -->
                        <div id="cpuUsageChart" class="col-lg-6" style="height: 100%;"></div>
                        <div id="diskUsageChart" class="col-lg-6" style="height: 100%;"></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-12 panel-group" role="tablist" aria-multiselectable="true" id="datalogStatDiv">
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" >
                    <h4 class="panel-title">
                        <a role="button" data-toggle="collapse" data-parent="#accordion" href="#datalogStat" aria-expanded="true" aria-controls="datalogStat">
                            <i class="fa fa-angle-right"></i> 数据操作统计
                        </a>
                    </h4>
                </div>
                <div id="datalogStat" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                    <div class="panel-body" id="datalog" style="width:100%;min-height: 200px;">
                        <!-- 数据操作统计 -->
                    </div>
                </div>
            </div>
        </div>

        <%--
        <div class="col-lg-6 panel-group" id="accordion" role="tablist" aria-multiselectable="true">
            <div class="panel panel-default">
                <div class="panel-heading" role="tab" >
                    <h4 class="panel-title">
                        <a role="button" data-toggle="collapse" data-parent="#accordion" href="#info" aria-expanded="true" aria-controls="info">
                            <i class="fa fa-angle-right"></i> 公告
                        </a>
                    </h4>
                </div>
                <div id="info" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                    <div class="panel-body">
                        <!-- 添加公告列表，显示5条 -->
                        <div id="infoList"></div>
                    </div>
                </div>
            </div>
        </div>--%>

    </div>
</div>
<%@include file="footer.jsp"%>
<script src="${ctxPath}/resources/js/echarts.min.js"></script>
<script>
    $(document).ready(function(){
        $("#datalog").height(($("#changeLogDiv").height() + $("#infoDiv").height() - 140)/2);
        $("#performance").height(($("#changeLogDiv").height() + $("#infoDiv").height() - 140)/2);
        //getLatestInformation();

        $(window).resize(function(){
            $("#datalog").height(($("#changeLogDiv").height() + $("#infoDiv").height() - 140)/2);
            $("#performance").height(($("#changeLogDiv").height() + $("#infoDiv").height() - 140)/2);
            if(datalogStatChart)
                datalogStatChart.resize();
            if(cpuUsageChart)
                cpuUsageChart.resize();
            if(diskUsageChart)
                diskUsageChart.resize();
        });
        window.isSet = false;
        $(".system_left").bind("DOMSubtreeModified", function(){
            if(window.isSet){
                return;
            }else {
                window.isSet = true;
                setTimeout(function(){
                    $("#datalog").height(($("#changeLogDiv").height() + $("#infoDiv").height() - 140)/2);
                    $("#performance").height(($("#changeLogDiv").height() + $("#infoDiv").height() - 140)/2);
                    if(datalogStatChart)
                        datalogStatChart.resize();
                    if(cpuUsageChart)
                        cpuUsageChart.resize();
                    if(diskUsageChart)
                        diskUsageChart.resize();
                }, 2000);
            }
        });


        window.diskUsageChart = echarts.init(document.getElementById('diskUsageChart'));
        window.cpuUsageChart = echarts.init(document.getElementById('cpuUsageChart'));
        var diskOption = {
            tooltip : {
                trigger: 'item',
                formatter: "{a} <br/>{b} : {c} ({d}%)"
            },
            legend: {
                orient: 'vertical',
                left: 'left',
                data: ['已使用空间','空闲空间']
            },
            series: []
        };
        diskUsageChart.setOption(diskOption);
        diskUsageChart.showLoading();

        window.cpuOption = {
            tooltip: {
                trigger: 'axis',
                axisPointer: {
                    type: 'cross',
                    label: {
                        backgroundColor: '#283b56'
                    }
                }
            },
            legend: {
                data:['CPU使用率', '内存使用率', 'JVM堆内存使用率']
            },
            xAxis: [
                {
                    type: 'category',
                    boundaryGap: true,
                    data: (function (){
                        var now = new Date();
                        var res = [];
                        var len = 10;
                        while (len--) {
                            res.unshift(now.toLocaleTimeString().replace(/^\D*/,''));
                            now = new Date(now - 10000);
                        }
                        return res;
                    })()
                }
            ],
            yAxis: [
                {
                    type: 'value',
                    scale: true,
                    name: '%',
                    max: 100,
                    min: 0
                }
            ],
            series: [
                {
                    name:'CPU使用率',
                    type:'bar',
                    data:(function (){
                        var res = [];
                        var len = 10;
                        while (len--) {
                            res.push(0);
                        }
                        return res;
                    })()
                },
                {
                    name:'内存使用率',
                    type:'line',
                    data:(function (){
                        var res = [];
                        var len = 10;
                        while (len--) {
                            res.push(0);
                        }
                        return res;
                    })()
                },
                {
                    name:'JVM堆内存使用率',
                    type:'line',
                    data:(function (){
                        var res = [];
                        var len = 10;
                        while (len--) {
                            res.push(0);
                        }
                        return res;
                    })()
                }
            ]
        };
        cpuUsageChart.setOption(cpuOption);
        cpuUsageChart.showLoading();

        performanceStat();
        datalogStat();
        setInterval(performanceStat, 10000);
    });

    function performanceStat(){

        var dt = (new Date()).getTime();
        $.ajax({
            url: "${ctxPath}/performanceStat?dt="+dt,
            dataType: "json",
            type: "post",
            success: function(data){
                console.log(JSON.stringify(data));
                var diskUsage = data.diskUsage;
                diskUsageChart.setOption({
                    series: [{
                        type: 'pie',
                        radius : '40%',
                        center: ['50%', '60%'],
                        data:[
                            {value:diskUsage.used, name:'已使用空间'},
                            {value:diskUsage.free, name:'空闲空间'}
                        ]
                    }]
                });
                diskUsageChart.hideLoading();

                var axisData = (new Date()).toLocaleTimeString().replace(/^\D*/,'');
                var cpuUsage = data.cpuUsage;
                cpuOption.series[0].data.shift();
                cpuOption.series[0].data.push(cpuUsage.used);

                var memUsage = data.memUsage;
                cpuOption.series[1].data.shift();
                cpuOption.series[1].data.push((memUsage.used*100.0)/memUsage.total);

                var jvmMemUsage = data.jvmMemUsage;
                cpuOption.series[2].data.shift();
                cpuOption.series[2].data.push(100 - (jvmMemUsage.free*100.0)/jvmMemUsage.total);

                cpuOption.xAxis[0].data.shift();
                cpuOption.xAxis[0].data.push(axisData);
                cpuUsageChart.setOption(cpuOption);
                cpuUsageChart.hideLoading();
            }
        });
    }

    function datalogStat() {
        window.datalogStatChart = echarts.init(document.getElementById('datalog'));
        var option = {
            tooltip: {},
            xAxis: {
                type: "category",
                data: ["新增","修改","删除","读取"]
            },
            yAxis: {},
            series: []
        };
        datalogStatChart.setOption(option);
        datalogStatChart.showLoading();
        var dt = (new Date()).getTime();
        $.ajax({
            url: "${ctxPath}/datalogStat?dt="+dt,
            dataType: "json",
            type: "post",
            success: function(data){
                var series = [];
                var legend = [];
                for(var i = 0; i < data.length; i++){
                    legend.push(data[i].class_name);
                    var serie = {
                        type: "bar",
                        name: data[i].class_name,
                        data: [0,0,0,0]
                    };
                    serie.data[data[i].change_type] = data[i].cnt;
                    series.push(serie);
                }
                datalogStatChart.setOption({
                    legend: {
                        data: legend
                    },
                    series: series
                });
                datalogStatChart.hideLoading();
            }
        });
    }

    function getLatestInformation(){
        $.ajax({
            url: "${ctxPath}/getLatestInformation",
            data: {
                page: 0,
                size: 5
            },
            dataType: "json",
            type: "post",
            success: function(data){
                var length = data.content.length;
                var table = $("<table border='0' class='table table-hover table-striped table-row-cell ' style='width: 100%;'></table>");

                for(var i = 0; i < length; i++){
                    var tr = $("<tr></tr>")
                    var a = i+1;
                    var bb = data.content[i].releasedDate;
                    bb = bb.substring(0,bb.indexOf(" "));

                    tr.append($("<td >" + a + "</td>"));
                    tr.append($("<td  style='text-overflow: ellipsis;white-space: nowrap;overflow:hidden;'>" +"<a href=' ${ctxPath}/information/?method=view&id="+data.content[i].id+"'target='view_window'>"+ data.content[i].title + "</a></td>"));
                    tr.append($("<td >" + bb + "</td>"));
                    tr.append($("<td >" + data.content[i].name + "</td>"));
                    table.append(tr);
                }$("#infoList").append(table)
            }
        });
    }
</script>
