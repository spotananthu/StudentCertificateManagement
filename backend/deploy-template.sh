#!/bin/bash

# ===========================================
# Template Deployment Script for Services
# ===========================================
# Usage: ./deploy-template.sh <service-name> [postgres-name]
# Example: ./deploy-template.sh auth-service auth-postgres
# ===========================================

set -e

# Configuration
SERVICE_NAME=${1:-"unknown-service"}
POSTGRES_NAME=${2:-""}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHARED_CONFIG="${SCRIPT_DIR}/../shared-build-config.sh"

# Load shared configuration
if [ -f "$SHARED_CONFIG" ]; then
    source "$SHARED_CONFIG"
else
    echo "❌ Shared build configuration not found: $SHARED_CONFIG"
    exit 1
fi

echo "🚀 Starting ${SERVICE_NAME} Deployment on Minikube..."

# Setup Minikube Docker environment
setup_minikube_docker

# Build service image
build_service_image "$SERVICE_NAME"

# Deploy postgres first if specified
if [ ! -z "$POSTGRES_NAME" ]; then
    echo "🗄️ Deploying PostgreSQL for ${SERVICE_NAME}..."
    kubectl apply -f k8s/postgres/
    wait_for_deployment "$POSTGRES_NAME" 180
fi

# Deploy the service
echo "📦 Applying ${SERVICE_NAME} Kubernetes manifests..."
kubectl apply -f k8s/

# Restart deployments to ensure latest image is used
echo "🔄 Restarting deployments..."
kubectl rollout restart deployment/${SERVICE_NAME} || true

if [ ! -z "$POSTGRES_NAME" ]; then
    kubectl rollout restart deployment/${POSTGRES_NAME} || true
fi

# Wait for deployments to be ready
if [ ! -z "$POSTGRES_NAME" ]; then
    wait_for_deployment "$POSTGRES_NAME" 180
fi

wait_for_deployment "$SERVICE_NAME" 300

# Display deployment status
check_deployment_status "$SERVICE_NAME"

# Show service URL
get_service_url "$SERVICE_NAME"

echo "🎉 ${SERVICE_NAME} Deployment Completed Successfully!"