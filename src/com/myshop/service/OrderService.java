package com.myshop.service;
import com.myshop.dao.*;
import com.myshop.entity.*;
import java.text.SimpleDateFormat;
import java.util.*;

public class OrderService {
    private OrderDao orderDao = new OrderDao();
    private CartDao cartDao = new CartDao();

    public int createOrder(int userId, List<CartItem> checkedItems) {
        if (checkedItems == null || checkedItems.isEmpty()) return -1;

        Order order = new Order();
        order.setOrderNo(generateOrderNo());
        order.setUserId(userId);

        double total = 0;
        List<OrderItem> items = new ArrayList<>();
        for (CartItem ci : checkedItems) {
            OrderItem item = new OrderItem();
            item.setGoodsId(ci.getGoodsId());
            item.setGoodsName(ci.getGoodsName());
            item.setGoodsPrice(ci.getGoodsPrice());
            item.setGoodsNum(ci.getGoodsNum());
            item.setGoodsPicture(ci.getGoodsPicture());
            items.add(item);
            total += ci.getSubtotal();
        }
        order.setTotalAmount(Math.round(total * 100.0) / 100.0);
        order.setItems(items);

        int orderId = orderDao.createOrder(order);
        if (orderId > 0) {
            cartDao.clearByUserId(userId);
        }
        return orderId;
    }

    private String generateOrderNo() {
        String date = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        String random = String.format("%04d", new Random().nextInt(10000));
        return date + random;
    }

    public List<Order> getOrders(int userId) { return orderDao.findByUserId(userId); }
    public int count() { return orderDao.count(); }
}
