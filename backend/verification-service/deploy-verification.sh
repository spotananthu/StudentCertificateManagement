#!/bin/bash
set -e

echo "🚀 Starting Verification-Service Deployment on Minikube..."

echo "👉 Switching Docker to Minikube daemon..."
eval $(minikube -p minikube docker-env)

echo "👉 Building Verification-Service Docker image..."
export DOCKER_BUILDKIT=1
docker build --cache-from=verification-service:latest -t verification-service:1.0.0-dev .

echo "👉 Applying Kubernetes manifests..."
kubectl apply -f k8s/

echo "⏳ Waiting for Verification-Service to be ready..."
kubectl rollout status deployment/verification-deployment --timeout=300s

echo "🌍 Opening Verification-Service URL..."
minikube service verification-service

echo "🎉 Verification-Service Deployment Completed Successfully!"
