/**
 * Copyright 2013 hongxin
 * Change Revision
 * ---------------------------------------------------------------
 * Date               Author            Remarks
 * 2013-5-13          YuWeitao          create
 * ---------------------------------------------------------------
 */
package com.jsict.biz.service.identity;


import com.jsict.biz.model.Role;
import com.jsict.biz.model.User;
import com.jsict.biz.service.RoleService;
import com.jsict.biz.service.UserService;
import org.activiti.engine.identity.Group;
import org.activiti.engine.impl.Page;
import org.activiti.engine.impl.UserQueryImpl;
import org.activiti.engine.impl.persistence.entity.UserEntity;
import org.activiti.engine.impl.persistence.entity.UserEntityManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * 自定义Activiti用户管理类
 *
 * @author Ian Lu
 */
@Service
public class CustomUserEntityManager extends UserEntityManager {

    @Autowired
    private UserService userService;

    @Autowired
    private RoleService roleService;

    @Override
    public UserEntity findUserById(final String userName) {
        if (userName == null)
            return null;

        try {
            User query = new User();
            query.setUserId(userName);
            User user = userService.find(query).get(0);
            return Transformer.toActivitiUser(user);
        } catch (Exception e) {
            throw e;
        }
    }

    @Override
    public List<Group> findGroupsByUser(final String userName) {
        if (userName == null)
            return new ArrayList<>();
        User uquery = new User();
        uquery.setUserId(userName);
        User user = userService.find(uquery).get(0);
        List<Role> roleList = user.getRoleList();
        return Transformer.toActivitiGroups(roleList);
    }

    @Override
    public List<org.activiti.engine.identity.User> findUserByQueryCriteria(UserQueryImpl query, Page page) {
        int pageNumb;
        int pageSize;
        pageNumb = page.getFirstResult() / page.getMaxResults() + 1;
        pageSize = page.getMaxResults();
        Map<String, Object> map = new HashMap<>();
        if (query.getFullNameLike() != null) {
            map.put("userId", query.getFullNameLike());
        }

        Pageable pagination = new PageRequest(pageNumb, pageSize);
        org.springframework.data.domain.Page spage = userService.findByPage(map, pagination);
        List<org.activiti.engine.identity.User> userEntityList = new ArrayList<>();

        Iterator iter = spage.iterator();
        while (iter.hasNext()) {
            User user = (User) iter.next();
            userEntityList.add(Transformer.toActivitiUser(user));
        }

        return userEntityList;
    }


    @Override
    public long findUserCountByQueryCriteria(UserQueryImpl query) {
        User uquery = new User();
        uquery.setUserId(query.getFullNameLike());
        return userService.find(uquery).size();
    }

}
