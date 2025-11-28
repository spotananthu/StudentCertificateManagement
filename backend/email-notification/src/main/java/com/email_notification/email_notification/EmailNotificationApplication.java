package com.email_notification.email_notification;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.kafka.annotation.KafkaListener;
import tools.jackson.databind.ObjectMapper;

@SpringBootApplication
public class EmailNotificationApplication {

	@Autowired
	ObjectMapper objectMapper;
	public static void main(String[] args) {
		SpringApplication.run(EmailNotificationApplication.class, args);
	}

	@KafkaListener(topics = "email_notifications", groupId = "email_notification_group")
	public void sendEmail(String emailRequest) {
		try {
			EmailRequest emailRequest = objectMapper.readValue(emailRequest, EmailRequest.class);

			System.out.println("Email received:");
			System.out.println(emailRequest);

			// Now you can process emailRequest.getTo(), getSubject(), getBody()
		} catch (Exception e) {
			System.err.println("Failed to parse email JSON: " + e.getMessage());
		}
		// Implementation for sending email

	}

}
