<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@include file="../header.jsp" %>

<form class="layui-form" id="excelImportForm" lay-filter="excelImportForm" action="">
    <input id="id" name="id" type="hidden" value="${id}">
    <input id="CSRFToken" name="CSRFToken" type="hidden" value="${CSRFToken}">
    <div class="layui-fluid" align="center">
        <input name="excelImportFile" type="file" accept=".xls,.xlsx">
    </div>
    <div class="layui-row">
        <div class="layui-col-xs12" align="center">
            <div class="layui-form-item layui-hide">
                <input type="button" lay-submit lay-filter="layuiadmin-app-form-submit"
                       id="layuiadmin-app-form-submit" value="提交">
            </div>
        </div>
    </div>
</form>
<div class="layui-input-block" >
    <button class="layui-btn layuiadmin-btn-list" lay-event="downloadExl" data-type="downloadExl">
        导出模板文件
    </button>
    <a href="" download="Excel模板文件.xlsx" id="hf"></a>
</div>
<div class="layui-row">
    <div class="layui-col-xs12" align="center">
        <div class="layui-form-item">
            <i class="layui-icon" style="font-size: 20px; color: #1E9FFF;">&#xe702;</i>
            <span>Excel文件包含三列，第一列为代码项值，第二列为代码项显示值，第三列为父项显示值。</span>
        </div>
    </div>
</div>

<script>
    layui.use(['layer', 'form'], function () {
        var layer = layui.layer
            , form = layui.form
            , $ = layui.jquery;

        var $ = layui.$, active = {
            downloadExl: downloadExl
        };

        $('.layui-btn.layuiadmin-btn-list').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });

        function downloadExl() {
            var json = [{ //测试数据
                //第一列为代码项显示值，第二列为代码项值，第三列为父项显示值
                "代码项值":"0",
                "代码项显示值":"男",
                "父项显示值":"性别"
            }];
            var tmpDown; //导出的二进制对象
            var tmpdata = json[0];
            json.unshift({});
            var keyMap = []; //获取keys
            //keyMap =Object.keys(json[0]);
            for (var k in tmpdata) {
                keyMap.push(k);
                json[0][k] = k;
            }
            var tmpdata = [];//用来保存转换好的json
            json.map((v, i) => keyMap.map((k, j) => Object.assign({}, {
                v: v[k],
                position: (j > 25 ? getCharCol(j) : String.fromCharCode(65 + j)) + (i + 1)
            }))).reduce((prev, next) => prev.concat(next)).forEach((v, i) => tmpdata[v.position] = {
                v: v.v
            });
            var outputPos = Object.keys(tmpdata); //设置区域,比如表格从A1到D10
            var tmpWB = {
                SheetNames: ['mySheet'], //保存的表标题
                Sheets: {
                    'mySheet': Object.assign({},
                        tmpdata, //内容
                        {
                            '!ref': outputPos[0] + ':' + outputPos[outputPos.length - 1] //设置填充区域
                        })
                }
            };
            tmpDown = new Blob([s2ab(XLSX.write(tmpWB,
                {bookType:'xlsx',bookSST:false, type:'binary'}//这里的数据是用来定义导出的格式类型
            ))], {
                type: ""
            }); //创建二进制对象写入转换好的字节流
            var href = URL.createObjectURL(tmpDown); //创建对象超链接
            document.getElementById("hf").href = href; //绑定a标签
            document.getElementById("hf").click(); //模拟点击实现下载
            setTimeout(function() { //延时释放
                URL.revokeObjectURL(tmpDown); //用URL.revokeObjectURL()来释放这个object URL
            }, 100);
        }

        function s2ab(s) { //字符串转字符流
            var buf = new ArrayBuffer(s.length);
            var view = new Uint8Array(buf);
            for (var i = 0; i != s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
            return buf;
        }
        // 将指定的自然数转换为26进制表示。映射关系：[0-25] -> [A-Z]。
        function getCharCol(n) {
            let temCol = '',
                s = '',
                m = 0
            while (n > 0) {
                m = n % 26 + 1
                s = String.fromCharCode(m + 64) + s
                n = (n - m) / 26
            }
            return s
        }

        form.on('submit(layuiadmin-app-form-submit)', function (e) {
            url = "${ctxPath}/multiValue/excelImport";
            $("#excelImportForm").ajaxSubmit({
                type: "post",
                url: url,
                success: function (data) {
                    if (data.responseCode == 0) {
                        layer.msg("提交成功", {time: 3000}, function () {
                            var index = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(index);
                        });
                    } else {
                        layer.msg(data.msg);
                    }
                }
            });
            return false;
        });
    });
</script>

<%@include file="../footer.jsp" %>

