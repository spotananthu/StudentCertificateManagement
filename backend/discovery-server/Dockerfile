FROM amazoncorretto:17-alpine

# Set working directory
WORKDIR /app

# Copy the JAR file
COPY target/discovery-server-0.0.1-SNAPSHOT.jar app.jar

# Expose port
EXPOSE 8761

# Run the application
CMD ["java", "-jar", "app.jar"]