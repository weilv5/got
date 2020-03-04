package com.jsict.biz.model;

/**
 * Created by caron on 2017/5/24.
 */
public class UserQuery extends User {

    private Role role;

    @Override
    public Role getRole() {
        return role;
    }

    @Override
    public void setRole(Role role) {
        this.role = role;
    }
}
