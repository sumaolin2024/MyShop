package com.myshop.util;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;

public class JsonUtil {

    public static String toJson(Object obj) {
        return JSON.toJSONString(obj,
                SerializerFeature.DisableCircularReferenceDetect,
                SerializerFeature.WriteDateUseDateFormat);
    }

    public static <T> T fromJson(String json, Class<T> clazz) {
        return JSON.parseObject(json, clazz);
    }

    public static String success(Object data) {
        return "{\"code\":200,\"data\":" + toJson(data) + "}";
    }

    public static String success() {
        return "{\"code\":200}";
    }

    public static String error(String msg) {
        return "{\"code\":500,\"msg\":\"" + msg + "\"}";
    }

    public static String error(int code, String msg) {
        return "{\"code\":" + code + ",\"msg\":\"" + msg + "\"}";
    }
}
