package com.myshop.service;
import com.myshop.dao.CartDao;
import com.myshop.entity.CartItem;
import java.util.List;

public class CartService {
    private CartDao dao = new CartDao();

    public List<CartItem> getCart(int userId) { return dao.findByUserId(userId); }
    public boolean add(int userId, int goodsId, int num) { return dao.addOrUpdate(userId, goodsId, num); }
    public boolean updateNum(int id, int num) { return dao.updateNum(id, num); }
    public boolean toggleChecked(int id, int checked) { return dao.updateChecked(id, checked); }
    public boolean selectAll(int userId) { return dao.updateAllChecked(userId, 1); }
    public boolean deselectAll(int userId) { return dao.updateAllChecked(userId, 0); }
    public boolean remove(int id) { return dao.delete(id); }
    public boolean removeChecked(int userId) { return dao.deleteChecked(userId); }
    public int count(int userId) { return dao.countByUserId(userId); }
    public void clearChecked(int userId) { dao.clearByUserId(userId); }

    public double getTotal(List<CartItem> items, boolean onlyChecked) {
        double total = 0;
        for (CartItem item : items) {
            if (onlyChecked && item.getChecked() == 0) continue;
            total += item.getSubtotal();
        }
        return Math.round(total * 100.0) / 100.0;
    }

    public int getSelectedCount(List<CartItem> items) {
        int count = 0;
        for (CartItem item : items) {
            if (item.getChecked() == 1) count++;
        }
        return count;
    }
}
