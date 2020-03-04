package com.jsict.biz.controller.api;

import com.jsict.activiti.ActConstant;
import com.jsict.activiti.entity.ActivitiListResponse;
import com.jsict.activiti.entity.RequestTask;
import com.jsict.activiti.entity.ResponseTask;
import com.jsict.activiti.service.ActProcInstanceService;
import com.jsict.activiti.service.ActTaskService;
import com.jsict.biz.model.Role;
import com.jsict.biz.model.User;
import org.apache.shiro.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/activiti/api/task")
public class ActTaskController {

    private static final Logger logger = LoggerFactory.getLogger(ActTaskController.class);

    @Autowired
    ActTaskService actTaskService;

    @Autowired
    ActProcInstanceService actProcInstacneService;
    /**
     * 跳转到待办任务列表
     * @return
     */
    @GetMapping(value = "/toTaskPage")
    public ModelAndView toTaskPage(){
        return new ModelAndView("act/taskList");
    }
    /**
     * 跳转到已办任务列表
     * @return
     */
    @GetMapping(value = "/toHisTaskPage")
    public ModelAndView toHisTaskPage(){
        return new ModelAndView("act/doneTaskList");
    }


    @RequestMapping(value="ruTask",method=RequestMethod.GET,produces = "application/json;charset=utf-8")
    public ActivitiListResponse<ResponseTask> listRuTaskByPage(RequestTask requestTask, @PageableDefault Pageable page) {
        User user = (User) SecurityUtils.getSubject().getPrincipal();
        List<String> groups = new ArrayList<>();
        List<Role> roles = user.getRoleList();
        if(roles !=null){
            for (Role role :roles){
                groups.add(role.getRoleName());
                groups.add(user.getDepartment().getDeptCode()+"|"+role.getRoleName());
            }
        }
        requestTask.setCurrentUserId(user.getUserId());
        requestTask.setUserRoleList(groups);
        try {
            return new ActivitiListResponse<>(ActConstant.SUCCESS_CODE,"",actTaskService.count(requestTask,false),
                   actTaskService.getRuTaskList(requestTask, page));
        } catch (ParseException e) {
            logger.error("请求失败，日期解析异常",e);
            return new ActivitiListResponse<>(ActConstant.INNER_ERROR_CODE,"",0,null);
        }
    }

    @RequestMapping(value="hiTask",method=RequestMethod.GET,produces = "application/json;charset=utf-8")
    public ActivitiListResponse<ResponseTask> listHiTaskByPage(RequestTask requestTask, @PageableDefault Pageable page) {
        User user = (User) SecurityUtils.getSubject().getPrincipal();
        List<String> groups = new ArrayList<>();
        List<Role> roles = user.getRoleList();
        if(roles !=null){
            for (Role role :roles){
                groups.add(role.getRoleName());
                groups.add(user.getDepartment().getDeptCode()+"|"+role.getRoleName());
            }
        }
        requestTask.setCurrentUserId(user.getUserId());
        requestTask.setUserRoleList(groups);
        try {
            return new ActivitiListResponse<>(ActConstant.SUCCESS_CODE,"",actTaskService.count(requestTask,true),
                    actTaskService.getHiTaskList(requestTask, page));
        } catch (ParseException e) {
            logger.error("请求失败，日期解析异常",e);
            return new ActivitiListResponse<>(ActConstant.INNER_ERROR_CODE,"",0,null);
        }
    }
}
