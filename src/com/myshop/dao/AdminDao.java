package com.myshop.dao;

import com.myshop.entity.Admin;
import com.myshop.util.DBUtil;
import java.sql.*;

public class AdminDao {

    public Admin findByUsername(String username) {
        String sql = "SELECT id, username, password, salt, avatar FROM shop_admin WHERE username = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) {
                Admin a = new Admin();
                a.setId(rs.getInt("id")); a.setUsername(rs.getString("username"));
                a.setPassword(rs.getString("password")); a.setSalt(rs.getString("salt"));
                a.setAvatar(rs.getString("avatar"));
                return a;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, ps, conn); }
        return null;
    }

    public Admin findById(int id) {
        String sql = "SELECT id, username, password, salt, avatar FROM shop_admin WHERE id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                Admin a = new Admin();
                a.setId(rs.getInt("id")); a.setUsername(rs.getString("username"));
                a.setPassword(rs.getString("password")); a.setSalt(rs.getString("salt"));
                a.setAvatar(rs.getString("avatar"));
                return a;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, ps, conn); }
        return null;
    }

    public int count() {
        String sql = "SELECT COUNT(*) FROM shop_admin";
        Connection conn = null; Statement stmt = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, stmt, conn); }
        return 0;
    }
}
