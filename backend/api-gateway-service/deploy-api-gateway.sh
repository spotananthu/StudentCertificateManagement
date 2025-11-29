#!/bin/bash
set -e

echo "🚀 Starting API-Gateway Deployment on Minikube..."

echo "👉 Switching Docker to Minikube daemon..."
eval $(minikube -p minikube docker-env)

echo "👉 Building API-Gateway Docker image..."
docker build -t api-gateway:latest .

echo "👉 Applying API-Gateway Kubernetes manifests..."
kubectl apply -f k8s/

echo "🔄 Restarting deployment..."
kubectl rollout restart deployment/api-gateway || true

echo "⏳ Waiting for pods to be ready..."
kubectl wait --for=condition=available --timeout=180s deployment/api-gateway

echo "🌍 Opening API-Gateway URL..."
minikube service api-gateway

echo "🎉 API-Gateway Deployment Completed Successfully!"
