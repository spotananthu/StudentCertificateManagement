FROM amazoncorretto:17-alpine

# Set working directory
WORKDIR /app

# Copy the JAR file
COPY target/auth-service-1.0.0.jar app.jar

# Expose port
EXPOSE 8081

# Run the application
CMD ["java", "-jar", "app.jar"]