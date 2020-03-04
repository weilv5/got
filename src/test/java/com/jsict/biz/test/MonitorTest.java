package com.jsict.biz.test;

import com.jsict.framework.utils.performence.CpuUsage;
import com.jsict.framework.utils.performence.DiskUsage;
import com.jsict.framework.utils.performence.MemUsage;
import com.jsict.framework.utils.performence.PerformanceMonitor;
import org.hyperic.sigar.CpuInfo;
import org.junit.Before;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.reflect.Field;

/**
 * Created by caron on 2017/7/11.
 */
public class MonitorTest {

    private static final Logger logger = LoggerFactory.getLogger(MonitorTest.class);

    @Before
    public void loadJNILibDynamically() {
        try {
            System.setProperty("java.library.path", System.getProperty("java.library.path") + ":/Users/caron/IdeaProjects/unified_development_platform/bizweb/target/udp-biz-web-1.0/WEB-INF/lib");
            Field fieldSysPath = ClassLoader.class.getDeclaredField("sys_paths");
            fieldSysPath.setAccessible(true);
            fieldSysPath.set(null, null);
        } catch (Exception e) {
            // do nothing for exception
        }
    }

    public void testGetCpu(){
        CpuInfo[] infos = PerformanceMonitor.getCpuInfo();
        for (int i = 0; i < infos.length; i++) {// 不管是单块CPU还是多CPU都适用
            CpuInfo info = infos[i];
            logger.debug("第" + (i + 1) + "块CPU信息");
            logger.debug("CPU的总量MHz:    " + info.getMhz());// CPU的总量MHz
            logger.debug("CPU生产商:    " + info.getVendor());// 获得CPU的卖主，如：Intel
            logger.debug("CPU类别:    " + info.getModel());// 获得CPU的类别，如：Celeron
            logger.debug("CPU缓存数量:    " + info.getCacheSize());// 缓冲存储器数量
        }
    }

    public void testGetDiskUsage()  {
        DiskUsage diskUsage = PerformanceMonitor.getDiskUsage();
        logger.debug("硬盘总空间：{}", diskUsage.getTotal());
        logger.debug("使用空间：{}", diskUsage.getUsed());
        logger.debug("空闲空间：{}", diskUsage.getFree());
    }

    public void testGetCpuUsage() throws Exception {
        Thread.sleep(30000);
        CpuUsage cpuUsage = PerformanceMonitor.getCpuUsage();
        logger.debug("CPU空闲率：{}%", cpuUsage.getIdle());
        logger.debug("CPU使用率：{}%", cpuUsage.getUsed());
    }

    public void testGetMemUsage() throws Exception {
        Thread.sleep(30000);
        MemUsage memUsage = PerformanceMonitor.getMemUsage();
        logger.debug("总内存：{}", memUsage.getTotal());
        logger.debug("已使用：{}", memUsage.getUsed());
        logger.debug("空闲：{}", memUsage.getFree());
    }

}
