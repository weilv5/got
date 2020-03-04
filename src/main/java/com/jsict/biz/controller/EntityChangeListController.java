package com.jsict.biz.controller;

import com.jsict.biz.model.EntityChangeListQuery;
import com.jsict.framework.core.controller.AbstractGenericController;
import com.jsict.framework.core.model.EntityChangeList;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by caron on 2017/6/28.
 */
@Controller
@RequestMapping("/datalog")
public class EntityChangeListController extends AbstractGenericController<EntityChangeList, String, EntityChangeListQuery> {
}
