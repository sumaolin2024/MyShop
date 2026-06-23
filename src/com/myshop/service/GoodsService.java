package com.myshop.service;
import com.myshop.dao.*;
import com.myshop.entity.*;
import com.myshop.util.PageUtil;
import java.util.*;

public class GoodsService {
    private GoodsDao goodsDao = new GoodsDao();

    public PageInfo<Goods> getPage(int categoryId, String keyword, String sort, int page, int pageSize) {
        int[] total = new int[1];
        List<Goods> list = goodsDao.findPage(categoryId, keyword, sort, page, pageSize, total);
        return PageUtil.build(page, pageSize, total[0], list);
    }

    public Goods getById(int id) { return goodsDao.findById(id); }
    public List<GoodsAlbum> getAlbums(int goodsId) { return goodsDao.findAlbums(goodsId); }
    public List<Goods> getHot(int limit) { return goodsDao.findHot(limit); }
    public List<Goods> getNew(int limit) { return goodsDao.findNew(limit); }
    public List<Goods> getRelated(int goodsId, int categoryId, int limit) { return goodsDao.findRelated(goodsId, categoryId, limit); }
    public int countByCategory(int categoryId) { return goodsDao.countByCategory(categoryId); }
    public int count() { return goodsDao.count(); }
}
