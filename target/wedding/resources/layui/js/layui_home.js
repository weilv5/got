layui.config({
    base: window.contextPath + '/resources/layui/js/'
}).extend({
    layui_nav: 'layui_nav'
    , layui_tab: 'layui_tab'
    , layui_table: 'layui_table'
});

function closeLayer(index){
    layui.layer.close(index);
}
layui.use(['layer', 'element', 'util', 'layui_nav','form'], function () {
    var $ = layui.jquery;
    var layuiNav = layui.layui_nav;
    // 操作对象
    var device = layui.device()
        , element = layui.element
        , layer = layui.layer
        , util = layui.util
        , $ = layui.jquery
        ,form = layui.form
        , cardIdx = 0
        , cardLayId = 0
        ,logo = $('.my-header-logo')
        ,topBtn = $('.my-header-btn')
        ,topNav = $('.my-nav')
        , side = $('.my-side')
        ,layuiBody = $('.layui-body')
        , body = $('.my-body')
        , footer = $('.my-footer');

    //阻止IE7以下访问
    if (device.ie && device.ie < 8) {
        layer.alert('本系统不支持IE8以下的浏览器');
    }

    layuiNav.top_left(menuAddr,'side-top-left');
    navShow();

    // 导航栏收缩
    function navHide(t, st) {
        var time = t ? t : 50;
        st ? localStorage.log = 1 : localStorage.log = 0;
        //side.animate({'left': -200}, time);
        logo.animate({'left': -200}, time);
        topBtn.animate({'left': 20}, time);
        topNav.animate({'left': 50}, time);
        body.animate({'left': 50}, time);
        layuiBody.animate({'left': 50}, time);
        footer.animate({'left': 50}, time);
    }

    // 导航栏展开
    function navShow(t, st) {
        var time = t ? t : 50;
        st ? localStorage.log = 0 : localStorage.log = 1;
        //side.animate({'left': 0}, time);
        logo.animate({'left': 0}, time);
        topBtn.animate({'left': 210}, time);
        topNav.animate({'left': 250}, time);
        body.animate({'left': 200}, time);
        layuiBody.animate({'left': 200}, time);
        footer.animate({'left': 200}, time);
    }

    // 监听导航栏收缩
    $('.btn-nav').on('click', function () {
        if (localStorage.log == 0) {
            $(".btn-nav>.layui-icon").html("&#xe668;");
            navShow(300);
        } else {
            $(".btn-nav>.layui-icon").html("&#xe66b;");
            navHide(300);
        }
    });

    $(".layui-nav-tree").bind("DOMNodeInserted",function(){
        if($(".layui-nav-tree").find("li").length>0){
            $(".btn-nav>.layui-icon").html("&#xe668;");
            navShow(50);
        }
    });

    form.verify({
        password: function (value) {
            if (value.length < 8) {
                return '密码至少8个字符';
            }
        },
        passwordComplex: function(value){
            if(validateInput(value)){
                return "新密码太简单，必须包含数字、大写字母、小写字母或特殊字符";
            }
            else if (validateKey(value)) {
                return "密码不得包含键盘上任意连续的四个字符或shift转换字符";
            }
            else if (validateContainsName(window.username, value)) {
                return "密码中不能包含用户名或大小写变形";
            }
            else if (validateReplace(window.username, value)) {
                return "密码中不能包含用户名的形似变形";
            }else if(value == $("#oldPassword").val()){
                return "新密码与旧密码相同，请重新输入"
            }
        },
        confirmPassword: function(value){
            if(value!=$("#newPassword").val()){
                return "两次密码不一致，请确认";
            }
        }
    });

    //监听提交
    form.on('submit(passwordForm)', function (data) {
        changePassword();
        return false;
    });
    function showChangePassword(){
        window.passwordDivContent = $("#changePassDiv").html();
        window.passwordLayer = layer.open({
            type:1,
            title: "修改密码",
            content: $("#changePassDiv").html(),
            btn: [],
            area: '500px',
            end: function(){
                $("#changePassDiv").html(window.passwordDivContent)
            }
        });
        $("#changePassDiv").empty();
    }
    function changePassword() {
        if(window.userId==="")
            return;
        var newPassword = $("#newPassword").val();
        var oldPassword = $("#oldPassword").val();
        console.info(window.contextPath);
        $.post(window.contextPath + "/changePassword", {
            id: window.userId,
            oldPassword: oldPassword,
            newPassword: newPassword
        }, function(data){
            if(data.responseCode==0){
                var msg = "密码修改成功，注销后生效";
                layer.close(window.passwordLayer);
            }else{
                var msg = "密码修改失败，错误信息：" + data.msg;
            }
            layer.msg(msg);
        });
    }

    // 根据导航栏text获取lay-id
    function getTitleId(card, title) {
        var id = -1;
        $(document).find(".layui-tab[lay-filter=" + card + "] ul li").each(function () {
            if (title === $(this).find('span').html()) {
                id = $(this).attr('lay-id');
            }
        });
        return id;
    }

    // 添加TAB选项卡
    window.addTab = function (elem, tit, url) {
        if(elem.parent().hasClass("layui-nav-tree"))
            layuiNav.main(menuAddr,elem,true, {parentModuleId: elem.attr("id")}, true);
        else if(elem.hasClass("layui-nav-item"))
            layuiNav.main(menuAddr,'side-main',true, {parentModuleId: elem.attr("id")});
        var card = 'card';                                              // 选项卡对象
        var title = tit ? tit : elem.children('a').html();              // 导航栏text
        var src = url ? url : elem.children('a').attr('href-url');      // 导航栏跳转URL
        var id = new Date().getTime();                                  // ID
        var flag = getTitleId(card, title);                             // 是否有该选项卡存在
        // 大于0就是有该选项卡了
        if (flag > 0) {
            id = flag;
        } else {
            if (src) {
                src=window.contextPath+src;
                //新增
                element.tabAdd(card, {
                    title: '<span>' + title + '</span>'
                    , content: '<iframe src="' + src + '" frameborder="0" ></iframe>'
                    , id: id
                });
                // 关闭弹窗
                layer.closeAll();
            }
        }
        // 切换相应的ID tab
        element.tabChange(card, id);
        // 提示信息
        // layer.msg(title);
    };

    // 监听顶部左侧导航
    element.on('nav(side-top-left)', function (elem) {
        // 添加tab方法
        window.addTab(elem);
    });




    // 监听顶部右侧导航
    element.on('nav(side-top-right)', function (elem) {
        if ($(this).attr('data-skin')) {
            // 修改skin
            localStorage.skin = $(this).attr('data-skin');
            skin();
        } else if($(this).attr("data") === "changePassword")
            showChangePassword();
        else {
            // 添加tab方法
            window.addTab(elem);
        }
    });

    // 监听导航(side-main)点击切换页面
    element.on('nav(side-main)', function (elem) {
        // 添加tab方法
        window.addTab(elem);
    });

    element.on('nav(sub_menu)', function(elem){alert("collapse")
        window.addTab(elem);
    });

    // 删除选项卡
    window.delTab = function (layId) {
        // 删除
        element.tabDelete('card', layId);
    };

    // 删除所有选项卡
    window.delAllTab = function () {
        // 选项卡对象
        layui.each($('.my-body .layui-tab-title > li'), function (k, v) {
            var layId = $(v).attr('lay-id');
            if (layId > 1) {
                // 删除
                element.tabDelete('card', layId);
            }
        });
    };

    // 获取当前选中选项卡lay-id
    window.getThisTabID = function () {
        // 当前选中的选项卡id
        return $(document).find('body .my-body .layui-tab-card > .layui-tab-title .layui-this').attr('lay-id');
    };

    //获取当前选中的选项卡的DOM对象
    window.getThisTabWindow = function(){
        return $(document).find('body .my-body .layui-tab-card > .layui-tab-content .layui-show').find("iframe")[0].contentWindow;
    }

    // 双击关闭相应选项卡
    $(document).on('dblclick', '.my-body .layui-tab-card > .layui-tab-title li', function () {
        // 欢迎页面以外，删除选项卡
        if ($(this).index() > 0) {
            element.tabDelete('card', $(this).attr('lay-id'));
        } else {
            layer.msg('首页不能关闭')
        }
    });

    // 选项卡右键事件阻止
    $(document).on("contextmenu", '.my-body .layui-tab-card > .layui-tab-title li', function () {
        return false;
    });

    // 选项卡右键事件
    $(document).on("mousedown", '.my-body .layui-tab-card > .layui-tab-title li', function (e) {
        // 判断是右键点击事件并且不是欢迎页面选项卡
        if (3 == e.which && $(this).index() > 0) {
            // 赋值
            cardIdx = $(this).index();
            cardLayId = $(this).attr('lay-id');
            console.log('lay-id:' + cardLayId);
            // 选择框
            layer.tips($('.my-dblclick-box').html(), $(this), {
                skin: 'dblclick-tips-box',
                tips: 3,
                time: false
            });
        }
    });

    // 点击body关闭tips
    $(document).on('click', 'html', function () {
        layer.closeAll('tips');
    });

    // 右键提示框菜单操作-刷新页面
    $(document).on('click', '.card-refresh', function () {
        // 窗体对象
        var ifr = $(document).find('.my-body .layui-tab-content .layui-tab-item iframe').eq(cardIdx);
        // 刷新当前页
        ifr.attr('src', ifr.attr('src'));
        // 切换到当前选项卡
        element.tabChange('card', cardLayId);
    });

    // 右键提示框菜单操作-关闭页面
    $(document).on('click', '.card-close', function () {
        // 删除
        window.delTab(cardLayId);
    });

    // 右键提示框菜单操作-关闭所有页面
    $(document).on('click', '.card-close-all', function () {
        // 删除
        window.delAllTab();
    });

    // 皮肤
    function skin() {
        var skin = localStorage.skin ? localStorage.skin : 0;
        var body = $('body');
        body.removeClass('skin-0');
        body.removeClass('skin-1');
        body.removeClass('skin-2');
        body.addClass('skin-' + skin);
        element.render('nav');
    }

    // 工具
    function _util() {
        var bar = $('.layui-fixbar');
        // 分辨率小于1023  使用内部工具组件
        if ($(window).width() < 1023) {
            util.fixbar({
                bar1: '&#xe602;'
                , css: {left: 10, bottom: 54}
                , click: function (type) {
                    if (type === 'bar1') {
                        //iframe层
                        layer.open({
                            type: 1,                        // 类型
                            title: false,                   // 标题
                            offset: 'l',                    // 定位 左边
                            closeBtn: 0,                    // 关闭按钮
                            anim: 0,                        // 动画
                            shadeClose: true,               // 点击遮罩关闭
                            shade: 0.8,                     // 半透明
                            area: ['150px', '100%'],        // 区域
                            skin: 'my-mobile',              // 样式
                            content: $('body .my-side').html() // 内容
                        });
                    }
                    element.init();
                }
            });
            bar.removeClass('layui-hide');
            bar.addClass('layui-show');
        } else {
            bar.removeClass('layui-show');
            bar.addClass('layui-hide');
        }
    };

    // 自适应
    $(window).on('resize', function () {
        if ($(window).width() > 1023) {
            $(".btn-nav>.layui-icon").html("&#xe668;");
            navShow(10);
        } else {
            $(".btn-nav>.layui-icon").html("&#xe66b;");
            navHide(10);
        }
        _util();
    });

    // 监听控制content高度
    function init() {
        // 起始判断-收缩/展开
        if (!localStorage.log) {
            if ($(window).width() > 1023) {
                if (localStorage.log == 0) {
                    $(".btn-nav>.layui-icon").html("&#xe66b;");
                    navHide(10);
                } else {
                    $(".btn-nav>.layui-icon").html("&#xe668;");
                    navShow(10);
                }
            } else {
                $(".btn-nav>.layui-icon").html("&#xe66b;");
                navHide(10);
            }
        } else {
            if (localStorage.log == 0) {
                $(".btn-nav>.layui-icon").html("&#xe66b;");
                navHide(10);
            } else {
                $(".btn-nav>.layui-icon").html("&#xe668;");
                navShow(10);
            }
        }
        // 工具
        _util();
        // skin
        skin();
        // 选项卡高度
        cardTitleHeight = $(document).find(".layui-tab[lay-filter='card'] ul.layui-tab-title").height();
        // 需要减去的高度
        height = $(window).height() - $('.layui-header').height() - cardTitleHeight - $('.layui-footer').height();
        // 设置高度
        $(document).find(".layui-tab[lay-filter='card'] div.layui-tab-content").height(height - 2);
    }

    // 初始化
    init();
});

//密码不得包含用户名或者大小写变形
function validateContainsName(name, password) {
    var pwdTemp = password.toLowerCase();
    var nameTemp = name.toLowerCase();
    if (pwdTemp.indexOf(nameTemp) != -1) {
        return true
    }
    return false
}

//密码不得包含键盘上任意连续的四个字符
function validateKey(password) {

    //横向穷举
    var zxsz = "qwertyuiop[]|@asdfghjkl;'@zxcvbnm,./@`1234567890-=@";
    //纵向穷举
    var dxsz = "1qaz@2wsx@3edc@4rfv@5tgb@6yhn@7ujm@8ik,@9ol.@0p;/@";
    if (validateKeyXh(zxsz, password)) {
        return true;
    }
    if (validateKeyXh(dxsz, password)) {
        return true;
    }
    return false;
}
function validateKeyXh(keysz, password) {
    var zxlen = keysz.length - 1;
    for (var i = 0; i < zxlen; i++) {
        var a = (keysz.charAt(i) + keysz.charAt(i + 1) + keysz.charAt(i + 2) + keysz.charAt(i + 3)).toLowerCase();
        var b = (keysz.charAt(zxlen - i) + keysz.charAt(zxlen - 1 - i) + keysz.charAt(zxlen - 2 - i) + keysz.charAt(zxlen - 3 - i)).toLowerCase();
        var c = password.toLowerCase();
        var wReplace = c.replace(/~/g, '`').replace(/!/g, '1').replace(/@/g, '2').replace(/#/g, '3').replace(/\$/g, '4')
            .replace(/%/g, '5').replace(/\^/g, '6').replace(/&/g, '7').replace(/\*/g, '8').replace(/\(/g, '9')
            .replace(/\)/g, '0').replace(/\_/g, '-').replace(/\+/g, '=').replace(/{/g, '[').replace(/}/g, ']')
            .replace(/\\/g, '|').replace(/:/g, ';').replace(/"/g, '\'').replace(/</g, ',').replace(/>/g, '.')
            .replace(/\?/g, '/')
        if (a.indexOf("@") == -1) {
            if (wReplace.indexOf(a) != -1) {
                return true;
            }
        }
        if (b.indexOf("@") == -1) {
            if (wReplace.indexOf(b) != -1) {
                return true;
            }
        }
    }
    return false;

}
//密码中不得包含用户名的形似形变
function validateReplace(name, password) {
    var reName = name.replace(/0/g, 'Q').replace(/o/g, 'Q').replace(/O/g, 'Q')
        .replace(/1/g, 'l').replace(/!/g, 'l').replace(/i/g, 'l')
        .replace(/6/g, 'b').replace(/d/g, 'b')
        .replace(/2/g, 'z').replace(/Z/g, 'z')
        .replace(/g/g, 'y').replace(/9/g, 'y')
        .replace(/C/g, '(').replace(/c/g, '(')
        .replace(/S/g, '$').replace(/s/g, '$')
        .replace(/p/g, 'q').replace(/P/g, 'R').replace(/f/g, 't').replace(/a/g, '@')
        .replace(/J/g, 'L').replace(/m/g, 'n').replace(/U/g, 'V');
    var rePwd = password.replace(/0/g, 'Q').replace(/o/g, 'Q').replace(/O/g, 'Q')
        .replace(/1/g, 'l').replace(/!/g, 'l').replace(/i/g, 'l')
        .replace(/6/g, 'b').replace(/d/g, 'b')
        .replace(/2/g, 'z').replace(/Z/g, 'z')
        .replace(/g/g, 'y').replace(/9/g, 'y')
        .replace(/C/g, '(').replace(/c/g, '(')
        .replace(/S/g, '$').replace(/s/g, '$')
        .replace(/p/g, 'q').replace(/P/g, 'R').replace(/f/g, 't').replace(/a/g, '@')
        .replace(/J/g, 'L').replace(/m/g, 'n').replace(/U/g, 'V');
    if (rePwd.indexOf(reName) != -1) {
        return true
    }
    return false
}
//验证组合代码
function validateInput(password) {
    var regUpper = /[A-Z]/;
    var regLower = /[a-z]/;
    var regStr = /[0-9]/;
    var regEn = /[`~!@#$%^&*()_+<>?:"{},.\/;'[\]]/im,
        regCn = /[·！#￥（——）：；“”‘、，|《。》？、【】[\]]/im;
    var flag = 0;
    if (regUpper.test(password)) {
        flag++;
    }
    if (regLower.test(password)) {
        flag++;
    }
    if (regStr.test(password)) {
        flag++;
    }
    if (regEn.test(password)) {
        flag++;
    }
    return flag < 3;
}