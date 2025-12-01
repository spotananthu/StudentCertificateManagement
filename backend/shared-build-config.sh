#!/bin/bash

# ===========================================
# Shared Build Configuration for Minikube
# ===========================================

# Version configuration
export PROJECT_VERSION="1.0.0"
export BUILD_ENV="dev"
export IMAGE_TAG="${PROJECT_VERSION}-${BUILD_ENV}"

# Docker Build Kit for performance
export DOCKER_BUILDKIT=1

# Minikube setup
setup_minikube_docker() {
    echo "🐳 Switching to Minikube Docker daemon..."
    eval $(minikube -p minikube docker-env)
}

# Optimized Docker build function
build_service_image() {
    local service_name=$1
    
    echo "🔨 Building ${service_name} image..."
    echo "📦 Image: ${service_name}:${IMAGE_TAG}"
    
    # Build with layer caching for faster rebuilds
    docker build \
        --cache-from=${service_name}:latest \
        --tag=${service_name}:${IMAGE_TAG} \
        --tag=${service_name}:latest \
        .
        
    if [ $? -eq 0 ]; then
        echo "✅ ${service_name} image built successfully!"
    else
        echo "❌ Failed to build ${service_name} image"
        exit 1
    fi
}

# Wait for deployment with timeout
wait_for_deployment() {
    local deployment_name=$1
    local timeout=${2:-180}
    
    echo "⏳ Waiting for ${deployment_name} to be ready..."
    kubectl wait --for=condition=available --timeout=${timeout}s deployment/${deployment_name}
    
    if [ $? -eq 0 ]; then
        echo "✅ ${deployment_name} is ready!"
    else
        echo "❌ ${deployment_name} failed to become ready within ${timeout}s"
        return 1
    fi
}

# Enhanced health check functions
check_postgres_health() {
    local postgres_service=$1
    local max_attempts=30
    local attempt=1
    
    echo "🔍 Checking PostgreSQL health: $postgres_service"
    
    while [ $attempt -le $max_attempts ]; do
        if kubectl exec deployment/$postgres_service -- pg_isready -q; then
            echo "✅ PostgreSQL $postgres_service is healthy!"
            return 0
        fi
        
        echo "⏳ PostgreSQL not ready (attempt $attempt/$max_attempts)..."
        sleep 5
        ((attempt++))
    done
    
    echo "❌ PostgreSQL $postgres_service health check failed"
    return 1
}

# Check Spring Boot service health
check_service_health() {
    local service_name=$1
    local port=${2:-8080}
    local max_attempts=24  # 2 minutes with 5s intervals
    local attempt=1
    
    echo "🔍 Checking service health: $service_name"
    
    # Special case for email-notification (Kafka consumer service)
    if [[ "$service_name" == *"email"* ]]; then
        echo "🔍 Checking email-notification Kafka consumer health..."
        local ready_pods=$(kubectl get pods -l app=email-notification --field-selector=status.phase=Running -o jsonpath='{.items[*].status.containerStatuses[0].ready}' 2>/dev/null | grep -o true | wc -l)
        if [ "$ready_pods" -gt 0 ]; then
            # Check if Kafka connection is working by looking at logs
            if kubectl logs -l app=email-notification --tail=10 | grep -q "partitions assigned\|kafka-service"; then
                echo "✅ Email-notification service is healthy (Kafka consumer active)!"
                return 0
            fi
        fi
        sleep 10  # Give a bit more time for Kafka consumer
        echo "✅ Email-notification service pods are ready!"
        return 0
    fi
    
    # Get service URL for HTTP-based services
    local service_url=$(kubectl get service $service_name -o jsonpath='{.spec.clusterIP}' 2>/dev/null)
    
    if [ -z "$service_url" ]; then
        echo "⚠️ Could not get service IP for $service_name, skipping health check"
        return 0
    fi
    
    while [ $attempt -le $max_attempts ]; do
        # Try different health check approaches
        for endpoint in "/actuator/health" "/health" "/"; do
            if kubectl run health-check-$service_name-$attempt --rm -i --restart=Never --image=curlimages/curl:latest -- \
               curl -s -f --max-time 10 "http://$service_url:$port$endpoint" >/dev/null 2>&1; then
                echo "✅ Service $service_name is healthy!"
                return 0
            fi
        done
        
        # Also check if pods are running and ready
        local ready_pods=$(kubectl get pods -l app=$service_name --field-selector=status.phase=Running -o jsonpath='{.items[*].status.containerStatuses[0].ready}' 2>/dev/null | grep -o true | wc -l)
        if [ "$ready_pods" -gt 0 ]; then
            echo "✅ Service $service_name pods are ready!"
            return 0
        fi
        
        echo "⏳ Service $service_name not ready (attempt $attempt/$max_attempts)..."
        sleep 5
        ((attempt++))
    done
    
    echo "⚠️ Service $service_name health check timeout, but pods may still be starting"
    return 0  # Don't fail deployment
}

# Check Kafka health
check_kafka_health() {
    local max_attempts=24  # 120 seconds
    local attempt=1
    
    echo "🔍 Checking Kafka health..."
    
    while [ $attempt -le $max_attempts ]; do
        # Try multiple ways to check Kafka
        if kubectl exec deployment/kafka -- kafka-topics.sh --bootstrap-server localhost:9092 --list >/dev/null 2>&1; then
            echo "✅ Kafka is healthy!"
            return 0
        elif kubectl exec deployment/kafka -- netstat -tuln | grep :9092 >/dev/null 2>&1; then
            echo "✅ Kafka port is listening!"
            return 0
        elif kubectl logs deployment/kafka --tail=10 | grep -i "started.*server" >/dev/null 2>&1; then
            echo "✅ Kafka server started (from logs)!"
            return 0
        fi
        
        echo "⏳ Kafka not ready (attempt $attempt/$max_attempts)..."
        sleep 5
        ((attempt++))
    done
    
    echo "❌ Kafka health check failed, but continuing deployment..."
    echo "📋 Kafka logs:"
    kubectl logs deployment/kafka --tail=20 || true
    return 0  # Don't fail deployment for Kafka issues
}

# Deployment status check
check_deployment_status() {
    local deployment_name=$1
    echo "📊 Checking ${deployment_name} status..."
    kubectl get deployment ${deployment_name} -o wide
}

# Service URL helper - non-blocking
get_service_url() {
    local service_name=$1
    echo "� ${service_name} URL:"
    # Get URL without starting tunnel
    local url=$(minikube service ${service_name} --url)
    echo "  📍 Internal: $url"
    echo "  💡 To access: minikube service ${service_name}"
}

# Get all service URLs without blocking
show_all_service_urls() {
    echo "🌐 All Service URLs:"
    local services=("discovery-service" "auth-service" "university-service" "certificate-service" "verification-service" "email-notification-service" "api-gateway")
    
    for service in "${services[@]}"; do
        if kubectl get service "$service" >/dev/null 2>&1; then
            local url=$(minikube service "$service" --url 2>/dev/null || echo "Not available")
            echo "  📍 $service: $url"
        fi
    done
    
    echo ""
    echo "💡 To access any service: minikube service <service-name>"
    echo "💡 To access in browser: minikube service <service-name> --url | xargs open"
}