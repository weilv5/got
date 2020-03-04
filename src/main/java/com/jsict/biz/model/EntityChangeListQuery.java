package com.jsict.biz.model;

import com.jsict.framework.core.model.EntityChangeList;
import com.jsict.framework.core.model.EntityChangeType;

import java.util.Date;

/**
 * Created by caron on 2017/6/28.
 */
public class EntityChangeListQuery extends EntityChangeList {

    private Integer opType;

    private Date createdDateStart;

    private Date createdDateEnd;

    public Date getCreatedDateEnd() {
        return createdDateEnd;
    }

    public void setCreatedDateEnd(Date createdDateEnd) {
        this.createdDateEnd = createdDateEnd;
    }

    public Date getCreatedDateStart() {

        return createdDateStart;
    }

    public void setCreatedDateStart(Date createdDateStart) {
        this.createdDateStart = createdDateStart;
    }

    public Integer getOpType() {
        return opType;
    }

    public void setOpType(Integer opType) {
        setEntityChangeType(EntityChangeType.values()[opType]);
    }
}
