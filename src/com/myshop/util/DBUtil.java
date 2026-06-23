package com.myshop.util;

import org.apache.commons.dbcp2.BasicDataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class DBUtil {
    private static BasicDataSource ds;

    static {
        try {
            ds = new BasicDataSource();
            ds.setDriverClassName("com.mysql.jdbc.Driver");
            ds.setUrl("jdbc:mysql://localhost:3306/myShop?useUnicode=true&characterEncoding=utf8mb4&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true");
            ds.setUsername("root");
            ds.setPassword("root123");
            ds.setInitialSize(5);
            ds.setMaxTotal(20);
            ds.setMinIdle(2);
            ds.setMaxWaitMillis(10000);
            ds.setValidationQuery("SELECT 1");
            ds.setTestOnBorrow(true);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to initialize connection pool", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return ds.getConnection();
    }

    public static void closeQuietly(AutoCloseable... resources) {
        for (AutoCloseable r : resources) {
            if (r != null) {
                try { r.close(); } catch (Exception ignored) {}
            }
        }
    }
}

