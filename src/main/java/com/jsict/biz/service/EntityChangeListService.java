package com.jsict.biz.service;

import com.jsict.framework.core.model.EntityChangeList;
import com.jsict.framework.core.service.GeneriService;

import java.util.List;
import java.util.Map;

/**
 * Created by caron on 2017/6/28.
 */
public interface EntityChangeListService extends GeneriService<EntityChangeList, String> {

    /**
     * 数据操作统计
     *
     * @param size 返回记录数
     * @return 统计结果
     */
    List<Map> datalogStat(Integer size);
}
