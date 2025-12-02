package com.studentcert.auth.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.servers.Server;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.Components;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI authServiceOpenAPI() {
        Server devServer = new Server();
        devServer.setUrl("http://localhost");
        devServer.setDescription("Development server for Auth Service (via Ingress)");

        Server prodServer = new Server();
        prodServer.setUrl("https://api.studentcert.com");
        prodServer.setDescription("Production server for Auth Service");

        Contact contact = new Contact();
        contact.setEmail("admin@studentcert.com");
        contact.setName("Student Certificate Team");

        License license = new License()
                .name("MIT License")
                .url("https://choosealicense.com/licenses/mit/");

        Info info = new Info()
                .title("Student Certificate Management - Authentication Service API")
                .version("1.0.0")
                .contact(contact)
                .description("This API provides authentication and authorization services for the Student Certificate Management System. " +
                        "It handles user registration, login, JWT token management, and role-based access control.")
                .license(license);

        SecurityScheme securityScheme = new SecurityScheme()
                .type(SecurityScheme.Type.HTTP)
                .scheme("bearer")
                .bearerFormat("JWT")
                .in(SecurityScheme.In.HEADER)
                .name("Authorization");

        SecurityRequirement securityRequirement = new SecurityRequirement()
                .addList("bearerAuth");

        return new OpenAPI()
                .info(info)
                .servers(List.of(devServer, prodServer))
                .addSecurityItem(securityRequirement)
                .components(new Components()
                        .addSecuritySchemes("bearerAuth", securityScheme));
    }
}