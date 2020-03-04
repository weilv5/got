
jQuery(document).ready(function() {
	
    /*
        Fullscreen background
    */
    $.backstretch("resources/img/login_bg.jpg");
    
    /*
        Form validation
    */
    $('.login-form input[type="text"], .login-form input[type="password"], .login-form textarea').on('focus', function() {
    	$(this).removeClass('input-error');
    });

    $('.login-form input[type="text"], .login-form input[type="password"], .login-form textarea').keyup(function(event) {
        if(event.key === "Enter"){
            if(checkForm()){
                doLogin();
            }else{

                if( $(this).val() != "" ){
                    var index = $(".login-form input").index($(this)) + 1;
                    $(".login-form input")[index].focus();
                }
            }
        }else {
            if( $(this).val() != "" )
                $(this).removeClass('input-error');
        }

    });
    
});

function checkForm() {
    var checked = true;
    $(".login-form").find('input[type="text"], input[type="password"], textarea').each(function(){
        if( $(this).val() == "" ) {
            checked = false;
            $(this).addClass('input-error');
            return;
        }
        else {
            $(this).removeClass('input-error');
        }
    });
    return checked;
}

function getNewCaptcha(){
    var dt = (new Date()).getTime();
    $("#captchaImg").attr("src", "captcha?dt=" + dt);
}
function doLogin() {
    if(!checkForm()){
        $("#msg").text("请输入用户名、密码和验证码");
        $("#closeBtn").show();
        $('#alertModal').modal("show");
        return false;
    }else{
        $.ajax({
            url: "encryptPass.action",
            data: {
                "timestamp": (new Date()).getTime()
            },
            success: function(publicKey){
                var encrypt = new JSEncrypt();
                encrypt.setPublicKey(publicKey);
                var epw= encrypt.encrypt($("#password").val());
                // $("#password").val(epw);
                $.ajax({
                    url: "doLogin",
                    type: "post",
                    dataType: "json",
                    data: {
                        userId: $("#userId").val(),
                        password: epw,
                        captcha: $("#captcha").val()
                    },
                    success: function(data){
                        if(data.responseCode == 0){
                            $("#msg").text("登录成功，正在跳转中....");
                            $("#closeBtn").hide();
                            setTimeout(function(){
                                var url = "home";
                                if(data.msg)
                                    url = data.msg;
                                window.open(url, "_self");
                            }, 1000);
                        } else if(data.responseCode == 1 || data.responseCode == 2){
                            if(data.responseCode == 1)
                                $("#msg").text("密码不符合要求，请修改密码....");
                            else
                                $("#msg").text("密码到期，请修改密码....");
                            setTimeout(function(){
                                var url = "changePwd";
                                if(data.msg)
                                    url = data.msg;
                                window.open(url,"_self");
                            }, 1000);

                        } else{
                            $("#msg").text(data.msg);
                            $("#closeBtn").show();
                            getNewCaptcha();
                        }
                        $('#alertModal').modal("show");
                    },
                    error: function(){
                        $("#msg").text("用户名或密码错误");
                        $("#closeBtn").show();
                        getNewCaptcha();
                        $('#alertModal').modal("show");
                    }
                });
            }
        });
    }

}
