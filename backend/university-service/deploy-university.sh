#!/bin/bash
set -e

echo "🚀 Starting University-Service Deployment on Minikube..."

echo "👉 Switching Docker to Minikube daemon..."
eval $(minikube -p minikube docker-env)

echo "👉 Building University-Service Docker image..."
docker build -t university-service:latest .

echo "👉 Applying Kubernetes manifests..."
kubectl apply -f k8s/postgres/
kubectl apply -f k8s/university-service/

echo "⏳ Waiting for Postgres to be ready..."
kubectl rollout status deployment/postgres --timeout=180s

echo "⏳ Waiting for University-Service to be ready..."
kubectl rollout status deployment/university-service --timeout=300s

echo "🌍 Opening University-Service URL..."
minikube service university-service

echo "🎉 University-Service Deployment Completed Successfully!"
