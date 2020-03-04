package com.jsict.biz.controller.api;

import com.jsict.activiti.ActConstant;
import com.jsict.activiti.entity.*;
import com.jsict.activiti.exception.ResourceNotExistException;
import com.jsict.activiti.service.ActProcInstanceService;
import com.jsict.biz.model.Role;
import com.jsict.biz.model.User;
import com.jsict.framework.utils.StringUtil;
import org.activiti.engine.HistoryService;
import org.apache.shiro.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/activiti/api/procInstacne")
public class ActProcInstanceController {
    private static final Logger logger = LoggerFactory.getLogger(ActProcInstanceController.class);
    @Autowired
    ActProcInstanceService actProcInstacneService;
    @Autowired
    HistoryService historyService;

    @GetMapping(value = "/toPage")
    public ModelAndView toPage() {
        return new ModelAndView("act/hisProcInstanceList");
    }

    @GetMapping(value = "/toProcInstacneView/{id}")
    public ModelAndView toProcInstacneView(@PathVariable String id) {
        ModelAndView mv = new ModelAndView("act/procInstanceView");
        mv.addObject("id", id);
        return mv;
    }

    @RequestMapping(value = "/{procInstanceId}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    public ActivitiResponse<ResponseProcInstance> getProcInstanceById(@PathVariable String procInstanceId) {
        return new ActivitiResponse<>(ActConstant.SUCCESS_CODE, "", actProcInstacneService.getProcInstanceById(procInstanceId));
    }

    /**
     * 我发起的流程
     *
     * @param requestProcInstance
     * @param page
     * @return
     */
    @RequestMapping(value = "/hisProcInstanceList", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    public ActivitiListResponse<ResponseProcInstance> listHisProcInstanceByPage(RequestProcInstance requestProcInstance, @PageableDefault Pageable page) {
        User user = (User) SecurityUtils.getSubject().getPrincipal();
        List<String> groups = new ArrayList<>();
        List<Role> roles = user.getRoleList();
        if (roles != null) {
            for (Role role : roles) {
                groups.add(role.getRoleName());
                groups.add(user.getDepartment().getDeptCode() + "|" + role.getRoleName());
            }
        }
        requestProcInstance.setCurrentUserId(user.getUserId());
        requestProcInstance.setUserRoleList(groups);
        try {
            return new ActivitiListResponse<>(ActConstant.SUCCESS_CODE, "", actProcInstacneService.count(requestProcInstance, true), actProcInstacneService.getHisProcInstanceList(requestProcInstance, page));
        } catch (ParseException e) {
            logger.error("请求失败，日期解析异常", e);
            return new ActivitiListResponse<>(ActConstant.INNER_ERROR_CODE, "", 0, null);
        }
    }

    @PutMapping(value = "/{procInstanceId}", produces = "application/json;charset=utf-8")
    public ActivitiResponse<ResponseProcInstance> updateProcInstanceState(@PathVariable String procInstanceId, String action) {
        if (StringUtil.isEmpty(action)) {
            action = "activate";
        }
        try {
            actProcInstacneService.updateProcInstanceState(procInstanceId, action);
        } catch (ResourceNotExistException e) {
            logger.error("指定ID的流程实例不存在，无法进行相应操作", e);
            return new ActivitiResponse(ActConstant.INNER_ERROR_CODE, "创建失败，指定ID的流程实例不存在");
        }
        return new ActivitiResponse<>(ActConstant.SUCCESS_CODE, "");
    }


    /**
     * 获取指定流程图
     *
     * @param procInstanceId
     * @param response
     * @throws IOException
     */
    @RequestMapping(value = "/diagram", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    public void getDiagram(@RequestParam(value = "procInstanceId", required = false) String procInstanceId, HttpServletResponse response) throws IOException {
        InputStream inputStream = actProcInstacneService.getDiagramByProcessInstanceId(procInstanceId);
        try {
            byte[] b = new byte[1024];
            int len;
            while ((len = inputStream.read(b, 0, 1024)) != -1) {
                response.getOutputStream().write(b, 0, len);
            }
        } catch (Exception e) {
            logger.error("获取流程图失败", e);
        }

    }

    @RequestMapping(value = "/delete")
    @ResponseBody
    public ActivitiResponse<ResponseProcInstance> deleteProcInstance(@RequestParam("procInstanceId") String procInstanceId) {
        try {
            actProcInstacneService.deleteProcInstance(procInstanceId);

        } catch (Exception e) {
            logger.error("删除流程实例出错", e);
            return new ActivitiResponse<>(ActConstant.INNER_ERROR_CODE, "删除流程实例失败");
        }
        return new ActivitiResponse<>(ActConstant.SUCCESS_CODE, "删除流程实例成功");
    }

    /**
     * 该接口仅供简单流程启动，在UDP5中，仅为演示示例而提供，在实际使用时，应当视具体业务流程的启动需求而自行开发
     *
     * @param processDefinitionKey 流程定义Key
     * @param businessKey          关联业务表对象ID
     * @param variables            流程变量列表
     * @param userId               qid
     * @return
     */
    public ActivitiResponse startProcessByProDefKey(String processDefinitionKey, String businessKey, Map<String, Object> variables, String userId) {
        return actProcInstacneService.startProcessByProDefKey(processDefinitionKey, businessKey, variables, userId);
    }


}
