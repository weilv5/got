package com.jsict.biz.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.jsict.biz.model.Role;
import com.jsict.biz.model.User;
import com.jsict.framework.core.controller.Response;
import com.jsict.framework.filter.EscapeScriptwrapper;
import org.activiti.bpmn.model.BpmnModel;
import org.activiti.editor.constants.ModelDataJsonConstants;
import org.activiti.editor.language.json.converter.BpmnJsonConverter;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.TaskService;
import org.activiti.engine.repository.*;
import org.activiti.engine.task.Task;
import org.activiti.engine.task.TaskQuery;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.web.servlet.ShiroHttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by ian lu on 2018/5/28.
 */
@Controller
@RequestMapping("/activiti")
public class ActivitiController {

    private static final Logger logger = LoggerFactory.getLogger(ActivitiController.class);

    protected static Map<String, ProcessDefinition> pROCESSDEFINITIONCACHE = new HashMap<>();

    @Autowired
    protected RepositoryService repositoryService;

    @Autowired
    protected TaskService taskService;

    protected static final String BPMN_SUFFIX = ".bpmn20.xml";

    /**
     * 流程定义列表
     *
     * @return
     * @author Ian Lu
     */
    @RequestMapping(value = "/processDefinitionPage", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public Page<HashMap<String, Object>> processDefinitionPage(@PageableDefault Pageable pageable) {

        List<HashMap<String, Object>> mapList = new ArrayList<>();
        ProcessDefinitionQuery processDefinitionQuery = repositoryService.createProcessDefinitionQuery();

        processDefinitionQuery.orderByDeploymentId().desc();
        List<ProcessDefinition> processDefinitionList = processDefinitionQuery.listPage(pageable.getOffset(), pageable.getPageSize());
        for (ProcessDefinition processDefinition : processDefinitionList) {
            String deploymentId = processDefinition.getDeploymentId();
            Deployment deployment = repositoryService.createDeploymentQuery().deploymentId(deploymentId).singleResult();

            HashMap<String, Object> map = new HashMap<>();
            map.put("id", processDefinition.getId());
            map.put("deploymentId", processDefinition.getDeploymentId());
            map.put("deploymentTime", deployment.getDeploymentTime());
            map.put("key", processDefinition.getKey());
            map.put("name", processDefinition.getName());
            map.put("category", processDefinition.getCategory());
            map.put("resourceName", processDefinition.getResourceName());
            map.put("version", processDefinition.getVersion());
            map.put("desc", processDefinition.getDescription());
            map.put("hasStartFormKey", processDefinition.hasStartFormKey());
            map.put("isSuspended", processDefinition.isSuspended());
            map.put("diagramResourceName", processDefinition.getDiagramResourceName());
            mapList.add(map);
        }

        return new PageImpl<>(mapList, pageable, processDefinitionQuery.count());

    }

    /**
     * 通过模型文件部署
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/deploy",method = RequestMethod.POST)
    @ResponseBody
    public Response deploy(HttpServletRequest request) {

        try {
            EscapeScriptwrapper escapeScriptwrapper = (EscapeScriptwrapper)((ShiroHttpServletRequest)request).getRequest();
            MultipartHttpServletRequest multipartReq = (MultipartHttpServletRequest) escapeScriptwrapper.getOrigRequest();
            Map<String, MultipartFile> fileMap = multipartReq.getFileMap();
            for (Map.Entry<String, MultipartFile> mf : fileMap.entrySet()) {
                MultipartFile multipartFile = mf.getValue();
                repositoryService.createDeployment().addInputStream(multipartFile.getOriginalFilename(),multipartFile.getInputStream()).deploy();
            }
        } catch (Exception e) {
            logger.error("流程部署出错", e);
            return new Response(-1, e.getMessage());
        }
        return new Response(0);
    }


    /**
     * 待办、待签任务列表
     *
     * @return
     */
    @RequestMapping(value = "/task/todo/list", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public Page<HashMap<String, Object>> todoList(@PageableDefault Pageable pageable) {
        List<HashMap<String,Object>> mapList = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm");
        User user = (User) SecurityUtils.getSubject().getPrincipal();
        List<String> groups = new ArrayList<>();
        List<Role> roles = user.getRoleList();
        if(roles !=null){
            for (Role role :roles){
                groups.add(role.getRoleName());
                groups.add(user.getDepartment().getDeptCode()+"|"+role.getRoleName());
            }
        }
        //重写acticiti identity接口
        TaskQuery claimedTaskQuery = taskService.createTaskQuery().taskCandidateOrAssigned(user.getUserId());
        if(!groups.isEmpty())
            claimedTaskQuery.taskCandidateGroupIn(groups);
        claimedTaskQuery.active().orderByTaskId().desc();
        List<Task> todoList = claimedTaskQuery.list();
        for (Task task : todoList) {
            String processDefinitionId = task.getProcessDefinitionId();
            ProcessDefinition processDefinition = getProcessDefinition(processDefinitionId);
            HashMap<String, Object> singleTask = packageTaskInfo(sdf, task, processDefinition);
            mapList.add(singleTask);
        }


        return new PageImpl<>(mapList,pageable,todoList.size());
    }

    /**
     * 删除部署的流程，级联删除流程实例
     *
     * @param deploymentId
     * @return
     */
    @RequestMapping(value = "/process/delete")
    @ResponseBody
    public Response deleteProcess(@RequestParam("deploymentId") String deploymentId) {
        try {
            repositoryService.deleteDeployment(deploymentId, true);
            return new Response(0);
        } catch (Exception e) {
            logger.error("删除流程定义出错", e);
            return new Response(-1, e.getMessage());
        }
    }

    /**
     * 挂起、激活流程实例
     *
     * @param state
     * @param processDefinitionId
     * @return
     */
    @RequestMapping(value = "/processdefinition/update/{state}/{processDefinitionId}", method = RequestMethod.GET, produces = "application/json")
    @ResponseBody
    public Response updateState(@PathVariable("state") String state, @PathVariable("processDefinitionId") String processDefinitionId) {
        Response response = null;
        if (state.equals("suspend")) {
            repositoryService.activateProcessDefinitionById(processDefinitionId, true, null);
            response = new Response(0, "已激活ID为[" + processDefinitionId + "]的流程定义。");
        } else if (state.equals("active")) {
            repositoryService.suspendProcessDefinitionById(processDefinitionId, true, null);
            response = new Response(0, "已挂起ID为[" + processDefinitionId + "]的流程定义。");
        }
        return response;
    }

    private HashMap<String, Object> packageTaskInfo(SimpleDateFormat sdf, Task task, ProcessDefinition processDefinition) {
        HashMap<String, Object> singleTask = new HashMap<>();
        singleTask.put("id", task.getId());
        singleTask.put("name", task.getName());
        singleTask.put("createTime", sdf.format(task.getCreateTime()));
        singleTask.put("pdname", processDefinition.getName());
        singleTask.put("pdversion", processDefinition.getVersion());
        singleTask.put("pid", task.getProcessInstanceId());
        singleTask.put("owner",task.getOwner());
        return singleTask;
    }

    private ProcessDefinition getProcessDefinition(String processDefinitionId) {
        ProcessDefinition processDefinition = pROCESSDEFINITIONCACHE.get(processDefinitionId);
        if (processDefinition == null) {
            processDefinition = repositoryService.createProcessDefinitionQuery().processDefinitionId(processDefinitionId).singleResult();
            pROCESSDEFINITIONCACHE.put(processDefinitionId, processDefinition);
        }
        return processDefinition;
    }

    @RequestMapping(value = "/process")
    public String process(HttpServletRequest request) {
        return "act/processList";
    }

    @RequestMapping(value = "/doDeploy")
    public String doDeploy(){
      return "act/doDeploy";
    }

    @RequestMapping(value = "/task",method = RequestMethod.GET)
    public String task(){
        return "act/taskList";
    }

    private HashMap<String, Object> packageModelInfo(Model model) {
        HashMap<String, Object> singleModel = new HashMap<>();
        singleModel.put("id", model.getId());
        singleModel.put("key", model.getKey());
        singleModel.put("name",model.getName());
        singleModel.put("metaInfo", model.getMetaInfo());
        return singleModel;
    }

    @RequestMapping("/model/list")
    @ResponseBody
    public Page<HashMap<String, Object>> list(@PageableDefault Pageable pageable){
        List<HashMap<String,Object>> mapList = new ArrayList<>();
        List<Model> models = repositoryService.createModelQuery().list();

        if(null != models){
            models.forEach(model ->
                mapList.add(packageModelInfo(model))
            );
            return new PageImpl<>(mapList,pageable,models.size());
        }else return null;


    }

    @RequestMapping("/model/page")
    public String models(){
        return "act/page";
    }

    @RequestMapping("/model/edit")
    public String editModel(){
        return "act/edit";
    }

    @RequestMapping(value = "/model/save", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public Response save(String name, String key, String metaInfo) throws IOException {

        ObjectMapper objectMapper = new ObjectMapper();
        ObjectNode editorNode = objectMapper.createObjectNode();
        editorNode.put("id", "canvas");
        editorNode.put("resourceId", "canvas");
        ObjectNode stencilSetNode = objectMapper.createObjectNode();
        stencilSetNode.put("namespace", "http://b3mn.org/stencilset/bpmn2.0#");
        editorNode.put("stencilset", stencilSetNode);
        ObjectNode modelObjectNode = objectMapper.createObjectNode();
        modelObjectNode.put(ModelDataJsonConstants.MODEL_NAME, name);
        modelObjectNode.put(ModelDataJsonConstants.MODEL_REVISION, 1);
        modelObjectNode.put(ModelDataJsonConstants.MODEL_DESCRIPTION, metaInfo);

        Model modelData = repositoryService.newModel();
        modelData.setKey(key);
        modelData.setMetaInfo(modelObjectNode.toString());
        modelData.setName(name);
        repositoryService.saveModel(modelData);

        repositoryService.addModelEditorSource(modelData.getId(), editorNode.toString().getBytes("utf-8"));

        return new Response(0);
    }

    @RequestMapping(value = "/model/delete/{id}", method = RequestMethod.POST, produces = "application/json")
    @ResponseBody
    public Response deleteModel(@PathVariable String id){
        Response response;
        try{
            repositoryService.deleteModel(id);
            response = new Response(0);
        }catch(Exception e){
            logger.error(e.getLocalizedMessage(), e);
            response = new Response(-1, e.getLocalizedMessage());
        }
        return response;
    }
    /**
     * 模型管理-流程部署
     * @param modelId
     * @return
     */
    @RequestMapping(value = "/model/deploy/{modelId}",method = RequestMethod.GET,produces = "application/json")
    @ResponseBody
    public Response modelDeploy(@PathVariable String modelId){
        Response response;
        try {
            Model modelData = repositoryService.getModel(modelId);
            JsonNode modelNode = new ObjectMapper().readTree(repositoryService.getModelEditorSource(modelData.getId()));
            BpmnModel bpmnModel = new BpmnJsonConverter().convertToBpmnModel(modelNode);

            String processName = modelData.getName() + BPMN_SUFFIX;
            DeploymentBuilder deploymentBuilder = repositoryService.createDeployment().name(modelData.getName()).addBpmnModel(processName, bpmnModel);

            List<JsonNode> list = modelNode.findValues("formkeydefinition");
            for (JsonNode node : list) {
                if (null != node.asText() && !"".equalsIgnoreCase(node.asText())) {
                    deploymentBuilder.addClasspathResource(node.asText());
                }
            }
            deploymentBuilder.deploy();

            response = new Response(0);
        } catch (Exception e) {
            logger.error("部署模型失败", e);
            response = new Response(-1, e.getLocalizedMessage());
        }
        return response;
    }


}

