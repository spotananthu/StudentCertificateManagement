#!/bin/bash

# ===========================================
# Backend Services Rollback Script
# ===========================================
# Safely removes all backend deployments
# ===========================================

set -e

echo "🔄 Backend Services Rollback Script"
echo "⚠️  This will remove all backend deployments from Kubernetes"
echo ""

# List current deployments
echo "📋 Current deployments:"
kubectl get deployments --no-headers | awk '{print "  - " $1}'
echo ""

read -p "Are you sure you want to rollback all backend services? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Rollback cancelled."
    exit 0
fi

echo "🚨 Starting rollback process..."

# Services in reverse deployment order (gateway first, infrastructure last)
SERVICES_TO_REMOVE=(
    "api-gateway"
    "email-notification"  
    "verification-service"
    "certificate-service"
    "university-service"
    "auth-service"
    "discovery-server"
    "kafka"
    "zookeeper"
    "certificate-postgres"
    "university-postgres"
    "auth-postgres"
)

# Remove services
for service in "${SERVICES_TO_REMOVE[@]}"; do
    echo "🗑️ Removing $service..."
    
    # Remove deployment
    kubectl delete deployment "$service" --ignore-not-found=true
    
    # Remove service  
    kubectl delete service "$service" --ignore-not-found=true
    kubectl delete service "${service}-service" --ignore-not-found=true
    
    # Remove configmaps
    kubectl delete configmap "${service}-config" --ignore-not-found=true 2>/dev/null || true
    kubectl delete configmap "${service}-configmap" --ignore-not-found=true 2>/dev/null || true
    
    # Remove secrets
    kubectl delete secret "${service}-secret" --ignore-not-found=true 2>/dev/null || true
    
    # Remove PVCs for postgres
    if [[ "$service" == *"postgres"* ]]; then
        kubectl delete pvc "${service}-pvc" --ignore-not-found=true 2>/dev/null || true
    fi
    
    echo "✅ $service removed"
done

# Clean up any remaining resources
echo ""
echo "🧹 Cleaning up remaining resources..."

# Remove any orphaned configmaps/secrets
kubectl delete configmap -l app=auth-service --ignore-not-found=true 2>/dev/null || true
kubectl delete configmap -l app=certificate-service --ignore-not-found=true 2>/dev/null || true
kubectl delete configmap -l app=university-service --ignore-not-found=true 2>/dev/null || true

kubectl delete secret -l app=auth-service --ignore-not-found=true 2>/dev/null || true
kubectl delete secret -l app=certificate-service --ignore-not-found=true 2>/dev/null || true
kubectl delete secret -l app=university-service --ignore-not-found=true 2>/dev/null || true

# Remove any remaining PVCs
kubectl delete pvc -l app=postgres --ignore-not-found=true 2>/dev/null || true

echo ""
echo "📊 Remaining deployments:"
remaining=$(kubectl get deployments --no-headers 2>/dev/null | wc -l)
if [ "$remaining" -eq 0 ]; then
    echo "  ✅ No backend deployments remaining"
else
    kubectl get deployments --no-headers | awk '{print "  - " $1}'
fi

echo ""
echo "🎉 Backend rollback completed successfully!"
echo "💡 You can now run './deploy-all-backend.sh' to redeploy fresh services"