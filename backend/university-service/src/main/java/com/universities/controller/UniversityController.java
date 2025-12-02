package com.universities.controller;

import com.universities.dto.*;
import com.universities.service.UniversityService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "Universities", description = "University management endpoints")
@RestController
@RequestMapping("/universities")
@RequiredArgsConstructor
public class UniversityController {

    private final UniversityService service;
    private static final Logger logger = LoggerFactory.getLogger(UniversityController.class);

    @Operation(summary = "Register a new university", description = "Register a new university in the system")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "201", description = "University registered successfully", 
            content = @Content(mediaType = "application/json", schema = @Schema(implementation = UniversityResponse.class))),
        @ApiResponse(responseCode = "400", description = "Invalid university registration request")
    })
    @PostMapping
    public ResponseEntity<UniversityResponse> registerUniversity(
            @Parameter(description = "University registration details", required = true)
            @Validated @RequestBody UniversityRegisterRequest req) {

        logger.info("Registering new university: {}", req.getUniversityName());
        UniversityResponse created = service.registerUniversity(req);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @Operation(summary = "List universities", description = "Get a list of all universities with optional verified filter")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Universities retrieved successfully", 
            content = @Content(mediaType = "application/json", schema = @Schema(implementation = UniversityResponse.class)))
    })
    @GetMapping
    public ResponseEntity<List<UniversityResponse>> listUniversities(
            @Parameter(description = "Filter by verification status", required = false)
            @RequestParam(required = false) Boolean verified) {

        logger.info("Listing universities. Verified filter: {}", verified);
        return ResponseEntity.ok(service.listUniversities(verified));
    }

    @Operation(summary = "Get university by ID", description = "Retrieve a specific university by its ID")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "University found and retrieved", 
            content = @Content(mediaType = "application/json", schema = @Schema(implementation = UniversityResponse.class))),
        @ApiResponse(responseCode = "404", description = "University not found")
    })
    @GetMapping("/{id}")
    public ResponseEntity<UniversityResponse> getUniversity(
            @Parameter(description = "University ID", required = true)
            @PathVariable String id) {

        logger.info("Fetching university with ID {}", id);
        return ResponseEntity.ok(service.getUniversity(id));
    }

    @Operation(summary = "Update university", description = "Update university information")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "University updated successfully", 
            content = @Content(mediaType = "application/json", schema = @Schema(implementation = UniversityResponse.class))),
        @ApiResponse(responseCode = "404", description = "University not found"),
        @ApiResponse(responseCode = "400", description = "Invalid update request")
    })
    @PutMapping("/{id}")
    public ResponseEntity<UniversityResponse> updateUniversity(
            @Parameter(description = "University ID", required = true)
            @PathVariable String id,
            @Parameter(description = "University update details", required = true)
            @Validated @RequestBody UniversityUpdateRequest req) {

        logger.info("Updating university {}", id);
        return ResponseEntity.ok(service.updateUniversity(id, req));
    }

    @Operation(summary = "Delete university", description = "Delete a university from the system")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "204", description = "University deleted successfully"),
        @ApiResponse(responseCode = "404", description = "University not found")
    })
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUniversity(
            @Parameter(description = "University ID", required = true)
            @PathVariable String id) {

        logger.info("Deleting university {}", id);
        service.deleteUniversity(id);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "Verify university", description = "Mark a university as verified")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "University verified successfully", 
            content = @Content(mediaType = "application/json", schema = @Schema(implementation = VerifyUniversityResponse.class))),
        @ApiResponse(responseCode = "404", description = "University not found")
    })
    @PostMapping("/{id}/verify")
    public ResponseEntity<VerifyUniversityResponse> verifyUniversity(
            @Parameter(description = "University ID", required = true)
            @PathVariable String id) {

        logger.info("Verifying university {}", id);
        return ResponseEntity.ok(service.verifyUniversity(id));
    }

    @Operation(summary = "Unverify university", description = "Mark a university as unverified")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "University unverified successfully", 
            content = @Content(mediaType = "application/json", schema = @Schema(implementation = VerifyUniversityResponse.class))),
        @ApiResponse(responseCode = "404", description = "University not found")
    })
    @PostMapping("/{id}/unverify")
    public ResponseEntity<VerifyUniversityResponse> unverifyUniversity(
            @Parameter(description = "University ID", required = true)
            @PathVariable String id) {

        logger.info("Unverifying university {}", id);
        return ResponseEntity.ok(service.unverifyUniversity(id));
    }

    @GetMapping("/{id}/public-key")
    public ResponseEntity<PublicKeyResponse> getUniversityPublicKey(@PathVariable String id) {

        logger.info("Getting public key for university {}", id);
        return ResponseEntity.ok(service.getUniversityPublicKey(id));
    }
}
