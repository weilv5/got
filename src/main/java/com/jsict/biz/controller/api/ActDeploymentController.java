package com.jsict.biz.controller.api;

import com.jsict.activiti.ActConstant;
import com.jsict.activiti.entity.ActivitiResponse;
import com.jsict.activiti.exception.ResourceNotExistException;
import com.jsict.activiti.service.ActDeploymentService;
import org.apache.shiro.web.servlet.ShiroHttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/activiti/api/deployment")
public class ActDeploymentController {

    private static final Logger logger = LoggerFactory.getLogger(ActDeploymentController.class);

    @Autowired
    ActDeploymentService actDeploymentService;

    @RequestMapping(value = "/{modelId}",method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
    public ActivitiResponse deploy(@PathVariable String modelId){
        try {
            actDeploymentService.deploy(modelId);
        } catch (IOException e){
            logger.error("模型部署时，ModelEditorSource转换异常",e);
            return new ActivitiResponse(ActConstant.INNER_ERROR_CODE,"部署失败，数据转换异常");
        } catch (ResourceNotExistException e){
            logger.error("模型部署时，未找到指定资源",e);
            return new ActivitiResponse(ActConstant.INNER_ERROR_CODE,e.getMessage());
        }
        return new ActivitiResponse(ActConstant.SUCCESS_CODE);
    }

    @RequestMapping(value = "/{deploymentId}",method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
    public ActivitiResponse deleteDeploymentById(@PathVariable String deploymentId){
        if(null == actDeploymentService.getDeploymentById(deploymentId)){
            return new ActivitiResponse(ActConstant.INNER_ERROR_CODE,"删除失败，指定ID的部署不存在");
        }
        actDeploymentService.deleteDeploymentById(deploymentId);
        return new ActivitiResponse(ActConstant.SUCCESS_CODE);
    }

    /**
     * 根据上传文件新建部署，支持后缀为zip、bar、xml的文件
     * @param request
     * @return
     */
    @RequestMapping(value = "/bpmn",method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
    public ActivitiResponse deployByBpmn(HttpServletRequest request) {
        List<String> allowedFileList = new ArrayList<>();
        allowedFileList.add("xml");
        allowedFileList.add("zip");
        allowedFileList.add("bar");
        try {

            ShiroHttpServletRequest shiroRequest = (ShiroHttpServletRequest) request;
            CommonsMultipartResolver commonsMultipartResolver = new CommonsMultipartResolver();
            MultipartHttpServletRequest multipartReq = commonsMultipartResolver.resolveMultipart((HttpServletRequest) shiroRequest.getRequest());
            Map<String, MultipartFile> fileMap = multipartReq.getFileMap();
            if(fileMap.size() > 1){
                return new ActivitiResponse(ActConstant.INNER_ERROR_CODE,"部署失败，不支持多文件上传部署");
            }

            for (Map.Entry<String, MultipartFile> me : fileMap.entrySet()) {
                MultipartFile multipartFile = me.getValue();
                String originalFilename = multipartFile.getOriginalFilename();
                int pos = originalFilename.lastIndexOf('.');
                String suffix = originalFilename.substring(pos+1);
                if(!allowedFileList.contains(suffix)){
                    return new ActivitiResponse(ActConstant.INNER_ERROR_CODE,"部署失败，不支持的文件后缀");
                }
                actDeploymentService.deployByBpmn(originalFilename,multipartFile.getInputStream());
                break;
            }
            return new ActivitiResponse(ActConstant.SUCCESS_CODE);
        } catch (IOException e){
            logger.error("根据BPMN文件部署流程异常：文件处理异常",e);
            return new ActivitiResponse(ActConstant.INNER_ERROR_CODE,"部署失败，文件处理异常");
        }
    }
}
