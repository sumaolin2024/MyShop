package com.myshop.service;
import com.myshop.dao.FavoriteDao;

public class FavoriteService {
    private FavoriteDao dao = new FavoriteDao();

    public boolean isFavorited(int userId, int goodsId) { return dao.exists(userId, goodsId); }
    public boolean add(int userId, int goodsId) { return dao.add(userId, goodsId); }
    public boolean remove(int userId, int goodsId) { return dao.remove(userId, goodsId); }
}
