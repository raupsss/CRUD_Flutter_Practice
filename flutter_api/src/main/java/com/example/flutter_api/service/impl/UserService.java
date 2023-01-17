package com.example.flutter_api.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.flutter_api.model.User;
import com.example.flutter_api.repository.IUserRepo;
import com.example.flutter_api.service.IUserService;

@Service
public class UserService implements IUserService {

    @Autowired
    IUserRepo userRepo;

    @Override
    public User createUser(User user) {

        return userRepo.createUser(user);
    }

    @Override
    public List<User> getAllUser() {

        return userRepo.getAllUser();
    }

    @Override
    public User updateUser(int id, User user) {

        return userRepo.updateUser(id, user);
    }

    @Override
    public User deleteUser(int id) {

        return userRepo.deleteUser(id);
    }

}
