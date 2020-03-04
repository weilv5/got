package com.jsict.biz.service.identity;

import com.jsict.biz.model.Role;
import com.jsict.biz.model.User;
import org.activiti.engine.identity.Group;
import org.activiti.engine.impl.persistence.entity.GroupEntity;
import org.activiti.engine.impl.persistence.entity.UserEntity;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by ian lu on 2018/6/21.
 */
public class Transformer {

    private Transformer() {
        throw new IllegalStateException("Transformer class");
    }
    /**
     * 将婚礼管理的User对象转化为Activiti的用户
     *
     * @param bUser
     * @return
     */
    public static UserEntity toActivitiUser(User bUser){
        UserEntity userEntity = new UserEntity();
        userEntity.setId(bUser.getId());
        userEntity.setFirstName(bUser.getName());
        userEntity.setLastName(bUser.getUserId());
        userEntity.setPassword(bUser.getPassword());
        userEntity.setEmail(bUser.getEmail());
        userEntity.setRevision(1);
        return userEntity;
    }

    /**
     * 将婚礼管理的角色转化为Activiti的组
     *
     * @param role
     * @return
     */
    public static GroupEntity toActivitiGroup(Role role){
        GroupEntity groupEntity = new GroupEntity();
        groupEntity.setRevision(1);
        groupEntity.setType("assignment");
        //taskCandidateUser等方法是通过groupEntity.id来查询的，对应流程定义文件中的activiti:candidateGroups等值
        groupEntity.setId(role.getId());
        groupEntity.setName(role.getRoleName());
        return groupEntity;
    }



    /**
     * 将婚礼管理的角色List转化为Activiti的组List
     *
     * @param roleList
     * @return
     */
    public static List<Group> toActivitiGroups(List<Role> roleList){
        List<Group> groupEntitys = new ArrayList<>();

        for (Role userRole : roleList) {
            GroupEntity groupEntity = toActivitiGroup(userRole);
            groupEntitys.add(groupEntity);
        }
        return groupEntitys;
    }

}
