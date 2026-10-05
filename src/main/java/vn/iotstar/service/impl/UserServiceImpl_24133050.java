package vn.iotstar.service.impl;

import java.util.List;

import vn.iotstar.dao.IUserDao_24133050;
import vn.iotstar.dao.impl.UserDaoImpl_24133050;
import vn.iotstar.entity.User_24133050;
import vn.iotstar.service.IUserService_24133050;

public class UserServiceImpl_24133050 implements IUserService_24133050 {

    private IUserDao_24133050 userDao = new UserDaoImpl_24133050();

    @Override
    public User_24133050 findByUsername(String username) {
        return userDao.findByUsername(username);
    }

    @Override
    public User_24133050 findByEmail(String email) {
        return userDao.findByEmail(email);
    }

    @Override
    public User_24133050 login(String username, String password) {
        return userDao.login(username, password);
    }

    @Override
    public void insert(User_24133050 user) {
        userDao.insert(user);
    }

    @Override
    public void update(User_24133050 user) {
        userDao.update(user);
    }

    @Override
    public void delete(String username) {
        userDao.delete(username);
    }

    @Override
    public List<User_24133050> findAll() {
        return userDao.findAll();
    }

    @Override
    public List<User_24133050> findAll(int page, int pageSize) {
        return userDao.findAll(page, pageSize);
    }

    @Override
    public int countAll() {
        return userDao.countAll();
    }

    @Override
    public boolean checkExistUsername(String username) {
        return userDao.checkExistUsername(username);
    }

    @Override
    public boolean checkExistEmail(String email) {
        return userDao.checkExistEmail(email);
    }

    @Override
    public boolean register(String username, String password, String email, String fullname, String phone) {
        if (checkExistUsername(username) || checkExistEmail(email)) {
            return false;
        }
        User_24133050 user = new User_24133050(username, password, phone, fullname, email, false, true, "default-avatar.png");
        userDao.insert(user);
        return true;
    }
}
