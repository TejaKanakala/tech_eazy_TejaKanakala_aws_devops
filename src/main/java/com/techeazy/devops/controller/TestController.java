package com.techeazy.devops.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestController {

    @GetMapping
    public  String testPR() {
        return "testing pull request demo";
    }
}
