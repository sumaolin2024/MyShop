package com.myshop.entity;

public class OrderItem {
    private int id;
    private int orderId;
    private int goodsId;
    private String goodsName;
    private double goodsPrice;
    private int goodsNum;
    private String goodsPicture;

    public OrderItem() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getGoodsId() { return goodsId; }
    public void setGoodsId(int goodsId) { this.goodsId = goodsId; }
    public String getGoodsName() { return goodsName; }
    public void setGoodsName(String goodsName) { this.goodsName = goodsName; }
    public double getGoodsPrice() { return goodsPrice; }
    public void setGoodsPrice(double goodsPrice) { this.goodsPrice = goodsPrice; }
    public int getGoodsNum() { return goodsNum; }
    public void setGoodsNum(int goodsNum) { this.goodsNum = goodsNum; }
    public String getGoodsPicture() { return goodsPicture; }
    public void setGoodsPicture(String goodsPicture) { this.goodsPicture = goodsPicture; }
}
