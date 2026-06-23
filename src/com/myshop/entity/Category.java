package com.myshop.entity;

public class Category {
    private int id;
    private String name;
    private String picture;
    private int pid; // parent category id, 0 = top-level

    public Category() {}

    public Category(int id, String name, String picture, int pid) {
        this.id = id;
        this.name = name;
        this.picture = picture;
        this.pid = pid;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getPicture() { return picture; }
    public void setPicture(String picture) { this.picture = picture; }
    public int getPid() { return pid; }
    public void setPid(int pid) { this.pid = pid; }
}
