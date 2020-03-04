package com.jsict.biz.util;

import com.jsict.framework.utils.JsonUtil;

import java.util.HashMap;
import java.util.Map;

public class FileUploadUtil
{
    public static String result(String url, String title)
    {
        return result(url, title, null);
    }

    public static String result(String msg)
    {
        return result(null, null, msg);
    }

    private static String result(String url, String title, String msg)
    {
        Map<String, Object> result = new HashMap<>();
        if (msg == null)
        {
            result.put("code", Integer.valueOf(0));
            Map<String, Object> data = new HashMap();
            result.put("data", data);
            data.put("src", url);
            data.put("title", title);
        }
        else
        {
            result.put("code", Integer.valueOf(1));
            result.put("msg", msg);
        }
        return JsonUtil.parseMapToJson(result);
    }
}