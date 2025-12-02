package com.studentcert.auth.config;

import com.studentcert.auth.security.JwtAuthenticationFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true)
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    public SecurityConfig(@Lazy JwtAuthenticationFilter jwtAuthenticationFilter) {
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12);
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(authz -> authz
                .requestMatchers(HttpMethod.POST, "/api/auth/register").permitAll()
                .requestMatchers(HttpMethod.POST, "/api/auth/login").permitAll()
                .requestMatchers(HttpMethod.GET, "/api/health").permitAll()
                .requestMatchers(HttpMethod.GET, "/api/users/universities").permitAll()  // Public endpoint for university list
                .requestMatchers(HttpMethod.GET, "/api/users/email/**").permitAll()  // For certificate service to fetch user by email
                .requestMatchers(HttpMethod.GET, "/api/users/{id}").permitAll()  // For certificate service to fetch user by ID
                // Swagger UI endpoints - comprehensive list
                .requestMatchers("/swagger-ui/**").permitAll()
                .requestMatchers("/swagger-ui.html").permitAll()
                .requestMatchers("/v3/api-docs/**").permitAll()
                .requestMatchers("/v3/api-docs").permitAll()
                .requestMatchers("/api-docs/**").permitAll()
                .requestMatchers("/api-docs").permitAll()
                .requestMatchers("/swagger-resources/**").permitAll()
                .requestMatchers("/swagger-resources").permitAll()
                .requestMatchers("/configuration/ui").permitAll()
                .requestMatchers("/configuration/security").permitAll()
                .requestMatchers("/swagger-config").permitAll()
                .requestMatchers("/webjars/**").permitAll()
                .requestMatchers("/favicon.ico").permitAll()
                .requestMatchers("/api/admin/**").hasRole("ADMIN")
                .requestMatchers("/api/auth/logout").authenticated()
                .requestMatchers("/api/auth/me").authenticated()
                .anyRequest().authenticated()
            )
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
        
        return http.build();
    }
}