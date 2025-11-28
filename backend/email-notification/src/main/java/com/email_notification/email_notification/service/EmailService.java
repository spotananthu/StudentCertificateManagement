package com.email_notification.email_notification.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class EmailService {
    Logger logger = LoggerFactory.getLogger(EmailService.class);
    public void sendEmail(String to, String subject, String body) {
        // Implementation for sending email
        logger.info("Sending email to: " + to);
    }
}
