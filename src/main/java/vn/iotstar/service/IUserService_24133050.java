package vn.iotstar.service;

import java.util.List;
import vn.iotstar.entity.User_24133050;

public interface IUserService_24133050 {
    User_24133050 findByUsername(String username);

    User_24133050 findByEmail(String email);

    User_24133050 login(String username, String password);

    void insert(User_24133050 user);

    void update(User_24133050 user);

    void delete(String username);

    List<User_24133050> findAll();

    // Câu 3: Quản trị CRUD có phân trang 6 user trên 01 trang
    List<User_24133050> findAll(int page, int pageSize);

    int countAll();

    boolean checkExistUsername(String username);

    boolean checkExistEmail(String email);

    boolean register(String username, String password, String email, String fullname, String phone);
}
