# Student Certificate Management System# Student Certificate Management System# Student Certificate Management System



A comprehensive microservices-based platform for managing and verifying student academic certificates with digital signatures.



## OverviewA comprehensive microservices-based platform for managing and verifying student academic certificates with digital signatures.A web application for managing and verifying student certificates. Universities can issue digital certificates, students can access their records, and employers can verify certificate authenticity in real-time.



This system provides a secure and efficient way to issue, manage, and verify student certificates. Built with a modern microservices architecture, it ensures scalability, maintainability, and reliability.



## Features## Overview## 🎯 Overview



### For Students

- Request and download verified certificates

- View certificate history and statusThis system provides a secure and efficient way to issue, manage, and verify student certificates. Built with a modern microservices architecture, it ensures scalability, maintainability, and reliability.This system provides a secure platform for the complete certificate lifecycle - from issuance by universities to verification by employers, eliminating manual verification processes and preventing fraud.

- Track verification requests

- Secure profile management



### For Universities## Features## 🛠 Tech Stack

- Issue digital certificates with secure signatures

- Manage certificate templates

- Track certificate issuance

- Bulk certificate generation### For Students- **Backend:** Java 17+, Spring Boot 3.x, Feign Client, PostgreSQL



### For Employers- Request and download verified certificates- **Frontend:** React 18+, TypeScript

- Quick certificate verification

- Batch verification support- View certificate history and status- **API:** REST (HTTP), Swagger/OpenAPI 3.0

- Detailed verification reports

- Real-time validation- Track verification requests- **Testing:** Bruno



### For Administrators- Secure profile management

- System-wide monitoring and analytics

- User management across all roles## 🏗 Architecture

- Audit logs and compliance tracking

- System configuration### For Universities



## Technology Stack- Issue digital certificates with secure signaturesThe application consists of 4 independent services communicating via HTTP REST APIs:



### Backend- Manage certificate templates```

- **Java 17** with Spring Boot 3.3.x

- **Microservices Architecture**- Track certificate issuanceFrontend (React + TypeScript)

  - API Gateway (Node.js/Express)

  - Authentication Service (Spring Security + JWT)- Bulk certificate generation         │

  - University Service

  - Certificate Service    ┌────┼─────┬────────┬──────────┐

  - Verification Service

- **Database**: PostgreSQL### For Employers    ▼    ▼     ▼        ▼          │

- **Message Queue**: RabbitMQ/Kafka

- **API Documentation**: OpenAPI/Swagger- Quick certificate verification  Auth  Univ  Cert  Verification   │



### Frontend- Batch verification support  3001  3002  3003      3004       │

- **React 18** with TypeScript

- **Material-UI (MUI)** for UI components- Detailed verification reports                    │               │

- **React Router** for navigation

- **Axios** for API communication- Real-time validation              Feign Client          │

- **React Hook Form** with Zod validation

                    │               │

### DevOps

- **Docker** & **Docker Compose** for containerization### For Administrators              ┌─────┴───────────────┘

- **GitHub Actions** for CI/CD

- **Artillery** for load testing- System-wide monitoring and analytics              ▼



## Architecture- User management across all roles          Database



```- Audit logs and compliance tracking```

┌─────────────────────────────────────────────────────────────┐

│                        Frontend Layer                        │- System configuration

│  Student Portal │ University Portal │ Employer │ Admin      │

└────────────────────────┬────────────────────────────────────┘## 🚀 Quick Start

                         │

┌────────────────────────▼────────────────────────────────────┐## Technology Stack

│                      API Gateway                             │

└────────────────────────┬────────────────────────────────────┘### Backend Setup

                         │

        ┌────────────────┼────────────────┬─────────────┐### Backend```bash

        │                │                │             │

┌───────▼──────┐ ┌──────▼──────┐ ┌──────▼──────┐ ┌───▼────────┐- **Java 17** with Spring Boot 3.3.x# Start each service in separate terminals

│    Auth      │ │ University  │ │Certificate  │ │Verification│

│   Service    │ │  Service    │ │  Service    │ │  Service   │- **Microservices Architecture**cd backend/auth-service && ./mvnw spring-boot:run        # Port 3001

└──────┬───────┘ └──────┬──────┘ └──────┬──────┘ └─────┬──────┘

       │                │                │               │  - API Gateway (Node.js/Express)cd backend/university-service && ./mvnw spring-boot:run  # Port 3002

       └────────────────┴────────────────┴───────────────┘

                         │  - Authentication Service (Spring Security + JWT)cd backend/certificate-service && ./mvnw spring-boot:run # Port 3003

                ┌────────▼─────────┐

                │   PostgreSQL     │  - University Servicecd backend/verification-service && ./mvnw spring-boot:run # Port 3004

                │   Databases      │

                └──────────────────┘  - Certificate Service```

```

  - Verification Service

## Getting Started

- **Database**: PostgreSQL### Frontend Setup

### Prerequisites

- **Node.js** 16+ and npm- **Message Queue**: RabbitMQ/Kafka```bash

- **Java** 17+

- **Maven** 3.8+- **API Documentation**: OpenAPI/Swaggercd frontend

- **Docker** and **Docker Compose**

- **PostgreSQL** 14+ (if not using Docker)npm install



### Installation### Frontendnpm start



1. **Clone the repository**- **React 18** with TypeScript```

   ```bash

   git clone https://github.com/spotananthu/StudentCertificateManagement.git- **Material-UI (MUI)** for UI components

   cd StudentCertificateManagement

   ```- **React Router** for navigation## 📚 Services



2. **Set up environment variables**- **Axios** for API communication

   ```bash

   cp environment.example .env- **React Hook Form** with Zod validation| Service | Port | Purpose |

   # Edit .env with your configuration

   ```|---------|------|---------|



3. **Using Docker (Recommended)**### DevOps| Auth Service | 3001 | User authentication & authorization |

   ```bash

   docker-compose up -d- **Docker** & **Docker Compose** for containerization| University Service | 3002 | Manage university profiles |

   ```

- **GitHub Actions** for CI/CD| Certificate Service | 3003 | Issue and manage certificates |

4. **Manual Setup**

   - **Artillery** for load testing| Verification Service | 3004 | Verify certificate authenticity |

   **Backend Services:**

   ```bash

   # Install dependencies

   cd backend/auth-service && mvn clean install## Architecture## API Documentation

   cd ../university-service && mvn clean install

   cd ../certificate-service && mvn clean install

   cd ../verification-service && mvn clean install

   ```Once services are running:

   # Start services (in separate terminals)

   cd backend/auth-service && mvn spring-boot:run┌─────────────────────────────────────────────────────────────┐

   cd backend/university-service && mvn spring-boot:run

   cd backend/certificate-service && mvn spring-boot:run│                        Frontend Layer                        │- **Auth:** http://localhost:3001/swagger-ui.html

   cd backend/verification-service && mvn spring-boot:run

   ```│  Student Portal │ University Portal │ Employer │ Admin      │- **University:** http://localhost:3002/swagger-ui.html

   

   **API Gateway:**└────────────────────────┬────────────────────────────────────┘- **Certificate:** http://localhost:3003/swagger-ui.html

   ```bash

   cd backend/api-gateway                         │- **Verification:** http://localhost:3004/swagger-ui.html

   npm install

   npm run dev┌────────────────────────▼────────────────────────────────────┐

   ```

   │                      API Gateway                             │## 🧪 Testing with Bruno

   **Frontend Applications:**

   ```bash└────────────────────────┬────────────────────────────────────┘

   # Student Portal

   cd frontend/student-portal && npm install && npm start                         │1. **Install Bruno:** https://www.usebruno.com/

   

   # University Portal        ┌────────────────┼────────────────┬─────────────┐2. **Test workflow:**

   cd frontend/university-portal && npm install && npm start

           │                │                │             │   - Health checks → Create university → Issue certificate → Verify

   # Employer Portal

   cd frontend/employer-portal && npm install && npm start┌───────▼──────┐ ┌──────▼──────┐ ┌──────▼──────┐ ┌───▼────────┐

   

   # Admin Dashboard│    Auth      │ │ University  │ │Certificate  │ │Verification│## 🤝 Team Members

   cd frontend/admin-dashboard && npm install && npm start

   ```│   Service    │ │  Service    │ │  Service    │ │  Service   │



### Access the Application└──────┬───────┘ └──────┬──────┘ └──────┬──────┘ └─────┬──────┘- **Sachin T P** – 93102 – [@SachinTP02](https://github.com/SachinTP02)



- **Student Portal**: http://localhost:3001       │                │                │               │- **Saher Mahtab** – 93103 – [@SaherMahtab](https://github.com/SaherMahtab)

- **University Portal**: http://localhost:3002

- **Employer Portal**: http://localhost:3003       └────────────────┴────────────────┴───────────────┘- **R Soujanya** – 93039 – [@reddeboinasoujanya09](https://github.com/reddeboinasoujanya09)

- **Admin Dashboard**: http://localhost:3004

- **API Gateway**: http://localhost:3000                         │- **Sanka Deekshitha** – 93043 – [@deekshitha-77](https://github.com/deekshitha-77)

- **API Documentation**: http://localhost:8080/swagger-ui.html

                ┌────────▼─────────┐- **Anantha Krishnan G** – 93049 – [@spotananthu](https://github.com/spotananthu)

## Project Structure

                │   PostgreSQL     │

```

├── backend/                │   Databases      │## 📄 License

│   ├── api-gateway/          # API Gateway (Node.js)

│   ├── auth-service/         # Authentication Service                └──────────────────┘

│   ├── university-service/   # University Management

│   ├── certificate-service/  # Certificate Operations```This project is licensed under the [MIT License](./LICENSE).

│   ├── verification-service/ # Certificate Verification

│   └── shared/               # Shared utilities

├── frontend/

│   ├── student-portal/       # Student interface## Getting Started---

│   ├── university-portal/    # University interface

│   ├── employer-portal/      # Employer interface

│   └── admin-dashboard/      # Admin interface

├── docs/                     # Documentation### Prerequisites**Note:** Each service has its own detailed README in their respective directories for service-specific documentation.

│   └── api/                  # API specifications

├── load-tests/               # Performance testing- **Node.js** 16+ and npm

└── docker-compose.yml        # Container orchestration- **Java** 17+

```- **Maven** 3.8+

- **Docker** and **Docker Compose**

## API Documentation- **PostgreSQL** 14+ (if not using Docker)



Interactive API documentation is available via Swagger UI when the services are running:### Installation

- Visit http://localhost:8080/swagger-ui.html

- Or check `docs/api/openapi.yaml` for the complete API specification1. **Clone the repository**

   ```bash

## Testing   git clone https://github.com/spotananthu/StudentCertificateManagement.git

   cd StudentCertificateManagement

### Unit Tests   ```

```bash

# Backend services2. **Set up environment variables**

mvn test   ```bash

   cp environment.example .env

# Frontend applications   # Edit .env with your configuration

npm test   ```

```

3. **Using Docker (Recommended)**

### Load Testing   ```bash

```bash   docker-compose up -d

cd load-tests   ```

npm install -g artillery

artillery run auth-load.yaml4. **Manual Setup**

artillery run certificate-load.yaml   

```   **Backend Services:**

   ```bash

## Security Features   # Install dependencies

   cd backend/auth-service && mvn clean install

- JWT-based authentication and authorization   cd ../university-service && mvn clean install

- Role-based access control (RBAC)   cd ../certificate-service && mvn clean install

- Digital signatures for certificate integrity   cd ../verification-service && mvn clean install

- Secure API endpoints with rate limiting   

- Input validation and sanitization   # Start services (in separate terminals)

- SQL injection prevention   cd backend/auth-service && mvn spring-boot:run

- XSS protection   cd backend/university-service && mvn spring-boot:run

   cd backend/certificate-service && mvn spring-boot:run

## Database Schema   cd backend/verification-service && mvn spring-boot:run

   ```

The system uses PostgreSQL with separate databases for each microservice:   

- `auth_db` - User authentication and authorization   **API Gateway:**

- `university_db` - University and student data   ```bash

- `certificate_db` - Certificate records and metadata   cd backend/api-gateway

- `verification_db` - Verification logs and reports   npm install

   npm run dev

## Contributing   ```

   

Contributions are welcome! Please follow these steps:   **Frontend Applications:**

   ```bash

1. Fork the repository   # Student Portal

2. Create a feature branch (`git checkout -b feature/AmazingFeature`)   cd frontend/student-portal && npm install && npm start

3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)   

4. Push to the branch (`git push origin feature/AmazingFeature`)   # University Portal

5. Open a Pull Request   cd frontend/university-portal && npm install && npm start

   

## License   # Employer Portal

   cd frontend/employer-portal && npm install && npm start

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.   

   # Admin Dashboard

## Support   cd frontend/admin-dashboard && npm install && npm start

   ```

For issues, questions, or contributions, please open an issue on GitHub.

### Access the Application

## Acknowledgments

- **Student Portal**: http://localhost:3001

- Spring Boot community for excellent microservices framework- **University Portal**: http://localhost:3002

- React and Material-UI teams for frontend tools- **Employer Portal**: http://localhost:3003

- All open-source contributors whose libraries made this possible- **Admin Dashboard**: http://localhost:3004

- **API Gateway**: http://localhost:3000

---- **API Documentation**: http://localhost:8080/swagger-ui.html



**Built using modern web technologies**## Project Structure


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
