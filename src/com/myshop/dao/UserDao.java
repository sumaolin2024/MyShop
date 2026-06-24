package com.myshop.dao;

import com.myshop.entity.User;
import com.myshop.util.DBUtil;
import java.sql.*;

public class UserDao {

    public User findByUsername(String username) {
        String sql = "SELECT id, username, password, salt, avatar FROM shop_user WHERE username = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id")); u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password")); u.setSalt(rs.getString("salt"));
                u.setAvatar(rs.getString("avatar"));
                return u;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, ps, conn); }
        return null;
    }

    public User findById(int id) {
        String sql = "SELECT id, username, password, salt, avatar FROM shop_user WHERE id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id")); u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password")); u.setSalt(rs.getString("salt"));
                u.setAvatar(rs.getString("avatar"));
                return u;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, ps, conn); }
        return null;
    }

    public int insert(User user) {
        String sql = "INSERT INTO shop_user (username, password, salt, avatar) VALUES (?, ?, ?, ?)";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, user.getUsername()); ps.setString(2, user.getPassword());
            ps.setString(3, user.getSalt());
            ps.setString(4, user.getAvatar() != null ? user.getAvatar() : "");
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, ps, conn); }
        return -1;
    }

    public boolean update(User user) {
        String sql = "UPDATE shop_user SET avatar = ? WHERE id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getAvatar() != null ? user.getAvatar() : "");
            ps.setInt(2, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(ps, conn); }
        return false;
    }

    public boolean updatePassword(int id, String password, String salt) {
        String sql = "UPDATE shop_user SET password = ?, salt = ? WHERE id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, password); ps.setString(2, salt); ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(ps, conn); }
        return false;
    }

    public boolean usernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM shop_user WHERE username = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, ps, conn); }
        return false;
    }

    public int count() {
        String sql = "SELECT COUNT(*) FROM shop_user";
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
