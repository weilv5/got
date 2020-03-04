
jQuery(document).ready(function() {

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
    $("#captchaImg").attr("src", window.baseUrl + "/captcha?dt=" + dt);
}
function showAjaxLoginForm(){
    getNewCaptcha();
    $("#password").val("");
    $("#captcha").val("");
    $("#userId").val("");
    $('#ajaxLoginModal').modal("show");
}
function ajaxLogin() {
    if(!checkForm()){
        $("#msg").text("请输入用户名、密码和验证码");
        $("#closeBtn").show();
        $('#alertModal').modal("show");
        return false;
    }else{
        $.ajax({
            url: window.baseUrl + "/encryptPass.action",
            data: {
                "timestamp": (new Date()).getTime()
            },
            success: function(publicKey){
                var encrypt = new JSEncrypt();
                encrypt.setPublicKey(publicKey);
                var epw= encrypt.encrypt($("#password").val());
                $("#password").val(epw);
                $.ajax({
                    url: window.baseUrl + "/doLogin",
                    type: "post",
                    dataType: "json",
                    data: {
                        userId: $("#userId").val(),
                        password: $("#password").val(),
                        captcha: $("#captcha").val()
                    },
                    success: function(data){
                        if(data.responseCode==0){
                            $('#ajaxLoginModal').modal("hide");
                            $("#msg").text("登录成功");
                            $("#closeBtn").hide();
                            setTimeout(function(){
                                $('#alertModal').modal("hide");
                            }, 1500);
                        }else{
                            $("#msg").text(data.msg);
                            $("#closeBtn").show();
                            $("#password").val("");
                        }
                        $('#alertModal').modal("show");
                    }
                });
            }
        });
    }

}
