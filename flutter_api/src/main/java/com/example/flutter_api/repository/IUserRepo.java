package com.example.flutter_api.repository;

import java.util.List;

import com.example.flutter_api.model.User;

public interface IUserRepo {

    public User createUser(User user);

    public List<User> getAllUser();

    public User updateUser(int id, User user);

    public User deleteUser(int id);

}
