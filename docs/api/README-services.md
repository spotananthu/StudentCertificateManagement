# API Documentation - Student Certificate Management System

This document provides comprehensive API documentation for all microservices in the Student Certificate Management System.

## Service APIs Overview

| Service | Port | Swagger UI | OpenAPI Spec |
|---------|------|------------|--------------|
| Authentication Service | 8081 | http://localhost:8081/swagger-ui.html | [auth-service.yaml](./auth-service.yaml) |
| Certificate Service | 3003 | http://localhost:3003/swagger-ui.html | [certificate-service.yaml](./certificate-service.yaml) |
| University Service | 3002 | http://localhost:3002/swagger-ui.html | [university-service.yaml](./university-service.yaml) |
| Verification Service | 3004 | http://localhost:3004/swagger-ui.html | [verification-service.yaml](./verification-service.yaml) |
| Email Notification Service | 8080 | http://localhost:8080/swagger-ui.html | [email-notification-service.yaml](./email-notification-service.yaml) |

## Quick Start

### 1. Access Live Documentation

Once the services are running, you can access the interactive Swagger UI for each service:

```bash
# Authentication Service
open http://localhost:8081/swagger-ui.html

# Certificate Service  
open http://localhost:3003/swagger-ui.html

# University Service
open http://localhost:3002/swagger-ui.html

# Verification Service
open http://localhost:3004/swagger-ui.html

# Email Notification Service
open http://localhost:8080/swagger-ui.html
```

### 2. OpenAPI Specifications

Each service has its own OpenAPI 3.0 specification file that can be used for:
- Code generation
- API testing tools (Postman, Insomnia)
- Documentation generation
- Contract testing

### 3. Authentication

Most endpoints require JWT authentication. To authenticate:

1. **Register a user** via the Authentication Service:
   ```bash
   POST http://localhost:8081/api/auth/register
   ```

2. **Login** to get a JWT token:
   ```bash
   POST http://localhost:8081/api/auth/login
   ```

3. **Use the token** in the Authorization header:
   ```
   Authorization: Bearer <your-jwt-token>
   ```

## Service Descriptions

### Authentication Service (Port 8081)
- User registration and login
- JWT token management
- Role-based access control
- User profile management

**Key Endpoints:**
- `POST /api/auth/register` - Register new users
- `POST /api/auth/login` - User authentication
- `GET /api/auth/me` - Get current user info

### Certificate Service (Port 3003)
- Certificate issuance and management
- Digital signature generation
- PDF certificate creation
- Batch operations

**Key Endpoints:**
- `POST /certificates` - Issue new certificate
- `GET /certificates` - List certificates
- `GET /certificates/{id}/pdf` - Download PDF

### University Service (Port 3002)
- University registration and management
- Institution verification
- University profile updates

**Key Endpoints:**
- `POST /universities` - Register university
- `GET /universities` - List universities
- `PUT /universities/{id}` - Update university

### Verification Service (Port 3004)
- Certificate authenticity verification
- Public verification endpoints
- Bulk verification capabilities

**Key Endpoints:**
- `POST /api/verify` - Verify certificate
- `GET /api/verify/{number}` - Public verification
- `POST /api/verify/bulk` - Batch verification

### Email Notification Service (Port 8080)
- Event-driven email notifications
- Kafka message processing
- Health monitoring

**Key Endpoints:**
- `GET /api/health` - Service health check

## API Usage Examples

### Complete Registration Flow

1. **Register a University:**
   ```json
   POST /api/auth/register
   {
     "email": "admin@university.edu",
     "password": "securePassword123",
     "role": "UNIVERSITY",
     "fullName": "Stanford University",
     "universityName": "Stanford University"
   }
   ```

2. **Register a Student:**
   ```json
   POST /api/auth/register
   {
     "email": "student@university.edu",
     "password": "studentPass123",
     "role": "STUDENT",
     "fullName": "John Doe",
     "universityUid": "UNIV001"
   }
   ```

3. **Issue a Certificate:**
   ```json
   POST /certificates
   Authorization: Bearer <university-token>
   {
     "studentName": "John Doe",
     "studentEmail": "student@university.edu",
     "courseName": "Computer Science Degree",
     "universityName": "Stanford University"
   }
   ```

4. **Verify Certificate:**
   ```json
   POST /api/verify
   {
     "certificateNumber": "CERT-2024-001"
   }
   ```

## Development Tools

### Using with Postman
1. Import the OpenAPI spec files into Postman
2. Set up environment variables for base URLs and tokens
3. Use the authentication flow to get JWT tokens

### Using with curl
```bash
# Get JWT token
TOKEN=$(curl -X POST http://localhost:8081/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password"}' \
  | jq -r '.data.token')

# Use token for authenticated requests
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:3003/certificates
```

## Error Handling

All services follow consistent error response patterns:

```json
{
  "success": false,
  "message": "Error description",
  "timestamp": "2024-12-02T10:00:00Z",
  "path": "/api/endpoint"
}
```

Common HTTP status codes:
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `500` - Internal Server Error

## Production Considerations

### Security
- All services validate JWT tokens
- HTTPS is required in production
- Rate limiting should be implemented
- Input validation is enforced

### Monitoring
- Health check endpoints available
- Metrics exposed via Spring Actuator
- Centralized logging recommended

### Scaling
- Services are stateless and can be horizontally scaled
- Database connections should be pooled
- Caching can be implemented for better performance

## Support

For API questions or issues:
- Review the individual OpenAPI specifications
- Check the Swagger UI documentation
- Contact: admin@studentcert.com