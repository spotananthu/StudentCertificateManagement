FROM amazoncorretto:17-alpine

# Set working directory
WORKDIR /app

# Copy the JAR file
COPY target/certificate-service.jar app.jar

# Expose port
EXPOSE 3003

# Run the application
CMD ["java", "-jar", "app.jar"]