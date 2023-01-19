package com.example.api_flutter.service;

import java.util.List;

import com.example.api_flutter.model.User;

public interface IUserService {

    public User createUser(User user);

    public List<User> getAllUser();

    public User updateUser(int id, User user);

    public User deleteUser(int id);

    
}
