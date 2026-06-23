package com.myshop.dao;
import com.myshop.util.DBUtil;
import java.sql.*;

public class FavoriteDao {
    public boolean exists(int userId, int goodsId) {
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("SELECT COUNT(*) FROM shop_favorite WHERE user_id = ? AND goods_id = ?");
            ps.setInt(1, userId); ps.setInt(2, goodsId);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, ps, conn); }
        return false;
    }
    public boolean add(int userId, int goodsId) {
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("INSERT IGNORE INTO shop_favorite (user_id, goods_id) VALUES (?, ?)");
            ps.setInt(1, userId); ps.setInt(2, goodsId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(ps, conn); }
        return false;
    }
    public boolean remove(int userId, int goodsId) {
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("DELETE FROM shop_favorite WHERE user_id = ? AND goods_id = ?");
            ps.setInt(1, userId); ps.setInt(2, goodsId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(ps, conn); }
        return false;
    }
}
