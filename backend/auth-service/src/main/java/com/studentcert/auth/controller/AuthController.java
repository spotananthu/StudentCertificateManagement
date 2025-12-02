package com.studentcert.auth.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.studentcert.auth.dto.AuthResponse;
import com.studentcert.auth.dto.EmailRequest;
import com.studentcert.auth.dto.LoginRequest;
import com.studentcert.auth.dto.RegisterRequest;
import com.studentcert.auth.model.User;
import com.studentcert.auth.model.UserRole;
import com.studentcert.auth.service.AuthService;
import com.studentcert.auth.service.JwtService;
import com.studentcert.auth.service.UidGenerationService;
import com.studentcert.auth.service.UniversityServiceClient;
import com.studentcert.auth.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import java.util.logging.Logger;
import org.apache.kafka.common.protocol.types.Field;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@Tag(name = "Authentication", description = "Authentication and user management endpoints")
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @Autowired
    private JwtService jwtService;
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private UidGenerationService uidGenerationService;
    
    @Autowired
    private UniversityServiceClient universityServiceClient;

    @Autowired
    private KafkaTemplate<String, String> kafkaTemplate;

    @Autowired
    private ObjectMapper objectMapper;

    Logger logger = Logger.getLogger(AuthController.class.getName());

    @Operation(summary = "User login", description = "Authenticate a user and return a JWT token")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Login successful", 
            content = @Content(mediaType = "application/json", schema = @Schema(implementation = AuthResponse.class))),
        @ApiResponse(responseCode = "401", description = "Invalid credentials",
            content = @Content(mediaType = "application/json", schema = @Schema(implementation = AuthResponse.class)))
    })
    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(
            @Parameter(description = "User login credentials", required = true)
            @Valid @RequestBody LoginRequest loginRequest) {
        try {
            User user = authService.authenticate(loginRequest.getEmail(), loginRequest.getPassword());
            String token = jwtService.generateToken(user);
            
            AuthResponse response = AuthResponse.builder()
                .success(true)
                .message("Login successful")
                .data(AuthResponse.UserData.builder()
                    .id(user.getId().toString())
                    .email(user.getEmail())
                    .fullName(user.getFullName())
                    .role(user.getRole().toString().toLowerCase())
                    .token(token)
                    .uid(user.getUid())
                    .universityUid(user.getUniversityUid())
                    .build())
                .build();
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            AuthResponse errorResponse = AuthResponse.builder()
                .success(false)
                .message(e.getMessage())
                .build();
            return ResponseEntity.status(401).body(errorResponse);
        }
    }

    @Operation(summary = "User registration", description = "Register a new user (Student, University, Employer, or Admin)")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Registration successful", 
            content = @Content(mediaType = "application/json", schema = @Schema(implementation = AuthResponse.class))),
        @ApiResponse(responseCode = "400", description = "Invalid input or registration failed",
            content = @Content(mediaType = "application/json", schema = @Schema(implementation = AuthResponse.class)))
    })
    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(
            @Parameter(description = "User registration details", required = true)
            @Valid @RequestBody RegisterRequest registerRequest) {
        try {
            // Validate: Students MUST select a university UID
            if (registerRequest.getRole() == UserRole.STUDENT && 
                (registerRequest.getUniversityUid() == null || registerRequest.getUniversityUid().trim().isEmpty())) {
                AuthResponse errorResponse = AuthResponse.builder()
                    .success(false)
                    .message("Students must select a university")
                    .build();
                return ResponseEntity.status(400).body(errorResponse);
            }
            
            // For UNIVERSITY role, use fullName as universityName if universityName is not provided
            if (registerRequest.getRole() == UserRole.UNIVERSITY) {
                if (registerRequest.getUniversityName() == null || registerRequest.getUniversityName().trim().isEmpty()) {
                    registerRequest.setUniversityName(registerRequest.getFullName());
                }
            }
            
            User user = userService.createUser(
                registerRequest.getEmail(), 
                registerRequest.getPassword(), 
                registerRequest.getRole()
            );
            
            // Generate unique UID for the user
            String uid = uidGenerationService.regenerateUidIfConflict(registerRequest.getRole());
            
            // Update additional fields
            user.setFullName(registerRequest.getFullName());
            user.setUid(uid);
            user.setUniversityUid(registerRequest.getUniversityUid());
            
            // Save updated user
            user = userService.updateUser(user);
            
            // If registering a university, also create university record in university service
            if (registerRequest.getRole() == UserRole.UNIVERSITY) {
                try {
                    universityServiceClient.registerUniversity(
                        uid, 
                        registerRequest.getUniversityName(),
                        registerRequest.getEmail(),
                        registerRequest.getUniversityAddress(),
                        registerRequest.getUniversityPhone()
                    );
                } catch (Exception e) {
                    // If university service registration fails, rollback user creation
                    userService.deleteUser(user.getId());
                    throw new RuntimeException("Failed to register university: " + e.getMessage());
                }
            }
            
            String token = jwtService.generateToken(user);

            /* Below code enables event driven notification management with kafka
            * Ensure you setup kafka, and it is in running state*/
            EmailRequest emailRequest = new EmailRequest();
            emailRequest.setTo(user.getEmail());
            emailRequest.setSubject("Your registration to StudentCert is successful");
            emailRequest.setBody("Dear " + user.getFullName() + ",\n\n" +
                "Thank you for registering at StudentCert. Your unique UID is: " + uid + "\n\n" +
                "Best regards,\nStudentCert Team");

            String emailJson = objectMapper.writeValueAsString(emailRequest);
            kafkaTemplate.send ("email_notifications", emailJson);
            logger.info("Published registration email event to Kafka for user: " + user.getEmail());

            AuthResponse response = AuthResponse.builder()
                .success(true)
                .message("Registration successful. Your UID is: " + uid)
                .data(AuthResponse.UserData.builder()
                    .id(user.getId().toString())
                    .email(user.getEmail())
                    .fullName(user.getFullName())
                    .role(user.getRole().toString().toLowerCase())
                    .token(token)
                    .uid(user.getUid())
                    .universityUid(user.getUniversityUid())
                    .build())
                .build();
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            AuthResponse errorResponse = AuthResponse.builder()
                .success(false)
                .message(e.getMessage())
                .build();
            return ResponseEntity.status(400).body(errorResponse);
        }
    }

    @Operation(summary = "User logout", description = "Logout a user (client should remove the token)")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Logout successful", 
            content = @Content(mediaType = "application/json", schema = @Schema(implementation = AuthResponse.class)))
    })
    @PostMapping("/logout")
    public ResponseEntity<AuthResponse> logout(
            @Parameter(description = "Authenticated user", hidden = true)
            @AuthenticationPrincipal User user) {
        // In a real implementation, you might blacklist the JWT token
        // For now, we'll just return success since the frontend handles token removal
        AuthResponse response = AuthResponse.builder()
            .success(true)
            .message("Logout successful")
            .build();
        
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "Get current user", description = "Get details of the currently authenticated user")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "User details retrieved successfully", 
            content = @Content(mediaType = "application/json", schema = @Schema(implementation = AuthResponse.class))),
        @ApiResponse(responseCode = "401", description = "User not authenticated",
            content = @Content(mediaType = "application/json", schema = @Schema(implementation = AuthResponse.class)))
    })
    @GetMapping("/me")
    public ResponseEntity<AuthResponse> getCurrentUser(
            @Parameter(description = "Authenticated user", hidden = true)
            @AuthenticationPrincipal User user) {
        try {
            AuthResponse response = AuthResponse.builder()
                .success(true)
                .message("User retrieved successfully")
                .data(AuthResponse.UserData.builder()
                    .id(user.getId().toString())
                    .email(user.getEmail())
                    .fullName(user.getFullName())
                    .role(user.getRole().toString().toLowerCase())
                    .build())
                .build();
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            AuthResponse errorResponse = AuthResponse.builder()
                .success(false)
                .message("User not found")
                .build();
            return ResponseEntity.status(401).body(errorResponse);
        }
    }
}