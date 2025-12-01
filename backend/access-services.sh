#!/bin/bash

# ===========================================
# Service Access Helper for Minikube
# ===========================================
# Provides easy access to deployed services without blocking terminals
# ===========================================

echo "🌐 StudentCert Backend Services Access"
echo ""

# Check if minikube is running
if ! minikube status >/dev/null 2>&1; then
    echo "❌ Minikube is not running. Start it with: minikube start"
    exit 1
fi

# Available services
SERVICES=(
    "discovery-service:Eureka Dashboard:8761"
    "auth-service:Authentication API:8081"
    "university-service:University API:3002"
    "certificate-service:Certificate API:3003"
    "verification-service:Verification API:3004"
    "email-notification-service:Email API:8080"
    "api-gateway:Main Gateway:8080"
)

echo "📋 Available Services:"
for i in "${!SERVICES[@]}"; do
    IFS=':' read -r service_name description port <<< "${SERVICES[i]}"
    status="❌"
    if kubectl get service "$service_name" >/dev/null 2>&1; then
        if kubectl get deployment "${service_name%%-service}" >/dev/null 2>&1; then
            ready=$(kubectl get deployment "${service_name%%-service}" -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
            if [ "$ready" -gt 0 ]; then
                status="✅"
            fi
        fi
    fi
    echo "  $((i+1)). $status $description ($service_name)"
done

echo ""
echo "🎯 Quick Access Options:"
echo "  a) Get all service URLs"
echo "  b) Access specific service"
echo "  c) Open service in browser"
echo "  d) Start service tunnel (background)"
echo "  q) Quit"

echo ""
read -p "Choose option (a/b/c/d/q): " -n 1 -r
echo ""

case $REPLY in
    a|A)
        echo "🌐 All Service URLs:"
        for service_info in "${SERVICES[@]}"; do
            IFS=':' read -r service_name description port <<< "$service_info"
            if kubectl get service "$service_name" >/dev/null 2>&1; then
                url=$(minikube service "$service_name" --url 2>/dev/null || echo "Not available")
                echo "  📍 $description: $url"
            else
                echo "  ❌ $description: Service not found"
            fi
        done
        ;;
    b|B)
        echo "Select service to access:"
        select service_info in "${SERVICES[@]}"; do
            IFS=':' read -r service_name description port <<< "$service_info"
            echo "🔗 Accessing $description..."
            echo "📍 URL: $(minikube service "$service_name" --url)"
            echo "💡 Opening tunnel (Ctrl+C to stop)..."
            minikube service "$service_name"
            break
        done
        ;;
    c|C)
        echo "Select service to open in browser:"
        select service_info in "${SERVICES[@]}"; do
            IFS=':' read -r service_name description port <<< "$service_info"
            echo "🌍 Opening $description in browser..."
            url=$(minikube service "$service_name" --url)
            open "$url" 2>/dev/null || echo "📍 URL: $url"
            break
        done
        ;;
    d|D)
        echo "Select service for background tunnel:"
        select service_info in "${SERVICES[@]}"; do
            IFS=':' read -r service_name description port <<< "$service_info"
            echo "🔧 Starting background tunnel for $description..."
            
            # Start tunnel in background and save PID
            nohup minikube service "$service_name" > "/tmp/${service_name}_tunnel.log" 2>&1 &
            tunnel_pid=$!
            echo "$tunnel_pid" > "/tmp/${service_name}_tunnel.pid"
            
            echo "✅ Tunnel started for $description (PID: $tunnel_pid)"
            echo "📍 Check log: tail -f /tmp/${service_name}_tunnel.log"
            echo "🛑 To stop: kill $tunnel_pid"
            break
        done
        ;;
    q|Q)
        echo "👋 Goodbye!"
        exit 0
        ;;
    *)
        echo "❌ Invalid option"
        ;;
esac