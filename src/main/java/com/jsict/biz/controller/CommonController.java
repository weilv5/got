package com.jsict.biz.controller;

import com.jsict.biz.model.*;
import com.jsict.biz.service.*;
import com.jsict.framework.core.controller.Response;
import com.jsict.framework.core.controller.RestControllerException;
import com.jsict.framework.core.model.IDataDictionary;
import com.jsict.framework.utils.BeanMapper;
import com.jsict.framework.utils.SysConfig;
import com.jsict.framework.utils.performence.Performance;
import com.jsict.framework.utils.performence.PerformanceMonitor;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import com.baidu.ueditor.ActionEnter;

/**
 * Created by caron on 2017/6/6.
 */
@Controller
@RequestMapping("/")
public class CommonController {

    private static final Logger logger = LoggerFactory.getLogger(CommonController.class);

    private static final String LIST_ERROR = "查询列表出错";

    @Autowired
    private UserService userService;

    @Autowired
    private ModuleService moduleService;

    @Autowired
    private DepartmentService departmentService;

    @Autowired
    private DataDictionaryService dataDictionaryService;

    @Autowired
    private InformationContentService informationContentService;

    @Autowired
    private EntityChangeListService entityChangeListService;

    @Autowired
    private SensitiveWordsService sensitiveWordsService;

    @Autowired
    private SysConfig sysConfig;

    @RequestMapping(value = "/getModule/{id}", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public Module get(@PathVariable String id) {
        try{
            return moduleService.get(id);
        }catch (Exception e){
            logger.error("主键查询出错", e);
            throw new RestControllerException("主键查询出错", e);
        }
    }

    @RequestMapping(value = "moduleList", method = RequestMethod.POST,  produces = "application/json")
    @ResponseBody
    public List<Module> moduleList(@ModelAttribute ModuleQuery query){
        try{
            User user = (User)SecurityUtils.getSubject().getPrincipal();
            if(user.isAdmin()){
                return moduleService.find(query);
            }else{
                List<Role> roles = user.getRoleList();
                Department dept = user.getDepartment();
                if(dept.getDeptRoleList()!=null)
                    roles.addAll(dept.getDeptRoleList());
                List<Department> departmentList = user.getDeptList();
                if(departmentList!=null && !departmentList.isEmpty()){
                    for(Department department: departmentList){
                        roles.addAll(department.getDeptRoleList());
                    }
                }
                List<Role> roleList = new ArrayList<>();
                for(Role role: roles)
                    if(!roleList.contains(role))
                        roleList.add(role);
                Map<String, Object> params = BeanMapper.map(query, Map.class);
                List<String> keys = new ArrayList<>();
                for(Map.Entry<String, Object> entry: params.entrySet()){
                    if(entry.getValue()==null)
                        keys.add(entry.getKey());
                }
                if(!keys.isEmpty()) {
                    for(String key: keys)
                        params.remove(key);
                }
                return moduleService.findByRoles(params, roleList);
            }

        }catch (Exception e){
            logger.error(LIST_ERROR, e);
            throw new RestControllerException(LIST_ERROR, e);
        }
    }

    @ResponseBody
    @RequestMapping(value = "/changePassword", method = RequestMethod.POST)
    public Response changePassword(@RequestParam String id, @RequestParam String oldPassword,
                                   @RequestParam String newPassword){
        try{
            userService.changePassword(id, oldPassword, newPassword);
            return new Response(0);
        }catch(Exception e){
            logger.debug("修改密码出错", e);
            return new Response(-1, e.getMessage());
        }
    }

    @RequestMapping(value = "deptList", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public List<Department> list(@ModelAttribute DepartmentQuery query){
        try{
            User user = (User) SecurityUtils.getSubject().getPrincipal();
            if(user.isAdmin() || StringUtils.isNotBlank(query.getParentDeptId()))
                return departmentService.find(query);
            else{
                List<Department> departmentList = new ArrayList<>();
                departmentList.add(user.getDepartment());
                List<Department> departments = user.getDeptList();
                departmentList.addAll(departments);
                return departmentList;
            }
        }catch (Exception e){
            logger.error(LIST_ERROR, e);
            throw new RestControllerException(LIST_ERROR, e);
        }
    }

    @ResponseBody
    @RequestMapping(value = "/getDictionary", method = RequestMethod.POST)
    public List<IDataDictionary> getDictionary(@RequestParam String dictTable, @RequestParam String dictCode,
                                               @RequestParam String dictText){
        return dataDictionaryService.getDictionary(dictTable, dictCode, dictText);
    }

    @RequestMapping(value = "/test", method = RequestMethod.GET)
    public String test(HttpServletRequest request, @RequestParam(required = false) String moduleId){
        request.getSession().setAttribute("moduleId", moduleId);
        return "test";
    }

    @RequestMapping(value = "/getLatestInformation", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public Page<InformationContent> getLatestInformation(@ModelAttribute InformationContent query, @PageableDefault Pageable pageable){
        try{
            return informationContentService.findByPage(query, pageable);
        }catch(Exception e){
            logger.error("翻页查询出错", e);
            throw new RestControllerException("翻页查询出错", e);
        }
    }

    @RequestMapping(value = "/datalogStat", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public List<Map> datalogStat(@RequestParam(required = false) Integer size){
        if(size==null)
            size = 5;
        return entityChangeListService.datalogStat(size);
    }

    @RequestMapping(value = "/performanceStat", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public Performance performanceStat(HttpServletRequest request){
        try{
            return PerformanceMonitor.getPerformence();
        }catch(Exception e){
            logger.debug(e.getLocalizedMessage(), e);
            throw new RestControllerException(e.getMessage());
        }
    }

    /**
     * UEditor文件上传功能
     *
     */
    @RequestMapping(value = "/ueditor")
    public void ueditor(HttpServletRequest request, HttpServletResponse response) throws IOException{
        response.setHeader("Content-Type" , "text/html");
        String rootPath = request.getServletContext().getRealPath( "/" );
        response.getWriter().write( new ActionEnter( request, rootPath ).exec() );
    }

    /**
     * 输出敏感词
     *
     * @param request
     * @param response
     * @throws IOException
     */
    @RequestMapping(value = "/exportWords", method = RequestMethod.POST)
    public void exportWords(HttpServletRequest request, HttpServletResponse response) throws IOException{
        String syncKey = sysConfig.getConfig().getString("sensitive_words_sync_key");
        String syncValue = sysConfig.getConfig().getString("sensitive_words_sync_value");
        String requestSyncValue = request.getHeader(syncKey);
        if(syncValue.equals(requestSyncValue)){
            List<SensitiveWords> sensitiveWordsList = sensitiveWordsService.loadAllWords();
            response.setStatus(200);
            for(SensitiveWords sensitiveWords: sensitiveWordsList){
                response.getWriter().write(sensitiveWords.getWords());
                response.getWriter().write("\n");
            }
        }else{
            response.setStatus(403);
            response.getWriter().write("invalid request");
        }
    }
}
