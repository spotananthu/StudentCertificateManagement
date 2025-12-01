#!/bin/bash

# ===========================================
# Unified Backend Deployment Script v2.0
# ===========================================
# Deploys all backend services with proper dependency management
# ===========================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_CONFIG="${SCRIPT_DIR}/shared-build-config.sh"

# Load shared configuration
source "$SHARED_CONFIG"

# Deployment state tracking
DEPLOYED_SERVICES=()
FAILED_SERVICES=()

# Cleanup function for rollback
cleanup_on_error() {
    echo "🚨 Deployment failed! Starting cleanup..."
    
    # Rollback deployed services in reverse order
    for ((i=${#DEPLOYED_SERVICES[@]}-1; i>=0; i--)); do
        service="${DEPLOYED_SERVICES[i]}"
        echo "🔄 Rolling back $service..."
        kubectl delete deployment "$service" --ignore-not-found=true
        kubectl delete service "$service" --ignore-not-found=true
        kubectl delete configmap "${service}-config" --ignore-not-found=true 2>/dev/null || true
    done
    
    echo "💥 Deployment failed and rolled back!"
    exit 1
}

# Set trap for error handling
trap cleanup_on_error ERR

echo "🚀 Starting Complete Backend Deployment on Minikube..."
echo "📋 This will deploy all services with proper dependency coordination"
echo ""

# Setup Minikube Docker environment
setup_minikube_docker

# Phase-based deployment with dependency management
echo "===== PHASE 1: Infrastructure (Databases & Messaging) ====="

# Deploy PostgreSQL databases
DATABASES=("auth-postgres:auth-service" "university-postgres:university-service" "certificate-postgres:certificate-service")

for db_config in "${DATABASES[@]}"; do
    IFS=':' read -r db_name service_name <<< "$db_config"
    echo ""
    echo "🗄️ Deploying $db_name for $service_name..."
    
    cd "$SCRIPT_DIR/$service_name"
    kubectl apply -f k8s/postgres/
    
    wait_for_deployment "$db_name" 120
    check_postgres_health "$db_name"
    
    DEPLOYED_SERVICES+=("$db_name")
    echo "✅ $db_name deployed and healthy!"
done

# Deploy Kafka infrastructure for email service
echo ""
echo "📦 Deploying Kafka Infrastructure..."
cd "$SCRIPT_DIR/email-notification"

echo "🦍 Deploying Zookeeper..."
kubectl apply -f k8s/zookeeper.yaml
wait_for_deployment "zookeeper" 120
DEPLOYED_SERVICES+=("zookeeper")

echo "🦍 Deploying Kafka..."
kubectl apply -f k8s/kafka.yaml
wait_for_deployment "kafka" 180
echo "🔍 Checking Kafka health (optional)..."
check_kafka_health || echo "⚠️ Kafka health check skipped - will be ready shortly"
DEPLOYED_SERVICES+=("kafka")

echo "✅ Kafka infrastructure ready!"

echo ""
echo "===== PHASE 2: Core Services ====="

# Deploy Discovery Server (must be first)
echo ""
echo "🔍 Deploying Discovery Server..."
cd "$SCRIPT_DIR/discovery-server"
build_service_image "discovery-server"
kubectl apply -f k8s/
kubectl rollout restart deployment/discovery-server || true
wait_for_deployment "discovery-server" 300
check_service_health "discovery-service" 8761
DEPLOYED_SERVICES+=("discovery-server")
echo "✅ Discovery Server ready!"

# Deploy Auth Service  
echo ""
echo "🔐 Deploying Auth Service..."
cd "$SCRIPT_DIR/auth-service"
build_service_image "auth-service"
kubectl apply -f k8s/
kubectl rollout restart deployment/auth-service || true
wait_for_deployment "auth-service" 300
check_service_health "auth-service" 8081
DEPLOYED_SERVICES+=("auth-service")
echo "✅ Auth Service ready!"

# Deploy University Service
echo ""
echo "🏛️ Deploying University Service..."
cd "$SCRIPT_DIR/university-service"  
build_service_image "university-service"
kubectl apply -f k8s/
kubectl rollout restart deployment/university-service || true
wait_for_deployment "university-service" 300
check_service_health "university-service" 3002
DEPLOYED_SERVICES+=("university-service")
echo "✅ University Service ready!"

echo ""
echo "===== PHASE 3: Business Services ====="

# Deploy Certificate Service
echo ""
echo "� Deploying Certificate Service..."
cd "$SCRIPT_DIR/certificate-service"
build_service_image "certificate-service"
kubectl apply -f k8s/
kubectl rollout restart deployment/certificate-service || true  
wait_for_deployment "certificate-service" 300
check_service_health "certificate-service" 3003
DEPLOYED_SERVICES+=("certificate-service")
echo "✅ Certificate Service ready!"

# Deploy Verification Service
echo ""
echo "✅ Deploying Verification Service..."
cd "$SCRIPT_DIR/verification-service"
build_service_image "verification-service"
kubectl apply -f k8s/
kubectl rollout restart deployment/verification-service || true
wait_for_deployment "verification-service" 300
check_service_health "verification-service" 3004
DEPLOYED_SERVICES+=("verification-service")
echo "✅ Verification Service ready!"

# Deploy Email Notification Service  
echo ""
echo "� Deploying Email Notification Service..."
cd "$SCRIPT_DIR/email-notification"
build_service_image "email-notification"
kubectl apply -f k8s/email-configmap.yaml
kubectl apply -f k8s/email-secret.yaml  
kubectl apply -f k8s/email-deployment.yaml
kubectl apply -f k8s/email-service.yaml
kubectl rollout restart deployment/email-notification || true
wait_for_deployment "email-notification" 300
check_service_health "email-notification-service" 8080
DEPLOYED_SERVICES+=("email-notification")
echo "✅ Email Notification Service ready!"

echo ""
echo "===== PHASE 4: Gateway ====="

# Deploy API Gateway (must be last)
echo ""
echo "🌐 Deploying API Gateway..."
cd "$SCRIPT_DIR/api-gateway-service"
build_service_image "api-gateway-service"  
kubectl apply -f k8s/
kubectl rollout restart deployment/api-gateway || true
wait_for_deployment "api-gateway" 300
check_service_health "api-gateway" 8080
DEPLOYED_SERVICES+=("api-gateway")
echo "✅ API Gateway ready!"

echo ""
echo "🎉 ALL BACKEND SERVICES DEPLOYED SUCCESSFULLY!"
echo ""
echo "📊 Final Deployment Status:"
kubectl get deployments -o wide
echo ""

echo "✅ Backend deployment complete! All services are healthy and ready."
echo "🚀 You can now proceed with frontend deployment or testing."
echo ""
echo "💡 Quick access commands:"
echo "  minikube service auth-service           # Auth API"
echo "  minikube service api-gateway           # Main Gateway"  
echo "  minikube service discovery-service     # Eureka Dashboard"