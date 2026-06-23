package com.myshop.entity;

import java.util.Date;

public class CartItem {
    private int id;
    private int userId;
    private int goodsId;
    private int goodsNum;
    private int checked;
    private Date createTime;

    // joined fields from goods table
    private String goodsName;
    private double goodsPrice;
    private String goodsPicture;

    public CartItem() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getGoodsId() { return goodsId; }
    public void setGoodsId(int goodsId) { this.goodsId = goodsId; }
    public int getGoodsNum() { return goodsNum; }
    public void setGoodsNum(int goodsNum) { this.goodsNum = goodsNum; }
    public int getChecked() { return checked; }
    public void setChecked(int checked) { this.checked = checked; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
    public String getGoodsName() { return goodsName; }
    public void setGoodsName(String goodsName) { this.goodsName = goodsName; }
    public double getGoodsPrice() { return goodsPrice; }
    public void setGoodsPrice(double goodsPrice) { this.goodsPrice = goodsPrice; }
    public String getGoodsPicture() { return goodsPicture; }
    public void setGoodsPicture(String goodsPicture) { this.goodsPicture = goodsPicture; }
    public double getSubtotal() { return goodsPrice * goodsNum; }
}
