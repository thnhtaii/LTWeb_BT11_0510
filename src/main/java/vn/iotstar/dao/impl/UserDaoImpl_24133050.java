package vn.iotstar.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import vn.iotstar.connection.DBConnection_24133050;
import vn.iotstar.dao.IUserDao_24133050;
import vn.iotstar.entity.User_24133050;

public class UserDaoImpl_24133050 extends DBConnection_24133050 implements IUserDao_24133050 {

    @Override
    public User_24133050 findByUsername(String username) {
        String sql = "SELECT * FROM Users WHERE Username = ?";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public User_24133050 findByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE Email = ?";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public User_24133050 login(String username, String password) {
        String sql = "SELECT * FROM Users WHERE (Username = ? OR Email = ?) AND Password = ? AND Active = 1";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, username);
            ps.setString(3, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (Exception e) {
            throw new IllegalStateException("Cannot query the login database", e);
        }
        return null;
    }

    @Override
    public void insert(User_24133050 user) {
        String sql = "INSERT INTO Users (Username, Password, Phone, Fullname, Email, Admin, Active, Images) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getFullname());
            ps.setString(5, user.getEmail());
            ps.setBoolean(6, user.isAdmin());
            ps.setBoolean(7, user.isActive());
            ps.setString(8, user.getImages());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(User_24133050 user) {
        String sql;
        boolean updatePassword = user.getPassword() != null && !user.getPassword().trim().isEmpty();
        if (updatePassword) {
            sql = "UPDATE Users SET Password = ?, Phone = ?, Fullname = ?, Email = ?, Admin = ?, Active = ?, Images = ? WHERE Username = ?";
        } else {
            sql = "UPDATE Users SET Phone = ?, Fullname = ?, Email = ?, Admin = ?, Active = ?, Images = ? WHERE Username = ?";
        }

        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int idx = 1;
            if (updatePassword) {
                ps.setString(idx++, user.getPassword());
            }
            ps.setString(idx++, user.getPhone());
            ps.setString(idx++, user.getFullname());
            ps.setString(idx++, user.getEmail());
            ps.setBoolean(idx++, user.isAdmin());
            ps.setBoolean(idx++, user.isActive());
            ps.setString(idx++, user.getImages());
            ps.setString(idx++, user.getUsername());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(String username) {
        String sql = "DELETE FROM Users WHERE Username = ?";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<User_24133050> findAll() {
        List<User_24133050> list = new ArrayList<>();
        String sql = "SELECT * FROM Users ORDER BY Username ASC";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<User_24133050> findAll(int page, int pageSize) {
        List<User_24133050> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM Users ORDER BY Username ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapUser(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM Users";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public boolean checkExistUsername(String username) {
        String sql = "SELECT 1 FROM Users WHERE Username = ?";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean checkExistEmail(String email) {
        String sql = "SELECT 1 FROM Users WHERE Email = ?";
        try (Connection con = super.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private User_24133050 mapUser(ResultSet rs) throws Exception {
        User_24133050 user = new User_24133050();
        user.setUsername(rs.getString("Username"));
        user.setPassword(rs.getString("Password"));
        user.setPhone(rs.getString("Phone"));
        user.setFullname(rs.getString("Fullname"));
        user.setEmail(rs.getString("Email"));
        user.setAdmin(rs.getBoolean("Admin"));
        user.setActive(rs.getBoolean("Active"));
        user.setImages(rs.getString("Images"));
        return user;
    }
}
