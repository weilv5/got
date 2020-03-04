package com.jsict.biz.dao;

import com.jsict.framework.core.dao.GenericDao;
import com.jsict.framework.core.model.EntityChangeList;

import java.util.List;
import java.util.Map;

/**
 * Created by caron on 2017/6/28.
 */
public interface EntityChangeListDao extends GenericDao<EntityChangeList, String> {

    List<Map> datalogStat(Integer size);
}
