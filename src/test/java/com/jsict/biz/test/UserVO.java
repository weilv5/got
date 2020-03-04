package com.jsict.biz.test;

import org.hibernate.type.StandardBasicTypes;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * USerVO，用于BeanMapper测试
 *
 * Created by caron on 2017/2/23.
 */
public class UserVO {
    private String id;

    private String name;

    private Date birthday;

    private String deptId;

    private String deptName;



    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    public String getDeptId() {
        return deptId;
    }

    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }


    @Override
    public String toString() {
        return "UserVO{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", birthday=" + birthday +
                ", deptId=" + deptId +
                ", deptName=" + deptName +
                '}';
    }

}
