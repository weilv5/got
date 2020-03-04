package com.jsict.biz.controller;

import com.jsict.biz.model.Module;
import com.jsict.biz.model.User;
import com.jsict.biz.service.ModuleService;
import com.jsict.biz.service.UserService;
import com.jsict.framework.core.controller.Response;
import com.jsict.framework.utils.Encodes;
import com.jsict.framework.utils.RSAKeyGenerater;
import com.jsict.framework.utils.SysConfig;
import com.jsict.framework.utils.ValidateCode;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.util.SavedRequest;
import org.apache.shiro.web.util.WebUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.*;

import static com.jsict.framework.utils.VerifyUtil.*;

/**
 * Created by caron on 2017/5/24.
 */
@Controller
@RequestMapping("/")
public class LoginController {

    private static final Logger logger = LoggerFactory.getLogger(LoginController.class);

    private static final String VALIDATE_CODE = "ValidateCode";

    private static final String KEY_GENERATOR = "keyGenerator";

    private static final String LOGIN = "login";
    private static final String HOME = "home";
    private static final String WELCOME = "welcome";
    private static final String CHANGE = "changePwd";


    @Autowired
    private SysConfig sysConfig;

    @Autowired
    private UserService userService;

    @Autowired
    private ModuleService moduleService;

    @RequestMapping(value = "login", method = RequestMethod.GET)
    public String login() {
        if (SecurityUtils.getSubject() != null && SecurityUtils.getSubject().isAuthenticated())
            return HOME;
        else
            return LOGIN;
    }

    /**
     * 生成验证码
     *
     * @throws Exception
     */
    @RequestMapping(value = "captcha", method = RequestMethod.GET)
    public void captcha(HttpServletRequest request, HttpServletResponse response) throws IOException {
        ValidateCode vCode = new ValidateCode(120, 40, 4, 100);
        request.getSession().setAttribute(VALIDATE_CODE, vCode.getCode());
        ImageIO.write(vCode.getBuffImg(), "PNG", response.getOutputStream());
    }

    @ResponseBody
    @RequestMapping(value = "encryptPass", method = RequestMethod.GET)
    public String encryptPass(HttpServletRequest request, @RequestParam Long timestamp) {
        RSAKeyGenerater keyGenerator = new RSAKeyGenerater();
        request.getSession().setAttribute(KEY_GENERATOR, keyGenerator);
        return keyGenerator.generateBase64PublicKey(timestamp);
    }

    @ResponseBody
    @RequestMapping(value = "doLogin", method = RequestMethod.POST, produces = "application/json")
    public Response<User> doLogin(@ModelAttribute User user, @RequestParam(required = false) String captcha, HttpServletRequest request) {
        Response<User> response;
        User query = new User();
        query.setUserId(user.getUserId());
        Date lastChangeTime = userService.singleResult(query).getLastChangePwdTime();
        if (sysConfig.getConfig().getBoolean("needCaptcha") && (StringUtils.isBlank(captcha) ||
                !captcha.equalsIgnoreCase((String) request.getSession().getAttribute(VALIDATE_CODE)))) {
            response = new Response<>(-1, "验证码错误");
            return response;
        }
        try {
            RSAKeyGenerater keyGenerator = (RSAKeyGenerater) request.getSession().getAttribute(KEY_GENERATOR);
            String credential = keyGenerator.decryptBase64(user.getPassword());
            user.setPassword(credential);
            request.getSession().removeAttribute(KEY_GENERATOR);
            Subject currentUser = SecurityUtils.getSubject();
            currentUser.login(new UsernamePasswordToken(user.getUserId(), Encodes.encodeMD5(user.getPassword())));
            SavedRequest reqUrl = WebUtils.getSavedRequest(request);
            if (reqUrl != null) {
                response = new Response<>(0, reqUrl.getRequestUrl(), (User) currentUser.getPrincipal());
            } else if (!verifyPwd(user.getUserId(), user.getPassword()) && (getConfigChangePwd().getProperty("pwdVerify").equals("yes"))) {
                response = new Response<>(1, (User) currentUser.getPrincipal());
            } else if (verifyPwdExpire(lastChangeTime)) {//密码到期
                response = new Response<>(2, (User) currentUser.getPrincipal());
            } else
                response = new Response<>(0, (User) currentUser.getPrincipal());
        } catch (Exception e) {
            //request.getSession().invalidate();
            logger.debug("用户登录失败", e);
            String error;
            try {
                error = userService.doErrorPassword(user.getUserId(), true);
            } catch (Exception ex) {
                error = ex.getMessage();
                logger.debug("用户登录失败", ex);
            }
            if (StringUtils.isBlank(error))
                error = e.getMessage();
            response = new Response<>(-1, error);
        }

        return response;
    }

    @RequestMapping(value = "logout", method = RequestMethod.GET)
    public String logout(HttpServletRequest request) {
        Subject currentUser = SecurityUtils.getSubject();
        currentUser.logout();
        HttpSession session = request.getSession();
        session.invalidate();
        return LOGIN;
    }

    @RequestMapping(value = "home", method = RequestMethod.GET)
    public ModelAndView home(HttpServletRequest request) {
        request.getSession().removeAttribute("moduleId");
        ModelAndView mav = new ModelAndView(HOME);
        User user = (User) SecurityUtils.getSubject().getPrincipal();
        List<Module> modulelist=moduleService.getModuleFullTreeByUser(user.isAdmin(),user.getRoleList(),null);
        mav.addObject("modulelist", modulelist);
        return mav;
    }

    @RequestMapping(value = "changePwd", method = RequestMethod.GET)
    public String changePwd(HttpServletRequest request) {
        request.getSession().removeAttribute("moduleId");
        return CHANGE;
    }

    @RequestMapping(value = "welcome", method = RequestMethod.GET)
    public String welcome(HttpServletRequest request) {
        return WELCOME;
    }


    public Properties getConfigChangePwd() {
        Properties p = new Properties();
        InputStream inputStream = LoginController.class.getClassLoader().getResourceAsStream("configPwd.properties");
        try {
            p.load(inputStream);
        } catch (IOException e) {
            logger.debug("getConfigChangePwd出错", e);
        }
        return p;
    }

    public boolean verifyPwd(String username, String password) {
        boolean flag = false;
        boolean myFirstCondition = validateLen(password) && validateInput(password);
        boolean mySecondCondition = validateKey(password) && validateContainsName(username, password);
        if (myFirstCondition && mySecondCondition && validateReplace(username, password)) {
            flag = true;
        }
        return flag;
    }



    public boolean verifyPwdExpire(Date lastChangePwdTime) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if (lastChangePwdTime == null)
            return false;
        Calendar rightNow = Calendar.getInstance();
        rightNow.setTime(lastChangePwdTime);
        rightNow.add(Calendar.MONTH, 3);//日期加3个月
        Date dt = rightNow.getTime();
        Date nowDate = new Date();
        logger.info(sdf.format(lastChangePwdTime) + "\n" +sdf.format(dt));
        int flag = nowDate.compareTo(dt);
        return flag > 0;


    }

}
