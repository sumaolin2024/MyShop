package com.myshop.dao;
import com.myshop.entity.*;
import com.myshop.util.DBUtil;
import java.sql.*;
import java.util.*;

public class OrderDao {

    public int createOrder(Order order) {
        Connection conn = null; PreparedStatement psOrder = null; PreparedStatement psItem = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection(); conn.setAutoCommit(false);
            psOrder = conn.prepareStatement("INSERT INTO shop_order (order_no, user_id, total_amount, status) VALUES (?, ?, ?, 0)", Statement.RETURN_GENERATED_KEYS);
            psOrder.setString(1, order.getOrderNo()); psOrder.setInt(2, order.getUserId());
            psOrder.setDouble(3, order.getTotalAmount());
            psOrder.executeUpdate();
            rs = psOrder.getGeneratedKeys(); int orderId = 0;
            if (rs.next()) orderId = rs.getInt(1);
            DBUtil.closeQuietly(rs, psOrder);

            psItem = conn.prepareStatement("INSERT INTO shop_order_item (order_id, goods_id, goods_name, goods_price, goods_num, goods_picture) VALUES (?, ?, ?, ?, ?, ?)");
            for (OrderItem item : order.getItems()) {
                psItem.setInt(1, orderId); psItem.setInt(2, item.getGoodsId());
                psItem.setString(3, item.getGoodsName()); psItem.setDouble(4, item.getGoodsPrice());
                psItem.setInt(5, item.getGoodsNum()); psItem.setString(6, item.getGoodsPicture());
                psItem.addBatch();
            }
            psItem.executeBatch(); conn.commit(); return orderId;
        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (SQLException ex) {}
            DBUtil.closeQuietly(null, psItem, null, conn);
        }
        return -1;
    }

    public List<Order> findByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("SELECT id, order_no, user_id, total_amount, status, create_time, pay_time FROM shop_order WHERE user_id = ? ORDER BY create_time DESC");
            ps.setInt(1, userId); rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id")); o.setOrderNo(rs.getString("order_no"));
                o.setUserId(rs.getInt("user_id")); o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getInt("status")); o.setCreateTime(rs.getTimestamp("create_time"));
                o.setPayTime(rs.getTimestamp("pay_time"));
                o.setItems(findItemsByOrderId(o.getId())); list.add(o);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, ps, conn); }
        return list;
    }

    private List<OrderItem> findItemsByOrderId(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("SELECT * FROM shop_order_item WHERE order_id = ?");
            ps.setInt(1, orderId); rs = ps.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("id")); item.setOrderId(rs.getInt("order_id"));
                item.setGoodsId(rs.getInt("goods_id")); item.setGoodsName(rs.getString("goods_name"));
                item.setGoodsPrice(rs.getDouble("goods_price")); item.setGoodsNum(rs.getInt("goods_num"));
                item.setGoodsPicture(rs.getString("goods_picture"));
                list.add(item);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, ps, conn); }
        return list;
    }

    public int count() {
        Connection conn = null; Statement stmt = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection(); stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT COUNT(*) FROM shop_order");
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        finally { DBUtil.closeQuietly(rs, stmt, conn); }
        return 0;
    }
}
