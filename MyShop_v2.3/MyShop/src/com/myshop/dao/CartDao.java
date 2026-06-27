package com.myshop.dao;
import com.myshop.entity.CartItem;
import com.myshop.util.DBUtil;
import java.sql.*;
import java.util.*;

public class CartDao {

    public List<CartItem> findByUserId(int userId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT c.id, c.user_id, c.goods_id, c.goods_num, c.checked, c.create_time, g.name, g.price, g.picture FROM shop_car c LEFT JOIN shop_goods g ON c.goods_id = g.id WHERE c.user_id = ? ORDER BY c.create_time DESC";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql); ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                CartItem item = new CartItem();
                item.setId(rs.getInt("id")); item.setUserId(rs.getInt("user_id"));
                item.setGoodsId(rs.getInt("goods_id")); item.setGoodsNum(rs.getInt("goods_num"));
                item.setChecked(rs.getInt("checked")); item.setCreateTime(rs.getTimestamp("create_time"));
                item.setGoodsName(rs.getString("name")); item.setGoodsPrice(rs.getDouble("price"));
                item.setGoodsPicture(rs.getString("picture"));
                list.add(item);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, ps, conn); }
        return list;
    }

    public boolean addOrUpdate(int userId, int goodsId, int num) {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("SELECT id, goods_num FROM shop_car WHERE user_id = ? AND goods_id = ?");
            ps.setInt(1, userId); ps.setInt(2, goodsId);
            rs = ps.executeQuery();
            if (rs.next()) {
                int newNum = rs.getInt("goods_num") + num;
                PreparedStatement ups = conn.prepareStatement("UPDATE shop_car SET goods_num = ? WHERE id = ?");
                ups.setInt(1, newNum); ups.setInt(2, rs.getInt("id"));
                int r = ups.executeUpdate(); ups.close(); return r > 0;
            } else {
                PreparedStatement ins = conn.prepareStatement("INSERT INTO shop_car (user_id, goods_id, goods_num) VALUES (?, ?, ?)");
                ins.setInt(1, userId); ins.setInt(2, goodsId); ins.setInt(3, num);
                int r = ins.executeUpdate(); ins.close(); return r > 0;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, ps, conn); }
        return false;
    }

    public boolean updateNum(int id, int num) {
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("UPDATE shop_car SET goods_num = ? WHERE id = ?");
            ps.setInt(1, num); ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(ps, conn); }
        return false;
    }

    public boolean updateChecked(int id, int checked) {
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("UPDATE shop_car SET checked = ? WHERE id = ?");
            ps.setInt(1, checked); ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(ps, conn); }
        return false;
    }

    public boolean updateAllChecked(int userId, int checked) {
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("UPDATE shop_car SET checked = ? WHERE user_id = ?");
            ps.setInt(1, checked); ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(ps, conn); }
        return false;
    }

    public boolean delete(int id) {
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("DELETE FROM shop_car WHERE id = ?");
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(ps, conn); }
        return false;
    }

    public boolean deleteChecked(int userId) {
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("DELETE FROM shop_car WHERE user_id = ? AND checked = 1");
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(ps, conn); }
        return false;
    }

    public int countByUserId(int userId) {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("SELECT COUNT(*) FROM shop_car WHERE user_id = ?");
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, ps, conn); }
        return 0;
    }

    public void clearByUserId(int userId) {
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("DELETE FROM shop_car WHERE user_id = ? AND checked = 1");
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(ps, conn); }
    }
}
