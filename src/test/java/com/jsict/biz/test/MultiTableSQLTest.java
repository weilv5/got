package com.jsict.biz.test;

import com.jsict.biz.dao.UserDao;
import com.jsict.biz.service.ModuleService;
import org.apache.commons.collections.map.HashedMap;
import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.MethodSorters;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 复杂SQL查询
 *
 * Created by caron on 2017/2/27.
 * @author caron
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath:spring-hibernate.xml"})
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class MultiTableSQLTest {

    private static final Logger logger = LoggerFactory.getLogger(MultiTableSQLTest.class);

    @Resource
    private UserDao userDao;

    @Resource
    private ModuleService moduleService;

    @PersistenceContext
    private EntityManager entityManager;

    @Test
    public void getCustomEntity() {
        Map<String, Object> params = new HashedMap();
        params.put("name", "admin");

        List<UserVO> list =userDao.getObjectListBySqlKey("query_multi_table",params,UserVO.class);
        System.out.println(list);
    }

    @Test
    public void getEntityByDeptId() {
        Map<String, Object> params = new HashedMap();

        List<String> deptId = new ArrayList<String>();
        deptId.add("297e4b3f5c0fe516015c0fe526b20002");
        deptId.add("8a8180ad64c672b70164c67448640000");
        params.put("deptId",deptId);

        List<UserVO> list =userDao.getObjectListBySqlKey("query_multi_table2",params,UserVO.class);
        System.out.println(list);
    }

    @Test
    public void getModule() {
        Map<String, Object> params = new HashedMap();

        ArrayList<String> roleList = new ArrayList<String>();
        roleList.add("0464f1a964b543420164b5609bf10005");
        params.put("delFlag",0);
        params.put("roleList",roleList);
        params.put("parentModuleId","4028cf815c3ecc41015c3ecd12150000");
        List list =moduleService.findByRoleList(params,roleList);

        System.out.println(list);
    }

    @Test
    @Transactional
    public void setUser() {
        Map<String, Object> params = new HashedMap();

        params.put("id","0464f1a964b543420164b561d88c0009");
        params.put("email","4353031632@qq.com");
        userDao.executeByKey("update_users_by_sql",params);
    }

}
