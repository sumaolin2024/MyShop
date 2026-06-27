package com.myshop.service;
import com.myshop.dao.CategoryDao;
import com.myshop.entity.Category;
import java.util.*;

public class CategoryService {
    private CategoryDao dao = new CategoryDao();

    public List<Category> getTopLevel() { return dao.findTopLevel(); }
    public List<Category> getSubCategories(int pid) { return dao.findByPid(pid); }
    public List<Category> getAll() { return dao.findAll(); }
    public Category getById(int id) { return dao.findById(id); }

    /** Get category tree for display. */
    public Map<Category, List<Category>> getCategoryTree() {
        Map<Category, List<Category>> tree = new LinkedHashMap<>();
        List<Category> tops = dao.findTopLevel();
        for (Category top : tops) {
            tree.put(top, dao.findByPid(top.getId()));
        }
        return tree;
    }
}
