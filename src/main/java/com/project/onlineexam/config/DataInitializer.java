package com.project.onlineexam.config;

import com.project.onlineexam.model.User;
import com.project.onlineexam.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {
    @Autowired
    private UserRepository userRepository;

    @Override
    public void run(String... args) {
        // Create default admin if not exists
        if (!userRepository.existsByEmail("admin@exam.com")) {
            User admin = new User("Admin", "admin@exam.com", "admin123", "ADMIN");
            userRepository.save(admin);
            System.out.println("Default admin created: admin@exam.com / admin123");
        }
    }
}
