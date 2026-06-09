package com.labweb.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class SpaForwardController {

    @RequestMapping(value = {
        "/about",
        "/research",
        "/research/**",
        "/publications",
        "/tools",
        "/agents",
        "/contact",
        "/admin/login",
        "/admin/lab-info",
        "/admin/research",
        "/admin/publications",
        "/admin/tools",
        "/admin/agents",
        "/admin/operation-logs",
        "/admin/agent-usage-logs"
    })
    public String forward() {
        return "forward:/index.html";
    }
}
