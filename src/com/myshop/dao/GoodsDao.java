package com.myshop.dao;
import com.myshop.entity.*;
import com.myshop.util.*;
import java.sql.*;
import java.util.*;

public class GoodsDao {

    public List<Goods> findPage(int categoryId, String keyword, String sort, int page, int pageSize, int[] totalOut) {
        List<Goods> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT id, category_id, name, price, picture, stock, sales, is_new, is_hot, spec FROM shop_goods WHERE 1=1");
        if (categoryId > 0) sql.append(" AND category_id = ?");
        if (keyword != null && !keyword.isEmpty()) sql.append(" AND name LIKE ?");
        switch (sort != null ? sort : "") {
            case "price_asc": sql.append(" ORDER BY price ASC"); break;
            case "price_desc": sql.append(" ORDER BY price DESC"); break;
            case "sales": sql.append(" ORDER BY sales DESC"); break;
            case "newest": sql.append(" ORDER BY id DESC"); break;
            default: sql.append(" ORDER BY sales DESC");
        }
        sql.append(" LIMIT ?, ?");
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            String countSql = "SELECT COUNT(*) FROM shop_goods WHERE 1=1";
            if (categoryId > 0) countSql += " AND category_id = " + categoryId;
            if (keyword != null && !keyword.isEmpty()) countSql += " AND name LIKE '%" + keyword + "%'";
            Statement cs = conn.createStatement();
            ResultSet crs = cs.executeQuery(countSql);
            if (crs.next()) totalOut[0] = crs.getInt(1);
            DBUtil.closeQuietly(crs, cs);

            ps = conn.prepareStatement(sql.toString());
            int idx = 1;
            if (categoryId > 0) ps.setInt(idx++, categoryId);
            if (keyword != null && !keyword.isEmpty()) ps.setString(idx++, "%" + keyword + "%");
            ps.setInt(idx++, PageUtil.offset(page, pageSize));
            ps.setInt(idx++, pageSize);
            rs = ps.executeQuery();
            while (rs.next()) {
                Goods g = new Goods();
                g.setId(rs.getInt("id")); g.setCategoryId(rs.getInt("category_id"));
                g.setName(rs.getString("name")); g.setPrice(rs.getDouble("price"));
                g.setPicture(rs.getString("picture")); g.setStock(rs.getInt("stock"));
                g.setSales(rs.getInt("sales")); g.setIsNew(rs.getInt("is_new"));
                g.setIsHot(rs.getInt("is_hot")); g.setSpec(rs.getString("spec"));
                list.add(g);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, ps, conn); }
        return list;
    }

    public Goods findById(int id) {
        String sql = "SELECT * FROM shop_goods WHERE id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql); ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                Goods g = new Goods();
                g.setId(rs.getInt("id")); g.setCategoryId(rs.getInt("category_id"));
                g.setName(rs.getString("name")); g.setPrice(rs.getDouble("price"));
                g.setPicture(rs.getString("picture")); g.setStock(rs.getInt("stock"));
                g.setSales(rs.getInt("sales")); g.setIsNew(rs.getInt("is_new"));
                g.setIsHot(rs.getInt("is_hot")); g.setSpec(rs.getString("spec"));
                g.setDescription(rs.getString("description"));
                return g;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, ps, conn); }
        return null;
    }

    public List<GoodsAlbum> findAlbums(int goodsId) {
        List<GoodsAlbum> list = new ArrayList<>();
        String sql = "SELECT id, goods_id, picture FROM shop_goods_album WHERE goods_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql); ps.setInt(1, goodsId);
            rs = ps.executeQuery();
            while (rs.next())
                list.add(new GoodsAlbum(rs.getInt("id"), rs.getInt("goods_id"), rs.getString("picture")));
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, ps, conn); }
        return list;
    }

    public List<Goods> findHot(int limit) {
        List<Goods> list = new ArrayList<>();
        String sql = "SELECT id, category_id, name, price, picture, stock, sales, is_new, is_hot, spec FROM shop_goods WHERE is_hot = 1 ORDER BY sales DESC LIMIT ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql); ps.setInt(1, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                Goods g = new Goods();
                g.setId(rs.getInt("id")); g.setCategoryId(rs.getInt("category_id"));
                g.setName(rs.getString("name")); g.setPrice(rs.getDouble("price"));
                g.setPicture(rs.getString("picture")); g.setStock(rs.getInt("stock"));
                g.setSales(rs.getInt("sales")); g.setIsNew(rs.getInt("is_new"));
                g.setIsHot(rs.getInt("is_hot")); g.setSpec(rs.getString("spec"));
                list.add(g);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, ps, conn); }
        return list;
    }

    public List<Goods> findNew(int limit) {
        List<Goods> list = new ArrayList<>();
        String sql = "SELECT id, category_id, name, price, picture, stock, sales, is_new, is_hot, spec FROM shop_goods WHERE is_new = 1 ORDER BY id DESC LIMIT ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql); ps.setInt(1, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                Goods g = new Goods();
                g.setId(rs.getInt("id")); g.setCategoryId(rs.getInt("category_id"));
                g.setName(rs.getString("name")); g.setPrice(rs.getDouble("price"));
                g.setPicture(rs.getString("picture")); g.setStock(rs.getInt("stock"));
                g.setSales(rs.getInt("sales")); g.setIsNew(rs.getInt("is_new"));
                g.setIsHot(rs.getInt("is_hot")); g.setSpec(rs.getString("spec"));
                list.add(g);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, ps, conn); }
        return list;
    }

    public List<Goods> findRelated(int goodsId, int categoryId, int limit) {
        List<Goods> list = new ArrayList<>();
        String sql = "SELECT id, category_id, name, price, picture, stock, sales, is_new, is_hot, spec FROM shop_goods WHERE category_id = ? AND id != ? ORDER BY sales DESC LIMIT ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, categoryId); ps.setInt(2, goodsId); ps.setInt(3, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                Goods g = new Goods();
                g.setId(rs.getInt("id")); g.setCategoryId(rs.getInt("category_id"));
                g.setName(rs.getString("name")); g.setPrice(rs.getDouble("price"));
                g.setPicture(rs.getString("picture")); g.setStock(rs.getInt("stock"));
                g.setSales(rs.getInt("sales")); g.setIsNew(rs.getInt("is_new"));
                g.setIsHot(rs.getInt("is_hot")); g.setSpec(rs.getString("spec"));
                list.add(g);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, ps, conn); }
        return list;
    }

    public int countByCategory(int categoryId) {
        String sql = "SELECT COUNT(*) FROM shop_goods WHERE category_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql); ps.setInt(1, categoryId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, ps, conn); }
        return 0;
    }

    public int count() {
        String sql = "SELECT COUNT(*) FROM shop_goods";
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
