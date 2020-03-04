package com.jsict.biz.service.impl;

import com.jsict.biz.dao.EntityChangeListDao;
import com.jsict.biz.service.EntityChangeListService;
import com.jsict.framework.core.model.EntityChangeList;
import com.jsict.framework.core.service.impl.GeneriServiceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * Created by caron on 2017/6/28.
 */
@Service
public class EntityChangeListServiceImpl extends GeneriServiceImpl<EntityChangeList, String> implements EntityChangeListService {

    @Transactional
    @Override
    public List<Map> datalogStat(Integer size) {
        return ((EntityChangeListDao)genericDao).datalogStat(size);
    }
}
