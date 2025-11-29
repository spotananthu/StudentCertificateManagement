#!/bin/bash
set -e

echo "🚀 Starting Discovery-Server Deployment on Minikube..."

echo "👉 Switching Docker to Minikube daemon..."
eval $(minikube -p minikube docker-env)

echo "🔨 Building Discovery Server image..."
mvn clean package -DskipTests
docker build -t discovery-server:1.0.0 .

echo "⚙️ Deploying ConfigMap..."
kubectl apply -f k8s/discovery-configmap.yaml

echo "💡 Deploying Discovery Server..."
kubectl apply -f k8s/discovery-deployment.yaml
kubectl apply -f k8s/discovery-service.yaml

echo "⏳ Waiting for Discovery Server to be ready..."
kubectl rollout status deployment/discovery-server

echo "✔️ Deployment Complete!"
echo "🌍 To open Eureka dashboard:"
echo "minikube service discovery-service --url"
