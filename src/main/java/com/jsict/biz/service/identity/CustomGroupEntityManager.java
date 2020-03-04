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
import org.activiti.engine.impl.GroupQueryImpl;
import org.activiti.engine.impl.Page;
import org.activiti.engine.impl.persistence.entity.GroupEntity;
import org.activiti.engine.impl.persistence.entity.GroupEntityManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.*;


/**
 * Created by ian lu on 2018/6/21.
 */
@Service
public class CustomGroupEntityManager extends GroupEntityManager {
    @Autowired
    private UserService userService;

    @Autowired
    private RoleService roleService;


    @Override
    public List<Group> findGroupByQueryCriteria(GroupQueryImpl query, Page page) {
        int pageNumb;
        int pageSize;
        pageNumb = page.getFirstResult() / page.getMaxResults() + 1;
        pageSize = page.getMaxResults();
        Map<String, Object> map = new HashMap<>();
        if (query.getName() != null) {
            map.put("roleName", query.getName());
        }
        Pageable pagination = new PageRequest(pageNumb, pageSize);
        org.springframework.data.domain.Page spage = roleService.findByPage(map, pagination);
        List<Group> groupList = new ArrayList<>();
        Iterator iter = spage.iterator();
        while (iter.hasNext()) {
            Role role = (Role) iter.next();
            groupList.add(Transformer.toActivitiGroup(role));
        }

        return groupList;
    }

    @Override
    public long findGroupCountByQueryCriteria(GroupQueryImpl query) {
        Role rquery = new Role();
        rquery.setRoleName(query.getName());
        return roleService.find(rquery).size();
    }


    @Override
    public List<Group> findGroupsByNativeQuery(Map<String, Object> parameterMap, int firstResult, int maxResults) {
        return new ArrayList<>();
    }

    @Override
    public long findGroupCountByNativeQuery(Map<String, Object> parameterMap) {
        return -1;
    }

    @Override
    public List<Group> findGroupsByUser(final String userName) {
        if (userName == null)
            return new ArrayList<>();
        User userQuery = new User();
        userQuery.setUserId(userName);
        User user = userService.find(userQuery).get(0);
        List<Role> roleList = user.getRoleList();
        List<Group> gs = new ArrayList<>();
        GroupEntity groupEntity;
        for (Role role : roleList) {
            groupEntity = new GroupEntity();
            groupEntity.setRevision(1);
            groupEntity.setType("assignment");

            groupEntity.setId(role.getRoleName());   //taskCandidateUser等方法是通过groupEntity.id来查询的，对应流程定义文件中的activiti:candidateGroups等值
            groupEntity.setName(role.getRoleName());
            gs.add(groupEntity);
        }
        return gs;
    }
}  
