package com.email_notification.email_notification.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI emailNotificationServiceOpenAPI() {
        Server devServer = new Server();
        devServer.setUrl("http://localhost:8093/api");
        devServer.setDescription("Development server for Email Notification Service (via Port Forward)");

        Server prodServer = new Server();
        prodServer.setUrl("https://api.studentcert.com/email");
        prodServer.setDescription("Production server for Email Notification Service");

        Contact contact = new Contact();
        contact.setEmail("admin@studentcert.com");
        contact.setName("Student Certificate Team");

        License license = new License()
                .name("MIT License")
                .url("https://choosealicense.com/licenses/mit/");

        Info info = new Info()
                .title("Student Certificate Management - Email Notification Service API")
                .version("1.0.0")
                .contact(contact)
                .description("This service provides email notification capabilities for the Student Certificate Management System. " +
                        "It's primarily an event-driven service that listens to Kafka topics for email requests and sends notifications. " +
                        "The REST endpoints are minimal and mainly for health checks and monitoring.")
                .license(license);

        return new OpenAPI()
                .info(info)
                .servers(List.of(devServer, prodServer));
    }
}