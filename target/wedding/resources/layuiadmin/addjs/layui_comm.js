function openSubmitLayer(url, title, width, height) {
    var settings = {
        btn: ['确定', '取消'],
        yes: function (index, layero) {
            //点击确认触发 iframe 内容中的按钮提交
            var submit = layero.find('iframe').contents().find("#layuiadmin-app-form-submit");
            submit.click();
        }
    }
    openExtendLayer(url, title, width, height, settings)
}

function openCloseLayer(url, title, width, height) {
    var settings = {
        btn: ['关闭']
    }
    openExtendLayer(url, title, width, height, settings)
}

function openExtendLayer(url, title, width, height, settings) {
    layer.open($.extend(settings, {
        type: 2,
        title: title,
        maxmin: true,
        area: [width, height],
        offset: ['10px', '100px'],
        content: url
    }));
}

function openCustomLayer(myLayer, settings) {
    myLayer.open($.extend(settings, {
        type: 2,
        maxmin: true,
        offset: ['10px', '100px']
    }));
}

function initChooseUser(elementId, form, url) {
    var $searchDiv = $('#' + elementId).parent();
    var flag = true;
    $searchDiv.on('compositionstart', function () {
        flag = false;
    })
    $searchDiv.on('compositionend', function () {
        flag = true;
    })

    $searchDiv.bind('keydown', function (event) {
        if (event.keyCode == 8) {//keycode为8表示退格键
            $('#' + elementId).parent().find("input").val("");
            $('#' + elementId).html("");
            form.render('select');
            $('#' + elementId).parent().find("input").click().focus();
            return;
        }
    });
    $searchDiv.on('input propertychange', 'input', function () {//监听input的值的变化
        setTimeout(function() {
            if (flag) {
                var val = $('#' + elementId).parent().find("input").val();
                //从数据库中获取数据xxxxx, 把获取的数据渲染到页面上
                if (val == "") return;
                $.ajax({
                    url: url,
                    type: "post",
                    dataType: "json",
                    data: {
                        name: val
                    },
                    success: function (data) {

                        var str = "";
                        for (var i = 0; i < data.length; i++) {
                            str += "<option value=\"" + data[i].id + "\">" + data[i].name + "</option>";
                        }
                        $('#' + elementId).html(str);
                        form.render('select');
                        $('#' + elementId).parent().find("input").click().focus().val(val);
                    }

                });
            }
        });
    });
}