layui.use(['layer', 'element', 'util', 'form'], function () {
    var $ = layui.jquery;
    $.ajaxSetup({
        error: function (xhr, textStatus, errorThrown) {
            if( xhr.status === 401){
                showAjaxLoginForm();
            }else{
                layer.msg("请求失败");
            }
        }
    });

    function showAjaxLoginForm(){
        //TODO Ajax 登录
        alert("登录超时，请刷新重新登录")
    }
});

function openLayer(url, title, width, height) {
    parent.layui.layer.open({
        type: 2,
        title: title,
        maxmin: true,
        area: [width, height],
        content: url,
        zIndex: parent.layui.layer.zIndex,
        success: function(layero){
            parent.layui.layer.setTop(layero);
        }
    });
}