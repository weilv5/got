/**
 * Copyright 2013 hongxin 
 * Change Revision
 * ---------------------------------------------------------------
 * Date               Author            Remarks
 * 2013-5-13          YuWeitao          create
 * ---------------------------------------------------------------
 */
package com.jsict.biz.service.identity;

import org.activiti.engine.impl.interceptor.Session;
import org.activiti.engine.impl.interceptor.SessionFactory;
import org.activiti.engine.impl.persistence.entity.GroupEntityManager;
import org.springframework.beans.factory.annotation.Autowired;


/**
 * Created by ian lu on 2018/6/21.
 */
public class CustomGroupEntityManagerFactory implements SessionFactory {
    private GroupEntityManager groupEntityManager;
  
    @Autowired
    public void setGroupEntityManager(GroupEntityManager groupEntityManager) {
        this.groupEntityManager = groupEntityManager;   
    }   

    @Override
    public Class<?> getSessionType() {   
        // 返回原始的GroupEntityManager类型   
        return GroupEntityManager.class;
    }   

    @Override
    public Session openSession() {
        // 返回自定义的GroupEntityManager实例   
        return groupEntityManager;   
    }   
}  