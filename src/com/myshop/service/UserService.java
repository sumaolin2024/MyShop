package com.myshop.service;
import com.myshop.dao.UserDao;
import com.myshop.entity.User;
import com.myshop.util.BCryptUtil;

public class UserService {
    private UserDao dao = new UserDao();

    public User login(String username, String password) {
        User user = dao.findByUsername(username);
        if (user != null && BCryptUtil.checkPassword(password, user.getPassword())) {
            user.setPassword(null);
            user.setSalt(null);
            return user;
        }
        return null;
    }

    public int register(String username, String password) {
        if (dao.usernameExists(username)) return -2; // username taken
        String salt = BCryptUtil.generateSalt();
        String hashed = BCryptUtil.hashPassword(password, salt);
        User user = new User();
        user.setUsername(username);
        user.setPassword(hashed);
        user.setSalt(salt);
        return dao.insert(user);
    }

    public boolean updateProfile(User user) { return dao.update(user); }
    public boolean changePassword(int id, String oldPwd, String newPwd) {
        User user = dao.findById(id);
        if (user == null || !BCryptUtil.checkPassword(oldPwd, user.getPassword())) return false;
        String salt = BCryptUtil.generateSalt();
        String hashed = BCryptUtil.hashPassword(newPwd, salt);
        return dao.updatePassword(id, hashed, salt);
    }
    public User getById(int id) { return dao.findById(id); }
    public boolean usernameExists(String username) { return dao.usernameExists(username); }
    public int count() { return dao.count(); }
}
