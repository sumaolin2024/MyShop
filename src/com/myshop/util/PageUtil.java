package com.myshop.util;

import com.myshop.entity.PageInfo;
import java.util.List;

public class PageUtil {

    public static <T> PageInfo<T> build(int currentPage, int pageSize, int totalCount, List<T> list) {
        if (currentPage < 1) currentPage = 1;
        if (pageSize < 1) pageSize = 12;
        int totalPages = (totalCount + pageSize - 1) / pageSize;
        if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
        return new PageInfo<>(currentPage, pageSize, totalCount, list);
    }

    /** Calculate LIMIT offset from page number. */
    public static int offset(int page, int pageSize) {
        return (page - 1) * pageSize;
    }
}
