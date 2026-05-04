package com.labweb;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.labweb.mapper")
public class LabWebApplication {
    public static void main(String[] args) {
        SpringApplication.run(LabWebApplication.class, args);
    }
}
