package com.email_notification.email_notification;

import com.email_notification.email_notification.dto.EmailRequest;
import com.email_notification.email_notification.service.EmailService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.annotation.KafkaListener;
import com.fasterxml.jackson.databind.ObjectMapper;

@EnableKafka
@SpringBootApplication
public class EmailNotificationApplication {

	@Autowired
	private ObjectMapper objectMapper;

	@Autowired
	private EmailService emailService;

	private Logger logger = LoggerFactory.getLogger(EmailNotificationApplication.class);
	public static void main(String[] args) {
		SpringApplication.run(EmailNotificationApplication.class, args);
	}

	@KafkaListener(topics = "email_notifications", groupId = "email_notification_group")
	public void sendEmail(String messageJson) {
		try {
			EmailRequest emailRequest = objectMapper.readValue(messageJson, EmailRequest.class);
			logger.info(emailRequest.toString());

			emailService.sendEmail(emailRequest.getTo(), emailRequest.getSubject(), emailRequest.getBody());
			logger.info("EmailNotificationApplication--> Email sent to: " + emailRequest.getTo());

		} catch (Exception e) {
			logger.error("Failed to parse email JSON: " + e.getMessage());
		}
	}

}
