package com.example.flutter_api.repository.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.example.flutter_api.model.User;
import com.example.flutter_api.repository.IUserRepo;

@Repository
public class UserRepo implements IUserRepo {

    @Autowired
    JdbcTemplate jdbcTemplate;

    @Override
    public User createUser(User user) {

        String query = "INSERT INTO tb_user(name, email, gender)" + "VALUES(?, ?, ?)";

        jdbcTemplate.update(query, new Object[]{
            user.getName(), user.getEmail(), user.getGender()
        });

        return user;
    }

    @Override
    public List<User> getAllUser() {

        String query = "SELECT * FROM tb_user";
        return jdbcTemplate.query(query, new BeanPropertyRowMapper<>(User.class));
        
    }

    @Override
    public User updateUser(int id, User user) {
        String query = "UPDATE tb_user SET name = ?, email = ?, gender = ? WHERE id = ?";

        jdbcTemplate.update(query, new Object[] {
                user.getName(), user.getEmail(), user.getGender(), id
        });
        return user;
    }

    @Override
    public User deleteUser(int id) {
        
        String query = "SELECT * FROM tb_user WHERE id = ?";

        var result = jdbcTemplate.queryForObject(query, new BeanPropertyRowMapper<>(User.class), id);

        query = "DELETE FROM tb_user WHERE id = ?";
        jdbcTemplate.update(query, id);

        return result;
    }
    
}
