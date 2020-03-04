package com.jsict.biz.dao;

import com.jsict.framework.core.dao.EntityChangeHandler;
import com.jsict.framework.core.model.EntityChangeList;
import com.jsict.framework.core.model.EntityChangeType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by caron on 2017/6/28.
 */
@Component("entityChangeListener")
public class DefaultEntityChangeHandler implements EntityChangeHandler {

    @Autowired
    private EntityChangeListDao entityChangeListDao;

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    @Override
    public void handleEntityChange(EntityChangeList entityChangeList) {
        if(entityChangeList.getEntityChangeType() == EntityChangeType.READ && "NO User".equals(entityChangeList.getOperatorId())){
            // Do nothing
        }else{
            entityChangeList.setId(null);
            entityChangeListDao.save(entityChangeList);
        }
    }
}
