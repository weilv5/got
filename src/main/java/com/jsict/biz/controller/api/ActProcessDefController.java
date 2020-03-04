package com.jsict.biz.controller.api;

import com.jsict.activiti.ActConstant;
import com.jsict.activiti.entity.*;
import com.jsict.activiti.exception.ResourceNotExistException;
import com.jsict.activiti.service.ActProcessDefService;
import com.jsict.framework.utils.StringUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.io.IOException;

@RestController
@RequestMapping("/activiti/api/procDef")
public class ActProcessDefController {

    private static final Logger logger = LoggerFactory.getLogger(ActProcessDefController.class);


    @Autowired
    ActProcessDefService actProcessDefService;

    @GetMapping(value = "/toPage")
    public ModelAndView toPage(){
        return new ModelAndView("act/processList");
    }
    @GetMapping(value = "/doDeploy")
    public ModelAndView doDeploy(){
        return new ModelAndView("act/doDeploy");
    }
    @GetMapping(value = "/toProcDefView/{id}")
    public ModelAndView toProcDefView(@PathVariable String id){
        ModelAndView mv = new ModelAndView("act/procDefView");
        mv.addObject("id",id);
        return mv;
    }

    @RequestMapping(value="",method=RequestMethod.GET,produces = "application/json;charset=utf-8")
    public ActivitiListResponse<ResponseProcessDef> listProcessDefByPage(RequestProcessDef requestProcessDef, @PageableDefault Pageable page) {
        return new ActivitiListResponse<>(ActConstant.SUCCESS_CODE,"",actProcessDefService.count(requestProcessDef),
                actProcessDefService.listProcessDefByPage(requestProcessDef,page));
    }

    @RequestMapping(value="/{processDefId}",method=RequestMethod.GET,produces = "application/json;charset=utf-8")
    public ActivitiResponse<ResponseProcessDef> getProcessDefById(@PathVariable String processDefId){
        return new ActivitiResponse<>(ActConstant.SUCCESS_CODE,"",actProcessDefService.getProcessDefById(processDefId));
    }

    @RequestMapping(value="/key/{processDefKey}",method=RequestMethod.GET,produces = "application/json;charset=utf-8")
    public ActivitiListResponse<ResponseProcessDef> getProcessDefByKey(@PathVariable String processDefKey){
        return new ActivitiListResponse<>(ActConstant.SUCCESS_CODE,"",actProcessDefService.getProcessDefByKey(processDefKey));
    }

    @PutMapping(value="/{processDefId}",produces = "application/json;charset=utf-8")
    //@RequestMapping(value="/{processDefId}",method=RequestMethod.PUT,produces = "application/json;charset=utf-8")
    public ActivitiResponse<ResponseProcessDef> updateProcessDefState(@PathVariable String processDefId, String action, boolean isIncludeProcIns){
        if (StringUtil.isEmpty(action)){
            action="activate";
        }
        try {
            actProcessDefService.updateProcessDefState(processDefId, action, isIncludeProcIns);
        } catch (ResourceNotExistException e) {
            logger.error("指定ID的流程定义不存在，无法进行相应操作",e);
            return new ActivitiResponse(ActConstant.INNER_ERROR_CODE,"创建失败，指定ID的流程定义不存在");
        }
        return new ActivitiResponse<>(ActConstant.SUCCESS_CODE,"");
    }

    /**
     * 删除部署的流程，级联删除流程实例
     *
     * @param deploymentId
     * @return
     */
    @RequestMapping(value = "/delete")
    @ResponseBody
    public ActivitiResponse<ResponseProcessDef> deleteProcess(@RequestParam("deploymentId") String deploymentId) {
        try {
            actProcessDefService.deleteDeployment(deploymentId);

        } catch (Exception e) {
            logger.error("删除流程定义出错", e);
            return new ActivitiResponse<>(ActConstant.INNER_ERROR_CODE,"删除流程定义失败");
        }
        return new ActivitiResponse<>(ActConstant.SUCCESS_CODE,"删除流程定义成功");
    }

    /**
     * 将流程定义转换为模型
     * @param processDefId
     * @return
     */
    @PostMapping(value="/convert/{processDefId}",produces = "application/json;charset=utf-8")
    public ActivitiResponse<ResponseProcessDef> convertToModel(@PathVariable("processDefId") String processDefId){
        try {
            actProcessDefService.convertToModel(processDefId);
        } catch (IOException e) {
            logger.error("模型转换失败",e);
            return new ActivitiResponse(ActConstant.INNER_ERROR_CODE,"模型转换失败");
        }
        return new ActivitiResponse<>(ActConstant.SUCCESS_CODE,"");

    }


}
