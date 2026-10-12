package org.fsa_2026.company_fsa_captone_2026.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Tự động chuyển hướng từ trang chủ "/" sang "/swagger-ui.html"
 */
@Controller
public class RootRedirectController {

    @GetMapping("/")
    public String redirectToSwagger() {
        return "redirect:/swagger-ui.html";
    }
}
