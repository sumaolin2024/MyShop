package com.myshop.entity;

public class Goods {
    private int id;
    private int categoryId;
    private String name;
    private double price;
    private String picture;
    private int stock;
    private int sales;
    private int isNew;
    private int isHot;
    private String spec;
    private String description;

    public Goods() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public String getPicture() { return picture; }
    public void setPicture(String picture) { this.picture = picture; }
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
    public int getSales() { return sales; }
    public void setSales(int sales) { this.sales = sales; }
    public int getIsNew() { return isNew; }
    public void setIsNew(int isNew) { this.isNew = isNew; }
    public int getIsHot() { return isHot; }
    public void setIsHot(int isHot) { this.isHot = isHot; }
    public String getSpec() { return spec; }
    public void setSpec(String spec) { this.spec = spec; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
