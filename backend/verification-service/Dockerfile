FROM amazoncorretto:17-alpine

# Set working directory
WORKDIR /app

# Copy the JAR file
COPY target/verification-service-1.0.0.jar app.jar

# Expose port
EXPOSE 3004

# Run the application
CMD ["java", "-jar", "app.jar"]