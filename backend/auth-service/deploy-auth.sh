#!/bin/bash
set -e

echo "🚀 Starting Auth-Service Deployment on Minikube..."

echo "👉 Switching Docker to Minikube daemon..."
eval $(minikube -p minikube docker-env)

echo "👉 Building Auth-Service Docker image..."
export DOCKER_BUILDKIT=1
docker build --cache-from=auth-service:latest -t auth-service:1.0.0-dev .

echo "👉 Applying Postgres and Auth-Service Kubernetes manifests..."
kubectl apply -f k8s/postgres/
kubectl apply -f k8s/

echo "🔄 Restarting deployments..."
kubectl rollout restart deployment/auth-service || true
kubectl rollout restart deployment/auth-postgres || true

echo "⏳ Waiting for pods to be ready..."
kubectl wait --for=condition=available --timeout=180s deployment/auth-postgres
kubectl wait --for=condition=available --timeout=180s deployment/auth-service

echo "� Auth-Service is ready!"
echo "📍 URL: $(minikube service auth-service --url)"
echo "💡 To access: minikube service auth-service"

echo "🎉 Auth-Service Deployment Completed Successfully!"
