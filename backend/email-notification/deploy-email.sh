#!/bin/bash
set -e

echo "🚀 Starting Email-Notification Deployment on Minikube..."

echo "👉 Switching Docker to Minikube daemon..."
eval $(minikube -p minikube docker-env)

echo "🔨 Building Email-Notification Docker image..."
export DOCKER_BUILDKIT=1
docker build --cache-from=email-notification:latest -t email-notification:1.0.0-dev .

echo "📦 Deploying Zookeeper..."
kubectl apply -f k8s/zookeeper.yaml

echo "🦍 Deploying Kafka..."
kubectl apply -f k8s/kafka.yaml

echo "⚙️ Deploying Email-Service ConfigMap..."
kubectl apply -f k8s/email-configmap.yaml

echo "🔐 Deploying Email-Service Secret..."
kubectl apply -f k8s/email-secret.yaml

echo "💌 Deploying Email Notification Service..."
kubectl apply -f k8s/email-deployment.yaml
kubectl apply -f k8s/email-service.yaml

echo "⏳ Waiting for Zookeeper to be ready..."
kubectl rollout status deployment/zookeeper

echo "⏳ Waiting for Kafka to be ready..."
kubectl rollout status deployment/kafka

echo "⏳ Waiting for Email Notification Service to be ready..."
kubectl rollout status deployment/email-notification

echo "✔️ Deployment Complete!"

echo "🌐 To access the Email Notification API run:"
echo "minikube service email-notification-service --url"
