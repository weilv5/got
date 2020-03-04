package com.jsict.biz.controller.api;

import com.jsict.activiti.ActConstant;
import com.jsict.activiti.entity.ActivitiListResponse;
import com.jsict.activiti.entity.ActivitiResponse;
import com.jsict.activiti.entity.ResponseModel;
import com.jsict.activiti.service.ActModelService;
import com.jsict.framework.utils.StringUtil;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;

@RestController
@RequestMapping("/activiti/api/model")
public class ActModelController {

    private static final Logger logger = LoggerFactory.getLogger(ActModelController.class);


    @Autowired
    ActModelService actModelService;

    @GetMapping(value = "/edit")
    public ModelAndView doDeploy(){
        return new ModelAndView("act/edit");
    }

    /**
     * 跳转到模型列表页
     * @return
     */
    @GetMapping(value = "/toModelPage")
    public ModelAndView toModelPage(){
        return new ModelAndView("act/page");
    }

    @RequestMapping(value="",method=RequestMethod.GET,produces = "application/json;charset=utf-8")
    public ActivitiListResponse<ResponseModel> listByPage(String name, String key, @PageableDefault Pageable page){
        return new ActivitiListResponse<>(ActConstant.SUCCESS_CODE,"",actModelService.count(name,key),
                actModelService.listModelByPage(name, key, page));
    }

    @RequestMapping(value="/{modelId}",method=RequestMethod.GET,produces = "application/json;charset=utf-8")
    public ActivitiResponse<ResponseModel> getModelById(@PathVariable String modelId){
        return new ActivitiResponse<>(ActConstant.SUCCESS_CODE,"",actModelService.getModelById(modelId));
    }

    @RequestMapping(value = "",method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
    public ActivitiResponse createNewModel(String name, String key){
        try {
            actModelService.createNewModel(name,key);
        } catch (UnsupportedEncodingException e) {
            logger.error("save modelEditorSource error, json to byte error",e);
            return new ActivitiResponse(ActConstant.INNER_ERROR_CODE,"创建失败，保存数据异常");
        }
        return new ActivitiResponse(ActConstant.SUCCESS_CODE);
    }

    @RequestMapping(value="/{modelId}",method=RequestMethod.DELETE,produces = "application/json;charset=utf-8")
    public ActivitiResponse deleteModelById(@PathVariable String modelId){
        if(StringUtil.isNotEmpty(actModelService.getModelById(modelId).getId())){
            actModelService.deleteModelById(modelId);
            return new ActivitiResponse(ActConstant.SUCCESS_CODE);
        }
        return new ActivitiResponse(ActConstant.INNER_ERROR_CODE,"删除失败，指定ID的模型不存在");
    }

    @RequestMapping(value="/bpmn/{modelId}",method=RequestMethod.GET,produces = "multipart/form-data")
    public void getBpmnFile(@PathVariable String modelId, HttpServletResponse response){
        try {
            ByteArrayInputStream inputStream = actModelService.getBpmnFile(modelId);
            String fileName = modelId + ActConstant.BPMN_SUFFIX;
            response.setBufferSize(1024*32);
            IOUtils.copy(inputStream,response.getOutputStream());
            response.setHeader("Content-Disposition", "attachment;filename="+fileName);
            response.flushBuffer();
        } catch (IOException e){
            logger.error("下载指定模型的BPMN文件失败",e);
        }
    }
}
