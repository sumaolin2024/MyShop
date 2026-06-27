package com.myshop.entity;

import java.util.List;

public class PageInfo<T> {
    private int currentPage;
    private int pageSize;
    private int totalCount;
    private int totalPages;
    private List<T> list;

    public PageInfo() {}

    public PageInfo(int currentPage, int pageSize, int totalCount, List<T> list) {
        this.currentPage = currentPage;
        this.pageSize = pageSize;
        this.totalCount = totalCount;
        this.totalPages = (totalCount + pageSize - 1) / pageSize;
        this.list = list;
    }

    public int getCurrentPage() { return currentPage; }
    public void setCurrentPage(int currentPage) { this.currentPage = currentPage; }
    public int getPageSize() { return pageSize; }
    public void setPageSize(int pageSize) { this.pageSize = pageSize; }
    public int getTotalCount() { return totalCount; }
    public void setTotalCount(int totalCount) { this.totalCount = totalCount; }
    public int getTotalPages() { return totalPages; }
    public void setTotalPages(int totalPages) { this.totalPages = totalPages; }
    public List<T> getList() { return list; }
    public void setList(List<T> list) { this.list = list; }
    public boolean getHasPrev() { return currentPage > 1; }
    public boolean getHasNext() { return currentPage < totalPages; }
}
