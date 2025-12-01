FROM amazoncorretto:17-alpine

# Set working directory
WORKDIR /app

# Copy the JAR file
COPY target/email-notification-0.0.1-SNAPSHOT.jar app.jar

# Expose port
EXPOSE 3005

# Run the application
CMD ["java", "-jar", "app.jar"]