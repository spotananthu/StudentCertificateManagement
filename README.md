# Student Certificate Management System

A comprehensive microservices-based platform for managing and verifying student academic certificates.

## Overview

This system provides a secure platform for the complete certificate lifecycle - from issuance by universities to verification by employers, eliminating manual verification processes and preventing fraud.


## Quick Start

### Prerequisites
- Node.js 16+ and npm
- Java 17+
- Maven 3.8+
- Docker and **Docker Compose**
- PostgreSQL 14+ (if not using Docker)
- Minikube and **kubectl** (for Kubernetes deployment)

  - **Step 1: Start Minikube and Configure Docker Environment**
   
   First, start your local Kubernetes cluster using Minikube and configure your local Docker CLI to build images directly into the Minikube Docker daemon. This step is crucial for Minikube to find your locally built images.

   ```bash
   # Navigate to the project directory

   # Start the Minikube cluster (if not already running)
   minikube start

   # Point your local Docker CLI to the Minikube daemon
   # This makes 'docker build' save images directly inside Minikube's environment
   eval $(minikube docker-env)
   ```

  -  **Step 2: Build Docker Images**
   
   Use the configured Docker environment to build the container images for each of your microservices. The `:latest` tag is used for simplicity in local development, and the images are immediately available to your Minikube cluster because of the previous docker-env step.

   ```bash
   # Build all backend services
   docker build -t auth-service:latest ./backend/auth-service
   docker build -t university-service:latest ./backend/university-service
   docker build -t certificate-service:latest ./backend/certificate-service
   docker build -t verification-service:latest ./backend/verification-service
   docker build -t email-service:latest ./backend/email-notification
   docker build -t discovery-server:latest ./backend/discovery-server
   ```

   **Step 3: Enable Ingress and Deploy to Kubernetes**
   
   Ingress is required to expose your services externally, allowing you to access them via URLs using hostnames (e.g., auth.studentcertificates.local).

   ```bash
   # Enable the Ingress controller addon in Minikube
   minikube addons enable ingress

   # Apply all Kubernetes manifests (Deployments, Services, Ingress, etc.)
   # located in your './k8s' directory
   kubectl apply -f ./k8s
   ```

   **Step 4: Expose Services with Minikube Tunnel**
   
   The `minikube tunnel` command is essential for making the ClusterIP Services and Ingress routes accessible from your host machine (your laptop).

   > ⚠️ **Note on minikube tunnel**: This command requires root privileges because it modifies your host's networking routing table. It must be run in a separate, persistent terminal window and will require your system password. Keep this window open as long as you are using the cluster.

   ```bash
   # Run this command in a NEW, separate terminal window
   sudo minikube tunnel
   ```


## Team Members

- **Anantha Krishnan G** – 93049 – [@spotananthu](https://github.com/spotananthu)
- **Sachin T P** – 93102 – [@SachinTP02](https://github.com/SachinTP02)
- **Saher Mahtab** – 93103 – [@SaherMahtab](https://github.com/SaherMahtab)
- **R Soujanya** – 93039 – [@reddeboinasoujanya09](https://github.com/reddeboinasoujanya09)
- **Sanka Deekshitha** – 93043 – [@deekshitha-77](https://github.com/deekshitha-77)

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the [MIT License](./LICENSE).

## Support

For issues, questions, or contributions, please open an issue on GitHub.
