#!/bin/bash
set -e

echo "🚀 Starting Certificate-Service Deployment on Minikube..."

echo "👉 Switching Docker to Minikube daemon..."
eval $(minikube -p minikube docker-env)

echo "👉 Building Certificate-Service Docker image..."
export DOCKER_BUILDKIT=1
docker build --cache-from=certificate-service:latest -t certificate-service:1.0.0-dev .

echo "👉 Applying Postgres and Certificate-Service Kubernetes manifests..."
kubectl apply -f k8s/postgres/
kubectl apply -f k8s/

echo "🔄 Restarting deployments..."
kubectl rollout restart deployment/certificate-service || true
kubectl rollout restart deployment/certificate-postgres || true

echo "⏳ Waiting for pods to be ready..."
kubectl wait --for=condition=available --timeout=180s deployment/certificate-postgres
kubectl wait --for=condition=available --timeout=180s deployment/certificate-service

echo "🌍 Opening Certificate-Service URL..."
minikube service certificate-service

echo "🎉 Certificate-Service Deployment Completed Successfully!"
