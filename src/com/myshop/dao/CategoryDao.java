package com.myshop.dao;

import com.myshop.entity.Category;
import com.myshop.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDao {

    public List<Category> findTopLevel() {
        return findByPid(0);
    }

    public List<Category> findByPid(int pid) {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT id, name, picture, pid FROM shop_category WHERE pid = ? ORDER BY id";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, pid);
            rs = ps.executeQuery();
            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setPicture(rs.getString("picture"));
                c.setPid(rs.getInt("pid"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeQuietly(rs, ps, conn);
        }
        return list;
    }

    public List<Category> findAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT id, name, picture, pid FROM shop_category ORDER BY pid, id";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setPicture(rs.getString("picture"));
                c.setPid(rs.getInt("pid"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeQuietly(rs, stmt, conn);
        }
        return list;
    }

    public Category findById(int id) {
        String sql = "SELECT id, name, picture, pid FROM shop_category WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setPicture(rs.getString("picture"));
                c.setPid(rs.getInt("pid"));
                return c;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeQuietly(rs, ps, conn);
        }
        return null;
    }
}
