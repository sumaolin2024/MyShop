package com.myshop.entity;

public class GoodsAlbum {
    private int id;
    private int goodsId;
    private String picture;

    public GoodsAlbum() {}

    public GoodsAlbum(int id, int goodsId, String picture) {
        this.id = id;
        this.goodsId = goodsId;
        this.picture = picture;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getGoodsId() { return goodsId; }
    public void setGoodsId(int goodsId) { this.goodsId = goodsId; }
    public String getPicture() { return picture; }
    public void setPicture(String picture) { this.picture = picture; }
}
