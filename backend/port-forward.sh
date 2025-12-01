#!/bin/bash

# ===========================================
# Port Forward Helper (Alternative to minikube service)
# ===========================================
# Uses kubectl port-forward instead of minikube service tunnels
# ===========================================

echo "🔌 Port Forward Manager"
echo ""

# Service configurations
declare -A SERVICES
SERVICES["auth-service"]="8081"
SERVICES["university-service"]="3002"
SERVICES["certificate-service"]="3003"
SERVICES["verification-service"]="3004"
SERVICES["discovery-service"]="8761"
SERVICES["api-gateway"]="8080"
SERVICES["email-notification-service"]="8080"

show_active_forwards() {
    echo "📋 Active Port Forwards:"
    ps aux | grep "kubectl.*port-forward" | grep -v grep | while read line; do
        echo "  🔗 $line"
    done
}

start_port_forward() {
    local service_name=$1
    local port=${SERVICES[$service_name]}
    
    if [ -z "$port" ]; then
        echo "❌ Unknown service: $service_name"
        return 1
    fi
    
    echo "🔌 Starting port forward for $service_name on localhost:$port"
    kubectl port-forward service/$service_name $port:$port &
    local pid=$!
    echo "✅ Port forward started (PID: $pid)"
    echo "📍 Access at: http://localhost:$port"
    echo "$pid" > "/tmp/portforward_${service_name}.pid"
}

stop_port_forward() {
    local service_name=$1
    local pid_file="/tmp/portforward_${service_name}.pid"
    
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        kill "$pid" 2>/dev/null
        rm "$pid_file"
        echo "🛑 Stopped port forward for $service_name (PID: $pid)"
    else
        echo "❌ No active port forward found for $service_name"
    fi
}

stop_all_forwards() {
    echo "🛑 Stopping all port forwards..."
    pkill -f "kubectl.*port-forward"
    rm -f /tmp/portforward_*.pid
    echo "✅ All port forwards stopped"
}

case "${1:-menu}" in
    start)
        start_port_forward "$2"
        ;;
    stop)
        stop_port_forward "$2"
        ;;
    stop-all)
        stop_all_forwards
        ;;
    list)
        show_active_forwards
        ;;
    menu|*)
        echo "🎯 Port Forward Options:"
        echo "  ./port-forward.sh start <service-name>  # Start forward"
        echo "  ./port-forward.sh stop <service-name>   # Stop forward"
        echo "  ./port-forward.sh stop-all              # Stop all"
        echo "  ./port-forward.sh list                  # Show active"
        echo ""
        echo "📋 Available services:"
        for service in "${!SERVICES[@]}"; do
            port="${SERVICES[$service]}"
            echo "  - $service (port $port)"
        done
        ;;
esac