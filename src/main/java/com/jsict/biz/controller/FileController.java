package com.jsict.biz.controller;

import com.jsict.biz.util.FileUploadUtil;
import com.jsict.framework.core.controller.RestControllerException;
import com.jsict.framework.filter.EscapeScriptwrapper;
import com.jsict.framework.utils.Identities;
import com.jsict.framework.utils.SysConfig;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.web.servlet.ShiroHttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.*;

@Controller
@RequestMapping({"/file"})
public class FileController
{
    @Autowired
    protected SysConfig sysConfig;

    @RequestMapping(value={"/upload"}, method={org.springframework.web.bind.annotation.RequestMethod.POST})
    @ResponseBody
    public String fileUpload(HttpServletRequest request)
    {
        String headpath = "";
        String model = request.getParameter("model");
        if ("richtxt".equals(model))
        {
            String scheme = request.getScheme();
            String serverName = request.getServerName();
            int port = request.getServerPort();

            headpath = scheme + "://" + serverName + ":" + port + "/";
        }
        request = changeRequest(request);
        try
        {
            String allowedFiles = this.sysConfig.getConfig().getString("allowedFiles");
            List<String> allowedFileList = getAllowedFileList(allowedFiles);
            String uploadPath = this.sysConfig.getConfig().getString("uploadPath");
            MultipartHttpServletRequest multipartReq = (MultipartHttpServletRequest)request;
            Map<String, MultipartFile> fileMap = multipartReq.getFileMap();
            Iterator localIterator = fileMap.entrySet().iterator();
            if (localIterator.hasNext())
            {
                Map.Entry<String, MultipartFile> me = (Map.Entry)localIterator.next();
                MultipartFile multipartFile = (MultipartFile)me.getValue();
                File fileDir = new File(uploadPath);
                if (!fileDir.exists()) {
                    fileDir.mkdirs();
                }
                String originalFilename = multipartFile.getOriginalFilename();
                int pos = originalFilename.lastIndexOf('.');
                String suffix = originalFilename.substring(pos + 1);
                if (!allowedFileList.contains(suffix.toLowerCase())) {
                    throw new RestControllerException("上传文件文件格式不合法，支持的文件格式为：" + allowedFiles.replace("|", "、"));
                }
                String fileName = Identities.uuid2() + "." + suffix;
                File targetFile = new File(fileDir, fileName);
                FileUtils.copyInputStreamToFile(multipartFile.getInputStream(), targetFile);
                return FileUploadUtil.result(headpath + targetFile.getPath(), originalFilename);
            }
            return FileUploadUtil.result("文件不存在");
        }
        catch (Exception e)
        {
            return FileUploadUtil.result(e.getMessage());
        }
    }

    private HttpServletRequest changeRequest(HttpServletRequest request)
    {
        if ((request instanceof ShiroHttpServletRequest))
        {
            EscapeScriptwrapper escapeScriptwrapper = (EscapeScriptwrapper)((ShiroHttpServletRequest)request).getRequest();
            if (escapeScriptwrapper.hasMultipart()) {
                return escapeScriptwrapper.getOrigRequest();
            }
            return request;
        }
        return request;
    }

    private List<String> getAllowedFileList(String allowedFiles)
    {
        List<String> allowedFileList = new ArrayList<>();
        if (StringUtils.isNotBlank(allowedFiles)) {
            allowedFileList.addAll(Arrays.asList(allowedFiles.split("\\|")));
        }
        return allowedFileList;
    }
}
