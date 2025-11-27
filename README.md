# Student Certificate Management System# Student Certificate Management System



A comprehensive microservices-based platform for managing and verifying student academic certificates with digital signatures.A web application for managing and verifying student certificates. Universities can issue digital certificates, students can access their records, and employers can verify certificate authenticity in real-time.



## Overview## 🎯 Overview



This system provides a secure and efficient way to issue, manage, and verify student certificates. Built with a modern microservices architecture, it ensures scalability, maintainability, and reliability.This system provides a secure platform for the complete certificate lifecycle - from issuance by universities to verification by employers, eliminating manual verification processes and preventing fraud.



## Features## 🛠 Tech Stack



### For Students- **Backend:** Java 17+, Spring Boot 3.x, Feign Client, PostgreSQL

- Request and download verified certificates- **Frontend:** React 18+, TypeScript

- View certificate history and status- **API:** REST (HTTP), Swagger/OpenAPI 3.0

- Track verification requests- **Testing:** Bruno

- Secure profile management

## 🏗 Architecture

### For Universities

- Issue digital certificates with secure signaturesThe application consists of 4 independent services communicating via HTTP REST APIs:

- Manage certificate templates```

- Track certificate issuanceFrontend (React + TypeScript)

- Bulk certificate generation         │

    ┌────┼─────┬────────┬──────────┐

### For Employers    ▼    ▼     ▼        ▼          │

- Quick certificate verification  Auth  Univ  Cert  Verification   │

- Batch verification support  3001  3002  3003      3004       │

- Detailed verification reports                    │               │

- Real-time validation              Feign Client          │

                    │               │

### For Administrators              ┌─────┴───────────────┘

- System-wide monitoring and analytics              ▼

- User management across all roles          Database

- Audit logs and compliance tracking```

- System configuration

## 🚀 Quick Start

## Technology Stack

### Backend Setup

### Backend```bash

- **Java 17** with Spring Boot 3.3.x# Start each service in separate terminals

- **Microservices Architecture**cd backend/auth-service && ./mvnw spring-boot:run        # Port 3001

  - API Gateway (Node.js/Express)cd backend/university-service && ./mvnw spring-boot:run  # Port 3002

  - Authentication Service (Spring Security + JWT)cd backend/certificate-service && ./mvnw spring-boot:run # Port 3003

  - University Servicecd backend/verification-service && ./mvnw spring-boot:run # Port 3004

  - Certificate Service```

  - Verification Service

- **Database**: PostgreSQL### Frontend Setup

- **Message Queue**: RabbitMQ/Kafka```bash

- **API Documentation**: OpenAPI/Swaggercd frontend

npm install

### Frontendnpm start

- **React 18** with TypeScript```

- **Material-UI (MUI)** for UI components

- **React Router** for navigation## 📚 Services

- **Axios** for API communication

- **React Hook Form** with Zod validation| Service | Port | Purpose |

|---------|------|---------|

### DevOps| Auth Service | 3001 | User authentication & authorization |

- **Docker** & **Docker Compose** for containerization| University Service | 3002 | Manage university profiles |

- **GitHub Actions** for CI/CD| Certificate Service | 3003 | Issue and manage certificates |

- **Artillery** for load testing| Verification Service | 3004 | Verify certificate authenticity |



## Architecture## API Documentation



```Once services are running:

┌─────────────────────────────────────────────────────────────┐

│                        Frontend Layer                        │- **Auth:** http://localhost:3001/swagger-ui.html

│  Student Portal │ University Portal │ Employer │ Admin      │- **University:** http://localhost:3002/swagger-ui.html

└────────────────────────┬────────────────────────────────────┘- **Certificate:** http://localhost:3003/swagger-ui.html

                         │- **Verification:** http://localhost:3004/swagger-ui.html

┌────────────────────────▼────────────────────────────────────┐

│                      API Gateway                             │## 🧪 Testing with Bruno

└────────────────────────┬────────────────────────────────────┘

                         │1. **Install Bruno:** https://www.usebruno.com/

        ┌────────────────┼────────────────┬─────────────┐2. **Test workflow:**

        │                │                │             │   - Health checks → Create university → Issue certificate → Verify

┌───────▼──────┐ ┌──────▼──────┐ ┌──────▼──────┐ ┌───▼────────┐

│    Auth      │ │ University  │ │Certificate  │ │Verification│## 🤝 Team Members

│   Service    │ │  Service    │ │  Service    │ │  Service   │

└──────┬───────┘ └──────┬──────┘ └──────┬──────┘ └─────┬──────┘- **Sachin T P** – 93102 – [@SachinTP02](https://github.com/SachinTP02)

       │                │                │               │- **Saher Mahtab** – 93103 – [@SaherMahtab](https://github.com/SaherMahtab)

       └────────────────┴────────────────┴───────────────┘- **R Soujanya** – 93039 – [@reddeboinasoujanya09](https://github.com/reddeboinasoujanya09)

                         │- **Sanka Deekshitha** – 93043 – [@deekshitha-77](https://github.com/deekshitha-77)

                ┌────────▼─────────┐- **Anantha Krishnan G** – 93049 – [@spotananthu](https://github.com/spotananthu)

                │   PostgreSQL     │

                │   Databases      │## 📄 License

                └──────────────────┘

```This project is licensed under the [MIT License](./LICENSE).



## Getting Started---



### Prerequisites**Note:** Each service has its own detailed README in their respective directories for service-specific documentation.

- **Node.js** 16+ and npm
- **Java** 17+
- **Maven** 3.8+
- **Docker** and **Docker Compose**
- **PostgreSQL** 14+ (if not using Docker)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/spotananthu/StudentCertificateManagement.git
   cd StudentCertificateManagement
   ```

2. **Set up environment variables**
   ```bash
   cp environment.example .env
   # Edit .env with your configuration
   ```

3. **Using Docker (Recommended)**
   ```bash
   docker-compose up -d
   ```

4. **Manual Setup**
   
   **Backend Services:**
   ```bash
   # Install dependencies
   cd backend/auth-service && mvn clean install
   cd ../university-service && mvn clean install
   cd ../certificate-service && mvn clean install
   cd ../verification-service && mvn clean install
   
   # Start services (in separate terminals)
   cd backend/auth-service && mvn spring-boot:run
   cd backend/university-service && mvn spring-boot:run
   cd backend/certificate-service && mvn spring-boot:run
   cd backend/verification-service && mvn spring-boot:run
   ```
   
   **API Gateway:**
   ```bash
   cd backend/api-gateway
   npm install
   npm run dev
   ```
   
   **Frontend Applications:**
   ```bash
   # Student Portal
   cd frontend/student-portal && npm install && npm start
   
   # University Portal
   cd frontend/university-portal && npm install && npm start
   
   # Employer Portal
   cd frontend/employer-portal && npm install && npm start
   
   # Admin Dashboard
   cd frontend/admin-dashboard && npm install && npm start
   ```

### Access the Application

- **Student Portal**: http://localhost:3001
- **University Portal**: http://localhost:3002
- **Employer Portal**: http://localhost:3003
- **Admin Dashboard**: http://localhost:3004
- **API Gateway**: http://localhost:3000
- **API Documentation**: http://localhost:8080/swagger-ui.html

## Project Structure

```
├── backend/
│   ├── api-gateway/          # API Gateway (Node.js)
│   ├── auth-service/         # Authentication Service
│   ├── university-service/   # University Management
│   ├── certificate-service/  # Certificate Operations
│   ├── verification-service/ # Certificate Verification
│   └── shared/               # Shared utilities
├── frontend/
│   ├── student-portal/       # Student interface
│   ├── university-portal/    # University interface
│   ├── employer-portal/      # Employer interface
│   └── admin-dashboard/      # Admin interface
├── docs/                     # Documentation
│   └── api/                  # API specifications
├── load-tests/               # Performance testing
└── docker-compose.yml        # Container orchestration
```

## API Documentation

Interactive API documentation is available via Swagger UI when the services are running:
- Visit http://localhost:8080/swagger-ui.html
- Or check `docs/api/openapi.yaml` for the complete API specification

## Testing

### Unit Tests
```bash
# Backend services
mvn test

# Frontend applications
npm test
```

### Load Testing
```bash
cd load-tests
npm install -g artillery
artillery run auth-load.yaml
artillery run certificate-load.yaml
```

## Security Features

- JWT-based authentication and authorization
- Role-based access control (RBAC)
- Digital signatures for certificate integrity
- Secure API endpoints with rate limiting
- Input validation and sanitization
- SQL injection prevention
- XSS protection

## Database Schema

The system uses PostgreSQL with separate databases for each microservice:
- `auth_db` - User authentication and authorization
- `university_db` - University and student data
- `certificate_db` - Certificate records and metadata
- `verification_db` - Verification logs and reports

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For issues, questions, or contributions, please open an issue on GitHub.

## Acknowledgments

- Spring Boot community for excellent microservices framework
- React and Material-UI teams for frontend tools
- All open-source contributors whose libraries made this possible

---

**Built using modern web technologies**
