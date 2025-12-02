package com.email_notification.email_notification.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@Tag(name = "Health", description = "Service health check endpoints")
@RestController
@RequestMapping("/api/health")
public class HealthController {

    @Operation(summary = "Health check", description = "Check the status of the email notification service")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Service is healthy", 
            content = @Content(mediaType = "application/json", schema = @Schema(implementation = Map.class)))
    })
    @GetMapping
    public ResponseEntity<Map<String, String>> health() {
        Map<String, String> status = new HashMap<>();
        status.put("status", "UP");
        status.put("service", "email-notification");
        status.put("description", "Event-driven email notification service via Kafka");
        return ResponseEntity.ok(status);
    }
}