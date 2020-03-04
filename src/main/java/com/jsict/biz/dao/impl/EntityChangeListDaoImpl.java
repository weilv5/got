package com.jsict.biz.dao.impl;

import com.jsict.biz.dao.EntityChangeListDao;
import com.jsict.framework.core.dao.hibernate.GenericHibernateDaoImpl;
import com.jsict.framework.core.model.EntityChangeList;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by caron on 2017/6/28.
 */
@Repository
public class EntityChangeListDaoImpl extends GenericHibernateDaoImpl<EntityChangeList, String> implements EntityChangeListDao {
    @Override
    public List<Map> datalogStat(Integer size) {
        Map<String, Object> params = new HashMap<>();
        params.put("size", size);
        return super.getList("datalogStat", params);
    }
}
